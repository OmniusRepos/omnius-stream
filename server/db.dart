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

    // Run migrations (creates tables)
    await DuxtOrm.migrate();

    // Add missing columns to existing tables (ORM only creates, doesn't alter)
    await _addMissingColumns();
  }

  static Future<void> _addMissingColumns() async {
    final alterStatements = [
      // Licenses table - columns added after initial creation
      'ALTER TABLE licenses ADD COLUMN transaction_id TEXT',
      'ALTER TABLE licenses ADD COLUMN notes TEXT',
      'ALTER TABLE licenses ADD COLUMN expires_at TEXT',
    ];

    for (final sql in alterStatements) {
      try {
        await DuxtOrm.raw(sql);
      } catch (_) {
        // Column already exists — ignore duplicate column error
      }
    }
  }
}
