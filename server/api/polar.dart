import 'dart:convert';
import 'package:duxt/server.dart';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/models/licens.dart';
import 'package:omnius_stream/models/order.dart';
import 'package:omnius_stream/models/deployment.dart';
import 'dart:io';
import '../polar_webhook_verifier.dart';

void registerPolarRoutes(DuxtServer server) {
  final users = Model<User>();
  final licenses = Model<Licens>();
  final deployments = Model<Deployment>();

  // POST /api/polar/webhook
  server.post('/api/polar/webhook', (req) async {
    // Authentication must use the exact bytes received, never re-encoded JSON.
    final rawBody = req.rawBody;
    final verification = verifyPolarWebhook(
      secret: Platform.environment['POLAR_WEBHOOK_SECRET'] ?? '',
      rawBody: rawBody,
      webhookId: req.headers['webhook-id'],
      timestamp: req.headers['webhook-timestamp'],
      signatureHeader: req.headers['webhook-signature'],
    );
    if (verification == PolarWebhookVerification.notConfigured) {
      return json({'error': 'Webhook verification is not configured'},
          statusCode: 503);
    }
    if (verification != PolarWebhookVerification.verified) {
      return json({'error': 'Invalid webhook signature'}, statusCode: 401);
    }

    // Parse the authenticated body, rather than a separately transformed object.
    dynamic parsed;
    try {
      parsed = jsonDecode(rawBody!);
    } on FormatException {
      return json({'error': 'Invalid webhook JSON'}, statusCode: 400);
    }
    if (parsed is! Map<String, dynamic>) {
      return json({'error': 'Invalid webhook payload'}, statusCode: 400);
    }
    final data = parsed;
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

      print('[Polar] Refund processed: license deactivated, ${licenseDeployments.length} deployments deactivated');
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
      print('[Polar] Order already processed');
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

    // Generate license — enterprise gets OMNI-LIVE key with live_channels feature
    final licenseKey = plan == 'enterprise' ? Licens.generateLiveKey() : Licens.generateKey();
    final webhookFeatures = Licens.planFeatures(plan).join(',');
    final license = Licens(
      license_key: licenseKey,
      user_id: user.id as int,
      plan: plan,
      max_deployments: maxDeployments,
      is_active: true,
      transaction_id: orderId,
      checkout_id: checkoutId,
      features: webhookFeatures.isNotEmpty ? webhookFeatures : null,
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

    print('[Polar] License created (plan: $plan)');

    return json({
      'status': 'success',
      'license_key': licenseKey,
      'plan': plan,
    }, statusCode: 201);
  });
}
