import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../content/content_endpoint.dart';
import '../generated/protocol.dart';
import 'site_html.dart';
import 'site_stats.dart';
import 'site_texts.dart';

/// The public website at the API's address (owner, 2026-11-27): the home
/// page, the blog, the privacy policy and the terms, in az (`/`), ru
/// (`/ru`) and en (`/en`). The load balancer sends these paths to the web
/// server. Pages are plain HTML with the site's own CSS and a small script
/// for click and reading-depth totals ([SiteStats]); no cookies and
/// nothing from other sites.
class SiteConfig {
  SiteConfig({
    required this.assets,
    required this.legal,
    this.appStoreUrl,
    this.googlePlayUrl,
  });

  /// From the web root and the environment: `PARLA_APP_STORE_URL` and
  /// `PARLA_GOOGLE_PLAY_URL` once the app is in the stores.
  factory SiteConfig.of(String webRoot) {
    String? store(String name, String prefix) {
      final v = Platform.environment[name]?.trim();
      return v != null && v.startsWith(prefix) ? v : null;
    }

    final legal = Directory('$webRoot/site/legal');
    return SiteConfig(
      assets: Directory('$webRoot/site/assets'),
      legal: legal.existsSync()
          ? legal
          : Directory('../parla_flutter/assets/legal'),
      appStoreUrl: store('PARLA_APP_STORE_URL', 'https://apps.apple.com/'),
      googlePlayUrl: store(
        'PARLA_GOOGLE_PLAY_URL',
        'https://play.google.com/',
      ),
    );
  }

  final Directory assets;
  final Directory legal;
  final String? appStoreUrl;
  final String? googlePlayUrl;
}

/// The paths the website answers, below each language prefix.
const sitePages = ['/', '/blog', '/blog/:slug', '/privacy', '/terms'];

/// Registers the website's routes through [addRoute].
void mountSiteRoutes(
  SiteConfig config, {
  required void Function(Route route, String path) addRoute,
}) {
  final pages = SitePageRoute(config);
  for (final l in siteLanguages) {
    for (final p in sitePages) {
      addRoute(pages, SiteHtml.pathIn(l, p));
    }
  }
  addRoute(SiteEventRoute(), '/site/e');
  addRoute(SiteAssetsRoute(config.assets), '/site/assets');
  addRoute(SiteRobotsRoute(), '/robots.txt');
  addRoute(SiteMapRoute(), '/sitemap.xml');
}

/// Security headers of the website's pages.
Headers siteHeaders({Duration maxAge = const Duration(minutes: 5)}) =>
    Headers.build((h) {
      h.cacheControl = CacheControlHeader(
        publicCache: true,
        maxAge: maxAge.inSeconds,
      );
      h['Content-Security-Policy'] = [
        "default-src 'none'; script-src 'self'; style-src 'self'; "
            "img-src 'self'; font-src 'self'; connect-src 'self'; "
            "base-uri 'none'; form-action 'none'; frame-ancestors 'none'",
      ];
      h['Referrer-Policy'] = ['strict-origin-when-cross-origin'];
      h['Permissions-Policy'] = [
        'camera=(), microphone=(), geolocation=(), payment=(), '
            'interest-cohort=()',
      ];
      h['Cross-Origin-Opener-Policy'] = ['same-origin'];
    });

/// A page of the website, in the language of its path prefix.
class SitePageRoute extends Route {
  SitePageRoute(this.config) : super(methods: {Method.get, Method.head});

  final SiteConfig config;

