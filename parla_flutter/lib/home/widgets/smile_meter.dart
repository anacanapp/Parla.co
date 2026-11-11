import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../ui/brand.dart';

/// The brand's Smile Meter: a smile-shaped arc that fills with progress.
///
/// Purely visual; the numbers next to it carry the meaning for screen
/// readers, so the arc itself is excluded from semantics.
class SmileMeter extends StatelessWidget {
  const SmileMeter({
    super.key,
    required this.fraction,
    required this.child,
    this.width = 290,
    this.track = ParlaColors.cream,
    this.fill = ParlaColors.sun,
  });

  final double fraction;
  final Widget child;
  final double width;
  final Color track;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final height = width * 150 / 260;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ExcludeSemantics(
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: fraction.clamp(0, 1)),
              duration: const Duration(milliseconds: 600),
              curve: const Cubic(0.2, 0.8, 0.2, 1),
              builder: (context, value, _) => CustomPaint(
                size: Size(width, height),
                painter: _SmilePainter(value, track, fill),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.02),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _SmilePainter extends CustomPainter {
  _SmilePainter(this.fraction, this.track, this.fill);

  final double fraction;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 22 / 260;
    final inset = size.width * 20 / 260;
    final radius = (size.width - 2 * inset) / 2;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, inset),
      radius: radius,
    );
    Paint paint(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // From the left end, through the bottom, to the right end.
    canvas.drawArc(rect, math.pi, -math.pi, false, paint(track));
    if (fraction > 0) {
      canvas.drawArc(rect, math.pi, -math.pi * fraction, false, paint(fill));
    }
  }

  @override
  bool shouldRepaint(_SmilePainter old) =>
      old.fraction != fraction || old.track != track || old.fill != fill;
}
