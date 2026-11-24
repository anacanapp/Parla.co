import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'brand.dart';
import 'parla_icons.dart';

/// Building blocks of the night design (Parla 3.0, prototype "Parla 3.0 —
/// şüşə dizayn", variant A, 2026-11-23): a dark page with soft blue and
/// magenta glows and a fine grain, glass surfaces, gradient "mesh" tiles,
/// the plum pebble card, the slide pill and the dashed tick ring.
abstract final class NightColors {
  /// Darkest point of the page, under the glows.
  static const deep = Color(0xFF08070F);

  /// Blue glow at the top left of the page.
  static const glowBlue = Color(0x734056FF);

  /// Magenta glow at the right of the page.
  static const glowMagenta = Color(0x66D62EA0);

  /// Glass fill and its hairline.
  static const glass = Color(0x1AFFFFFF);
  static const glassLine = Color(0x2EFFFFFF);
}

/// The night page: deep background, two glows and a still grain. Put it
/// behind a [Scaffold] with a transparent background.
class NightBackdrop extends StatelessWidget {
  const NightBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(color: NightColors.deep),
    child: Stack(
      fit: StackFit.expand,
      children: [
        const ExcludeSemantics(
          child: RepaintBoundary(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.7, -0.75),
                  radius: 0.9,
                  colors: [NightColors.glowBlue, Color(0x004056FF)],
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(1, 0.2),
                    radius: 0.9,
                    colors: [NightColors.glowMagenta, Color(0x00D62EA0)],
                  ),
                ),
                child: CustomPaint(painter: _GrainPainter()),
              ),
            ),
          ),
        ),
        child,
      ],
    ),
  );
}

/// A fixed, faint grain: the same dots every time, painted once and cached
/// by the surrounding [RepaintBoundary].
class _GrainPainter extends CustomPainter {
  const _GrainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(7);
    final count = (size.width * size.height / 90).clamp(0, 12000).toInt();
    final light = <Offset>[];
    final dark = <Offset>[];
    for (var i = 0; i < count; i++) {
      final point = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      (i.isEven ? light : dark).add(point);
    }
    final paint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.square;
    canvas
      ..drawPoints(
        ui.PointMode.points,
        light,
        paint..color = const Color(0x0FFFFFFF),
      )
      ..drawPoints(
        ui.PointMode.points,
        dark,
        paint..color = const Color(0x14000000),
      );
  }

  @override
  bool shouldRepaint(_GrainPainter oldDelegate) => false;
}

/// A glass surface: a faint white fill with a hairline, optionally
/// blurring what lies behind it.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.radius = 28,
    this.padding,
    this.blur = false,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;

  /// Blurs the content behind the surface (the menu, floating bars).
  final bool blur;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: const BorderSide(color: NightColors.glassLine),
    );
    Widget surface = DecoratedBox(
      decoration: ShapeDecoration(color: NightColors.glass, shape: shape),
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );
    if (blur) {
      surface = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: surface,
        ),
      );
    }
    return surface;
  }
}

/// The colour moods of [MeshTile]: a two-stop gradient, a dark blob and
/// the ink that reads on the gradient (WCAG AA against both stops,
/// checked in `test/night_palette_test.dart`).
enum MeshTone {
  pink(Color(0xFFF0B8D4), Color(0xFFC77BA8), Color(0xFF3E0828), _darkPink),
  sage(Color(0xFFB4C6B1), Color(0xFF8AA28C), Color(0xFF0E1410), _darkSage),
  blue(Color(0xFF3B5BD6), Color(0xFF1F2E8C), Color(0xFF050B2E), _light),
  orange(Color(0xFFEFA070), Color(0xFFD98A5C), Color(0xFF2E4CF0), _darkOrange),
  rose(Color(0xFFF2B6D6), Color(0xFFE399C2), Color(0xFF5C0D3E), _darkPink),
  plum(Color(0xFF8E3BA6), Color(0xFF2B0F45), Color(0xFF14061F), _light);

  const MeshTone(this.from, this.to, this.blob, this.ink);

  final Color from;
  final Color to;

  /// The dark (or, for orange, blue) glow inside the tile.
  final Color blob;

  /// Text and icons on the tile.
  final Color ink;

  /// Secondary text on the tile.
  Color get softInk => ink.withValues(alpha: .8);
}

const _light = Color(0xFFF4E9FF);
const _darkPink = Color(0xFF2A0A1C);
const _darkSage = Color(0xFF10170F);
const _darkOrange = Color(0xFF2A1206);

