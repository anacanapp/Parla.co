import 'package:flutter/material.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/charts.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import 'stats_screen.dart';

/// Names of the counted tools (UsageTool) in the panel.
const toolLabels = {
  'home': 'Bu gün (ana səhifə)',
  'habits': 'Vərdişlər və rutin',
  'reminders': 'Xatırlatmalar',
  'routineBuilder': 'Öz rutinim',
  'check': 'Yoxla (məhsul axtarışı)',
  'productDetail': 'Məhsul səhifəsi',
  'shoppingList': 'Alış-veriş siyahısı',
  'shop': 'Mağaza',
  'sport': 'İdman planı',
  'sportQuiz': 'İdman sualları',
  'workout': 'Məşq',
  'discover': 'Kəşf et',
  'blog': 'Bloq',
  'experts': 'Mütəxəssislər',
  'nutrition': 'Qidalanma',
  'messages': 'Mesajlar',
  'privacy': 'Məxfilik',
};

const _countryNames = {
  'AZ': 'Azərbaycan',
  'TR': 'Türkiyə',
  'KZ': 'Qazaxıstan',
  'UZ': 'Özbəkistan',
  '--': 'Məlum deyil',
};

const _platformNames = {'ios': 'iOS', 'android': 'Android', 'other': 'Digər'};

const _periods = [7, 30, 90];

