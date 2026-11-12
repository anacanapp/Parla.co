import 'package:flutter/material.dart';

import '../home/widgets/home_cards.dart';
import '../l10n/app_localizations.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'habit_tracker.dart';

/// Formats hours in half-hour steps, e.g. "7½".
String formatHours(double hours) {
  final whole = hours.floor();
  final half = hours - whole >= 0.5;
  if (!half) return '$whole';
  return whole == 0 ? '½' : '$whole½';
}

/// Asks for last night's sleep and saves it.
Future<void> logSleep(BuildContext context, HabitTracker habits) async {
  final l10n = AppLocalizations.of(context);
  final result = await showStepperSheet(
    context,
    title: l10n.habitSleepSheetTitle,
    icon: ParlaIconName.moon,
    initial: habits.sleepHours ?? 7,
    step: 0.5,
    max: HabitTracker.maxSleepHours,
    format: (v) => l10n.habitSleepHours(formatHours(v)),
    canClear: habits.sleepHours != null,
  );
  if (result == null) return;
  habits.setSleep(result.cleared ? null : result.value);
}

/// Asks for today's movement in minutes and saves it.
Future<void> logMove(BuildContext context, HabitTracker habits) async {
  final l10n = AppLocalizations.of(context);
  final result = await showStepperSheet(
    context,
    title: l10n.habitMoveSheetTitle,
    icon: ParlaIconName.move,
    initial: (habits.moveMinutes ?? 20).toDouble(),
    step: 5,
    max: HabitTracker.maxMoveMinutes.toDouble(),
    format: (v) => l10n.habitMoveMinutes(v.round()),
    canClear: habits.moveMinutes != null,
  );
  if (result == null) return;
  habits.setMove(result.cleared ? null : result.value.round());
}

/// What a stepper sheet returns: the chosen value, or `cleared`.
class StepperResult {
  const StepperResult(this.value, {this.cleared = false});

  final double value;
  final bool cleared;
}

/// A bottom sheet with a value, minus and plus buttons and Save. With
/// [canClear] it also offers to remove the entry.
Future<StepperResult?> showStepperSheet(
  BuildContext context, {
  required String title,
  required ParlaIconName icon,
  required double initial,
  required double step,
  required double max,
  required String Function(double) format,
  bool canClear = false,
}) => showModalBottomSheet<StepperResult>(
  context: context,
  backgroundColor: ParlaColors.cream,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
  ),
  builder: (context) => _StepperSheet(
    title: title,
    icon: icon,
    initial: initial,
    step: step,
    max: max,
    format: format,
    canClear: canClear,
  ),
);

class _StepperSheet extends StatefulWidget {
  const _StepperSheet({
    required this.title,
    required this.icon,
    required this.initial,
    required this.step,
    required this.max,
    required this.format,
    required this.canClear,
  });

  final String title;
  final ParlaIconName icon;
  final double initial;
  final double step;
  final double max;
  final String Function(double) format;
  final bool canClear;

  @override
  State<_StepperSheet> createState() => _StepperSheetState();
}

class _StepperSheetState extends State<_StepperSheet> {
  late double _value = widget.initial;

  void _by(double delta) =>
      setState(() => _value = (_value + delta).clamp(0, widget.max));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final label = widget.format(_value);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ParlaIcon(widget.icon, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(widget.title, style: text.titleLarge),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                RoundIconButton(
                  icon: ParlaIconName.minus,
                  label: l10n.habitLess,
                  onPressed: _value <= 0 ? null : () => _by(-widget.step),
                ),
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      label,
                      key: const ValueKey('habit-sheet-value'),
                      textAlign: TextAlign.center,
                      style: text.headlineMedium,
                    ),
                  ),
                ),
                RoundIconButton(
                  icon: ParlaIconName.plus,
                  label: l10n.habitMore,
                  onPressed: _value >= widget.max
                      ? null
                      : () => _by(widget.step),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(StepperResult(_value)),
              child: Text(l10n.habitSave),
            ),
            if (widget.canClear) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop(const StepperResult(0, cleared: true)),
                child: Text(l10n.habitClearEntry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
