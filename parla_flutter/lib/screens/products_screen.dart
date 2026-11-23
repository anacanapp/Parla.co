import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../discover/content_library.dart';
import '../check/care_list.dart';
import '../check/ingredient_texts.dart';
import '../check/preference_ui.dart';
import '../home/widgets/home_cards.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/parla_ui.dart';
import '../ui/common.dart';
import '../ui/parla_icons.dart';

/// M-20 "Yoxla": product search, the user's preferences and recently
/// checked products; M-22 "nothing found". Searches go through our server,
/// never straight to Open Beauty Facts.
class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final _query = TextEditingController();
  List<ProductResult>? _results;
  bool _busy = false;
  String? _hint;

  /// Preferences the routine rules suggest for the user's quiz answers,
  /// worked out on the phone. Empty until loaded or without a quiz.
  Set<String> _suggested = const {};
  bool _loadedSuggestions = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedSuggestions) return;
    _loadedSuggestions = true;
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    try {
      final answers = await ParlaScope.of(context).api.myQuizAnswers();
      if (answers == null || !mounted) return;
      final known = {for (final p in productPreferences) p.id};
      setState(
        () => _suggested = buildRoutine(
          answers,
        ).preferences.where(known.contains).toSet(),
      );
    } on Object {
      // Offline or no quiz: no suggestions.
    }
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search([String? text]) async {
    final l10n = AppLocalizations.of(context);
    final api = ParlaScope.of(context).api;
    if (text != null) _query.text = text;
    final query = _query.text.trim();
    if (query.length < 2) {
      setState(() => _hint = l10n.productsQueryTooShort);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _hint = null;
    });
    try {
      final results = await api.searchProducts(query);
      if (mounted) setState(() => _results = results);
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.check),
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: ParlaScope.of(context).careList,
          builder: (context, _) => _body(context, results),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, List<ProductResult>? results) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final book = ParlaScope.of(context).careList;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      children: [
        Semantics(
          header: true,
          child: Text(l10n.productsTitle, style: text.headlineLarge),
        ),
        const SizedBox(height: 6),
        Text(l10n.productsIntro, style: text.bodyLarge),
        const SizedBox(height: 20),
        TextField(
          key: const ValueKey('product-query'),
          controller: _query,
          textInputAction: TextInputAction.search,
          maxLength: 80,
          decoration: InputDecoration(
            labelText: l10n.productsSearchLabel,
            errorText: _hint,
            counterText: '',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: ParlaColors.white,
          ),
          onSubmitted: (_) => _search(),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _busy ? null : _search,
          child: _busy
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              : Text(l10n.productsSearchButton),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ParlaColors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: ParlaColors.line),
              ),
              child: Text(
                l10n.checkBarcodeSoon,
                style: text.labelMedium?.copyWith(color: ParlaColors.muted),
              ),
            ),
            TextButton.icon(
              key: const ValueKey('open-shopping'),
              onPressed: () => context.go(Routes.shoppingList),
              icon: const ParlaIcon(ParlaIconName.check, size: 18),
              label: Text(l10n.discoverShopping),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (results != null && results.isEmpty)
          SoftCard(
            key: const ValueKey('products-not-found'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.productsNotFoundTitle, style: text.titleLarge),
                const SizedBox(height: 6),
                Text(l10n.productsNotFoundBody, style: text.bodyMedium),
              ],
            ),
          ),
        if (results != null)
          for (final product in results) ...[
            _ProductTile(
              product: product,
              onTap: () => context.go(Routes.productDetail, extra: product),
            ),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              child: Semantics(
                header: true,
                child: Text(l10n.checkPrefsTitle, style: text.titleLarge),
              ),
            ),
            TextButton(
              key: const ValueKey('prefs-edit'),
              onPressed: () => editPreferences(context, book),
              child: Text(
                book.preferences.isEmpty
                    ? l10n.checkPrefsAdd
                    : l10n.checkPrefsEdit,
              ),
            ),
          ],
        ),
        if (book.preferences.isEmpty)
          Text(
            l10n.checkPrefsEmpty,
            style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
          )
        else
          PreferenceChips(ids: book.preferences),
        if (_suggested
                .difference(book.preferences.toSet())
                .difference(ContentLibrary.hiddenIds('preference'))
            case final open when open.isNotEmpty) ...[
          const SizedBox(height: 12),
          SoftCard(
            key: const ValueKey('check-suggestions'),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.checkSuggestTitle, style: text.titleMedium),
                const SizedBox(height: 4),
                Text(l10n.checkSuggestBody, style: text.bodySmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final p in productPreferences)
                      if (open.contains(p.id))
                        ActionChip(
                          key: ValueKey('suggest-${p.id}'),
                          avatar: const Icon(Icons.add, size: 18),
                          label: Text(preferenceLabel(l10n, p.id)),
                          tooltip: l10n.checkSuggestAdd(
                            preferenceLabel(l10n, p.id),
                          ),
                          onPressed: () => book.setPreferences({
                            ...book.preferences,
                            p.id,
                          }),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ],
        if (book.recent.isNotEmpty) ...[
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.checkRecentTitle,
                    style: text.titleLarge,
                  ),
                ),
              ),
              TextButton(
                onPressed: book.clearRecent,
                child: Text(
                  l10n.checkRecentClear,
                  semanticsLabel:
                      '${l10n.checkRecentClear}: ${l10n.checkRecentTitle}',
                ),
              ),
            ],
          ),
          for (final r in book.recent)
            ListTile(
              key: ValueKey('recent-${r.code}'),
              contentPadding: EdgeInsets.zero,
              title: Text(r.name, style: text.titleMedium),
              subtitle: r.brand == null ? null : Text(r.brand!),
              trailing: const Icon(Icons.search, size: 20),
              onTap: () => _search(r.name),
            ),
        ],
      ],
    );
  }
}

