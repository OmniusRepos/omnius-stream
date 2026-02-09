import 'package:duxt/server.dart';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/licens.dart';
import 'package:omnius_stream/models/order.dart';
import 'package:omnius_stream/shared/middleware/auth_middleware.dart';

void registerDashboardRoutes(DuxtServer server) {
  final licenses = Model<Licens>();
  final orders = Model<Order>();

  // GET /api/dashboard/licenses — returns current user's licenses
  server.get('/api/dashboard/licenses', (req) async {
    final userId = AuthMiddleware.getUserId(req.headers['cookie']);
    if (userId == null) {
      return json({'error': 'Not authenticated'}, statusCode: 401);
    }

    final userLicenses = await licenses.where('user_id', userId).get();
    return json({
      'licenses': userLicenses.map((l) => l.toJson()).toList(),
    });
  });

  // GET /api/dashboard/orders — returns current user's orders
  server.get('/api/dashboard/orders', (req) async {
    final userId = AuthMiddleware.getUserId(req.headers['cookie']);
    if (userId == null) {
      return json({'error': 'Not authenticated'}, statusCode: 401);
    }

    final userOrders = await orders.where('user_id', userId).get();
    return json({
      'orders': userOrders.map((o) => o.toJson()).toList(),
    });
  });
}
