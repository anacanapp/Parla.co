import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'brand.dart';
import 'parla_icons.dart';

/// The day design "HR" (owner 2026-11-24; prototype boards `HR1Today` …
/// `HR7Profile`): a soft photo of a woman in profile on a neutral cream
/// page behind milky glass cards with coral and burnt orange glows, dark
/// chosen states and a glass menu. Sizes follow the 390 × 844 prototype.
abstract final class Warm {
  static const ink = ParlaColors.espresso;
  static const muted = ParlaColors.muted;

  /// Dark warm brown of chosen chips and round buttons.
  static const black = Color(0xFF2A2320);

  /// The light page under the soft colour wash (light design, owner
  /// 2026-11-26: "Parla İşıq" demo).
  static const page = Color(0xFFF7F3F1);

  /// Banana yellow, the brand colour (app icon). Meters, chosen marks and
  /// the core of every gradient; never text.
  static const marker = Color(0xFFFFCE00);
  static const banana = marker;

  /// Light washes of the design: butter, rose, lilac and sky.
  static const butter = Color(0xFFFFF6CF);
  static const roseTint = Color(0xFFF6B4CF);
  static const lilac = Color(0xFFC9B8F2);
  static const sky = Color(0xFFBFD8F2);

  /// The rainbow of the Parla mark: banana first and most.
  static const iris = [
    Color(0xFFFFCE00),
    Color(0xFFFFE15A),
    Color(0xFFF6B4CF),
    Color(0xFFC9B8F2),
    Color(0xFFBFD8F2),
    Color(0xFFFFE97A),
    Color(0xFFFFCE00),
  ];

  /// Text on cards: the cards are light glass now, so this is dark ink;
  /// the name is kept for the screens that use it.
  static const onCard = ParlaColors.espresso;
  static const onCardSoft = Color(0xFF6B6259);

  /// Text on dark surfaces (chosen chips, the menu, black buttons).
  static const onDark = Color(0xFFFFFFFF);

  /// Butter card (was lime): white to butter to banana, dark text.
  static const lime = [Color(0xFFFFFBEA), Color(0xFFFFF1B0), Color(0xFFFFE47A)];
  static const limeGlow = Color(0x99FFCE00);

  /// Rose card: white to pale rose, dark text.
  static const rose = [Color(0xFFFFF7FA), Color(0xFFFCE3EE), Color(0xFFF9D3E4)];
  static const roseGlow = Color(0x80C9B8F2);
}

/// The page: neutral cream with the soft photo of a woman in profile
/// (an AI image made for Parla, no real person) behind the cards.
class WarmBackdrop extends StatelessWidget {
  const WarmBackdrop({super.key, required this.child, this.figure = true});

  /// The photo, kept in the app (nothing is fetched at runtime). It is
  /// the original (`backdrop.jpg`, not bundled) with a light blur baked in
  /// (owner, 2026-11-25), so no filter runs while scrolling.
  static const asset = 'assets/images/backdrop_soft.jpg';

  final Widget child;

  /// The photo behind the cards. Pages of running text (sign-up,
  /// consents, legal texts, articles) leave it out so dark text stays
  /// legible.
  final bool figure;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Warm.page,
    child: Stack(
      fit: StackFit.expand,
      children: [
        // Soft colour wash: rose at the top left, banana at the top right
        // and a butter glow at the bottom. Text pages get a lighter wash.
        ExcludeSemantics(
          child: RepaintBoundary(
            child: CustomPaint(painter: _WashPainter(strong: figure)),
          ),
        ),
        child,
      ],
    ),
  );
}

class _WashPainter extends CustomPainter {
  const _WashPainter({required this.strong});

  final bool strong;

  @override
  void paint(Canvas canvas, Size size) {
    final k = strong ? 1.0 : .55;
    void glow(Offset c, double r, Color color) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = ui.Gradient.radial(c, r, [
            color.withValues(alpha: color.a * k),
            color.withValues(alpha: 0),
          ]),
      );
    }

    final w = size.width;
    final h = size.height;
    glow(Offset(w * .05, -h * .02), w * .95, const Color(0x8CF6B4CF));
    glow(Offset(w * 1.02, h * .06), w * .9, const Color(0x80FFCE00));
    glow(Offset(w * .85, h * 1.02), w * 1.0, const Color(0x8CFFE97A));
    glow(Offset(-w * .1, h * .92), w * .8, const Color(0x59C9B8F2));
  }

  @override
  bool shouldRepaint(_WashPainter old) => old.strong != strong;
}

