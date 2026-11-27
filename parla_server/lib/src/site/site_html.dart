import 'package:markdown/markdown.dart' as md;

import 'site_texts.dart';

/// The public website's pages, rendered on the server as plain HTML (no
/// framework, no third-party resources, no cookies). Everything a page
/// shows is escaped here; article bodies are Markdown without raw HTML.
abstract final class SiteHtml {
  /// The site's canonical origin (links in the sitemap and meta tags).
  static const origin = 'https://parla.anacan.az';

  /// The path of [path] (`/`, `/blog`, …) in [language].
  static String pathIn(String language, String path) {
    if (language == 'az') return path;
    return path == '/' ? '/$language' : '/$language$path';
  }

  /// [text] safe for HTML text and attribute values.
  static String esc(String text) => text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');

  static String _t(String key, String l) => esc(siteText(key, l));

  /// The whole page around [main].
  static String page({
    required String language,
    required String path,
    required String title,
    required String description,
    required String main,
    bool index = true,
    String? image,
  }) {
    final alternates = [
      for (final l in siteLanguages)
        '<link rel="alternate" hreflang="$l" '
            'href="$origin${pathIn(l, path)}">',
      '<link rel="alternate" hreflang="x-default" href="$origin$path">',
    ].join('\n');
    final canonical = '$origin${pathIn(language, path)}';
    return '''<!doctype html>
<html lang="$language">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)}</title>
<meta name="description" content="${esc(description)}">
${index ? '' : '<meta name="robots" content="noindex">\n'}<link rel="canonical" href="$canonical">
$alternates
<meta property="og:type" content="website">
<meta property="og:title" content="${esc(title)}">
<meta property="og:description" content="${esc(description)}">
<meta property="og:url" content="$canonical">
<meta property="og:image" content="${esc(image ?? '$origin/site/assets/og.jpg')}">
<meta name="theme-color" content="#F7F3F1">
<link rel="icon" href="/site/assets/icon.png">
<link rel="stylesheet" href="/site/assets/site.css">
<script src="/site/assets/site.js" defer></script>
</head>
<body>
<div class="wash" aria-hidden="true"><i class="w1"></i><i class="w2"></i><i class="w3"></i></div>
${_nav(language, path)}
<main>
$main
</main>
${_footer(language, path)}
</body>
</html>
''';
  }

  static String _nav(String l, String path) {
    final langs = [
      for (final o in siteLanguages)
        o == l
            ? '<span class="on">${o.toUpperCase()}</span>'
            : '<a href="${pathIn(o, path)}" hreflang="$o" '
                  'data-track="lang-$o">${o.toUpperCase()}</a>',
    ].join('');
    return '''<header class="wrap nav">
<a class="logo" href="${pathIn(l, '/')}"><img src="/site/assets/icon.png" alt="" width="36" height="36">Parla</a>
<nav class="links">
<a href="${pathIn(l, '/')}#features" data-track="nav-features">${_t('navFeatures', l)}</a>
<a href="${pathIn(l, '/')}#privacy" data-track="nav-privacy">${_t('navPrivacy', l)}</a>
<a href="${pathIn(l, '/blog')}" data-track="nav-blog">${_t('navBlog', l)}</a>
<span class="langs">$langs</span>
</nav>
</header>''';
  }

  static String _footer(String l, String path) =>
      '''<footer class="wrap foot">
<div><b>Parla</b> — "ANACAN" Məhdud Məsuliyyətli Cəmiyyəti<br>${_t('taxId', l)} 1407578211 · Şamil Əzizbəyov 150, Bakı, Azərbaycan<br>${_t('dpo', l)}: Türkan Sultanlı · <a href="mailto:info@anacan.az">info@anacan.az</a></div>
<div><b>${_t('docs', l)}</b><br><a href="${pathIn(l, '/privacy')}" data-track="legal-privacy">${_t('privacyPolicy', l)}</a><br><a href="${pathIn(l, '/terms')}" data-track="legal-terms">${_t('terms', l)}</a></div>
<div><b>${_t('language', l)}</b><br>${[
        for (final o in siteLanguages) '<a href="${pathIn(o, path)}" hreflang="$o" data-track="lang-$o">${const {'az': 'Azərbaycan', 'ru': 'Русский', 'en': 'English'}[o]}</a>',
      ].join(' · ')}</div>
</footer>''';

  /// The App Store and Google Play buttons; a button without its store
  /// link is shown but not a link yet (owner: no "coming soon" text).
  static String stores(String l, {String? appStore, String? googlePlay}) {
    String button(String label, String track, String? url, String mark) {
      final inner =
          '<span class="mark" aria-hidden="true">$mark</span><span><small>${_t('storeGet', l)}</small>$label</span>';
      return url == null
          ? '<span class="store" aria-disabled="true">$inner</span>'
          : '<a class="store" href="${esc(url)}" rel="noopener" data-track="$track">$inner</a>';
    }

    return '<div class="stores">'
        '${button('App Store', 'appstore', appStore, '')}'
        '${button('Google Play', 'googleplay', googlePlay, '')}'
        '</div>';
  }

