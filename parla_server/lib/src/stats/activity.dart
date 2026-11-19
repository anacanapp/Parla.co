import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// UTC day as yyyy-mm-dd.
String dayOf(DateTime t) {
  final u = t.toUtc();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${u.year}-${two(u.month)}-${two(u.day)}';
}

DateTime _parseDay(String day) => DateTime.parse('${day}T00:00:00Z');

/// The account's activity mark: an HMAC of its id with the server's
/// pseudonym pepper. The same for every day (needed to count an account
/// once per week or month), but it cannot be linked to the account without
/// the pepper. `null` without the pepper.
String? activityMark(Session session, UuidValue userId) {
  final pepper = session.passwords['pseudonymPepper'];
  if (pepper == null || pepper.isEmpty) return null;
  final mac = Hmac(sha256, utf8.encode(pepper));
  return mac.convert(utf8.encode('active|$userId')).toString();
}

/// Notes that [userId] used the app today (once per day).
Future<void> markActive(
  Session session,
  UuidValue userId, {
  UsagePlatform? platform,
  DateTime? now,
}) async {
  final day = dayOf(now ?? DateTime.now());
  final mark = activityMark(session, userId);
  if (mark == null) return;
  final exists = await DailyActiveMark.db.findFirstRow(
    session,
    where: (t) => t.day.equals(day) & t.mark.equals(mark),
  );
  if (exists != null) {
    if (exists.platform == null && platform != null) {
      await DailyActiveMark.db.updateRow(
        session,
        exists.copyWith(platform: platform.name),
      );
    }
    return;
  }
  try {
    await DailyActiveMark.db.insertRow(
      session,
      DailyActiveMark(day: day, mark: mark, platform: platform?.name),
    );
  } on DatabaseException {
    // A parallel request marked the same day first.
  }
}

/// Removes all of [userId]'s marks (account deletion, analytics consent
/// withdrawn).
Future<void> eraseActivityMarks(
  Session session,
  UuidValue userId, {
  Transaction? transaction,
}) async {
  final mark = activityMark(session, userId);
  if (mark == null) return;
  await DailyActiveMark.db.deleteWhere(
    session,
    where: (t) => t.mark.equals(mark),
    transaction: transaction,
  );
}

/// Adds one report's counts to the day's totals. No row names the account:
/// only its profile country and the platform are kept with the counts.
Future<void> addUsage(
  Session session, {
  required String country,
  required UsagePlatform platform,
  required Map<(UsageEvent, String), int> counts,
  DateTime? now,
}) async {
  if (counts.isEmpty) return;
  final day = dayOf(now ?? DateTime.now());
  await session.db.transaction((transaction) async {
    for (final e in counts.entries) {
      await session.db.unsafeExecute(
        'INSERT INTO "usage_daily" '
        '("day", "country", "platform", "event", "target", "times") '
        'VALUES (@day, @country, @platform, @event, @target, @count) '
        'ON CONFLICT ("day", "country", "platform", "event", "target") '
        'DO UPDATE SET "times" = "usage_daily"."times" + EXCLUDED."times"',
        parameters: QueryParameters.named({
          'day': day,
          'country': country,
          'platform': platform.name,
          'event': e.key.$1.name,
          'target': e.key.$2,
          'count': e.value,
        }),
        transaction: transaction,
      );
    }
  });
}

/// Makes the totals of every finished day not counted yet (active
/// accounts that day, in the 7 and 30 days up to it, and per platform),
/// then deletes marks older than [UsageRules.markDays] and usage totals
/// older than [UsageRules.keepMonths]. Returns how many days were counted.
Future<int> rollUpActivity(Session session, {DateTime? now}) async {
  final todayTime = (now ?? DateTime.now()).toUtc();
  final today = dayOf(todayTime);
  return session.db.transaction((transaction) async {
    final marks = await DailyActiveMark.db.find(
      session,
      where: (t) => t.day < today,
      transaction: transaction,
    );
    final done = {
      for (final c in await DailyActiveCount.db.find(
        session,
        where: (t) => t.weekly.notEquals(null),
        transaction: transaction,
      ))
        c.day,
    };
    // A finished day is counted once: later its oldest marks are gone.
    final days = {
      for (final m in marks)
        if (!done.contains(m.day)) m.day,
    };
    for (final day in days) {
      final end = _parseDay(day);
      String back(int n) => dayOf(end.subtract(Duration(days: n)));
      final week = back(6);
      final month = back(29);
      final onDay = marks.where((m) => m.day == day).toList();
      final weekly = {
        for (final m in marks)
          if (m.day.compareTo(week) >= 0 && m.day.compareTo(day) <= 0) m.mark,
      }.length;
      final monthly = {
        for (final m in marks)
          if (m.day.compareTo(month) >= 0 && m.day.compareTo(day) <= 0) m.mark,
      }.length;
      final row = DailyActiveCount(
        day: day,
        accounts: onDay.length,
        weekly: weekly,
        monthly: monthly,
        ios: onDay.where((m) => m.platform == UsagePlatform.ios.name).length,
        android: onDay
            .where((m) => m.platform == UsagePlatform.android.name)
            .length,
      );
      final existing = await DailyActiveCount.db.findFirstRow(
        session,
        where: (t) => t.day.equals(day),
        transaction: transaction,
      );
      if (existing == null) {
        await DailyActiveCount.db.insertRow(
          session,
          row,
          transaction: transaction,
        );
      } else {
        await DailyActiveCount.db.updateRow(
          session,
          row.copyWith(id: existing.id),
          transaction: transaction,
        );
      }
    }
    final oldest = dayOf(
      todayTime.subtract(const Duration(days: UsageRules.markDays)),
    );
    await DailyActiveMark.db.deleteWhere(
      session,
      where: (t) => t.day < oldest,
      transaction: transaction,
    );
    final keepFrom = dayOf(
      DateTime.utc(
        todayTime.year,
        todayTime.month - UsageRules.keepMonths,
        todayTime.day,
      ),
    );
    await UsageDaily.db.deleteWhere(
      session,
      where: (t) => t.day < keepFrom,
      transaction: transaction,
    );
    return days.length;
  });
}
