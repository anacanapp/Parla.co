import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';

String categoryText(AppLocalizations l10n, String id) => switch (id) {
  'care' => l10n.catCare,
  'beauty' => l10n.catBeauty,
  'fashion' => l10n.catFashion,
  'hair' => l10n.catHair,
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
      leading: BackButton(onPressed: onBack),
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
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          key: const ValueKey('cat-all'),
          label: Text(l10n.discoverAll),
          selected: selected == null,
          onSelected: (_) => onChanged(null),
        ),
        for (final c in categories)
          ChoiceChip(
            key: ValueKey('cat-$c'),
            label: Text(categoryText(l10n, c)),
            selected: selected == c,
            onSelected: (_) => onChanged(c),
          ),
      ],
    );
  }
}

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
