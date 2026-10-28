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
  String? checkout_id;
  String? notes;
  String? features; // comma-separated feature flags (e.g. "live_channels")
  String? expires_at;
  DateTime? createdAt;
  // Entity.updatedAt is the ORM auto-update switch, not the stored timestamp.
  DateTime? updatedAtTimestamp;

  Licens({
    int? id,
    this.license_key,
    this.user_id,
    this.plan,
    this.max_deployments,
    this.is_active,
    this.transaction_id,
    this.checkout_id,
    this.notes,
    this.features,
    this.expires_at,
    this.createdAt,
    DateTime? updatedAt,
  }) : _id = id,
       updatedAtTimestamp = updatedAt;

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
        'checkout_id': checkout_id,
        'notes': notes,
        'features': features,
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
        checkout_id: row['checkout_id'] as String?,
        notes: row['notes'] as String?,
        features: row['features'] as String?,
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
        'checkout_id': checkout_id,
        'notes': notes,
        'features': features,
        'expires_at': expires_at,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAtTimestamp?.toIso8601String(),
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
        'checkout_id': Column.string(100).nullable(),
        'notes': Column.text().nullable(),
        'features': Column.text().nullable(),
        'expires_at': Column.string(255).nullable(),
        'created_at': Column.dateTime().nullable(),
        'updated_at': Column.dateTime().nullable(),
      },
    );
  }

  /// Generate a license key in format OMNI-XXXX-XXXX-XXXX-XXXX
  static String generateKey() {
    return _generateKeyWithPrefix('OMNI', 4);
  }

  /// Generate an enterprise live key in format OMNI-LIVE-XXXX-XXXX
  static String generateLiveKey() {
    return _generateKeyWithPrefix('OMNI-LIVE', 2);
  }

  static String _generateKeyWithPrefix(String prefix, int segmentCount) {
    final random = Random.secure();
    final chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // no ambiguous: 0/O, 1/I/L
    String segment() =>
        List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
    final segments = List.generate(segmentCount, (_) => segment()).join('-');
    return '$prefix-$segments';
  }

  /// Check if a license key is a live-enabled enterprise key
  static bool isLiveKey(String key) => key.startsWith('OMNI-LIVE-');

  /// Returns the default features for a plan
  static List<String> planFeatures(String plan) {
    switch (plan) {
      case 'enterprise':
        return ['live_channels'];
      default:
        return [];
    }
  }

  /// Get the features list from this license
  List<String> get featuresList {
    if (features != null && features!.isNotEmpty) {
      return features!.split(',');
    }
    // Fallback: detect from key format or plan
    if (license_key != null && isLiveKey(license_key!)) {
      return ['live_channels'];
    }
    return planFeatures(plan ?? 'personal');
  }

  String get displayLabel => license_key ?? 'ID: $id';

  @override
  String toString() => 'Licens(id: $_id, license_key: $license_key)';
}
