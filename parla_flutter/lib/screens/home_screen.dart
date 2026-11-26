import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parla_shared/parla_shared.dart';

import '../consent/consent_refresh.dart';
import '../discover/banner_strip.dart';
import '../habits/habit_log.dart';
import '../habits/habit_sheets.dart';
import '../habits/habit_tracker.dart';
import '../home/widgets/pregnancy_recheck_card.dart';
import '../home/home_controller.dart';
import '../home/routine.dart';
import '../home/widgets/home_cards.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../routines/routine_section.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import '../ui/parla_mark.dart';
import '../ui/warm.dart';

/// M-14 "Bu gün" (design A+): a lemon header with the greeting and the
/// routine switch, then a cream sheet with the Smile Meter summary, the
/// face routine steps, the other routines due today and today's habits.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController? _controller;

  /// The quiz answers, `null` until loaded or when the quiz was not taken.
  QuizAnswers? _answers;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final scope = ParlaScope.of(context);
      _controller = HomeController(now: scope.clock(), habits: scope.habits);
      scope.attachAccount();
      _loadAnswers();
    }
  }

  Future<void> _loadAnswers() async {
    QuizAnswers? answers;
    try {
      answers = await ParlaScope.of(context).api.myQuizAnswers();
    } on Object {
      answers = null; // The default routine still works offline.
    }
    if (!mounted) return;
    setState(() {
      _answers = answers;
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.today),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          controller,
          ParlaScope.of(context).routines,
        ]),
        builder: (context, _) => _HomeBody(
          controller: controller,
          answers: _answers,
          plan: _answers == null ? defaultRoutinePlan : planRoutine(_answers!),
          showQuizPrompt: _loaded && _answers == null,
          onQuiz: () => context.go(Routes.quiz),
          onAnswersSaved: _loadAnswers,
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.controller,
    required this.answers,
    required this.plan,
    required this.showQuizPrompt,
    required this.onQuiz,
    required this.onAnswersSaved,
  });

  final HomeController controller;
  final QuizAnswers? answers;
  final RoutinePlan plan;
  final bool showQuizPrompt;
  final VoidCallback onQuiz;
  final VoidCallback onAnswersSaved;

  @override
  Widget build(BuildContext context) {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final now = scope.clock();
    final language = scope.settings.language ?? defaultLanguage;

    final kind = controller.kind;
    final habits = controller.habits;
    final morning = kind == RoutineKind.morning;
    final progress = RoutineProgress(
      routineSteps(morning ? plan.morning : plan.evening, language),
      controller,
    );
    final routineName = morning
        ? l10n.routineMorningTitle
        : l10n.routineEveningTitle;
    final greeting = now.hour >= 5 && now.hour < 12
        ? l10n.homeGreetingMorning
        : now.hour >= 12 && now.hour < 18
        ? l10n.homeGreetingAfternoon
        : l10n.homeGreetingEvening;
    final left = progress.total - progress.doneCount;
    final status = progress.allDone
        ? l10n.routineStatusDone
        : progress.doneCount == 0
        ? l10n.routineStatusStart
        : l10n.routineStatusLeft(left);

    final nextStep = [
      for (var i = 0; i < progress.total; i++)
        if (!progress.done[i]) progress.steps[i],
    ].firstOrNull;

    // Warm day design (prototype "Fon B isti · Bu gün"): date and a thin
    // greeting, the week's movement as a smoky glass card with a curve,
    // water (lime) and the routine (rose) as rounded cards, then evening
    // yoga and sleep as capsules; below, the routine switch, the steps
    // and the other routines due today.
    final monday = weekStart(now);
    final week = [
      for (var i = 0; i < 7; i++)
        habits.log.peek(monday.add(Duration(days: i)))?.moveMinutes ?? 0,
    ];
    final eveningYoga = yogaWorkouts.firstWhere((w) => w.id == 'yoga_evening');
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: WarmHeader(
                above: MaterialLocalizations.of(context).formatFullDate(now),
                title: greeting,
                trailing: const _MessagesButton(),
              ),
            ),
            const SizedBox(height: 14),
            // A renewed consent is asked for first (it shows only then).
            const ConsentRefreshCard(),
            _FocusCard(
              key: const ValueKey('home-focus'),
              routineName: routineName,
              step: nextStep,
              done: progress.done,
              onOpen: () => context.go(Routes.habits),
            ),
            const SizedBox(height: 18),
            _SectionTitle(l10n.homePulse),
            const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _WaterCard(
                      count: controller.water,
                      goal: HomeController.waterGoal,
                      onAdd: controller.water >= HomeController.waterGoal
                          ? null
                          : controller.addWater,
                      onRemove: controller.water == 0
                          ? null
                          : controller.removeWater,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _RoutineCard(
                      title: routineName,
                      caption: progress.allDone
                          ? status
                          : l10n.routineMinutesLeft(progress.minutesLeft),
                      doneCount: progress.doneCount,
                      total: progress.total,
                      semanticLabel: l10n.routineProgressLabel(
                        routineName,
                        progress.doneCount,
                        progress.total,
                      ),
                      next: nextStep?.title ?? l10n.navRoutine,
                      onOpen: () => context.go(Routes.habits),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _MoveWeekCard(
              key: const ValueKey('habit-move'),
              week: week,
              todayIndex: now.weekday - 1,
              today: habits.moveMinutes,
              onLog: () => logMove(context, habits),
            ),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: StatPill(
                      key: const ValueKey('home-evening-yoga'),
                      title: l10n.sportYogaEvening,
                      value: '${eveningYoga.minutes}',
                      badge: l10n.sportTypeYoga,
                      icon: ParlaIconName.moon,
                      tint: SmokyTint.burnt,
                      height: 104,
                      onTap: () =>
                          context.go(Routes.workout, extra: eveningYoga.id),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SleepPill(
                      key: const ValueKey('habit-sleep'),
                      title: l10n.habitSleep,
                      value: habits.sleepHours == null
                          ? l10n.habitNoEntry
                          : l10n.habitSleepHours(
                              formatHours(habits.sleepHours!),
                            ),
                      actionLabel: habits.sleepHours == null
                          ? l10n.habitLog
                          : l10n.habitEdit,
                      onAction: () => logSleep(context, habits),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Semantics(
              container: true,
              label: l10n.routineSwitchLabel,
              child: WarmSegmented<RoutineKind>(
                values: RoutineKind.values,
                labelOf: (k) => k == RoutineKind.morning
                    ? l10n.routineMorning
                    : l10n.routineEvening,
                selected: kind,
                onChanged: controller.selectKind,
                keyOf: (k) => ValueKey('segment-$k'),
              ),
            ),
            const SizedBox(height: 12),
            PregnancyRecheckCards(
              answers: answers,
              onSkinSaved: onAnswersSaved,
            ),
            if (showQuizPrompt) ...[
              _QuizPromptCard(onStart: onQuiz),
              const SizedBox(height: 12),
            ],
            if (progress.allDone) ...[
              RoutineDoneCard(
                routineName: routineName,
                onRestart: controller.restart,
              ),
              const SizedBox(height: 12),
            ],
            const BannerStrip(placement: 'today'),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        routineName,
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Warm.ink,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${progress.doneCount} / ${progress.total}',
                    style: text.labelMedium?.copyWith(color: Warm.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (progress.total > 0)
              StepList(
                steps: progress.steps,
                rowKey: (s) => ValueKey('step-${s.id}'),
                isDone: (i) => progress.done[i],
                onToggle: (i) => controller.toggle(progress.steps[i].id),
              ),
            const SizedBox(height: 18),
            _TodayRoutines(
              answers: answers,
              kind: kind,
              habits: habits,
              today: now,
            ),
          ],
        ),
      ),
    );
  }
}

