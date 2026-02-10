import 'dart:io';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/models/licens.dart';
import 'package:omnius_stream/models/order.dart';
import 'package:omnius_stream/models/deployment.dart';

class Db {
  static Future<void> init() async {
    // Register models (order matters for foreign keys)
    User.register();
    Licens.register();
    Order.register();
    Deployment.register();

    // Initialize ORM with SQLite
    final dataDir = Platform.environment['DATA_DIR'] ?? '.';
    await DuxtOrm.init((
      driver: 'sqlite',
      host: '',
      port: 0,
      database: '',
      username: '',
      password: '',
      path: '$dataDir/omnius_stream.db',
      ssl: false,
    ));

    // Run migrations (creates tables + adds missing columns via duxt_orm 0.4.0)
    await DuxtOrm.migrate();
  }
}
