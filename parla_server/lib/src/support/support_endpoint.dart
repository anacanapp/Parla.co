import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'support.dart';

/// The user's own conversation with the Parla team. Messages are stored
/// encrypted and deleted 12 months after the last message or with the
/// account.
class SupportEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The conversation, oldest first (empty when none). Marks the team's
  /// replies as read.
  Future<List<SupportEntry>> myMessages(Session session) async {
    final userId = session.authenticated!.authUserId;
    final thread = await SupportThread.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    if (thread == null) return const [];
    if (thread.unreadByUser) {
      await SupportThread.db.updateRow(
        session,
        thread.copyWith(unreadByUser: false),
      );
    }
    return readSupportThread(session, thread);
  }

  /// Whether the team replied and the user has not read it yet.
  Future<bool> hasUnreadReply(Session session) async {
    final thread = await SupportThread.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(session.authenticated!.authUserId),
    );
    return thread?.unreadByUser ?? false;
  }

  Future<void> send(Session session, String text) async {
    final clean = cleanSupportText(text);
    final userId = session.authenticated!.authUserId;
    var thread = await SupportThread.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final now = DateTime.now().toUtc();
    thread ??= await SupportThread.db.insertRow(
      session,
      SupportThread(
        authUserId: userId,
        open: true,
        unreadByStaff: true,
        unreadByUser: false,
        createdAt: now,
        lastMessageAt: now,
      ),
    );
    await addSupportMessage(session, thread, clean);
  }
}