/// The week's movement (prototype's big smoky card): today's minutes under
/// the title, a white capsule to log or edit, the curve of this week's
/// logged minutes, the days with today in white, and the week's total.
class _MoveWeekCard extends StatelessWidget {
  const _MoveWeekCard({
    super.key,
    required this.week,
    required this.todayIndex,
    required this.today,
    required this.onLog,
  });

  /// Logged minutes from Monday to Sunday (0 where nothing is logged).
  final List<int> week;
  final int todayIndex;

  /// Today's minutes, or `null` when nothing is logged.
  final int? today;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Short day names from Monday (Material's narrow names are digits in
    // Azerbaijani). 2024-01-01 was a Monday.
    final locale = Localizations.localeOf(context).toString();
    final days = [
      for (var i = 0; i < 7; i++)
        DateFormat.E(
          locale,
        ).format(DateTime(2024, 1, 1 + i)).replaceAll('.', ''),
    ];
    final total = week.fold<int>(0, (a, b) => a + b);
    final logged = week.where((m) => m > 0).length;
    return SmokyGlass(
      radius: 44,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.habitMove,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      today == null
                          ? l10n.habitNoEntry
                          : l10n.habitMoveMinutes(today!),
                      style: TextStyle(
                        fontSize: kMinTextSize,
                        color: Warm.onCardSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _WhitePill(
                label: today == null ? l10n.habitLog : l10n.habitEdit,
                onPressed: onLog,
              ),
            ],
          ),
          const SizedBox(height: 6),
          WeekCurve(
            values: [for (final m in week) m.toDouble()],
            selected: todayIndex,
          ),
          const SizedBox(height: 10),
          _Days(labels: days, selected: todayIndex),
          const SizedBox(height: 12),
          Text(
            '${l10n.sportWeekTitle} · ${l10n.habitsWeekMoveValue(total, logged)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Warm.onCardSoft),
          ),
        ],
      ),
    );
  }
}

