import 'dart:io';
import 'dart:typed_data';

import 'package:parla_server/src/media/media_store.dart';
import 'package:parla_server/src/web/public_media.dart';
import 'package:parla_server/src/web/web_routes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

const _id = '3f1c2a4e-9b7d-4c1a-8e2f-0a1b2c3d4e5f';

/// Runs the web routes on a plain Relic app on IPv4 loopback, mounted the
/// way `WebServer.addRoute` mounts them (host prefix `*`).
Future<(RelicServer, HttpClient, Directory)> _start() async {
  final root = await Directory.systemTemp.createTemp('parla-web');
  final admin = Directory('${root.path}/admin')..createSync();
  File('${admin.path}/index.html').writeAsStringSync('<html>panel</html>');
  File('${admin.path}/main.dart.js').writeAsStringSync('// app');

  final app = RelicApp(useHostWhenRouting: true);
  mountWebRoutes(
    webRoot: root.path,
    addRoute: (route, path) => app.injectAt('*/$path', route),
    addMiddleware: (m, path) => app.use('*/$path', m),
  );
  final server = await app.serve(port: 0);
  return (server, HttpClient(), root);
}

Future<(int, HttpHeaders, List<int>)> _get(
  HttpClient client,
  int port,
  String path, {
  String? range,
}) async {
  final req = await client.get('127.0.0.1', port, path);
  req.followRedirects = false;
  if (range != null) req.headers.set('range', range);
  final res = await req.close();
  final body = await res.fold<List<int>>([], (a, b) => a..addAll(b));
  return (res.statusCode, res.headers, body);
}

