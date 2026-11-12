import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../home/widgets/home_cards.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/common.dart';
import '../ui/parla_icons.dart';

/// M-20 product search and M-22 "nothing found". Searches go through our
/// server, never straight to Open Beauty Facts.
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

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final l10n = AppLocalizations.of(context);
    final api = ParlaScope.of(context).api;
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

  void _onNav(int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
      case 2:
        context.go(Routes.habits);
      case 3:
        context.go(Routes.privacy);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final results = _results;
    return Scaffold(
      backgroundColor: ParlaColors.cream,
      extendBody: true,
      bottomNavigationBar: ParlaNavBar(selected: 1, onTap: _onNav),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
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
            const SizedBox(height: 24),
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
          ],
        ),
      ),
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
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductResult product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final dataset = ParlaScope.of(context).ingredients;
    final ingredients = product.ingredientsText;
    final matches = ingredients == null
        ? const <IngredientMatch>[]
        : analyseIngredients(ingredients, dataset);
    final listed = matches.where((m) => m.entry != null).length;

    return Scaffold(
      backgroundColor: ParlaColors.cream,
      appBar: AppBar(
        backgroundColor: ParlaColors.cream,
        leading: BackButton(onPressed: () => context.go(Routes.products)),
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
      backgroundColor: ParlaColors.cream,
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
