import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parla_shared/parla_shared.dart';

import '../habits/habit_tracker.dart';
import '../home/routine.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import '../ui/warm.dart';
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

    final done = _doneCount(plan.slot(slot), slot);
    final next = [
      for (var i = 0; i < steps.length; i++)
        if (!widget.habits.isDoneIn(slot, steps[i].id)) steps[i],
    ].firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (slots.isNotEmpty)
          WarmSegmented<RoutineSlot>(
            values: slots,
            selected: slot,
            labelOf: (s) => slotLabel(l10n, s),
            keyOf: (s) => ValueKey('slot-${s.name}'),
            onChanged: (s) => setState(() => _slot = s),
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final area in RoutineArea.values)
              WarmChip(
                key: ValueKey('area-${area.name}'),
                label: areaLabel(l10n, area),
                selected: area == _area,
                onTap: () => setState(() {
                  _area = area;
                  _slot = null;
                }),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (steps.isNotEmpty)
          _ProgressCard(
            key: const ValueKey('routine-progress'),
            area: areaLabel(l10n, _area),
            slot: slotLabel(l10n, slot).toLowerCase(),
            done: done,
            total: steps.length,
            next: next?.title,
            onDoneNext: next == null
                ? null
                : () => widget.habits.toggleIn(slot, next.id),
          ),
        if (slot == RoutineSlot.weekly) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              l10n.routineWeeklyHint,
              style: const TextStyle(fontSize: 13, color: Warm.muted),
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (steps.isEmpty)
          Text(
            l10n.routineSlotEmpty,
            style: const TextStyle(fontSize: 15, color: Warm.muted),
          ),
        for (final step in steps) ...[
          _StepRow(
            key: ValueKey('routine-step-${step.id}'),
            step: step,
            done: widget.habits.isDoneIn(slot, step.id),
            current: identical(step, next),
            onToggle: () => widget.habits.toggleIn(slot, step.id),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        if (own.isEmpty)
          _OwnRoutineInvite(onAdd: () => context.go(Routes.routineBuilder))
        else ...[
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.routineOwnSection,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Warm.ink,
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                key: const ValueKey('routine-own-add'),
                style: TextButton.styleFrom(foregroundColor: Warm.ink),
                onPressed: () => context.go(Routes.routineBuilder),
                icon: const ParlaIcon(
                  ParlaIconName.plus,
                  size: 18,
                  color: Warm.ink,
                ),
                label: Text(l10n.routineOwnButton),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (final routine in own) ...[
            _OwnRoutineCard(
              key: ValueKey('own-${routine.id}'),
              routine: routine,
              book: widget.book,
              dueToday: routine.isDueOn(widget.today),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }

  int _doneCount(List<String> ids, RoutineSlot slot) =>
      ids.where((id) => widget.habits.isDoneIn(slot, id)).length;
}

/// The rose progress card of the prototype: area and slot with a black
/// arrow that ticks off the next step, "done/total" large, a tick meter
/// and the next step at the bottom.
class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    super.key,
    required this.area,
    required this.slot,
    required this.done,
    required this.total,
    required this.next,
    required this.onDoneNext,
  });

  final String area;
  final String slot;
  final int done;
  final int total;
  final String? next;
  final VoidCallback? onDoneNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final left = total - done;
    return Semantics(
      container: true,
      liveRegion: true,
      label: l10n.routineProgressLabel('$area · $slot', done, total),
      child: SquircleCard(
        tone: SquircleTone.rose,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SquircleHead(
              icon: ParlaIconName.sparkle,
              title: area,
              subtitle: slot,
              onOpen: onDoneNext,
              openLabel: next == null ? null : l10n.stepMarkDone(next!),
            ),
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        left > 0
                            ? l10n.routineStatusLeft(left)
                            : l10n.stepStatusDone,
                        style: const TextStyle(
                          fontSize: kMinTextSize,
                          color: Warm.onCardSoft,
                        ),
                      ),
                      Text(
                        '$done/$total',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  l10n.routineOwnSteps(total),
                  style: const TextStyle(
                    fontSize: kMinTextSize,
                    color: Warm.onCardSoft,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TicksMeter(fraction: total == 0 ? 0 : done / total, count: 28),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  next == null ? l10n.stepStatusDone : l10n.sportNextLabel,
                  style: const TextStyle(
                    fontSize: kMinTextSize,
                    color: Warm.onCardSoft,
                  ),
                ),
                const SizedBox(width: 12),
                if (next != null)
                  Expanded(
                    child: Text(
                      next!,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: kMinTextSize,
                        color: Warm.onCardSoft,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One step as a smoky capsule: a round toggle (white with a tick when
/// done), the title (struck through when done) and how to do it. The next
/// step to do glows burnt orange. Tapping the text shows the whole hint.
class _StepRow extends StatefulWidget {
  const _StepRow({
    super.key,
    required this.step,
    required this.done,
    required this.current,
    required this.onToggle,
  });

  final RoutineStep step;
  final bool done;
  final bool current;
  final VoidCallback onToggle;

  @override
  State<_StepRow> createState() => _StepRowState();
}

class _StepRowState extends State<_StepRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final step = widget.step;
    final done = widget.done;
    final hint = done ? l10n.stepStatusDone : step.meta;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: SmokyGlass(
        radius: 32,
        tint: widget.current && !done ? SmokyTint.burnt : SmokyTint.none,
        shadow: false,
        padding: const EdgeInsets.fromLTRB(8, 4, 18, 4),
        child: Row(
          children: [
            Semantics(
              button: true,
              toggled: done,
              label: done
                  ? l10n.stepMarkUndone(step.title)
                  : l10n.stepMarkDone(step.title),
              excludeSemantics: true,
              child: InkResponse(
                onTap: widget.onToggle,
                radius: 26,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? Colors.white : Colors.transparent,
                        border: done
                            ? null
                            : Border.all(
                                color: const Color(0x99FFFFFF),
                                width: 1.5,
                              ),
                      ),
                      alignment: Alignment.center,
                      child: done
                          ? const ParlaIcon(
                              ParlaIconName.check,
                              size: 18,
                              color: Warm.black,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: done ? null : () => setState(() => _open = !_open),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
            if (widget.current && !done) ...[
              const SizedBox(width: 8),
              const ExcludeSemantics(
                child: ParlaIcon(
                  ParlaIconName.arrowRight,
                  size: 18,
                  color: Warm.onCard,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Before the first own routine: a smoky capsule that invites to make one,
/// with the glowing "+".
class _OwnRoutineInvite extends StatelessWidget {
  const _OwnRoutineInvite({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SmokyGlass(
      radius: 40,
      padding: const EdgeInsets.fromLTRB(22, 12, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.routineOwnSection,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.routineOwnEmpty,
                  style: const TextStyle(
                    fontSize: kMinTextSize,
                    color: Warm.onCardSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GlowPlusButton(
            key: const ValueKey('routine-own-add'),
            onPressed: onAdd,
            label: l10n.routineOwnButton,
            size: 60,
          ),
        ],
      ),
    );
  }
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
    final done = routine.steps.where((s) => book.isTicked(s.id)).length;
    return SmokyGlass(
      radius: 32,
      shadow: false,
      padding: const EdgeInsets.fromLTRB(18, 10, 6, 10),
      child: Theme(
        data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
            side: const BorderSide(color: Color(0x99FFFFFF), width: 1.5),
            fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.transparent,
            ),
            checkColor: const WidgetStatePropertyAll(Warm.black),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(routine.name, style: const TextStyle(fontSize: 16)),
                      Text(
                        '${customWhen(context, routine)} · '
                        '${l10n.routineOwnSteps(routine.steps.length)}'
                        '${dueToday ? ' · $done/${routine.steps.length}' : ''}',
                        style: const TextStyle(
                          fontSize: kMinTextSize,
                          color: Warm.onCardSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.routineOwnEdit(routine.name),
                  color: Warm.onCard,
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
                  title: Text(
                    step.title,
                    style: const TextStyle(fontSize: 15, color: Warm.onCard),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
