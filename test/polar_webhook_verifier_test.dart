// Deterministic, offline checks; all keys and signatures below are public test
// fixtures, never credentials. Run: dart run test/polar_webhook_verifier_test.dart
import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../server/polar_webhook_verifier.dart';

const _body = '{ "type": "order.paid", "data": {"note":"café"} }';
const _id = 'test-message';
const _timestamp = '1800000000';
const _secret = 'test-secret-not-for-production';
// Independently generated with Python's hmac/hashlib, not the verifier.
const _signature = 'v1,lKV/dzRKnupTtKiBHosvDbpJ9hF4IdmID9vIJPPtCBM=';
final _now = DateTime.fromMillisecondsSinceEpoch(
  1800000000 * 1000,
  isUtc: true,
);

PolarWebhookVerification _verify({
  String secret = _secret,
  String? body = _body,
  String? id = _id,
  String? timestamp = _timestamp,
  String? signature = _signature,
  DateTime? now,
}) =>
    verifyPolarWebhook(
      secret: secret,
      rawBody: body,
      webhookId: id,
      timestamp: timestamp,
      signatureHeader: signature,
      now: now ?? _now,
    );

String _sign(List<int> key, {String timestamp = _timestamp}) =>
    'v1,${base64.encode(Hmac(sha256, key).convert(utf8.encode('$_id.$timestamp.$_body')).bytes)}';

void main() {
  var passed = 0;
  void check(
    String name,
    PolarWebhookVerification actual,
    PolarWebhookVerification expected,
  ) {
    if (actual != expected) throw StateError('$name: $actual != $expected');
    passed++;
  }

  const valid = PolarWebhookVerification.verified;
  const invalid = PolarWebhookVerification.invalid;
  const unconfigured = PolarWebhookVerification.notConfigured;
  check('legacy/custom literal key', _verify(), valid);
  check('missing secret fails closed', _verify(secret: ''), unconfigured);
  check('whitespace secret fails closed', _verify(secret: ' '), unconfigured);
  check(
    'newline in secret fails closed',
    _verify(secret: 'test\nsecret'),
    unconfigured,
  );
  check(
    'prefix-only standard key fails closed',
    _verify(secret: 'whsec_'),
    unconfigured,
  );
  check(
    'prefix-only legacy key fails closed',
    _verify(secret: 'polar_whs_'),
    unconfigured,
  );
  check('wrong secret', _verify(secret: 'different-public-test-key'), invalid);
  check('missing raw body', _verify(body: null), invalid);
  check('altered raw body', _verify(body: '$_body '), invalid);
  check(
    're-encoded JSON is not the signed body',
    _verify(body: jsonEncode(jsonDecode(_body))),
    invalid,
  );
  check('missing ID', _verify(id: null), invalid);
  check('empty ID', _verify(id: ''), invalid);
  check('altered ID', _verify(id: 'other-message'), invalid);
  check('missing timestamp', _verify(timestamp: null), invalid);
  check('nonnumeric timestamp', _verify(timestamp: 'not-a-time'), invalid);
  check(
    'partial numeric timestamp',
    _verify(timestamp: '${_timestamp}junk'),
    invalid,
  );
  check('negative timestamp', _verify(timestamp: '-1'), invalid);
  check(
    'overflow timestamp',
    _verify(timestamp: '999999999999999999999999'),
    invalid,
  );
  check(
    'future signed timestamp',
    _verify(now: _now.subtract(const Duration(seconds: 301))),
    invalid,
  );
  check(
    'stale signed timestamp',
    _verify(now: _now.add(const Duration(seconds: 301))),
    invalid,
  );
  check(
    'old tolerance boundary',
    _verify(now: _now.add(const Duration(seconds: 300))),
    valid,
  );
  check(
    'future tolerance boundary',
    _verify(now: _now.subtract(const Duration(seconds: 300))),
    valid,
  );
  check('modified fresh timestamp', _verify(timestamp: '1800000001'), invalid);
  check(
    'valid newly signed timestamp',
    _verify(
      timestamp: '1800000001',
      signature: _sign(utf8.encode(_secret), timestamp: '1800000001'),
    ),
    valid,
  );
  check('missing signatures', _verify(signature: null), invalid);
  check('empty signatures', _verify(signature: ''), invalid);
  check(
    'wrong signature',
    _verify(signature: 'v1,AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='),
    invalid,
  );
  check(
    'unknown version',
    _verify(signature: _signature.replaceFirst('v1,', 'v2,')),
    invalid,
  );
  check(
    'missing version',
    _verify(signature: _signature.substring(3)),
    invalid,
  );
  check('extra comma', _verify(signature: '$_signature,extra'), invalid);
  check(
    'multiple versions include valid v1',
    _verify(signature: 'v2,ignored v1,invalid $_signature'),
    valid,
  );
  check(
    'malformed header entries do not authenticate',
    _verify(signature: 'v2,ignored v1,invalid malformed'),
    invalid,
  );

  // New Standard Webhooks secrets decode the suffix; legacy Polar keys retain
  // the entire string. Public bytes 0..31 deliberately contain no randomness.
  final standardKey = List<int>.generate(32, (index) => index);
  final standardSecret = 'whsec_${base64.encode(standardKey)}';
  check(
    'standard key independently generated vector',
    _verify(
      secret: standardSecret,
      signature: 'v1,PUvFH3covqcybSNJQ5TYwi/nAADMe1frGfrGKUJc+yw=',
    ),
    valid,
  );
  check(
    'standard unpadded key',
    _verify(
      secret: standardSecret.replaceAll('=', ''),
      signature: 'v1,PUvFH3covqcybSNJQ5TYwi/nAADMe1frGfrGKUJc+yw=',
    ),
    valid,
  );
  check(
    'legacy whsec prefix uses literal bytes',
    _verify(
      secret: standardSecret,
      signature: _sign(utf8.encode(standardSecret)),
    ),
    valid,
  );
  final legacySecret = '${'polar_whs_'}public_test_fixture';
  check(
    'legacy polar prefix independently generated vector',
    _verify(
      secret: legacySecret,
      signature: 'v1,+dRbAa1538E0/ze3BVgod5h1kAMscI2DvxA9w20bKNo=',
    ),
    valid,
  );
  check(
    'invalid base64 never becomes an empty HMAC key',
    _verify(secret: 'whsec_!!!', signature: _sign([])),
    invalid,
  );
  check(
    'non-base64 legacy custom key is literal',
    _verify(
      secret: 'whsec_legacy_fixture',
      signature: _sign(utf8.encode('whsec_legacy_fixture')),
    ),
    valid,
  );
  print('Passed $passed Polar webhook verification checks.');
}
