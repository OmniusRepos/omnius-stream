import 'package:duxt_orm/duxt_orm.dart';

class Deployment extends Entity {
  int? _id;
  int? license_id;
  String? machine_fingerprint;
  String? machine_label;
  String? server_version;
  String? ip_address;
  String? domain;
  bool? is_active;
  DateTime? last_seen_at;
  DateTime? createdAt;
  DateTime? updatedAt;

  Deployment({
    int? id,
    this.license_id,
    this.machine_fingerprint,
    this.machine_label,
    this.server_version,
    this.ip_address,
    this.domain,
    this.is_active,
    this.last_seen_at,
    this.createdAt,
    this.updatedAt,
  }) : _id = id;

  @override
  dynamic get id => _id;

  @override
  set id(dynamic value) => _id = value as int?;

  @override
  Map<String, dynamic> toMap() => {
        'license_id': license_id,
        'machine_fingerprint': machine_fingerprint,
        'machine_label': machine_label,
        'server_version': server_version,
        'ip_address': ip_address,
        'domain': domain,
        'is_active': is_active == true ? 1 : 0,
        'last_seen_at': last_seen_at?.toIso8601String(),
      };

  factory Deployment.fromRow(Map<String, dynamic> row) => Deployment(
        id: row['id'] as int?,
        license_id: row['license_id'] as int?,
        machine_fingerprint: row['machine_fingerprint'] as String?,
        machine_label: row['machine_label'] as String?,
        server_version: row['server_version'] as String?,
        ip_address: row['ip_address'] as String?,
        domain: row['domain'] as String?,
        is_active: (row['is_active'] as int?) == 1,
        last_seen_at: row['last_seen_at'] != null
            ? DateTime.tryParse(row['last_seen_at'] as String)
            : null,
        createdAt: row['created_at'] != null
            ? DateTime.tryParse(row['created_at'] as String)
            : null,
        updatedAt: row['updated_at'] != null
            ? DateTime.tryParse(row['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': _id,
        'license_id': license_id,
        'machine_fingerprint': machine_fingerprint,
        'machine_label': machine_label,
        'server_version': server_version,
        'ip_address': ip_address,
        'domain': domain,
        'is_active': is_active,
        'last_seen_at': last_seen_at?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  static void register() {
    Entity.registerModel<Deployment>(
      Deployment.fromRow,
      schema: {
        'id': Column.integer().primaryKey().autoIncrement(),
        'license_id': Column.integer().nullable(),
        'machine_fingerprint': Column.string(255).nullable(),
        'machine_label': Column.string(255).nullable(),
        'server_version': Column.string(50).nullable(),
        'ip_address': Column.string(100).nullable(),
        'domain': Column.string(255).nullable(),
        'is_active': Column.boolean().defaultValue(true),
        'last_seen_at': Column.string(255).nullable(),
        'created_at': Column.dateTime().nullable(),
        'updated_at': Column.dateTime().nullable(),
      },
    );
  }
}
