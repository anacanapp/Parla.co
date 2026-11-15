import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'care_list.dart';

String _areaLabel(AppLocalizations l10n, String area) => switch (area) {
  'face' => l10n.routineAreaFace,
  'hair' => l10n.routineAreaHair,
  'body' => l10n.routineAreaBody,
  _ => l10n.shoppingAreaOther,
};

/// The shopping list: items grouped by area, ticked off when bought.
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _title = TextEditingController();
  String _area = 'face';

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _add(CareListBook book) async {
    final l10n = AppLocalizations.of(context);
    if (_title.text.trim().isEmpty) return;
    final added = await book.addItem(_title.text, area: _area);
    if (!mounted) return;
    if (added) {
      _title.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.shoppingFull(CareListRules.maxShopping))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final book = ParlaScope.of(context).careList;
    return Scaffold(
      backgroundColor: ParlaColors.cream,
      appBar: AppBar(
        backgroundColor: ParlaColors.cream,
        leading: BackButton(onPressed: () => context.go(Routes.products)),
      ),
      body: ListenableBuilder(
        listenable: book,
        builder: (context, _) {
          final items = book.shopping;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        l10n.discoverShopping,
                        style: text.headlineMedium,
                      ),
                    ),
                  ),
                  if (items.isNotEmpty)
                    Text(
                      l10n.shoppingCount(book.boughtCount, items.length),
                      style: text.labelMedium?.copyWith(
                        color: ParlaColors.sunInk,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                key: const ValueKey('shopping-new'),
                controller: _title,
                maxLength: CareListRules.maxTitleLength,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: l10n.shoppingNewHint),
                onSubmitted: (_) => _add(book),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final area in CareListRules.areas)
                    ChoiceChip(
                      key: ValueKey('shopping-area-$area'),
                      label: Text(_areaLabel(l10n, area)),
                      selected: _area == area,
                      onSelected: (_) => setState(() => _area = area),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                key: const ValueKey('shopping-add'),
                onPressed: () => _add(book),
                icon: const ParlaIcon(ParlaIconName.plus, size: 18),
                label: Text(l10n.shoppingAdd),
              ),
              const SizedBox(height: 20),
              if (items.isEmpty)
                Text(
                  l10n.shoppingEmpty,
                  style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
                ),
              for (final area in CareListRules.areas)
                if (items.any((i) => i.area == area)) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Semantics(
                      header: true,
                      child: Text(
                        _areaLabel(l10n, area).toUpperCase(),
                        style: text.labelMedium?.copyWith(
                          color: ParlaColors.muted,
                          letterSpacing: .6,
                        ),
                      ),
                    ),
                  ),
                  for (final item in items.where((i) => i.area == area))
                    _ItemTile(key: ValueKey('item-${item.id}'), item: item),
                ],
              if (book.boughtCount > 0)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: book.removeBought,
                    child: Text(l10n.shoppingRemoveBought),
                  ),
                ),
              const SizedBox(height: 16),
              Material(
                color: ParlaColors.blush,
                borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
                child: InkWell(
                  key: const ValueKey('shop-soon'),
                  borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
                  onTap: () => context.go(Routes.shop),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.shopSoonCard, style: text.titleMedium),
                              Text(
                                l10n.shopSoonCardBody,
                                style: text.bodySmall?.copyWith(
                                  color: ParlaColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const ParlaIcon(ParlaIconName.arrowRight),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                book.isSynced ? l10n.careListSynced : l10n.careListDevice,
                style: text.bodySmall?.copyWith(color: ParlaColors.muted),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({super.key, required this.item});

  final ShoppingItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final book = ParlaScope.of(context).careList;
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: item.bought,
      onChanged: (_) => book.toggleBought(item.id),
      title: Text(
        item.title,
        style: text.bodyLarge?.copyWith(
          decoration: item.bought ? TextDecoration.lineThrough : null,
          color: item.bought ? ParlaColors.muted : null,
        ),
      ),
      subtitle: item.origin == 'check'
          ? Text(
              l10n.shoppingFromCheck,
              style: text.bodySmall?.copyWith(color: ParlaColors.muted),
            )
          : null,
      secondary: IconButton(
        tooltip: l10n.shoppingRemove(item.title),
        onPressed: () => book.removeItem(item.id),
        icon: const Icon(Icons.close, size: 20),
      ),
    );
  }
}
