import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../consent/consent_refresh.dart';
import '../habits/habit_sheets.dart';
import '../habits/habit_tracker.dart';
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
      backgroundColor: ParlaColors.cream,
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
  });

  final HomeController controller;
  final QuizAnswers? answers;
  final RoutinePlan plan;
  final bool showQuizPrompt;
  final VoidCallback onQuiz;

  @override
  Widget build(BuildContext context) {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context);
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

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Lemon header (brand: Lemon surface, espresso text).
        ColoredBox(
          color: ParlaColors.lemon,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const _Wordmark(),
                      const Spacer(),
                      RoundIconButton(
                        icon: ParlaIconName.profile,
                        label: l10n.homeProfileButton,
                        onPressed: () => context.go(Routes.privacy),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    MaterialLocalizations.of(context).formatFullDate(now),
                    style: text.labelMedium?.copyWith(
                      color: ParlaColors.sunInk,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    header: true,
                    child: Text(greeting, style: text.headlineLarge),
                  ),
                  const SizedBox(height: 2),
                  Text(l10n.homeTagline, style: accentStyle(locale)),
                  const SizedBox(height: 14),
                  RoutineSwitch(kind: kind, onChanged: controller.selectKind),
                ],
              ),
            ),
          ),
        ),

        // Cream sheet rising over the lemon with rounded top corners.
        Transform.translate(
          offset: const Offset(0, -36),
          child: Container(
            decoration: const BoxDecoration(
              color: ParlaColors.cream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ConsentRefreshCard(),
                if (showQuizPrompt) ...[
                  _QuizPromptCard(onStart: onQuiz),
                  const SizedBox(height: 16),
                ],
                RoutineSummaryCard(
                  eyebrow: morning
                      ? l10n.routineMorningEyebrow
                      : l10n.routineEveningEyebrow,
                  status: status,
                  caption: progress.allDone
                      ? null
                      : l10n.routineMinutesLeft(progress.minutesLeft),
                  doneCount: progress.doneCount,
                  total: progress.total,
                  semanticLabel: l10n.routineProgressLabel(
                    routineName,
                    progress.doneCount,
                    progress.total,
                  ),
                ),
                if (progress.allDone) ...[
                  const SizedBox(height: 16),
                  RoutineDoneCard(
                    routineName: routineName,
                    onRestart: controller.restart,
                  ),
                ],
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(routineName, style: text.headlineSmall),
                      ),
                    ),
                    Text(
                      '${progress.doneCount} / ${progress.total}',
                      style: text.labelMedium?.copyWith(
                        color: ParlaColors.sunInk,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < progress.total; i++) ...[
                  StepTile(
                    key: ValueKey('step-${progress.steps[i].id}'),
                    step: progress.steps[i],
                    number: i + 1,
                    done: progress.done[i],
                    onToggle: () => controller.toggle(progress.steps[i].id),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 14),
                _TodayRoutines(
                  answers: answers,
                  kind: kind,
                  habits: habits,
                  today: now,
                ),
                const SizedBox(height: 22),
                Semantics(
                  header: true,
                  child: Text(l10n.habitsTitle, style: text.headlineSmall),
                ),
                const SizedBox(height: 12),
                HabitCard(
                  key: const ValueKey('habit-water'),
                  icon: ParlaIconName.drop,
                  title: l10n.habitWater,
                  value: l10n.habitWaterCount(
                    controller.water,
                    HomeController.waterGoal,
                  ),
                  background: ParlaColors.sky,
                  fill: ParlaColors.waterFill,
                  fraction: controller.water / HomeController.waterGoal,
                  actions: [
                    RoundIconButton(
                      icon: ParlaIconName.minus,
                      label: l10n.habitWaterRemove,
                      background: ParlaColors.cream,
                      onPressed: controller.water == 0
                          ? null
                          : controller.removeWater,
                    ),
                    RoundIconButton(
                      icon: ParlaIconName.plus,
                      label: l10n.habitWaterAdd,
                      onPressed: controller.water >= HomeController.waterGoal
                          ? null
                          : controller.addWater,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SmallHabitTile(
                        key: const ValueKey('habit-sleep'),
                        icon: ParlaIconName.moon,
                        title: l10n.habitSleep,
                        value: habits.sleepHours == null
                            ? l10n.habitNoEntry
                            : l10n.habitSleepHours(
                                formatHours(habits.sleepHours!),
                              ),
                        background: ParlaColors.lemon,
                        actionLabel: habits.sleepHours == null
                            ? l10n.habitLog
                            : l10n.habitEdit,
                        onAction: () => logSleep(context, habits),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SmallHabitTile(
                        key: const ValueKey('habit-move'),
                        icon: ParlaIconName.move,
                        title: l10n.habitMove,
                        value: habits.moveMinutes == null
                            ? l10n.habitNoEntry
                            : l10n.habitMoveMinutes(habits.moveMinutes!),
                        background: ParlaColors.sage,
                        actionLabel: habits.moveMinutes == null
                            ? l10n.habitLog
                            : l10n.habitEdit,
                        onAction: () => logMove(context, habits),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Parla',
    excludeSemantics: true,
    child: SizedBox(
      width: 84,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'parla',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1,
              color: ParlaColors.espresso,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 2),
            child: CustomPaint(
              size: const Size(40, 10),
              painter: _WordmarkSmile(),
            ),
          ),
        ],
      ),
    ),
  );
}

class _WordmarkSmile extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.025, h * 0.1)
      ..quadraticBezierTo(w / 2, h * 1.4, w * 0.975, h * 0.1)
      ..quadraticBezierTo(w / 2, h * 0.9, w * 0.025, h * 0.1)
      ..close();
    canvas.drawPath(path, Paint()..color = ParlaColors.espresso);
  }

  @override
  bool shouldRepaint(_WordmarkSmile oldDelegate) => false;
}

