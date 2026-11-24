import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'brand.dart';
import 'parla_icons.dart';

/// The warm day design ("isti B", owner 2026-11-24; prototype boards
/// `X1TodayW` … `X7ProfileW`): a cream page with a soft, motion-blurred
/// figure and a peach glow behind smoky glass, lime and rose cards, white
/// chosen states and a black menu. Sizes follow the 390 × 844 prototype.
abstract final class Warm {
  static const ink = ParlaColors.espresso;
  static const muted = ParlaColors.muted;

  /// Black of round buttons and the menu.
  static const black = Color(0xFF0F0F12);

  /// The small lime marker of meters (never text).
  static const marker = Color(0xFFE8F06A);

  /// White text on cards, and its softer variant.
  static const onCard = Color(0xFFFFFFFF);
  static const onCardSoft = Color(0xD9FFFFFF);

  /// Lime card: olive to lime, with a lime glow at the bottom right.
  /// Slightly deeper than the prototype so white text passes AA.
  static const lime = [Color(0xFF56650F), Color(0xFF61731A), Color(0xFF667A14)];
  static const limeGlow = Color(0x99C9E04A);

  /// Rose card: dusty rose to clay, with a pink glow on the left.
  static const rose = [Color(0xFFA5625A), Color(0xFFA86852), Color(0xFFA6664F)];
  static const roseGlow = Color(0x80D28C8C);
}

/// The page: cream with a soft white light at the top, a peach glow and a
/// warm, horizontally motion-blurred figure behind the cards.
class WarmBackdrop extends StatelessWidget {
  const WarmBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF5EDE4), Color(0xFFF3E6DA), Color(0xFFF1D8C4)],
        stops: [0, .6, 1],
      ),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        const ExcludeSemantics(
          child: RepaintBoundary(child: CustomPaint(painter: _FigurePainter())),
        ),
        child,
      ],
    ),
  );
}

/// The figure, painted once: a top light, a peach glow, and a head, body
/// and streaks blurred mostly sideways (motion).
class _FigurePainter extends CustomPainter {
  const _FigurePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 390;
    final sy = size.height / 844;
    Offset p(double x, double y) => Offset(x * sx, y * sy);

    // Soft white light at the top right.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.radial(
          p(312, 0),
          size.width * .9,
          const [Color(0xFFFBF4EC), Color(0x00FBF4EC)],
        ),
    );

    // Peach glow on the left.
    canvas
      ..saveLayer(
        Offset.zero & size,
        Paint()
          ..imageFilter = ui.ImageFilter.blur(sigmaX: 44 * sx, sigmaY: 10 * sy),
      )
      ..drawOval(
        Rect.fromCenter(center: p(130, 560), width: 300 * sx, height: 600 * sy),
        Paint()..color = const Color(0xD9F0915A),
      )
      ..restore();

    // The figure: warm brown, blurred mostly sideways.
    final figure = Paint()..color = const Color(0xD15A3A2A);
    canvas
      ..saveLayer(
        Offset.zero & size,
        Paint()
          ..imageFilter = ui.ImageFilter.blur(sigmaX: 30 * sx, sigmaY: 5 * sy),
      )
      ..drawOval(
        Rect.fromCenter(center: p(215, 200), width: 220 * sx, height: 180 * sy),
        figure,
      )
      ..drawPath(
        Path()
          ..moveTo(80 * sx, 290 * sy)
          ..cubicTo(130 * sx, 240 * sy, 300 * sx, 240 * sy, 340 * sx, 310 * sy)
          ..lineTo(360 * sx, size.height + 20)
          ..lineTo(50 * sx, size.height + 20)
          ..close(),
        Paint()..color = const Color(0xD1523426),
      );
    final streak = Paint()..color = const Color(0x8C4A2E22);
    for (var i = 0; i < 14; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            (20 + i % 3 * 15) * sx,
            (280 + i * 42) * sy,
            (300 - i % 4 * 30) * sx,
            14 * sy,
          ),
          Radius.circular(7 * sx),
        ),
        streak,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FigurePainter oldDelegate) => false;
}

/// Tints of [SmokyGlass].
enum SmokyTint { none, coral, burnt }

/// Smoky glass: a warm grey, see-through surface that blurs what lies
/// behind, with a bright top edge and white text. Optional coral or burnt
/// orange glow inside.
class SmokyGlass extends StatelessWidget {
  const SmokyGlass({
    super.key,
    required this.child,
    this.radius = 44,
    this.shape,
    this.tint = SmokyTint.none,
    this.padding,
    this.onTap,
    this.shadow = true,
  });