String _sourceLabel(AppLocalizations l10n, String source) =>
    source == 'parla' ? l10n.productsSourceParla : l10n.productsSourceObf;

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.onTap});

  final ProductResult product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return SoftCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(product.name, style: text.titleMedium),
        subtitle: Text(
          [
            if (product.brand != null) product.brand!,
            _sourceLabel(l10n, product.source),
          ].join(' · '),
          style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
        ),
        trailing: const Icon(Icons.chevron_right, color: ParlaColors.espresso),
        onTap: onTap,
      ),
    );
  }
}

/// M-21 product detail with the ingredient list and EU statuses, and M-23
/// ingredient detail as a sheet. Neutral, sourced statuses only; no verdict
/// on the product and nothing personal (no quiz or health data is used).
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductResult product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _recorded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_recorded) return;
    _recorded = true;
    final p = widget.product;
    final book = ParlaScope.of(context).careList;
    // After this frame: the book notifies listeners, which must not
    // happen while the screen builds.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => book.addRecent(
        code: p.code,
        source: p.source,
        name: p.name,
        brand: p.brand,
      ),
    );
  }

  Future<void> _addToList(CareListBook book) async {
    final l10n = AppLocalizations.of(context);
    final p = widget.product;
    final added = await book.addItem(
      p.brand == null ? p.name : '${p.brand} · ${p.name}',
      origin: 'check',
      code: p.code,
      source: p.source,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added
              ? l10n.resultAdded
              : l10n.shoppingFull(CareListRules.maxShopping),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: ParlaScope.of(context).careList,
    builder: (context, _) => _build(context),
  );

  Widget _build(BuildContext context) {
    final product = widget.product;
    final book = ParlaScope.of(context).careList;
    final inList = book.hasProduct(product.code, product.source);
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final dataset = ParlaScope.of(context).ingredients;
    final ingredients = product.ingredientsText;
    final matches = ingredients == null
        ? const <IngredientMatch>[]
        : analyseIngredients(ingredients, dataset);
    final listed = matches.where((m) => m.entry != null).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: roundBackWidth,
        leading: RoundBackButton(
          onPressed: () => context.go(
            GoRouterState.of(context).uri.queryParameters['from'] == 'discover'
                ? Routes.discover
                : Routes.products,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Semantics(
            header: true,
            child: Text(product.name, style: text.headlineMedium),
          ),
          if (product.brand != null) ...[
            const SizedBox(height: 4),
            Text(
              product.brand!,
              style: text.bodyLarge?.copyWith(color: ParlaColors.muted),
            ),
          ],
          const SizedBox(height: 16),
          OutlinedButton.icon(
            key: const ValueKey('add-to-list'),
            onPressed: inList ? null : () => _addToList(book),
            icon: ParlaIcon(
              inList ? ParlaIconName.check : ParlaIconName.plus,
              size: 18,
            ),
            label: Text(inList ? l10n.resultInList : l10n.resultAddToList),
          ),
          const SizedBox(height: 20),
          _PreferencesCard(
            results: checkPreferences(ingredients, book.preferences),
            onEdit: () => editPreferences(context, book),
          ),
          const SizedBox(height: 24),
          Text(l10n.productIngredientsTitle, style: text.headlineSmall),
          const SizedBox(height: 8),
          if (matches.isEmpty)
            Text(l10n.productNoIngredients, style: text.bodyLarge)
          else ...[
            Text(
              [
                l10n.productIngredientCount(matches.length),
                if (!dataset.isEmpty) l10n.productListedCount(listed),
              ].join(' · '),
              style: text.bodyMedium?.copyWith(color: ParlaColors.sunInk),
            ),
            const SizedBox(height: 12),
            if (dataset.isEmpty) ...[
              _Notice(
                key: const ValueKey('statuses-missing'),
                text: l10n.productStatusesMissing,
                color: ParlaColors.sky,
              ),
              const SizedBox(height: 12),
            ],
            for (final m in matches) ...[
              _IngredientTile(match: m, dataset: dataset),
              const SizedBox(height: 8),
            ],
          ],
          const SizedBox(height: 16),
          if (product.source != 'parla')
            _Notice(text: l10n.productDataNotice, color: ParlaColors.lemon),
          if (!dataset.isEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.productLegalNotice(dataset.exportedOn ?? ''),
              style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
            ),
          ],
          if (product.source != 'parla') ...[
            const SizedBox(height: 12),
            Text(
              l10n.productAttribution,
              style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
            ),
          ],
        ],
      ),
    );
  }
}

