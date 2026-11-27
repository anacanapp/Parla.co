import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/night.dart';
import 'content_library.dart';
import 'discover_widgets.dart';
import '../ui/locale_text.dart';

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
/// language and country, and, under an article or a recipe, for its
/// [topic] (category). Targeting is decided here, on the phone.
class BannerStrip extends StatelessWidget {
  const BannerStrip({
    super.key,
    required this.placement,
    this.topic,
    this.max = 3,
  });

  final String placement;
  final String? topic;

  /// At most this many banners show.
  final int max;

  @override
  Widget build(BuildContext context) {
    final scope = ParlaScope.of(context);
    final language = contentLanguageOf(context);
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
                  topic: topic,
                ))
              b,
        ];
        if (banners.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            for (final b in banners.take(max))
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

/// Asks before leaving the app, then opens a brand's or partner's [url]
/// in the browser with only Parla's campaign tags added
/// ([ContentRules.adLink]). Nothing about the user is added.
Future<void> openPartnerSite(
  BuildContext context,
  String url, {
  int? campaign,
}) async {
  if (!ContentRules.isAdUrl(url)) return;
  final link = ContentRules.adLink(url, campaign: campaign);
  final l10n = AppLocalizations.of(context);
  final go = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.bannerLeaveTitle),
      content: Text(l10n.bannerLeaveBody(link.host)),
      actions: [
        TextButton(
          key: const ValueKey('banner-leave-cancel'),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.bannerLeaveCancel),
        ),
        FilledButton(
          key: const ValueKey('banner-leave-go'),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.bannerLeaveGo),
        ),
      ],
    ),
  );
  if (go ?? false) await BannerCard.launcher(link);
}

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, required this.item});

  final PublishedItem item;

  /// Opens a brand's website in the browser (replaced in tests).
  static Future<bool> Function(Uri uri) launcher = _launch;

  static Future<bool> _launch(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);

  /// Asks before leaving the app, then opens the brand's site.
  static Future<void> openSite(BuildContext context, PublishedItem item) {
    final url = item.data['url'];
    final campaign = item.data['campaign'];
    return openPartnerSite(
      context,
      url is String ? url : '',
      campaign: campaign is int ? campaign : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = contentLanguageOf(context);
    final sponsor = ContentRules.isSponsored(item.data)
        ? (item.data['sponsor']! as String).trim()
        : null;
    final link = item.data['link'] as String?;
    final site = item.data['url'] as String?;
    final title = item.text('title', language);
    final body = item.text('body', language);
    final usage = ParlaScope.of(context).usage..bannerShown(item.id);
    return Material(
      key: ValueKey('banner-${item.slug}'),
      color: NightColors.glass,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: NightColors.glassLine),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        onTap: site != null
            ? () {
                usage.bannerTapped(item.id);
                openSite(context, item);
              }
            : link == null
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
