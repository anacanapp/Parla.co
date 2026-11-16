import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:url_launcher/url_launcher.dart';

import '../habits/habit_tracker.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'discover_widgets.dart';
import 'skin_tips.dart';

/// Blogs: category chips and the published articles.
class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  String? _category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final library = ParlaScope.of(context).content;
    return ListenableBuilder(
      listenable: library,
      builder: (context, _) {
        final items = library
            .items('article')
            .where((i) => _category == null || i.category == _category)
            .toList();
        return SubPage(
          title: l10n.discoverBlogs,
          onBack: () => context.go(Routes.discover),
          children: [
            CategoryChips(
              categories: ContentRules.articleCategories,
              selected: _category,
              onChanged: (c) => setState(() => _category = c),
            ),
            const SizedBox(height: 12),
            if (library.offline) _OfflineNote(),
            if (items.isEmpty) const EmptyNote(),
            for (final item in items)
              ArticleCard(
                item: item,
                onTap: () => context.go(Routes.blogPost, extra: item.slug),
              ),
          ],
        );
      },
    );
  }
}

/// One article: meta, the expert review line, the text and quick steps.
class BlogPostScreen extends StatelessWidget {
  const BlogPostScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final item = ParlaScope.of(context).content.find('article', slug);
    void back() => context.go(Routes.blog);
    if (item == null) {
      return SubPage(
        title: l10n.discoverBlogs,
        onBack: back,
        children: const [EmptyNote()],
      );
    }
    final minutes = (item.data['minutes'] as num?)?.toInt() ?? 1;
    final paragraphs = item
        .text('body', language)
        .split(RegExp(r'\n\s*\n'))
        .where((p) => p.trim().isNotEmpty);
    final tips = item.lines('tips', language);
    return SubPage(
      title: categoryText(l10n, item.category),
      onBack: back,
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
        const SizedBox(height: 6),
        Semantics(
          header: true,
          child: Text(item.text('title', language), style: text.headlineMedium),
        ),
        if (item.reviewedAt != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const ParlaIcon(ParlaIconName.check, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.blogReviewed(shortDate(context, item.reviewedAt!)),
                  style: text.labelMedium,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        for (final p in paragraphs) ...[
          Text(p.trim(), style: text.bodyLarge),
          const SizedBox(height: 12),
        ],
        if (tips.isNotEmpty) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ParlaColors.lemon,
              borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.blogTips, style: text.titleMedium),
                const SizedBox(height: 8),
                for (var i = 0; i < tips.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${i + 1}.', style: text.titleSmall),
                        const SizedBox(width: 8),
                        Expanded(child: Text(tips[i], style: text.bodyMedium)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Experts: filter by specialty, contacts open the phone's own apps.
class ExpertsScreen extends StatefulWidget {
  const ExpertsScreen({super.key});

  /// Opens a contact link in the phone's own app (replaced in tests).
  static Future<bool> Function(Uri uri) launcher = _launch;

  static Future<bool> _launch(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);

  @override
  State<ExpertsScreen> createState() => _ExpertsScreenState();
}

class _ExpertsScreenState extends State<ExpertsScreen> {
  String? _specialty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final library = ParlaScope.of(context).content;
    return ListenableBuilder(
      listenable: library,
      builder: (context, _) {
        final experts = library
            .items('expert')
            .where((e) => _specialty == null || e.category == _specialty)
            .toList();
        return SubPage(
          title: l10n.discoverExperts,
          onBack: () => context.go(Routes.discover),
          children: [
            CategoryChips(
              categories: ContentRules.expertSpecialties,
              selected: _specialty,
              onChanged: (c) => setState(() => _specialty = c),
            ),
            const SizedBox(height: 12),
            if (library.offline) _OfflineNote(),
            if (experts.isEmpty) const EmptyNote(),
            for (final e in experts)
              _ExpertCard(
                item: e,
                language: language,
                launch: ExpertsScreen.launcher,
              ),
            const SizedBox(height: 8),
            Text(
              l10n.expertsNote,
              style: text.bodySmall?.copyWith(color: ParlaColors.muted),
            ),
          ],
        );
      },
    );
  }
}

class _ExpertCard extends StatelessWidget {
  const _ExpertCard({
    required this.item,
    required this.language,
    required this.launch,
  });

  final PublishedItem item;
  final String language;
  final Future<bool> Function(Uri uri) launch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final phone = item.data['phone'] as String?;
    final whatsapp = item.data['whatsapp'] as String?;
    final instagram = item.data['instagram'] as String?;
    final years = (item.data['years'] as num?)?.toInt();
    final name = item.data['name'] as String? ?? '';
    final initials = name
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0])
        .join();
    return Container(
      key: ValueKey('expert-${item.slug}'),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ParlaColors.white,
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: ParlaColors.sky,
                  child: Text(initials, style: text.titleMedium),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: text.titleMedium),
                    Text(
                      [
                        categoryText(l10n, item.category),
                        item.text('workplace', language),
                        item.text('city', language),
                      ].where((s) => s.isNotEmpty).join(' · '),
                      style: text.bodySmall,
                    ),
                    if (years != null)
                      Text(
                        l10n.expertYears(years),
                        style: text.bodySmall?.copyWith(
                          color: ParlaColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (item.text('bio', language).isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(item.text('bio', language), style: text.bodyMedium),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (phone != null)
                FilledButton.tonal(
                  key: ValueKey('call-${item.slug}'),
                  onPressed: () => launch(Uri(scheme: 'tel', path: phone)),
                  child: Text(l10n.expertCall),
                ),
              if (whatsapp != null)
                FilledButton.tonal(
                  key: ValueKey('whatsapp-${item.slug}'),
                  onPressed: () => launch(
                    Uri.https('wa.me', '/${whatsapp.replaceAll('+', '')}'),
                  ),
                  child: Text(l10n.expertWhatsapp),
                ),
              if (instagram != null)
                FilledButton.tonal(
                  key: ValueKey('instagram-${item.slug}'),
                  onPressed: () =>
                      launch(Uri.https('instagram.com', '/$instagram')),
                  child: Text(l10n.expertInstagram),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The nutrition tool: today's plate, water, a skin tip and recipes.
class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scope = ParlaScope.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final muted = text.bodySmall?.copyWith(color: ParlaColors.muted);
    return ListenableBuilder(
      listenable: Listenable.merge([
        scope.nutrition,
        scope.content,
        scope.habits,
      ]),
      builder: (context, _) {
        final plate = scope.nutrition.today;
        final recipes = scope.content.items('recipe');
        return SubPage(
          title: l10n.discoverNutrition,
          onBack: () => context.go(Routes.discover),
          children: [
            Text(l10n.nutritionHero, style: text.headlineSmall),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ParlaColors.sageTint,
                borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text(l10n.nutritionPlate, style: text.titleMedium),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          l10n.nutritionPlateCount(
                            plate.length,
                            ContentRules.plateGroups.length,
                          ),
                          style: text.labelMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final g in ContentRules.plateGroups)
                        FilterChip(
                          key: ValueKey('plate-$g'),
                          label: Text(groupText(l10n, g)),
                          selected: plate.contains(g),
                          onSelected: (_) => scope.nutrition.toggle(g),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.nutritionWater(
                      scope.habits.water,
                      HabitTracker.waterGoal,
                    ),
                    style: text.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(l10n.nutritionNoCalories, style: muted),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ParlaColors.lemon,
                borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.nutritionTip, style: text.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    skinTipFor(scope.clock(), language),
                    style: text.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              header: true,
              child: Text(l10n.nutritionRecipes, style: text.titleLarge),
            ),
            const SizedBox(height: 8),
            if (recipes.isEmpty) const EmptyNote(),
            for (final r in recipes)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: ParlaColors.white,
                  borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
                  child: InkWell(
                    key: ValueKey('recipe-${r.slug}'),
                    borderRadius: BorderRadius.circular(
                      ParlaSpace.cardRadius,
                    ),
                    onTap: () => context.go(Routes.recipe, extra: r.slug),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _recipeMeta(l10n, r).toUpperCase(),
                            style: text.labelMedium?.copyWith(
                              color: ParlaColors.sunInk,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            r.text('title', language),
                            style: text.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(l10n.nutritionDisclaimer, style: muted),
            const SizedBox(height: 6),
            Text(
              scope.nutrition.isSynced
                  ? l10n.nutritionPrivacySynced
                  : l10n.nutritionPrivacyDevice,
              style: muted,
            ),
          ],
        );
      },
    );
  }
}

String _recipeMeta(AppLocalizations l10n, PublishedItem r) => l10n.recipeMeta(
  categoryText(l10n, r.category),
  (r.data['minutes'] as num?)?.toInt() ?? 1,
  (r.data['servings'] as num?)?.toInt() ?? 1,
);

/// One recipe: groups, ingredients, steps; ingredients go to the list.
class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final scope = ParlaScope.of(context);
    final r = scope.content.find('recipe', slug);
    void back() => context.go(Routes.nutrition);
    if (r == null) {
      return SubPage(
        title: l10n.discoverNutrition,
        onBack: back,
        children: const [EmptyNote()],
      );
    }
    final ingredients = [
      for (final i in (r.data['ingredients'] as List? ?? const []))
        (
          ContentRules.pick((i as Map)['name'], language),
          ContentRules.pick(i['amount'], language),
        ),
    ];
    final steps = r.lines('steps', language);
    final groups = (r.data['groups'] as List? ?? const []).cast<String>();
    return SubPage(
      title: l10n.discoverNutrition,
      onBack: back,
      children: [
        Text(
          _recipeMeta(l10n, r).toUpperCase(),
          style: text.labelMedium?.copyWith(color: ParlaColors.sunInk),
        ),
        const SizedBox(height: 4),
        Semantics(
          header: true,
          child: Text(r.text('title', language), style: text.headlineMedium),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final g in groups) Chip(label: Text(groupText(l10n, g))),
          ],
        ),
        const SizedBox(height: 16),
        Text(l10n.recipeIngredients, style: text.titleLarge),
        const SizedBox(height: 6),
        for (final (name, amount) in ingredients)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(name, style: text.bodyLarge)),
                const SizedBox(width: 12),
                Text(amount, style: text.bodyMedium),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Text(l10n.recipeSteps, style: text.titleLarge),
        const SizedBox(height: 6),
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i + 1}.', style: text.titleSmall),
                const SizedBox(width: 8),
                Expanded(child: Text(steps[i], style: text.bodyLarge)),
              ],
            ),
          ),
        if (r.text('note', language).isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            r.text('note', language),
            style: text.bodySmall?.copyWith(color: ParlaColors.muted),
          ),
        ],
        const SizedBox(height: 16),
        OutlinedButton.icon(
          key: const ValueKey('recipe-add'),
          onPressed: () async {
            var added = 0;
            for (final (name, _) in ingredients) {
              if (await scope.careList.addItem(name, origin: 'recipe')) {
                added++;
              }
            }
            if (!context.mounted) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.recipeAdded(added))),
              );
          },
          icon: const ParlaIcon(ParlaIconName.plus, size: 18),
          label: Text(l10n.recipeAddAll),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.nutritionDisclaimer,
          style: text.bodySmall?.copyWith(color: ParlaColors.muted),
        ),
      ],
    );
  }
}

class _OfflineNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      AppLocalizations.of(context).contentOffline,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: ParlaColors.muted),
    ),
  );
}
