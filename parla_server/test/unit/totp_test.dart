import 'dart:convert';

import 'package:parla_server/src/staff/totp.dart';
import 'package:test/test.dart';

void main() {
  // RFC 6238 appendix B, SHA-1 secret "12345678901234567890" (8 digits
  // there; the last 6 digits are the 6-digit code).
  final secret = utf8.encode('12345678901234567890');

  test('matches the RFC 6238 test vectors', () async {
    expect(await Totp.code(secret, 59 ~/ 30), '287082');
    expect(await Totp.code(secret, 1111111109 ~/ 30), '081804');
    expect(await Totp.code(secret, 1234567890 ~/ 30), '005924');
    expect(await Totp.code(secret, 2000000000 ~/ 30), '279037');
  });

  test('accepts one step of drift and refuses reuse', () async {
    final now = DateTime.utc(2026, 11, 16, 9);
    final step = Totp.stepAt(now);
    final previous = await Totp.code(secret, step - 1);
    expect(await Totp.verify(secret, previous, now), step - 1);
    expect(
      await Totp.verify(secret, previous, now, lastStep: step - 1),
      isNull,
    );
    final old = await Totp.code(secret, step - 3);
    expect(await Totp.verify(secret, old, now), isNull);
    expect(await Totp.verify(secret, '12 34', now), isNull);
  });

  test('base32 round-trips and the URI names the issuer', () {
    final s = Totp.newSecret();
    expect(Totp.fromBase32(Totp.base32(s)), s);
    expect(Totp.base32(secret), 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ');
    expect(
      Totp.uri('ABC', 'a@b.c'),
      startsWith('otpauth://totp/Parla%20Admin%3Aa%40b.c?secret=ABC'),
    );
  });
}
