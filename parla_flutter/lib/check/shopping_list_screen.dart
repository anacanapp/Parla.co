import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/night.dart';
import '../ui/parla_icons.dart';
import 'care_list.dart';
import 'glass_bits.dart';
import 'shop_screen.dart' show RoundBack;

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
      backgroundColor: Colors.transparent,
      body: ListenableBuilder(
        listenable: book,
        builder: (context, _) {
          final items = book.shopping;
          return SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 32),
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: RoundBack(
                    onPressed: () => context.go(
                      GoRouterState.of(context).uri.queryParameters['from'] ==
                              'discover'
                          ? Routes.discover
                          : Routes.products,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: GlassTitle(l10n.discoverShopping)),
                    if (items.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          l10n.shoppingCount(book.boughtCount, items.length),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Glass.soft,
                          ),
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
                  decoration: glassInput(l10n.shoppingNewHint),
                  onSubmitted: (_) => _add(book),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final area in CareListRules.areas)
                      GlassChip(
                        key: ValueKey('shopping-area-$area'),
                        label: _areaLabel(l10n, area),
                        selected: _area == area,
                        onTap: () => setState(() => _area = area),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                GlassPill(
                  key: const ValueKey('shopping-add'),
                  onPressed: () => _add(book),
                  icon: ParlaIconName.plus,
                  label: l10n.shoppingAdd,
                  expand: true,
                  height: 52,
                  fontSize: 15,
                ),
                const SizedBox(height: 20),
                if (items.isEmpty)
                  Text(
                    l10n.shoppingEmpty,
                    style: text.bodyMedium?.copyWith(color: Glass.soft),
                  ),
                for (final area in CareListRules.areas)
                  if (items.any((i) => i.area == area)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
                      child: Semantics(
                        header: true,
                        child: Text(
                          _areaLabel(l10n, area).toUpperCase(),
                          style: const TextStyle(
                            fontSize: kMinTextSize,
                            letterSpacing: 1,
                            color: Glass.soft,
                          ),
                        ),
                      ),
                    ),
                    for (final item in items.where((i) => i.area == area)) ...[
                      _ItemTile(key: ValueKey('item-${item.id}'), item: item),
                      const SizedBox(height: 10),
                    ],
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
                MeshTile(
                  key: const ValueKey('shop-soon'),
                  tone: MeshTone.rose,
                  blobAt: const Alignment(0.9, 0.2),
                  padding: const EdgeInsets.fromLTRB(18, 14, 12, 14),
                  onTap: () => context.go(Routes.shop),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.shopSoonCard,
                              style: text.titleMedium?.copyWith(
                                color: MeshTone.rose.ink,
                              ),
                            ),
                            Text(
                              l10n.shopSoonCardBody,
                              style: text.bodySmall?.copyWith(
                                color: MeshTone.rose.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const _WhiteArrow(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  book.isSynced ? l10n.careListSynced : l10n.careListDevice,
                  style: text.bodySmall?.copyWith(color: Glass.soft),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// The white round arrow of tiles and slide pills.
class _WhiteArrow extends StatelessWidget {
  const _WhiteArrow();

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: const BoxDecoration(
      color: Color(0xFFFFFFFF),
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: const ParlaIcon(
      ParlaIconName.arrowRight,
      size: 18,
      color: Glass.darkInk,
    ),
  );
}

/// One shopping item: a round tick, the title and a remove button, on
/// glass (as the routine steps of the night design).
class _ItemTile extends StatelessWidget {
  const _ItemTile({super.key, required this.item});

  final ShoppingItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final book = ParlaScope.of(context).careList;
    final done = item.bought;
    return Semantics(
      checked: done,
      child: Material(
        color: done ? Glass.fill : Glass.buttonFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
            color: done ? Glass.line : const Color(0x38FFFFFF),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => book.toggleBought(item.id),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 6, 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? ParlaColors.espresso : null,
                    border: done
                        ? null
                        : Border.all(
                            color: const Color(0x99F4E9FF),
                            width: 1.5,
                          ),
                  ),
                  alignment: Alignment.center,
                  child: done
                      ? const ParlaIcon(
                          ParlaIconName.check,
                          size: 18,
                          color: Glass.darkInk,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 15,
                          decoration: done ? TextDecoration.lineThrough : null,
                          decorationColor: Glass.soft,
                          color: done ? const Color(0x99F4E9FF) : null,
                        ),
                      ),
                      if (item.origin == 'check')
                        Text(
                          l10n.shoppingFromCheck,
                          style: const TextStyle(
                            fontSize: kMinTextSize,
                            color: Glass.soft,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.shoppingRemove(item.title),
                  onPressed: () => book.removeItem(item.id),
                  icon: const Icon(Icons.close, size: 20, color: Glass.soft),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
