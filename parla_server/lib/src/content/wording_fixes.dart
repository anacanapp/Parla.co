import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import 'content_import.dart' show taskAdmin;

/// One wording change in an article: in the [lang] text of the article
/// [slug], [from] becomes [to].
typedef WordingFix = (String slug, String lang, String from, String to);

/// The blog never calls a product or a habit "harmful" (owner, 2026-11-26:
/// "zərərli sözü əvəzinə başqa söz"). These replace the word and its ru/en
/// equivalents in the imported articles with neutral wording.
///
/// `tools/blog_import/build_blog_seed.py` reads this list (one entry per
/// line, single-quoted, no escapes) and applies it when it writes
/// `blog_seed.dart`; the task `PARLA_TASK=fix-content-wording` applies it
/// to the articles already in the database.
const wordingFixes = <WordingFix>[
  (
    'bemotrizinol-news',
    'az',
    'bu araşdırmalar filtrlərin zərərli olduğunu sübut etmir',
    'bu araşdırmalar filtrlərlə bağlı problem olduğunu sübut etmir',
  ),
  (
    'bemotrizinol-news',
    'en',
    'show the filters are harmful',
    'show a problem with the filters',
  ),
  (
    'daily-sunscreen-winter',
    'az',
    'günəşin zərərli UV şüalarının',
    'günəşin UV şüalarının',
  ),
  (
    'daily-sunscreen-winter',
    'az',
    'UV-nin zərərli təsirləri mümkündür',
    'UV-nin dəriyə təsiri mümkündür',
  ),
  (
    'daily-sunscreen-winter',
    'ru',
    'до 80% вредных УФ-лучей',
    'до 80% УФ-лучей',
  ),
  (
    'daily-sunscreen-winter',
    'ru',
    'вредное действие УФ возможно',
    'воздействие УФ на кожу возможно',
  ),
  ('daily-sunscreen-winter', 'en', 'harmful UV rays', 'UV rays'),
  (
    'fabrics-sensitive-skin',
    'az',
    'Sintetik parça həmişə zərərlidir.',
    'Sintetik parça dəri üçün həmişə pis seçimdir.',
  ),
  (
    'fabrics-sensitive-skin',
    'ru',
    'Синтетика всегда вредна.',
    'Синтетика всегда плохой выбор для кожи.',
  ),
  (
    'fabrics-sensitive-skin',
    'en',
    'Synthetic fabric is always harmful.',
    'Synthetic fabric is always a bad choice for skin.',
  ),
  (
    'lip-care-winter',
    'ru',
    'отказ от вредных привычек',
    'отказ от привычек, которые сушат губы,',
  ),
  (
    'retinoid-first-steps',
    'az',
    'günəşin zərərli UV şüalarının',
    'günəşin UV şüalarının',
  ),
  ('retinoid-first-steps', 'ru', 'до 80% вредных УФ-лучей', 'до 80% УФ-лучей'),
  ('retinoid-first-steps', 'en', 'harmful UV rays', 'UV rays'),
  (
    'soft-blush-trend',
    'en',
    'bacteria may be harmful to you',
    'bacteria can pass to you',
  ),
  (
    'sunglasses-hats-uv',
    'az',
    'Ucuz eynək zərərlidirmi?',
    'Ucuz eynək gözü qoruyurmu?',
  ),
  (
    'sunglasses-hats-uv',
    'ru',
    'Дешёвые очки вредны?',
    'Защищают ли дешёвые очки глаза?',
  ),
  (
    'sunglasses-hats-uv',
    'en',
    'Are cheap sunglasses harmful?',
    'Do cheap sunglasses protect your eyes?',
  ),
  (
    'winter-dry-skin',
    'az',
    'Hər gün vanna qəbul etmək zərərlidirmi?',
    'Hər gün vanna qəbul etmək dərini qurudurmu?',
  ),
  (
    'winter-dry-skin',
    'ru',
    'Вредно ли принимать ванну каждый день?',
    'Сушит ли кожу ежедневная ванна?',
  ),
  (
    'winter-hair-colors',
    'az',
    'Saç boyası saça zərərlidirmi?',
    'Saç boyası saça necə təsir edir?',
  ),
  (
    'winter-hair-colors',
    'az',
    'nəmləndirici qulluq zərəri azaldır',
    'nəmləndirici qulluq bu təsiri yumşaldır',
  ),
  (
    'winter-hair-colors',
    'ru',
    'Вредна ли краска для волос?',
    'Как краска влияет на волосы?',
  ),
  (
    'winter-hair-colors',
    'ru',
    'уменьшают вред',
    'смягчают это воздействие',
  ),
];

/// [data] (an article's JSON) with the [fixes] for [slug] applied to every
/// per-language text (title, summary, body, tips). Returns [data] itself
/// when nothing changed.
Map<String, Object?> applyWordingFixes(
  String slug,
  Map<String, Object?> data, [
  List<WordingFix> fixes = wordingFixes,
]) {
  final mine = fixes.where((f) => f.$1 == slug).toList();
  if (mine.isEmpty) return data;
  var changed = false;
  Object? fix(Object? value) {
    if (value is List) return [for (final v in value) fix(v)];
    if (value is! Map) return value;
    return {
      for (final e in value.entries)
        e.key: switch (e.value) {
          final String text => () {
            var next = text;
            for (final (_, lang, from, to) in mine) {
              if (lang == e.key) next = next.replaceAll(from, to);
            }
            if (next != text) changed = true;
            return next;
          }(),
          final other => fix(other),
        },
    };
  }

  final next = {for (final e in data.entries) e.key: fix(e.value)};
  return changed ? next : data;
}

/// The one-off task `fix-content-wording`: applies [fixes] to the draft and
/// the published text of the articles, as the admin [email]. An article
/// the team has already reworded is left as it is (the old wording is not
/// found). Each changed article is audited as `content.wording_fixed`.
Future<String> runFixContentWordingTask(
  Session session,
  String email, {
  List<WordingFix> fixes = wordingFixes,
}) async {
  final staff = await taskAdmin(session, email);
  final slugs = {for (final f in fixes) f.$1};
  final rows = await ContentItem.db.find(
    session,
    where: (t) => t.kind.equals(ContentKind.article.name) & t.slug.inSet(slugs),
  );
  final fixed = <String>[];
  for (final row in rows) {
    final draft = jsonDecode(row.draftJson) as Map<String, Object?>;
    final published = row.publishedJson == null
        ? null
        : jsonDecode(row.publishedJson!) as Map<String, Object?>;
    final d = applyWordingFixes(row.slug, draft, fixes);
    final p = published == null
        ? null
        : applyWordingFixes(row.slug, published, fixes);
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
      action: 'content.wording_fixed',
      objectType: 'content_item',
      objectId: updated.id.toString(),
    );
    fixed.add(row.slug);
  }
  final missing = slugs.where((s) => !rows.any((r) => r.slug == s));
  return [
    'Reworded ${fixed.length} articles'
        '${fixed.isEmpty ? '' : ': ${fixed.join(', ')}'}.',
    if (missing.isNotEmpty) 'No item: ${missing.join(', ')}.',
  ].join(' ');
}
