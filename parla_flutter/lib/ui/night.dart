import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'brand.dart';
import 'parla_icons.dart';
import 'warm.dart';

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

/// The page behind every route: now the warm day backdrop
/// ([WarmBackdrop]); the name stays for the routes that use it.
class NightBackdrop extends StatelessWidget {
  const NightBackdrop({super.key, required this.child, this.figure = true});

  final Widget child;

  /// See [WarmBackdrop.figure].
  final bool figure;

  @override
  Widget build(BuildContext context) =>
      WarmBackdrop(figure: figure, child: child);
}

/// Satin glass (owner, 2026-11-24, after the "AI Glucose Scan" card of
/// the reference video): a smooth top-to-bottom colour, a fine grain that
/// makes the surface frosted and matte, a soft light along the top, a
/// little shade along the bottom so the card looks thick, and a thin rim
/// that is light at the top and fades downwards. Clear surfaces also blur
/// what lies behind them.
///
/// Every glass surface of the app goes through this widget, so the effect
/// is the same everywhere. Pages wrap their content in a [BackdropGroup]
/// (see `routes.dart`), so all blurs on a page share one backdrop read.
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    super.key,
    required this.child,
    this.radius = 28,
    this.shape,
    this.color,
    this.gradient,
    this.padding,
    this.shadow = true,
  });

  final Widget child;

  /// Corner radius when no [shape] is given.
  final double radius;

  /// The outline (stadium, circle); a rounded rectangle by default.
  final OutlinedBorder? shape;

  /// The surface colour; frosted clear glass when neither this nor
  /// [gradient] is given.
  final Color? color;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final bool shadow;

  /// Frosted clear glass.
  static const clear = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xA6FFFFFF), Color(0x66FFFFFF)],
  );

  /// Brighter clear glass for the current or chosen row.
  static const bright = Color(0xD9FFFFFF);

  static const blurSigma = 22.0;

  @override
  Widget build(BuildContext context) {
    final outline =
        (shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ))
            .copyWith(side: BorderSide.none);
    final see = color == null
        ? gradient == null || gradient!.colors.any((c) => c.a < .95)
        : color!.a < .95;
    final filter = ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma);
    final grouped = BackdropGroup.of(context) != null;
    final body = Stack(
      children: [
        if (see)
          Positioned.fill(
            child: grouped
                ? BackdropFilter.grouped(
                    filter: filter,
                    child: const SizedBox(),
                  )
                : BackdropFilter(filter: filter, child: const SizedBox()),
          ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              gradient: color == null ? (gradient ?? clear) : null,
            ),
          ),
        ),
        // Light along the top and shade along the bottom: a thick card.
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x38FFFFFF),
                    Color(0x00FFFFFF),
                    Color(0x00000000),
                    Color(0x1F000000),
                  ],
                  stops: [0, .32, .72, 1],
                ),
              ),
            ),
          ),
        ),
        // A specular glint at the top left.
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.85, -1.05),
                  radius: 0.75,
                  colors: [Color(0x47FFFFFF), Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),
        ),
        Padding(padding: padding ?? EdgeInsets.zero, child: child),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _RimPainter(outline)),
          ),
        ),
      ],
    );
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: outline,
        shadows: shadow
            ? const [
                BoxShadow(
                  color: Color(0x66050118),
                  blurRadius: 36,
                  offset: Offset(0, 18),
                ),
              ]
            : null,
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: outline),
        child: Material(type: MaterialType.transparency, child: body),
      ),
    );
  }
}

/// The glass edge: a crisp line lit at the top left and again, softer, at
/// the bottom right, over a blurred inner glow that gives the glass its
/// thickness.
class _RimPainter extends CustomPainter {
  _RimPainter(this.shape);