/// Shown until the quiz is taken: the routine is generic until then.
class _QuizPromptCard extends StatelessWidget {
  const _QuizPromptCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ParlaColors.sky,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.homeQuizTitle, style: text.titleLarge),
          const SizedBox(height: 6),
          Text(l10n.homeQuizBody, style: text.bodyMedium),
          const SizedBox(height: 16),
          FilledButton(onPressed: onStart, child: Text(l10n.homeQuizStart)),
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
            title: '${areaLabel(l10n, area)} · ${slotLabel(l10n, slot)}',
            steps: ids.length,
            done: done,
            tile: area == RoutineArea.hair
                ? ParlaColors.lilac
                : ParlaColors.sky,
          ),
        );
      }
    }
    for (final routine in book.routines.where((r) => r.isDueOn(today))) {
      rows.add(
        _RowData(
          key: 'today-own-${routine.id}',
          title: routine.name,
          steps: routine.steps.length,
          done: routine.steps.where((s) => book.isTicked(s.id)).length,
          tile: ParlaColors.blush,
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
                child: Text(l10n.todayRoutinesTitle, style: text.headlineSmall),
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
            style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
          ),
        for (final row in rows) ...[
          Material(
            key: ValueKey(row.key),
            color: ParlaColors.white,
            borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
            child: InkWell(
              borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
              onTap: () => context.go(Routes.habits),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: row.tile,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const ParlaIcon(ParlaIconName.sparkle, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(row.title, style: text.titleMedium),
                          Text(
                            l10n.routineOwnSteps(row.steps),
                            style: text.bodySmall?.copyWith(
                              color: ParlaColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${row.done}/${row.steps}',
                      style: text.labelMedium?.copyWith(
                        color: ParlaColors.sunInk,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _RowData {
  const _RowData({
    required this.key,
    required this.title,
    required this.steps,
    required this.done,
    required this.tile,
  });

  final String key;
  final String title;
  final int steps;
  final int done;
  final Color tile;
}
