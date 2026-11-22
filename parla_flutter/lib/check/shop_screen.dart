import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../discover/banner_strip.dart' show BannerCard, openPartnerSite;
import '../discover/discover_widgets.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import '../ui/parla_ui.dart';

String shopCategoryText(AppLocalizations l10n, String id) => switch (id) {
  'face' => l10n.shopCategoryFace,
  'hair' => l10n.shopCategoryHair,
  'body' => l10n.shopCategoryBody,
  'makeup' => l10n.shopCategoryMakeup,
  _ => l10n.shopCategoryOther,
};

/// Whether the app offers [item] now. Products sold in the app wait until
/// in-app payment is switched on ([sellsInApp]).
bool shopShows(PublishedItem item, {bool sellsInApp = false}) =>
    switch (item.data['sale']) {
      'redirect' => true,
      'own' => sellsInApp,
      _ => false,
    };

/// Whether in-app sales are open, as the server last said (`false` until
/// asked). The Shop screen asks each time it opens.
abstract final class ShopSales {
  static final open = ValueNotifier<bool>(false);
}

/// The brand label of a product in a paid campaign, or `null`.
String? sponsorOf(PublishedItem item) => ContentRules.isSponsored(item.data)
    ? (item.data['sponsor'] as String?)?.trim()
    : null;

