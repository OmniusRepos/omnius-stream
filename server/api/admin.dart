import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:duxt/server.dart';
import 'package:shelf/shelf.dart' show Response;
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/models/licens.dart';
import 'package:omnius_stream/models/deployment.dart';
import 'package:omnius_stream/models/order.dart';

// In-memory session store (single admin, so one token is sufficient)
String? _activeSessionToken;

String _generateToken() {
  final random = Random.secure();
  final bytes = List<int>.generate(32, (_) => random.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

String? _getSessionCookie(Map<String, String> headers) {
  final cookieHeader = headers['cookie'] ?? '';
  for (final part in cookieHeader.split(';')) {
    final trimmed = part.trim();
    if (trimmed.startsWith('admin_session=')) {
      return trimmed.substring('admin_session='.length);
    }
  }
  return null;
}

/// Check admin auth via HttpOnly cookie (browser) or x-admin-secret header (server-to-server)
bool _isAdmin(Map<String, String> headers) {
  final secret = Platform.environment['ADMIN_SECRET'] ?? '';
  if (secret.isEmpty) return false;

  // 1. Check HttpOnly session cookie (browser)
  final sessionToken = _getSessionCookie(headers);
  if (sessionToken != null &&
      sessionToken.isNotEmpty &&
      _activeSessionToken != null &&
      sessionToken == _activeSessionToken) {
    return true;
  }

  // 2. Check x-admin-secret header (server-to-server proxy)
  if (headers['x-admin-secret'] == secret) {
    return true;
  }

  return false;
}

void registerAdminRoutes(DuxtServer server) {
  final users = Model<User>();
  final licenses = Model<Licens>();
  final deployments = Model<Deployment>();
  final orders = Model<Order>();

  // POST /api/admin/login — validate secret, set HttpOnly session cookie
  server.post('/api/admin/login', (req) async {
    final body = req.body as Map<String, dynamic>?;
    final secret = (body?['secret'] as String?)?.trim() ?? '';
    final adminSecret = Platform.environment['ADMIN_SECRET'] ?? '';

    if (adminSecret.isEmpty || secret != adminSecret) {
      return json({'error': 'Invalid admin secret'}, statusCode: 401);
    }

    // Create session token
    final token = _generateToken();
    _activeSessionToken = token;

    return Response(
      200,
      body: '{"ok":true}',
      headers: {
        'Content-Type': 'application/json',
        'Set-Cookie':
            'admin_session=$token; HttpOnly; Secure; SameSite=Strict; Path=/api/admin; Max-Age=86400',
      },
    );
  });

  // POST /api/admin/logout — clear session cookie
  server.post('/api/admin/logout', (req) async {
    _activeSessionToken = null;
    return Response(
      200,
      body: '{"ok":true}',
      headers: {
        'Content-Type': 'application/json',
        'Set-Cookie':
            'admin_session=; HttpOnly; Secure; SameSite=Strict; Path=/api/admin; Max-Age=0',
      },
    );
  });

  // GET /api/admin/stats
  server.get('/api/admin/stats', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final totalUsers = await users.count();
    final totalLicenses = await licenses.count();
    final activeLicenses = await licenses.where('is_active', 1).get();
    final activeDeployments = await deployments.where('is_active', 1).get();

    return json({
      'total_users': totalUsers,
      'total_licenses': totalLicenses,
      'active_licenses': activeLicenses.length,
      'active_deployments': activeDeployments.length,
    });
  });

  // GET /api/admin/users
  server.get('/api/admin/users', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final allUsers = await users.all();
    final allLicenses = await licenses.all();

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

    final allLicenses = await licenses.all();
    final allUsers = await users.all();
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

    final allOrders = await orders.all();
    final allUsers = await users.all();
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

    // Enterprise gets OMNI-LIVE key with live_channels feature
    final isEnterprise = plan == 'enterprise';
    final licenseKey = isEnterprise ? Licens.generateLiveKey() : Licens.generateKey();
    final licenseFeatures = Licens.planFeatures(plan).join(',');

    final license = Licens(
      license_key: licenseKey,
      user_id: userId,
      plan: plan,
      max_deployments: maxDeployments,
      is_active: true,
      notes: notes,
      features: licenseFeatures.isNotEmpty ? licenseFeatures : null,
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
      results = await deployments.all();
    }

    return json({
      'deployments': results.map((d) => d.toJson()).toList(),
    });
  });

  // GET /api/admin/users/detail?id=X — get a user with their licenses and orders
  server.get('/api/admin/users/detail', (req) async {
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

    final user = await users.find(id);
    if (user == null) {
      return json({'error': 'User not found'}, statusCode: 404);
    }

    final userLicenses = await licenses.where('user_id', id).get();
    final userOrders = await orders.where('user_id', id).get();

    // For each license, get deployments
    final licensesWithDeployments = <Map<String, dynamic>>[];
    for (final lic in userLicenses) {
      final licJson = lic.toJson();
      final licDeployments =
          await deployments.where('license_id', lic.id).get();
      licJson['deployments'] =
          licDeployments.map((d) => d.toJson()).toList();
      licensesWithDeployments.add(licJson);
    }

    return json({
      'user': user.toJson(),
      'licenses': licensesWithDeployments,
      'orders': userOrders.map((o) => o.toJson()).toList(),
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

  // ─── Polar API Proxy Endpoints (real-time data from Polar) ───

  /// Helper to make authenticated requests to Polar API
  Future<Map<String, dynamic>?> _polarApiFetch(String path, {Map<String, String>? queryParams}) async {
    final accessToken = Platform.environment['POLAR_ACCESS_TOKEN'] ?? '';
    if (accessToken.isEmpty) return null;

    final uri = Uri.https('api.polar.sh', '/v1$path', queryParams);
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      request.headers.set('Authorization', 'Bearer $accessToken');
      request.headers.set('Accept', 'application/json');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      print('[Admin] Polar API error: $e');
      return null;
    } finally {
      client.close();
    }
  }

  // GET /api/admin/polar/orders — fetch real-time orders from Polar API
  server.get('/api/admin/polar/orders', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final page = req.query('page') ?? '1';
    final limit = req.query('limit') ?? '50';
    final sorting = req.query('sorting') ?? '-created_at';

    final result = await _polarApiFetch('/orders/', queryParams: {
      'page': page,
      'limit': limit,
      'sorting': sorting,
    });

    if (result == null) {
      return json({'error': 'Polar API not configured or unreachable'}, statusCode: 503);
    }

    return json(result);
  });

  // GET /api/admin/polar/customers — fetch real-time customers from Polar API
  server.get('/api/admin/polar/customers', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final page = req.query('page') ?? '1';
    final limit = req.query('limit') ?? '50';
    final sorting = req.query('sorting') ?? '-created_at';
    final query = req.query('query') ?? '';

    final params = {
      'page': page,
      'limit': limit,
      'sorting': sorting,
    };
    if (query.isNotEmpty) params['query'] = query;

    final result = await _polarApiFetch('/customers/', queryParams: params);

    if (result == null) {
      return json({'error': 'Polar API not configured or unreachable'}, statusCode: 503);
    }

    return json(result);
  });

  // GET /api/admin/polar/order?id=X — fetch single order detail from Polar API
  server.get('/api/admin/polar/order', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final orderId = req.query('id') ?? '';
    if (orderId.isEmpty) {
      return json({'error': 'Order ID required'}, statusCode: 400);
    }

    final result = await _polarApiFetch('/orders/$orderId');

    if (result == null) {
      return json({'error': 'Polar API not configured or unreachable'}, statusCode: 503);
    }

    return json(result);
  });

  // POST /api/admin/polar/sync — sync a Polar order to local DB (create user + license + order)
  //   Body: { "order_id": "polar-order-uuid" }
  server.post('/api/admin/polar/sync', (req) async {
    if (!_isAdmin(req.headers)) {
      return json({'error': 'Unauthorized'}, statusCode: 401);
    }

    final body = req.body as Map<String, dynamic>?;
    final orderId = (body?['order_id'] as String?)?.trim() ?? '';
    if (orderId.isEmpty) {
      return json({'error': 'order_id is required'}, statusCode: 400);
    }

    // Check if already synced
    final existingLicenses = await licenses.where('transaction_id', orderId).get();
    if (existingLicenses.isNotEmpty) {
      return json({
        'status': 'already_synced',
        'license_key': existingLicenses.first.license_key,
      });
    }

    // Fetch order from Polar API
    final orderData = await _polarApiFetch('/orders/$orderId');
    if (orderData == null) {
      return json({'error': 'Failed to fetch order from Polar'}, statusCode: 503);
    }

    // Extract customer info
    final customer = orderData['customer'] as Map<String, dynamic>?;
    final email = (customer?['email'] as String?)?.trim().toLowerCase() ?? '';
    final customerName = customer?['name'] as String? ?? email.split('@').first;

    if (email.isEmpty) {
      return json({'error': 'Order has no customer email'}, statusCode: 400);
    }

    // Determine plan from product
    final product = orderData['product'] as Map<String, dynamic>?;
    final productId = product?['id'] as String? ?? '';

    final personalProductId = Platform.environment['POLAR_PERSONAL_PRODUCT_ID'] ?? '';
    final businessProductId = Platform.environment['POLAR_BUSINESS_PRODUCT_ID'] ?? '';
    final enterpriseProductId = Platform.environment['POLAR_ENTERPRISE_PRODUCT_ID'] ?? '';

    String plan = 'personal';
    int maxDeployments = 1;

    if (productId == enterpriseProductId) {
      plan = 'enterprise';
      maxDeployments = 999;
    } else if (productId == businessProductId) {
      plan = 'business';
      maxDeployments = 5;
    } else if (productId == personalProductId) {
      plan = 'personal';
      maxDeployments = 1;
    }

    // Extract amount (Polar uses total_amount, not amount)
    final amountRaw = orderData['total_amount'] as int? ?? orderData['amount'] as int? ?? 0;
    final amount = (amountRaw / 100).toStringAsFixed(2);
    final currency = (orderData['currency'] as String? ?? 'usd').toUpperCase();

    // Find or create user
    User user;
    final existingUsers = await users.where('email', email).get();
    if (existingUsers.isNotEmpty) {
      user = existingUsers.first;
    } else {
      user = User(
        email: email,
        name: customerName,
        password_hash: User.hashPassword(orderId),
        is_active: true,
      );
      await user.save();
    }

    // Check if user already has a license without a transaction_id — update it
    // instead of creating a duplicate
    final userLicenses = await licenses.where('user_id', user.id).get();
    final unlinked = userLicenses.where((l) =>
        l.transaction_id == null || l.transaction_id!.isEmpty).toList();

    Licens license;
    String licenseKey;

    final syncFeatures = Licens.planFeatures(plan).join(',');

    if (unlinked.isNotEmpty) {
      // Update existing unlinked license
      license = unlinked.first;
      license.plan = plan;
      license.max_deployments = maxDeployments;
      license.is_active = true;
      license.transaction_id = orderId;
      license.features = syncFeatures.isNotEmpty ? syncFeatures : null;
      await license.save();
      licenseKey = license.license_key ?? '';
    } else {
      // Create new license — enterprise gets OMNI-LIVE key
      licenseKey = plan == 'enterprise' ? Licens.generateLiveKey() : Licens.generateKey();
      license = Licens(
        license_key: licenseKey,
        user_id: user.id as int,
        plan: plan,
        max_deployments: maxDeployments,
        is_active: true,
        transaction_id: orderId,
        features: syncFeatures.isNotEmpty ? syncFeatures : null,
      );
      await license.save();
    }

    // Create order record
    final order = Order(
      user_id: user.id as int,
      license_id: license.id as int,
      transaction_id: orderId,
      amount: amount,
      currency: currency,
      status: 'completed',
    );
    await order.save();

    return json({
      'status': 'synced',
      'license_key': licenseKey,
      'plan': plan,
      'email': email,
    }, statusCode: 201);
  });
}
