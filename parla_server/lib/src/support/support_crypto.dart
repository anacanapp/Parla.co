import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:serverpod/serverpod.dart';

import '../health/health_crypto.dart';

/// Seals support messages with a key derived from the server KEK
/// (`healthKek`) by HKDF with its own label, so it never shares a key with
/// health data or staff secrets. Each message is bound to the thread's
/// owner, so a row moved to another user does not decrypt. Withdrawing the
/// health consent does not affect support messages.
class SupportCrypto {
  SupportCrypto._(this._key);

  static Future<SupportCrypto> of(Session session) async {
    final encoded = session.passwords['healthKek'];
    if (encoded == null || encoded.isEmpty) {
      throw StateError('Missing password "healthKek".');
    }
    final derived = await Hkdf(hmac: Hmac.sha256(), outputLength: 32).deriveKey(
      secretKey: SecretKey(base64.decode(encoded)),
      nonce: utf8.encode('parla-support'),
      info: utf8.encode('support-messages-v1'),
    );
    return SupportCrypto._(await derived.extractBytes());
  }

  final List<int> _key;
  final _aes = AesGcm.with256bits();

  Future<Sealed> seal(String text, UuidValue owner) async {
    final box = await _aes.encrypt(
      utf8.encode(text),
      secretKey: SecretKey(_key),
      aad: utf8.encode(owner.toString()),
    );
    return Sealed(
      ciphertext: base64.encode([...box.cipherText, ...box.mac.bytes]),
      nonce: base64.encode(box.nonce),
    );
  }

  Future<String> open(Sealed sealed, UuidValue owner) async {
    final bytes = base64.decode(sealed.ciphertext);
    final macLength = _aes.macAlgorithm.macLength;
    final clear = await _aes.decrypt(
      SecretBox(
        bytes.sublist(0, bytes.length - macLength),
        nonce: base64.decode(sealed.nonce),
        mac: Mac(bytes.sublist(bytes.length - macLength)),
      ),
      secretKey: SecretKey(_key),
      aad: utf8.encode(owner.toString()),
    );
    return utf8.decode(clear);
  }
}
