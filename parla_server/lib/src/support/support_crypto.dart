import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../health/health_crypto.dart';
import '../health/health_kms.dart';

/// Seals support messages with AES-GCM. Each message is bound to the
/// thread's owner, so a row moved to another user does not decrypt.
/// Withdrawing the health consent does not affect support messages.
///
/// Keys (owner, 2026-11-26: option A of ENC-3):
/// - [kmsVersion]: each thread has its own random key, wrapped by the KMS
///   health key with the context `parla:user` = the owner and
///   `parla:purpose` = `support`, so it never unwraps as a health key. Used
///   whenever KMS is configured ([HealthKms.wrapper]).
/// - `null` (older messages, development and tests without KMS): a key
///   derived by HKDF from the server KEK (`healthKek`) with its own label.
///   Older messages keep it and are read with it until they expire.
class SupportCrypto {
  SupportCrypto(this._key, this.version);

  /// `keyVersion` of messages sealed with the thread's KMS-wrapped key.
  static const kmsVersion = 2;

  /// The KMS encryption context purpose of thread keys.
  static const purpose = 'support';

  /// The key derived from the server KEK (messages without a version).
  static Future<SupportCrypto> derived(Session session) async {
    final encoded = session.passwords['healthKek'];
    if (encoded == null || encoded.isEmpty) {
      throw StateError('Missing password "healthKek".');
    }
    final derived = await Hkdf(hmac: Hmac.sha256(), outputLength: 32).deriveKey(
      secretKey: SecretKey(base64.decode(encoded)),
      nonce: utf8.encode('parla-support'),
      info: utf8.encode('support-messages-v1'),
    );
    return SupportCrypto(await derived.extractBytes(), null);
  }

  /// The key new messages of [thread] are sealed with: the thread's KMS key
  /// (made and stored on first use) when KMS is configured, else the
  /// derived key. Two first messages at once end up with the same key: the
  /// key is stored only while the thread has none, then read back.
  static Future<SupportCrypto> forWriting(
    Session session,
    SupportThread thread,
  ) async {
    final kms = HealthKms.wrapper;
    if (kms == null) return derived(session);
    var wrapped = thread.wrappedKey;
    if (wrapped == null) {
      final random = Random.secure();
      final fresh = [for (var i = 0; i < 32; i++) random.nextInt(256)];
      await session.db.unsafeExecute(
        'UPDATE "support_thread" SET "wrappedKey" = @key '
        'WHERE "id" = @id AND "wrappedKey" IS NULL',
        parameters: QueryParameters.named({
          'key': await kms.wrap(fresh, thread.authUserId, purpose: purpose),
          'id': thread.id!,
        }),
      );
      wrapped = (await SupportThread.db.findById(
        session,
        thread.id!,
      ))!.wrappedKey!;
    }
    return SupportCrypto(
      await kms.unwrap(wrapped, thread.authUserId, purpose: purpose),
      kmsVersion,
    );
  }

  /// The keys to read [thread]'s messages with, by `keyVersion`; each is
  /// made once, on first need.
  static SupportKeys forReading(Session session, SupportThread thread) =>
      SupportKeys._(session, thread);

  final List<int> _key;

  /// The `keyVersion` stored with messages sealed by this key.
  final int? version;

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

/// The keys of one thread for reading, made lazily by `keyVersion`.
class SupportKeys {
  SupportKeys._(this._session, this._thread);

  final Session _session;
  final SupportThread _thread;
  final _keys = <int?, Future<SupportCrypto>>{};

  /// The plain text of [message].
  Future<String> open(SupportMessage message) async {
    final crypto = await _keys.putIfAbsent(
      message.keyVersion,
      () => _make(message.keyVersion),
    );
    return crypto.open(
      Sealed(ciphertext: message.ciphertext, nonce: message.nonce),
      _thread.authUserId,
    );
  }

  Future<SupportCrypto> _make(int? version) async {
    if (version == null) return SupportCrypto.derived(_session);
    if (version != SupportCrypto.kmsVersion) {
      throw StateError('Unknown support key version $version.');
    }
    final kms = HealthKms.wrapper;
    final wrapped = _thread.wrappedKey;
    if (kms == null || wrapped == null) {
      throw StateError('A support message is sealed by KMS but KMS is off.');
    }
    return SupportCrypto(
      await kms.unwrap(
        wrapped,
        _thread.authUserId,
        purpose: SupportCrypto.purpose,
      ),
      SupportCrypto.kmsVersion,
    );
  }
}
