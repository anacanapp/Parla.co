import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// UTC day as yyyy-mm-dd.
String dayOf(DateTime t) {
  final u = t.toUtc();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${u.year}-${two(u.month)}-${two(u.day)}';
}

/// The day's mark for [userId]: an HMAC with the server's pseudonym pepper,
/// so marks cannot be linked to an account or across days without it.
String? activityMark(Session session, UuidValue userId, String day) {
  final pepper = session.passwords['pseudonymPepper'];
  if (pepper == null || pepper.isEmpty) return null;
  final mac = Hmac(sha256, utf8.encode(pepper));
  return mac.convert(utf8.encode('active|$day|$userId')).toString();
}

/// Notes that [userId] used the app today (once per day).
Future<void> markActive(
  Session session,
  UuidValue userId, {
  DateTime? now,
}) async {
  final day = dayOf(now ?? DateTime.now());
  final mark = activityMark(session, userId, day);
  if (mark == null) return;
  final exists = await DailyActiveMark.db.findFirstRow(
    session,
    where: (t) => t.day.equals(day) & t.mark.equals(mark),
  );
  if (exists != null) return;
  try {
    await DailyActiveMark.db.insertRow(
      session,
      DailyActiveMark(day: day, mark: mark),
    );
  } on DatabaseException {
    // A parallel request marked the same day first.
  }
}

/// Removes [userId]'s marks of today and yesterday (account deletion).
Future<void> eraseActivityMarks(
  Session session,
  UuidValue userId, {
  Transaction? transaction,
  DateTime? now,
}) async {
  final today = (now ?? DateTime.now()).toUtc();
  for (final day in [
    dayOf(today),
    dayOf(today.subtract(const Duration(days: 1))),
  ]) {
    final mark = activityMark(session, userId, day);
    if (mark == null) continue;
    await DailyActiveMark.db.deleteWhere(
      session,
      where: (t) => t.day.equals(day) & t.mark.equals(mark),
      transaction: transaction,
    );
  }
}

/// Turns the marks of days before today into totals and deletes them.
/// Returns how many days were counted.
Future<int> rollUpActivity(Session session, {DateTime? now}) async {
  final today = dayOf(now ?? DateTime.now());
  return session.db.transaction((transaction) async {
    final marks = await DailyActiveMark.db.find(
      session,
      where: (t) => t.day < today,
      transaction: transaction,
    );
    final perDay = <String, int>{};
    for (final m in marks) {
      perDay[m.day] = (perDay[m.day] ?? 0) + 1;
    }
    for (final e in perDay.entries) {
      final existing = await DailyActiveCount.db.findFirstRow(
        session,
        where: (t) => t.day.equals(e.key),
        transaction: transaction,
      );
      if (existing == null) {
        await DailyActiveCount.db.insertRow(
          session,
          DailyActiveCount(day: e.key, accounts: e.value),
          transaction: transaction,
        );
      } else {
        await DailyActiveCount.db.updateRow(
          session,
          existing.copyWith(accounts: existing.accounts + e.value),
          transaction: transaction,
        );
      }
    }
    await DailyActiveMark.db.deleteWhere(
      session,
      where: (t) => t.day < today,
      transaction: transaction,
    );
    return perDay.length;
  });
}