  /// (language, page) of a request path: `/ru/blog/x` → (`ru`,
  /// `/blog/x`).
  static (String, String) split(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isNotEmpty &&
        siteLanguages.contains(segments.first) &&
        segments.first != 'az') {
      return (segments.first, '/${segments.skip(1).join('/')}');
    }
    return ('az', '/${segments.join('/')}');
  }

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final (status, html) = await serve(
      session,
      SiteVisit(
        path: request.url.path,
        query: request.url.queryParameters,
        counted: request.method == Method.get,
        userAgent: request.headers['user-agent']?.join(',') ?? '',
        forwardedFor: request.headers['x-forwarded-for']?.join(','),
        remote: request.connectionInfo.remote.address.toString(),
        referer: request.headers['referer']?.join(','),
      ),
    );
    return Response(
      status,
      body: Body.fromString(html, mimeType: MimeType.html),
      headers: siteHeaders(),
    );
  }

  /// The status and HTML of [visit]'s page; a shown page is counted
  /// ([SiteStats.recordView]) unless the visitor is a robot.
  Future<(int, String)> serve(Session session, SiteVisit visit) async {
    final (language, page) = split(visit.path);
    final (status, html, key) = await _render(session, language, page);
    if (visit.counted && status == 200 && !SiteStats.isBot(visit.userAgent)) {
      try {
        await SiteStats.recordView(
          session,
          page: key,
          language: language,
          userAgent: visit.userAgent,
          address: SiteStats.clientAddress(visit.forwardedFor, visit.remote),
          referrer: SiteStats.referrerOf(
            visit.referer,
            Uri.parse(SiteHtml.origin).host,
          ),
          campaign: SiteStats.campaignOf(visit.query),
        );
      } on Object catch (error) {
        // Statistics never stop a page.
        session.log('Site view not counted: ${error.runtimeType}');
      }
    }
    return (status, html);
  }

  Future<(int, String, String)> _render(
    Session session,
    String l,
    String page,
  ) async {
    final stores = (config.appStoreUrl, config.googlePlayUrl);
    if (page == '/') {
      final articles = await siteArticles(session, l);
      return (
        200,
        SiteHtml.home(
          l,
          articles.take(3).toList(),
          appStore: stores.$1,
          googlePlay: stores.$2,
        ),
        '/',
      );
    }
    if (page == '/blog') {
      return (200, SiteHtml.blog(l, await siteArticles(session, l)), page);
    }
    if (page.startsWith('/blog/')) {
      final slug = page.substring('/blog/'.length);
      final articles = await siteArticles(session, l);
      for (final a in articles) {
        if (a.slug == slug) {
          return (
            200,
            SiteHtml.article(
              l,
              a,
              appStore: stores.$1,
              googlePlay: stores.$2,
            ),
            page,
          );
        }
      }
      return (404, SiteHtml.notFound(l), '404');
    }
    if (page == '/privacy' || page == '/terms') {
      final doc = page.substring(1);
      return (
        200,
        SiteHtml.legal(l, doc, legalHtml(config.legal, doc, l)),
        page,
      );
    }
    return (404, SiteHtml.notFound(l), '404');
  }
}

/// What a page request brings that the site uses.
class SiteVisit {
  const SiteVisit({
    required this.path,
    this.query = const {},
    this.counted = true,
    this.userAgent = '',
    this.forwardedFor,
    this.remote,
    this.referer,
  });

  final String path;
  final Map<String, String> query;

  /// A GET (a HEAD is not counted).
  final bool counted;
  final String userAgent;
  final String? forwardedFor;
  final String? remote;
  final String? referer;
}

/// The published articles in [language] that the website may show:
/// visible, and not limited to a country (the website does not know its
/// visitors' country; owner, 2026-11-27).
Future<List<SiteArticle>> siteArticles(Session session, String language) async {
  final items = await ContentEndpoint().published(session, 'article');
  return [
    for (final i in items)
      if (!i.hidden) ?_article(i, language),
  ];
}

SiteArticle? _article(PublicContent item, String language) {
  final data = (jsonDecode(item.json) as Map).cast<String, Object?>();
  if (!ContentRules.shownInCountry(data, null)) return null;
  final title = ContentRules.pick(data['title'], language);
  final body = ContentRules.pick(data['body'], language);
  if (title.isEmpty || body.isEmpty) return null;
  String alt(String? altJson) {
    if (altJson == null) return '';
    try {
      return ContentRules.pick(jsonDecode(altJson), language);
    } on Object {
      return '';
    }
  }

  return SiteArticle(
    slug: item.slug,
    category: item.category,
    title: title,
    summary: ContentRules.pick(data['summary'], language),
    body: body,
    minutes: data['minutes'] is int ? data['minutes'] as int : null,
    imageUrl: item.image?.url,
    imageAlt: alt(item.image?.altJson),
    sources: [
      for (final s in (data['sources'] as List? ?? const []))
        if (s is String && s.startsWith('https://')) s,
    ],
    inlineImages: {
      for (final img in item.inlineImages ?? const <PublicImage>[])
        if (img.id != null) img.id!: (img.url, alt(img.altJson)),
    },
    publishedAt: item.publishedAt,
  );
}

