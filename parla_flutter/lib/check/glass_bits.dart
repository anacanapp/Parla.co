import 'package:flutter/material.dart';

import '../ui/brand.dart';
import '../ui/night.dart';
import '../ui/parla_icons.dart';
import '../ui/warm.dart';

/// Small glass pieces shared by the Shop, the shopping list, Check and the
/// profile, tuned for the warm light page (design "isti B", 2026-11-24).
abstract final class Glass {
  /// Ink on the light capsule of a selected chip or tab.
  static const darkInk = Color(0xFF1A0B2A);

  /// Faint glass fill of cards and lists, and its hairline.
  static const fill = Color(0x99FFFFFF);
  static const line = Color(0xCCFFFFFF);

  /// Slightly stronger fill of buttons and chips, and its hairline.
  static const buttonFill = Color(0xA6FFFFFF);
  static const buttonLine = Color(0xE6FFFFFF);

  /// Divider between rows of a [GlassGroup].
  static const divider = Color(0x1A1A1A1E);

  /// Secondary text on the light page and light glass.
  static const soft = ParlaColors.muted;

  /// The red of destructive rows ("Delete account") on light glass.
  static const danger = Color(0xFFB3261E);

  /// The coral of destructive rows on smoky glass.
  static const dangerOnSmoke = Color(0xFFFFC2B0);
}

/// The large thin page title ("Mağaza", "Profil").
class GlassTitle extends StatelessWidget {
  const GlassTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w200,
        letterSpacing: -1,
        height: 1.1,
        color: ParlaColors.espresso,
      ),
    ),
  );
}

/// A round light glass back button, 44 px (HR design headers).
class GlassBack extends StatelessWidget {
  const GlassBack({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 44,
    height: 44,
    child: SmokyGlass(
      shape: const CircleBorder(),
      milk: true,
      shadow: false,
      child: BackButton(onPressed: onPressed, color: Warm.ink),
    ),
  );
}

/// A glass capsule button (44 px) with an optional icon.
class GlassPill extends StatelessWidget {
  const GlassPill({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.height = 44,
    this.fontSize = 13,
  });

  final String label;
  final VoidCallback? onPressed;
  final ParlaIconName? icon;
  final bool expand;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onPressed != null,
    child: LiquidGlass(
      shape: const StadiumBorder(),
      shadow: false,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  ParlaIcon(icon!, size: 18, color: ParlaColors.espresso),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: ParlaColors.espresso,
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

/// A filter chip: light capsule when selected, glass otherwise.
class GlassChip extends StatelessWidget {
  const GlassChip({
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
    child: LiquidGlass(
      color: selected ? ParlaColors.espresso : null,
      shape: const StadiumBorder(),
      shadow: false,
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
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? Colors.white : ParlaColors.espresso,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// A glass card (radius 32 by default).
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 32,
    this.shadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  /// The drop shadow and bottom shade; off for a flat card.
  final bool shadow;

  @override
  Widget build(BuildContext context) => LiquidGlass(
    radius: radius,
    padding: padding,
    shadow: shadow,
    child: child,
  );
}

/// Rows in one glass card, split by faint lines.
class GlassGroup extends StatelessWidget {
  const GlassGroup({super.key, required this.children, this.shadow = true});

  final List<Widget> children;

  /// The drop shadow and bottom shade; off for a flat card.
  final bool shadow;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(32),
    clipBehavior: Clip.none,
    child: GlassCard(
      padding: EdgeInsets.zero,
      shadow: shadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Glass.divider),
            children[i],
          ],
        ],
      ),
    ),
  );
}

/// A row of a [GlassGroup]: optional icon, label, optional value on the
/// right, at least 58 px high.
class GlassRow extends StatelessWidget {
  const GlassRow({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.value,
    this.color = ParlaColors.espresso,
    this.trailing,
  });

  final String label;
  final VoidCallback? onTap;
  final ParlaIconName? icon;
  final String? value;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 58),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            if (icon != null) ...[
              ExcludeSemantics(child: ParlaIcon(icon!, size: 20, color: color)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 15, color: color)),
            ),
            if (value != null) ...[
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  value!,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 13, color: Glass.soft),
                ),
              ),
            ],
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    ),
  );
}

/// The plum pebble header card with a round glass icon, a title and a
/// line under it (profile, check).
class PebbleHeader extends StatelessWidget {
  const PebbleHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final ParlaIconName icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => PebbleCard(
    padding: const EdgeInsets.all(18),
    child: Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0x29FFFFFF),
            border: Border.all(color: const Color(0x4DFFFFFF)),
          ),
          alignment: Alignment.center,
          child: ExcludeSemantics(
            child: ParlaIcon(icon, size: 24, color: Colors.white),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 17, color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: kMinTextSize,
                  height: 1.35,
                  color: Warm.onCardSoft,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// A glass text field's decoration: faint fill, capsule-like corners.
InputDecoration glassInput(String hint, {Widget? prefixIcon}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Glass.soft),
    prefixIcon: prefixIcon,
    filled: true,
    fillColor: Glass.buttonFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: border(Glass.buttonLine),
    enabledBorder: border(Glass.buttonLine),
    focusedBorder: border(ParlaColors.espresso, 1.5),
  );
}
