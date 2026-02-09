import 'package:duxt/server.dart';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/models/licens.dart';
import 'package:omnius_stream/models/order.dart';
import 'dart:io';

void registerPaddleRoutes(DuxtServer server) {
  final users = Model<User>();
  final licenses = Model<Licens>();

  // POST /api/paddle/webhook
  server.post('/api/paddle/webhook', (req) async {
    final body = req.body;
    if (body == null) {
      return json({'error': 'Empty body'}, statusCode: 400);
    }

    final data = body as Map<String, dynamic>;
    final eventType = data['event_type'] as String?;

    if (eventType != 'transaction.completed') {
      return json({'status': 'ignored', 'event': eventType});
    }

    final txnData = data['data'] as Map<String, dynamic>?;
    if (txnData == null) {
      return json({'error': 'Missing transaction data'}, statusCode: 400);
    }

    final transactionId = txnData['id'] as String?;
    if (transactionId == null) {
      return json({'error': 'Missing transaction ID'}, statusCode: 400);
    }

    // Idempotency check
    final existingLicenses =
        await licenses.where('paddle_transaction_id', transactionId).get();
    if (existingLicenses.isNotEmpty) {
      return json({
        'status': 'already_processed',
        'license_key': existingLicenses.first.license_key,
      });
    }

    // Extract customer info
    final customer = txnData['customer'] as Map<String, dynamic>?;
    final email =
        (customer?['email'] as String?)?.trim().toLowerCase() ?? '';
    final customerName =
        customer?['name'] as String? ?? email.split('@').first;

    // Determine plan from items/price
    final items = txnData['items'] as List<dynamic>? ?? [];
    String plan = 'personal';
    int maxDeployments = 1;
    String amount = '0';
    String currency = 'USD';

    if (items.isNotEmpty) {
      final firstItem = items.first as Map<String, dynamic>;
      final price = firstItem['price'] as Map<String, dynamic>?;
      final priceId = price?['id'] as String? ?? '';

      final personalPriceId =
          Platform.environment['PADDLE_PERSONAL_PRICE_ID'] ?? '';
      final businessPriceId =
          Platform.environment['PADDLE_BUSINESS_PRICE_ID'] ?? '';

      if (priceId == businessPriceId) {
        plan = 'business';
        maxDeployments = 5;
      } else if (priceId == personalPriceId) {
        plan = 'personal';
        maxDeployments = 1;
      }

      final unitPrice = price?['unit_price'] as Map<String, dynamic>?;
      amount = unitPrice?['amount'] as String? ?? '0';
      currency = unitPrice?['currency_code'] as String? ?? 'USD';

      final amountInt = int.tryParse(amount);
      if (amountInt != null) {
        amount = (amountInt / 100).toStringAsFixed(2);
      }
    }

    // Find or create user
    User user;
    final existingUsers = await users.where('email', email).get();
    if (existingUsers.isNotEmpty) {
      user = existingUsers.first;
    } else {
      user = User(
        email: email,
        name: customerName,
        password_hash: User.hashPassword(transactionId),
        is_active: true,
      );
      await user.save();
    }

    // Generate license
    final licenseKey = Licens.generateKey();
    final license = Licens(
      license_key: licenseKey,
      user_id: user.id as int,
      plan: plan,
      max_deployments: maxDeployments,
      is_active: true,
      paddle_transaction_id: transactionId,
    );
    await license.save();

    // Create order record
    final order = Order(
      user_id: user.id as int,
      license_id: license.id as int,
      paddle_transaction_id: transactionId,
      amount: amount,
      currency: currency,
      status: 'completed',
    );
    await order.save();

    return json({
      'status': 'success',
      'license_key': licenseKey,
      'plan': plan,
    }, statusCode: 201);
  });
}
