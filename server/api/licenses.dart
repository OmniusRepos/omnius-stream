import 'package:duxt/server.dart';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/models/licens.dart';

void registerLicensRoutes(DuxtServer server) {
  final users = Model<User>();
  final licenses = Model<Licens>();

  // GET /api/licenses/lookup?email=xxx — public endpoint for success page polling
  server.get('/api/licenses/lookup', (req) async {
    final email = (req.query('email') ?? '').trim().toLowerCase();
    if (email.isEmpty) {
      return json({'error': 'Email parameter required'}, statusCode: 400);
    }

    // Find user by email
    final matchedUsers = await users.where('email', email).get();
    if (matchedUsers.isEmpty) {
      return json({'license': null});
    }

    final user = matchedUsers.first;

    // Find latest active license for this user
    final userLicenses =
        await licenses.where('user_id', user.id).where('is_active', 1).get();
    if (userLicenses.isEmpty) {
      return json({'license': null});
    }

    // Return the most recently created license
    final latest = userLicenses.last;
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
}
