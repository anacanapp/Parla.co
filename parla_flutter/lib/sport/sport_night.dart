import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../ui/brand.dart';
import '../ui/night.dart';
import '../ui/parla_icons.dart';

/// Night design pieces of the sport screens (prototypes "Gecə · İdman"
/// and "Gecə · Məşq", 2026-11-23). Shared by the sport files only.
abstract final class SportNight {
  /// Main ink and the dark ink on light capsules (14:1 on [ink]).
  static const ink = ParlaColors.espresso;
  static const inkDark = Color(0xFF1A0B2A);

  /// Secondary text on the page (about 9:1 on the night page).
  static const soft = Color(0xA6F4E9FF);

  /// Glass rows: calm and highlighted (the next workout).
  static const glass = Color(0x0FFFFFFF);
  static const glassLine = Color(0x1FFFFFFF);
  static const glassHigh = Color(0x1AFFFFFF);
  static const glassHighLine = Color(0x38FFFFFF);

  /// The blue pebble of the week card (light ink passes AA on each stop).
  static const blue = [Color(0xFF4E62C6), Color(0xFF3A49A8), Color(0xFF1F2566)];
}

/// A round glass button (back, sound, stop): 44 px, faint fill, hairline.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => LiquidGlass(
    shape: const CircleBorder(),
    shadow: false,
    child: IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: 20,
      constraints: const BoxConstraints.tightFor(width: 44, height: 44),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(foregroundColor: SportNight.ink),
      icon: icon,
    ),
  );
}

/// The large thin page title next to a round back button.
class SportHeader extends StatelessWidget {
  const SportHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.trailing,
  });

  final String title;
  final VoidCallback onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      GlassIconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Semantics(
          header: true,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
              letterSpacing: -1,
              height: 1.1,
              color: SportNight.ink,
            ),
          ),
        ),
      ),
      ?trailing,
    ],
  );
}

/// A glass row: rounded 28, faint fill and hairline; brighter when
/// [highlight]ed. The whole row is one button when [onTap] is set.
class GlassRow extends StatelessWidget {
  const GlassRow({
    super.key,
    required this.child,
    this.onTap,
    this.highlight = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.radius = 28,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool highlight;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) => LiquidGlass(
    radius: radius,
    color: highlight ? LiquidGlass.bright : null,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    ),
  );
}

/// The 36 px status circle of a list row: filled with a tick when done,
/// otherwise an outline (or an icon when given).
class TickDot extends StatelessWidget {
  const TickDot({super.key, required this.done, this.icon, this.label});

  final bool done;
  final ParlaIconName? icon;

  /// A number shown inside the outline (the move's place in a workout).
  final String? label;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? SportNight.ink : null,
        border: done
            ? null
            : Border.all(color: const Color(0x99F4E9FF), width: 1.5),
      ),
      alignment: Alignment.center,
      child: done
          ? const ParlaIcon(
              ParlaIconName.check,
              size: 18,
              color: SportNight.inkDark,
            )
          : icon != null
          ? ParlaIcon(icon!, size: 18, color: SportNight.ink)
          : label != null
          ? Text(
              label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: SportNight.ink,
              ),
            )
          : null,
    ),
  );
}

/// A row's title and secondary line.
class RowTexts extends StatelessWidget {
  const RowTexts({super.key, required this.title, this.subtitle, this.extra});

  final String title;
  final String? subtitle;
  final String? extra;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 15, color: SportNight.ink),
      ),
      for (final line in [?subtitle, ?extra])
        Text(
          line,
          style: const TextStyle(
            fontSize: kMinTextSize,
            height: 1.35,
            color: SportNight.soft,
          ),
        ),
    ],
  );
}

/// The white orb of the slide pills: a light sphere with a dark icon.
class SportOrb extends StatelessWidget {
  const SportOrb({super.key, required this.icon, this.size = 48});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        center: Alignment(-0.3, -0.4),
        colors: [Color(0xFFFFFFFF), Color(0xFFDCD3E6)],
      ),
    ),
    alignment: Alignment.center,
    child: Icon(icon, size: size * .45, color: SportNight.inkDark),
  );
}

/// A dark capsule with the orb and a label: the whole capsule is one
/// button (the main action of a sport screen).
class OrbPill extends StatelessWidget {
  const OrbPill({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
    this.height = 60,
    this.background = const Color(0x8C0A0824),
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final double height;
  final Color background;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: LiquidGlass(
      color: background,
      shape: const StadiumBorder(),
      shadow: false,
      child: InkWell(
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Padding(
            padding: EdgeInsets.all((height - 48) / 2 + 0.5),
            child: Row(
              children: [
                SportOrb(icon: icon, size: height - 12),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 15, color: SportNight.ink),
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

/// The blue pebble card (the week's plan and the questions' invitation).
class BluePebble extends StatelessWidget {
  const BluePebble({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LiquidGlass(
    radius: 40,
    padding: const EdgeInsets.all(20),
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: SportNight.blue,
    ),
    child: DefaultTextStyle.merge(
      style: const TextStyle(color: SportNight.ink),
      child: child,
    ),
  );
}

/// The small upper-case label of a card ("BU HƏFTƏ").
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = SportNight.ink});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      fontSize: kMinTextSize,
      letterSpacing: 1.4,
      fontWeight: FontWeight.w500,
      color: color,
    ),
  );
}

/// A thin ring on a dashed track with anything in the middle; it empties
/// (or fills) with [fraction].
class DashedRing extends StatelessWidget {
  const DashedRing({
    super.key,
    required this.fraction,
    required this.child,
    this.size = 150,
  });

  final double fraction;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(minWidth: size, minHeight: size),
    child: CustomPaint(
      painter: _DashedRingPainter(fraction.clamp(0, 1).toDouble()),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(widthFactor: 1, heightFactor: 1, child: child),
      ),
    ),
  );
}

class _DashedRingPainter extends CustomPainter {
  _DashedRingPainter(this.fraction);

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.shortestSide / 2 - 3;
    final center = size.center(Offset.zero);
    final track = Paint()
      ..color = const Color(0x1FFFFFFF)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final step = 8 / radius;
    for (var a = 0.0; a < 2 * math.pi - step / 2; a += step) {
      canvas.drawLine(
        center + Offset(math.cos(a), math.sin(a)) * radius,
        center +
            Offset(math.cos(a + 2 / radius), math.sin(a + 2 / radius)) * radius,
        track,
      );
    }
    if (fraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * fraction,
        false,
        Paint()
          ..color = SportNight.ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) => old.fraction != fraction;
}