/// A rounded tile with a [MeshTone] gradient and its glow. The glow sits
/// at [blobAt], away from the text (top left by default), so the ink keeps
/// its contrast. Gives the [DefaultTextStyle] and [IconTheme] the tone's
/// ink.
class MeshTile extends StatelessWidget {
  const MeshTile({
    super.key,
    required this.tone,
    required this.child,
    this.radius = 34,
    this.padding = const EdgeInsets.all(16),
    this.blobAt = const Alignment(0.75, 0.7),
    this.onTap,
    this.semanticLabel,
  });

  final MeshTone tone;
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Alignment blobAt;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(radius);
    final body = DefaultTextStyle.merge(
      style: TextStyle(color: tone.ink),
      child: IconTheme.merge(
        data: IconThemeData(color: tone.ink),
        child: Padding(padding: padding, child: child),
      ),
    );
    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: border,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tone.from, tone.to],
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: border,
            gradient: RadialGradient(
              center: blobAt,
              radius: 0.6,
              colors: [
                tone.blob.withValues(alpha: .85),
                tone.blob.withAlpha(0),
              ],
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: border,
              onTap: onTap,
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}

/// The plum "pebble" card of the night design: a deep plum gradient with a
/// soft inner highlight, light ink.
class PebbleCard extends StatelessWidget {
  const PebbleCard({
    super.key,
    required this.child,
    this.radius = 40,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  /// The gradient's stops, top to bottom (light ink passes AA on each).
  static const stops = [
    Color(0xFFA8429A),
    Color(0xFF6E2A9A),
    Color(0xFF2B0F45),
  ];

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: const LinearGradient(
        begin: Alignment(-0.4, -1),
        end: Alignment(0.4, 1),
        colors: stops,
      ),
      border: Border.all(color: const Color(0x33FFFFFF)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x66000000),
          blurRadius: 40,
          offset: Offset(0, 20),
        ),
      ],
    ),
    child: DefaultTextStyle.merge(
      style: const TextStyle(color: ParlaColors.espresso),
      child: IconTheme.merge(
        data: const IconThemeData(color: ParlaColors.espresso),
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

/// The slide pill: a dark capsule with a white round arrow and a label;
/// the whole capsule is one button (at least 60 px high).
class SlidePill extends StatelessWidget {
  const SlidePill({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = ParlaIconName.arrowRight,
    this.background = const Color(0x8C2A0A1C),
    this.foreground = const Color(0xFFFFF0F7),
  });

  final String label;
  final VoidCallback? onPressed;
  final ParlaIconName icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onPressed != null,
    label: label,
    excludeSemantics: true,
    child: Material(
      color: background,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: ParlaIcon(icon, size: 20, color: _darkPink),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, color: foreground),
                  ),
                ),
                ExcludeSemantics(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 14),
                    child: Text(
                      '•••',
                      style: TextStyle(
                        letterSpacing: 3,
                        fontSize: kMinTextSize,
                        color: foreground.withValues(alpha: .5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// A thin progress ring on a dashed track with a light number in the
/// middle (e.g. "2/4").
class TickRing extends StatelessWidget {
  const TickRing({
    super.key,
    required this.fraction,
    required this.label,
    this.size = 78,
    this.color = const Color(0xFFFFF0F7),
    this.semanticLabel,
  });

  final double fraction;
  final String label;
  final double size;
  final Color color;

  /// What a screen reader says instead of [label].
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel ?? label,
    excludeSemantics: true,
    child: SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TickRingPainter(fraction.clamp(0, 1).toDouble(), color),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: size * 0.3,
                  fontWeight: FontWeight.w200,
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _TickRingPainter extends CustomPainter {
  _TickRingPainter(this.fraction, this.color);

  final double fraction;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.shortestSide / 2 - 6;
    final center = size.center(Offset.zero);
    final track = Paint()
      ..color = color.withValues(alpha: .35)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    // Dashed track: short ticks every 7 degrees.
    const step = 2 * math.pi / 52;
    for (var a = 0.0; a < 2 * math.pi - step / 2; a += step) {
      final from = center + Offset(math.cos(a), math.sin(a)) * radius;
      final to = center + Offset(math.cos(a + .03), math.sin(a + .03)) * radius;
      canvas.drawLine(from, to, track);
    }
    if (fraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * fraction,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_TickRingPainter old) =>
      old.fraction != fraction || old.color != color;
}
