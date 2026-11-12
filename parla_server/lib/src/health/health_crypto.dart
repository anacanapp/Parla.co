import 'dart:convert';

import 'package:cryptography/cryptography.dart';

/// Envelope encryption for health data (privacy checklist ENC-3).
///
/// Each user has their own 256-bit data key (DEK). The DEK encrypts the
/// user's health answers; the key-encryption key (KEK) encrypts the DEK.
/// Only the wrapped DEK is stored. Deleting it makes the user's health data
/// unreadable everywhere, backups included.
///
/// The KEK comes from `passwords.yaml` (`healthKek`, 32 bytes, base64) in
/// development and tests. Production should hold it in a KMS of the data
/// region; swapping the source only touches [HealthCrypto.fromBase64].
class HealthCrypto {
  HealthCrypto(List<int> kek, {this.kekVersion = 1})
    : _kek = SecretKey(List.unmodifiable(kek)) {
    if (kek.length != 32) {
      throw ArgumentError('The health KEK must be 32 bytes');
    }
  }

  /// Reads a base64 KEK, failing loudly when it is missing or malformed.
  factory HealthCrypto.fromBase64(String? encoded) {
    if (encoded == null || encoded.isEmpty) {
      throw StateError(
        'Missing password "healthKek". Run tool/create_local_passwords.sh '
        'or set SERVERPOD_PASSWORD_healthKek.',
      );
    }
    return HealthCrypto(base64.decode(encoded));
  }

  final SecretKey _kek;
  final int kekVersion;
  final _aes = AesGcm.with256bits();

  /// Creates a new random data key and returns it with its wrapped form.
  Future<({List<int> dataKey, Sealed wrapped})> newDataKey() async {
    final dataKey = await (await _aes.newSecretKey()).extractBytes();
    final wrapped = await _seal(_kek, dataKey, const []);
    return (dataKey: dataKey, wrapped: wrapped);
  }

  /// Decrypts a wrapped data key.
  Future<List<int>> unwrap(Sealed wrapped) => _open(_kek, wrapped, const []);

  /// Encrypts [plaintext] under [dataKey], bound to [owner] so a row copied
  /// to another user does not decrypt.
  Future<Sealed> seal(List<int> dataKey, String plaintext, String owner) =>
      _seal(SecretKey(dataKey), utf8.encode(plaintext), utf8.encode(owner));

  Future<String> open(List<int> dataKey, Sealed sealed, String owner) async =>
      utf8.decode(
        await _open(SecretKey(dataKey), sealed, utf8.encode(owner)),
      );

  Future<Sealed> _seal(SecretKey key, List<int> clear, List<int> aad) async {
    final box = await _aes.encrypt(clear, secretKey: key, aad: aad);
    return Sealed(
      ciphertext: base64.encode([...box.cipherText, ...box.mac.bytes]),
      nonce: base64.encode(box.nonce),
    );
  }

  Future<List<int>> _open(SecretKey key, Sealed sealed, List<int> aad) {
    final bytes = base64.decode(sealed.ciphertext);
    final macLength = _aes.macAlgorithm.macLength;
    final box = SecretBox(
      bytes.sublist(0, bytes.length - macLength),
      nonce: base64.decode(sealed.nonce),
      mac: Mac(bytes.sublist(bytes.length - macLength)),
    );
    return _aes.decrypt(box, secretKey: key, aad: aad);
  }
}

/// Base64 ciphertext (with its authentication tag) and nonce.
class Sealed {
  const Sealed({required this.ciphertext, required this.nonce});

  final String ciphertext;
  final String nonce;
}
