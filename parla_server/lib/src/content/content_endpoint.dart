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

  /// Published items of [kind] (a ContentKind name), newest first. For
  /// catalogue kinds this also lists hidden items, so the app can leave
  /// them out.
  Future<List<PublicContent>> published(Session session, String kind) async {
    final rows = await ContentItem.db.find(
      session,
      where: (t) =>
          t.kind.equals(kind) &
          (t.publishedJson.notEquals(null) | t.hidden.equals(true)),
      orderByList: (t) => [t.publishedAt.desc()],
      limit: 500,
    );
    int? imageId(ContentItem r) => MediaRules.imageOf(
      jsonDecode(r.publishedJson ?? '{}') as Map<String, Object?>,
    );
    Map<String, Object?> data(ContentItem r) =>
        jsonDecode(r.publishedJson ?? '{}') as Map<String, Object?>;
    final ids = <int>{};
    for (final r in rows) {
      ids.addAll(MediaRules.imageIdsOf(data(r)));
    }
    final images = <int, MediaAsset>{};
    if (ids.isNotEmpty) {
      final found = await MediaAsset.db.find(
        session,
        where: (t) => t.id.inSet(ids) & t.public.equals(true),
      );
      for (final a in found) {
        images[a.id!] = a;
      }
    }
    PublicImage? publicImage(int? id) {
      final a = id == null ? null : images[id];
      final url = a == null ? null : Media.instance.publicUrl(a.key);
      if (a == null || url == null) return null;
      return PublicImage(
        id: id,
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
          json: r.publishedJson ?? '{}',
          reviewedAt: r.publishedReviewedAt,
          publishedAt: r.publishedAt ?? r.updatedAt,
          image: publicImage(imageId(r)),
          inlineImages: [
            for (final id in ContentRules.inlineImageIds(data(r)))
              ?publicImage(id),
          ],
          hidden: r.hidden,
        ),
    ];
  }
}
