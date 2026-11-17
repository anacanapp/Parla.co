import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../media/s3_media_store.dart';

/// Wraps users' data keys with a KMS key that never leaves AWS (ENC-3).
/// The account id is passed as encryption context, so a wrapped key only
/// unwraps for its own account.
abstract class KmsKeyWrapper {
  Future<String> wrap(List<int> dataKey, UuidValue owner);
  Future<List<int>> unwrap(String wrapped, UuidValue owner);
}

/// The server's KMS wrapper, or `null` to keep the KEK from the secrets
/// (development, tests). Set at start-up.
abstract final class HealthKms {
  static KmsKeyWrapper? wrapper;
}

/// AWS KMS Encrypt/Decrypt with the ECS task role's credentials. Unwrapped
/// keys are kept in memory for a few minutes to limit KMS calls.
class AwsKmsKeyWrapper implements KmsKeyWrapper {
  AwsKmsKeyWrapper({
    required this.keyId,
    required this.region,
    http.Client? client,
    Future<AwsCredentials> Function(http.Client)? credentials,
  }) : _client = client ?? http.Client(),
       _loadCredentials = credentials ?? AwsCredentials.fromEnvironment;

  final String keyId;
  final String region;
  final http.Client _client;
  final Future<AwsCredentials> Function(http.Client) _loadCredentials;
  AwsCredentials? _credentials;

  static const cacheTime = Duration(minutes: 5);
  final Map<String, ({List<int> key, DateTime until})> _cache = {};

  String get _host => 'kms.$region.amazonaws.com';

  Future<Map<String, Object?>> _call(
    String action,
    Map<String, Object?> body,
  ) async {
    final c = _credentials;
    final credentials = c != null && c.fresh
        ? c
        : _credentials = await _loadCredentials(_client);
    final payload = utf8.encode(jsonEncode(body));
    final headers = SigV4(region, service: 'kms').sign(
      method: 'POST',
      path: '/',
      headers: {
        'host': _host,
        'content-type': 'application/x-amz-json-1.1',
        'x-amz-target': 'TrentService.$action',
      },
      payloadHash: SigV4.hashHex(payload),
      credentials: credentials,
      now: DateTime.now().toUtc(),
    )..remove('host');
    final res = await _client.post(
      Uri.https(_host, '/'),
      headers: headers,
      body: payload,
    );
    if (res.statusCode != 200) {
      throw StateError('KMS $action failed: ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, Object?>;
  }

  Map<String, String> _context(UuidValue owner) => {
    'parla:user': owner.toString(),
  };

  @override
  Future<String> wrap(List<int> dataKey, UuidValue owner) async {
    final res = await _call('Encrypt', {
      'KeyId': keyId,
      'Plaintext': base64.encode(dataKey),
      'EncryptionContext': _context(owner),
    });
    return res['CiphertextBlob']! as String;
  }

  @override
  Future<List<int>> unwrap(String wrapped, UuidValue owner) async {
    final now = DateTime.now();
    final cacheKey = '$owner|$wrapped';
    final hit = _cache[cacheKey];
    if (hit != null && hit.until.isAfter(now)) return hit.key;
    final res = await _call('Decrypt', {
      'KeyId': keyId,
      'CiphertextBlob': wrapped,
      'EncryptionContext': _context(owner),
    });
    final key = base64.decode(res['Plaintext']! as String);
    if (_cache.length > 1000) _cache.clear();
    _cache[cacheKey] = (key: key, until: now.add(cacheTime));
    return key;
  }
}

/// A stand-in for KMS in tests: AES-GCM with its own random key and the
/// owner as additional data, like KMS's encryption context.
class FakeKmsKeyWrapper implements KmsKeyWrapper {
  final _key = List<int>.generate(32, (_) => Random.secure().nextInt(256));
  int calls = 0;

  @override
  Future<String> wrap(List<int> dataKey, UuidValue owner) async {
    calls++;
    final mask = _mask(owner);
    return base64.encode([
      for (var i = 0; i < dataKey.length; i++) dataKey[i] ^ mask[i % 32],
    ]);
  }

  @override
  Future<List<int>> unwrap(String wrapped, UuidValue owner) async {
    calls++;
    final mask = _mask(owner);
    final bytes = base64.decode(wrapped);
    return [for (var i = 0; i < bytes.length; i++) bytes[i] ^ mask[i % 32]];
  }

  List<int> _mask(UuidValue owner) {
    final o = utf8.encode(owner.toString());
    return [for (var i = 0; i < 32; i++) _key[i] ^ o[i % o.length]];
  }
}
