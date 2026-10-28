import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:duxt_orm/duxt_orm.dart';

class User extends Entity {
  int? _id;
  String? email;
  String? name;
  String? password_hash;
  bool? is_active;
  DateTime? createdAt;
  // Entity.updatedAt is the ORM auto-update switch, not the stored timestamp.
  DateTime? updatedAtTimestamp;

  User({
    int? id,
    this.email,
    this.name,
    this.password_hash,
    this.is_active,
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
        'email': email,
        'name': name,
        'password_hash': password_hash,
        'is_active': is_active == true ? 1 : 0,
      };

  factory User.fromRow(Map<String, dynamic> row) => User(
        id: row['id'] as int?,
        email: row['email'] as String?,
        name: row['name'] as String?,
        password_hash: row['password_hash'] as String?,
        is_active: (row['is_active'] as int?) == 1,
        createdAt: row['created_at'] != null
            ? DateTime.tryParse(row['created_at'] as String)
            : null,
        updatedAt: row['updated_at'] != null
            ? DateTime.tryParse(row['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': _id,
        'email': email,
        'name': name,
        'is_active': is_active,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAtTimestamp?.toIso8601String(),
      };

  static void register() {
    Entity.registerModel<User>(
      User.fromRow,
      schema: {
        'id': Column.integer().primaryKey().autoIncrement(),
        'email': Column.string(255).unique().notNull(),
        'name': Column.string(100).notNull(),
        'password_hash': Column.string(255).notNull(),
        'is_active': Column.boolean().defaultValue(true),
        'created_at': Column.dateTime().nullable(),
        'updated_at': Column.dateTime().nullable(),
      },
    );
  }

  /// Hash a password using SHA-256 with salt
  static String hashPassword(String password) {
    final salt = 'omnius_stream_salt_2026';
    final bytes = utf8.encode('$salt:$password');
    return sha256.convert(bytes).toString();
  }

  /// Verify a password against the stored hash
  bool verifyPassword(String password) {
    return password_hash == hashPassword(password);
  }

  String get displayLabel => name ?? 'ID: $id';

  @override
  String toString() => 'User(id: $_id, email: $email)';
}
