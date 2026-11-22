import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'brand.dart';
import 'parla_icons.dart';

/// Shapes and shadows of the Parla 2.0 design (prototype "Parla 2.0
/// dizayn", 2026-11-21): large rounded cards, capsules for controls, soft
/// shadows. Colours stay the brand's ([ParlaColors]).
abstract final class ParlaShape {
  /// Cards and lists.
  static const card = 28.0;

  /// Small tiles (statistics, product images).
  static const tile = 22.0;

  /// Sheets and heroes (their bottom or top corners).
  static const sheet = 36.0;

  /// Capsules: buttons, chips, the menu.
  static const pill = 999.0;

  /// Height of capsule buttons and segments.
  static const pillHeight = 44.0;

  /// Height of filter chips.
  static const chipHeight = 40.0;
}

/// A card's soft shadow.
const List<BoxShadow> kCardShadow = [
  BoxShadow(color: Color(0x0F1F1A14), blurRadius: 30, offset: Offset(0, 10)),
];

/// The shadow of things that float over the page (the menu, bars).
const List<BoxShadow> kFloatShadow = [
  BoxShadow(color: Color(0x1F1F1A14), blurRadius: 30, offset: Offset(0, 12)),
];

/// The hero's soft sun glow at the top right.
const heroSunGlow = RadialGradient(
  center: Alignment(0.85, -1),
  radius: 1.1,
  colors: [Color(0x8CFFCE00), Color(0x00FFCE00)],
);

/// The hero's sky glow at the bottom left.
const heroSkyGlow = RadialGradient(
  center: Alignment(-1, 1),
  radius: 0.9,
  colors: [Color(0xBFCFE3F7), Color(0x00CFE3F7)],
);

/// A hero area: lemon with a sun and a sky glow, rounded at the bottom
/// (or as [radius] says).
class HeroGlow extends StatelessWidget {
  const HeroGlow({
    super.key,
    required this.child,
    this.padding,
    this.radius = const BorderRadius.vertical(
      bottom: Radius.circular(ParlaShape.sheet),
    ),
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: ParlaColors.lemon, borderRadius: radius),
    child: DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, gradient: heroSunGlow),
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: radius, gradient: heroSkyGlow),
        child: Padding(
          padding: padding ?? const EdgeInsets.fromLTRB(20, 16, 20, 22),
          child: child,
        ),
      ),
    ),
  );
}

/// How a [PillButton] looks.
enum PillTone {
  /// Espresso with white text: the selected or main action.
  dark,

  /// Sun with espresso text: the brand's call to action.
  sun,

  /// White with a hairline: a secondary choice.
  light,
}

