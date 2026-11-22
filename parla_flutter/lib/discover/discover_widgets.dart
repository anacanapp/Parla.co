import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';

String categoryText(AppLocalizations l10n, String id) => switch (id) {
  'care' => l10n.catCare,
  'beauty' => l10n.catBeauty,
  'fashion' => l10n.catFashion,
  'hair' => l10n.catHair,
  'body' => l10n.catBody,
  'breakfast' => l10n.mealBreakfast,
  'lunch' => l10n.mealLunch,
  'dinner' => l10n.mealDinner,
  'snack' => l10n.mealSnack,
  'dermatologist' => l10n.specDermatologist,
  'cosmetologist' => l10n.specCosmetologist,
  'trainer' => l10n.specTrainer,
  'dietitian' => l10n.specDietitian,
  'trichologist' => l10n.specTrichologist,
  _ => id,
};

String allergenText(AppLocalizations l10n, String id) => switch (id) {
  'gluten' => l10n.allergenGluten,
  'crustaceans' => l10n.allergenCrustaceans,
  'egg' => l10n.allergenEgg,
  'fish' => l10n.allergenFish,
  'peanuts' => l10n.allergenPeanuts,
  'soy' => l10n.allergenSoy,
  'milk' => l10n.allergenMilk,
  'nuts' => l10n.allergenNuts,
  'celery' => l10n.allergenCelery,
  'mustard' => l10n.allergenMustard,
  'sesame' => l10n.allergenSesame,
  'sulphites' => l10n.allergenSulphites,
  'lupin' => l10n.allergenLupin,
  'molluscs' => l10n.allergenMolluscs,
  _ => id,
};

String groupText(AppLocalizations l10n, String id) => switch (id) {
  'vegetables' => l10n.groupVegetables,
  'fruit' => l10n.groupFruit,
  'protein' => l10n.groupProtein,
  'whole_grain' => l10n.groupWholeGrain,
  'healthy_fat' => l10n.groupHealthyFat,
  _ => l10n.groupDairy,
};

String shortDate(BuildContext context, DateTime date) =>
    DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date);

/// A small page with a back button and a title.
class SubPage extends StatelessWidget {
  const SubPage({
    super.key,
    required this.title,
    required this.onBack,
    required this.children,
    this.background = ParlaColors.cream,
  });

  final String title;
  final VoidCallback onBack;
  final List<Widget> children;
  final Color background;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: background,
    appBar: AppBar(
      backgroundColor: background,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Center(
          child: Material(
            color: ParlaColors.white,
            shape: const CircleBorder(
              side: BorderSide(color: ParlaColors.line),
            ),
            child: BackButton(onPressed: onBack, color: ParlaColors.espresso),
          ),
        ),
      ),
      leadingWidth: 64,
      title: Text(title),
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          ParlaSpace.page,
          4,
          ParlaSpace.page,
          32,
        ),
        children: children,
      ),
    ),
  );
}

/// An article in a list: category, reading time, title, summary.
/// A published image with its alt text; nothing when it cannot load.
class ContentImage extends StatelessWidget {
  const ContentImage({
    super.key,
    required this.image,
    this.radius = ParlaSpace.cardRadius,
    this.aspectRatio,
  });

  final ContentImageRef image;
  final double radius;

  /// Fixed shape, or `null` for the image's own.
  final double? aspectRatio;

  /// Loads an image from its URL. Replaced in tests.
  static ImageProvider Function(String url) provider = NetworkImage.new;

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    final alt = ContentRules.pick(image.alt, language);
    return Semantics(
      image: true,
      label: alt,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: AspectRatio(
          aspectRatio: aspectRatio ?? image.aspectRatio,
          child: Image(
            image: provider(image.url),
            fit: BoxFit.cover,
            excludeFromSemantics: true,
            errorBuilder: (_, _, _) =>
                const ColoredBox(color: ParlaColors.line),
          ),
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.item, required this.onTap});

  final PublishedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final minutes = (item.data['minutes'] as num?)?.toInt() ?? 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: ParlaColors.white,
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        child: InkWell(
          key: ValueKey('article-${item.slug}'),
          borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.image case final image?) ...[
                  ContentImage(image: image, aspectRatio: 16 / 9),
                  const SizedBox(height: 10),
                ],
                Text(
                  l10n
                      .blogMeta(categoryText(l10n, item.category), minutes)
                      .toUpperCase(),
                  style: text.labelMedium?.copyWith(
                    color: ParlaColors.sunInk,
                    letterSpacing: .6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.text('title', language), style: text.titleMedium),
                if (item.text('summary', language).isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.text('summary', language),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(color: ParlaColors.muted),
                  ),
                ],
                if (item.reviewedAt != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const ParlaIcon(ParlaIconName.check, size: 14),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.blogReviewed(
                            shortDate(context, item.reviewedAt!),
                          ),
                          style: text.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Filter chips: "All" and each category.
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onChanged,
    this.counts,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onChanged;

  /// Items per category (`null` key: all); shown beside each name.
  final Map<String?, int>? counts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // One line that scrolls sideways (owner's ask, 2026-11-20).
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _Pill(
            key: const ValueKey('cat-all'),
            selected: selected == null,
            onTap: () => onChanged(null),
            child: _label(context, l10n.discoverAll, null),
          ),
          for (final c in categories)
            _Pill(
              key: ValueKey('cat-$c'),
              selected: selected == c,
              onTap: () => onChanged(c),
              child: _label(context, categoryText(l10n, c), c),
            ),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String name, String? category) {
    final count = counts?[category];
    if (count == null) return Text(name);
    final selectedHere = category == selected;
    return Text.rich(
      TextSpan(
        text: name,
        children: [
          TextSpan(
            text: '  $count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selectedHere ? ParlaColors.line : ParlaColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

/// A filter pill: espresso when selected, white with a hairline otherwise.
class _Pill extends StatelessWidget {
  const _Pill({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleSmall?.copyWith(
      color: selected ? ParlaColors.white : ParlaColors.espresso,
    );
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? ParlaColors.espresso : ParlaColors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: selected ? ParlaColors.espresso : ParlaColors.line,
              width: 1.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  widthFactor: 1,
                  child: DefaultTextStyle.merge(style: style, child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The light tint of an article category or a recipe meal (cards
/// without a cover).
Color categoryTint(String id) => switch (id) {
  'care' => ParlaColors.sageTint,
  'beauty' => ParlaColors.blush,
  'hair' => ParlaColors.lilac,
  'body' => ParlaColors.sky,
  'fashion' => ParlaColors.lemon,
  'breakfast' => ParlaColors.lemon,
  'lunch' => ParlaColors.sageTint,
  'dinner' => ParlaColors.sky,
  'snack' => ParlaColors.blush,
  _ => ParlaColors.line,
};

/// Shown when nothing is published (or loaded) yet.
class EmptyNote extends StatelessWidget {
  const EmptyNote({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Text(
      AppLocalizations.of(context).contentEmpty,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: ParlaColors.muted),
    ),
  );
}
