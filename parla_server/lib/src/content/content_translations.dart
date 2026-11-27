import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import 'content_import.dart' show taskAdmin;
import 'content_seed_import.dart';

/// [current] (an article's or recipe's JSON) with the translations of
/// [seed] added (owner, 2026-11-27): for every text in both whose
/// Azerbaijani text is the same, the languages of `translatedLanguages`
/// the seed has and [current] lacks. Nothing else changes: az, ru and en,
/// a translation already there and a text the team rewrote stay as they
/// are. Returns [current] itself when nothing was added.
Map<String, Object?> addSeedTranslations(
  Map<String, Object?> current,
  Map<String, Object?> seed,
) {
  var changed = false;
  Object? merge(Object? cur, Object? src) {
    if (cur is Map && src is Map) {
      final isText = cur['az'] is String && src['az'] is String;
      if (isText) {
        if (cur['az'] != src['az']) return cur;
        final add = {
          for (final l in translatedLanguages)
            if (cur[l] == null && src[l] is String) l: src[l],
        };
        if (add.isEmpty) return cur;
        changed = true;
        return {...cur, ...add};
      }
      return {
        for (final e in cur.entries)
          e.key: src.containsKey(e.key) ? merge(e.value, src[e.key]) : e.value,
      };
    }
    if (cur is List && src is List && cur.length == src.length) {
      return [for (var i = 0; i < cur.length; i++) merge(cur[i], src[i])];
    }
    return cur;
  }

  final next = merge(current, seed) as Map;
  return changed ? next.cast<String, Object?>() : current;
}

/// The one-off task `add-content-translations`: adds the translations of
/// the imported articles and recipes to the ones in the database (draft
/// and published text), as the admin [email]. Each changed item is
/// audited as `content.translated`.
Future<String> runAddContentTranslationsTask(
  Session session,
  String email, {
  List<SeedContent>? seeds,
}) async {
  final staff = await taskAdmin(session, email);
  final bySlug = {
    for (final s in seeds ?? [...blogSeed, ...recipeSeed])
      '${s.kind}/${s.slug}': s,
  };
  final rows = await ContentItem.db.find(
    session,
    where: (t) =>
        t.kind.inSet({ContentKind.article.name, ContentKind.recipe.name}),
  );
  final done = <String>[];
  for (final row in rows) {
    final seed = bySlug['${row.kind}/${row.slug}'];
    if (seed == null) continue;
    final src = jsonDecode(seed.json) as Map<String, Object?>;
    final draft = jsonDecode(row.draftJson) as Map<String, Object?>;
    final published = row.publishedJson == null
        ? null
        : jsonDecode(row.publishedJson!) as Map<String, Object?>;
    final d = addSeedTranslations(draft, src);
    final p = published == null ? null : addSeedTranslations(published, src);
    if (identical(d, draft) && identical(p, published)) continue;
    final updated = await ContentItem.db.updateRow(
      session,
      row.copyWith(
        draftJson: jsonEncode(d),
        publishedJson: p == null ? null : jsonEncode(p),
        updatedBy: staff.authUserId,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await writeAudit(
      session,
      actorId: staff.authUserId,
      actorRole: AuditActor.staff,
      action: 'content.translated',
      objectType: 'content_item',
      objectId: updated.id.toString(),
    );
    done.add('${row.kind}/${row.slug}');
  }
  return 'Translated ${done.length} items.';
}
