import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import '../ui/warm.dart';
import 'sport_book.dart';
import 'sport_labels.dart';
import 'workout_names.dart';
import 'workout_photo.dart';
import '../habits/habit_log.dart';
import 'sport_night.dart';

/// Sport: five sections as chips (owner, 2026-11-24). Fitness, pilates and
/// wall pilates ask their own questions first, then show their weekly plan;
/// yoga and face yoga are fixed sessions without questions.
class SportScreen extends StatefulWidget {
  const SportScreen({super.key, this.section});

  /// The section to open; fitness when `null` or unknown.
  final String? section;

  static const sections = [...SportOptions.sections, 'yoga', 'face_yoga'];

  @override
  State<SportScreen> createState() => _SportScreenState();
}

class _SportScreenState extends State<SportScreen> {
  bool _attached = false;
  late String _section = SportScreen.sections.contains(widget.section)
      ? widget.section!
      : 'fitness';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_attached) {
      _attached = true;
      ParlaScope.of(context).attachAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = ParlaScope.of(context).sport;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.discover),
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: book,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
            children: [
              SportHeader(
                title: l10n.sportTitle,
                onBack: () => context.go(Routes.discover),
              ),
              const SizedBox(height: 14),
              _SectionChips(
                selected: _section,
                onSelected: (s) => setState(() => _section = s),
              ),
              const SizedBox(height: 18),
              ...switch (_section) {
                'yoga' => [
                  _SectionLabel(l10n.sportTypeYoga),
                  const SizedBox(height: 10),
                  for (final w in yogaWorkouts) ...[
                    _SessionCard(
                      workout: w,
                      done: book.doneThisWeek.contains(w.id),
                      icon: ParlaIconName.moon,
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
                'face_yoga' => [
                  _SectionLabel(l10n.sportTypeFaceYoga),
                  const SizedBox(height: 10),
                  _SessionCard(
                    workout: faceYogaWorkout,
                    done: book.doneThisWeek.contains(faceYogaWorkoutId),
                    icon: ParlaIconName.sparkle,
                  ),
                ],
                final section => [
                  if (book.planOf(section) == null)
                    _Intro(section: section)
                  else
                    _PlanView(book: book, section: section),
                ],
              },
            ],
          ),
        ),
      ),
    );
  }
}

/// The five sections as capsules; the open one is white.
class _SectionChips extends StatelessWidget {
  const _SectionChips({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final id in SportScreen.sections)
          WarmChip(
            key: ValueKey('sport-section-$id'),
            label: sportTypeLabel(l10n, id),
            selected: id == selected,
            onTap: () => onSelected(id),
          ),
      ],
    );
  }
}

/// A quiet section heading above a list of rows.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: SportNight.pageSoft),
      ),
    ),
  );
}

/// The blue pebble shown before the questions.
class _Intro extends StatelessWidget {
  const _Intro({required this.section});

  final String section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BluePebble(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.sportIntroTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              letterSpacing: -.5,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.sportIntroBody,
            style: const TextStyle(fontSize: 14, height: 1.45),
          ),
          const SizedBox(height: 16),
          OrbPill(
            key: const ValueKey('sport-start'),
            label: l10n.sportStart,
            onPressed: () => context.go(Routes.sportQuiz, extra: section),
          ),
        ],
      ),
    );
  }
}

/// "Edit my answers": a glass row with a plum orb.
class _EditRow extends StatelessWidget {
  const _EditRow({required this.section});

  final String section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GlassRow(
      key: const ValueKey('sport-edit'),
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
      onTap: () => context.go(Routes.sportQuiz, extra: section),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF6CF), Color(0xFFFFCE00)],
              ),
            ),
            alignment: Alignment.center,
            child: ParlaIcon(
              ParlaIconName.sparkle,
              size: 22,
              color: SportNight.ink,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(child: RowTexts(title: l10n.sportEditAnswers)),
          ExcludeSemantics(
            child: Icon(Icons.chevron_right, color: SportNight.soft),
          ),
        ],
      ),
    );
  }
}

class _PlanView extends StatelessWidget {
  const _PlanView({required this.book, required this.section});

