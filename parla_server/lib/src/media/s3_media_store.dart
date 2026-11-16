import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'media_store.dart';

/// AWS credentials, usually temporary ones of the ECS task role.
class AwsCredentials {
  const AwsCredentials(
    this.accessKeyId,
    this.secretAccessKey, {
    this.sessionToken,
    this.expires,
  });

  final String accessKeyId;
  final String secretAccessKey;
  final String? sessionToken;
  final DateTime? expires;

  bool get fresh =>
      expires == null ||
      expires!.isAfter(DateTime.now().toUtc().add(const Duration(minutes: 5)));

  /// The ECS task role's credentials (no keys stored anywhere), or the
  /// standard AWS_* variables for a developer's machine.
  static Future<AwsCredentials> fromEnvironment(http.Client client) async {
    final env = Platform.environment;
    final relative = env['AWS_CONTAINER_CREDENTIALS_RELATIVE_URI'];
    if (relative != null) {
      final res = await client.get(Uri.parse('http://169.254.170.2$relative'));
      if (res.statusCode != 200) {
        throw StateError('Task role credentials: ${res.statusCode}');
      }
      final j = jsonDecode(res.body) as Map<String, Object?>;
      return AwsCredentials(
        j['AccessKeyId']! as String,
        j['SecretAccessKey']! as String,
        sessionToken: j['Token'] as String?,
        expires: DateTime.parse(j['Expiration']! as String).toUtc(),
      );
    }
    final id = env['AWS_ACCESS_KEY_ID'];
    final secret = env['AWS_SECRET_ACCESS_KEY'];
    if (id == null || secret == null) {
      throw StateError('No AWS credentials for the media store');
    }
    return AwsCredentials(id, secret, sessionToken: env['AWS_SESSION_TOKEN']);
  }
}

/// AWS Signature Version 4 for S3 requests.
class SigV4 {
  SigV4(this.region, {this.service = 's3'});

  final String region;
  final String service;

  static String _hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  static String hashHex(List<int> bytes) => _hex(sha256.convert(bytes).bytes);

  static List<int> _hmac(List<int> key, String data) =>
      Hmac(sha256, key).convert(utf8.encode(data)).bytes;

  static String _amzDate(DateTime t) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${t.year}${two(t.month)}${two(t.day)}T'
        '${two(t.hour)}${two(t.minute)}${two(t.second)}Z';
  }

  /// URI-encodes a path, keeping the slashes.
  static String encodePath(String path) => path
      .split('/')
      .map(
        (s) => Uri.encodeComponent(
          s,
        ).replaceAll('!', '%21').replaceAll("'", '%27'),
      )
      .join('/');

  /// The headers to send, including `Authorization`. [headers] must hold
  /// `host`; `x-amz-content-sha256` is added from [payloadHash].
  Map<String, String> sign({
    required String method,
    required String path,
    required Map<String, String> headers,
    required String payloadHash,
    required AwsCredentials credentials,
    required DateTime now,
    Map<String, String> query = const {},
  }) {
    final amzDate = _amzDate(now.toUtc());
    final date = amzDate.substring(0, 8);
    final all = <String, String>{
      for (final e in headers.entries) e.key.toLowerCase(): e.value.trim(),
      'x-amz-content-sha256': payloadHash,
      'x-amz-date': amzDate,
      if (credentials.sessionToken != null)
        'x-amz-security-token': credentials.sessionToken!,
    };
    final names = all.keys.toList()..sort();
    final canonicalHeaders = names.map((n) => '$n:${all[n]}\n').join();
    final signedHeaders = names.join(';');
    final q = query.keys.toList()..sort();
    final canonicalQuery = q
        .map(
          (k) => '${Uri.encodeComponent(k)}=${Uri.encodeComponent(query[k]!)}',
        )
        .join('&');
    final canonical = [
      method,
      encodePath(path),
      canonicalQuery,
      canonicalHeaders,
      signedHeaders,
      payloadHash,
    ].join('\n');
    final scope = '$date/$region/$service/aws4_request';
    final toSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      scope,
      hashHex(utf8.encode(canonical)),
    ].join('\n');
    var key = _hmac(utf8.encode('AWS4${credentials.secretAccessKey}'), date);
    key = _hmac(key, region);
    key = _hmac(key, service);
    key = _hmac(key, 'aws4_request');
    final signature = _hex(
      Hmac(sha256, key).convert(utf8.encode(toSign)).bytes,
    );
    return {
      ...all,
      'authorization':
          'AWS4-HMAC-SHA256 Credential=${credentials.accessKeyId}/$scope, '
          'SignedHeaders=$signedHeaders, Signature=$signature',
    };
  }
}

/// Images in a private S3 bucket. Only CloudFront reads the `public/`
/// prefix; uploads stay under `uploads/`.
class S3MediaStore implements MediaStore {
  S3MediaStore({
    required this.bucket,
    required this.region,
    http.Client? client,
    Future<AwsCredentials> Function(http.Client)? credentials,
  }) : _client = client ?? http.Client(),
       _loadCredentials = credentials ?? AwsCredentials.fromEnvironment;

  final String bucket;
  final String region;
  final http.Client _client;
  final Future<AwsCredentials> Function(http.Client) _loadCredentials;
  AwsCredentials? _credentials;

  String get _host => '$bucket.s3.$region.amazonaws.com';

  Future<AwsCredentials> _creds() async {
    final c = _credentials;
    if (c != null && c.fresh) return c;
    return _credentials = await _loadCredentials(_client);
  }

  Future<http.Response> _send(
    String method,
    String key, {
    Uint8List? body,
    Map<String, String> headers = const {},
  }) async {
    final path = '/$key';
    final signed = SigV4(region).sign(
      method: method,
      path: path,
      headers: {'host': _host, ...headers},
      payloadHash: SigV4.hashHex(body ?? const []),
      credentials: await _creds(),
      now: DateTime.now().toUtc(),
    );
    final request = http.Request(
      method,
      Uri.https(_host, SigV4.encodePath(path)),
    )..headers.addAll(signed..remove('host'));
    if (body != null) request.bodyBytes = body;
    final res = await http.Response.fromStream(await _client.send(request));
    if (res.statusCode >= 300 && !(method == 'GET' && res.statusCode == 404)) {
      throw HttpException('S3 $method ${res.statusCode}');
    }
    return res;
  }

  @override
  Future<void> put(String key, Uint8List bytes, String contentType) => _send(
    'PUT',
    key,
    body: bytes,
    headers: {
      'content-type': contentType,
      'cache-control': 'public, max-age=31536000, immutable',
    },
  );

  @override
  Future<Uint8List?> get(String key) async {
    final res = await _send('GET', key);
    return res.statusCode == 404 ? null : res.bodyBytes;
  }

  @override
  Future<void> copy(String from, String to) => _send(
    'PUT',
    to,
    headers: {
      'x-amz-copy-source': SigV4.encodePath('/$bucket/$from'),
      'x-amz-metadata-directive': 'COPY',
    },
  );

  @override
  Future<void> delete(String key) => _send('DELETE', key);
}
