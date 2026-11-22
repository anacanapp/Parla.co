import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/brand.dart';
import '../../ui/parla_icons.dart';
import '../../ui/parla_ui.dart';
import '../routine.dart';

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

/// A routine's steps as one compact card: a row per step, divided by
/// hairlines. Each row's hint shows on one line and opens in full on tap,
/// so safety notes (such as re-applying sunscreen) stay one tap away.
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
  Widget build(BuildContext context) => SoftCard(
    radius: ParlaShape.card,
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            const Divider(
              height: 1,
              thickness: 1,
              indent: 58,
              endIndent: 16,
              color: ParlaColors.line,
            ),
          StepTile(
            key: rowKey(steps[i]),
            step: steps[i],
            number: i + 1,
            done: isDone(i),
            onToggle: () => onToggle(i),
          ),
        ],
      ],
    ),
  );
}

/// One row of a [StepList], with a check toggle.
class StepTile extends StatefulWidget {
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
  State<StepTile> createState() => _StepTileState();
}

class _StepTileState extends State<StepTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final step = widget.step;
    final done = widget.done;
    final hint = done ? l10n.stepStatusDone : step.meta;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      child: Row(
        children: [
          _NumberTile(number: widget.number, color: step.tile, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: done ? null : () => setState(() => _open = !_open),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: text.titleSmall?.copyWith(
                      color: done ? ParlaColors.muted : null,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: ParlaColors.outline,
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
                        style: text.bodySmall?.copyWith(
                          color: ParlaColors.sunInk,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          Semantics(
            button: true,
            toggled: done,
            label: done
                ? l10n.stepMarkUndone(step.title)
                : l10n.stepMarkDone(step.title),
            excludeSemantics: true,
            // A 32 px circle (owner's ask, 2026-11-20) in a 48 px tap area.
            child: InkResponse(
              onTap: widget.onToggle,
              radius: 24,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? ParlaColors.sun : ParlaColors.cream,
                      border: done
                          ? null
                          : Border.all(color: ParlaColors.outline, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: done
                        ? const ParlaIcon(
                            ParlaIconName.check,
                            size: 18,
                            strokeWidth: 2.5,
                          )
                        : null,
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
          fontSize: size > 56 ? 26 : (size < 36 ? 16 : 20),
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
