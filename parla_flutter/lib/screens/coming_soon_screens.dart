import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../discover/banner_strip.dart';
import '../discover/discover_bento.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../services/parla_api.dart';
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
    final locale = Localizations.localeOf(context);
    void go(String route) => context.go(route);
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.discover),
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: library,
          builder: (context, _) {
            final articles = library.items('article');
            final recipes = library.items('recipe');
            final latest = articles.take(3).toList();
            ContentImageRef? cover(List<PublishedItem> items) =>
                items.where((i) => i.image != null).firstOrNull?.image;
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
                  child: Text(l10n.discoverTitle, style: text.headlineLarge),
                ),
                const SizedBox(height: 2),
                Text(l10n.homeTagline, style: accentStyle(locale, size: 17)),
                const SizedBox(height: ParlaSpace.gap),
                DiscoverBento(
                  blogs: BentoSection(
                    title: l10n.discoverBlogs,
                    hint: articles.isEmpty
                        ? l10n.discoverBlogsHint
                        : '${l10n.discoverArticleCount(articles.length)} · '
                              '${l10n.discoverBlogsHint}',
                    color: ParlaColors.lilac,
                    icon: ParlaIconName.book,
                    onTap: () => go(Routes.blog),
                  ),
                  nutrition: BentoSection(
                    title: l10n.discoverNutrition,
                    hint: recipes.isEmpty
                        ? l10n.discoverNutritionHint
                        : l10n.discoverRecipeCount(recipes.length),
                    color: ParlaColors.sageTint,
                    icon: ParlaIconName.bowl,
                    onTap: () => go(Routes.nutrition),
                  ),
                  sport: BentoSection(
                    id: 'sport',
                    title: l10n.sportTitle,
                    hint: l10n.discoverSportHint,
                    color: ParlaColors.sportBlue,
                    icon: ParlaIconName.dumbbell,
                    onTap: () => go(Routes.sport),
                  ),
                  experts: BentoSection(
                    title: l10n.discoverExperts,
                    hint: l10n.discoverExpertsHint,
                    color: ParlaColors.sky,
                    icon: ParlaIconName.profile,
                    onTap: () => go(Routes.experts),
                  ),
                  shopping: BentoSection(
                    title: l10n.discoverShopping,
                    hint: l10n.discoverShoppingHint,
                    color: ParlaColors.lemon,
                    icon: ParlaIconName.routine,
                    onTap: () => go('${Routes.shoppingList}?from=discover'),
                  ),
                  shop: BentoSection(
                    title: l10n.discoverShop,
                    hint: l10n.discoverShopHint,
                    color: ParlaColors.blush,
                    icon: ParlaIconName.bag,
                    onTap: () => go('${Routes.shop}?from=discover'),
                    soon: true,
                  ),
                  blogsImage: cover(articles),
                  nutritionImage: cover(recipes),
                ),
                const SizedBox(height: ParlaSpace.gap),
                const BannerStrip(placement: 'discover'),
                if (latest.isNotEmpty) ...[
                  const SizedBox(height: 6),
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
                        onPressed: () => go(Routes.blog),
                        child: Text(
                          l10n.discoverAll,
                          semanticsLabel:
                              '${l10n.discoverAll}: ${l10n.discoverBlogs}',
                        ),
                      ),
                    ],
                  ),
                  for (final item in latest)
                    ArticleRow(
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
