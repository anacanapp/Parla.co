import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../discover/banner_strip.dart';
import '../discover/discover_bento.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import '../ui/warm.dart';

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
            final scope = ParlaScope.of(context);
            final sportBook = scope.sport;
            final plan = sportBook.plan;
            final sportDone = plan == null
                ? 0
                : plan.workouts
                      .where((w) => sportBook.doneThisWeek.contains(w.id))
                      .length;
            final reminders = scope.reminders;
            final enabledReminders = reminders.settings.reminders.values
                .where((r) => r.enabled)
                .length;
            final sportHint = [
              l10n.sportTypeFitness,
              l10n.sportTypeYoga,
              l10n.sportTypeFaceYoga,
            ].join(' · ');
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                ParlaSpace.page,
                22,
                ParlaSpace.page,
                120,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: WarmHeader(
                    title: l10n.discoverTitle,
                    above: l10n.homeTagline,
                  ),
                ),
                const SizedBox(height: ParlaSpace.gap),
                DiscoverBento(
                  sportFraction: plan == null || plan.workouts.isEmpty
                      ? 0
                      : sportDone / plan.workouts.length,
                  blogs: BentoSection(
                    title: l10n.discoverBlogs,
                    hint: articles.isEmpty
                        ? l10n.discoverBlogsHint
                        : '${l10n.discoverArticleCount(articles.length)} · '
                              '${l10n.discoverBlogsHint}',
                    value: articles.isEmpty ? null : '${articles.length}',
                    icon: ParlaIconName.book,
                    onTap: () => go(Routes.blog),
                  ),
                  latestLabel: articles.isEmpty ? null : l10n.discoverLatest,
                  latestTitle: articles.firstOrNull?.text(
                    'title',
                    locale.languageCode,
                  ),
                  nutrition: BentoSection(
                    title: l10n.discoverNutrition,
                    hint: recipes.isEmpty
                        ? l10n.discoverNutritionHint
                        : l10n.discoverRecipeCount(recipes.length),
                    value: recipes.isEmpty ? null : '${recipes.length}',
                    caption: recipes.isEmpty
                        ? null
                        : _withoutCount(
                            l10n.discoverRecipeCount(recipes.length),
                            recipes.length,
                          ),
                    icon: ParlaIconName.bowl,
                    onTap: () => go(Routes.nutrition),
                  ),
                  sport: BentoSection(
                    id: 'sport',
                    title: l10n.sportTitle,
                    hint: sportHint,
                    value: plan == null || plan.workouts.isEmpty
                        ? null
                        : '$sportDone',
                    valueSuffix: plan == null || plan.workouts.isEmpty
                        ? null
                        : '/ ${plan.workouts.length}',
                    caption: l10n.sportWeekTitle,
                    icon: ParlaIconName.dumbbell,
                    onTap: () => go(Routes.sport),
                  ),
                  experts: BentoSection(
                    title: l10n.discoverExperts,
                    hint: l10n.discoverExpertsHint,
                    icon: ParlaIconName.profile,
                    onTap: () => go(Routes.experts),
                  ),
                  shop: BentoSection(
                    title: l10n.discoverShop,
                    hint: l10n.discoverShopHint,
                    icon: ParlaIconName.bag,
                    onTap: () => go('${Routes.shop}?from=discover'),
                  ),
                  reminders: reminders.supported
                      ? BentoSection(
                          id: 'reminders',
                          title: l10n.remindersTitle,
                          hint: enabledReminders == 0
                              ? l10n.remindersSummaryOff
                              : l10n.remindersSummaryOn(enabledReminders),
                          caption: l10n.remindersOpen,
                          icon: ParlaIconName.arrowRight,
                          onTap: () => go(Routes.reminders),
                        )
                      : null,
                  shopping: BentoSection(
                    title: l10n.discoverShopping,
                    hint: l10n.discoverShoppingHint,
                    icon: ParlaIconName.routine,
                    onTap: () => go('${Routes.shoppingList}?from=discover'),
                  ),
                  journal: BentoSection(
                    id: 'journal',
                    title: l10n.discoverJournal,
                    hint: l10n.discoverJournalHint,
                    icon: ParlaIconName.pen,
                    onTap: () => go(Routes.journal),
                  ),
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

/// "76 recipes" without the number ("recipes"), for the caption under a
/// large number. Every language's plural form contains the count.
String _withoutCount(String counted, int count) =>
    counted.replaceFirst('$count', '').trim();