/// How the product fits the user's own preferences. Neutral wording only:
/// "fits" or "contains X", never a score or a warning colour.
class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({required this.results, required this.onEdit});

  final List<PreferenceResult> results;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final known = results.where((r) => r.outcome != PreferenceOutcome.unknown);
    final fits = known.where((r) => r.outcome == PreferenceOutcome.fits).length;
    return SoftCard(
      key: const ValueKey('prefs-result'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                child: Text(l10n.resultPrefsTitle, style: text.titleMedium),
              ),
              TextButton(
                onPressed: onEdit,
                child: Text(
                  results.isEmpty ? l10n.checkPrefsAdd : l10n.checkPrefsEdit,
                ),
              ),
            ],
          ),
          if (results.isEmpty)
            Text(l10n.resultPrefsNone, style: text.bodyMedium)
          else ...[
            if (known.isNotEmpty)
              Text(
                l10n.resultPrefsSummary(fits, known.length),
                style: text.titleLarge,
              ),
            const SizedBox(height: 8),
            for (final r in results)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: ParlaIcon(
                        r.outcome == PreferenceOutcome.fits
                            ? ParlaIconName.check
                            : ParlaIconName.sparkle,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            preferenceLabel(l10n, r.preference.id),
                            style: text.titleSmall,
                          ),
                          Text(
                            switch (r.outcome) {
                              PreferenceOutcome.fits =>
                                r.preference.cautious
                                    ? l10n.resultPrefVeganFits
                                    : l10n.resultPrefFits,
                              PreferenceOutcome.conflicts =>
                                l10n.resultPrefContains(r.found.join(', ')),
                              PreferenceOutcome.unknown =>
                                l10n.resultPrefUnknown,
                            },
                            style: text.bodyMedium?.copyWith(
                              color: ParlaColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 8),
          Text(
            l10n.resultPrefsNote,
            style: text.bodySmall?.copyWith(color: ParlaColors.muted),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
  );
}

String annexLabel(AppLocalizations l10n, EuAnnex annex) => switch (annex) {
  EuAnnex.ii => l10n.annexIIShort,
  EuAnnex.iii => l10n.annexIIIShort,
  EuAnnex.iv => l10n.annexIVShort,
  EuAnnex.v => l10n.annexVShort,
  EuAnnex.vi => l10n.annexVIShort,
};

/// Neutral surfaces only: a status is information, not a warning colour.
Color _annexColor(EuAnnex annex) => switch (annex) {
  EuAnnex.ii => ParlaColors.white,
  EuAnnex.iii => ParlaColors.lemon,
  EuAnnex.iv || EuAnnex.vi => ParlaColors.sky,
  EuAnnex.v => ParlaColors.sage,
};

class _IngredientTile extends StatelessWidget {
  const _IngredientTile({required this.match, required this.dataset});

  final IngredientMatch match;
  final IngredientDataset dataset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final entry = match.entry;
    final explained = ingredientText(
      match.name,
      Localizations.localeOf(context).languageCode,
    );
    return SoftCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: entry == null ? null : () => _showDetail(context, entry),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(match.name, style: text.titleMedium)),
                  if (entry != null)
                    const Icon(
                      Icons.chevron_right,
                      color: ParlaColors.espresso,
                    ),
                ],
              ),
              // What the ingredient does, in neutral words (draft texts).
              if (explained != null) ...[
                const SizedBox(height: 2),
                Text(
                  explained.$1,
                  style: text.labelMedium?.copyWith(color: ParlaColors.sunInk),
                ),
                Text(explained.$2, style: text.bodySmall),
              ],
              if (entry != null)
                for (final rule in entry.rules) ...[
                  const SizedBox(height: 6),
                  _StatusChip(rule: rule, label: annexLabel(l10n, rule.annex)),
                ]
              else if (!dataset.isEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.ingredientNoEntry,
                  style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, IngredientEntry entry) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            children: [
              Semantics(
                header: true,
                child: Text(entry.inci, style: text.titleLarge),
              ),
              for (final rule in entry.rules) ...[
                const SizedBox(height: 16),
                _StatusChip(rule: rule, label: annexLabel(l10n, rule.annex)),
                const SizedBox(height: 6),
                Text(
                  l10n.annexEntry(rule.annex.roman, rule.reference),
                  style: text.bodyMedium,
                ),
                if (rule.conditions != null) ...[
                  const SizedBox(height: 8),
                  Text(l10n.annexConditionsLabel, style: text.labelMedium),
                  const SizedBox(height: 4),
                  Text(
                    rule.conditions!,
                    // The official text stays in English, exactly as published.
                    locale: const Locale('en'),
                    style: text.bodyMedium,
                  ),
                ],
              ],
              const SizedBox(height: 16),
              Text(
                l10n.ingredientSheetSource(dataset.exportedOn ?? ''),
                style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.rule, required this.label});

  final IngredientRule rule;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: _annexColor(rule.annex),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: ParlaColors.outline),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ParlaIcon(ParlaIconName.routine, size: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );
}
