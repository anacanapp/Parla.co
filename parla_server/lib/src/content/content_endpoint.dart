import 'package:serverpod/serverpod.dart';

import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';

import '../generated/protocol.dart';
import '../media/media_store.dart';

/// Published content for the app. No sign-in needed and nothing personal:
/// articles, recipes and expert profiles the team has published.
class ContentEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Published items of [kind] (a ContentKind name), newest first.
  Future<List<PublicContent>> published(Session session, String kind) async {
    final rows = await ContentItem.db.find(
      session,
      where: (t) => t.kind.equals(kind) & t.publishedJson.notEquals(null),
      orderByList: (t) => [t.publishedAt.desc()],
      limit: 200,
    );
    final ids = {
      for (final r in rows)
        ?MediaRules.imageOf(
          jsonDecode(r.publishedJson!) as Map<String, Object?>,
        ),
    };
    final images = ids.isEmpty
        ? const <int, MediaAsset>{}
        : {
            for (final a in await MediaAsset.db.find(
              session,
              where: (t) => t.id.inSet(ids) & t.public.equals(true),
            ))
              a.id!: a,
          };
    PublicImage? imageFor(ContentItem r) {
      final id = MediaRules.imageOf(
        jsonDecode(r.publishedJson!) as Map<String, Object?>,
      );
      final a = id == null ? null : images[id];
      final url = a == null ? null : Media.instance.publicUrl(a.key);
      if (a == null || url == null) return null;
      return PublicImage(
        url: url,
        pixelWidth: a.pixelWidth,
        pixelHeight: a.pixelHeight,
        altJson: a.altJson,
      );
    }

    return [
      for (final r in rows)
        PublicContent(
          id: r.id!,
          kind: r.kind,
          slug: r.slug,
          category: r.category,
          json: r.publishedJson!,
          reviewedAt: r.publishedReviewedAt,
          publishedAt: r.publishedAt!,
          image: imageFor(r),
        ),
    ];
  }
}
