import 'package:flutter/material.dart';

import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';

/// Fitness tab. The workout plan arrives in redesign step 4; until then the
/// tab says what is coming, so the navigation already has its final shape.
class SportScreen extends StatelessWidget {
  const SportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.sport),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            ParlaSpace.page,
            14,
            ParlaSpace.page,
            120,
          ),
          children: [
            Semantics(
              header: true,
              child: Text(l10n.sportTitle, style: text.headlineMedium),
            ),
            const SizedBox(height: ParlaSpace.gap),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: ParlaColors.sportBlue,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SoonBadge(onDark: true),
                  const SizedBox(height: 10),
                  Text(
                    l10n.sportSoonTitle,
                    style: text.headlineSmall?.copyWith(
                      color: ParlaColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.sportSoonBody,
                    style: text.bodyMedium?.copyWith(
                      color: ParlaColors.sportBlueText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Discover tab: blogs, experts, nutrition, shopping list and shop. Each
/// opens in a later redesign step; for now they are listed as coming soon.
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final tiles = [
      (l10n.discoverBlogs, l10n.discoverBlogsHint, ParlaColors.lilac),
      (l10n.discoverExperts, l10n.discoverExpertsHint, ParlaColors.sky),
      (
        l10n.discoverNutrition,
        l10n.discoverNutritionHint,
        ParlaColors.sageTint,
      ),
      (l10n.discoverShopping, l10n.discoverShoppingHint, ParlaColors.lemon),
      (l10n.discoverShop, l10n.discoverShopHint, ParlaColors.blush),
    ];
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.discover),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            ParlaSpace.page,
            14,
            ParlaSpace.page,
            120,
          ),
          children: [
            Semantics(
              header: true,
              child: Text(l10n.discoverTitle, style: text.headlineMedium),
            ),
            const SizedBox(height: ParlaSpace.gap),
            for (final (title, hint, color) in tiles) ...[
              Semantics(
                container: true,
                label: '$title. $hint. ${l10n.soonBadge}',
                excludeSemantics: true,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(
                      ParlaSpace.cardRadius,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: text.titleLarge),
                            const SizedBox(height: 2),
                            Text(
                              hint,
                              style: text.bodySmall?.copyWith(
                                color: ParlaColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const _SoonBadge(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _SoonBadge extends StatelessWidget {
  const _SoonBadge({this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: onDark ? ParlaColors.sun : ParlaColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ParlaIcon(ParlaIconName.sparkle, size: 14),
          const SizedBox(width: 4),
          Text(
            l10n.soonBadge,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