  /// The home page.
  static String home(
    String l,
    List<SiteArticle> latest, {
    String? appStore,
    String? googlePlay,
  }) {
    final shots = l == 'az' ? 'az' : l;
    final privacyItems = [
      for (final i in [1, 2, 3, 4])
        '<li><span class="tick" aria-hidden="true">✓</span><span><b>${_t('p${i}Bold', l)}</b> ${_t('p$i', l)}</span></li>',
    ].join('\n');
    final features = [
      for (final i in [1, 2, 3])
        '<div class="card"><div class="dot d$i"></div><h3>${_t('f${i}Title', l)}</h3><p>${_t('f${i}Body', l)}</p></div>',
    ].join('\n');
    final main =
        '''<section class="wrap hero">
<div>
<span class="pill">${_t('heroPill', l)}</span>
<h1>${_t('heroBefore', l)}<em>${_t('heroAccent', l)}</em>${_t('heroAfter', l)}</h1>
<p class="lead">${_t('description', l)}</p>
${stores(l, appStore: appStore, googlePlay: googlePlay)}
<p class="soon">${_t('languagesNote', l)}</p>
</div>
<div class="phones" aria-hidden="true">
<div class="phone p1"><img src="/site/assets/shot-check-$shots.jpg" alt="" width="390" height="844"></div>
<div class="phone p2"><img src="/site/assets/shot-home-$shots.jpg" alt="" width="390" height="844"></div>
</div>
</section>
<section class="wrap sec" id="features">
<h2>${_t('featuresTitle', l)}</h2>
<div class="grid">
$features
</div>
</section>
<section class="wrap sec" id="privacy">
<div class="priv">
<div>
<span class="pill">${_t('privacyPill', l)}</span>
<h2>${_t('privacyTitle', l)}</h2>
<p class="plead">${_t('privacyLead', l)}</p>
</div>
<ul>
$privacyItems
</ul>
</div>
</section>
${latest.isEmpty ? '' : '''<section class="wrap sec">
<div class="sechead"><h2>${_t('blogTitle', l)}</h2><a href="${pathIn(l, '/blog')}" data-track="blog-all">${_t('blogAll', l)} →</a></div>
<div class="blog">
${latest.map((a) => card(l, a)).join('\n')}
</div>
<p class="note">${_t('disclaimer', l)}</p>
</section>'''}''';
    return page(
      language: l,
      path: '/',
      title: siteText('title', l),
      description: siteText('description', l),
      main: main,
    );
  }

  /// An article's card in a list.
  static String card(String l, SiteArticle a) {
    final cover = a.imageUrl == null
        ? '<div class="img g${a.slug.length % 3}"></div>'
        : '<img class="img" src="${esc(a.imageUrl!)}" alt="${esc(a.imageAlt ?? '')}" loading="lazy">';
    return '''<a class="post" href="${pathIn(l, '/blog/${a.slug}')}" data-track="blog-card">$cover<div class="t"><span>${esc(category(a.category, l))} · ${esc(minutes(a.minutes, l))}</span><h3>${esc(a.title)}</h3><p>${esc(a.summary)}</p></div></a>''';
  }

  /// The category's name.
  static String category(String id, String l) {
    final key =
        'cat${id.isEmpty ? '' : id[0].toUpperCase()}${id.length > 1 ? id.substring(1) : ''}';
    final name = siteText(key, l);
    return name == key ? id : name;
  }

  static String minutes(int? n, String l) =>
      n == null ? '' : siteText('minutes', l).replaceAll('{n}', '$n');

  /// The blog's list.
  static String blog(String l, List<SiteArticle> articles) {
    final list = articles.isEmpty
        ? '<p class="lead">${_t('blogEmpty', l)}</p>'
        : '<div class="blog">\n${articles.map((a) => card(l, a)).join('\n')}\n</div>';
    final main =
        '''<section class="wrap sec top">
<h1 class="h1s">${_t('blogPageTitle', l)}</h1>
<p class="lead">${_t('blogPageLead', l)}</p>
$list
<p class="note">${_t('disclaimer', l)}</p>
</section>''';
    return page(
      language: l,
      path: '/blog',
      title: '${siteText('blogPageTitle', l)} — Parla',
      description: siteText('blogPageLead', l),
      main: main,
    );
  }