  final OutlinedBorder shape;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(.6);
    final path = shape.getOuterPath(rect);
    const light = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xF2FFFFFF),
        Color(0x33FFFFFF),
        Color(0x14FFFFFF),
        Color(0x80FFFFFF),
      ],
      stops: [0, .3, .65, 1],
    );
    canvas
      ..drawPath(
        shape.getOuterPath((Offset.zero & size).deflate(2.5)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              for (final c in light.colors) c.withValues(alpha: c.a * .45),
            ],
            stops: light.stops,
          ).createShader(rect),
      )
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..shader = light.createShader(rect),
      );
  }

  @override
  bool shouldRepaint(_RimPainter old) => old.shape != shape;
}

/// Clear liquid glass with a corner [radius] (see [LiquidGlass]).
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

  /// Kept for callers; every glass surface blurs now ([LiquidGlass]).
  final bool blur;

  @override
  Widget build(BuildContext context) =>
      LiquidGlass(radius: radius, padding: padding, child: child);
}

/// The colour moods of [MeshTile] in the warm day design: rose, lime,
/// smoky brown, burnt orange, coral and dark smoke (the old names stay). Each runs [from] → [to] → [deep] and carries light ink
/// that passes WCAG AA on all three (checked in
/// `test/night_palette_test.dart`). The names are the tiles' old ones.
enum MeshTone {
  pink(Color(0xFFFFF6CF), Color(0xFFF6B4CF), Color(0xFFFFE15A), _ink),
  sage(Color(0xFFFFF6CF), Color(0xFFFFE97A), Color(0xFFFFCE00), _ink),
  blue(Color(0xFFF4F0FB), Color(0xFFBFD8F2), Color(0xFFC9B8F2), _ink),
  orange(Color(0xFFFFE97A), Color(0xFFFFCE00), Color(0xFFF6B4CF), _ink),
  rose(Color(0xFFFDE3EE), Color(0xFFF6B4CF), Color(0xFFC9B8F2), _ink),
  plum(Color(0xFFF4F0FB), Color(0xFFC9B8F2), Color(0xFFBFD8F2), _ink);

  const MeshTone(this.from, this.to, this.blob, this.ink);

  final Color from;
  final Color to;

  /// The dark (or, for orange, blue) glow inside the tile.
  final Color blob;

  /// Text and icons on the tile.
  final Color ink;

  /// Secondary text on the tile.
  Color get softInk => ink.withValues(alpha: .8);

  /// A light tile: dark ink on a pale gradient.
  bool get isLight => ink.computeLuminance() < .2;

  /// The bottom of the tile: [to] a little deeper (light tiles less, so
  /// their dark ink keeps AA).
  Color get deep =>
      Color.lerp(to, const Color(0xFF000000), isLight ? .1 : .35)!;
}

/// Dark ink of the light tiles ("İşıq" design).
const _ink = Color(0xFF16130F);
const _darkPink = Color(0xFF2A0A1C);

/// A rounded tile in a [MeshTone]'s colours as satin glass ([LiquidGlass]):
/// one smooth colour from top to bottom. Gives the [DefaultTextStyle] and
/// [IconTheme] the tone's ink. [blobAt] is kept for callers; the tiles no
/// longer draw a blob.
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

  /// How much of a tile's colour covers the glass (the rest shows the
  /// blurred page behind).
  static const opacity = .82;

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
    // The reference card: one smooth colour from top to bottom, no blob.
    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticLabel,
      child: LiquidGlass(
        radius: radius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            tone.from.withValues(alpha: MeshTile.opacity),
            tone.to.withValues(alpha: MeshTile.opacity),
            tone.deep.withValues(alpha: MeshTile.opacity),
          ],
          stops: const [0, .55, 1],
        ),
        child: InkWell(borderRadius: border, onTap: onTap, child: body),
      ),
    );
  }
}

/// The plum "pebble" card: the deep plum gradient as liquid glass, light
/// ink.
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
    Color(0xFFFFF6CF),
    Color(0xFFFFE97A),
    Color(0xFFFFE15A),
  ];

  @override
  Widget build(BuildContext context) => LiquidGlass(
    radius: radius,
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: stops,
    ),
    child: DefaultTextStyle.merge(
      style: const TextStyle(color: _ink),
      child: IconTheme.merge(
        data: const IconThemeData(color: _ink),
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
    this.background = const Color(0xFF16130F),
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
