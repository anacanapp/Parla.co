import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../media/media_store.dart';
import 'public_media.dart';

/// The web server (port 8082) behind the same address as the API: the load
/// balancer sends `/admin` and `/media/*` here and everything else to the
/// API server, so the panel and the images share the API's origin and no
/// CORS is needed.
///
/// - `/media/<id>.jpg`: published content images ([PublicMedia]).
/// - `/admin/`: the admin panel, a Flutter web build in `web/admin` (built
///   into the image by the Dockerfile), with a strict content security
///   policy. Unknown paths below it load the panel (client-side routing).
///
/// HSTS, `nosniff` and `X-Frame-Options` are added by the load balancer to
/// every response.
void addWebRoutes(Serverpod pod, {String webRoot = 'web'}) {
  if (pod.config.webServer == null) return;
  final web = pod.webServer;
  mountWebRoutes(
    webRoot: webRoot,
    addRoute: web.addRoute,
    addMiddleware: (m, path) => web.addMiddleware(m, path),
  );
}

/// Registers the routes through [addRoute] and [addMiddleware] (the
/// [WebServer] methods; tests pass a plain Relic app).
void mountWebRoutes({
  required String webRoot,
  required void Function(Route route, String path) addRoute,
  required void Function(Middleware middleware, String path) addMiddleware,
}) {
  addRoute(MediaRoute(), '/media/:file');

  final admin = Directory('$webRoot/admin');
  if (!File('${admin.path}/index.html').existsSync()) return;
  addMiddleware(const AdminHeadersMiddleware().call, '/admin');
  addRoute(AdminPanelRoute(admin), '/admin');
}

/// `GET /media/<id>.jpg`.
class MediaRoute extends Route {
  MediaRoute() : super(methods: {Method.get, Method.head});

  // Needs no database session.
  @override
  Future<Result> call(Request req) => _serve(req);

  @override
  Future<Result> handleCall(Session session, Request request) =>
      _serve(request);

  Future<Result> _serve(Request request) async {
    final file = request.url.pathSegments.isEmpty
        ? ''
        : request.url.pathSegments.last;
    return mediaResponse(
      await PublicMedia.instance.read(file, Media.instance.store),
    );
  }
}

/// The response for an image's bytes, or 404 when there are none.
Response mediaResponse(List<int>? bytes) {
  if (bytes == null) {
    return Response.notFound(
      body: Body.fromString('Not found'),
      headers: Headers.build((h) => h.cacheControl = _noStore),
    );
  }
  return Response.ok(
    body: Body.fromData(
      bytes is Uint8List ? bytes : Uint8List.fromList(bytes),
      mimeType: MimeType.parse('image/jpeg'),
    ),
    headers: Headers.build((h) {
      h.cacheControl = CacheControlHeader(
        publicCache: true,
        maxAge: PublicMedia.browserMaxAge.inSeconds,
      );
      h['Cross-Origin-Resource-Policy'] = ['same-origin'];
    }),
  );
}

final _noStore = CacheControlHeader(noStore: true);

/// The panel's files below `/admin/`. Paths that are not files load
/// `index.html` (client-side routing). `/admin` itself redirects to
/// `/admin/`, because the panel is built with `--base-href /admin/`. Every file is revalidated with its
/// ETag, because Flutter's file names carry no content hash. Needs no
/// database session.
class AdminPanelRoute extends Route {
  AdminPanelRoute(this.directory)
    : super(methods: {Method.get, Method.head}, path: '/**');

  final Directory directory;

  static CacheControlHeader? _revalidate(Request _, FileInfo _) =>
      CacheControlHeader(privateCache: true, noCache: true);

  late final Handler _handler = StaticHandler.directory(
    directory,
    cacheControl: _revalidate,
    defaultHandler: StaticHandler.file(
      File('${directory.path}/index.html'),
      cacheControl: _revalidate,
    ).asHandler,
  ).asHandler;

  static final _withSlash = Uri(path: '/admin/');

  Future<Result> _serve(Request req) async {
    if (req.url.path == '/admin') return Response.movedPermanently(_withSlash);
    return _handler(req);
  }

  @override
  Future<Result> call(Request req) => _serve(req);

  @override
  Future<Result> handleCall(Session session, Request request) =>
      _serve(request);
}

/// Security headers of the admin panel: it loads nothing from other sites
/// (CanvasKit and fonts are bundled), talks only to its own origin and is
/// never indexed or framed.
class AdminHeadersMiddleware extends MiddlewareObject {
  const AdminHeadersMiddleware();

  static const contentSecurityPolicy =
      "default-src 'self'; "
      "script-src 'self' 'wasm-unsafe-eval'; "
      "style-src 'self' 'unsafe-inline'; "
      "img-src 'self' data: blob:; "
      "font-src 'self' data:; "
      "connect-src 'self'; "
      "worker-src 'self' blob:; "
      "frame-ancestors 'none'; "
      "base-uri 'self'; "
      "form-action 'none'; "
      "object-src 'none'";

  @override
  Handler call(Handler next) {
    return (Request req) async {
      final result = await next(req);
      if (result is! Response) return result;
      return result.copyWith(
        headers: result.headers.transform((h) {
          h['Content-Security-Policy'] = [contentSecurityPolicy];
          h['Referrer-Policy'] = ['no-referrer'];
          h['X-Robots-Tag'] = ['noindex, nofollow'];
          h['Permissions-Policy'] = [
            'camera=(), microphone=(), geolocation=(), payment=()',
          ];
          h['Cross-Origin-Opener-Policy'] = ['same-origin'];
        }),
      );
    };
  }
}
