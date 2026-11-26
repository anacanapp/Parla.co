import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'warm.dart';

/// The Parla mark: a disc with a smile cut out, as on the app icon. By
/// default it is filled with the iridescent sweep ([Warm.iris]), banana
/// first; [color] fills it flat instead.
class ParlaMark extends StatelessWidget {
  const ParlaMark({super.key, this.size = 30, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _MarkPainter(color)),
    ),
  );
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.color);

  final Color? color;

  /// The mark on a 52.8 unit square: a disc of radius 26.4 with a smile
  /// between two curves from (-17.6, -3.5) to (17.6, -3.5) through
  /// (0, 5.3) above and (0, 12.3) below, relative to the centre.
  static Path path(Size size) {
    final s = size.shortestSide / 52.8;
    final c = Offset(size.width / 2, size.height / 2);
    Offset p(double x, double y) => c + Offset(x * s, y * s);
    final smile = Path()
      ..moveTo(p(-17.6, -3.5).dx, p(-17.6, -3.5).dy)
      ..quadraticBezierTo(
        p(0, 14.1).dx,
        p(0, 14.1).dy,
        p(17.6, -3.5).dx,
        p(17.6, -3.5).dy,
      )
      ..quadraticBezierTo(
        p(0, 28.1).dx,
        p(0, 28.1).dy,
        p(-17.6, -3.5).dx,
        p(-17.6, -3.5).dy,
      )
      ..close();
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(Rect.fromCircle(center: c, radius: 26.4 * s))
      ..addPath(smile, Offset.zero);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint();
    if (color != null) {
      paint.color = color!;
    } else {
      paint.shader = const SweepGradient(
        colors: Warm.iris,
        transform: GradientRotation(math.pi * 7 / 6),
      ).createShader(rect);
    }
    canvas.drawPath(path(size), paint);
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.color != color;
}
