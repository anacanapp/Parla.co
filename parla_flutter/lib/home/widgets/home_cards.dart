import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/brand.dart';
import '../../ui/parla_icons.dart';
import '../routine.dart';
import 'smile_meter.dart';

/// White rounded card with the brand's soft shadow.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 28,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: ParlaColors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: kSoftShadow,
    ),
    // Ink splashes of buttons and list tiles inside the card paint on this
    // transparent Material instead of under the card's white background.
    child: Material(type: MaterialType.transparency, child: child),
  );
}

/// Small spaced capitals label, e.g. "NÖVBƏTİ ADDIM".
class EyebrowText extends StatelessWidget {
  const EyebrowText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
      color: ParlaColors.sunInk,
    ),
  );
}

/// Morning / evening switch (two-segment toggle).
class RoutineSwitch extends StatelessWidget {
  const RoutineSwitch({
    super.key,
    required this.kind,
    required this.onChanged,
  });

  final RoutineKind kind;
  final ValueChanged<RoutineKind> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget segment(RoutineKind value, String label, ParlaIconName icon) {
      final selected = value == kind;
      final color = selected ? ParlaColors.espresso : ParlaColors.muted;
      return Expanded(
        child: Semantics(
          button: true,
          selected: selected,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 52,
              decoration: BoxDecoration(
                color: selected ? ParlaColors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                boxShadow: selected ? kSoftShadow : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ParlaIcon(icon, size: 22, color: color),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Semantics(
      container: true,
      label: l10n.routineSwitchLabel,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ParlaColors.cream,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            segment(
              RoutineKind.morning,
              l10n.routineMorning,
              ParlaIconName.sun,
            ),
            const SizedBox(width: 4),
            segment(
              RoutineKind.evening,
              l10n.routineEvening,
              ParlaIconName.moon,
            ),
          ],
        ),
      ),
    );
  }
}

/// First card of the sheet: the Smile Meter with the routine's status.
class RoutineSummaryCard extends StatelessWidget {
  const RoutineSummaryCard({
    super.key,
    required this.eyebrow,
    required this.status,
    required this.caption,
    required this.doneCount,
    required this.total,
    required this.semanticLabel,
  });

  final String eyebrow;
  final String status;
  final String? caption;
  final int doneCount;
  final int total;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      liveRegion: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: SoftCard(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            SmileMeter(
              width: 124,
              track: ParlaColors.lemon,
              fraction: total == 0 ? 0 : doneCount / total,
              child: Text(
                '$doneCount/$total',
                style: text.headlineMedium,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EyebrowText(eyebrow),
                  const SizedBox(height: 4),
                  Text(status, style: text.titleLarge),
                  if (caption != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      caption!,
                      style: text.bodyMedium?.copyWith(
                        color: ParlaColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when every step of the routine is done (the brand's "success
/// moment": a smile drawn under the button).
class RoutineDoneCard extends StatelessWidget {
  const RoutineDoneCard({
    super.key,
    required this.routineName,
    required this.onRestart,
  });

  final String routineName;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      child: Column(
        children: [
          Text(
            l10n.routineDoneHeader(routineName),
            textAlign: TextAlign.center,
            style: text.titleSmall?.copyWith(color: ParlaColors.sunInk),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.routineDoneTitle,
            textAlign: TextAlign.center,
            style: accentStyle(Localizations.localeOf(context), size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.routineDoneBody,
            textAlign: TextAlign.center,
            style: text.bodyLarge?.copyWith(color: ParlaColors.muted),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onRestart,
            child: Text(l10n.routineRestart),
          ),
          const SizedBox(height: 8),
          const ExcludeSemantics(
            child: CustomPaint(size: Size(140, 26), painter: _SmilePainter()),
          ),
        ],
      ),
    );
  }
}

class _SmilePainter extends CustomPainter {
  const _SmilePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.03, h * 0.15)
      ..quadraticBezierTo(w / 2, h * 1.55, w * 0.97, h * 0.15)
      ..quadraticBezierTo(w / 2, h, w * 0.03, h * 0.15)
      ..close();
    canvas.drawPath(path, Paint()..color = ParlaColors.sun);
  }

  @override
  bool shouldRepaint(_SmilePainter oldDelegate) => false;
}

/// One row of the full step list, with a check toggle.
class StepTile extends StatelessWidget {
  const StepTile({
    super.key,
    required this.step,
    required this.number,
    required this.done,
    required this.onToggle,
  });

  final RoutineStep step;
  final int number;
  final bool done;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return SoftCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _NumberTile(number: number, color: step.tile, size: 48),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: text.titleMedium),
                Text(
                  done ? l10n.stepStatusDone : step.meta,
                  style: text.bodyMedium?.copyWith(color: ParlaColors.sunInk),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            button: true,
            toggled: done,
            label: done
                ? l10n.stepMarkUndone(step.title)
                : l10n.stepMarkDone(step.title),
            excludeSemantics: true,
            child: InkResponse(
              onTap: onToggle,
              radius: 28,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? ParlaColors.sun : ParlaColors.cream,
                  border: done
                      ? null
                      : Border.all(color: ParlaColors.outline, width: 2),
                ),
                alignment: Alignment.center,
                child: done
                    ? const ParlaIcon(ParlaIconName.check, strokeWidth: 2.5)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({
    required this.number,
    required this.color,
    required this.size,
  });

  final int number;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(size / 3.2),
    ),
    child: ExcludeSemantics(
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: size > 56 ? 26 : 20,
          fontWeight: FontWeight.w700,
          color: ParlaColors.espresso,
        ),
      ),
    ),
  );
}

/// A habit tile: icon, name, value, optional actions and a progress bar.
class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.background,
    required this.fill,
    this.track = ParlaColors.cream,
    this.fraction,
    this.actions = const [],
  });

  final ParlaIconName icon;
  final String title;
  final String value;
  final Color background;
  final Color fill;
  final Color track;

  /// Progress from 0 to 1, or `null` for no bar (nothing logged yet).
  final double? fraction;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ParlaIcon(icon, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium),
                    Semantics(
                      liveRegion: true,
                      child: Text(value, style: text.bodyMedium),
                    ),
                  ],
                ),
              ),
              ...actions,
            ],
          ),
          if (fraction != null) ...[
            const SizedBox(height: 12),
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: fraction!.clamp(0, 1)),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 12,
                    backgroundColor: track,
                    color: fill,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Round 48 px icon button used inside habit cards.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.background = ParlaColors.white,
  });

  final ParlaIconName icon;
  final String label;
  final VoidCallback? onPressed;
  final Color background;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: ParlaIcon(
                icon,
                size: 22,
                strokeWidth: 2.5,
                color: onPressed == null
                    ? ParlaColors.outline
                    : ParlaColors.espresso,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Half-width habit tile (sleep, movement) with a log action.
class SmallHabitTile extends StatelessWidget {
  const SmallHabitTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.background,
    required this.actionLabel,
    required this.onAction,
  });

  final ParlaIconName icon;
  final String title;
  final String value;
  final Color background;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ParlaIcon(icon, size: 28),
          const SizedBox(height: 10),
          Text(title, style: text.titleMedium),
          Text(value, style: text.bodyMedium),
          const SizedBox(height: 4),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