  final Widget child;
  final double radius;

  /// A stadium or circle; a rounded rectangle of [radius] by default.
  final OutlinedBorder? shape;
  final SmokyTint tint;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final outline =
        shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
    final filter = ui.ImageFilter.blur(sigmaX: 22, sigmaY: 22);
    final grouped = BackdropGroup.of(context) != null;
    final glow = switch (tint) {
      SmokyTint.coral => const RadialGradient(
        center: Alignment(-0.4, -0.4),
        radius: 0.9,
        colors: [Color(0xCCF06E50), Color(0x5950403C)],
      ),
      SmokyTint.burnt => const RadialGradient(
        center: Alignment(-0.4, 0.6),
        radius: 0.9,
        colors: [Color(0xD9DC6E1E), Color(0x7350321E)],
      ),
      SmokyTint.none => null,
    };
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: outline,
        shadows: shadow
            ? const [
                BoxShadow(
                  color: Color(0x40281409),
                  blurRadius: 40,
                  offset: Offset(0, 20),
                ),
              ]
            : null,
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: outline),
        child: Stack(
          children: [
            Positioned.fill(
              child: grouped
                  ? BackdropFilter.grouped(
                      filter: filter,
                      child: const SizedBox(),
                    )
                  : BackdropFilter(filter: filter, child: const SizedBox()),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.5, -1),
                    end: Alignment(0.5, 1),
                    colors: [Color(0x755A504B), Color(0x5728221F)],
                  ),
                ),
              ),
            ),
            if (glow != null)
              Positioned.fill(
                child: DecoratedBox(decoration: BoxDecoration(gradient: glow)),
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _EdgePainter(outline)),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                customBorder: outline,
                onTap: onTap,
                child: DefaultTextStyle.merge(
                  style: const TextStyle(color: Warm.onCard),
                  child: IconTheme.merge(
                    data: const IconThemeData(color: Warm.onCard),
                    child: Padding(
                      padding: padding ?? EdgeInsets.zero,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The glass edge: a thin white line, bright along the top, and a soft
/// inner glow.
class _EdgePainter extends CustomPainter {
  _EdgePainter(this.shape);

  final OutlinedBorder shape;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(.5);
    canvas
      ..drawPath(
        shape.getOuterPath((Offset.zero & size).deflate(3)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
          ..color = const Color(0x1AFFFFFF),
      )
      ..drawPath(
        shape.getOuterPath(rect),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xA6FFFFFF), Color(0x4DFFFFFF), Color(0x40FFFFFF)],
            stops: [0, .12, 1],
          ).createShader(rect),
      );
  }

  @override
  bool shouldRepaint(_EdgePainter old) => old.shape != shape;
}

/// The colour of a [SquircleCard].
enum SquircleTone { lime, rose }

/// A lime or rose rounded card with white text, a soft glow, a light top
/// edge and depth at the bottom.
class SquircleCard extends StatelessWidget {
  const SquircleCard({
    super.key,
    required this.tone,
    required this.child,
    this.radius = 44,
    this.padding = const EdgeInsets.fromLTRB(14, 14, 14, 16),
    this.onTap,
    this.height,
  });

  final SquircleTone tone;
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(radius);
    final (colors, glow, glowAt) = switch (tone) {
      SquircleTone.lime => (Warm.lime, Warm.limeGlow, const Alignment(.4, .7)),
      SquircleTone.rose => (Warm.rose, Warm.roseGlow, const Alignment(-.4, .2)),
    };
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: border,
        gradient: LinearGradient(
          begin: const Alignment(-0.6, -1),
          end: const Alignment(0.6, 1),
          colors: colors,
          stops: const [0, .6, 1],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40281E28),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: border,
          gradient: RadialGradient(
            center: glowAt,
            radius: .8,
            colors: [glow, glow.withAlpha(0)],
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: border,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x33FFFFFF),
                Color(0x00FFFFFF),
                Color(0x00000000),
                Color(0x1A000000),
              ],
              stops: [0, .08, .7, 1],
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: border,
              onTap: onTap,
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Warm.onCard),
                child: IconTheme.merge(
                  data: const IconThemeData(color: Warm.onCard),
                  child: Padding(padding: padding, child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The head of a [SquircleCard]: a ring icon, two short lines and a black
/// arrow button.
class SquircleHead extends StatelessWidget {
  const SquircleHead({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onOpen,
    this.openLabel,
  });

  final ParlaIconName icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onOpen;
  final String? openLabel;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      RingIcon(icon: icon),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          subtitle == null ? title : '$title\n$subtitle',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, height: 1.15),
        ),
      ),
      if (onOpen != null)
        BlackCircleButton(
          icon: ParlaIconName.arrowRight,
          onPressed: onOpen!,
          label: openLabel ?? title,
          size: 38,
        ),
    ],
  );
}

