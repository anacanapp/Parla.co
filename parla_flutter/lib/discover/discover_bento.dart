import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import '../ui/parla_ui.dart';
import 'blog_widgets.dart';
import 'discover_widgets.dart';

/// One section of the Discover bento.
class BentoSection {
  const BentoSection({
    required this.title,
    required this.hint,
    required this.color,
    required this.icon,
    required this.onTap,
    this.id,
    this.soon = false,
  });

  /// Names the tile for tests (`discover-<id>`).
  final String? id;
  final String title;
  final String hint;
  final Color color;
  final ParlaIconName icon;
  final VoidCallback onTap;
  final bool soon;
}

/// The Discover sections (Parla 2.0): a dark Blogs hero with the newest
/// cover, a 2×2 grid (sport, nutrition, experts, shop) and capsule rows
/// for the shopping list and the journal. Tiles grow with the user's text
/// size instead of clipping.
class DiscoverBento extends StatelessWidget {
  const DiscoverBento({
    super.key,
    required this.blogs,
    required this.nutrition,
    required this.sport,
    required this.experts,
    required this.shopping,
    required this.shop,
    required this.journal,
    this.blogsImage,
  });

  final BentoSection blogs;
  final BentoSection nutrition;
  final BentoSection sport;
  final BentoSection experts;
  final BentoSection shopping;
  final BentoSection shop;
  final BentoSection journal;

  /// Cover of the newest article that has one.
  final ContentImageRef? blogsImage;

  static const _gap = 10.0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Tile(
          section: blogs,
          radius: ParlaShape.card + 4,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.8, -0.9),
                radius: 1.1,
                colors: [Color(0x66D62EA0), Color(0x00D62EA0)],
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 200),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 8, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _IconBubble(
                              icon: blogs.icon,
                              background: const Color(0x29F4E9FF),
                              color: ParlaColors.espresso,
                            ),
                            const SizedBox(height: 24),
                            _Labels(
                              section: blogs,
                              titleStyle: text.headlineSmall,
                              titleColor: ParlaColors.espresso,
                              hintColor: ParlaColors.muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: blogsImage == null
                            ? const _CapsuleArt()
                            : ContentImage(
                                image: blogsImage!,
                                radius: ParlaShape.tile,
                                aspectRatio: 0.8,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: _gap),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _GridTile(section: sport, dark: true)),
              const SizedBox(width: _gap),
              Expanded(child: _GridTile(section: nutrition)),
            ],
          ),
        ),
        const SizedBox(height: _gap),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _GridTile(section: experts)),
              const SizedBox(width: _gap),
              Expanded(child: _GridTile(section: shop)),
            ],
          ),
        ),
        const SizedBox(height: _gap),
        _PillRow(section: shopping),
        const SizedBox(height: _gap),
        _PillRow(section: journal),
      ],
    );
  }
}

/// A round icon on a tile.
class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    this.background = ParlaColors.white,
    this.color = ParlaColors.espresso,
  });

  final ParlaIconName icon;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(color: background, shape: BoxShape.circle),
    alignment: Alignment.center,
    child: ParlaIcon(icon, size: 20, color: color),
  );
}

/// Four tilted capsules in the brand's colours, until a cover exists.
class _CapsuleArt extends StatelessWidget {
  const _CapsuleArt();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Center(
      child: Transform.rotate(
        angle: -0.21,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final c in const [
              ParlaColors.cream,
              ParlaColors.sun,
              ParlaColors.sky,
              ParlaColors.sage,
            ])
              Container(
                width: 104,
                height: 26,
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: ShapeDecoration(
                  color: c,
                  shape: const StadiumBorder(),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// A square-ish tile of the 2×2 grid: icon, title and hint.
class _GridTile extends StatelessWidget {
  const _GridTile({required this.section, this.dark = false});

  final BentoSection section;
  final bool dark;

  @override
  Widget build(BuildContext context) => _Tile(
    section: section,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _IconBubble(
              icon: section.icon,
              background: dark ? const Color(0x24F4E9FF) : ParlaColors.white,
              color: dark ? ParlaColors.sportBlueText : ParlaColors.espresso,
            ),
            const SizedBox(height: 18),
            _Labels(
              section: section,
              titleStyle: Theme.of(context).textTheme.titleMedium,
              titleColor: dark
                  ? ParlaColors.sportBlueText
                  : ParlaColors.espresso,
              hintColor: dark ? ParlaColors.sportBlueText : ParlaColors.muted,
            ),
          ],
        ),
      ),
    ),
  );
}

/// A white capsule row: icon, title and hint, and a dark round arrow.
class _PillRow extends StatelessWidget {
  const _PillRow({required this.section});

  final BentoSection section;

  @override
  Widget build(BuildContext context) => _Tile(
    section: section,
    radius: ParlaShape.pill,
    border: const BorderSide(color: ParlaColors.line),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _IconBubble(icon: section.icon, background: ParlaColors.cream),
          const SizedBox(width: 12),
          Expanded(child: _Labels(section: section)),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: ParlaColors.espresso,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const ParlaIcon(
              ParlaIconName.arrowRight,
              size: 18,
              color: ParlaColors.cream,
            ),
          ),
        ],
      ),
    ),
  );
}

/// A tappable tile: one button for screen readers with its title, hint
/// and "soon" mark.
class _Tile extends StatelessWidget {
  const _Tile({
    required this.section,
    required this.child,
    this.radius = ParlaShape.card,
    this.border,
  });

  final BentoSection section;
  final Widget child;
  final double radius;
  final BorderSide? border;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: border ?? BorderSide.none,
    );
    return Semantics(
      key: section.id == null ? null : ValueKey('discover-${section.id}'),
      container: true,
      button: true,
      label: section.soon
          ? '${section.title}. ${section.hint}. ${l10n.soonBadge}'
          : '${section.title}. ${section.hint}',
      excludeSemantics: true,
      child: Material(
        color: section.color,
        shape: shape,
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

/// A compact row for an article or a recipe: square cover, the kicker
/// (category and minutes, or the recipe's meta) and the title.
class ArticleRow extends StatelessWidget {
  const ArticleRow({
    super.key,
    required this.item,
    required this.onTap,
    this.meta,
  });

  final PublishedItem item;
  final VoidCallback onTap;

  /// The line above the title; the article kicker when `null`.
  final String? meta;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: ParlaColors.white,
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('${item.kind}-${item.slug}'),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SizedBox(
                  width: 84,
                  child: ArticleCover(
                    item: item,
                    radius: 14,
                    aspectRatio: 1,
                    iconSize: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (meta case final meta?)
                        Text(
                          meta.toUpperCase(),
                          style: text.labelMedium?.copyWith(
                            color: ParlaColors.sunInk,
                            letterSpacing: .6,
                          ),
                        )
                      else
                        ArticleKicker(item: item),
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