/// The legal document [doc] in [language] (else Azerbaijani, the
/// governing text) as HTML, or `null` when none is ready.
String? legalHtml(Directory dir, String doc, String language) {
  final Map<String, String>? company;
  try {
    company = LegalTexts.company(
      jsonDecode(File('${dir.path}/company.json').readAsStringSync()),
    );
  } on Object {
    return null;
  }
  if (company == null) return null;
  for (final l in {language, 'az'}) {
    final file = File('${dir.path}/$doc.$l.md');
    if (!file.existsSync()) continue;
    final text = LegalTexts.fill(file.readAsStringSync(), company);
    if (!LegalTexts.isReady(text)) continue;
    // Links between the documents (`terms.az.md`) go to the site's pages.
    final linked = text.replaceAllMapped(
      RegExp(r'\]\((privacy|terms)\.(az|ru|en)\.md\)'),
      (m) =>
          '](${SiteHtml.origin}${SiteHtml.pathIn(m.group(2)!, '/${m.group(1)}')})',
    );
    return SiteHtml.markdown(linked, const {});
  }
  return null;
}

/// `POST /site/e`: a click or reading depth the page reports, as
/// `kind|key|path` (plain text, at most 200 bytes). Answers 204 always.
class SiteEventRoute extends Route {
  SiteEventRoute() : super(methods: {Method.post});

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final ua = request.headers['user-agent']?.join(',') ?? '';
    if (!SiteStats.isBot(ua)) {
      try {
        final body = await request.readAsString(maxLength: 200);
        final parts = body.split('|');
        if (parts.length == 3) {
          final (_, page) = SitePageRoute.split(Uri.parse(parts[2]).path);
          await SiteStats.recordEvent(
            session,
            kind: parts[0],
            key: parts[1],
            page: _pageKey(page),
          );
        }
      } on Object {
        // A malformed report is ignored.
      }
    }
    return Response(204, headers: siteHeaders(maxAge: Duration.zero));
  }

  static String _pageKey(String page) {
    if (page == '/' ||
        page == '/blog' ||
        page == '/privacy' ||
        page == '/terms') {
      return page;
    }
    final m = RegExp(r'^/blog/([a-z0-9-]{1,80})$').firstMatch(page);
    return m == null ? 'other' : '/blog/${m.group(1)}';
  }
}

/// `/site/assets/*`: the site's CSS, script, fonts and pictures.
class SiteAssetsRoute extends Route {
  SiteAssetsRoute(Directory directory)
    : _handler = StaticHandler.directory(
        directory,
        cacheControl: (_, _) => CacheControlHeader(
          publicCache: true,
          maxAge: const Duration(hours: 1).inSeconds,
        ),
      ).asHandler,
      super(methods: {Method.get, Method.head}, path: '/**');

  final Handler _handler;

  @override
  Future<Result> call(Request req) async => _handler(req);

  @override
  Future<Result> handleCall(Session session, Request request) async =>
      _handler(request);
}

/// `/robots.txt`.
class SiteRobotsRoute extends Route {
  SiteRobotsRoute() : super(methods: {Method.get, Method.head});

  static const text =
      'User-agent: *\n'
      'Disallow: /admin\n'
      'Disallow: /shop\n'
      'Sitemap: ${SiteHtml.origin}/sitemap.xml\n';

  @override
  Future<Result> call(Request req) async => _ok();

  @override
  Future<Result> handleCall(Session session, Request request) async => _ok();

  Response _ok() => Response.ok(
    body: Body.fromString(text, mimeType: MimeType.plainText),
    headers: siteHeaders(maxAge: const Duration(hours: 1)),
  );
}

/// `/sitemap.xml`: the pages and published articles in every language.
class SiteMapRoute extends Route {
  SiteMapRoute() : super(methods: {Method.get, Method.head});

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final articles = await siteArticles(session, 'az');
    final paths = [
      '/',
      '/blog',
      '/privacy',
      '/terms',
      for (final a in articles) '/blog/${a.slug}',
    ];
    final urls = [
      for (final p in paths)
        for (final l in siteLanguages)
          '<url><loc>${SiteHtml.origin}${SiteHtml.pathIn(l, p)}</loc></url>',
    ];
    final xml =
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
        '${urls.join('\n')}\n</urlset>\n';
    return Response.ok(
      body: Body.fromString(xml, mimeType: MimeType.xml),
      headers: siteHeaders(maxAge: const Duration(hours: 1)),
    );
  }
}
