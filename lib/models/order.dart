import 'package:duxt_orm/duxt_orm.dart';

class Order extends Entity {
  int? _id;
  int? user_id;
  int? license_id;
  String? paddle_transaction_id;
  String? amount;
  String? currency;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Order({
    int? id,
    this.user_id,
    this.license_id,
    this.paddle_transaction_id,
    this.amount,
    this.currency,
    this.status,
    this.createdAt,
    this.updatedAt,
  }) : _id = id;

  @override
  dynamic get id => _id;

  @override
  set id(dynamic value) => _id = value as int?;

  @override
  Map<String, dynamic> toMap() => {
        'user_id': user_id,
        'license_id': license_id,
        'paddle_transaction_id': paddle_transaction_id,
        'amount': amount,
        'currency': currency,
        'status': status,
      };

  factory Order.fromRow(Map<String, dynamic> row) => Order(
        id: row['id'] as int?,
        user_id: row['user_id'] as int?,
        license_id: row['license_id'] as int?,
        paddle_transaction_id: row['paddle_transaction_id'] as String?,
        amount: row['amount'] as String?,
        currency: row['currency'] as String?,
        status: row['status'] as String?,
        createdAt: row['created_at'] != null
            ? DateTime.tryParse(row['created_at'] as String)
            : null,
        updatedAt: row['updated_at'] != null
            ? DateTime.tryParse(row['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': _id,
        'user_id': user_id,
        'license_id': license_id,
        'paddle_transaction_id': paddle_transaction_id,
        'amount': amount,
        'currency': currency,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  static void register() {
    Entity.registerModel<Order>(
      Order.fromRow,
      schema: {
        'id': Column.integer().primaryKey().autoIncrement(),
        'user_id': Column.integer().nullable(),
        'license_id': Column.integer().nullable(),
        'paddle_transaction_id': Column.string(100).nullable(),
        'amount': Column.string(20).nullable(),
        'currency': Column.string(3).nullable(),
        'status': Column.string(20).nullable(),
        'created_at': Column.dateTime().nullable(),
        'updated_at': Column.dateTime().nullable(),
      },
    );
  }

  String get displayLabel => paddle_transaction_id ?? 'ID: $id';

  @override
  String toString() => 'Order(id: $_id, user_id: $user_id)';
}
