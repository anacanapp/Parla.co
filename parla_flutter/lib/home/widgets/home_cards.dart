import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/brand.dart';
import '../../ui/night.dart';
import '../../ui/parla_icons.dart';
import '../../ui/parla_ui.dart';
import '../../ui/warm.dart';
import '../routine.dart';

/// A glass card of the night design: a faint white fill and hairline.
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
  Widget build(BuildContext context) =>
      LiquidGlass(radius: radius, padding: padding, child: child);
}

/// Small spaced capitals label, e.g. "NÖVBƏTİ ADDIM".
class EyebrowText extends StatelessWidget {
  const EyebrowText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: kMinTextSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      color: ParlaColors.sunInk,
    ),
  );
}

/// The routine's progress as a white capsule in the hero: ring, eyebrow,
/// status and a round button that opens the Routine tab.
class RoutineHeroCapsule extends StatelessWidget {
  const RoutineHeroCapsule({
    super.key,
    required this.eyebrow,
    required this.status,
    this.caption,
    required this.doneCount,
    required this.total,
    required this.semanticLabel,
    required this.openLabel,
    required this.onOpen,
  });

  final String eyebrow;
  final String status;
  final String? caption;
  final int doneCount;
  final int total;
  final String semanticLabel;
  final String openLabel;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      key: const ValueKey('routine-hero'),
      padding: const EdgeInsets.all(8),
      decoration: const ShapeDecoration(
        color: ParlaColors.white,
        shape: StadiumBorder(),
        shadows: [
          BoxShadow(
            color: Color(0x1F7A5C00),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Semantics(
            label: semanticLabel,
            excludeSemantics: true,
            child: ProgressRing(
              fraction: total == 0 ? 0 : doneCount / total,
              label: '$doneCount/$total',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EyebrowText(eyebrow),
                const SizedBox(height: 2),
                Text(status, style: text.titleSmall),
                if (caption != null)
                  Text(
                    caption!,
                    style: text.bodySmall?.copyWith(color: ParlaColors.muted),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            button: true,
            label: openLabel,
            excludeSemantics: true,
            child: Material(
              color: ParlaColors.sun,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onOpen,
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: ParlaIcon(ParlaIconName.arrowRight, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
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

/// A routine's steps as glass rows (night design 3.0): the next open
/// step is a little brighter. Each row's hint shows on one line and opens
/// in full on tap, so safety notes (such as re-applying sunscreen) stay
/// one tap away.
class StepList extends StatelessWidget {
  const StepList({
    super.key,
    required this.steps,
    required this.isDone,
    required this.onToggle,
    required this.rowKey,
  });

  final List<RoutineStep> steps;
  final bool Function(int index) isDone;
  final void Function(int index) onToggle;
  final Key Function(RoutineStep step) rowKey;

  @override
  Widget build(BuildContext context) {
    final next = [
      for (var i = 0; i < steps.length; i++)
        if (!isDone(i)) i,
    ].firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          StepTile(
            key: rowKey(steps[i]),
            step: steps[i],
            number: i + 1,
            done: isDone(i),
            highlighted: i == next,
            onToggle: () => onToggle(i),
          ),
        ],
      ],
    );
  }
}

/// One row of a [StepList], with a check toggle.
class StepTile extends StatefulWidget {
  const StepTile({
    super.key,
    required this.step,
    required this.number,
    required this.done,
    required this.onToggle,
    this.highlighted = false,
  });

  final RoutineStep step;

  /// Position in the routine (read by screen readers in the row order).
  final int number;
  final bool done;
  final VoidCallback onToggle;

  /// The next step to do: a brighter glass.
  final bool highlighted;

  @override
  State<StepTile> createState() => _StepTileState();
}

class _StepTileState extends State<StepTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final step = widget.step;
    final done = widget.done;
    final hint = done ? l10n.stepStatusDone : step.meta;
    // Its own node: the glass around it is a tap target that would
    // otherwise merge this label into its own.
    final check = Semantics(
      container: true,
      button: true,
      toggled: done,
      label: done
          ? l10n.stepMarkUndone(step.title)
          : l10n.stepMarkDone(step.title),
      excludeSemantics: true,
      // A thin 28 px circle in a 48 px tap area (owner 2026-11-26,
      // variant C): a banana disc with an ink tick when done.
      child: InkResponse(
        onTap: widget.onToggle,
        radius: 24,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(child: CheckCircle(done: done)),
        ),
      ),
    );
    // Warm day design: a smoky glass capsule; the next step glows burnt
    // orange.
    return SmokyGlass(
      shape: const StadiumBorder(),
      tint: widget.highlighted ? SmokyTint.burnt : SmokyTint.none,
      shadow: false,
      padding: const EdgeInsets.fromLTRB(8, 6, 20, 6),
      child: Row(
        children: [
          check,
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: done ? null : () => setState(() => _open = !_open),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 15,
                        color: done ? Warm.onCardSoft : Warm.onCard,
                        decoration: done ? TextDecoration.lineThrough : null,
                        decorationColor: Warm.onCardSoft,
                      ),
                    ),
                    if (hint.isNotEmpty)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 160),
                        alignment: Alignment.topLeft,
                        child: Text(
                          hint,
                          maxLines: _open && !done ? null : 1,
                          overflow: _open && !done
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: kMinTextSize,
                            color: Warm.onCardSoft,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
