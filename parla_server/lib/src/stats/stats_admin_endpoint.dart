import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../staff/staff_guard.dart';

/// The smallest group shown; smaller counts are reported as "<10" so no
/// one can be singled out.
const minGroupSize = 10;

int? _safe(int n) => n < minGroupSize ? null : n;

/// Anonymous aggregate statistics for the admin panel (admins and
/// editors). Only counts leave the server, groups under [minGroupSize] are
/// hidden, and health answers (encrypted) are never counted.
class StatsAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<StatsReport> report(Session session) async {
    await requireStaff(session, roles: {StaffRole.admin, StaffRole.editor});
    return buildStatsReport(session);
  }
}

/// The report, as of [now].
Future<StatsReport> buildStatsReport(Session session, {DateTime? now}) async {
  final today = (now ?? DateTime.now()).toUtc();
  final groups = <StatsGroup>[];

  StatsGroup group(String name, Map<String, int> counts, {int? total}) =>
      StatsGroup(
        metric: name,
        counts: [
          for (final e in counts.entries)
            StatsCount(label: e.key, count: _safe(e.value)),
        ],
        total: total == null ? null : _safe(total),
      );

  Map<String, int> tally(Iterable<String> values) {
    final out = <String, int>{};
    for (final v in values) {
      out[v] = (out[v] ?? 0) + 1;
    }
    return out;
  }

  // Accounts and profiles.
  final profiles = await MemberProfile.db.find(session);
  final total = profiles.length;
  groups.add(group('accounts', {'total': total}));

  final weekStart = DateTime.utc(
    today.year,
    today.month,
    today.day,
  ).subtract(Duration(days: today.weekday - 1));
  final weeks = <String, int>{
    for (var i = 11; i >= 0; i--)
      _date(weekStart.subtract(Duration(days: 7 * i))): 0,
  };
  for (final p in profiles) {
    final c = p.createdAt.toUtc();
    final start = DateTime.utc(
      c.year,
      c.month,
      c.day,
    ).subtract(Duration(days: c.weekday - 1));
    final key = _date(start);
    if (weeks.containsKey(key)) weeks[key] = weeks[key]! + 1;
  }
  groups.add(group('signups_per_week', weeks));

  String ageBand(int birthYear) {
    final age = today.year - birthYear;
    if (age < 25) return '18-24';
    if (age < 35) return '25-34';
    if (age < 45) return '35-44';
    if (age < 55) return '45-54';
    return '55+';
  }

  groups.add(
    group('age_band', {
      for (final b in ['18-24', '25-34', '35-44', '45-54', '55+']) b: 0,
      ...tally(profiles.map((p) => ageBand(p.birthYear))),
    }, total: total),
  );
  groups.add(
    group('country', tally(profiles.map((p) => p.countryCode)), total: total),
  );
  groups.add(
    group('language', tally(profiles.map((p) => p.language)), total: total),
  );

  final deleted = await DeletedAccount.db.find(
    session,
    where: (t) => t.deletedAt > today.subtract(const Duration(days: 183)),
  );
  groups.add(
    group(
      'deleted_per_month',
      tally(deleted.map((d) => _date(d.deletedAt).substring(0, 7))),
    ),
  );

  // Consent: the latest decision of each current account.
  final members = {for (final p in profiles) p.authUserId};
  final records = await ConsentRecord.db.find(
    session,
    where: (t) => t.authUserId.inSet(members),
    orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
  );
  final granted = <String, int>{
    for (final type in ConsentType.values) type.name: 0,
  };
  final seen = <String>{};
  for (final r in records) {
    if (!seen.add('${r.authUserId}|${r.consentType.name}')) continue;
    if (r.granted) {
      granted[r.consentType.name] = granted[r.consentType.name]! + 1;
    }
  }
  groups.add(group('consent_granted', granted, total: total));

  // Quiz answers that are not health data (stored in plain form).
  final plain = [
    for (final q in quizQuestions)
      if (!q.sensitive && q.stored) q,
  ];
  final answers = await QuizAnswer.db.find(
    session,
    where: (t) => t.questionId.inSet({for (final q in plain) q.id}),
  );
  for (final q in plain) {
    final mine = answers.where((a) => a.questionId == q.id).toList();
    final counts = {for (final o in q.options) o.id: 0};
    for (final a in mine) {
      for (final o in a.optionIds) {
        if (counts.containsKey(o)) counts[o] = counts[o]! + 1;
      }
    }
    groups.add(group('quiz:${q.id}', counts, total: mine.length));
  }

  // Tools: how many accounts keep each on the server (only counts).
  groups.add(
    group('tools', {
      'custom_routines': await CustomRoutineRecord.db.count(session),
      'care_list': await CareListRecord.db.count(session),
      'sport': await SportRecord.db.count(session),
      'nutrition': await NutritionRecord.db.count(session),
    }, total: total),
  );

  // Daily active accounts, last 30 days.
  final from = _date(today.subtract(const Duration(days: 30)));
  final active = await DailyActiveCount.db.find(
    session,
    where: (t) => t.day >= from,
    orderBy: (t) => t.day,
  );
  groups.add(
    group('daily_active', {for (final a in active) a.day: a.accounts}),
  );

  return StatsReport(
    generatedAt: today,
    minGroupSize: minGroupSize,
    groups: groups,
  );
}

String _date(DateTime t) {
  final u = t.toUtc();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${u.year}-${two(u.month)}-${two(u.day)}';
}
