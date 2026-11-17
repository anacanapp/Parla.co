import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'media_store.dart';

/// Ids of the images content uses: in published copies, and with [drafts]
/// also in working copies.
Future<Set<int>> usedImageIds(Session session, {bool drafts = false}) async {
  final rows = await ContentItem.db.find(session);
  final out = <int>{};
  for (final r in rows) {
    for (final json in [r.publishedJson, if (drafts) r.draftJson]) {
      if (json == null) continue;
      final decoded = jsonDecode(json);
      if (decoded is Map<String, Object?>) {
        out.addAll(MediaRules.imageIdsOf(decoded));
      }
    }
  }
  return out;
}

/// Makes exactly the images of published content reachable by the app:
/// copies newly used ones to the public prefix and removes the public copy
/// of images no published content uses any more.
Future<void> syncPublicMedia(Session session) async {
  final used = await usedImageIds(session);
  final assets = await MediaAsset.db.find(
    session,
    where: (t) => t.public.equals(true) | t.id.inSet(used),
  );
  final store = Media.instance.store;
  for (final a in assets) {
    final shouldBePublic = used.contains(a.id);
    if (shouldBePublic == a.public) continue;
    if (shouldBePublic) {
      await store.copy(Media.privateKey(a.key), Media.publicKey(a.key));
    } else {
      await store.delete(Media.publicKey(a.key));
    }
    await MediaAsset.db.updateRow(session, a.copyWith(public: shouldBePublic));
  }
}
