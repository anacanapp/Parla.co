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
import '../ui/night.dart';
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

    final done = _doneCount(plan.slot(slot), slot);
    final next = [
      for (var i = 0; i < steps.length; i++)
        if (!widget.habits.isDoneIn(slot, steps[i].id)) steps[i],
    ].firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (slots.isNotEmpty)
          _SlotSwitch(
            slots: slots,
            selected: slot,
            labelOf: (s) => slotLabel(l10n, s),
            onChanged: (s) => setState(() => _slot = s),
          ),
        const SizedBox(height: 16),
        _AreaChips(
          selected: _area,
          onChanged: (area) => setState(() {
            _area = area;
            _slot = null;
          }),
        ),
        const SizedBox(height: 16),
        if (steps.isNotEmpty)
          _ProgressPebble(
            key: const ValueKey('routine-progress'),
            title:
                '${areaLabel(l10n, _area)} · '
                '${slotLabel(l10n, slot).toLowerCase()}',
            done: done,
            total: steps.length,
            subtitle: next == null
                ? l10n.stepStatusDone
                : l10n.sportNextUp(next.title),
          ),
        if (slot == RoutineSlot.weekly) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              l10n.routineWeeklyHint,
              style: text.bodySmall?.copyWith(color: ParlaColors.muted),
            ),
          ),
        ],
        const SizedBox(height: 16),
        if (steps.isEmpty)
          Text(
            l10n.routineSlotEmpty,
            style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
          ),
        for (final step in steps) ...[
          _GlassStepRow(
            key: ValueKey('routine-step-${step.id}'),
            step: step,
            done: widget.habits.isDoneIn(slot, step.id),
            current: identical(step, next),
            onToggle: () => widget.habits.toggleIn(slot, step.id),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        if (own.isEmpty)
          _OwnRoutineInvite(onAdd: () => context.go(Routes.routineBuilder))
        else ...[
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

/// Light ink on the night page and the dark ink on a light pill.
const _ink = ParlaColors.espresso;
const _pillInk = Color(0xFF1A0B2A);

/// Morning, evening (and weekly) in a glass capsule; the open slot is a
/// light pill.
class _SlotSwitch extends StatelessWidget {
  const _SlotSwitch({
    required this.slots,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  final List<RoutineSlot> slots;
  final RoutineSlot selected;
  final String Function(RoutineSlot slot) labelOf;
  final ValueChanged<RoutineSlot> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(5),
    decoration: ShapeDecoration(
      color: const Color(0x14FFFFFF),
      shape: const StadiumBorder(side: BorderSide(color: Color(0x24FFFFFF))),
    ),
    child: Row(
      children: [
        for (final s in slots)
          Expanded(
            child: Semantics(
              button: true,
              selected: s == selected,
              child: GestureDetector(
                key: ValueKey('slot-${s.name}'),
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  constraints: const BoxConstraints(minHeight: 44),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: ShapeDecoration(
                    color: s == selected ? _ink : Colors.transparent,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    labelOf(s),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: s == selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: s == selected ? _pillInk : _ink,
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

/// Face, hair and body as capsules: the open area in the plum gradient,
/// the others glass.
class _AreaChips extends StatelessWidget {
  const _AreaChips({required this.selected, required this.onChanged});

  final RoutineArea selected;
  final ValueChanged<RoutineArea> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final area in RoutineArea.values)
          _AreaChip(
            key: ValueKey('area-${area.name}'),
            label: areaLabel(l10n, area),
            selected: area == selected,
            onTap: () => onChanged(area),
          ),
      ],
    );
  }
}

class _AreaChip extends StatelessWidget {
  const _AreaChip({
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
    excludeSemantics: true,
    label: label,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      // A 44 px tap area around the 40 px capsule.
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Container(
          height: 40,
          constraints: const BoxConstraints(minWidth: 44),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            gradient: selected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFC653B0), Color(0xFF7A2FA8)],
                  )
                : null,
            color: selected ? null : const Color(0x0FFFFFFF),
            shape: StadiumBorder(
              side: selected
                  ? BorderSide.none
                  : const BorderSide(color: Color(0x2EFFFFFF)),
            ),
          ),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                color: selected ? const Color(0xFFFFFFFF) : _ink,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// The plum progress card: a tick ring with "done/total", the area and
/// slot, and the next step.
class _ProgressPebble extends StatelessWidget {
  const _ProgressPebble({
    super.key,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.total,
  });

  final String title;
  final String subtitle;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    liveRegion: true,
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          begin: Alignment(-0.35, -1),
          end: Alignment(0.35, 1),
          colors: [Color(0xFFA8429A), Color(0xFF6E2A9A), Color(0xFF2B0F45)],
          stops: [0, .55, 1],
        ),
        border: Border.all(color: const Color(0x2EFFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D280050),
            blurRadius: 40,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        children: [
          TickRing(
            fraction: total == 0 ? 0 : done / total,
            label: '$done/$total',
            size: 84,
            color: _ink,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: _ink.withValues(alpha: .8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// One step as a glass row: a round toggle (light with a tick when done),
/// the title (struck through when done) and how to do it. The next step
/// to do is brighter. Tapping the text shows the whole hint.
class _GlassStepRow extends StatefulWidget {
  const _GlassStepRow({
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
  State<_GlassStepRow> createState() => _GlassStepRowState();
}

class _GlassStepRowState extends State<_GlassStepRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final step = widget.step;
    final done = widget.done;
    final hint = done ? l10n.stepStatusDone : step.meta;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
      decoration: ShapeDecoration(
        color: Color(widget.current ? 0x1AFFFFFF : 0x0FFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
            color: Color(widget.current ? 0x38FFFFFF : 0x1FFFFFFF),
          ),
        ),
      ),
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
              radius: 24,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? _ink : Colors.transparent,
                      border: done
                          ? null
                          : Border.all(
                              color: _ink.withValues(alpha: .6),
                              width: 1.5,
                            ),
                    ),
                    alignment: Alignment.center,
                    child: done
                        ? const ParlaIcon(
                            ParlaIconName.check,
                            size: 18,
                            color: _pillInk,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: done ? null : () => setState(() => _open = !_open),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 15,
                        color: done ? _ink.withValues(alpha: .6) : _ink,
                        decoration: done ? TextDecoration.lineThrough : null,
                        decorationColor: _ink.withValues(alpha: .6),
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
                          style: TextStyle(
                            fontSize: kMinTextSize,
                            color: _ink.withValues(alpha: done ? .5 : .65),
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
              child: ParlaIcon(ParlaIconName.arrowRight, size: 18, color: _ink),
            ),
          ],
        ],
      ),
    );
  }
}

/// Before the first own routine: a glass card that invites to make one.
class _OwnRoutineInvite extends StatelessWidget {
  const _OwnRoutineInvite({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return GlassSurface(
      padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
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
                    style: text.titleMedium,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.routineOwnEmpty,
                  style: text.bodySmall?.copyWith(color: ParlaColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Semantics(
            button: true,
            label: l10n.routineOwnButton,
            excludeSemantics: true,
            child: Material(
              color: _ink,
              shape: const CircleBorder(),
              child: InkWell(
                key: const ValueKey('routine-own-add'),
                customBorder: const CircleBorder(),
                onTap: onAdd,
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: ParlaIcon(
                      ParlaIconName.plus,
                      size: 22,
                      color: _pillInk,
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
    return GlassSurface(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(16, 10, 6, 10),
      child: Material(
        type: MaterialType.transparency,
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
                        style: text.bodySmall?.copyWith(
                          color: ParlaColors.muted,
                        ),
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
      ),
    );
  }
}