/// The seven days as outlined circles; today is white. Labels stay at
/// the minimum text size.
class _Days extends StatelessWidget {
  const _Days({required this.labels, required this.selected});

  final List<String> labels;
  final int selected;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < labels.length; i++)
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == selected ? Colors.white : null,
              border: i == selected
                  ? null
                  : Border.all(color: const Color(0x59FFFFFF)),
            ),
            child: Text(
              labels[i],
              maxLines: 1,
              style: TextStyle(
                fontSize: kMinTextSize,
                color: i == selected ? Warm.dayInk : Warm.onCard,
              ),
            ),
          ),
      ],
    ),
  );
}

/// Water as the lime rounded card: − and + at the top, the count in large
/// figures and a dot meter filling with each glass.
class _WaterCard extends StatelessWidget {
  const _WaterCard({
    required this.count,
    required this.goal,
    required this.onAdd,
    required this.onRemove,
  });

  final int count;
  final int goal;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SquircleCard(
      key: const ValueKey('habit-water'),
      tone: SquircleTone.lime,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 154),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const RingIcon(icon: ParlaIconName.drop),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.habitWater,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _RoundButton(
                  icon: ParlaIconName.minus,
                  label: l10n.habitWaterRemove,
                  onPressed: onRemove,
                  outlined: true,
                ),
                const Spacer(),
                _RoundButton(
                  icon: ParlaIconName.plus,
                  label: l10n.habitWaterAdd,
                  onPressed: onAdd,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Semantics(
              container: true,
              liveRegion: true,
              label: l10n.habitWaterCount(count, goal),
              excludeSemantics: true,
              child: Text.rich(
                TextSpan(
                  text: '$count',
                  children: [
                    TextSpan(
                      text: '/$goal',
                      style: TextStyle(color: Warm.onCardSoft),
                    ),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: DotsMeter(fraction: goal == 0 ? 0 : count / goal),
            ),
          ],
        ),
      ),
    );
  }
}

/// The routine as the rose rounded card: name and time left, a black
/// arrow to the Routine tab, done / total in large figures, a tick meter
/// and the next step.
class _RoutineCard extends StatelessWidget {
  const _RoutineCard({
    required this.title,
    required this.caption,
    required this.doneCount,
    required this.total,
    required this.semanticLabel,
    required this.next,
    required this.onOpen,
  });