/// A 36 px icon in a white ring that is open on the right.
class RingIcon extends StatelessWidget {
  const RingIcon({super.key, required this.icon, this.size = 36});

  final ParlaIconName icon;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _OpenRingPainter(),
        child: Center(
          child: ParlaIcon(icon, size: size * .4, color: Warm.onCard),
        ),
      ),
    ),
  );
}

class _OpenRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(1);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas
      ..drawArc(
        rect,
        0,
        2 * math.pi,
        false,
        paint..color = const Color(0x40FFFFFF),
      )
      ..drawArc(
        rect,
        math.pi * .6,
        math.pi * 1.6,
        false,
        paint..color = const Color(0xE6FFFFFF),
      );
  }

  @override
  bool shouldRepaint(_OpenRingPainter oldDelegate) => false;
}

/// A black round button with a white icon (at least 44 px to tap).
class BlackCircleButton extends StatelessWidget {
  const BlackCircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.label,
    this.size = 44,
  });

  final ParlaIconName icon;
  final VoidCallback onPressed;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: SizedBox(
      width: math.max(size, 44),
      height: math.max(size, 44),
      child: Center(
        child: Material(
          color: Warm.black,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: size,
              height: size,
              child: Center(
                child: ParlaIcon(icon, size: size * .42, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// The glowing peach round "+" button of the design.
class GlowPlusButton extends StatelessWidget {
  const GlowPlusButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.size = 70,
    this.icon = ParlaIconName.plus,
  });

  final VoidCallback? onPressed;
  final String label;
  final double size;
  final ParlaIconName icon;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment(-.2, -.2),
            colors: [Color(0xF2FFC896), Color(0x8CF0823C)],
          ),
        ),
        alignment: Alignment.center,
        child: ParlaIcon(icon, size: size * .32, color: Colors.white),
      ),
    ),
  );
}

/// A small outlined capsule next to a value ("dəq", "↑ 2").
class OutlineBadge extends StatelessWidget {
  const OutlineBadge(this.text, {super.key, this.color = Warm.onCard});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 26),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: ShapeDecoration(
      shape: StadiumBorder(
        side: BorderSide(color: color.withValues(alpha: .5)),
      ),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: kMinTextSize, color: color, height: 1.2),
    ),
  );
}

/// Three rows of dots; the last [lit] columns are lime.
class DotsMeter extends StatelessWidget {
  const DotsMeter({super.key, required this.fraction, this.columns = 18});

  final double fraction;
  final int columns;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: 18,
      child: CustomPaint(painter: _DotsPainter(fraction.clamp(0, 1), columns)),
    ),
  );
}

class _DotsPainter extends CustomPainter {
  _DotsPainter(this.fraction, this.columns);

  final double fraction;
  final int columns;

  @override
  void paint(Canvas canvas, Size size) {
    final step = (size.width - 8) / (columns - 1);
    final lit = (columns * fraction).round();
    for (var i = 0; i < columns; i++) {
      final paint = Paint()
        ..color = i < lit ? Warm.marker : const Color(0x80FFFFFF);
      for (var j = 0; j < 3; j++) {
        canvas.drawCircle(Offset(4 + i * step, 4 + j * 6.0), 1.3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotsPainter old) =>
      old.fraction != fraction || old.columns != columns;
}

/// Thin ticks with one lime marker at [fraction].
class TicksMeter extends StatelessWidget {
  const TicksMeter({super.key, required this.fraction, this.count = 20});

  final double fraction;
  final int count;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: 18,
      child: CustomPaint(painter: _TicksPainter(fraction.clamp(0, 1), count)),
    ),
  );
}

class _TicksPainter extends CustomPainter {
  _TicksPainter(this.fraction, this.count);

  final double fraction;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final step = (size.width - 6) / (count - 1);
    final mark = ((count - 1) * fraction).round();
    for (var i = 0; i < count; i++) {
      final x = 3 + i * step;
      canvas.drawLine(
        Offset(x, 2),
        Offset(x, 16),
        Paint()
          ..color = i == mark ? Warm.marker : const Color(0x73FFFFFF)
          ..strokeWidth = i == mark ? 2 : 1,
      );
    }
  }

