import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../staff/staff_guard.dart';
import '../stats/activity.dart' show dayOf;
import 'site_stats.dart';

/// The website's statistics for the admin panel (admins only): totals of
/// the last days per metric. The totals name no visitor, so small counts
/// are shown as they are.
class SiteStatsAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The totals of the last [days] days (1 to 366), today included.
  Future<StatsReport> report(Session session, int days) async {
    await requireStaff(session, roles: {StaffRole.admin});
    return buildSiteReport(session, days);
  }
}

/// The report of the last [days] days as of [now].
Future<StatsReport> buildSiteReport(
  Session session,
  int days, {
  DateTime? now,
}) async {
  final span = days.clamp(1, 366);
  final today = (now ?? DateTime.now()).toUtc();
  final first = dayOf(today.subtract(Duration(days: span - 1)));
  final rows = await SiteStatDaily.db.find(
    session,
    where: (t) => t.day >= first,
  );
  final groups = <StatsGroup>[];
  for (final metric in SiteStats.metrics) {
    final counts = <String, int>{};
    for (final r in rows.where((r) => r.metric == metric)) {
      // Visitors are per day; the other totals add up over the days.
      final label = metric == SiteStats.visitors ? r.day : r.target;
      counts[label] = (counts[label] ?? 0) + r.times;
    }
    final sorted = counts.entries.toList()
      ..sort(
        (a, b) => metric == SiteStats.visitors
            ? a.key.compareTo(b.key)
            : b.value.compareTo(a.value),
      );
    groups.add(
      StatsGroup(
        metric: 'site:$metric',
        counts: [
          for (final e in sorted.take(metric == SiteStats.visitors ? 366 : 30))
            StatsCount(label: e.key, count: e.value),
        ],
        total: counts.values.fold<int>(0, (a, b) => a + b),
      ),
    );
  }
  return StatsReport(
    generatedAt: DateTime.now().toUtc(),
    minGroupSize: 1,
    groups: groups,
  );
}