  final SportBook book;
  final String section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final plan = book.planOf(section)!;
    final muted = TextStyle(
      fontSize: kMinTextSize,
      height: 1.4,
      color: SportNight.pageSoft,
    );
    final footer = <Widget>[
      // Owner 2026-11-24: retaking the quiz comes after the workouts.
      const SizedBox(height: 18),
      _EditRow(section: section),
      const SizedBox(height: 14),
      Text(l10n.sportDraftNote, style: muted),
      const SizedBox(height: 6),
      Text(
        book.isSynced ? l10n.sportPrivacySynced : l10n.sportPrivacyDevice,
        style: muted,
      ),
    ];

    if (plan.blocked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassRow(
            key: const ValueKey('sport-blocked'),
            highlight: true,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sportBlockedTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: SportNight.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.sportBlockedBody,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: SportNight.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _EditRow(section: section),
        ],
      );
    }

    final month = book.monthOf(section);
    final doneCount = [
      for (final (day, w) in month)
        if (book.doneOn(w.id, day)) w,
    ].length;

    if (book.monthOver(section)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BluePebble(
            child: Column(
              key: const ValueKey('sport-month-done'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.sportMonthDoneTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: SportNight.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.sportMonthDoneBody(doneCount),
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: SportNight.ink,
                  ),
                ),
                const SizedBox(height: 16),
                OrbPill(
                  key: const ValueKey('sport-new-month'),
                  label: l10n.sportNewMonth,
                  onPressed: () => context.go(Routes.sportQuiz, extra: section),
                ),
              ],
            ),
          ),
          ...footer,
        ],
      );
    }

    final today = book.today;
    final todayWorkout = book.workoutOn(section, today);
    final next = book.nextDayOf(section);
    final index = book.todayIndexOf(section) ?? 0;
    final week = SportMonth.weekOf(index);
    String dayLabel(DateTime d) =>
        '${l10n.sportWeekday('${d.weekday}')}, ${d.day}';
    String badgeOf(Workout w, int week) =>
        '${sportTypeLabel(l10n, w.type)} · '
        '${week == 3 ? l10n.sportRecoveryWeek : l10n.sportWeekBadge(week + 1)}';
    String meta(Workout w) => l10n.sportCardMeta(w.minutes, w.items.length);

    final monday = weekStart(today);
    final thisWeek = [
      for (final (day, w) in month)
        if (!day.isBefore(monday) &&
            day.isBefore(monday.add(const Duration(days: 7))) &&
            day != today)
          (day, w),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MonthCalendar(
          book: book,
          section: section,
          today: today,
          done: doneCount,
          total: month.length,
          title: l10n.sportMonthProgress(index + 1, week + 1),
        ),
        if (plan.gentle) ...[
          const SizedBox(height: 12),
          GlassRow(
            key: const ValueKey('sport-gentle'),
            highlight: true,
            child: Text(
              l10n.sportGentleNote,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: SportNight.ink,
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        _SectionLabel(l10n.sportToday),
        const SizedBox(height: 10),
        if (todayWorkout != null)
          WorkoutPhotoCard(
            key: ValueKey('workout-${todayWorkout.id}'),
            workout: todayWorkout,
            title: workoutName(l10n, todayWorkout.id),
            subtitle: meta(todayWorkout),
            badge: badgeOf(todayWorkout, week),
            done: book.doneOn(todayWorkout.id, today),
            doneLabel: l10n.sportDone,
            onTap: () => context.go(Routes.workout, extra: todayWorkout.id),
          )
        else ...[
          GlassRow(
            key: const ValueKey('sport-rest-today'),
            child: RowTexts(
              title: l10n.sportRestToday,
              subtitle: next == null ? '' : l10n.sportNextOn(dayLabel(next.$1)),
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 10),
            WorkoutPhotoCard(
              key: ValueKey('workout-${next.$2.id}'),
              workout: next.$2,
              title: workoutName(l10n, next.$2.id),
              subtitle: meta(next.$2),
              badge: dayLabel(next.$1),
              onTap: () => context.go(Routes.workout, extra: next.$2.id),
            ),
          ],
        ],
        if (thisWeek.isNotEmpty) ...[
          const SizedBox(height: 20),
          _SectionLabel(l10n.sportWeekTitle),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: thisWeek.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final (day, w) = thisWeek[i];
                return WorkoutPhotoCard(
                  key: ValueKey('workout-${w.id}-${SportMonth.keyOf(day)}'),
                  workout: w,
                  width: 160,
                  height: 160,
                  titleSize: 15,
                  title: workoutName(l10n, w.id),
                  subtitle: meta(w),
                  badge: dayLabel(day),
                  done: book.doneOn(w.id, day),
                  doneLabel: l10n.sportDone,
                  onTap: () => context.go(Routes.workout, extra: w.id),
                );
              },
            ),
          ),
        ],
        ...footer,
      ],
    );
  }
}

