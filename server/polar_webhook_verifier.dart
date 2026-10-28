import 'dart:convert';

import 'package:crypto/crypto.dart';

enum PolarWebhookVerification { verified, invalid, notConfigured }

/// Verifies Polar's raw JSON delivery before any event side effects.
///
/// Polar supports legacy literal UTF-8 keys and, for secrets generated since
/// 2026-09-08, Standard Webhooks base64 keys. Like Polar's current SDK, try both
/// interpretations of the configured secret; neither accepts unsigned requests.
/// https://polar.sh/docs/integrate/webhooks/delivery
PolarWebhookVerification verifyPolarWebhook({
  required String secret,
  required String? rawBody,
  required String? webhookId,
  required String? timestamp,
  required String? signatureHeader,
  DateTime? now,
}) {
  if (secret.isEmpty ||
      RegExp(r'[\x00-\x20\x7f]').hasMatch(secret) ||
      secret == 'whsec_' ||
      secret == 'polar_whs_') {
    return PolarWebhookVerification.notConfigured;
  }
  if (rawBody == null ||
      webhookId == null ||
      webhookId.trim().isEmpty ||
      timestamp == null ||
      !RegExp(r'^[0-9]+$').hasMatch(timestamp) ||
      signatureHeader == null ||
      signatureHeader.trim().isEmpty) {
    return PolarWebhookVerification.invalid;
  }

  final seconds = int.tryParse(timestamp);
  final currentSeconds = (now ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;
  // The timestamp is signed. Bound both old deliveries and future clock skew.
  if (seconds == null || (currentSeconds - seconds).abs() > 300) {
    return PolarWebhookVerification.invalid;
  }

  final keys = <List<int>>[utf8.encode(secret)];
  if (secret.startsWith('whsec_')) {
    try {
      final encoded = secret.substring(6);
      if (RegExp(r'^[A-Za-z0-9+/]+={0,2}$').hasMatch(encoded)) {
        final decoded = base64.decode(base64.normalize(encoded));
        if (decoded.isNotEmpty) keys.add(decoded);
      }
    } on FormatException {
      // Older Polar secrets are literal strings, not encoded key material.
      // Never attempt lenient decoding that silently discards invalid bytes.
    }
  }

  final content = utf8.encode('$webhookId.$timestamp.$rawBody');
  final expected = keys
      .map((key) => base64.encode(Hmac(sha256, key).convert(content).bytes))
      .toList();
  for (final signature in signatureHeader.trim().split(RegExp(r'\s+'))) {
    final parts = signature.split(',');
    if (parts.length != 2 || parts[0] != 'v1') continue;
    for (final candidate in expected) {
      if (_constantTimeEqual(candidate, parts[1])) {
        return PolarWebhookVerification.verified;
      }
    }
  }
  return PolarWebhookVerification.invalid;
}

// All valid HMAC-SHA256 base64 signatures have the same public length. Avoid
// returning early based on the first differing byte of an equal-length value.
bool _constantTimeEqual(String expected, String actual) {
  if (expected.length != actual.length) return false;
  var difference = 0;
  for (var i = 0; i < expected.length; i++) {
    difference |= expected.codeUnitAt(i) ^ actual.codeUnitAt(i);
  }
  return difference == 0;
}