  final String title;
  final String caption;
  final int doneCount;
  final int total;
  final String semanticLabel;
  final String next;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SquircleCard(
      key: const ValueKey('routine-hero'),
      tone: SquircleTone.rose,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 154),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RingIcon(icon: ParlaIconName.sparkle),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                        ),
                      ),
                      Text(
                        caption,
                        style: TextStyle(
                          fontSize: kMinTextSize,
                          color: Warm.onCardSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Semantics(
                    container: true,
                    label: semanticLabel,
                    excludeSemantics: true,
                    child: Text(
                      '$doneCount/$total',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                BlackCircleButton(
                  icon: ParlaIconName.arrowRight,
                  onPressed: onOpen,
                  label: '$title: $next',
                  size: 38,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: TicksMeter(fraction: total == 0 ? 0 : doneCount / total),
            ),
            Row(
              children: [
                Text(
                  l10n.sportNextLabel,
                  style: TextStyle(
                    fontSize: kMinTextSize,
                    color: Warm.onCardSoft,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    next,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: kMinTextSize),
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

/// A 44 px round button on a card: black, or outlined white.
class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.outlined = false,
  });

  final ParlaIconName icon;
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: outlined ? Colors.transparent : Warm.black,
        shape: CircleBorder(
          side: outlined
              ? BorderSide(color: Warm.ring, width: 1.2)
              : BorderSide.none,
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: ParlaIcon(
                icon,
                size: 18,
                strokeWidth: 2.5,
                color: !outlined
                    ? Warm.onBlack
                    : enabled
                    ? Warm.ink
                    : Warm.ring,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Sleep as a smoky capsule: last night's hours and a white capsule to log
/// or edit; the glowing round mark of the prototype's "add" capsule.
class _SleepPill extends StatelessWidget {
  const _SleepPill({
    super.key,
    required this.title,
    required this.value,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String value;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 104),
    // Same shape as the card beside it; the add button is small and sits
    // by the title so the value has the full width.
    child: SmokyGlass(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      onTap: onAction,
      padding: const EdgeInsets.fromLTRB(18, 12, 12, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              ExcludeSemantics(
                child: GlowPlusButton(
                  onPressed: onAction,
                  label: title,
                  size: 36,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              height: 1.25,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          OutlineBadge(actionLabel),
        ],
      ),
    ),
  );
}

/// A white capsule with dark text (log / edit on a card).
class _WhitePill extends StatelessWidget {
  const _WhitePill({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: const StadiumBorder(),
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44, minWidth: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Warm.dayInk,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Shown until the quiz is taken: the routine is generic until then.
class _QuizPromptCard extends StatelessWidget {
  const _QuizPromptCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return SmokyGlass(
      tint: SmokyTint.coral,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.homeQuizTitle,
            style: text.titleLarge?.copyWith(color: Warm.onCard),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.homeQuizBody,
            style: text.bodyMedium?.copyWith(color: Warm.onCardSoft),
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: const ValueKey('home-quiz-start'),
            style: FilledButton.styleFrom(
              backgroundColor: Warm.black,
              foregroundColor: Warm.onBlack,
            ),
            onPressed: onStart,
            child: Text(l10n.homeQuizStart),
          ),
        ],
      ),
    );
  }
}

/// The other routines due today, after the face steps: hair and body for
/// this part of the day, weekly steps still open this week and the user's
/// own routines for today. Each row opens the Routine tab.
class _TodayRoutines extends StatelessWidget {
  const _TodayRoutines({
    required this.answers,
    required this.kind,
    required this.habits,
    required this.today,
  });

  final QuizAnswers? answers;
  final RoutineKind kind;
  final HabitTracker habits;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final book = ParlaScope.of(context).routines;
    final daySlot = kind == RoutineKind.morning
        ? RoutineSlot.morning
        : RoutineSlot.evening;
    final rows = <_RowData>[];
    for (final area in [RoutineArea.hair, RoutineArea.body]) {
      final plan = planArea(area, answers);
      for (final slot in [daySlot, RoutineSlot.weekly]) {
        final ids = plan.slot(slot);
        if (ids.isEmpty) continue;
        final done = ids.where((id) => habits.isDoneIn(slot, id)).length;
        // A finished weekly slot waits for next week.
        if (slot == RoutineSlot.weekly && done == ids.length) continue;
        rows.add(
          _RowData(
            key: 'today-${area.name}-${slot.name}',
            route: '${Routes.habits}?area=${area.name}&slot=${slot.name}',
            title: '${areaLabel(l10n, area)} · ${slotLabel(l10n, slot)}',
            steps: ids.length,
            done: done,
            tile: area == RoutineArea.hair
                ? const Color(0xFF61731A)
                : const Color(0xFFA6664F),
          ),
        );
      }
    }
    for (final routine in book.routines.where((r) => r.isDueOn(today))) {
      rows.add(
        _RowData(
          key: 'today-own-${routine.id}',
          route: '${Routes.habits}?area=${routine.area.name}',
          title: routine.name,
          steps: routine.steps.length,
          done: routine.steps.where((s) => book.isTicked(s.id)).length,
          tile: const Color(0xFFB8622A),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  l10n.todayRoutinesTitle,
                  style: text.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: Warm.ink,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.go(Routes.habits),
              child: Text(
                l10n.todayRoutinesAll,
                semanticsLabel:
                    '${l10n.todayRoutinesAll}: '
                    '${l10n.todayRoutinesTitle}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (rows.isEmpty)
          Text(
            l10n.todayRoutinesNone,
            style: text.bodyMedium?.copyWith(color: Warm.muted),
          ),
        for (final row in rows) ...[
          SmokyGlass(
            key: ValueKey(row.key),
            shape: const StadiumBorder(),
            shadow: false,
            onTap: () => context.go(row.route),
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: row.tile,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const ParlaIcon(
                    ParlaIconName.sparkle,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(row.title, style: const TextStyle(fontSize: 15)),
                      Text(
                        l10n.routineOwnSteps(row.steps),
                        style: TextStyle(
                          fontSize: kMinTextSize,
                          color: Warm.onCardSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                OutlineBadge('${row.done}/${row.steps}'),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _RowData {
  const _RowData({
    required this.key,
    required this.route,
    required this.title,
    required this.steps,
    required this.done,
    required this.tile,
  });

  final String key;

  /// The Routine tab on this routine's area (and slot).
  final String route;
  final String title;
  final int steps;
  final int done;
  final Color tile;
}

/// Opens Messages; a dot shows when the team replied to the user.
class _MessagesButton extends StatefulWidget {
  const _MessagesButton();

  @override
  State<_MessagesButton> createState() => _MessagesButtonState();
}

class _MessagesButtonState extends State<_MessagesButton> {
  bool _unread = false;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    ParlaScope.of(context).api.hasUnreadSupportReply().then(
      (v) {
        if (mounted) setState(() => _unread = v);
      },
      onError: (Object _) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Semantics(
          button: true,
          label: _unread ? l10n.messagesButtonUnread : l10n.messagesButton,
          excludeSemantics: true,
          child: SizedBox(
            key: const ValueKey('home-messages'),
            width: 44,
            height: 44,
            child: SmokyGlass(
              shape: const CircleBorder(),
              milk: true,
              onTap: () => context.go(Routes.messages),
              child: Center(
                child: ParlaIcon(ParlaIconName.bell, size: 20, color: Warm.ink),
              ),
            ),
          ),
        ),
        if (_unread)
          const Positioned(
            right: 2,
            top: 2,
            child: CircleAvatar(
              key: ValueKey('home-messages-dot'),
              radius: 5,
              backgroundColor: Color(0xFFF0823C),
            ),
          ),
      ],
    );
  }
}

/// A quiet section title on the page ("Qısa nəbz").
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Warm.ink,
        ),
      ),
    ),
  );
}

/// "Günün fokusu" ("İşıq" design): the Parla mark, the routine's next
/// step and how to do it, a bar of today's steps (done in banana), and a
/// dark capsule to open the routine. When every step is done it says so.
class _FocusCard extends StatelessWidget {
  const _FocusCard({
    super.key,
    required this.routineName,
    required this.step,
    required this.done,
    required this.onOpen,
  });

  final String routineName;
  final RoutineStep? step;
  final List<bool> done;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final doneCount = done.where((d) => d).length;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF6CF), Color(0xFFFCE1EC)],
          stops: [0, .6, 1],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: const ParlaMark(size: 26),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeFocusTitle,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Warm.dayInk,
                        ),
                      ),
                      Text(
                        '${l10n.homeFocusSub} · $routineName',
                        style: TextStyle(
                          fontSize: kMinTextSize,
                          color: Warm.dayMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              step?.title ?? l10n.homeFocusDone,
              style: TextStyle(
                fontSize: 20,
                height: 1.2,
                fontWeight: FontWeight.w500,
                color: Warm.dayInk,
              ),
            ),
            if (step != null) ...[
              const SizedBox(height: 4),
              Text(
                step!.meta,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Warm.dayMuted,
                ),
              ),
            ],
            if (done.isNotEmpty) ...[
              const SizedBox(height: 14),
              ExcludeSemantics(
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      for (var i = 0; i < done.length; i++) ...[
                        if (i > 0) const SizedBox(width: 4),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: done[i]
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Warm.banana, Warm.bananaSoft],
                                    )
                                  : null,
                              color: done[i] ? null : const Color(0xFFE7E1DA),
                            ),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.homeFocusSteps(doneCount, done.length),
                style: TextStyle(
                  fontSize: kMinTextSize,
                  color: Warm.dayMuted,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                key: const ValueKey('home-focus-open'),
                style: FilledButton.styleFrom(
                  backgroundColor: Warm.dayInk,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(48, 48),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: onOpen,
                child: Text(l10n.homeFocusOpen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
