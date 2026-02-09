import 'dart:math';
import 'package:duxt_orm/duxt_orm.dart';

class Licens extends Entity {
  int? _id;
  String? license_key;
  int? user_id;
  String? plan;
  int? max_deployments;
  bool? is_active;
  String? transaction_id;
  String? notes;
  String? expires_at;
  DateTime? createdAt;
  DateTime? updatedAt;

  Licens({
    int? id,
    this.license_key,
    this.user_id,
    this.plan,
    this.max_deployments,
    this.is_active,
    this.transaction_id,
    this.notes,
    this.expires_at,
    this.createdAt,
    this.updatedAt,
  }) : _id = id;

  @override
  dynamic get id => _id;

  @override
  set id(dynamic value) => _id = value as int?;

  @override
  Map<String, dynamic> toMap() => {
        'license_key': license_key,
        'user_id': user_id,
        'plan': plan,
        'max_deployments': max_deployments,
        'is_active': is_active == true ? 1 : 0,
        'transaction_id': transaction_id,
        'notes': notes,
        'expires_at': expires_at,
      };

  factory Licens.fromRow(Map<String, dynamic> row) => Licens(
        id: row['id'] as int?,
        license_key: row['license_key'] as String?,
        user_id: row['user_id'] as int?,
        plan: row['plan'] as String?,
        max_deployments: row['max_deployments'] as int?,
        is_active: (row['is_active'] as int?) == 1,
        transaction_id: row['transaction_id'] as String?,
        notes: row['notes'] as String?,
        expires_at: row['expires_at'] as String?,
        createdAt: row['created_at'] != null
            ? DateTime.tryParse(row['created_at'] as String)
            : null,
        updatedAt: row['updated_at'] != null
            ? DateTime.tryParse(row['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': _id,
        'license_key': license_key,
        'user_id': user_id,
        'plan': plan,
        'max_deployments': max_deployments,
        'is_active': is_active,
        'transaction_id': transaction_id,
        'notes': notes,
        'expires_at': expires_at,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  static void register() {
    Entity.registerModel<Licens>(
      Licens.fromRow,
      schema: {
        'id': Column.integer().primaryKey().autoIncrement(),
        'license_key': Column.string(30).unique().nullable(),
        'user_id': Column.integer().nullable(),
        'plan': Column.string(20).nullable(),
        'max_deployments': Column.integer().nullable(),
        'is_active': Column.boolean().defaultValue(true),
        'transaction_id': Column.string(100).unique().nullable(),
        'notes': Column.text().nullable(),
        'expires_at': Column.string(255).nullable(),
        'created_at': Column.dateTime().nullable(),
        'updated_at': Column.dateTime().nullable(),
      },
    );
  }

  /// Generate a license key in format OMNI-XXXX-XXXX-XXXX-XXXX
  static String generateKey() {
    final random = Random.secure();
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String segment() =>
        List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
    return 'OMNI-${segment()}-${segment()}-${segment()}-${segment()}';
  }

  String get displayLabel => license_key ?? 'ID: $id';

  @override
  String toString() => 'Licens(id: $_id, license_key: $license_key)';
}
