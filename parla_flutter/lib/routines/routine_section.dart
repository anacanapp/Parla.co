import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parla_shared/parla_shared.dart';

import '../habits/habit_tracker.dart';
import '../home/routine.dart';
import '../home/widgets/home_cards.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'custom_routines.dart';

/// Label of a care area.
String areaLabel(AppLocalizations l10n, RoutineArea area) => switch (area) {
  RoutineArea.face => l10n.routineAreaFace,
  RoutineArea.hair => l10n.routineAreaHair,
  RoutineArea.body => l10n.routineAreaBody,
};

/// Label of a routine slot.
String slotLabel(AppLocalizations l10n, RoutineSlot slot) => switch (slot) {
  RoutineSlot.morning => l10n.routineSlotMorning,
  RoutineSlot.evening => l10n.routineSlotEvening,
  RoutineSlot.weekly => l10n.routineSlotWeekly,
};

/// "Every day" or the weekday name of a custom routine.
String customWhen(BuildContext context, CustomRoutine routine) {
  final l10n = AppLocalizations.of(context);
  final day = routine.weekday;
  if (day == null) return l10n.routineOwnEveryDay;
  final locale = Localizations.localeOf(context).toString();
  // 2024-01-01 was a Monday.
  return DateFormat.EEEE(locale).format(DateTime(2024, 1, day));
}

/// The care routines of the Routine tab: face, hair and body, each with
/// morning, evening and weekly steps, then the user's own routines.
class RoutinesSection extends StatefulWidget {
  const RoutinesSection({
    super.key,
    required this.answers,
    required this.habits,
    required this.book,
    required this.today,
    this.initialArea,
    this.initialSlot,
  });

  /// The area and slot to open on (a routine tapped on Today).
  final RoutineArea? initialArea;
  final RoutineSlot? initialSlot;

  /// Quiz answers, or `null` before the quiz (basic routines then).
  final QuizAnswers? answers;
  final HabitTracker habits;
  final CustomRoutineBook book;
  final DateTime today;

  @override
  State<RoutinesSection> createState() => _RoutinesSectionState();
}

class _RoutinesSectionState extends State<RoutinesSection> {
  late RoutineArea _area = widget.initialArea ?? RoutineArea.face;
  late RoutineSlot? _slot = widget.initialSlot;

  RoutineSlot _defaultSlot(AreaPlan plan) {
    final preferred = widget.today.hour < 15
        ? RoutineSlot.morning
        : RoutineSlot.evening;
    if (plan.slot(preferred).isNotEmpty) return preferred;
    return RoutineSlot.values.firstWhere(
      (s) => plan.slot(s).isNotEmpty,
      orElse: () => preferred,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final plan = planArea(_area, widget.answers);
    final slots = [
      for (final s in RoutineSlot.values)
        if (plan.slot(s).isNotEmpty) s,
    ];
    var slot = _slot ?? _defaultSlot(plan);
    if (!slots.contains(slot) && slots.isNotEmpty) slot = slots.first;
    final steps = routineSteps(plan.slot(slot), language);
    final own = widget.book.forArea(_area).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AreaTabs(
          selected: _area,
          onChanged: (area) => setState(() {
            _area = area;
            _slot = null;
          }),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in slots)
              _SlotChip(
                key: ValueKey('slot-${s.name}'),
                label:
                    '${slotLabel(l10n, s)} · '
                    '${_doneCount(plan.slot(s), s)}/${plan.slot(s).length}',
                selected: s == slot,
                onTap: () => setState(() => _slot = s),
              ),
          ],
        ),
        if (slot == RoutineSlot.weekly) ...[
          const SizedBox(height: 8),
          Text(
            l10n.routineWeeklyHint,
            style: text.bodySmall?.copyWith(color: ParlaColors.muted),
          ),
        ],
        const SizedBox(height: 12),
        if (steps.isEmpty)
          Text(
            l10n.routineSlotEmpty,
            style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
          ),
        if (steps.isNotEmpty) ...[
          StepList(
            steps: steps,
            rowKey: (s) => ValueKey('routine-step-${s.id}'),
            isDone: (i) => widget.habits.isDoneIn(slot, steps[i].id),
            onToggle: (i) => widget.habits.toggleIn(slot, steps[i].id),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(l10n.routineOwnSection, style: text.titleLarge),
              ),
            ),
            TextButton.icon(
              key: const ValueKey('routine-own-add'),
              onPressed: () => context.go(Routes.routineBuilder),
              icon: const ParlaIcon(ParlaIconName.plus, size: 18),
              label: Text(l10n.routineOwnButton),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (own.isEmpty)
          Text(
            l10n.routineOwnEmpty,
            style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
          ),
        for (final routine in own) ...[
          _OwnRoutineCard(
            key: ValueKey('own-${routine.id}'),
            routine: routine,
            book: widget.book,
            dueToday: routine.isDueOn(widget.today),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  int _doneCount(List<String> ids, RoutineSlot slot) =>
      ids.where((id) => widget.habits.isDoneIn(slot, id)).length;
}

class _AreaTabs extends StatelessWidget {
  const _AreaTabs({required this.selected, required this.onChanged});

  final RoutineArea selected;
  final ValueChanged<RoutineArea> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ParlaColors.line,
        borderRadius: BorderRadius.circular(ParlaSpace.controlRadius),
      ),
      child: Row(
        children: [
          for (final area in RoutineArea.values)
            Expanded(
              child: Semantics(
                button: true,
                selected: area == selected,
                child: InkWell(
                  key: ValueKey('area-${area.name}'),
                  borderRadius: BorderRadius.circular(11),
                  onTap: () => onChanged(area),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    constraints: const BoxConstraints(minHeight: 40),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: area == selected
                          ? ParlaColors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      areaLabel(l10n, area),
                      textAlign: TextAlign.center,
                      style: text.titleMedium?.copyWith(
                        color: area == selected
                            ? ParlaColors.espresso
                            : ParlaColors.muted,
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
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({
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
    child: InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 36),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? ParlaColors.sun : ParlaColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? ParlaColors.sun : ParlaColors.line,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? ParlaColors.espresso : ParlaColors.muted,
          ),
        ),
      ),
    ),
  );
}

/// One of the user's own routines: name, when, progress today and its
/// steps to tick off when it is due.
class _OwnRoutineCard extends StatelessWidget {
  const _OwnRoutineCard({
    super.key,
    required this.routine,
    required this.book,
    required this.dueToday,
  });

  final CustomRoutine routine;
  final CustomRoutineBook book;
  final bool dueToday;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final done = routine.steps.where((s) => book.isTicked(s.id)).length;
    return SoftCard(
      radius: ParlaSpace.cardRadius,
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(routine.name, style: text.titleMedium),
                    Text(
                      '${customWhen(context, routine)} · '
                      '${l10n.routineOwnSteps(routine.steps.length)}'
                      '${dueToday ? ' · $done/${routine.steps.length}' : ''}',
                      style: text.bodySmall?.copyWith(color: ParlaColors.muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.routineOwnEdit(routine.name),
                onPressed: () =>
                    context.go(Routes.routineBuilder, extra: routine.id),
                icon: const Icon(Icons.edit_outlined, size: 20),
              ),
            ],
          ),
          if (dueToday)
            for (final step in routine.steps)
              CheckboxListTile(
                key: ValueKey('own-step-${step.id}'),
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                value: book.isTicked(step.id),
                onChanged: (_) => book.toggleTick(step.id),
                title: Text(step.title, style: text.bodyMedium),
              ),
        ],
      ),
    );
  }
}
