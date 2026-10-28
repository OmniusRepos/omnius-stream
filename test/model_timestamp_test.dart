// No database is opened and no migrations run in these regression checks.
// Run: dart run test/model_timestamp_test.dart
import '../lib/models/deployment.dart';
import '../lib/models/licens.dart';
import '../lib/models/order.dart';
import '../lib/models/user.dart';

void main() {
  const timestamp = '2026-01-02T03:04:05.000Z';
  final time = DateTime.parse(timestamp);
  final row = <String, dynamic>{
    'id': 1,
    'is_active': 1,
    'created_at': timestamp,
    'updated_at': timestamp,
  };
  final models = <dynamic>[
    User.fromRow(row),
    Licens.fromRow(row),
    Order.fromRow(row),
    Deployment.fromRow(row),
    User(updatedAt: time),
    Licens(updatedAt: time),
    Order(updatedAt: time),
    Deployment(updatedAt: time),
  ];
  var passed = 0;
  for (final model in models) {
    if (model.updatedAtTimestamp != time) {
      throw StateError('${model.runtimeType}: timestamp not preserved');
    }
    if (model.updatedAt != true) {
      throw StateError(
          '${model.runtimeType}: ORM automatic timestamps changed');
    }
    if (model.toJson()['updatedAt'] != timestamp) {
      throw StateError('${model.runtimeType}: public JSON field changed');
    }
    if (model.toMap().containsKey('updated_at')) {
      throw StateError('${model.runtimeType}: ORM timestamp ownership changed');
    }
    passed += 4;
  }
  for (final model in <dynamic>[
    User.fromRow({'id': 1}),
    Licens.fromRow({'id': 1}),
    Order.fromRow({'id': 1}),
    Deployment.fromRow({'id': 1}),
  ]) {
    if (model.updatedAtTimestamp != null ||
        model.toJson()['updatedAt'] != null) {
      throw StateError('${model.runtimeType}: nullable timestamp changed');
    }
    passed++;
  }
  print('Passed $passed model timestamp compatibility checks.');
}
