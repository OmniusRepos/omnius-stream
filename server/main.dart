import 'dart:io';
import 'package:duxt/server.dart';
import 'db.dart';
import 'api/auth.dart';
import 'api/licenses.dart';
import 'api/polar.dart';
import 'api/dashboard.dart';

void main() async {
  // Initialize ORM and run migrations
  await Db.init();

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 3001;

  final server = DuxtServer(
    port: port,
    middleware: [cors(), jsonBody(), logger()],
  );

  // Register API routes
  registerAuthRoutes(server);
  registerLicensRoutes(server);
  registerPolarRoutes(server);
  registerDashboardRoutes(server);

  server.start();
}
