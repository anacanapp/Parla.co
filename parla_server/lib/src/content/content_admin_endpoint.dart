import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../staff/staff_guard.dart';
import 'content_seed_import.dart';

/// Error codes of the content flow. The panel translates them.
abstract final class ContentErrors {
  static const notFound = 'content.not_found';
  static const invalid = 'content.invalid';
  static const incomplete = 'content.incomplete';
  static const slugTaken = 'content.slug_taken';
  static const wrongStatus = 'content.wrong_status';
  static const consentMissing = 'content.consent_missing';
}

const _writers = {StaffRole.admin, StaffRole.editor};
const _all = {StaffRole.admin, StaffRole.editor, StaffRole.expert};

/// Writing, reviewing and publishing content in the admin panel.
///
/// Flow: an editor saves a draft and sends it for review; an expert
/// approves it or returns it with a note; an editor or admin publishes the
/// approved copy. Expert profiles need no review but need the expert's
/// written consent recorded by an admin. Every step is audited.
class ContentAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<ContentAdminItem>> list(Session session, String kind) async {
    await requireStaff(session, roles: _all);
    final rows = await ContentItem.db.find(
      session,
      where: (t) => t.kind.equals(_kind(kind).name),
      orderByList: (t) => [t.updatedAt.desc()],
    );
    return [for (final r in rows) _view(r)];
  }

  Future<ContentAdminItem> create(
    Session session,
    String kind,
    String slug,
    String category,
  ) async {
    final staff = await requireStaff(session, roles: _writers);
    final k = _kind(kind);
    _checkMeta(k, slug, category);
    final now = DateTime.now().toUtc();
    final existing = await ContentItem.db.findFirstRow(
      session,
      where: (t) => t.kind.equals(k.name) & t.slug.equals(slug),
    );
    if (existing != null) throw ParlaException(code: ContentErrors.slugTaken);
    final row = await ContentItem.db.insertRow(
      session,
      ContentItem(
        kind: k.name,
        slug: slug,
        category: category,
        status: ContentStatus.draft,
        draftJson: '{}',
        createdBy: staff.authUserId,
        updatedBy: staff.authUserId,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await _audit(session, staff, 'content.created', row);
    return _view(row);
  }

  /// Saves the working copy. Changing an item in review or approved sends
  /// it back to draft: the next version needs its own review.
  Future<ContentAdminItem> saveDraft(
    Session session,
    int id,
    String json,
    String category,
  ) async {
    final staff = await requireStaff(session, roles: _writers);
    final row = await _get(session, id);
    final k = _kind(row.kind);
    _checkMeta(k, row.slug, category);
    if (ContentRules.problems(k, json).isNotEmpty) {
      throw ParlaException(code: ContentErrors.invalid);
    }
    final updated = await ContentItem.db.updateRow(
      session,
      row.copyWith(
        draftJson: json,
        category: category,
        status: ContentStatus.draft,
        reviewedBy: null,
        reviewedAt: null,
        updatedBy: staff.authUserId,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(session, staff, 'content.saved', updated);
    return _view(updated);
  }

  Future<ContentAdminItem> submitForReview(Session session, int id) async {
    final staff = await requireStaff(session, roles: _writers);
    final row = await _get(session, id);
    if (row.status != ContentStatus.draft) {
      throw ParlaException(code: ContentErrors.wrongStatus);
    }
    _checkComplete(row);
    return _set(session, staff, row, 'content.submitted', (r) {
      return r.copyWith(status: ContentStatus.inReview, reviewNote: null);
    });
  }

  /// An expert approves the working copy as it is now.
  Future<ContentAdminItem> approve(Session session, int id) async {
    final staff = await requireStaff(session, roles: {StaffRole.expert});
    final row = await _get(session, id);
    if (row.status != ContentStatus.inReview) {
      throw ParlaException(code: ContentErrors.wrongStatus);
    }
    _checkComplete(row);
    return _set(
      session,
      staff,
      row,
      'content.approved',
      (r) => r.copyWith(
        status: ContentStatus.approved,
        reviewedBy: staff.authUserId,
        reviewedAt: DateTime.now().toUtc(),
        reviewNote: null,
      ),
    );
  }

  /// An expert sends it back to the writer with a note.
  Future<ContentAdminItem> returnToWriter(
    Session session,
    int id,
    String note,
  ) async {
    final staff = await requireStaff(session, roles: {StaffRole.expert});
    final row = await _get(session, id);
    if (row.status != ContentStatus.inReview) {
      throw ParlaException(code: ContentErrors.wrongStatus);
    }
    final clean = note.trim();
    return _set(
      session,
      staff,
      row,
      'content.returned',
      (r) => r.copyWith(
        status: ContentStatus.draft,
        reviewNote: clean.length > 1000 ? clean.substring(0, 1000) : clean,
      ),
    );
  }

  /// Records that the expert gave written consent to be listed, with a
  /// reference to where the signed document is kept.
  Future<ContentAdminItem> recordConsent(
    Session session,
    int id,
    String reference,
  ) async {
    final staff = await requireStaff(session, roles: {StaffRole.admin});
    final row = await _get(session, id);
    if (row.kind != ContentKind.expert.name) {
      throw ParlaException(code: ContentErrors.wrongStatus);
    }
    final clean = reference.trim();
    if (clean.isEmpty || clean.length > 200) {
      throw ParlaException(code: ContentErrors.invalid);
    }
    return _set(
      session,
      staff,
      row,
      'content.consent_recorded',
      (r) => r.copyWith(
        consentRecordedAt: DateTime.now().toUtc(),
        consentNote: clean,
      ),
    );
  }

  /// Makes the working copy live. Articles and recipes must be approved by
  /// an expert; expert profiles need the recorded consent.
  Future<ContentAdminItem> publish(Session session, int id) async {
    final staff = await requireStaff(session, roles: _writers);
    final row = await _get(session, id);
    _checkComplete(row);
    final isExpert = row.kind == ContentKind.expert.name;
    if (isExpert) {
      if (row.consentRecordedAt == null) {
        throw ParlaException(code: ContentErrors.consentMissing);
      }
    } else if (row.status != ContentStatus.approved) {
      throw ParlaException(code: ContentErrors.wrongStatus);
    }
    final now = DateTime.now().toUtc();
    return _set(
      session,
      staff,
      row,
      'content.published',
      (r) => r.copyWith(
        status: ContentStatus.published,
        publishedJson: r.draftJson,
        publishedReviewedAt: isExpert ? null : r.reviewedAt,
        publishedAt: now,
      ),
    );
  }

  Future<ContentAdminItem> unpublish(Session session, int id) async {
    final staff = await requireStaff(session, roles: _writers);
    final row = await _get(session, id);
    return _set(
      session,
      staff,
      row,
      'content.unpublished',
      (r) => r.copyWith(
        status: r.status == ContentStatus.published
            ? ContentStatus.draft
            : r.status,
        publishedJson: null,
        publishedReviewedAt: null,
        publishedAt: null,
      ),
    );
  }

  /// Imports the articles and recipes of the content sheet as drafts
  /// (admins only). Slugs that already exist are skipped, so running it
  /// again never overwrites the team's edits. Returns how many were added.
  Future<int> importSheet(Session session) async {
    final staff = await requireStaff(session, roles: {StaffRole.admin});
    var added = 0;
    for (final seed in contentSeed) {
      if (seed.problems.isNotEmpty) continue;
      final exists = await ContentItem.db.findFirstRow(
        session,
        where: (t) => t.kind.equals(seed.kind) & t.slug.equals(seed.slug),
      );
      if (exists != null) continue;
      final now = DateTime.now().toUtc();
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
      added++;
    }
    return added;
  }

  /// Deletes an item that is not live (admins only).
  Future<void> delete(Session session, int id) async {
    final staff = await requireStaff(session, roles: {StaffRole.admin});
    final row = await _get(session, id);
    if (row.publishedJson != null) {
      throw ParlaException(code: ContentErrors.wrongStatus);
    }
    await ContentItem.db.deleteRow(session, row);
    await _audit(session, staff, 'content.deleted', row);
  }

  static ContentKind _kind(String name) {
    for (final k in ContentKind.values) {
      if (k.name == name) return k;
    }
    throw ParlaException(code: ContentErrors.invalid);
  }

  static void _checkMeta(ContentKind kind, String slug, String category) {
    if (!ContentRules.isSlug(slug) ||
        !ContentRules.categoriesFor(kind).contains(category)) {
      throw ParlaException(code: ContentErrors.invalid);
    }
  }

  static void _checkComplete(ContentItem row) {
    if (ContentRules.problems(
      _kind(row.kind),
      row.draftJson,
      complete: true,
    ).isNotEmpty) {
      throw ParlaException(code: ContentErrors.incomplete);
    }
  }

  Future<ContentItem> _get(Session session, int id) async {
    final row = await ContentItem.db.findById(session, id);
    if (row == null) throw ParlaException(code: ContentErrors.notFound);
    return row;
  }

  Future<ContentAdminItem> _set(
    Session session,
    StaffMember staff,
    ContentItem row,
    String action,
    ContentItem Function(ContentItem) change,
  ) async {
    final updated = await ContentItem.db.updateRow(
      session,
      change(row).copyWith(
        updatedBy: staff.authUserId,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(session, staff, action, updated);
    return _view(updated);
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

  static ContentAdminItem _view(ContentItem r) => ContentAdminItem(
    id: r.id!,
    kind: r.kind,
    slug: r.slug,
    category: r.category,
    status: r.status,
    draftJson: r.draftJson,
    live: r.publishedJson != null,
    reviewedAt: r.reviewedAt,
    reviewNote: r.reviewNote,
    consentRecorded: r.consentRecordedAt != null,
    updatedAt: r.updatedAt,
  );
}