  /// One article.
  static String article(
    String l,
    SiteArticle a, {
    String? appStore,
    String? googlePlay,
  }) {
    final cover = a.imageUrl == null
        ? ''
        : '<img class="cover" src="${esc(a.imageUrl!)}" alt="${esc(a.imageAlt ?? '')}">';
    final sources = a.sources.isEmpty
        ? ''
        : '<h2>${_t('sources', l)}</h2><ol class="sources">${a.sources.map((s) => '<li><a href="${esc(s)}" rel="noopener nofollow" target="_blank">${esc(Uri.tryParse(s)?.host ?? s)}</a></li>').join()}</ol>';
    final main =
        '''<article class="wrap art">
<a class="back" href="${pathIn(l, '/blog')}">${_t('backToBlog', l)}</a>
<span class="meta">${esc(category(a.category, l))} · ${esc(minutes(a.minutes, l))}</span>
<h1 class="h1s">${esc(a.title)}</h1>
<p class="lead">${esc(a.summary)}</p>
$cover
<div class="body">
${markdown(a.body, a.inlineImages)}
</div>
$sources
<div class="cta"><b>${_t('articleCta', l)}</b>${stores(l, appStore: appStore, googlePlay: googlePlay)}</div>
<p class="note">${_t('disclaimer', l)}</p>
</article>''';
    return page(
      language: l,
      path: '/blog/${a.slug}',
      title: '${a.title} — Parla',
      description: a.summary,
      main: main,
      image: a.imageUrl,
    );
  }

  /// The privacy policy or the terms ([html] is the filled document, or
  /// `null` when none is ready). The privacy page starts with the
  /// website's own notice.
  static String legal(String l, String doc, String? html) {
    final privacy = doc == 'privacy';
    final notice = privacy
        ? '<section class="notice"><h2>${_t('siteNoticeTitle', l)}</h2><p>${_t('siteNotice', l)}</p></section>'
        : '';
    final main =
        '''<article class="wrap art legal">
$notice
${html ?? '<h1 class="h1s">${_t(privacy ? 'privacyPolicy' : 'terms', l)}</h1><p class="lead">${_t('legalMissing', l)}</p>'}
</article>''';
    return page(
      language: l,
      path: '/$doc',
      title: '${siteText(privacy ? 'privacyPolicy' : 'terms', l)} — Parla',
      description: siteText(privacy ? 'privacyPolicy' : 'terms', l),
      main: main,
    );
  }

  /// The not-found page.
  static String notFound(String l) => page(
    language: l,
    path: '/',
    title: '${siteText('notFound', l)} — Parla',
    description: siteText('notFound', l),
    index: false,
    main:
        '<section class="wrap sec top"><h1 class="h1s">404</h1><p class="lead">${_t('notFound', l)}</p><p><a href="${pathIn(l, '/')}">${_t('home', l)}</a></p></section>',
  );

  /// [source] Markdown as HTML: raw HTML is shown as text, links are kept
  /// only to https:// addresses and open in a new tab, and images only
  /// from [images] (`media:<id>` → url, alt).
  static String markdown(
    String source,
    Map<int, (String, String)> images,
  ) {
    final doc = md.Document(encodeHtml: true);
    final nodes = doc.parse(source.replaceAll('<', '&lt;'));
    return md.HtmlRenderer().render(_safe(nodes, images));
  }

  static List<md.Node> _safe(
    List<md.Node> nodes,
    Map<int, (String, String)> images,
  ) {
    final out = <md.Node>[];
    for (final n in nodes) {
      if (n is! md.Element) {
        out.add(n);
        continue;
      }
      final children = n.children == null ? null : _safe(n.children!, images);
      if (n.tag == 'img') {
        final m = RegExp(
          r'^media:(\d+)$',
        ).firstMatch(n.attributes['src'] ?? '');
        final image = m == null ? null : images[int.parse(m.group(1)!)];
        if (image == null) continue;
        out.add(
          md.Element.empty('img')
            ..attributes['src'] = image.$1
            ..attributes['alt'] = image.$2
            ..attributes['loading'] = 'lazy',
        );
        continue;
      }
      if (n.tag == 'a') {
        final href = n.attributes['href'] ?? '';
        if (!href.startsWith('https://')) {
          out.addAll(children ?? const []);
          continue;
        }
        out.add(
          md.Element('a', children)
            ..attributes['href'] = href
            ..attributes['rel'] = 'noopener nofollow'
            ..attributes['target'] = '_blank',
        );
        continue;
      }
      final copy = children == null
          ? md.Element.empty(n.tag)
          : md.Element(n.tag, children);
      for (final e in n.attributes.entries) {
        if (e.key == 'id' || e.key == 'class' || e.key == 'start') {
          copy.attributes[e.key] = e.value;
        }
      }
      out.add(copy);
    }
    return out;
  }
}

/// A published article as the website shows it, in one language.
class SiteArticle {
  const SiteArticle({
    required this.slug,
    required this.category,
    required this.title,
    required this.summary,
    required this.body,
    this.minutes,
    this.imageUrl,
    this.imageAlt,
    this.sources = const [],
    this.inlineImages = const {},
    this.publishedAt,
  });

  final String slug;
  final String category;
  final String title;
  final String summary;
  final String body;
  final int? minutes;
  final String? imageUrl;
  final String? imageAlt;
  final List<String> sources;
  final Map<int, (String, String)> inlineImages;
  final DateTime? publishedAt;
}