void main() {
  group('PublicMedia', () {
    test('accepts only <uuid v4>.jpg names', () {
      expect(PublicMedia.idOf('$_id.jpg'), _id);
      expect(PublicMedia.idOf(_id), isNull);
      expect(PublicMedia.idOf('$_id.png'), isNull);
      expect(PublicMedia.idOf('../uploads/$_id.jpg'), isNull);
      expect(PublicMedia.idOf('${_id.toUpperCase()}.jpg'), isNull);
      expect(PublicMedia.idOf('$_id.mp4'), _id);
      expect(PublicMedia.isVideo('$_id.mp4'), isTrue);
      expect(PublicMedia.isVideo('$_id.jpg'), isFalse);
      expect(PublicMedia.idOf('$_id.mov'), isNull);
    });

    test('reads only the public copy, never the private upload', () async {
      final store = MemoryMediaStore();
      final bytes = Uint8List.fromList([1, 2, 3]);
      await store.put(Media.privateKey(_id), bytes, 'image/jpeg');
      final media = PublicMedia();
      expect(await media.read('$_id.jpg', store), isNull);

      await store.copy(Media.privateKey(_id), Media.publicKey(_id));
      expect(await media.read('$_id.jpg', store), bytes);
    });

    test('forget drops the cached copy once it is unpublished', () async {
      final store = MemoryMediaStore();
      await store.put(Media.publicKey(_id), Uint8List(4), 'image/jpeg');
      final media = PublicMedia();
      expect(await media.read('$_id.jpg', store), isNotNull);

      await store.delete(Media.publicKey(_id));
      expect(await media.read('$_id.jpg', store), isNotNull); // cached
      media.forget(_id);
      expect(await media.read('$_id.jpg', store), isNull);
    });

    test('keeps the cache under its byte limit', () async {
      final store = MemoryMediaStore();
      final ids = [
        for (var i = 0; i < 3; i++) '3f1c2a4e-9b7d-4c1a-8e2f-0a1b2c3d4e5$i',
      ];
      for (final id in ids) {
        await store.put(Media.publicKey(id), Uint8List(10), 'image/jpeg');
      }
      final media = PublicMedia(maxCacheBytes: 20);
      for (final id in ids) {
        await media.read('$id.jpg', store);
      }
      // The oldest was evicted, so a removed copy is no longer served.
      await store.delete(Media.publicKey(ids.first));
      expect(await media.read('${ids.first}.jpg', store), isNull);
      await store.delete(Media.publicKey(ids.last));
      expect(await media.read('${ids.last}.jpg', store), isNotNull);
    });
  });

  group('web routes', () {
    late RelicServer server;
    late HttpClient client;
    late Directory root;
    final store = MemoryMediaStore();

    setUpAll(() async {
      (server, client, root) = await _start();
      Media.instance = Media(store);
      PublicMedia.instance = PublicMedia();
    });

    tearDownAll(() async {
      client.close(force: true);
      await server.close();
      await root.delete(recursive: true);
    });

    test('/media serves a published image with cache headers', () async {
      await store.put(Media.publicKey(_id), Uint8List(8), 'image/jpeg');
      final (status, headers, body) = await _get(
        client,
        server.port,
        '/media/$_id.jpg',
      );
      expect(status, 200);
      expect(body, hasLength(8));
      expect(headers.contentType?.mimeType, 'image/jpeg');
      expect(headers.value('cache-control'), contains('max-age=3600'));
      expect(headers.value('cache-control'), contains('public'));
    });

    test('/media serves a published video, with byte ranges', () async {
      const video = '7a1c2a4e-9b7d-4c1a-8e2f-0a1b2c3d4e5f';
      final bytes = Uint8List.fromList(List.generate(100, (i) => i));
      await store.put(Media.publicKey(video, video: true), bytes, 'video/mp4');
      var (status, headers, body) = await _get(
        client,
        server.port,
        '/media/$video.mp4',
      );
      expect(status, 200);
      expect(body, bytes);
      expect(headers.contentType?.mimeType, 'video/mp4');
      expect(headers.value('accept-ranges'), 'bytes');

      (status, headers, body) = await _get(
        client,
        server.port,
        '/media/$video.mp4',
        range: 'bytes=0-1',
      );
      expect(status, 206);
      expect(body, [0, 1]);
      expect(headers.value('content-range'), 'bytes 0-1/100');

      (status, headers, body) = await _get(
        client,
        server.port,
        '/media/$video.mp4',
        range: 'bytes=90-',
      );
      expect(status, 206);
      expect(body, List.generate(10, (i) => 90 + i));

      (status, headers, body) = await _get(
        client,
        server.port,
        '/media/$video.mp4',
        range: 'bytes=-5',
      );
      expect(body, [95, 96, 97, 98, 99]);

      (status, headers, _) = await _get(
        client,
        server.port,
        '/media/$video.mp4',
        range: 'bytes=200-300',
      );
      expect(status, 416);
      expect(headers.value('content-range'), 'bytes */100');

      // The video's private upload is never served as the image name.
      final (s2, _, _) = await _get(client, server.port, '/media/$video.jpg');
      expect(s2, 404);
    });

    test('/media gives 404 for unknown, unpublished or odd names', () async {
      const other = '00000000-0000-4000-8000-000000000000';
      await store.put(Media.privateKey(other), Uint8List(8), 'image/jpeg');
      for (final path in [
        '/media/$other.jpg',
        '/media/nothing.jpg',
        '/media/..%2Fuploads%2F$other.jpg',
        '/media/',
      ]) {
        final (status, _, _) = await _get(client, server.port, path);
        expect(status, 404, reason: path);
      }
    });

    test('/admin redirects to /admin/', () async {
      final (status, headers, _) = await _get(client, server.port, '/admin');
      expect(status, 301);
      expect(headers.value('location'), '/admin/');
    });

    test('/admin/ serves the panel with a strict policy', () async {
      final (status, headers, body) = await _get(
        client,
        server.port,
        '/admin/',
      );
      expect(status, 200);
      expect(String.fromCharCodes(body), contains('panel'));
      final csp = headers.value('content-security-policy')!;
      expect(csp, contains("connect-src 'self'"));
      expect(csp, contains("frame-ancestors 'none'"));
      expect(csp, isNot(contains('https:')));
      expect(headers.value('x-robots-tag'), 'noindex, nofollow');
      expect(headers.value('referrer-policy'), 'no-referrer');
    });

    test('/admin/ serves files and falls back to the panel', () async {
      final (s1, h1, b1) = await _get(
        client,
        server.port,
        '/admin/main.dart.js',
      );
      expect(s1, 200);
      expect(String.fromCharCodes(b1), '// app');
      expect(h1.value('content-security-policy'), isNotNull);

      final (s2, _, b2) = await _get(client, server.port, '/admin/staff/42');
      expect(s2, 200);
      expect(String.fromCharCodes(b2), contains('panel'));
    });
  });

  test('no API endpoint is named admin or media', () {
    // The load balancer sends /admin and /media/* to the web server.
    final generated = File(
      'lib/src/generated/endpoints.dart',
    ).readAsStringSync();
    final names = RegExp(
      r"connectors\['(\w+)'\]",
    ).allMatches(generated).map((m) => m.group(1)!).toSet();
    expect(names, isNotEmpty);
    expect(names, isNot(contains('admin')));
    expect(names, isNot(contains('media')));
  });
}
