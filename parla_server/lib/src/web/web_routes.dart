import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../media/media_store.dart';
import 'public_media.dart';
import 'shop_routes.dart';

/// The web server (port 8082) behind the same address as the API: the load
/// balancer sends `/admin`, `/media/*` and `/shop/*` here and everything else to the
/// API server, so the panel and the images share the API's origin and no
/// CORS is needed.
///
/// - `/media/<id>.jpg`, `/media/<id>.mp4`: published content images and
///   exercise videos ([PublicMedia]).
/// - `/shop/epoint/result`, `/shop/done`: Epoint's payment report and the
///   page buyers return to ([EpointResultRoute], [ShopDoneRoute]).
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
  addRoute(EpointResultRoute(), '/shop/epoint/result');
  addRoute(ShopDoneRoute(), '/shop/done');

  final admin = Directory('$webRoot/admin');
  if (!File('${admin.path}/index.html').existsSync()) return;
  addMiddleware(const AdminHeadersMiddleware().call, '/admin');
  addRoute(AdminPanelRoute(admin), '/admin');
}

/// `GET /media/<id>.jpg` and `GET /media/<id>.mp4` (with byte ranges,
/// which phones' video players ask for).
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
      video: PublicMedia.isVideo(file),
      request: request,
    );
  }
}

/// The response for an image's or video's bytes, or 404 when there are
/// none. A single byte range in [request] gets a 206 with that range.
Response mediaResponse(
  List<int>? bytes, {
  bool video = false,
  Request? request,
}) {
  if (bytes == null) {
    return Response.notFound(
      body: Body.fromString('Not found'),
      headers: Headers.build((h) => h.cacheControl = _noStore),
    );
  }
  final data = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
  final mime = MimeType.parse(video ? 'video/mp4' : 'image/jpeg');
  final headers = Headers.build((h) {
    h.cacheControl = CacheControlHeader(
      publicCache: true,
      maxAge: PublicMedia.browserMaxAge.inSeconds,
    );
    h.acceptRanges = AcceptRangesHeader.bytes();
    h['Cross-Origin-Resource-Policy'] = ['same-origin'];
  });
  final range = request == null ? null : _range(request, data.length);
  if (range == null) {
    return Response.ok(
      body: Body.fromData(data, mimeType: mime),
      headers: headers,
    );
  }
  if (range.isEmpty) {
    return Response(
      416,
      headers: headers.transform(
        (h) => h.contentRange = ContentRangeHeader(size: data.length),
      ),
    );
  }
  final (start, end) = range.single;
  return Response(
    206,
    body: Body.fromData(
      Uint8List.sublistView(data, start, end),
      mimeType: mime,
    ),
    headers: headers.transform(
      (h) => h.contentRange = ContentRangeHeader(
        start: start,
        end: end - 1,
        size: data.length,
      ),
    ),
  );
}

/// The one range asked for as `[(start, end)]` (end exclusive), `[]` when
/// it cannot be served (416), or `null` to send the whole file (no Range
/// header, several ranges, or one that cannot be read).
List<(int, int)>? _range(Request request, int size) {
  final RangeHeader? header;
  try {
    header = request.headers.range;
  } on Object {
    return null;
  }
  if (header == null || header.ranges.length != 1) return null;
  final r = header.ranges.single;
  int start;
  int end;
  if (r.start != null) {
    start = r.start!;
    end = r.end == null ? size : r.end! + 1;
  } else {
    start = size - r.end!;
    end = size;
  }
  if (start < 0) start = 0;
  if (end > size) end = size;
  if (start >= size || start >= end) return const [];
  return [(start, end)];
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
      "media-src 'self' blob:; "
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
