import 'dart:convert';
import 'dart:typed_data';
import 'package:duxt/server.dart';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/models/licens.dart';
import 'package:omnius_stream/models/order.dart';
import 'package:omnius_stream/models/deployment.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'email.dart';

/// Lenient base64 decoder that handles unpadded input and non-zero trailing bits
/// (which Dart's strict base64.decode rejects).
Uint8List _base64DecodeLenient(String input) {
  input = input.replaceAll('-', '+').replaceAll('_', '/');
  input = input.replaceAll('=', '');
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  final bytes = <int>[];
  var buffer = 0;
  var bitsCollected = 0;
  for (var i = 0; i < input.length; i++) {
    final value = chars.indexOf(input[i]);
    if (value < 0) continue;
    buffer = (buffer << 6) | value;
    bitsCollected += 6;
    if (bitsCollected >= 8) {
      bitsCollected -= 8;
      bytes.add((buffer >> bitsCollected) & 0xFF);
    }
  }
  return Uint8List.fromList(bytes);
}

void registerPolarRoutes(DuxtServer server) {
  final users = Model<User>();
  final licenses = Model<Licens>();
  final deployments = Model<Deployment>();

  // POST /api/polar/webhook
  server.post('/api/polar/webhook', (req) async {
    print('[Polar] Webhook received');
    final body = req.body;
    if (body == null) {
      print('[Polar] Empty body');
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
      // Lenient base64 decode (handles unpadded + non-zero trailing bits)
      final secretKey = _base64DecodeLenient(rawSecret);

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
    print('[Polar] Event type: $eventType');

    // Handle order.refunded — revoke license and deactivate deployments
    if (eventType == 'order.refunded') {
      final eventData = data['data'] as Map<String, dynamic>?;
      final orderId = eventData?['id'] as String?;
      if (orderId == null) {
        return json({'error': 'Missing order ID'}, statusCode: 400);
      }

      print('[Polar] Processing refund for order: $orderId');

      final refundedLicenses =
          await licenses.where('transaction_id', orderId).get();
      if (refundedLicenses.isEmpty) {
        print('[Polar] No license found for refunded order: $orderId');
        return json({'status': 'no_license_found', 'order_id': orderId});
      }

      final license = refundedLicenses.first;
      license.is_active = false;
      await license.save();

      // Deactivate all deployments for this license
      final licenseDeployments =
          await deployments.where('license_id', license.id).where('is_active', 1).get();
      for (final dep in licenseDeployments) {
        dep.is_active = false;
        await dep.save();
      }

      print('[Polar] Refund processed: license ${license.license_key} deactivated, ${licenseDeployments.length} deployments deactivated');
      return json({
        'status': 'refund_processed',
        'license_key': license.license_key,
        'deployments_deactivated': licenseDeployments.length,
      });
    }

    if (eventType != 'order.paid') {
      print('[Polar] Ignoring event: $eventType');
      return json({'status': 'ignored', 'event': eventType});
    }

    final eventData = data['data'] as Map<String, dynamic>?;
    if (eventData == null) {
      print('[Polar] Missing event data');
      return json({'error': 'Missing event data'}, statusCode: 400);
    }
    print('[Polar] Event data keys: ${eventData.keys.toList()}');

    final orderId = eventData['id'] as String?;
    final checkoutId = eventData['checkout_id'] as String? ??
        (eventData['checkout'] as Map<String, dynamic>?)?['id'] as String?;
    print('[Polar] Order ID: $orderId, Checkout ID: $checkoutId');
    if (orderId == null) {
      return json({'error': 'Missing order ID'}, statusCode: 400);
    }

    // Idempotency check
    final existingLicenses =
        await licenses.where('transaction_id', orderId).get();
    if (existingLicenses.isNotEmpty) {
      print('[Polar] Already processed: ${existingLicenses.first.license_key}');
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
        customer?['name'] as String? ?? (email.isNotEmpty ? email.split('@').first : 'Unknown');
    print('[Polar] Customer: $email ($customerName)');

    if (email.isEmpty) {
      print('[Polar] WARNING: No customer email in webhook for order $orderId');
    }

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
    print('[Polar] Plan: $plan (product: $productId), maxDeployments: $maxDeployments');

    // Extract amount
    final amountRaw = eventData['total_amount'] as int? ?? eventData['amount'] as int? ?? 0;
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
      checkout_id: checkoutId,
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

    print('[Polar] License created: $licenseKey for $email (plan: $plan)');

    // Send license key email to customer
    if (email.isNotEmpty) {
      sendLicenseEmail(
        toEmail: email,
        customerName: customerName,
        licenseKey: licenseKey,
        plan: plan,
        maxDeployments: maxDeployments,
      );
    }

    return json({
      'status': 'success',
      'license_key': licenseKey,
      'plan': plan,
    }, statusCode: 201);
  });
}
