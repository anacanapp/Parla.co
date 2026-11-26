import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../staff/staff_guard.dart';
import '../push/push.dart';
import 'support.dart';

const _roles = {StaffRole.admin, StaffRole.support};

/// Support conversations in the admin panel (support role and admins). The
/// list shows no message text; opening a conversation is audited.
class SupportAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<SupportThreadSummary>> threads(Session session) async {
    await requireStaff(session, roles: _roles);
    final rows = await SupportThread.db.find(
      session,
      orderByList: (t) => [t.open.desc(), t.lastMessageAt.desc()],
      limit: 200,
    );
    final emails = await EmailAccount.db.find(
      session,
      where: (t) => t.authUserId.inSet({for (final r in rows) r.authUserId}),
    );
    final byUser = {for (final e in emails) e.authUserId: e.email};
    return [
      for (final r in rows)
        SupportThreadSummary(
          id: r.id!,
          email: byUser[r.authUserId] ?? '',
          open: r.open,
          unreadByStaff: r.unreadByStaff,
          lastMessageAt: r.lastMessageAt,
        ),
    ];
  }

  Future<List<SupportEntry>> open(Session session, int threadId) async {
    final staff = await requireStaff(session, roles: _roles);
    final thread = await _get(session, threadId);
    await writeAudit(
      session,
      actorId: staff.authUserId,
      actorRole: AuditActor.staff,
      action: 'support.viewed',
      objectType: 'account',
      objectId: thread.authUserId.toString(),
    );
    if (thread.unreadByStaff) {
      await SupportThread.db.updateRow(
        session,
        thread.copyWith(unreadByStaff: false),
        columns: (t) => [t.unreadByStaff],
      );
    }
    return readSupportThread(session, thread);
  }

  Future<void> reply(Session session, int threadId, String text) async {
    final staff = await requireStaff(session, roles: _roles);
    final clean = cleanSupportText(text);
    final thread = await _get(session, threadId);
    await addSupportMessage(
      session,
      thread.copyWith(unreadByStaff: false),
      clean,
      staffId: staff.authUserId,
    );
    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(thread.authUserId),
    );
    // A service notice without the reply's text.
    await pushToUser(
      session,
      thread.authUserId,
      supportReplyNotice(profile?.language ?? 'az'),
    );
    await writeAudit(
      session,
      actorId: staff.authUserId,
      actorRole: AuditActor.staff,
      action: 'support.replied',
      objectType: 'account',
      objectId: thread.authUserId.toString(),
    );
  }

  Future<void> close(Session session, int threadId) async {
    final staff = await requireStaff(session, roles: _roles);
    final thread = await _get(session, threadId);
    await SupportThread.db.updateRow(
      session,
      thread.copyWith(open: false),
      columns: (t) => [t.open],
    );
    await writeAudit(
      session,
      actorId: staff.authUserId,
      actorRole: AuditActor.staff,
      action: 'support.closed',
      objectType: 'account',
      objectId: thread.authUserId.toString(),
    );
  }

  Future<SupportThread> _get(Session session, int id) async {
    final row = await SupportThread.db.findById(session, id);
    if (row == null) throw ParlaException(code: SupportErrors.notFound);
    return row;
  }
}
