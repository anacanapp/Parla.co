import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../staff/staff_guard.dart';
import 'activity.dart' show dayOf;
import 'stats_admin_endpoint.dart' show minGroupSize;

/// Periods the dashboard offers, in days.
const dashboardPeriods = [7, 30, 90];

/// The admin dashboard (admins only). Like the statistics, only totals
/// leave the server and every count under [minGroupSize] is hidden.
class DashboardAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<DashboardReport> report(Session session, int days) async {
    await requireStaff(session, roles: {StaffRole.admin});
    return buildDashboard(session, days: days);
  }
}

int? _safe(int n) => n < minGroupSize ? null : n;

/// The dashboard for the [days] days up to [now] (today included).
Future<DashboardReport> buildDashboard(
  Session session, {
  required int days,
  DateTime? now,
}) async {
  final period = dashboardPeriods.contains(days) ? days : 30;
  final todayTime = (now ?? DateTime.now()).toUtc();
  String back(int n) => dayOf(todayTime.subtract(Duration(days: n)));
  final from = back(period - 1);
  final prevFrom = back(2 * period - 1);
  final dayList = [for (var i = period - 1; i >= 0; i--) back(i)];

  final kpis = <StatsCount>[];
  final groups = <StatsGroup>[];
  void kpi(String id, int n) => kpis.add(StatsCount(label: id, count: n));
  // Daily series are totals over time and shown as they are; breakdowns
  // by country, platform and the like hide counts under [minGroupSize].
  void group(
    String metric,
    Map<String, int> counts, {
    int? total,
    bool series = false,
  }) => groups.add(
    StatsGroup(
      metric: metric,
      counts: [
        for (final e in counts.entries)
          StatsCount(label: e.key, count: series ? e.value : _safe(e.value)),
      ],
      total: total == null ? null : (series ? total : _safe(total)),
    ),
  );

  // Accounts and sign-ups.
  final profiles = await MemberProfile.db.find(session);
  final signups = {for (final d in dayList) d: 0};
  var previous = 0;
  for (final p in profiles) {
    final d = dayOf(p.createdAt);
    if (signups.containsKey(d)) {
      signups[d] = signups[d]! + 1;
    } else if (d.compareTo(prevFrom) >= 0 && d.compareTo(from) < 0) {
      previous++;
    }
  }
  final signupTotal = signups.values.fold(0, (a, b) => a + b);
  kpi('accounts', profiles.length);
  kpi('signups', signupTotal);
  kpi('signups_previous', previous);
  group('signups_daily', signups, total: signupTotal, series: true);

  final deleted = await DeletedAccount.db.count(
    session,
    where: (t) => t.deletedAt >= DateTime.parse('${from}T00:00:00Z'),
  );
  kpi('deleted', deleted);

  // Active accounts (analytics consent only).
  final active = await DailyActiveCount.db.find(
    session,
    where: (t) => t.day >= from,
    orderBy: (t) => t.day,
  );
  final latest = active.isEmpty ? null : active.last;
  kpi('dau', latest?.accounts ?? 0);
  kpi('wau', latest?.weekly ?? 0);
  kpi('mau', latest?.monthly ?? 0);
  group('active_daily', {
    for (final a in active) a.day: a.accounts,
  }, series: true);
  group('active_weekly', {
    for (final a in active)
      if (a.weekly != null) a.day: a.weekly!,
  }, series: true);
  group('active_monthly', {
    for (final a in active)
      if (a.monthly != null) a.day: a.monthly!,
  }, series: true);
  final ios = active.fold(0, (s, a) => s + (a.ios ?? 0));
  final android = active.fold(0, (s, a) => s + (a.android ?? 0));
  final allActive = active.fold(0, (s, a) => s + a.accounts);
  group('active_platform', {
    UsagePlatform.ios.name: ios,
    UsagePlatform.android.name: android,
    UsagePlatform.other.name: allActive - ios - android,
  }, total: allActive);

  // Usage totals.
  final usage = await UsageDaily.db.find(
    session,
    where: (t) => t.day >= from,
  );
  Map<String, int> sum(
    Iterable<UsageDaily> rows,
    String Function(UsageDaily) key,
  ) {
    final out = <String, int>{};
    for (final r in rows) {
      final k = key(r);
      out[k] = (out[k] ?? 0) + r.times;
    }
    return out;
  }

  Iterable<UsageDaily> of(UsageEvent e) =>
      usage.where((r) => r.event == e.name);
  Map<String, int> sorted(Map<String, int> m, {int? top}) {
    final entries = m.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(top == null ? entries : entries.take(top));
  }

  final opens = of(UsageEvent.appOpen);
  final openTotal = opens.fold(0, (s, r) => s + r.times);
  kpi('app_opens', openTotal);
  group(
    'opens_daily',
    {
      for (final d in dayList) d: 0,
      ...sum(opens, (r) => r.day),
    },
    total: openTotal,
    series: true,
  );
  group(
    'opens_country',
    sorted(sum(opens, (r) => r.country)),
    total: openTotal,
  );
  group(
    'opens_platform',
    sorted(sum(opens, (r) => r.platform)),
    total: openTotal,
  );
  group('app_versions', sorted(sum(opens, (r) => r.target)), total: openTotal);

  final tools = of(UsageEvent.tool);
  final toolTotal = tools.fold(0, (s, r) => s + r.times);
  kpi('tool_opens', toolTotal);
  group('tools', {
    for (final t in UsageTool.values) t.name: 0,
    ...sum(tools, (r) => r.target),
  }, total: toolTotal);
  group(
    'tools_daily',
    {
      for (final d in dayList) d: 0,
      ...sum(tools, (r) => r.day),
    },
    total: toolTotal,
    series: true,
  );
  group(
    'tools_country',
    sorted(sum(tools, (r) => '${r.country}|${r.target}')),
    total: toolTotal,
  );

  // Content: the most opened articles and recipes, with their titles.
  Future<Map<String, int>> topContent(UsageEvent e, ContentKind kind) async {
    final counts = sorted(sum(of(e), (r) => r.target), top: 10);
    if (counts.isEmpty) return counts;
    final items = await ContentItem.db.find(
      session,
      where: (t) =>
          t.kind.equals(kind.name) & t.slug.inSet(counts.keys.toSet()),
    );
    final titles = {
      for (final i in items) i.slug: _title(i.publishedJson ?? i.draftJson),
    };
    return {
      for (final c in counts.entries)
        '${c.key}|${titles[c.key] ?? ''}': c.value,
    };
  }

  group(
    'articles_top',
    await topContent(UsageEvent.article, ContentKind.article),
  );
  group('recipes_top', await topContent(UsageEvent.recipe, ContentKind.recipe));

  // Banners: views and taps per banner, with title and sponsor.
  final views = sum(of(UsageEvent.bannerView), (r) => r.target);
  final taps = sum(of(UsageEvent.bannerTap), (r) => r.target);
  final bannerIds = {
    ...views.keys,
    ...taps.keys,
  }.map(int.tryParse).whereType<int>().toSet();
  final banners = bannerIds.isEmpty
      ? <ContentItem>[]
      : await ContentItem.db.find(
          session,
          where: (t) => t.id.inSet(bannerIds),
        );
  String bannerLabel(String id) {
    final item = banners.where((b) => b.id.toString() == id).firstOrNull;
    if (item == null) return '$id||';
    final json = _json(item.publishedJson ?? item.draftJson);
    final sponsor = json['sponsor'];
    final brand = sponsor is String ? sponsor.trim() : '';
    return '$id|${_title(item.publishedJson ?? item.draftJson)}|$brand';
  }

  final byViews = sorted(views);
  group('banner_views', {
    for (final e in byViews.entries) bannerLabel(e.key): e.value,
  });
  group('banner_taps', {
    for (final id in {...byViews.keys, ...taps.keys})
      bannerLabel(id): taps[id] ?? 0,
  });
  kpi('banner_views', views.values.fold(0, (a, b) => a + b));
  kpi('banner_taps', taps.values.fold(0, (a, b) => a + b));

  // Support.
  kpi(
    'support_unread',
    await SupportThread.db.count(
      session,
      where: (t) => t.unreadByStaff.equals(true),
    ),
  );

  return DashboardReport(
    generatedAt: todayTime,
    minGroupSize: minGroupSize,
    days: period,
    kpis: kpis,
    groups: groups,
  );
}

Map<String, Object?> _json(String raw) {
  try {
    final v = jsonDecode(raw);
    return v is Map<String, Object?> ? v : const {};
  } on FormatException {
    return const {};
  }
}

String _title(String raw) => ContentRules.pick(_json(raw)['title'], 'az');
