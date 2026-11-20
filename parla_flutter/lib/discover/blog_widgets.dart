import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'discover_widgets.dart';

/// The cover of an article, or a block in its category's tint with the
/// blog icon until the team uploads one.
class ArticleCover extends StatelessWidget {
  const ArticleCover({
    super.key,
    required this.item,
    this.radius = 0,
    this.height,
    this.aspectRatio = 4 / 3,
    this.iconSize = 34,
  });

  final PublishedItem item;
  final double radius;

  /// Fixed height of the placeholder; `null` follows [aspectRatio].
  final double? height;
  final double aspectRatio;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (item.image case final image?) {
      return ContentImage(
        image: image,
        radius: radius,
        aspectRatio: aspectRatio,
      );
    }
    final block = DecoratedBox(
      decoration: BoxDecoration(
        color: categoryTint(item.category),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: ParlaIcon(
          ParlaIconName.book,
          size: iconSize,
          color: ParlaColors.sunInk,
        ),
      ),
    );
    return height == null
        ? AspectRatio(aspectRatio: aspectRatio, child: block)
        : SizedBox(height: height, child: block);
  }
}

/// "CATEGORY · 5 MIN" above an article's title.
class ArticleKicker extends StatelessWidget {
  const ArticleKicker({super.key, required this.item});

  final PublishedItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final minutes = (item.data['minutes'] as num?)?.toInt() ?? 1;
    return Text(
      l10n.blogMeta(categoryText(l10n, item.category), minutes).toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: ParlaColors.sunInk,
        letterSpacing: .6,
      ),
    );
  }
}

/// The newest article at the top of the blog list: a large cover, title
/// and summary (approved prototype "Bloq 1", 2026-11-20).
class FeaturedArticleCard extends StatelessWidget {
  const FeaturedArticleCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final PublishedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final summary = item.text('summary', language);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Material(
        color: ParlaColors.white,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('article-${item.slug}'),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ArticleCover(item: item, aspectRatio: 16 / 10),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArticleKicker(item: item),
                    const SizedBox(height: 6),
                    Text(
                      item.text('title', language),
                      style: text.headlineSmall,
                    ),
                    if (summary.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        summary,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyMedium?.copyWith(
                          color: ParlaColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A related article at the end of a post: cover and title.
class RelatedArticleCard extends StatelessWidget {
  const RelatedArticleCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final PublishedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    return SizedBox(
      width: 150,
      child: InkWell(
        key: ValueKey('related-${item.slug}'),
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArticleCover(
              item: item,
              radius: 18,
              aspectRatio: 1,
              iconSize: 26,
            ),
            const SizedBox(height: 8),
            Text(
              item.text('title', language),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// The article's sources as pills with their site name; each opens in the
/// browser (approved prototype "Yazı 2", 2026-11-20).
class SourceChips extends StatelessWidget {
  const SourceChips({super.key, required this.sources, required this.onOpen});

  final List<Uri> sources;
  final void Function(Uri uri) onOpen;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final uri in sources)
          Material(
            color: ParlaColors.white,
            shape: const StadiumBorder(
              side: BorderSide(color: ParlaColors.line, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: ValueKey('blog-source-$uri'),
              onTap: () => onOpen(uri),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          uri.host.replaceFirst('www.', ''),
                          style: text.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.open_in_new,
                        size: 14,
                        color: ParlaColors.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