/// The month at a glance: four weeks from the plan's start, workouts in
/// coral, finished ones white, rest days faint, today ringed.
class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.book,
    required this.section,
    required this.today,
    required this.done,
    required this.total,
    required this.title,
  });

  final SportBook book;
  final String section;
  final DateTime today;
  final int done;
  final int total;
  final String title;

  static const coral = Color(0xFFFFCE00);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final start = book.startOf(section)!;
    final first = weekStart(start);
    final last = start.add(const Duration(days: SportMonth.days - 1));
    final rows = <List<DateTime>>[];
    for (var d = first; !d.isAfter(last); d = d.add(const Duration(days: 7))) {
      rows.add([
        for (var i = 0; i < 7; i++) DateTime(d.year, d.month, d.day + i),
      ]);
    }

    Widget cell(DateTime d) {
      final inMonth = SportMonth.indexOf(start, d) != null;
      final w = inMonth ? book.workoutOn(section, d) : null;
      final finished = w != null && book.doneOn(w.id, d);
      final missed = w != null && !finished && d.isBefore(today);
      final isToday = d == today;
      final (Color? fill, Color text, BoxBorder? border) = switch (()) {
        _ when finished => (Warm.black, Warm.onBlack, null),
        _ when missed => (
          null,
          Warm.ink,
          Border.all(color: const Color(0xFFE0A800), width: 2),
        ),
        _ when w != null => (coral, Warm.ink, null),
        _ => (
          null,
          Warm.ink.withValues(alpha: inMonth ? 0.55 : 0.25),
          null,
        ),
      };
      return Center(
        child: Container(
          width: 36,
          height: 36,
          padding: const EdgeInsets.all(2),
          decoration: isToday
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Warm.ink, width: 2),
                )
              : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              border: border,
            ),
            child: Text(
              '${d.day}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: w != null ? FontWeight.w600 : FontWeight.w400,
                color: text,
              ),
            ),
          ),
        ),
      );
    }

    Widget legend(Color color, String label, {bool ring = false}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: ring ? null : color,
            shape: BoxShape.circle,
            border: ring ? Border.all(color: color, width: 1.5) : null,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: SportNight.soft),
        ),
      ],
    );

    return BluePebble(
      child: Semantics(
        key: const ValueKey('sport-month'),
        label:
            '${l10n.sportMonthTitle}. $title. '
            '${l10n.sportMonthCalendar(done, total - done)}',
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Eyebrow(l10n.sportMonthTitle),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: SportNight.ink,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var d = 1; d <= 7; d++)
                  Expanded(
                    child: Text(
                      l10n.sportWeekday('$d'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: SportNight.soft,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            for (final row in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [for (final d in row) Expanded(child: cell(d))],
                ),
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                legend(Warm.black, l10n.sportLegendDone),
                legend(coral, l10n.sportLegendWorkout),
                legend(
                  Warm.ink.withValues(alpha: 0.5),
                  l10n.sportLegendRest,
                  ring: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A fixed session (face yoga, yoga), open to everyone without the
/// questions.
class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.workout,
    required this.done,
    required this.icon,
  });

  final Workout workout;
  final bool done;
  final ParlaIconName icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final faceYoga = workout.id == faceYogaWorkoutId;
    return WorkoutPhotoCard(
      key: ValueKey(faceYoga ? 'face-yoga' : 'session-${workout.id}'),
      workout: workout,
      height: 180,
      title: sessionTitle(l10n, workout.id),
      subtitle: faceYoga
          ? l10n.sportFaceYogaCardBody(workout.minutes)
          : l10n.sportSessionCardBody(workout.items.length, workout.minutes),
      done: done,
      doneLabel: l10n.sportDone,
      onTap: () => context.go(Routes.workout, extra: workout.id),
    );
  }
}
