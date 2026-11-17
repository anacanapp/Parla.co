import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';

String _metricTitle(String metric) {
  if (metric.startsWith('quiz:')) {
    final q = quizQuestion(metric.substring(5));
    return 'Test: ${q?.text['az'] ?? metric.substring(5)}';
  }
  return switch (metric) {
    'accounts' => 'Hesablar',
    'signups_per_week' => 'Həftəlik qeydiyyat (həftənin bazar ertəsi)',
    'age_band' => 'Yaş qrupu',
    'country' => 'Ölkə',
    'language' => 'Dil',
    'deleted_per_month' => 'Silinən hesablar (ay üzrə)',
    'consent_granted' => 'Razılıq verənlər',
    'tools' => 'Alətlər (serverdə saxlayanlar)',
    'daily_active' => 'Gündəlik aktiv (analitika razılığı ilə)',
    _ => metric,
  };
}

String _label(String metric, String label) {
  if (metric.startsWith('quiz:')) {
    final q = quizQuestion(metric.substring(5));
    return q?.option(label)?.text['az'] ?? label;
  }
  return switch (label) {
    'total' => 'Cəmi',
    'health' => 'Sağlamlıq',
    'analytics' => 'Analitika',
    'marketing' => 'Marketinq',
    'custom_routines' => 'Öz rutinləri',
    'care_list' => 'Seçimlər və alış-veriş siyahısı',
    'sport' => 'İdman planı',
    'nutrition' => 'Qidalanma',
    'az' => 'Azərbaycan dili',
    'ru' => 'Rus dili',
    'en' => 'İngilis dili',
    _ => label,
  };
}

/// Anonymous aggregate statistics. Groups under the minimum size show as
/// "<10"; health answers are never counted.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  StatsReport? _report;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await widget.state.api.statsReport();
      if (mounted) setState(() => _report = r);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final r = _report;
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text('Statistika', style: text.headlineMedium),
              ),
            ),
            IconButton(
              tooltip: 'Yenilə',
              onPressed: _load,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Yalnız toplu, anonim rəqəmlər. ${r?.minGroupSize ?? 10} nəfərdən az '
          'olan qruplar "<${r?.minGroupSize ?? 10}" kimi göstərilir. Sağlamlıq '
          'cavabları heç vaxt sayılmır.',
          style: text.bodySmall?.copyWith(color: AdminColors.muted),
        ),
        const SizedBox(height: 16),
        if (_error != null) Text(errorText(_error!)),
        if (r == null && _error == null)
          const Center(child: CircularProgressIndicator()),
        if (r != null)
          for (final g in r.groups)
            Card(
              key: ValueKey('stats-${g.metric}'),
              elevation: 0,
              color: AdminColors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_metricTitle(g.metric), style: text.titleSmall),
                    const SizedBox(height: 8),
                    if (g.counts.isEmpty) const Text('Hələ məlumat yoxdur.'),
                    for (final c in g.counts)
                      _Row(
                        label: _label(g.metric, c.label),
                        count: c.count,
                        total: g.total,
                        min: r.minGroupSize,
                      ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.count,
    required this.total,
    required this.min,
  });

  final String label;
  final int? count;
  final int? total;
  final int min;

  @override
  Widget build(BuildContext context) {
    final share = count != null && total != null && total! > 0
        ? count! / total!
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 280, child: Text(label)),
          SizedBox(
            width: 70,
            child: Text(
              count == null ? '<$min' : '$count',
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 12),
          if (share != null) ...[
            SizedBox(
              width: 160,
              child: LinearProgressIndicator(value: share.clamp(0, 1)),
            ),
            const SizedBox(width: 8),
            Text('${(share * 100).round()}%'),
          ],
        ],
      ),
    );
  }
}
