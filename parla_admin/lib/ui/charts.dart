import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

/// The one series colour of the dashboard charts (dark gold; passes 3:1
/// against white and keeps the Parla Sun feel).
const chartSeries = Color(0xFF9A6B00);
const _chartSoft = Color(0x1F9A6B00);
const _grid = Color(0xFFEFE7D3);
const _axisText = TextStyle(
  fontFamily: adminFont,
  fontFamilyFallback: adminFontFallback,
  fontSize: 11,
  color: AdminColors.subtle,
);

/// One point of a daily series: the day (yyyy-mm-dd) and its value, or
/// `null` when it is hidden.
typedef DayValue = ({String day, int? value});

/// `17 noy` from `2026-11-17`.
String shortDay(String day) {
  const months = [
    'yan', 'fev', 'mar', 'apr', 'may', 'iyn', //
    'iyl', 'avq', 'sen', 'okt', 'noy', 'dek',
  ];
  final parts = day.split('-');
  if (parts.length != 3) return day;
  final m = int.tryParse(parts[1]) ?? 1;
  return '${int.tryParse(parts[2]) ?? parts[2]} ${months[(m - 1) % 12]}';
}

double _niceMax(int max) {
  if (max <= 4) return 4;
  final magnitude = math.pow(10, (math.log(max) / math.ln10).floor());
  for (final step in [1, 2, 2.5, 5, 10]) {
    final top = step * magnitude;
    if (top >= max) return top.toDouble();
  }
  return max.toDouble();
}

/// A daily series as columns (counts per day) or a line (levels such as
/// active accounts). Hovering shows the day and its value; the values are
/// also read out by screen readers.
class DailyChart extends StatefulWidget {
  const DailyChart({
    super.key,
    required this.points,
    required this.unit,
    this.line = false,
    this.height = 200,
  });

  final List<DayValue> points;

  /// Shown after the value in the tooltip, e.g. "qeydiyyat".
  final String unit;
  final bool line;
  final double height;

