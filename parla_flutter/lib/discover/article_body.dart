import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../services/parla_api.dart';
import '../ui/brand.dart';
import 'discover_screens.dart';
import 'discover_widgets.dart';

/// An article's text in Markdown. HTML is not rendered; images come only
/// from the team's published uploads (`media:<id>`); links open outside
/// the app and only when they are https.
class ArticleBody extends StatelessWidget {
  const ArticleBody({super.key, required this.item, required this.markdown});

  final PublishedItem item;
  final String markdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final images = {
      for (final i in item.inlineImages)
        if (i.id != null) i.id!: i,
    };
    return MarkdownBody(
      data: markdown,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        p: text.bodyLarge,
        h1: text.headlineSmall,
        h2: text.titleLarge,
        h3: text.titleMedium,
        h4: text.titleSmall,
        blockSpacing: 12,
        listBullet: text.bodyLarge,
        blockquoteDecoration: BoxDecoration(
          color: ParlaColors.lemon,
          borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        ),
        blockquotePadding: const EdgeInsets.all(12),
        a: text.bodyLarge?.copyWith(
          color: ParlaColors.sunInk,
          decoration: TextDecoration.underline,
        ),
      ),
      onTapLink: (text, href, title) {
        final uri = href == null ? null : Uri.tryParse(href);
        if (uri != null && uri.scheme == 'https') ExpertsScreen.launcher(uri);
      },
      imageBuilder: (uri, title, alt) {
        final m = RegExp(r'^media:(\d+)$').firstMatch('$uri');
        final image = m == null ? null : images[int.parse(m.group(1)!)];
        if (image == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ContentImage(image: image),
        );
      },
    );
  }
}

/// The article's hashtags; tapping one lists the articles that have it.
class ArticleTags extends StatelessWidget {
  const ArticleTags({super.key, required this.tags, required this.onTap});

  final List<String> tags;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [
      for (final t in tags)
        ActionChip(
          key: ValueKey('tag-$t'),
          label: Text('#$t'),
          onPressed: () => onTap(t),
        ),
    ],
  );
}
