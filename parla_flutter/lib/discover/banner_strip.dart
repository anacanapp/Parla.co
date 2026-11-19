import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import 'content_library.dart';
import 'discover_widgets.dart';

/// The route and `extra` of an in-app link (banners, messages, push), or
/// `null` for an unknown link.
(String, Object?)? linkRoute(String? link) {
  if (link == null || !ContentRules.isBannerLink(link)) return null;
  final i = link.indexOf(':');
  if (i > 0) {
    final slug = link.substring(i + 1);
    return (
      link.startsWith('article:') ? Routes.blogPost : Routes.recipe,
      slug,
    );
  }
  return (
    switch (link) {
      'home' => Routes.home,
      'routine' => Routes.habits,
      'check' => Routes.products,
      'sport' => Routes.sport,
      'blog' => Routes.blog,
      'nutrition' => Routes.nutrition,
      'experts' => Routes.experts,
      'messages' => Routes.messages,
      _ => Routes.discover,
    },
    null,
  );
}

/// Opens a banner's in-app link.
void openBannerLink(BuildContext context, String? link) {
  final route = linkRoute(link);
  if (route != null) context.go(route.$1, extra: route.$2);
}

/// The banners published for [placement] that show today in the user's
/// language and country. Targeting is decided here, on the phone.
class BannerStrip extends StatelessWidget {
  const BannerStrip({super.key, required this.placement});

  final String placement;

  @override
  Widget build(BuildContext context) {
    final scope = ParlaScope.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return ListenableBuilder(
      listenable: scope.content,
      builder: (context, _) {
        final today = scope.clock();
        final banners = [
          for (final b in scope.content.items('banner'))
            if (b.category == placement &&
                ContentRules.bannerVisible(
                  b.data,
                  today,
                  language: language,
                  country: ContentLibrary.country,
                ))
              b,
        ];
        if (banners.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            for (final b in banners.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BannerCard(item: b),
              ),
          ],
        );
      },
    );
  }
}

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, required this.item});

  final PublishedItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final sponsor = ContentRules.isSponsored(item.data)
        ? (item.data['sponsor']! as String).trim()
        : null;
    final link = item.data['link'] as String?;
    final title = item.text('title', language);
    final body = item.text('body', language);
    final usage = ParlaScope.of(context).usage..bannerShown(item.id);
    return Material(
      key: ValueKey('banner-${item.slug}'),
      color: ParlaColors.white,
      borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        onTap: link == null
            ? null
            : () {
                usage.bannerTapped(item.id);
                openBannerLink(context, link);
              },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sponsor != null)
                Container(
                  key: const ValueKey('banner-ad-label'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: ParlaColors.outline),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.bannerAd(sponsor),
                    style: text.labelMedium,
                  ),
                ),
              if (item.image case final image?) ...[
                ContentImage(image: image, aspectRatio: 16 / 9),
                const SizedBox(height: 10),
              ],
              Text(title, style: text.titleMedium),
              if (body.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(body, style: text.bodyMedium),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