  @override
  State<DailyChart> createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {
  int? _hover;

  @override
  Widget build(BuildContext context) {
    final points = widget.points;
    if (points.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text('Hələ məlumat yoxdur.', style: _axisText),
        ),
      );
    }
    final max = _niceMax(
      points.map((p) => p.value ?? 0).fold(0, math.max),
    );
    final summary = [
      for (final p in points) '${shortDay(p.day)}: ${p.value ?? "<10"}',
    ].join(', ');
    return Semantics(
      label: '${widget.unit}: $summary',
      excludeSemantics: true,
      child: SizedBox(
        height: widget.height,
        child: LayoutBuilder(
          builder: (context, c) {
            const left = 36.0;
            const bottom = 22.0;
            final plotWidth = c.maxWidth - left;
            final step = plotWidth / points.length;
            int? indexAt(Offset o) {
              final i = ((o.dx - left) / step).floor();
              return i < 0 || i >= points.length ? null : i;
            }

            final hover = _hover;
            return MouseRegion(
              onHover: (e) => setState(() => _hover = indexAt(e.localPosition)),
              onExit: (_) => setState(() => _hover = null),
              child: GestureDetector(
                onTapDown: (d) =>
                    setState(() => _hover = indexAt(d.localPosition)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DailyPainter(
                          points: points,
                          max: max,
                          line: widget.line,
                          hover: hover,
                          left: left,
                          bottom: bottom,
                        ),
                      ),
                    ),
                    if (hover != null)
                      Positioned(
                        left: (left + step * (hover + 0.5) - 70).clamp(
                          0,
                          math.max(0, c.maxWidth - 140),
                        ),
                        top: 0,
                        child: _Tip(
                          title: shortDay(points[hover].day),
                          value: points[hover].value == null
                              ? '<10'
                              : '${points[hover].value}',
                          unit: widget.unit,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.title, required this.value, required this.unit});

  final String title;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AdminColors.espresso,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: _axisText.copyWith(color: AdminColors.sunLine),
          ),
          Text(
            '$value $unit',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AdminColors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

class _DailyPainter extends CustomPainter {
  _DailyPainter({
    required this.points,
    required this.max,
    required this.line,
    required this.hover,
    required this.left,
    required this.bottom,
  });

  final List<DayValue> points;
  final double max;
  final bool line;
  final int? hover;
  final double left;
  final double bottom;

  void _text(Canvas canvas, String s, Offset at, {TextAlign? align}) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: _axisText),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = switch (align) {
      TextAlign.right => at.dx - tp.width,
      TextAlign.center => at.dx - tp.width / 2,
      _ => at.dx,
    };
    tp.paint(canvas, Offset(dx, at.dy - tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final plotH = size.height - bottom - 8;
    final top = 8.0;
    final width = size.width - left;
    final step = width / points.length;
    double y(num v) => top + plotH - (v / max) * plotH;

    // Recessive grid: zero, half and top.
    final grid = Paint()
      ..color = _grid
      ..strokeWidth = 1;
    for (final f in [0.0, 0.5, 1.0]) {
      final gy = y(max * f);
      canvas.drawLine(Offset(left, gy), Offset(size.width, gy), grid);
      _text(
        canvas,
        (max * f).round().toString(),
        Offset(left - 6, gy),
        align: TextAlign.right,
      );
    }

    // Day labels: first, middle and last.
    for (final i in {0, points.length ~/ 2, points.length - 1}) {
      _text(
        canvas,
        shortDay(points[i].day),
        Offset(left + step * (i + 0.5), size.height - bottom / 2),
        align: i == 0
            ? TextAlign.left
            : (i == points.length - 1 ? TextAlign.right : TextAlign.center),
      );
    }

    if (hover != null) {
      final hx = left + step * (hover! + 0.5);
      canvas.drawLine(
        Offset(hx, top),
        Offset(hx, top + plotH),
        Paint()
          ..color = AdminColors.field
          ..strokeWidth = 1,
      );
    }

    if (line) {
      final path = Path();
      final area = Path();
      var started = false;
      for (var i = 0; i < points.length; i++) {
        final v = points[i].value;
        if (v == null) continue;
        final p = Offset(left + step * (i + 0.5), y(v));
        if (!started) {
          path.moveTo(p.dx, p.dy);
          area.moveTo(p.dx, top + plotH);
          area.lineTo(p.dx, p.dy);
          started = true;
        } else {
          path.lineTo(p.dx, p.dy);
          area.lineTo(p.dx, p.dy);
        }
      }
      if (!started) return;
      final lastX = left + step * (points.length - 0.5);
      area
        ..lineTo(lastX, top + plotH)
        ..close();
      canvas
        ..drawPath(area, Paint()..color = _chartSoft)
        ..drawPath(
          path,
          Paint()
            ..color = chartSeries
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..strokeJoin = StrokeJoin.round,
        );
      if (hover != null && points[hover!].value != null) {
        final c = Offset(
          left + step * (hover! + 0.5),
          y(points[hover!].value!),
        );
        canvas
          ..drawCircle(c, 6, Paint()..color = AdminColors.white)
          ..drawCircle(c, 4, Paint()..color = chartSeries);
      }
      return;
    }

    // Columns with a 2 px gap and 4 px rounded tops on the baseline.
    final gap = step > 6 ? 2.0 : 1.0;
    final barW = math.min(28.0, step - gap);
    for (var i = 0; i < points.length; i++) {
      final v = points[i].value;
      final x = left + step * (i + 0.5) - barW / 2;
      if (v == null) {
        // Hidden ("<10"): a faint stub so the day is not read as zero.
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(x, top + plotH - 4, barW, 4),
            topLeft: const Radius.circular(2),
            topRight: const Radius.circular(2),
          ),
          Paint()..color = AdminColors.field,
        );
        continue;
      }
      if (v == 0) continue;
      final h = math.max(2.0, (v / max) * plotH);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x, top + plotH - h, barW, h),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        Paint()
          ..color = hover == null || hover == i
              ? chartSeries
              : chartSeries.withValues(alpha: 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(_DailyPainter old) =>
      old.points != points || old.hover != hover || old.line != line;
}

/// One row of a [BarList].
typedef BarEntry = ({String label, String? hint, int? count});

/// A ranked list with horizontal bars: label, value and share of [total].
/// Hidden counts show as "<[min]" without a bar.
class BarList extends StatelessWidget {
  const BarList({
    super.key,
    required this.entries,
    this.total,
    this.min = 10,
    this.emptyText = 'Hələ məlumat yoxdur.',
  });

  final List<BarEntry> entries;
  final int? total;
  final int min;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(emptyText, style: _axisText),
      );
    }
    final largest = entries.map((e) => e.count ?? 0).fold(0, math.max);
    return Column(
      children: [
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: e.label,
                          children: [
                            if (e.hint != null && e.hint!.isNotEmpty)
                              TextSpan(
                                text: '  ${e.hint}',
                                style: const TextStyle(
                                  color: AdminColors.subtle,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      e.count == null ? '<$min' : '${e.count}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (total != null && total! > 0)
                      SizedBox(
                        width: 48,
                        child: Text(
                          e.count == null
                              ? ''
                              : '${(e.count! * 100 / total!).round()}%',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AdminColors.subtle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                LayoutBuilder(
                  builder: (context, c) {
                    final share = largest == 0 || e.count == null
                        ? 0.0
                        : e.count! / largest;
                    return Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: AdminColors.hover,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          height: 6,
                          width: c.maxWidth * share,
                          decoration: BoxDecoration(
                            color: chartSeries,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
