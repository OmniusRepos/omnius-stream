import 'dart:convert';
import 'package:duxt/server.dart';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/models/licens.dart';
import 'package:omnius_stream/models/order.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';

void registerPolarRoutes(DuxtServer server) {
  final users = Model<User>();
  final licenses = Model<Licens>();

  // POST /api/polar/webhook
  server.post('/api/polar/webhook', (req) async {
    final body = req.body;
    if (body == null) {
      return json({'error': 'Empty body'}, statusCode: 400);
    }

    // Re-encode body for signature verification
    final bodyString = jsonEncode(body);

    // Verify webhook signature (Standard Webhooks spec)
    final webhookId = req.headers['webhook-id'];
    final webhookTimestamp = req.headers['webhook-timestamp'];
    final webhookSignature = req.headers['webhook-signature'];

    if (webhookId == null ||
        webhookTimestamp == null ||
        webhookSignature == null) {
      return json({'error': 'Missing webhook signature headers'},
          statusCode: 401);
    }

    final secret = Platform.environment['POLAR_WEBHOOK_SECRET'] ?? '';
    if (secret.isNotEmpty) {
      // Remove prefix and base64-decode the secret
      String rawSecret = secret;
      if (rawSecret.startsWith('whsec_')) {
        rawSecret = rawSecret.substring(6);
      } else if (rawSecret.startsWith('polar_whs_')) {
        rawSecret = rawSecret.substring(10);
      }
      final secretKey = base64.decode(rawSecret);

      // Construct signed content: {msg_id}.{timestamp}.{body}
      final signedContent = '$webhookId.$webhookTimestamp.$bodyString';
      final hmacDigest =
          Hmac(sha256, secretKey).convert(utf8.encode(signedContent));
      final expectedSignature = base64.encode(hmacDigest.bytes);

      // webhook-signature header can contain multiple signatures separated by spaces
      // Each signature is prefixed with version, e.g., "v1,base64signature"
      final signatures = webhookSignature.split(' ');
      final isValid = signatures.any((sig) {
        final parts = sig.split(',');
        if (parts.length != 2) return false;
        return parts[1] == expectedSignature;
      });

      if (!isValid) {
        return json({'error': 'Invalid webhook signature'}, statusCode: 401);
      }
    }

    final data = body as Map<String, dynamic>;
    final eventType = data['type'] as String?;

    if (eventType != 'order.paid') {
      return json({'status': 'ignored', 'event': eventType});
    }

    final eventData = data['data'] as Map<String, dynamic>?;
    if (eventData == null) {
      return json({'error': 'Missing event data'}, statusCode: 400);
    }

    final orderId = eventData['id'] as String?;
    if (orderId == null) {
      return json({'error': 'Missing order ID'}, statusCode: 400);
    }

    // Idempotency check
    final existingLicenses =
        await licenses.where('transaction_id', orderId).get();
    if (existingLicenses.isNotEmpty) {
      return json({
        'status': 'already_processed',
        'license_key': existingLicenses.first.license_key,
      });
    }

    // Extract customer info
    final customer = eventData['customer'] as Map<String, dynamic>?;
    final email =
        (customer?['email'] as String?)?.trim().toLowerCase() ?? '';
    final customerName =
        customer?['name'] as String? ?? email.split('@').first;

    // Determine plan from product ID
    final product = eventData['product'] as Map<String, dynamic>?;
    final productId = product?['id'] as String? ?? '';

    final personalProductId =
        Platform.environment['POLAR_PERSONAL_PRODUCT_ID'] ?? '';
    final businessProductId =
        Platform.environment['POLAR_BUSINESS_PRODUCT_ID'] ?? '';
    final enterpriseProductId =
        Platform.environment['POLAR_ENTERPRISE_PRODUCT_ID'] ?? '';

    String plan = 'personal';
    int maxDeployments = 1;

    if (productId == enterpriseProductId) {
      plan = 'enterprise';
      maxDeployments = 999;
    } else if (productId == businessProductId) {
      plan = 'business';
      maxDeployments = 5;
    } else if (productId == personalProductId) {
      plan = 'personal';
      maxDeployments = 1;
    }

    // Extract amount
    final amountRaw = eventData['amount'] as int? ?? 0;
    final amount = (amountRaw / 100).toStringAsFixed(2);
    final currency = (eventData['currency'] as String? ?? 'usd').toUpperCase();

    // Find or create user
    User user;
    final existingUsers = await users.where('email', email).get();
    if (existingUsers.isNotEmpty) {
      user = existingUsers.first;
    } else {
      user = User(
        email: email,
        name: customerName,
        password_hash: User.hashPassword(orderId),
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
      transaction_id: orderId,
    );
    await license.save();

    // Create order record
    final order = Order(
      user_id: user.id as int,
      license_id: license.id as int,
      transaction_id: orderId,
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