/// The Shop: partners' products by category. Nothing about the user
/// chooses what is shown; campaign products come first, labelled as ads.
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String? _category;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _askSales());
  }

  Future<void> _askSales() async {
    if (!mounted) return;
    final scope = ParlaScope.of(context);
    unawaited(scope.content.ensure('product'));
    try {
      final open = await ParlaScope.of(context).api.shopSalesOpen();
      ShopSales.open.value = open;
    } on Object {
      // Offline or signed out: keep the last answer.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final library = ParlaScope.of(context).content;
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    void back() =>
        context.go(from == 'discover' ? Routes.discover : Routes.shoppingList);
    return ListenableBuilder(
      listenable: Listenable.merge([library, ShopSales.open]),
      builder: (context, _) {
        final all =
            [
              for (final p in library.items('product'))
                if (shopShows(p, sellsInApp: ShopSales.open.value)) p,
            ]..sort((a, b) {
              final ad =
                  (sponsorOf(b) != null ? 1 : 0) -
                  (sponsorOf(a) != null ? 1 : 0);
              return ad != 0 ? ad : b.publishedAt.compareTo(a.publishedAt);
            });
        final shown = [
          for (final p in all)
            if (_category == null || p.category == _category) p,
        ];
        final categories = [
          for (final c in ContentRules.productCategories)
            if (all.any((p) => p.category == c)) c,
        ];
        final rows = [
          for (var i = 0; i < shown.length; i += 2)
            shown.sublist(i, i + 2 > shown.length ? shown.length : i + 2),
        ];
        return Scaffold(
          backgroundColor: ParlaColors.cream,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                Row(
                  children: [
                    RoundBack(onPressed: back),
                    const Spacer(),
                    if (ShopSales.open.value)
                      PillButton(
                        key: const ValueKey('shop-orders'),
                        label: l10n.shopMyOrders,
                        icon: ParlaIconName.routine,
                        onPressed: () => context.go(Routes.shopOrders),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Semantics(
                  header: true,
                  child: Text(l10n.shopTitle, style: text.headlineLarge),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.shopIntro,
                  style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
                ),
                const SizedBox(height: 14),
                if (categories.length > 1) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in [null, ...categories])
                        PillChip(
                          key: ValueKey('shop-cat-${c ?? 'all'}'),
                          label: c == null
                              ? l10n.shopAll
                              : shopCategoryText(l10n, c),
                          selected: _category == c,
                          onTap: () => setState(() => _category = c),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
                if (shown.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      l10n.shopEmpty,
                      style: text.bodyMedium?.copyWith(
                        color: ParlaColors.muted,
                      ),
                    ),
                  ),
                for (final row in rows) ...[
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < 2; i++) ...[
                          if (i == 1) const SizedBox(width: 10),
                          Expanded(
                            child: i < row.length
                                ? ProductCard(
                                    item: row[i],
                                    onTap: () => context.go(
                                      Routes.shopProduct,
                                      extra: row[i].slug,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 8),
                PillButton(
                  label: l10n.shopOpenList,
                  icon: ParlaIconName.routine,
                  expand: true,
                  onPressed: () => context.go(Routes.shoppingList),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A round white back button (Parla 2.0 headers).
class RoundBack extends StatelessWidget {
  const RoundBack({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: ParlaColors.white,
    shape: const CircleBorder(side: BorderSide(color: ParlaColors.line)),
    child: BackButton(onPressed: onPressed, color: ParlaColors.espresso),
  );
}

/// A product in the grid: picture (with the ad label), brand, name and
/// price.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.item, required this.onTap});

  final PublishedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final sponsor = sponsorOf(item);
    return Material(
      key: ValueKey('product-${item.slug}'),
      color: ParlaColors.white,
      borderRadius: BorderRadius.circular(ParlaShape.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(ParlaShape.card),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  item.image == null
                      ? AspectRatio(
                          aspectRatio: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: ParlaColors.lemon,
                              borderRadius: BorderRadius.circular(
                                ParlaShape.tile,
                              ),
                            ),
                            child: const Center(
                              child: ParlaIcon(
                                ParlaIconName.bag,
                                size: 32,
                                color: ParlaColors.sunInk,
                              ),
                            ),
                          ),
                        )
                      : ContentImage(
                          image: item.image!,
                          aspectRatio: 1,
                          radius: ParlaShape.tile,
                        ),
                  if (sponsor != null)
                    PositionedDirectional(
                      start: 8,
                      top: 8,
                      child: AdLabel(
                        text: l10n.bannerAd(sponsor),
                        filled: true,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.data['brand'] ?? ''}'.toUpperCase(),
                      style: text.labelMedium?.copyWith(
                        color: ParlaColors.sunInk,
                        letterSpacing: .6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(item.text('name', language), style: text.titleSmall),
                    const SizedBox(height: 6),
                    Text(
                      l10n.shopPrice('${item.data['price'] ?? ''}'),
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The outlined "Ad · brand" label.
class AdLabel extends StatelessWidget {
  const AdLabel({super.key, required this.text, this.filled = false});

  final String text;

  /// White background, for labels over pictures.
  final bool filled;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('product-ad-label'),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: filled ? ParlaColors.white : null,
      border: Border.all(color: ParlaColors.outline),
      borderRadius: BorderRadius.circular(ParlaShape.pill),
    ),
    child: Text(text, style: Theme.of(context).textTheme.labelMedium),
  );
}

/// One product: picture, texts, price and the partner's site.
class ShopProductScreen extends StatelessWidget {
  const ShopProductScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final scope = ParlaScope.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([scope.content, ShopSales.open]),
      builder: (context, _) => _product(context, l10n, text, language, scope),
    );
  }

  Widget _product(
    BuildContext context,
    AppLocalizations l10n,
    TextTheme text,
    String language,
    ParlaScope scope,
  ) {
    if (!scope.content.isLoaded('product')) {
      unawaited(scope.content.ensure('product'));
    }
    final item = scope.content.find('product', slug);
    void back() => context.go(Routes.shop);
    if (item == null || !shopShows(item, sellsInApp: ShopSales.open.value)) {
      return SubPage(
        title: l10n.shopTitle,
        onBack: back,
        children: [Text(l10n.shopEmpty)],
      );
    }
    final sponsor = sponsorOf(item);
    final description = item.text('description', language);
    final url = item.data['url'];
    final campaign = item.data['campaign'];
    final own = item.data['sale'] == 'own';
    return Scaffold(
      backgroundColor: ParlaColors.cream,
      extendBody: true,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          HeroGlow(
            padding: EdgeInsets.zero,
            radius: BorderRadius.zero,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 320,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(56, 16, 56, 44),
                        child: item.image == null
                            ? const ParlaIcon(
                                ParlaIconName.bag,
                                size: 72,
                                color: ParlaColors.sunInk,
                              )
                            : ContentImage(
                                image: item.image!,
                                radius: ParlaShape.card,
                              ),
                      ),
                    ),
                    PositionedDirectional(
                      start: 12,
                      top: 8,
                      child: RoundBack(onPressed: back),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -32),
            child: Container(
              decoration: const BoxDecoration(
                color: ParlaColors.cream,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ParlaShape.sheet),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      if (sponsor != null)
                        AdLabel(text: l10n.bannerAd(sponsor)),
                      const Spacer(),
                      Text(
                        shopCategoryText(l10n, item.category).toUpperCase(),
                        style: text.labelMedium?.copyWith(
                          color: ParlaColors.sunInk,
                          letterSpacing: .6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${item.data['brand'] ?? ''}'.toUpperCase(),
                    style: text.labelMedium?.copyWith(
                      color: ParlaColors.sunInk,
                      letterSpacing: .8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    header: true,
                    child: Text(
                      item.text('name', language),
                      style: text.headlineMedium,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(description, style: text.bodyLarge),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    l10n.shopPriceNote,
                    style: text.bodySmall?.copyWith(color: ParlaColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 8, 8, 8),
            decoration: const ShapeDecoration(
              color: ParlaColors.white,
              shape: StadiumBorder(side: BorderSide(color: ParlaColors.line)),
              shadows: kFloatShadow,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.shopPrice('${item.data['price'] ?? ''}'),
                    key: const ValueKey('shop-price'),
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (own)
                  PillButton(
                    key: const ValueKey('shop-buy'),
                    label: l10n.shopBuy,
                    tone: PillTone.sun,
                    onPressed: () => buyProduct(context, item),
                  ),
                if (!own && url is String)
                  PillButton(
                    key: const ValueKey('shop-visit'),
                    label: l10n.shopVisitPartner,
                    tone: PillTone.sun,
                    onPressed: () {
                      scope.usage.count(UsageEvent.productTap, item.slug);
                      openPartnerSite(
                        context,
                        url,
                        campaign: campaign is int ? campaign : null,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Confirms the order, starts it and opens Epoint's payment page in the
/// browser. The card is entered there only; the order then shows under
/// "My orders".
Future<void> buyProduct(BuildContext context, PublishedItem item) async {
  final l10n = AppLocalizations.of(context);
  final language = Localizations.localeOf(context).languageCode;
  final scope = ParlaScope.of(context);
  final price = l10n.shopPrice('${item.data['price'] ?? ''}');
  final seller = item.data['seller'] == 'brand'
      ? l10n.shopSellerBrand('${item.data['brand'] ?? ''}')
      : l10n.shopSellerParla;
  final go = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.shopBuyTitle),
      content: Text(
        l10n.shopBuyBody(item.text('name', language), price, seller),
      ),
      actions: [
        TextButton(
          key: const ValueKey('shop-buy-cancel'),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.bannerLeaveCancel),
        ),
        FilledButton(
          key: const ValueKey('shop-buy-go'),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.shopBuyGo),
        ),
      ],
    ),
  );
  if (!(go ?? false) || !context.mounted) return;
  scope.usage.count(UsageEvent.productTap, item.slug);
  try {
    final started = await scope.api.startShopOrder(item.slug, 1, language);
    await BannerCard.launcher(started.paymentPage);
    if (context.mounted) context.go(Routes.shopOrders);
  } on ApiError catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            e.code == 'shop.too_many' ? l10n.shopTooMany : l10n.shopBuyError,
          ),
        ),
      );
  } on Object {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.shopBuyError)));
  }
}

String shopOrderStatusText(AppLocalizations l10n, String status) =>
    switch (status) {
      'paid' => l10n.shopOrderPaid,
      'failed' => l10n.shopOrderFailed,
      'shipped' => l10n.shopOrderShipped,
      'delivered' => l10n.shopOrderDelivered,
      'cancelled' => l10n.shopOrderCancelled,
      'refunded' => l10n.shopOrderRefunded,
      _ => l10n.shopOrderCreated,
    };

/// "My orders": the user's own orders and their status. Orders still
/// waiting for payment are checked with Epoint when the screen opens and
/// when the app comes back from the browser.
class ShopOrdersScreen extends StatefulWidget {
  const ShopOrdersScreen({super.key});

  @override
  State<ShopOrdersScreen> createState() => _ShopOrdersScreenState();
}

class _ShopOrdersScreenState extends State<ShopOrdersScreen>
    with WidgetsBindingObserver {
  List<ShopOrderItem>? _orders;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    final api = ParlaScope.of(context).api;
    try {
      var orders = await api.myShopOrders();
      if (orders.any((o) => o.status == 'created')) {
        orders = [
          for (final o in orders)
            o.status == 'created' ? await api.refreshShopOrder(o.number) : o,
        ];
      }
      if (mounted) {
        setState(() {
          _orders = orders;
          _failed = false;
        });
      }
    } on Object {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final orders = _orders;
    String money(int q) =>
        l10n.shopPrice('${q ~/ 100}.${(q % 100).toString().padLeft(2, '0')}');
    String day(DateTime d) {
      final l = d.toLocal();
      String two(int v) => v.toString().padLeft(2, '0');
      return '${two(l.day)}.${two(l.month)}.${l.year}';
    }

    return SubPage(
      title: l10n.shopMyOrders,
      onBack: () => context.go(Routes.shop),
      background: ParlaColors.blush,
      children: [
        if (orders == null && !_failed)
          const Center(child: CircularProgressIndicator()),
        if (_failed && orders == null) Text(l10n.shopBuyError),
        if (orders != null && orders.isEmpty) Text(l10n.shopOrdersEmpty),
        for (final o in orders ?? const <ShopOrderItem>[]) ...[
          Container(
            key: ValueKey('my-order-${o.number}'),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ParlaColors.white,
              borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ContentRules.pick(o.productTitle, language),
                  style: text.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.shopOrderMeta(o.number, day(o.createdAt), o.quantity),
                  style: text.bodySmall?.copyWith(color: ParlaColors.muted),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        shopOrderStatusText(l10n, o.status),
                        style: text.titleSmall,
                      ),
                    ),
                    Text(money(o.totalQepik), style: text.titleSmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
