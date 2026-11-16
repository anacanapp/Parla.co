import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../discover/discover_widgets.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';

/// Discover tab: blogs, experts, nutrition, the shopping list and the shop
/// ("coming soon"), and the newest articles.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final scope = ParlaScope.of(context);
    scope.content.load();
    scope.attachAccount();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final library = ParlaScope.of(context).content;
    final tiles = [
      // (title, hint, colour, route, soon)
      (
        l10n.discoverBlogs,
        l10n.discoverBlogsHint,
        ParlaColors.lilac,
        Routes.blog,
        false,
      ),
      (
        l10n.discoverExperts,
        l10n.discoverExpertsHint,
        ParlaColors.sky,
        Routes.experts,
        false,
      ),
      (
        l10n.discoverNutrition,
        l10n.discoverNutritionHint,
        ParlaColors.sageTint,
        Routes.nutrition,
        false,
      ),
      (
        l10n.discoverShopping,
        l10n.discoverShoppingHint,
        ParlaColors.lemon,
        Routes.shoppingList,
        false,
      ),
      (
        l10n.discoverShop,
        l10n.discoverShopHint,
        ParlaColors.blush,
        Routes.shop,
        true,
      ),
    ];
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.discover),
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: library,
          builder: (context, _) {
            final latest = library.items('article').take(3).toList();
            return ListView(
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
                for (final (title, hint, color, route, soon) in tiles) ...[
                  Semantics(
                    container: true,
                    button: true,
                    label: soon
                        ? '$title. $hint. ${l10n.soonBadge}'
                        : '$title. $hint',
                    excludeSemantics: true,
                    child: Material(
                      color: color,
                      borderRadius: BorderRadius.circular(
                        ParlaSpace.cardRadius,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          ParlaSpace.cardRadius,
                        ),
                        onTap: () => context.go(route),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
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
                              if (soon)
                                const _SoonBadge()
                              else
                                const ParlaIcon(ParlaIconName.arrowRight),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (latest.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            l10n.discoverLatest,
                            style: text.titleLarge,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(Routes.blog),
                        child: Text(
                          l10n.discoverAll,
                          semanticsLabel:
                              '${l10n.discoverAll}: ${l10n.discoverBlogs}',
                        ),
                      ),
                    ],
                  ),
                  for (final item in latest)
                    ArticleCard(
                      item: item,
                      onTap: () =>
                          context.go(Routes.blogPost, extra: item.slug),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SoonBadge extends StatelessWidget {
  const _SoonBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ParlaColors.white,
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