  @override
  bool shouldRepaint(_TicksPainter old) =>
      old.fraction != fraction || old.count != count;
}

/// The week curve: a soft orange curve over seven [values] with a glowing
/// point on [selected], a dashed drop line and a light fill.
class WeekCurve extends StatelessWidget {
  const WeekCurve({
    super.key,
    required this.values,
    required this.selected,
    this.height = 90,
  });

  final List<double> values;
  final int selected;
  final double height;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _CurvePainter(values, selected)),
    ),
  );
}

class _CurvePainter extends CustomPainter {
  _CurvePainter(this.values, this.selected);

  final List<double> values;
  final int selected;

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n < 2) return;
    final top = values.fold<double>(1, math.max);
    Offset at(int i) => Offset(
      size.width * i / (n - 1),
      size.height - 10 - (size.height - 26) * (values[i] / top),
    );
    final path = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < n; i++) {
      final a = at(i - 1);
      final b = at(i);
      final mid = (a.dx + b.dx) / 2;
      path.cubicTo(mid, a.dy, mid, b.dy, b.dx, b.dy);
    }
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas
      ..drawPath(
        fill,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset.zero,
            Offset(0, size.height),
            const [Color(0x73F08A3C), Color(0x00F08A3C)],
          ),
      )
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = const Color(0xFFF6A35C),
      );
    final s = at(selected.clamp(0, n - 1));
    final dash = Paint()
      ..color = const Color(0x66FFFFFF)
      ..strokeWidth = 1;
    for (var y = s.dy + 8; y < size.height; y += 7) {
      canvas.drawLine(
        Offset(s.dx, y),
        Offset(s.dx, math.min(y + 3, size.height)),
        dash,
      );
    }
    canvas
      ..drawCircle(s, 10, Paint()..color = const Color(0x66F6A35C))
      ..drawCircle(s, 4.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_CurvePainter old) =>
      old.selected != selected || old.values != values;
}

/// Seven outlined day circles; [selected] is white.
class DayCircles extends StatelessWidget {
  const DayCircles({
    super.key,
    required this.labels,
    required this.selected,
    this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      for (var i = 0; i < labels.length; i++)
        Semantics(
          selected: i == selected,
          button: onSelected != null,
          child: GestureDetector(
            onTap: onSelected == null ? null : () => onSelected!(i),
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == selected ? Colors.white : null,
                border: i == selected
                    ? null
                    : Border.all(color: const Color(0x59FFFFFF)),
              ),
              child: FittedBox(
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 11,
                    color: i == selected
                        ? const Color(0xFF222222)
                        : Warm.onCard,
                  ),
                ),
              ),
            ),
          ),
        ),
    ],
  );
}

/// A big smoky card with a title, a line under it and an outlined arrow
/// at the top right (the week card, the blog card).
class GlassHeroCard extends StatelessWidget {
  const GlassHeroCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.onOpen,
    this.openLabel,
    this.tint = SmokyTint.none,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onOpen;
  final String? openLabel;
  final SmokyTint tint;

  @override
  Widget build(BuildContext context) => SmokyGlass(
    radius: 44,
    tint: tint,
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: kMinTextSize,
                        color: Warm.onCardSoft,
                      ),
                    ),
                ],
              ),
            ),
            if (onOpen != null)
              OutlineCircleButton(
                icon: ParlaIconName.arrowRight,
                label: openLabel ?? title,
                onPressed: onOpen!,
              ),
          ],
        ),
        child,
      ],
    ),
  );
}

/// A 48 px outlined round button on glass.
class OutlineCircleButton extends StatelessWidget {
  const OutlineCircleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.size = 48,
  });

  final ParlaIconName icon;
  final String label;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(side: BorderSide(color: Color(0x66FFFFFF))),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: ParlaIcon(icon, size: 18, color: Warm.onCard)),
        ),
      ),
    ),
  );
}

