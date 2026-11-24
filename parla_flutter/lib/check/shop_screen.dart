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
import '../ui/night.dart';
import '../ui/parla_icons.dart';
import '../ui/parla_ui.dart';
import '../ui/warm.dart';
import 'glass_bits.dart';

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
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
              children: [
                Row(
                  children: [
                    RoundBack(onPressed: back),
                    const Spacer(),
                    if (ShopSales.open.value)
                      _SmokyCapsule(
                        key: const ValueKey('shop-orders'),
                        label: l10n.shopMyOrders,
                        onPressed: () => context.go(Routes.shopOrders),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                WarmHeader(title: l10n.shopTitle, above: l10n.shopIntro),
                const SizedBox(height: 12),
                if (categories.length > 1) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in [null, ...categories])
                        WarmChip(
                          key: ValueKey('shop-cat-${c ?? 'all'}'),
                          label: c == null
                              ? l10n.shopAll
                              : shopCategoryText(l10n, c),
                          selected: _category == c,
                          onTap: () => setState(() => _category = c),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                for (final (r, row) in rows.indexed) ...[
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
                                    index: r * 2 + i,
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
                const SizedBox(height: 2),
                AddPill(
                  label: l10n.shopOpenList,
                  height: 90,
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

/// A smoky glass capsule button (warm design), 44 px high.
class _SmokyCapsule extends StatelessWidget {
  const _SmokyCapsule({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: SmokyGlass(
        shape: const StadiumBorder(),
        shadow: false,
        onTap: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(label, style: const TextStyle(fontSize: 13)),
      ),
    ),
  );
}

/// A round black back button (warm design headers).
class RoundBack extends StatelessWidget {
  const RoundBack({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GlassBack(onPressed: onPressed);
}

/// A product picture placeholder: a soft bottle shape (on the card's own
/// rose or lime colour).
class _ProductArt extends StatelessWidget {
  const _ProductArt({required this.mood, this.height = 120});

  final int mood;
  final double height;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: height,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: mood.isEven
              ? Container(
                  width: 38,
                  height: 92,
                  decoration: const BoxDecoration(
                    color: Color(0xE0FFFFFF),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(19),
                      bottom: Radius.circular(9),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: 96,
                      decoration: BoxDecoration(
                        color: const Color(0xE0FFFFFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0x80FFFFFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ),
  );
}

/// A product in the grid (warm design): a rose or lime card with the
/// picture, the ad label, brand, name, price and a black arrow.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.item,
    required this.onTap,
    this.index = 0,
  });

  final PublishedItem item;
  final VoidCallback onTap;

  /// Position in the grid; rose and lime cards alternate.
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final sponsor = sponsorOf(item);
    final name = item.text('name', language);
    return SquircleCard(
      key: ValueKey('product-${item.slug}'),
      tone: index.isEven ? SquircleTone.rose : SquircleTone.lime,
      radius: 40,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              item.image == null
                  ? _ProductArt(mood: index)
                  : ContentImage(
                      image: item.image!,
                      aspectRatio: 1,
                      radius: 28,
                    ),
              if (sponsor != null)
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  child: AdLabel(text: l10n.bannerAd(sponsor), filled: true),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 8, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.data['brand'] ?? ''}'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: kMinTextSize,
                    letterSpacing: 1,
                    color: Warm.onCardSoft,
                  ),
                ),
                const SizedBox(height: 2),
                Text(name, style: const TextStyle(fontSize: 14, height: 1.3)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.shopPrice('${item.data['price'] ?? ''}'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    BlackCircleButton(
                      icon: ParlaIconName.arrowRight,
                      onPressed: onTap,
                      label: name,
                      size: 34,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
    constraints: const BoxConstraints(minHeight: 24),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: filled ? const Color(0x8C0F0F12) : Glass.buttonFill,
      border: filled ? null : Border.all(color: Glass.buttonLine),
      borderRadius: BorderRadius.circular(ParlaShape.pill),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: kMinTextSize,
        color: filled ? Colors.white : ParlaColors.espresso,
      ),
    ),
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
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: RoundBack(onPressed: back),
                  ),
                  const SizedBox(height: 14),
                  item.image == null
                      ? const SquircleCard(
                          tone: SquircleTone.rose,
                          child: _ProductArt(mood: 0, height: 270),
                        )
                      : ContentImage(
                          image: item.image!,
                          aspectRatio: 1,
                          radius: 40,
                        ),
                ],
              ),
            ),
          ),
          // Texts sit on light glass so they read over the page's figure.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: GlassCard(
              radius: 36,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
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
                        style: const TextStyle(
                          fontSize: kMinTextSize,
                          letterSpacing: 1,
                          color: Glass.soft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${item.data['brand'] ?? ''}'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: kMinTextSize,
                      letterSpacing: 1,
                      color: Glass.soft,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    header: true,
                    child: Text(
                      item.text('name', language),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -.8,
                        height: 1.15,
                        color: ParlaColors.espresso,
                      ),
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(description, style: text.bodyLarge),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    l10n.shopPriceNote,
                    style: text.bodySmall?.copyWith(color: Glass.soft),
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
          child: GlassSurface(
            radius: 40,
            blur: true,
            padding: const EdgeInsets.fromLTRB(22, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.shopPrice('${item.data['price'] ?? ''}'),
                    key: const ValueKey('shop-price'),
                    style: text.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                if (own)
                  PillButton(
                    key: const ValueKey('shop-buy'),
                    label: l10n.shopBuy,
                    tone: PillTone.dark,
                    onPressed: () => buyProduct(context, item),
                  ),
                if (!own && url is String)
                  PillButton(
                    key: const ValueKey('shop-visit'),
                    label: l10n.shopVisitPartner,
                    tone: PillTone.dark,
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
      background: Colors.transparent,
      children: [
        if (orders == null && !_failed)
          const Center(child: CircularProgressIndicator()),
        if (_failed && orders == null) Text(l10n.shopBuyError),
        if (orders != null && orders.isEmpty) Text(l10n.shopOrdersEmpty),
        for (final o in orders ?? const <ShopOrderItem>[]) ...[
          GlassCard(
            key: ValueKey('my-order-${o.number}'),
            radius: 28,
            padding: const EdgeInsets.all(16),
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
                  style: text.bodySmall?.copyWith(color: Glass.soft),
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
