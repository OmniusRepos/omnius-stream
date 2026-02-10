import 'dart:io';
import 'package:duxt/server.dart';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/models/licens.dart';
import 'package:omnius_stream/models/deployment.dart';
import 'package:omnius_stream/models/order.dart';

bool _isAdmin(Map<String, String> headers) {
  final secret = Platform.environment['ADMIN_SECRET'] ?? '';
  if (secret.isEmpty) return false;
  return headers['x-admin-secret'] == secret;
}

void registerAdminRoutes(DuxtServer server) {
  final users = Model<User>();
  final licenses = Model<Licens>();
  final deployments = Model<Deployment>();
  final orders = Model<Order>();

  // GET /api/admin/stats
  server.get('/api/admin/stats', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final allUsers = await users.get();
    final allLicenses = await licenses.get();
    final activeLicenses = await licenses.where('is_active', 1).get();
    final activeDeployments = await deployments.where('is_active', 1).get();

    return json({
      'total_users': allUsers.length,
      'total_licenses': allLicenses.length,
      'active_licenses': activeLicenses.length,
      'active_deployments': activeDeployments.length,
    });
  });

  // GET /api/admin/users
  server.get('/api/admin/users', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final allUsers = await users.get();
    final allLicenses = await licenses.get();

    final usersWithCounts = allUsers.map((user) {
      final licenseCount =
          allLicenses.where((l) => l.user_id == user.id).length;
      final userJson = user.toJson();
      userJson['license_count'] = licenseCount;
      return userJson;
    }).toList();

    return json({'users': usersWithCounts});
  });

  // GET /api/admin/licenses — all licenses enriched with user email
  server.get('/api/admin/licenses', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final allLicenses = await licenses.get();
    final allUsers = await users.get();
    final userMap = {for (var u in allUsers) u.id: u};

    final enriched = allLicenses.map((l) {
      final j = l.toJson();
      final user = userMap[l.user_id];
      j['user_email'] = user?.email ?? '';
      j['user_name'] = user?.name ?? '';
      return j;
    }).toList();

    return json({'licenses': enriched});
  });

  // GET /api/admin/orders — all orders enriched with user email
  server.get('/api/admin/orders', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final allOrders = await orders.get();
    final allUsers = await users.get();
    final userMap = {for (var u in allUsers) u.id: u};

    final enriched = allOrders.map((o) {
      final j = o.toJson();
      final user = userMap[o.user_id];
      j['user_email'] = user?.email ?? '';
      return j;
    }).toList();

    return json({'orders': enriched});
  });

  // POST /api/admin/licenses — create a license
  //   Body: {plan, max_deployments, notes?, expires_at?, user_email?}
  server.post('/api/admin/licenses', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final body = req.body as Map<String, dynamic>?;
    if (body == null) {
      return json({'error': 'Body required'}, statusCode: 400);
    }

    final plan = (body['plan'] as String?)?.trim();
    final maxDeployments = body['max_deployments'] as int?;
    final notes = (body['notes'] as String?)?.trim();
    final expiresAt = (body['expires_at'] as String?)?.trim();
    final userEmail = (body['user_email'] as String?)?.trim().toLowerCase();

    if (plan == null || plan.isEmpty) {
      return json({'error': 'plan is required'}, statusCode: 400);
    }
    if (maxDeployments == null) {
      return json({'error': 'max_deployments is required'}, statusCode: 400);
    }

    int? userId;

    // If user_email provided, find or create user and link
    if (userEmail != null && userEmail.isNotEmpty) {
      final existingUsers = await users.where('email', userEmail).get();
      if (existingUsers.isNotEmpty) {
        userId = existingUsers.first.id as int;
      } else {
        // Create a new user with a random password hash
        final newUser = User(
          email: userEmail,
          name: userEmail.split('@').first,
          password_hash: User.hashPassword(DateTime.now().toIso8601String()),
          is_active: true,
        );
        await newUser.save();
        userId = newUser.id as int;
      }
    }

    final license = Licens(
      license_key: Licens.generateKey(),
      user_id: userId,
      plan: plan,
      max_deployments: maxDeployments,
      is_active: true,
      notes: notes,
      expires_at: expiresAt,
    );
    await license.save();

    return json({'license': license.toJson()}, statusCode: 201);
  });

  // PUT /api/admin/licenses?id=X — update a license
  //   Body: {plan?, max_deployments?, is_active?, notes?, expires_at?}
  server.put('/api/admin/licenses', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final idParam = req.query('id');
    if (idParam == null || idParam.isEmpty) {
      return json({'error': 'id query parameter is required'}, statusCode: 400);
    }

    final id = int.tryParse(idParam);
    if (id == null) {
      return json({'error': 'Invalid id'}, statusCode: 400);
    }

    final license = await licenses.find(id);
    if (license == null) {
      return json({'error': 'License not found'}, statusCode: 404);
    }

    final body = req.body as Map<String, dynamic>?;
    if (body == null) {
      return json({'error': 'Body required'}, statusCode: 400);
    }

    if (body.containsKey('plan')) {
      license.plan = (body['plan'] as String?)?.trim();
    }
    if (body.containsKey('max_deployments')) {
      license.max_deployments = body['max_deployments'] as int?;
    }
    if (body.containsKey('is_active')) {
      license.is_active = body['is_active'] as bool?;
    }
    if (body.containsKey('notes')) {
      license.notes = (body['notes'] as String?)?.trim();
    }
    if (body.containsKey('expires_at')) {
      license.expires_at = (body['expires_at'] as String?)?.trim();
    }

    await license.save();

    return json({'license': license.toJson()});
  });

  // GET /api/admin/deployments — list deployments, optionally filtered by ?license_id=X
  server.get('/api/admin/deployments', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final licenseIdParam = req.query('license_id');

    List<Deployment> results;
    if (licenseIdParam != null && licenseIdParam.isNotEmpty) {
      final licenseId = int.tryParse(licenseIdParam);
      if (licenseId == null) {
        return json({'error': 'Invalid license_id'}, statusCode: 400);
      }
      results = await deployments.where('license_id', licenseId).get();
    } else {
      results = await deployments.get();
    }

    return json({
      'deployments': results.map((d) => d.toJson()).toList(),
    });
  });

  // DELETE /api/admin/deployments?id=X — deactivate a deployment (set is_active=false)
  server.delete('/api/admin/deployments', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final idParam = req.query('id');
    if (idParam == null || idParam.isEmpty) {
      return json({'error': 'id query parameter is required'}, statusCode: 400);
    }

    final id = int.tryParse(idParam);
    if (id == null) {
      return json({'error': 'Invalid id'}, statusCode: 400);
    }

    final deployment = await deployments.find(id);
    if (deployment == null) {
      return json({'error': 'Deployment not found'}, statusCode: 404);
    }

    deployment.is_active = false;
    await deployment.save();

    return json({
      'message': 'Deployment deactivated',
      'deployment': deployment.toJson(),
    });
  });
}
