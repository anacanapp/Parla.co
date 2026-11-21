import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../discover/banner_strip.dart' show openPartnerSite;
import '../discover/blog_widgets.dart';
import '../discover/discover_widgets.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final library = ParlaScope.of(context).content;
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    void back() =>
        context.go(from == 'discover' ? Routes.discover : Routes.shoppingList);
    return ListenableBuilder(
      listenable: library,
      builder: (context, _) {
        final all =
            [
              for (final p in library.items('product'))
                if (shopShows(p)) p,
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
        return SubPage(
          title: l10n.shopTitle,
          onBack: back,
          background: ParlaColors.blush,
          children: [
            Text(l10n.shopIntro, style: text.bodyMedium),
            const SizedBox(height: 14),
            if (categories.length > 1) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final c in [null, ...categories]) ...[
                      ChoiceChip(
                        key: ValueKey('shop-cat-${c ?? 'all'}'),
                        label: Text(
                          c == null ? l10n.shopAll : shopCategoryText(l10n, c),
                        ),
                        selected: _category == c,
                        onSelected: (_) => setState(() => _category = c),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (shown.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  l10n.shopEmpty,
                  style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
                ),
              ),
            for (final p in shown) ...[
              ProductCard(
                item: p,
                onTap: () => context.go(Routes.shopProduct, extra: p.slug),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(Routes.shoppingList),
              child: Text(l10n.shopOpenList),
            ),
          ],
        );
      },
    );
  }
}

/// A product in the list: picture, brand, name and price.
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
      borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 88,
                child: item.image == null
                    ? const AspectRatio(
                        aspectRatio: 1,
                        child: ColoredBox(color: ParlaColors.cream),
                      )
                    : ContentImage(
                        image: item.image!,
                        aspectRatio: 1,
                        radius: 12,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sponsor != null) ...[
                      AdLabel(text: l10n.bannerAd(sponsor)),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      '${item.data['brand'] ?? ''}'.toUpperCase(),
                      style: text.labelMedium?.copyWith(
                        color: ParlaColors.muted,
                        letterSpacing: .6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(item.text('name', language), style: text.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      l10n.shopPrice('${item.data['price'] ?? ''}'),
                      style: text.titleSmall,
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
  const AdLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('product-ad-label'),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      border: Border.all(color: ParlaColors.outline),
      borderRadius: BorderRadius.circular(6),
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
    final item = scope.content.find('product', slug);
    void back() => context.go(Routes.shop);
    if (item == null || !shopShows(item)) {
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
    return CoverPage(
      item: item,
      onBack: back,
      children: [
        if (sponsor != null) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AdLabel(text: l10n.bannerAd(sponsor)),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          '${item.data['brand'] ?? ''}'.toUpperCase(),
          style: text.labelMedium?.copyWith(
            color: ParlaColors.sunInk,
            letterSpacing: .6,
          ),
        ),
        const SizedBox(height: 6),
        Semantics(
          header: true,
          child: Text(item.text('name', language), style: text.headlineLarge),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.shopPrice('${item.data['price'] ?? ''}'),
          key: const ValueKey('shop-price'),
          style: text.titleLarge,
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(description, style: text.bodyLarge),
        ],
        const SizedBox(height: 20),
        if (url is String)
          FilledButton(
            key: const ValueKey('shop-visit'),
            onPressed: () {
              scope.usage.count(UsageEvent.productTap, item.slug);
              openPartnerSite(
                context,
                url,
                campaign: campaign is int ? campaign : null,
              );
            },
            child: Text(l10n.shopVisitPartner),
          ),
        const SizedBox(height: 12),
        Text(
          l10n.shopPriceNote,
          style: text.bodySmall?.copyWith(color: ParlaColors.muted),
        ),
      ],
    );
  }
}
