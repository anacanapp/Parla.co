import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'support_crypto.dart';

/// Rules of the support conversation.
abstract final class SupportRules {
  static const maxLength = 2000;

  /// Conversations are deleted this long after their last message.
  static const retention = Duration(days: 365);
}

abstract final class SupportErrors {
  static const empty = 'support.empty';
  static const tooLong = 'support.too_long';
  static const notFound = 'support.not_found';
}

String cleanSupportText(String text) {
  final t = text.trim();
  if (t.isEmpty) throw ParlaException(code: SupportErrors.empty);
  if (t.length > SupportRules.maxLength) {
    throw ParlaException(code: SupportErrors.tooLong);
  }
  return t;
}

/// The decrypted messages of [thread], oldest first.
Future<List<SupportEntry>> readSupportThread(
  Session session,
  SupportThread thread,
) async {
  final rows = await SupportMessage.db.find(
    session,
    where: (t) => t.threadId.equals(thread.id!),
    orderBy: (t) => t.createdAt,
  );
  // The thread as stored now: its key may have been made after [thread]
  // was read.
  final fresh = await SupportThread.db.findById(session, thread.id!) ?? thread;
  final keys = SupportCrypto.forReading(session, fresh);
  return [
    for (final r in rows)
      SupportEntry(
        fromStaff: r.fromStaff,
        text: await keys.open(r),
        createdAt: r.createdAt,
      ),
  ];
}

/// Adds a message to [thread] and updates its unread flags.
Future<SupportThread> addSupportMessage(
  Session session,
  SupportThread thread,
  String text, {
  UuidValue? staffId,
}) async {
  final crypto = await SupportCrypto.forWriting(session, thread);
  final sealed = await crypto.seal(text, thread.authUserId);
  final now = DateTime.now().toUtc();
  return session.db.transaction((transaction) async {
    await SupportMessage.db.insertRow(
      session,
      SupportMessage(
        threadId: thread.id!,
        fromStaff: staffId != null,
        staffId: staffId,
        ciphertext: sealed.ciphertext,
        nonce: sealed.nonce,
        keyVersion: crypto.version,
        createdAt: now,
      ),
      transaction: transaction,
    );
    return SupportThread.db.updateRow(
      session,
      thread.copyWith(
        open: true,
        lastMessageAt: now,
        unreadByStaff: staffId == null ? true : thread.unreadByStaff,
        unreadByUser: staffId != null ? true : thread.unreadByUser,
      ),
      // Never the key: [thread] may have been read before it was made.
      columns: (t) => [
        t.open,
        t.lastMessageAt,
        t.unreadByStaff,
        t.unreadByUser,
      ],
      transaction: transaction,
    );
  });
}

/// Deletes [userId]'s conversation (account deletion).
Future<void> eraseSupport(
  Session session,
  UuidValue userId, {
  Transaction? transaction,
}) async {
  final thread = await SupportThread.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(userId),
    transaction: transaction,
  );
  if (thread == null) return;
  await SupportMessage.db.deleteWhere(
    session,
    where: (t) => t.threadId.equals(thread.id!),
    transaction: transaction,
  );
  await SupportThread.db.deleteRow(session, thread, transaction: transaction);
}

/// Deletes conversations whose last message is older than the retention.
Future<int> expireSupport(Session session, {DateTime? now}) async {
  final cutoff = (now ?? DateTime.now()).toUtc().subtract(
    SupportRules.retention,
  );
  final old = await SupportThread.db.find(
    session,
    where: (t) => t.lastMessageAt < cutoff,
  );
  for (final t in old) {
    await SupportMessage.db.deleteWhere(
      session,
      where: (m) => m.threadId.equals(t.id!),
    );
    await SupportThread.db.deleteRow(session, t);
  }
  return old.length;
}