/// The admin dashboard: users, activity, tools, content, banners and the
/// audience. Admins only; every number is an anonymous total.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _days = 30;
  int _tab = 0;
  int _activeSeries = 0;
  DashboardReport? _report;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final r = await widget.state.api.dashboard(_days);
      if (mounted) setState(() => _report = r);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  int? _kpi(String id) =>
      _report?.kpis.where((k) => k.label == id).firstOrNull?.count;

  StatsGroup? _group(String metric) =>
      _report?.groups.where((g) => g.metric == metric).firstOrNull;

  List<DayValue> _series(String metric) => [
    for (final c in _group(metric)?.counts ?? const <StatsCount>[])
      (day: c.label, value: c.count),
  ];

  List<BarEntry> _bars(
    String metric, {
    String Function(String)? label,
    String? Function(String)? hint,
  }) => [
    for (final c in _group(metric)?.counts ?? const <StatsCount>[])
      (
        label: label == null ? c.label : label(c.label),
        hint: hint?.call(c.label),
        count: c.count,
      ),
  ]..sort((a, b) => (b.count ?? 0).compareTo(a.count ?? 0));

  String _n(int? v) => v == null ? '<${_report?.minGroupSize ?? 10}' : '$v';

  @override
  Widget build(BuildContext context) {
    final r = _report;
    return AdminPage(
      title: 'Dashboard',
      subtitle:
          'Anonim, toplu rəqəmlər. İstifadə statistikası yalnız analitika '
          'razılığı verənlərdən gəlir; bölgülərdə 10-dan az say "<10" '
          'görünür. Sağlamlıq cavabları heç vaxt sayılmır.',
      actions: [
        PillTabs(
          labels: [for (final d in _periods) '$d gün'],
          keys: [for (final d in _periods) ValueKey('period-$d')],
          selected: _periods.indexOf(_days),
          onSelected: (i) {
            setState(() => _days = _periods[i]);
            _load();
          },
        ),
        OutlinedButton.icon(
          key: const ValueKey('dashboard-refresh'),
          onPressed: _load,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Yenilə'),
        ),
      ],
      children: [
        PillTabs(
          labels: const [
            'Ümumi baxış',
            'Alətlər',
            'Məzmun və reklam',
            'Auditoriya',
          ],
          keys: const [
            ValueKey('dash-tab-overview'),
            ValueKey('dash-tab-tools'),
            ValueKey('dash-tab-content'),
            ValueKey('dash-tab-audience'),
          ],
          selected: _tab,
          onSelected: (i) => setState(() => _tab = i),
        ),
        const SizedBox(height: 20),
        if (_error != null)
          Notice(
            tone: NoticeTone.danger,
            icon: Icons.error_outline,
            title: errorText(_error!),
          ),
        if (_tab == 3)
          AudienceStats(state: widget.state)
        else if (r == null && _error == null)
          const LoadingBlock()
        else if (r != null)
          ...switch (_tab) {
            0 => _overview(),
            1 => _tools(),
            _ => _content(),
          },
      ],
    );
  }

  List<Widget> _overview() {
    final signups = _kpi('signups') ?? 0;
    final previous = _kpi('signups_previous') ?? 0;
    final change = previous == 0
        ? null
        : ((signups - previous) * 100 / previous).round();
    const series = ['active_daily', 'active_weekly', 'active_monthly'];
    const seriesNames = ['Gündəlik', 'Həftəlik', 'Aylıq'];
    return [
      ResponsiveGrid(
        minItemWidth: 230,
        children: [
          StatCard(
            label: 'Hesablar',
            value: _n(_kpi('accounts')),
            valueKey: const ValueKey('kpi-accounts'),
            hint: 'Cəmi açıq hesab',
            highlight: true,
          ),
          StatCard(
            label: 'Yeni qeydiyyat',
            value: _n(signups),
            valueKey: const ValueKey('kpi-signups'),
            hint: change == null
                ? 'Son $_days gün'
                : 'Son $_days gün · əvvəlki dövrə görə '
                      '${change >= 0 ? '+' : ''}$change%',
          ),
          StatCard(
            label: 'Gündəlik aktiv (DAU)',
            value: _n(_kpi('dau')),
            valueKey: const ValueKey('kpi-dau'),
            hint: 'Dünən',
          ),
          StatCard(
            label: 'Həftəlik aktiv (WAU)',
            value: _n(_kpi('wau')),
            valueKey: const ValueKey('kpi-wau'),
            hint: 'Dünənə qədər 7 gün',
          ),
          StatCard(
            label: 'Aylıq aktiv (MAU)',
            value: _n(_kpi('mau')),
            valueKey: const ValueKey('kpi-mau'),
            hint: 'Dünənə qədər 30 gün',
          ),
          StatCard(
            label: 'Tətbiq açılışları',
            value: _n(_kpi('app_opens')),
            valueKey: const ValueKey('kpi-opens'),
            hint: 'Son $_days gün',
          ),
          StatCard(
            label: 'Silinən hesablar',
            value: _n(_kpi('deleted')),
            hint: 'Son $_days gün',
          ),
          StatCard(
            label: 'Oxunmamış dəstək',
            value: _n(_kpi('support_unread')),
            hint: 'Cavab gözləyən söhbətlər',
          ),
        ],
      ),
      const SizedBox(height: 20),
      ResponsiveGrid(
        minItemWidth: 420,
        children: [
          SectionCard(
            title: 'Qeydiyyat (gün üzrə)',
            child: DailyChart(
              key: const ValueKey('chart-signups'),
              points: _series('signups_daily'),
              unit: 'qeydiyyat',
            ),
          ),
          SectionCard(
            title: 'Aktiv istifadəçilər',
            trailing: PillTabs(
              labels: seriesNames,
              keys: [for (final s in series) ValueKey('series-$s')],
              selected: _activeSeries,
              onSelected: (i) => setState(() => _activeSeries = i),
            ),
            child: DailyChart(
              key: const ValueKey('chart-active'),
              points: _series(series[_activeSeries]),
              unit: 'hesab',
              line: true,
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      ResponsiveGrid(
        minItemWidth: 300,
        children: [
          SectionCard(
            title: 'Ölkələr (açılışlar)',
            child: BarList(
              entries: _bars(
                'opens_country',
                label: (c) => _countryNames[c] ?? c,
              ),
              total: _group('opens_country')?.total,
            ),
          ),
          SectionCard(
            title: 'Platforma (aktiv günlər)',
            child: BarList(
              entries: _bars(
                'active_platform',
                label: (p) => _platformNames[p] ?? p,
              ),
              total: _group('active_platform')?.total,
            ),
          ),
          SectionCard(
            title: 'Tətbiq versiyaları',
            child: BarList(
              entries: _bars('app_versions'),
              total: _group('app_versions')?.total,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _tools() {
    final byCountry = _group('tools_country')?.counts ?? const <StatsCount>[];
    return [
      ResponsiveGrid(
        minItemWidth: 420,
        children: [
          SectionCard(
            title: 'Ən çox istifadə olunan alətlər',
            child: BarList(
              key: const ValueKey('tools-list'),
              entries: _bars('tools', label: (t) => toolLabels[t] ?? t),
              total: _group('tools')?.total,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionCard(
                title: 'Alət açılışları (gün üzrə)',
                child: DailyChart(
                  points: _series('tools_daily'),
                  unit: 'açılış',
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Ölkə üzrə alətlər',
                child: byCountry.isEmpty
                    ? const Text('Hələ məlumat yoxdur.')
                    : Column(
                        key: const ValueKey('tools-country'),
                        children: [
                          for (final c in byCountry.take(20))
                            _TableRow(
                              cells: [
                                _countryNames[c.label.split('|').first] ??
                                    c.label.split('|').first,
                                toolLabels[c.label.split('|').last] ??
                                    c.label.split('|').last,
                              ],
                              value: _n(c.count),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  List<Widget> _content() {
    String title(String label) {
      final parts = label.split('|');
      return parts.length > 1 && parts[1].isNotEmpty ? parts[1] : parts.first;
    }

    final views = _group('banner_views')?.counts ?? const <StatsCount>[];
    final taps = {
      for (final c in _group('banner_taps')?.counts ?? const <StatsCount>[])
        c.label: c.count,
    };
    return [
      ResponsiveGrid(
        minItemWidth: 200,
        children: [
          StatCard(
            label: 'Banner göstərilməsi',
            value: _n(_kpi('banner_views')),
            valueKey: const ValueKey('kpi-banner-views'),
            hint: 'Son $_days gün',
          ),
          StatCard(
            label: 'Banner klikləri',
            value: _n(_kpi('banner_taps')),
            valueKey: const ValueKey('kpi-banner-taps'),
            hint: 'Son $_days gün',
          ),
          StatCard(
            label: 'Klik faizi (CTR)',
            value: switch ((_kpi('banner_views'), _kpi('banner_taps'))) {
              (final v?, final t?) when v > 0 =>
                '${(t * 1000 / v).round() / 10}%',
              _ => '—',
            },
            hint: 'Kliklər / göstərilmə',
          ),
        ],
      ),
      const SizedBox(height: 20),
      SectionCard(
        title: 'Bannerlər və kampaniyalar',
        child: views.isEmpty
            ? const Text('Bu dövrdə banner göstərilməyib.')
            : Column(
                key: const ValueKey('banner-table'),
                children: [
                  const _TableRow(
                    cells: ['Banner', 'Brend'],
                    value: 'Göstərilmə',
                    extra: 'Klik',
                    header: true,
                  ),
                  for (final v in views)
                    _TableRow(
                      cells: [
                        title(v.label),
                        v.label.split('|').length > 2 &&
                                v.label.split('|')[2].isNotEmpty
                            ? 'Reklam · ${v.label.split('|')[2]}'
                            : 'Parla',
                      ],
                      value: _n(v.count),
                      extra: _n(taps[v.label]),
                    ),
                ],
              ),
      ),
      const SizedBox(height: 20),
      ResponsiveGrid(
        minItemWidth: 380,
        children: [
          SectionCard(
            title: 'Ən çox oxunan bloq yazıları',
            child: BarList(
              key: const ValueKey('articles-top'),
              entries: _bars('articles_top', label: title),
            ),
          ),
          SectionCard(
            title: 'Ən çox açılan reseptlər',
            child: BarList(
              key: const ValueKey('recipes-top'),
              entries: _bars('recipes_top', label: title),
            ),
          ),
        ],
      ),
    ];
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.cells,
    required this.value,
    this.extra,
    this.header = false,
  });

  final List<String> cells;
  final String value;
  final String? extra;
  final bool header;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: header ? 12 : 14,
      fontWeight: header ? FontWeight.w700 : FontWeight.w400,
      color: header ? AdminColors.subtle : AdminColors.ink,
    );
    final number = style.copyWith(
      fontWeight: FontWeight.w700,
      color: header ? AdminColors.subtle : AdminColors.espresso,
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.line)),
      ),
      child: Row(
        children: [
          for (final (i, c) in cells.indexed)
            Expanded(
              flex: i == 0 ? 3 : 2,
              child: Text(
                c,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style,
              ),
            ),
          SizedBox(
            width: 90,
            child: Text(value, textAlign: TextAlign.end, style: number),
          ),
          if (extra != null)
            SizedBox(
              width: 70,
              child: Text(extra!, textAlign: TextAlign.end, style: number),
            ),
        ],
      ),
    );
  }
}
