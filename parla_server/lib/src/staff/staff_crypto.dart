import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:serverpod/serverpod.dart';

import '../health/health_crypto.dart';

/// Seals staff TOTP secrets with a key derived from the server KEK
/// (`healthKek`) by HKDF with its own label, so the two uses of the KEK
/// never share a key.
class StaffCrypto {
  StaffCrypto._(this._key);

  static Future<StaffCrypto> of(Session session) async {
    final encoded = session.passwords['healthKek'];
    if (encoded == null || encoded.isEmpty) {
      throw StateError('Missing password "healthKek".');
    }
    final derived = await Hkdf(hmac: Hmac.sha256(), outputLength: 32).deriveKey(
      secretKey: SecretKey(base64.decode(encoded)),
      nonce: utf8.encode('parla-staff'),
      info: utf8.encode('staff-totp-v1'),
    );
    return StaffCrypto._(await derived.extractBytes());
  }

  final List<int> _key;
  final _aes = AesGcm.with256bits();

  /// Encrypts [secret], bound to [owner] so a row copied to another staff
  /// member does not decrypt.
  Future<Sealed> seal(List<int> secret, UuidValue owner) async {
    final box = await _aes.encrypt(
      secret,
      secretKey: SecretKey(_key),
      aad: utf8.encode(owner.toString()),
    );
    return Sealed(
      ciphertext: base64.encode([...box.cipherText, ...box.mac.bytes]),
      nonce: base64.encode(box.nonce),
    );
  }

  Future<List<int>> open(Sealed sealed, UuidValue owner) {
    final bytes = base64.decode(sealed.ciphertext);
    final macLength = _aes.macAlgorithm.macLength;
    return _aes.decrypt(
      SecretBox(
        bytes.sublist(0, bytes.length - macLength),
        nonce: base64.decode(sealed.nonce),
        mac: Mac(bytes.sublist(bytes.length - macLength)),
      ),
      secretKey: SecretKey(_key),
      aad: utf8.encode(owner.toString()),
    );
  }
}
