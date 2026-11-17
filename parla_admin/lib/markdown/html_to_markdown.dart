import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

/// Turns HTML copied from Google Docs (or a web page) into the Markdown the
/// app shows: headings, paragraphs, bold, italic, lists, quotes and https
/// links. Everything else (styles, colours, fonts, images, scripts) is
/// dropped. Images are not taken over: they are uploaded in the panel.
String htmlToMarkdown(String source) {
  final doc = html.parse(source);
  final out = StringBuffer();
  _blocks(doc.body?.nodes ?? doc.nodes, out, listDepth: 0);
  return cleanMarkdown(out.toString());
}

/// Cleans pasted or typed text: Windows line ends, invisible characters,
/// non-breaking spaces, "●"/"•" bullets, and runs of blank lines.
String cleanMarkdown(String text) {
  var t = text
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .replaceAll(RegExp('[​‌‍⁠﻿]'), '')
      .replaceAll(' ', ' ')
      .replaceAll('\u000B', '\n');
  t = t.replaceAllMapped(
    RegExp(r'^([ \t]*)[●•◦▪■–]\s+', multiLine: true),
    (m) => '${m.group(1)}- ',
  );
  t = t.replaceAll(RegExp(r'[ \t]+$', multiLine: true), '');
  t = t.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return t.trim();
}

bool _isBold(Element e) {
  final tag = e.localName;
  if (tag == 'strong') return true;
  final style = (e.attributes['style'] ?? '').replaceAll(' ', '');
  final weight = RegExp(r'font-weight:(\d+|bold)').firstMatch(style);
  if (weight != null) {
    final w = weight.group(1)!;
    return w == 'bold' || (int.tryParse(w) ?? 400) >= 600;
  }
  // Google Docs wraps everything in <b style="font-weight:normal">.
  return tag == 'b' && !style.contains('font-weight:normal');
}

bool _isItalic(Element e) {
  final style = (e.attributes['style'] ?? '').replaceAll(' ', '');
  return e.localName == 'em' ||
      e.localName == 'i' ||
      style.contains('font-style:italic');
}

String _inline(List<Node> nodes) {
  final b = StringBuffer();
  for (final n in nodes) {
    if (n is Text) {
      b.write(n.text.replaceAll(RegExp(r'\s+'), ' '));
    } else if (n is Element) {
      final tag = n.localName;
      if (tag == 'br') {
        b.write('\n');
        continue;
      }
      if (tag == 'img' || tag == 'script' || tag == 'style') continue;
      var inner = _inline(n.nodes);
      if (inner.trim().isEmpty) {
        b.write(inner);
        continue;
      }
      if (tag == 'a') {
        final href = n.attributes['href'] ?? '';
        final url = _unwrapGoogleLink(href);
        if (url.startsWith('https://')) inner = '[${inner.trim()}]($url)';
      }
      final bold = _isBold(n);
      final italic = _isItalic(n);
      if (bold || italic) {
        final lead = inner.startsWith(' ') ? ' ' : '';
        final trail = inner.endsWith(' ') ? ' ' : '';
        var core = inner.trim();
        if (italic) core = '*$core*';
        if (bold) core = '**$core**';
        inner = '$lead$core$trail';
      }
      b.write(inner);
    }
  }
  return b.toString();
}

/// Google Docs sometimes links through google.com/url?q=...
String _unwrapGoogleLink(String href) {
  final uri = Uri.tryParse(href);
  if (uri != null &&
      uri.host.endsWith('google.com') &&
      uri.path == '/url' &&
      uri.queryParameters['q'] != null) {
    return uri.queryParameters['q']!;
  }
  return href;
}

void _blocks(List<Node> nodes, StringBuffer out, {required int listDepth}) {
  for (final n in nodes) {
    if (n is Text) {
      final t = n.text.trim();
      if (t.isNotEmpty) out.write('$t\n\n');
      continue;
    }
    if (n is! Element) continue;
    final tag = n.localName;
    switch (tag) {
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        // Google Docs "Title"/H1 becomes ##: the article's title is separate.
        final level = (int.parse(tag!.substring(1)) + 1).clamp(2, 4);
        final text = _inline(n.nodes).replaceAll('**', '').trim();
        if (text.isNotEmpty) out.write('${'#' * level} $text\n\n');
      case 'p':
        final text = _inline(n.nodes).trim();
        if (text.isNotEmpty) out.write('$text\n\n');
      case 'blockquote':
        final inner = StringBuffer();
        _blocks(n.nodes, inner, listDepth: listDepth);
        final quoted = inner
            .toString()
            .trim()
            .split('\n')
            .map((l) => l.isEmpty ? '>' : '> $l')
            .join('\n');
        if (quoted.isNotEmpty) out.write('$quoted\n\n');
      case 'ul':
      case 'ol':
        var i = 1;
        for (final li in n.children.where((c) => c.localName == 'li')) {
          final marker = tag == 'ol' ? '${i++}.' : '-';
          final own = li.nodes
              .where(
                (c) =>
                    !(c is Element &&
                        (c.localName == 'ul' || c.localName == 'ol')),
              )
              .toList();
          final text = _inline(own).trim();
          out.write('${'  ' * listDepth}$marker $text\n');
          for (final sub in li.children.where(
            (c) => c.localName == 'ul' || c.localName == 'ol',
          )) {
            _blocks([sub], out, listDepth: listDepth + 1);
          }
        }
        if (listDepth == 0) out.write('\n');
      case 'br':
        out.write('\n');
      case 'img':
      case 'script':
      case 'style':
      case 'meta':
      case 'title':
        break;
      default:
        // div, span, b wrappers, tables: keep their text.
        final hasBlocks = n.children.any(
          (c) => const {
            'p',
            'h1',
            'h2',
            'h3',
            'h4',
            'ul',
            'ol',
            'div',
            'blockquote',
            'table',
          }.contains(c.localName),
        );
        if (hasBlocks) {
          _blocks(n.nodes, out, listDepth: listDepth);
        } else {
          final text = _inline([n]).trim();
          if (text.isNotEmpty) out.write('$text\n\n');
        }
    }
  }
}
