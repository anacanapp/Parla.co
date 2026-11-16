import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

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
        ),
    ];
  }
}
