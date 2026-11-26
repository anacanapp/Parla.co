import 'package:flutter/material.dart';

import 'warm.dart';

/// The Parla mark (a disc with a smile cut out, as on the app icon) filled
/// with the iris gradient: banana first, then rose, lilac and sky. Drawn in
/// code from the icon's geometry, so it stays sharp at any size.
class ParlaMark extends StatelessWidget {
  const ParlaMark({super.key, this.size = 28, this.colors = Warm.iris});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _MarkPainter(colors)),
    ),
  );
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter(this.colors);

  final List<Color> colors;

  /// The mark's outline in a box of [size].
  static Path outline(Size size) {
    final r = size.shortestSide / 2;
    final c = size.center(Offset.zero);
    Path circle(double dy, double radius) => Path()
      ..addOval(
        Rect.fromCircle(center: c.translate(0, dy * r), radius: radius * r),
      );
    final smile = Path.combine(
      PathOperation.difference,
      circle(-.205, .663),
      circle(-.633, .833),
    );
    return Path.combine(PathOperation.difference, circle(0, 1), smile);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final box = Offset.zero & size;
    final path = outline(size);
    canvas
      ..drawPath(
        path,
        Paint()
          ..shader = SweepGradient(
            startAngle: 0,
            endAngle: 6.2832,
            transform: const GradientRotation(2.2),
            colors: colors,
          ).createShader(box),
      )
      ..drawPath(
        path,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-.35, -.45),
            radius: .8,
            colors: [Color(0x99FFFFFF), Color(0x00FFFFFF)],
          ).createShader(box),
      );
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.colors != colors;
}
