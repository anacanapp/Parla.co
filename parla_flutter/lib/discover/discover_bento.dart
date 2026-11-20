import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'discover_widgets.dart';

/// One section of the Discover bento.
class BentoSection {
  const BentoSection({
    required this.title,
    required this.hint,
    required this.color,
    required this.icon,
    required this.onTap,
    this.soon = false,
  });

  final String title;
  final String hint;
  final Color color;
  final ParlaIconName icon;
  final VoidCallback onTap;
  final bool soon;
}

/// The Discover sections as a bento (approved prototype A, 2026-11-20):
/// a wide Blogs tile, a tall Nutrition tile beside Sport and Experts, and
/// two small tiles for the shopping list and the shop. Tiles grow with the
/// user's text size instead of clipping.
class DiscoverBento extends StatelessWidget {
  const DiscoverBento({
    super.key,
    required this.blogs,
    required this.nutrition,
    required this.sport,
    required this.experts,
    required this.shopping,
    required this.shop,
    this.blogsImage,
    this.nutritionImage,
  });

  final BentoSection blogs;
  final BentoSection nutrition;
  final BentoSection sport;
  final BentoSection experts;
  final BentoSection shopping;
  final BentoSection shop;

  /// Cover of the newest article and recipe that have one.
  final ContentImageRef? blogsImage;
  final ContentImageRef? nutritionImage;

  static const _gap = 10.0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Tile(
          section: blogs,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 168),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ParlaIcon(blogs.icon, size: 22),
                          const SizedBox(height: 20),
                          _Labels(
                            section: blogs,
                            titleStyle: text.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 132,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _Photo(
                        image: blogsImage,
                        icon: blogs.icon,
                        color: const Color(0xFFDCD0EC),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: _gap),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Tile(
                  section: nutrition,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: SizedBox(
                          height: 128,
                          child: _Photo(
                            image: nutritionImage,
                            icon: nutrition.icon,
                            color: const Color(0xFFCFDDC7),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                        child: _Labels(section: nutrition),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: _gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _MediumTile(section: sport, dark: true)),
                    const SizedBox(height: _gap),
                    Expanded(child: _MediumTile(section: experts)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: _gap),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _SmallTile(section: shopping)),
              const SizedBox(width: _gap),
              Expanded(child: _SmallTile(section: shop)),
            ],
          ),
        ),
      ],
    );
  }
}

/// A tappable tile: one button for screen readers with its title, hint
/// and "soon" mark.
class _Tile extends StatelessWidget {
  const _Tile({required this.section, required this.child});

  final BentoSection section;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final radius = BorderRadius.circular(22);
    return Semantics(
      container: true,
      button: true,
      label: section.soon
          ? '${section.title}. ${section.hint}. ${l10n.soonBadge}'
          : '${section.title}. ${section.hint}',
      excludeSemantics: true,
      child: Material(
        color: section.color,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: section.onTap, child: child),
      ),
    );
  }
}

class _Labels extends StatelessWidget {
  const _Labels({
    required this.section,
    this.titleStyle,
    this.titleColor = ParlaColors.espresso,
    this.hintColor = ParlaColors.muted,
  });

  final BentoSection section;
  final TextStyle? titleStyle;
  final Color titleColor;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          section.title,
          style: (titleStyle ?? text.titleLarge)?.copyWith(color: titleColor),
        ),
        const SizedBox(height: 2),
        Text(
          section.hint,
          style: text.bodySmall?.copyWith(color: hintColor),
        ),
      ],
    );
  }
}

class _MediumTile extends StatelessWidget {
  const _MediumTile({required this.section, this.dark = false});

  final BentoSection section;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return _Tile(
      section: section,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ParlaIcon(
              section.icon,
              size: 22,
              color: dark ? ParlaColors.sportBlueText : ParlaColors.espresso,
            ),
            const SizedBox(height: 18),
            _Labels(
              section: section,
              titleColor: dark ? ParlaColors.white : ParlaColors.espresso,
              hintColor: dark ? ParlaColors.sportBlueText : ParlaColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallTile extends StatelessWidget {
  const _SmallTile({required this.section});

  final BentoSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return _Tile(
      section: section,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              ParlaIcon(section.icon, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(section.title, style: text.titleMedium)),
              if (section.soon) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: ParlaColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      l10n.soonBadge,
                      style: text.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A cover image, or a tinted block with the section's icon until the team
/// uploads one.
class _Photo extends StatelessWidget {
  const _Photo({required this.image, required this.icon, required this.color});

  final ContentImageRef? image;
  final ParlaIconName icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (image case final image?) {
      return ContentImage(image: image, radius: 16, aspectRatio: 1);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: ParlaIcon(icon, size: 32, color: ParlaColors.sunInk),
      ),
    );
  }
}

/// A compact row for the newest articles on Discover: thumbnail, category
/// and reading time, title.
class ArticleRow extends StatelessWidget {
  const ArticleRow({super.key, required this.item, required this.onTap});

  final PublishedItem item;
  final VoidCallback onTap;

  static const _tints = [
    ParlaColors.blush,
    ParlaColors.lemon,
    ParlaColors.sageTint,
    ParlaColors.lilac,
    ParlaColors.sky,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final minutes = (item.data['minutes'] as num?)?.toInt() ?? 1;
    final tint = _tints[item.slug.hashCode.abs() % _tints.length];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: ParlaColors.white,
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('article-${item.slug}'),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SizedBox(
                  width: 84,
                  height: 84,
                  child: item.image != null
                      ? ContentImage(
                          image: item.image!,
                          radius: 14,
                          aspectRatio: 1,
                        )
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            color: tint,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: ParlaIcon(
                              ParlaIconName.book,
                              size: 26,
                              color: ParlaColors.sunInk,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n
                            .blogMeta(
                              categoryText(l10n, item.category),
                              minutes,
                            )
                            .toUpperCase(),
                        style: text.labelMedium?.copyWith(
                          color: ParlaColors.sunInk,
                          letterSpacing: .6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.text('title', language),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