/// A smoky stadium with a title and icon on top and a big value with an
/// outlined badge under it (Su, Axşam yoqası, Mağaza …).
class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.badge,
    this.tint = SmokyTint.none,
    this.onTap,
    this.height = 112,
    this.semanticLabel,
  });

  final String title;
  final String value;
  final ParlaIconName icon;
  final String? badge;
  final SmokyTint tint;
  final VoidCallback? onTap;
  final double height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    label: semanticLabel,
    excludeSemantics: semanticLabel != null,
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: SmokyGlass(
        shape: const StadiumBorder(),
        tint: tint,
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(22, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                ExcludeSemantics(
                  child: ParlaIcon(icon, size: 18, color: Warm.onCard),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w300,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 10),
                  OutlineBadge(badge!),
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// A smoky stadium with a label and the glowing "+" on the right.
class AddPill extends StatelessWidget {
  const AddPill({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 112,
  });

  final String label;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: SizedBox(
      height: height,
      child: SmokyGlass(
        shape: const StadiumBorder(),
        onTap: onPressed,
        padding: const EdgeInsets.fromLTRB(22, 12, 12, 12),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
            GlowPlusButton(
              onPressed: onPressed,
              label: label,
              size: height - 44,
            ),
          ],
        ),
      ),
    ),
  );
}

/// A choice capsule: white with dark text when chosen, smoky glass
/// otherwise.
class WarmChip extends StatelessWidget {
  const WarmChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
        color: selected ? Warm.black : Warm.onCard,
      ),
    );
    const pad = EdgeInsets.symmetric(horizontal: 16, vertical: 11);
    return Semantics(
      button: true,
      selected: selected,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: selected
            ? Material(
                color: Colors.white,
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: onTap,
                  child: Padding(padding: pad, child: text),
                ),
              )
            : SmokyGlass(
                shape: const StadiumBorder(),
                shadow: false,
                onTap: onTap,
                padding: pad,
                child: text,
              ),
      ),
    );
  }
}

/// Two choices in a smoky capsule; the chosen one is white.
class WarmSegmented<T> extends StatelessWidget {
  const WarmSegmented({
    super.key,
    required this.values,
    required this.labelOf,
    required this.selected,
    required this.onChanged,
    this.keyOf,
  });

  final List<T> values;
  final String Function(T) labelOf;
  final T selected;
  final ValueChanged<T> onChanged;
  final Key Function(T)? keyOf;

  @override
  Widget build(BuildContext context) => SmokyGlass(
    radius: 28,
    shadow: false,
    padding: const EdgeInsets.all(5),
    child: Row(
      children: [
        for (final v in values)
          Expanded(
            child: Semantics(
              button: true,
              selected: v == selected,
              child: GestureDetector(
                key: keyOf?.call(v),
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  constraints: const BoxConstraints(minHeight: 44),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: v == selected ? Colors.white : Colors.transparent,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    labelOf(v),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: v == selected
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: v == selected ? Warm.black : Warm.onCard,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

/// A step or item row: a status circle (white tick when done), a title
/// and a line; the current one glows burnt orange.
class WarmStepRow extends StatelessWidget {
  const WarmStepRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.done = false,
    this.current = false,
    this.onTap,
    this.onToggle,
    this.trailing,
    this.toggleLabel,
  });

  final String title;
  final String subtitle;
  final bool done;
  final bool current;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final Widget? trailing;
  final String? toggleLabel;

  @override
  Widget build(BuildContext context) {
    final circle = done
        ? Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.check_rounded, size: 18, color: Warm.black),
          )
        : Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x99FFFFFF), width: 1.5),
            ),
          );
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: SmokyGlass(
        shape: const StadiumBorder(),
        tint: current ? SmokyTint.burnt : SmokyTint.none,
        shadow: false,
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(8, 6, 18, 6),
        child: Row(
          children: [
            Semantics(
              button: onToggle != null,
              checked: done,
              label: toggleLabel,
              child: InkResponse(
                onTap: onToggle,
                radius: 26,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(child: circle),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: Warm.onCardSoft,
                      color: done ? Warm.onCardSoft : Warm.onCard,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: kMinTextSize,
                        color: Warm.onCardSoft,
                      ),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// Page head: an optional small line above a large thin title, with an
/// optional widget on the left (back) and on the right.
class WarmHeader extends StatelessWidget {
  const WarmHeader({
    super.key,
    required this.title,
    this.above,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? above;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (leading != null) ...[leading!, const SizedBox(width: 12)],
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (above != null)
              Text(
                above!,
                style: const TextStyle(fontSize: 13, color: Warm.muted),
              ),
            Semantics(
              header: true,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w200,
                  letterSpacing: -1,
                  height: 1.05,
                  color: Warm.ink,
                ),
              ),
            ),
          ],
        ),
      ),
      ?trailing,
    ],
  );
}
