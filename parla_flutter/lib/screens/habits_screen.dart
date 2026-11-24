import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parla_shared/parla_shared.dart';

import '../habits/habit_log.dart';
import '../habits/habit_sheets.dart';
import '../habits/habit_tracker.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../routines/custom_routines.dart';
import '../routines/routine_section.dart';
import '../ui/parla_icons.dart';
import '../ui/warm.dart';

/// M-17 "Rutin": face, hair and body routines, the user's own routines,
/// today's habits and the last seven days.
///
/// Only plain counts and averages, no scores, targets for sleep or streaks
/// that can be "lost": the tab should encourage, not pressure. Values are
/// the user's own entries and are never judged.
class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  bool _attached = false;

  /// The quiz answers, `null` until loaded or when the quiz was not taken.
  QuizAnswers? _answers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_attached) {
      _attached = true;
      final scope = ParlaScope.of(context);
      scope.attachAccount();
      _loadAnswers();
    }
  }

  Future<void> _loadAnswers() async {
    QuizAnswers? answers;
    try {
      answers = await ParlaScope.of(context).api.myQuizAnswers();
    } on Object {
      answers = null; // Basic routines still work offline.
    }
    if (!mounted) return;
    setState(() => _answers = answers);
  }

  @override
  Widget build(BuildContext context) {
    final scope = ParlaScope.of(context);
    final habits = scope.habits;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.routine),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          habits,
          scope.reminders,
          scope.routines,
        ]),
        builder: (context, _) => _HabitsBody(
          habits: habits,
          book: scope.routines,
          answers: _answers,
          today: scope.clock(),
        ),
      ),
    );
  }
}

class _HabitsBody extends StatelessWidget {
  const _HabitsBody({
    required this.habits,
    required this.book,
    required this.answers,
    required this.today,
  });