/// Tints of [SmokyGlass].
enum SmokyTint { none, coral, burnt }

/// Milky glass: a see-through surface that blurs what lies behind, a
/// light warm tint, a white edge with a milky inner glow, and white text.
/// Optional coral or burnt orange glow inside. A [milk] surface is
/// lighter, with dark text (chips, header buttons).
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
    this.milk = false,
  });

  final Widget child;
  final double radius;

  /// A stadium or circle; a rounded rectangle of [radius] by default.
  final OutlinedBorder? shape;
  final SmokyTint tint;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool shadow;

  /// The light variant with dark text.
  final bool milk;

  @override
  Widget build(BuildContext context) {
    final outline =
        shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
    final filter = ui.ImageFilter.blur(sigmaX: 22, sigmaY: 22);
    final grouped = BackdropGroup.of(context) != null;
    final glow = switch (tint) {
      SmokyTint.coral => const RadialGradient(
        center: Alignment(0.7, -0.6),
        radius: 1,
        colors: [Color(0xB3FFCE00), Color(0x40FFE15A), Color(0x00FFE15A)],
        stops: [0, .55, 1],
        transform: _StretchToWidth(),
      ),
      SmokyTint.burnt => const RadialGradient(
        center: Alignment(-0.36, 0.7),
        radius: 1.1,
        colors: [Color(0x99F6B4CF), Color(0x40C9B8F2), Color(0x00C9B8F2)],
        stops: [0, .55, 1],
        transform: _StretchToWidth(),
      ),
      SmokyTint.none => null,
    };
    const ink = Warm.ink;
    final body = DefaultTextStyle.merge(
      style: const TextStyle(color: ink),
      child: IconTheme.merge(
        data: const IconThemeData(color: ink),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: outline,
        shadows: shadow
            ? const [
                BoxShadow(
                  color: Color(0x1F78501E),
                  blurRadius: 30,
                  offset: Offset(0, 14),
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
            // White glass; a milk surface (chips, small buttons) is a
            // little more solid.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: milk
                      ? const Color(0xD9FFFFFF)
                      : const Color(0xB8FFFFFF),
                ),
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x2EFFFFFF),
                      Color(0x0DFFFFFF),
                      Color(0x1AFFFFFF),
                    ],
                    stops: [0, .55, 1],
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
            // Only a tappable card is one button; otherwise the buttons
            // inside keep their own labels.
            Material(
              type: MaterialType.transparency,
              child: onTap == null
                  ? body
                  : InkWell(customBorder: outline, onTap: onTap, child: body),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stretches a radial glow sideways to the box's width, so a wide stadium
/// glows across, not in a small circle (radii count from the shorter side).
class _StretchToWidth extends GradientTransform {
  const _StretchToWidth();

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    if (bounds.height <= 0 || bounds.width <= bounds.height) return null;
    final c = bounds.center;
    return Matrix4.identity()
      ..translateByDouble(c.dx, c.dy, 0, 1)
      ..scaleByDouble(bounds.width / bounds.height, 1, 1, 1)
      ..translateByDouble(-c.dx, -c.dy, 0, 1);
  }
}

/// The glass edge: a milky white inner glow, a bright line along the
/// top and a 1.5 px white border.
class _EdgePainter extends CustomPainter {
  _EdgePainter(this.shape);

  final OutlinedBorder shape;

  @override
  void paint(Canvas canvas, Size size) {
    final box = Offset.zero & size;
    final outer = shape.getOuterPath(box);
    canvas
      ..save()
      ..clipPath(outer)
      // Inner milky glow: a wide blurred white stroke along the edge.
      ..drawPath(
        outer,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 18
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
          ..color = const Color(0x4DFFFFFF),
      )
      // The bright top line.
      ..drawPath(
        shape.getOuterPath(box.translate(0, 1.5)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xD9FFFFFF), Color(0x00FFFFFF)],
            stops: [0, .25],
          ).createShader(box),
      )
      ..restore()
      ..drawPath(
        shape.getOuterPath(box.deflate(.75)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color(0x8CFFFFFF),
      );
  }

  @override
  bool shouldRepaint(_EdgePainter old) => old.shape != shape;
}

/// The colour of a [SquircleCard].
enum SquircleTone { lime, rose }

/// A rounded glass card with white text: plain milky glass ([lime]) or
/// with a coral glow ([rose]). The tone names are kept from the earlier
/// design.
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
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: SmokyGlass(
      radius: radius,
      tint: tone == SquircleTone.rose ? SmokyTint.coral : SmokyTint.none,
      padding: padding,
      onTap: onTap,
      child: child,
    ),
  );
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
        paint..color = const Color(0x261A1A1E),
      )
      ..drawArc(
        rect,
        math.pi * .6,
        math.pi * 1.6,
        false,
        paint..color = Warm.banana,
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

/// A light glass round button with a dark icon (page heads: messages,
/// back, sound). At least 44 px to tap.
class GlassCircleButton extends StatelessWidget {
  const GlassCircleButton({
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
      child: SmokyGlass(
        shape: const CircleBorder(),
        milk: true,
        onTap: onPressed,
        child: Center(
          child: ParlaIcon(icon, size: size * .42, color: Warm.ink),
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
          border: Border.fromBorderSide(
            BorderSide(color: Color(0xBFFFFFFF), width: 1.5),
          ),
          gradient: SweepGradient(colors: Warm.iris),
          boxShadow: [BoxShadow(color: Color(0x80FFCE00), blurRadius: 30)],
        ),
        alignment: Alignment.center,
        child: ParlaIcon(icon, size: size * .32, color: Warm.ink),
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
      color: const Color(0x0D1A1A1E),
      shape: StadiumBorder(
        side: BorderSide(color: color.withValues(alpha: .6)),
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
        ..color = i < lit ? Warm.marker : const Color(0x401A1A1E);
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
          ..color = i == mark ? Warm.marker : const Color(0x401A1A1E)
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
            const [Color(0x80FFCE00), Color(0x00FFCE00)],
          ),
      )
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = const Color(0xFFE0A800),
      );
    final s = at(selected.clamp(0, n - 1));
    final dash = Paint()
      ..color = const Color(0x661A1A1E)
      ..strokeWidth = 1;
    for (var y = s.dy + 8; y < size.height; y += 7) {
      canvas.drawLine(
        Offset(s.dx, y),
        Offset(s.dx, math.min(y + 3, size.height)),
        dash,
      );
    }
    canvas
      ..drawCircle(s, 10, Paint()..color = const Color(0x80FFCE00))
      ..drawCircle(s, 4.5, Paint()..color = Warm.ink);
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
                color: i == selected ? Warm.black : null,
                border: i == selected
                    ? null
                    : Border.all(color: const Color(0x331A1A1E)),
              ),
              child: FittedBox(
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 11,
                    color: i == selected ? Warm.onDark : Warm.onCard,
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
      shape: const CircleBorder(side: BorderSide(color: Color(0x331A1A1E))),
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

/// A choice capsule: dark with white text when chosen, light milky
/// glass with dark text otherwise.
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
        color: selected ? Warm.onDark : Warm.ink,
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
                color: Warm.black,
                shape: const StadiumBorder(
                  side: BorderSide(color: Color(0x40FFFFFF), width: 1.5),
                ),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: onTap,
                  child: Padding(padding: pad, child: text),
                ),
              )
            : SmokyGlass(
                shape: const StadiumBorder(),
                shadow: false,
                milk: true,
                onTap: onTap,
                padding: pad,
                child: text,
              ),
      ),
    );
  }
}

/// Two choices in a light glass capsule; the chosen one is dark.
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
    milk: true,
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
                    color: v == selected ? Warm.black : Colors.transparent,
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
                      color: v == selected ? Warm.onDark : Warm.ink,
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
/// and a line; the current one glows coral.
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
              color: Warm.banana,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.check_rounded, size: 18, color: Warm.ink),
          )
        : Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x591A1A1E), width: 1.5),
            ),
          );
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: SmokyGlass(
        shape: const StadiumBorder(),
        tint: current ? SmokyTint.coral : SmokyTint.none,
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
