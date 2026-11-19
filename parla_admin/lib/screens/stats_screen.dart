import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/widgets.dart';

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

/// The audience tab of the dashboard: anonymous aggregate statistics.
/// Groups under the minimum size show as "<10"; health answers are never
/// counted.
class AudienceStats extends StatefulWidget {
  const AudienceStats({super.key, required this.state});

  final StaffState state;

  @override
  State<AudienceStats> createState() => _AudienceStatsState();
}

class _AudienceStatsState extends State<AudienceStats> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_error != null)
          Notice(
            tone: NoticeTone.danger,
            icon: Icons.error_outline,
            title: errorText(_error!),
          ),
        if (r == null && _error == null) const LoadingBlock(),
        if (r != null)
          ResponsiveGrid(
            minItemWidth: 340,
            children: [
              for (final g in r.groups)
                Card(
                  key: ValueKey('stats-${g.metric}'),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_metricTitle(g.metric), style: text.titleMedium),
                        const SizedBox(height: 12),
                        if (g.counts.isEmpty)
                          Text('Hələ məlumat yoxdur.', style: text.bodySmall),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 14)),
              ),
              Text(
                count == null ? '<$min' : '$count',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (share != null) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 44,
                  child: Text(
                    '${(share * 100).round()}%',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B6052),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (share != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: share.clamp(0, 1),
                minHeight: 6,
                color: const Color(0xFF1F1A14),
                backgroundColor: const Color(0xFFFFF3C2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