  final HabitTracker habits;
  final CustomRoutineBook book;
  final QuizAnswers? answers;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = GoRouterState.of(context).uri.queryParameters;
    final week = WeekSummary(
      habits.log,
      today,
      ownRoutineDays: book.tickedDays,
    );
    final reminders = ParlaScope.of(context).reminders;
    final enabledReminders = reminders.settings.reminders.values
        .where((r) => r.enabled)
        .length;
    final waterAverage = week.waterAverage;
    final sleepAverage = week.sleepAverage;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 120),
        children: [
          WarmHeader(
            title: l10n.habitsScreenTitle,
            trailing: Tooltip(
              message: l10n.skinCardBody,
              child: _SmokyCapsule(
                key: const ValueKey('habits-skin-analysis'),
                label: l10n.skinCardTitle,
                icon: ParlaIconName.scan,
                onPressed: () => context.go(Routes.quiz),
              ),
            ),
          ),
          const SizedBox(height: 14),
          RoutinesSection(
            key: ValueKey('routines-${query['area']}-${query['slot']}'),
            initialArea: RoutineArea.values
                .where((a) => a.name == query['area'])
                .firstOrNull,
            initialSlot: RoutineSlot.values
                .where((s) => s.name == query['slot'])
                .firstOrNull,
            answers: answers,
            habits: habits,
            book: book,
            today: today,
          ),
          const SizedBox(height: 26),
          _SectionTitle(l10n.routineDayHabits),
          const SizedBox(height: 12),
          _WaterCard(
            key: const ValueKey('habits-water'),
            title: l10n.habitWater,
            value: l10n.habitWaterCount(habits.water, HabitTracker.waterGoal),
            fraction: habits.water / HabitTracker.waterGoal,
            removeLabel: l10n.habitWaterRemove,
            addLabel: l10n.habitWaterAdd,
            onRemove: habits.water == 0 ? null : habits.removeWater,
            onAdd: habits.water >= HabitTracker.waterGoal
                ? null
                : habits.addWater,
          ),
          const SizedBox(height: 10),
          _LogRow(
            key: const ValueKey('habits-sleep'),
            icon: ParlaIconName.moon,
            tint: SmokyTint.burnt,
            title: l10n.habitSleep,
            value: habits.sleepHours == null
                ? l10n.habitNoEntry
                : l10n.habitSleepHours(formatHours(habits.sleepHours!)),
            action: habits.sleepHours == null ? l10n.habitLog : l10n.habitEdit,
            onTap: () => logSleep(context, habits),
          ),
          const SizedBox(height: 10),
          _LogRow(
            key: const ValueKey('habits-move'),
            icon: ParlaIconName.move,
            tint: SmokyTint.coral,
            title: l10n.habitMove,
            value: habits.moveMinutes == null
                ? l10n.habitNoEntry
                : l10n.habitMoveMinutes(habits.moveMinutes!),
            action: habits.moveMinutes == null ? l10n.habitLog : l10n.habitEdit,
            onTap: () => logMove(context, habits),
          ),
          if (reminders.supported) ...[
            const SizedBox(height: 10),
            _LogRow(
              key: const ValueKey('habits-reminders'),
              icon: ParlaIconName.sparkle,
              title: l10n.remindersTitle,
              value: enabledReminders == 0
                  ? l10n.remindersSummaryOff
                  : l10n.remindersSummaryOn(enabledReminders),
              action: l10n.remindersOpen,
              onTap: () => context.go(Routes.reminders),
            ),
          ],
          const SizedBox(height: 28),
          _SectionTitle(l10n.habitsWeekTitle),
          const SizedBox(height: 12),
          _WeekCard(
            key: const ValueKey('week-care'),
            title: l10n.habitsWeekCare,
            value: l10n.habitsWeekCareValue(week.careDays),
            dates: week.dates,
            fractions: [
              for (final c in week.care) c ? 1 : 0,
            ],
            fill: const Color(0xFFF6A35C),
          ),
          const SizedBox(height: 10),
          _WeekCard(
            key: const ValueKey('week-water'),
            title: l10n.habitWater,
            value: waterAverage == null
                ? l10n.habitsWeekNone
                : l10n.habitsWeekWaterValue(_oneDecimal(context, waterAverage)),
            dates: week.dates,
            fractions: [
              for (final w in week.water) w / HabitTracker.waterGoal,
            ],
            fill: const Color(0xFFC9E04A),
          ),
          const SizedBox(height: 10),
          _WeekCard(
            key: const ValueKey('week-sleep'),
            title: l10n.habitSleep,
            value: sleepAverage == null
                ? l10n.habitsWeekNone
                : l10n.habitsWeekSleepValue(
                    formatHours((sleepAverage * 2).round() / 2),
                    week.sleepNights,
                  ),
            dates: week.dates,
            fractions: [
              for (final s in week.sleep) (s ?? 0) / HabitTracker.maxSleepHours,
            ],
            fill: Colors.white,
          ),
          const SizedBox(height: 10),
          _WeekCard(
            key: const ValueKey('week-move'),
            title: l10n.habitMove,
            value: week.moveDays == 0
                ? l10n.habitsWeekNone
                : l10n.habitsWeekMoveValue(week.moveTotal, week.moveDays),
            dates: week.dates,
            fractions: _relative(week.move),
            fill: const Color(0xFFF08A6E),
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: ParlaIcon(
                  ParlaIconName.check,
                  size: 22,
                  color: Warm.ink,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.habitsPrivacyNote,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: Warm.muted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _oneDecimal(BuildContext context, double value) => NumberFormat(
    '0.#',
    Localizations.localeOf(context).toString(),
  ).format(value);

  /// Movement bars relative to the week's longest day (at least an hour).
  static List<double> _relative(List<int?> minutes) {
    final values = [for (final m in minutes) m ?? 0];
    final top = values.fold(60, (a, b) => a > b ? a : b);
    return [for (final v in values) v / top];
  }
}

/// A section heading on the page (dark, thin).
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: -.4,
          color: Warm.ink,
        ),
      ),
    ),
  );
}

