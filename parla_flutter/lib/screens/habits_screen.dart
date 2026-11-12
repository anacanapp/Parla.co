import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../habits/habit_log.dart';
import '../habits/habit_sheets.dart';
import '../habits/habit_tracker.dart';
import '../home/widgets/home_cards.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';

/// M-17 "Vərdişlər": today's habits and the last seven days.
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_attached) {
      _attached = true;
      final scope = ParlaScope.of(context);
      scope.attachAccount();
    }
  }

  void _onNav(int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
      case 1:
        context.go(Routes.guest);
      case 3:
        context.go(Routes.privacy);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = ParlaScope.of(context);
    final habits = scope.habits;
    return Scaffold(
      backgroundColor: ParlaColors.cream,
      extendBody: true,
      bottomNavigationBar: ParlaNavBar(selected: 2, onTap: _onNav),
      body: ListenableBuilder(
        listenable: Listenable.merge([habits, scope.reminders]),
        builder: (context, _) =>
            _HabitsBody(habits: habits, today: scope.clock()),
      ),
    );
  }
}

class _HabitsBody extends StatelessWidget {
  const _HabitsBody({required this.habits, required this.today});

  final HabitTracker habits;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final week = WeekSummary(habits.log, today);
    final reminders = ParlaScope.of(context).reminders;
    final enabledReminders = reminders.settings.reminders.values
        .where((r) => r.enabled)
        .length;
    final waterAverage = week.waterAverage;
    final sleepAverage = week.sleepAverage;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: [
          Semantics(
            header: true,
            child: Text(l10n.habitsScreenTitle, style: text.headlineLarge),
          ),
          const SizedBox(height: 6),
          Text(l10n.habitsScreenIntro, style: text.bodyLarge),
          const SizedBox(height: 24),
          Semantics(
            header: true,
            child: Text(l10n.habitsToday, style: text.headlineSmall),
          ),
          const SizedBox(height: 12),
          HabitCard(
            key: const ValueKey('habits-water'),
            icon: ParlaIconName.drop,
            title: l10n.habitWater,
            value: l10n.habitWaterCount(habits.water, HabitTracker.waterGoal),
            background: ParlaColors.sky,
            fill: ParlaColors.waterFill,
            fraction: habits.water / HabitTracker.waterGoal,
            actions: [
              RoundIconButton(
                icon: ParlaIconName.minus,
                label: l10n.habitWaterRemove,
                background: ParlaColors.cream,
                onPressed: habits.water == 0 ? null : habits.removeWater,
              ),
              RoundIconButton(
                icon: ParlaIconName.plus,
                label: l10n.habitWaterAdd,
                onPressed: habits.water >= HabitTracker.waterGoal
                    ? null
                    : habits.addWater,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _LogRow(
            key: const ValueKey('habits-sleep'),
            icon: ParlaIconName.moon,
            background: ParlaColors.lemon,
            title: l10n.habitSleep,
            value: habits.sleepHours == null
                ? l10n.habitNoEntry
                : l10n.habitSleepHours(formatHours(habits.sleepHours!)),
            action: habits.sleepHours == null ? l10n.habitLog : l10n.habitEdit,
            onTap: () => logSleep(context, habits),
          ),
          const SizedBox(height: 12),
          _LogRow(
            key: const ValueKey('habits-move'),
            icon: ParlaIconName.move,
            background: ParlaColors.sage,
            title: l10n.habitMove,
            value: habits.moveMinutes == null
                ? l10n.habitNoEntry
                : l10n.habitMoveMinutes(habits.moveMinutes!),
            action: habits.moveMinutes == null ? l10n.habitLog : l10n.habitEdit,
            onTap: () => logMove(context, habits),
          ),
          if (reminders.supported) ...[
            const SizedBox(height: 12),
            _LogRow(
              key: const ValueKey('habits-reminders'),
              icon: ParlaIconName.sparkle,
              background: ParlaColors.white,
              title: l10n.remindersTitle,
              value: enabledReminders == 0
                  ? l10n.remindersSummaryOff
                  : l10n.remindersSummaryOn(enabledReminders),
              action: l10n.remindersOpen,
              onTap: () => context.go(Routes.reminders),
            ),
          ],
          const SizedBox(height: 32),
          Semantics(
            header: true,
            child: Text(l10n.habitsWeekTitle, style: text.headlineSmall),
          ),
          const SizedBox(height: 12),
          _WeekCard(
            key: const ValueKey('week-care'),
            title: l10n.habitsWeekCare,
            value: l10n.habitsWeekCareValue(week.careDays),
            dates: week.dates,
            fractions: [
              for (final e in week.entries) (e?.hadCare ?? false) ? 1 : 0,
            ],
            fill: ParlaColors.sunInk,
          ),
          const SizedBox(height: 12),
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
            fill: ParlaColors.waterFill,
          ),
          const SizedBox(height: 12),
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
            fill: ParlaColors.espresso,
          ),
          const SizedBox(height: 12),
          _WeekCard(
            key: const ValueKey('week-move'),
            title: l10n.habitMove,
            value: week.moveDays == 0
                ? l10n.habitsWeekNone
                : l10n.habitsWeekMoveValue(week.moveTotal, week.moveDays),
            dates: week.dates,
            fractions: _relative(week.move),
            fill: ParlaColors.moveFill,
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: ParlaIcon(ParlaIconName.check, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.habitsPrivacyNote,
                  style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
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

/// A full-width tile with a value and a log or edit action.
class _LogRow extends StatelessWidget {
  const _LogRow({
    super.key,
    required this.icon,
    required this.background,
    required this.title,
    required this.value,
    required this.action,
    required this.onTap,
  });

  final ParlaIconName icon;
  final Color background;
  final String title;
  final String value;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
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
          TextButton(
            onPressed: onTap,
            child: Text(action, semanticsLabel: '$action: $title'),
          ),
        ],
      ),
    );
  }
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
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final weekday = DateFormat.E(locale);
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Semantics(
        container: true,
        label: '$title. $value',
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: text.titleMedium),
            Text(value, style: text.bodyMedium),
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
                            color: ParlaColors.cream,
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
                          style: text.labelMedium?.copyWith(
                            fontWeight: i == dates.length - 1
                                ? FontWeight.w800
                                : FontWeight.w400,
                            color: i == dates.length - 1
                                ? ParlaColors.espresso
                                : ParlaColors.muted,
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

  /// One or two letters: enough to tell the days apart and fits at 18 px.
  static String _initial(String shortName) {
    final clean = shortName.replaceAll('.', '');
    return clean.length <= 2 ? clean : clean.substring(0, 2);
  }
}
