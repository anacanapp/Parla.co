import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../media/media_sync.dart';
import 'content_admin_endpoint.dart' show ContentErrors;
import 'content_seed_import.dart';

/// Refuses content whose images are not complete (licence, alt text).
Future<void> checkContentImages(Session session, String json) async {
  for (final id in MediaRules.imageIdsOf(
    jsonDecode(json) as Map<String, Object?>,
  )) {
    final asset = await MediaAsset.db.findById(session, id);
    if (asset == null ||
        MediaRules.problems(
          license: asset.license,
          source: asset.source,
          altJson: asset.altJson,
          complete: true,
        ).isNotEmpty) {
      throw ParlaException(code: ContentErrors.imageIncomplete);
    }
  }
}

Future<void> _audit(
  Session session,
  StaffMember staff,
  String action,
  ContentItem row,
) => writeAudit(
  session,
  actorId: staff.authUserId,
  actorRole: AuditActor.staff,
  action: action,
  objectType: 'content_item',
  objectId: row.id.toString(),
);

/// Imports the sheet's articles and recipes as drafts for [staff] (an
/// admin). An existing item is left alone, except a draft that still holds
/// only the first sheet's writing plan, which gets the full article.
/// Returns how many items were added or filled in.
Future<int> importContentSeed(Session session, StaffMember staff) async {
  var changed = 0;
  for (final seed in importSeed) {
    if (seed.problems.isNotEmpty) continue;
    final exists = await ContentItem.db.findFirstRow(
      session,
      where: (t) => t.kind.equals(seed.kind) & t.slug.equals(seed.slug),
    );
    final now = DateTime.now().toUtc();
    if (exists != null) {
      if (seed.kind != 'article' ||
          exists.status != ContentStatus.draft ||
          !isUntouchedPlan(seed.slug, exists.draftJson) ||
          !blogSeed.contains(seed)) {
        continue;
      }
      final row = await ContentItem.db.updateRow(
        session,
        exists.copyWith(
          draftJson: mergeSeed(exists.draftJson, seed.json),
          category: seed.category,
          updatedBy: staff.authUserId,
          updatedAt: now,
        ),
      );
      await _audit(session, staff, 'content.reimported', row);
      changed++;
      continue;
    }
    final row = await ContentItem.db.insertRow(
      session,
      ContentItem(
        kind: seed.kind,
        slug: seed.slug,
        category: seed.category,
        status: ContentStatus.draft,
        draftJson: seed.json,
        createdBy: staff.authUserId,
        updatedBy: staff.authUserId,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await _audit(session, staff, 'content.imported', row);
    changed++;
  }
  return changed;
}

/// Publishes the imported blog articles and recipes that are still drafts,
/// without the expert's approval (the owner's decision of 2026-11-20, while
/// the app is not public). Each is audited as
/// `content.published_unreviewed` with [staff] as the actor and keeps no
/// review date. Returns how many were published.
Future<int> publishImportedContent(Session session, StaffMember staff) async {
  final rows = <ContentItem>[];
  for (final (kind, seed) in [
    (ContentKind.article, blogSeed),
    (ContentKind.recipe, recipeSeed),
  ]) {
    rows.addAll(
      await ContentItem.db.find(
        session,
        where: (t) =>
            t.kind.equals(kind.name) &
            t.slug.inSet({for (final s in seed) s.slug}) &
            t.status.equals(ContentStatus.draft),
      ),
    );
  }
  var published = 0;
  for (final row in rows) {
    if (ContentRules.problems(
      ContentKind.values.byName(row.kind),
      row.draftJson,
      complete: true,
    ).isNotEmpty) {
      continue;
    }
    await checkContentImages(session, row.draftJson);
    final updated = await ContentItem.db.updateRow(
      session,
      row.copyWith(
        status: ContentStatus.published,
        publishedJson: row.draftJson,
        publishedReviewedAt: null,
        publishedAt: DateTime.now().toUtc(),
        updatedBy: staff.authUserId,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(session, staff, 'content.published_unreviewed', updated);
    published++;
  }
  if (published > 0) await syncPublicMedia(session);
  return published;
}

/// Article drafts that still hold the first sheet's writing plan (the
/// marker is in their text) get the full article, even if the plan itself
/// was edited: the plan is a placeholder, never the team's text. A cover
/// and hashtags already set are kept. Returns how many were filled.
Future<int> refillPlanDrafts(Session session, StaffMember staff) async {
  final full = {for (final b in blogSeed) b.slug: b};
  final rows = await ContentItem.db.find(
    session,
    where: (t) =>
        t.kind.equals(ContentKind.article.name) &
        t.slug.inSet(full.keys.toSet()) &
        t.status.equals(ContentStatus.draft),
  );
  var filled = 0;
  for (final row in rows) {
    final body = (jsonDecode(row.draftJson) as Map<String, Object?>)['body'];
    final hasPlan =
        body is Map &&
        body.values.any(
          (v) => v is String && v.contains(ContentRules.planMarker),
        );
    if (!hasPlan) continue;
    final seed = full[row.slug]!;
    final updated = await ContentItem.db.updateRow(
      session,
      row.copyWith(
        draftJson: mergeSeed(row.draftJson, seed.json),
        updatedBy: staff.authUserId,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(session, staff, 'content.reimported', updated);
    filled++;
  }
  return filled;
}

/// The one-off task `PARLA_TASK=publish-imported`: imports and publishes
/// the sheet's content as the admin whose email is in
/// `PARLA_TASK_ACTOR`, so the audit names who asked for it. Returns a line
/// for the log.
Future<String> runPublishImportedTask(Session session, String email) async {
  final account = await EmailAccount.db.findFirstRow(
    session,
    where: (t) => t.email.equals(email.trim().toLowerCase()),
  );
  if (account == null) throw StateError('No account for the task actor.');
  final staff = await StaffMember.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(account.authUserId),
  );
  if (staff == null || !staff.active || staff.role != StaffRole.admin) {
    throw StateError('The task actor is not an active admin.');
  }
  final added = await importContentSeed(session, staff);
  final refilled = await refillPlanDrafts(session, staff);
  final published = await publishImportedContent(session, staff);
  return 'Imported or filled $added items, refilled $refilled plans, '
      'published $published.';
}
