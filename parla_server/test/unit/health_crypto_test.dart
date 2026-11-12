import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:parla_server/src/health/health_crypto.dart';
import 'package:test/test.dart';

void main() {
  final kek = List<int>.generate(32, (i) => i);
  final crypto = HealthCrypto(kek);
  const alice = '0b6c1f3e-8a4d-4c7e-9f21-3d5a7e9b1c01';
  const bob = '7f2e9d4c-1b3a-4e5f-8c6d-9a0b1c2d3e02';

  test('round trip through a wrapped data key', () async {
    final key = await crypto.newDataKey();
    final sealed = await crypto.seal(key.dataKey, '{"pregnancy":"no"}', alice);
    final unwrapped = await crypto.unwrap(key.wrapped);
    expect(await crypto.open(unwrapped, sealed, alice), '{"pregnancy":"no"}');
  });

  test('ciphertext does not contain the plaintext', () async {
    final key = await crypto.newDataKey();
    final sealed = await crypto.seal(key.dataKey, 'rosacea pregnant', alice);
    final bytes = base64.decode(sealed.ciphertext);
    expect(
      utf8.decode(bytes, allowMalformed: true),
      isNot(contains('rosacea')),
    );
    expect(sealed.ciphertext, isNot(contains('rosacea')));
  });

  test('two encryptions of the same text differ (fresh nonce)', () async {
    final key = await crypto.newDataKey();
    final a = await crypto.seal(key.dataKey, 'same', alice);
    final b = await crypto.seal(key.dataKey, 'same', alice);
    expect(a.ciphertext, isNot(b.ciphertext));
    expect(a.nonce, isNot(b.nonce));
  });

  test("a row moved to another user does not decrypt", () async {
    final key = await crypto.newDataKey();
    final sealed = await crypto.seal(key.dataKey, 'secret', alice);
    await expectLater(
      crypto.open(key.dataKey, sealed, bob),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });

  test('a different KEK cannot unwrap the data key', () async {
    final key = await crypto.newDataKey();
    final other = HealthCrypto(List<int>.filled(32, 7));
    await expectLater(
      other.unwrap(key.wrapped),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });

  test('the KEK must be present and 32 bytes', () {
    expect(() => HealthCrypto(List<int>.filled(16, 1)), throwsArgumentError);
    expect(() => HealthCrypto.fromBase64(null), throwsStateError);
    expect(() => HealthCrypto.fromBase64(''), throwsStateError);
  });
}
