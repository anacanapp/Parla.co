/// The API address for the panel.
///
/// - A `SERVER_URL` build define wins (local development against another
///   server).
/// - Served by the Parla server under `/admin/` (production), the API is on
///   the same origin, so the image works in any environment without a
///   rebuild and the content security policy can stay `connect-src 'self'`.
/// - Otherwise `null`: the caller falls back to the local server.
String? sameOriginServerUrl(Uri page, {String define = ''}) {
  if (define.isNotEmpty) return define;
  final servedByServer =
      page.path == '/admin' || page.path.startsWith('/admin/');
  if ((page.scheme == 'https' || page.scheme == 'http') && servedByServer) {
    return '${page.origin}/';
  }
  return null;
}
