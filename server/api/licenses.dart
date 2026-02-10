import 'package:duxt/server.dart';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/models/licens.dart';
import 'package:omnius_stream/models/deployment.dart';

void registerLicensRoutes(DuxtServer server) {
  final users = Model<User>();
  final licenses = Model<Licens>();
  final deployments = Model<Deployment>();

  // Helper: build the LicenseResponse the Go client expects
  Map<String, dynamic> _licenseResponse({
    required bool valid,
    String plan = '',
    String status = '',
    String message = '',
    int maxDeployments = 0,
    int graceDays = 30,
    String? expiresAt,
  }) =>
      {
        'valid': valid,
        'plan': plan,
        'status': status,
        'message': message,
        'max_deployments': maxDeployments,
        'grace_days': graceDays,
        'expires_at': expiresAt ?? '',
      };

  // GET /api/licenses/lookup?email=xxx or ?checkout_id=xxx
  // Public endpoint for success page polling
  server.get('/api/licenses/lookup', (req) async {
    final email = (req.query('email') ?? '').trim().toLowerCase();
    final checkoutId = (req.query('checkout_id') ?? '').trim();

    if (email.isEmpty && checkoutId.isEmpty) {
      return json({'error': 'Email or checkout_id parameter required'},
          statusCode: 400);
    }

    List<Licens> matchedLicenses = [];

    if (checkoutId.isNotEmpty) {
      // Lookup by Polar checkout ID
      matchedLicenses =
          await licenses.where('checkout_id', checkoutId).where('is_active', 1).get();
      // Fallback: try transaction_id (order ID) in case checkout_id wasn't stored
      if (matchedLicenses.isEmpty) {
        matchedLicenses =
            await licenses.where('transaction_id', checkoutId).where('is_active', 1).get();
      }
    } else {
      // Lookup by email → find user → find license
      final matchedUsers = await users.where('email', email).get();
      if (matchedUsers.isEmpty) {
        return json({'license': null});
      }
      final user = matchedUsers.first;
      matchedLicenses =
          await licenses.where('user_id', user.id).where('is_active', 1).get();
    }

    if (matchedLicenses.isEmpty) {
      return json({'license': null});
    }

    // Return the most recently created license
    final latest = matchedLicenses.last;
    return json({
      'license': {
        'license_key': latest.license_key,
        'plan': latest.plan,
        'max_deployments': latest.max_deployments,
        'is_active': latest.is_active,
        'createdAt': latest.createdAt?.toIso8601String(),
      },
    });
  });

  // GET /api/licenses/validate?key=xxx — for omnius-server to validate licenses
  server.get('/api/licenses/validate', (req) async {
    final key = (req.query('key') ?? '').trim();
    if (key.isEmpty) {
      return json({'valid': false, 'error': 'License key required'},
          statusCode: 400);
    }

    final matchedLicenses = await licenses.where('license_key', key).get();
    if (matchedLicenses.isEmpty) {
      return json({'valid': false, 'error': 'License not found'},
          statusCode: 404);
    }

    final license = matchedLicenses.first;
    return json({
      'valid': license.is_active == true,
      'plan': license.plan,
      'max_deployments': license.max_deployments,
    });
  });

  // ─── Go-compatible license endpoints (used by omnius-server LicenseClient) ───

  // POST /api/v2/license/activate
  // Called by Go servers on startup to register a deployment
  server.post('/api/v2/license/activate', (req) async {
    final body = req.body as Map<String, dynamic>?;
    if (body == null) {
      return json(
          _licenseResponse(
              valid: false, status: 'invalid', message: 'Empty request body'),
          statusCode: 400);
    }

    final licenseKey = (body['license_key'] as String?)?.trim() ?? '';
    final fingerprint = (body['machine_fingerprint'] as String?)?.trim() ?? '';
    final machineLabel = (body['machine_label'] as String?)?.trim() ?? '';
    final serverVersion = (body['server_version'] as String?)?.trim() ?? '';
    final domain = (body['domain'] as String?)?.trim() ?? '';

    if (licenseKey.isEmpty) {
      return json(
          _licenseResponse(
              valid: false,
              status: 'invalid',
              message: 'License key required'),
          statusCode: 400);
    }

    // Look up license
    final matchedLicenses =
        await licenses.where('license_key', licenseKey).get();
    if (matchedLicenses.isEmpty) {
      return json(
          _licenseResponse(
              valid: false,
              status: 'invalid',
              message: 'License key not found'),
          statusCode: 404);
    }

    final license = matchedLicenses.first;

    // Check if license is active
    if (license.is_active != true) {
      return json(_licenseResponse(
        valid: false,
        status: 'revoked',
        message: 'License has been revoked',
      ));
    }

    // Check expiry
    if (license.expires_at != null && license.expires_at!.isNotEmpty) {
      final expiry = DateTime.tryParse(license.expires_at!);
      if (expiry != null && DateTime.now().isAfter(expiry)) {
        return json(_licenseResponse(
          valid: false,
          status: 'expired',
          message: 'License has expired',
          expiresAt: license.expires_at,
        ));
      }
    }

    // Get client IP from X-Forwarded-For or fallback
    final ipAddress = req.headers['x-forwarded-for']?.split(',').first.trim() ??
        req.headers['x-real-ip'] ??
        '';

    if (fingerprint.isNotEmpty) {
      // Check existing deployments for this license
      final existingDeployments = await deployments
          .where('license_id', license.id)
          .where('is_active', 1)
          .get();

      // Check if this machine already has an active deployment
      final existingForMachine = existingDeployments
          .where((d) => d.machine_fingerprint == fingerprint)
          .toList();

      if (existingForMachine.isNotEmpty) {
        // Update existing deployment
        final dep = existingForMachine.first;
        dep.machine_label = machineLabel;
        dep.server_version = serverVersion;
        dep.ip_address = ipAddress;
        if (domain.isNotEmpty) dep.domain = domain;
        dep.last_seen_at = DateTime.now();
        dep.is_active = true;
        await dep.save();
      } else {
        // Check max deployments limit
        final maxDep = license.max_deployments ?? 1;
        if (existingDeployments.length >= maxDep) {
          return json(_licenseResponse(
            valid: false,
            status: 'over_limit',
            message:
                'Maximum deployments reached ($maxDep). Deactivate an existing deployment first.',
            plan: license.plan ?? '',
            maxDeployments: maxDep,
          ));
        }

        // Create new deployment
        final dep = Deployment(
          license_id: license.id as int,
          machine_fingerprint: fingerprint,
          machine_label: machineLabel,
          server_version: serverVersion,
          ip_address: ipAddress,
          domain: domain.isNotEmpty ? domain : null,
          is_active: true,
          last_seen_at: DateTime.now(),
        );
        await dep.save();
      }
    }

    return json(_licenseResponse(
      valid: true,
      plan: license.plan ?? 'personal',
      status: 'active',
      message: 'License activated',
      maxDeployments: license.max_deployments ?? 1,
      graceDays: 30,
      expiresAt: license.expires_at,
    ));
  });

  // POST /api/v2/license/heartbeat
  // Called periodically by Go servers to confirm they're alive
  server.post('/api/v2/license/heartbeat', (req) async {
    final body = req.body as Map<String, dynamic>?;
    if (body == null) {
      return json(
          _licenseResponse(
              valid: false, status: 'invalid', message: 'Empty request body'),
          statusCode: 400);
    }

    final licenseKey = (body['license_key'] as String?)?.trim() ?? '';
    final fingerprint = (body['machine_fingerprint'] as String?)?.trim() ?? '';
    final serverVersion = (body['server_version'] as String?)?.trim() ?? '';
    final domain = (body['domain'] as String?)?.trim() ?? '';

    if (licenseKey.isEmpty) {
      return json(
          _licenseResponse(
              valid: false,
              status: 'invalid',
              message: 'License key required'),
          statusCode: 400);
    }

    // Look up license
    final matchedLicenses =
        await licenses.where('license_key', licenseKey).get();
    if (matchedLicenses.isEmpty) {
      return json(_licenseResponse(
        valid: false,
        status: 'invalid',
        message: 'License key not found',
      ));
    }

    final license = matchedLicenses.first;

    if (license.is_active != true) {
      return json(_licenseResponse(
        valid: false,
        status: 'revoked',
        message: 'License has been revoked',
      ));
    }

    // Check expiry
    if (license.expires_at != null && license.expires_at!.isNotEmpty) {
      final expiry = DateTime.tryParse(license.expires_at!);
      if (expiry != null && DateTime.now().isAfter(expiry)) {
        return json(_licenseResponse(
          valid: false,
          status: 'expired',
          message: 'License has expired',
          expiresAt: license.expires_at,
        ));
      }
    }

    // Update deployment last_seen_at
    if (fingerprint.isNotEmpty) {
      final existingDeployments = await deployments
          .where('license_id', license.id)
          .where('machine_fingerprint', fingerprint)
          .where('is_active', 1)
          .get();

      if (existingDeployments.isNotEmpty) {
        final dep = existingDeployments.first;
        dep.last_seen_at = DateTime.now();
        dep.server_version = serverVersion;
        if (domain.isNotEmpty) dep.domain = domain;
        await dep.save();
      }
    }

    return json(_licenseResponse(
      valid: true,
      plan: license.plan ?? 'personal',
      status: 'active',
      message: 'License active',
      maxDeployments: license.max_deployments ?? 1,
      graceDays: 30,
      expiresAt: license.expires_at,
    ));
  });

  // POST /api/v2/license/deactivate
  // Called by Go servers on clean shutdown to release a deployment slot
  server.post('/api/v2/license/deactivate', (req) async {
    final body = req.body as Map<String, dynamic>?;
    if (body == null) {
      return json(
          _licenseResponse(
              valid: false, status: 'invalid', message: 'Empty request body'),
          statusCode: 400);
    }

    final licenseKey = (body['license_key'] as String?)?.trim() ?? '';
    final fingerprint = (body['machine_fingerprint'] as String?)?.trim() ?? '';

    if (licenseKey.isEmpty || fingerprint.isEmpty) {
      return json(
          _licenseResponse(
              valid: false,
              status: 'invalid',
              message: 'License key and machine fingerprint required'),
          statusCode: 400);
    }

    // Look up license
    final matchedLicenses =
        await licenses.where('license_key', licenseKey).get();
    if (matchedLicenses.isEmpty) {
      return json(_licenseResponse(
        valid: false,
        status: 'invalid',
        message: 'License key not found',
      ));
    }

    final license = matchedLicenses.first;

    // Find and deactivate the deployment
    final existingDeployments = await deployments
        .where('license_id', license.id)
        .where('machine_fingerprint', fingerprint)
        .where('is_active', 1)
        .get();

    if (existingDeployments.isNotEmpty) {
      final dep = existingDeployments.first;
      dep.is_active = false;
      await dep.save();
    }

    return json(_licenseResponse(
      valid: true,
      status: 'deactivated',
      message: 'Deployment deactivated',
    ));
  });
}