/// A capsule button with an optional icon; at least 44 px high.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = PillTone.light,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ParlaIconName? icon;
  final PillTone tone;

  /// Takes the full width of its parent.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, border) = switch (tone) {
      PillTone.dark => (ParlaColors.espresso, ParlaColors.white, null),
      PillTone.sun => (ParlaColors.sun, ParlaColors.espresso, null),
      PillTone.light => (
        ParlaColors.white,
        ParlaColors.espresso,
        ParlaColors.line,
      ),
    };
    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          ParlaIcon(icon!, size: 18, color: foreground),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: tone == PillTone.light
                  ? FontWeight.w600
                  : FontWeight.w700,
              color: foreground,
            ),
          ),
        ),
      ],
    );
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: Material(
        color: background,
        shape: StadiumBorder(
          side: border == null ? BorderSide.none : BorderSide(color: border),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: ParlaShape.pillHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// A selectable capsule chip (filters, slots). Selected: sun.
class PillChip extends StatelessWidget {
  const PillChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: Material(
      color: selected ? ParlaColors.sun : ParlaColors.white,
      shape: StadiumBorder(
        side: selected
            ? BorderSide.none
            : const BorderSide(color: ParlaColors.line),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? ParlaColors.espresso : ParlaColors.muted,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// One choice of a [PillSegmented].
class PillSegment<T> {
  const PillSegment(this.value, this.label, {this.icon});

  final T value;
  final String label;
  final ParlaIconName? icon;
}

/// Two or three choices side by side in a lemon capsule (face / hair /
/// body); the selected one is espresso.
class PillSegmented<T> extends StatelessWidget {
  const PillSegmented({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.semanticLabel,
    this.keyOf,
  });

  /// A key for each segment (tests and screen readers' anchors).
  final Key Function(T value)? keyOf;

  final List<PillSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: semanticLabel,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: const ShapeDecoration(
        color: ParlaColors.lemon,
        shape: StadiumBorder(),
      ),
      child: Row(
        children: [
          for (final s in segments)
            Expanded(
              child: Semantics(
                button: true,
                selected: s.value == selected,
                child: GestureDetector(
                  key: keyOf?.call(s.value) ?? ValueKey('segment-${s.value}'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(s.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    constraints: const BoxConstraints(
                      minHeight: ParlaShape.pillHeight,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: ShapeDecoration(
                      color: s.value == selected
                          ? ParlaColors.espresso
                          : Colors.transparent,
                      shape: const StadiumBorder(),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (s.icon != null) ...[
                          ParlaIcon(
                            s.icon!,
                            size: 18,
                            color: s.value == selected
                                ? ParlaColors.white
                                : ParlaColors.espresso,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            s.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: s.value == selected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: s.value == selected
                                  ? ParlaColors.white
                                  : ParlaColors.espresso,
                            ),
                          ),
                        ),
                      ],
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

/// A round progress ring with a label in the middle (e.g. "2/4").
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.fraction,
    required this.label,
    this.size = 52,
    this.stroke = 6,
    this.color = ParlaColors.sun,
    this.track = ParlaColors.lemon,
    this.labelColor = ParlaColors.espresso,
  });

  final double fraction;
  final String label;
  final double size;
  final double stroke;
  final Color color;
  final Color track;
  final Color labelColor;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      painter: _RingPainter(fraction.clamp(0, 1), stroke, color, track),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.all(stroke + 2),
            child: Text(
              label,
              style: TextStyle(
                fontSize: size * 0.27,
                fontWeight: FontWeight.w800,
                color: labelColor,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.fraction, this.stroke, this.color, this.track);

  final double fraction;
  final double stroke;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inner = rect.deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(inner, 0, 2 * math.pi, false, paint..color = track);
    if (fraction > 0) {
      canvas.drawArc(
        inner,
        -math.pi / 2,
        2 * math.pi * fraction,
        false,
        paint..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction ||
      old.color != color ||
      old.track != track ||
      old.stroke != stroke;
}

/// A small statistic tile: label, value with unit and a thin bar.
class MiniStat extends StatelessWidget {
  const MiniStat({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.fraction,
    this.dark = false,
    this.fill = ParlaColors.sunInk,
    this.onTap,
  });

  final String label;
  final String value;
  final String? unit;

  /// 0 to 1, or `null` for no bar.
  final double? fraction;

  /// Sport blue with light text.
  final bool dark;
  final Color fill;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? ParlaColors.white : ParlaColors.espresso;
    final soft = dark ? ParlaColors.sportBlueText : ParlaColors.muted;
    return Material(
      color: dark ? ParlaColors.sportBlue : ParlaColors.white,
      borderRadius: BorderRadius.circular(ParlaShape.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(ParlaShape.tile),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: kMinTextSize,
                  fontWeight: FontWeight.w600,
                  color: soft,
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  text: value,
                  children: [
                    if (unit != null)
                      TextSpan(
                        text: ' $unit',
                        style: TextStyle(
                          fontSize: kMinTextSize,
                          fontWeight: FontWeight.w600,
                          color: soft,
                        ),
                      ),
                  ],
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: fg,
                ),
              ),
              if (fraction != null) ...[
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: fraction!.clamp(0, 1),
                    minHeight: 6,
                    color: dark ? ParlaColors.sun : fill,
                    backgroundColor: dark
                        ? const Color(0x2EFFF9E8)
                        : ParlaColors.lemon,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