/// Water as a smoky card with a coral glow: the count, a dot meter and
/// round − and + buttons.
class _WaterCard extends StatelessWidget {
  const _WaterCard({
    super.key,
    required this.title,
    required this.value,
    required this.fraction,
    required this.removeLabel,
    required this.addLabel,
    required this.onRemove,
    required this.onAdd,
  });

  final String title;
  final String value;
  final double fraction;
  final String removeLabel;
  final String addLabel;
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => SmokyGlass(
    radius: 40,
    tint: SmokyTint.coral,
    padding: const EdgeInsets.fromLTRB(22, 16, 14, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _GlassRound(
              icon: ParlaIconName.minus,
              label: removeLabel,
              onPressed: onRemove,
            ),
            const SizedBox(width: 8),
            _GlassRound(
              icon: ParlaIconName.plus,
              label: addLabel,
              onPressed: onAdd,
            ),
          ],
        ),
        const SizedBox(height: 10),
        DotsMeter(fraction: fraction, columns: 24),
      ],
    ),
  );
}

/// A 48 px round button with a white ring on glass.
class _GlassRound extends StatelessWidget {
  const _GlassRound({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final ParlaIconName icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onPressed != null,
    label: label,
    excludeSemantics: true,
    child: Material(
      color: const Color(0x26FFFFFF),
      shape: const CircleBorder(side: BorderSide(color: Color(0x66FFFFFF))),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: ParlaIcon(
              icon,
              size: 20,
              color: onPressed == null ? Warm.onCardSoft : Warm.onCard,
            ),
          ),
        ),
      ),
    ),
  );
}

/// A smoky capsule with a ring icon, a value and a log or edit action.
class _LogRow extends StatelessWidget {
  const _LogRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.action,
    required this.onTap,
    this.tint = SmokyTint.none,
  });

  final ParlaIconName icon;
  final SmokyTint tint;
  final String title;
  final String value;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 72),
    child: SmokyGlass(
      shape: const StadiumBorder(),
      tint: tint,
      shadow: false,
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
      child: Row(
        children: [
          RingIcon(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13)),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Warm.black,
              backgroundColor: Colors.white,
              shape: const StadiumBorder(),
              minimumSize: const Size(64, 44),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: onTap,
            child: Text(action, semanticsLabel: '$action: $title'),
          ),
        ],
      ),
    ),
  );
}

/// A habit over the last seven days: a summary line and one bar per day,
/// oldest first, today last and marked.
class _WeekCard extends StatelessWidget {
  const _WeekCard({
    super.key,
    required this.title,
    required this.value,
    required this.dates,
    required this.fractions,
    required this.fill,
  });

  final String title;
  final String value;
  final List<DateTime> dates;
  final List<num> fractions;
  final Color fill;

  static const _barHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final weekday = DateFormat.E(locale);
    return Semantics(
      container: true,
      label: '$title. $value',
      excludeSemantics: true,
      child: SmokyGlass(
        radius: 34,
        shadow: false,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontSize: 15)),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Warm.onCardSoft,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < dates.length; i++)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 18,
                          height: _barHeight,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: const Color(0x24FFFFFF),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: FractionallySizedBox(
                            heightFactor: fractions[i].clamp(0, 1).toDouble(),
                            widthFactor: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: fill,
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          // First letters of the short weekday name.
                          _initial(weekday.format(dates[i])),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: i == dates.length - 1
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: i == dates.length - 1
                                ? Warm.onCard
                                : Warm.onCardSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// One or two letters: enough to tell the days apart and fits at large text sizes.
  static String _initial(String shortName) {
    final clean = shortName.replaceAll('.', '');
    return clean.length <= 2 ? clean : clean.substring(0, 2);
  }
}

/// A small smoky capsule button with an icon (skin analysis).
class _SmokyCapsule extends StatelessWidget {
  const _SmokyCapsule({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final ParlaIconName icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: SmokyGlass(
        shape: const StadiumBorder(),
        shadow: false,
        onTap: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ParlaIcon(icon, size: 16, color: Warm.onCard),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    ),
  );
}
