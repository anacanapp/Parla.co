import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../consent/consent_refresh.dart';
import '../discover/banner_strip.dart';
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
import '../ui/night.dart';

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

    // One scrolling column, so the hero stays built (and its progress
    // readable by screen readers) while the steps below are scrolled.
    // Night design 3.0 (prototype "Gecə · Bu gün"): wordmark, date and a
    // thin greeting, the routine as a pink mesh tile, water and movement
    // tiles, sleep as a wide orange tile, then the steps and routines.
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [_Wordmark(), Spacer(), _MessagesButton()],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatFullDate(now),
                    style: text.bodySmall?.copyWith(color: ParlaColors.muted),
                  ),
                  const SizedBox(height: 2),
                  Semantics(
                    header: true,
                    child: Text(greeting, style: text.displayLarge),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _RoutineHero(
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
            const SizedBox(height: 12),
            _KindSwitch(
              selected: kind,
              onChanged: controller.selectKind,
              semanticLabel: l10n.routineSwitchLabel,
              labels: {
                RoutineKind.morning: l10n.routineMorning,
                RoutineKind.evening: l10n.routineEvening,
              },
            ),
            const SizedBox(height: 12),
            const ConsentRefreshCard(),
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
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _WaterTile(
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
                    child: _MoveTile(
                      key: const ValueKey('habit-move'),
                      title: l10n.habitMove,
                      value: habits.moveMinutes == null
                          ? null
                          : l10n.habitMoveMinutes(habits.moveMinutes!),
                      empty: l10n.habitNoEntry,
                      actionLabel: habits.moveMinutes == null
                          ? l10n.habitLog
                          : l10n.habitEdit,
                      onAction: () => logMove(context, habits),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SleepTile(
              key: const ValueKey('habit-sleep'),
              title: l10n.habitSleep,
              value: habits.sleepHours == null
                  ? l10n.habitNoEntry
                  : l10n.habitSleepHours(formatHours(habits.sleepHours!)),
              actionLabel: habits.sleepHours == null
                  ? l10n.habitLog
                  : l10n.habitEdit,
              onAction: () => logSleep(context, habits),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(routineName, style: text.titleLarge),
                    ),
                  ),
                  Text(
                    '${progress.doneCount} / ${progress.total}',
                    style: text.labelMedium?.copyWith(
                      color: ParlaColors.muted,
                    ),
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

/// The routine as the prototype's pink mesh tile: name and time left, the
/// dashed tick ring, and the slide pill with the next step (opens the
/// Routine tab).
class _RoutineHero extends StatelessWidget {
  const _RoutineHero({
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
    const tone = MeshTone.pink;
    return MeshTile(
      key: const ValueKey('routine-hero'),
      tone: tone,
      radius: 38,
      padding: const EdgeInsets.all(18),
      // The dark glow sits behind the ring, so its light number reads.
      blobAt: const Alignment(0.62, -0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: tone.ink,
                      ),
                    ),
                    Text(
                      caption,
                      style: TextStyle(
                        fontSize: kMinTextSize,
                        color: tone.ink.withValues(alpha: .8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                container: true,
                child: TickRing(
                  fraction: total == 0 ? 0 : doneCount / total,
                  label: '$doneCount/$total',
                  semanticLabel: semanticLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SlidePill(label: next, onPressed: onOpen),
        ],
      ),
    );
  }
}

/// Morning / evening as a glass capsule; the open one is light.
class _KindSwitch extends StatelessWidget {
  const _KindSwitch({
    required this.selected,
    required this.onChanged,
    required this.semanticLabel,
    required this.labels,
  });

  final RoutineKind selected;
  final ValueChanged<RoutineKind> onChanged;
  final String semanticLabel;
  final Map<RoutineKind, String> labels;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: semanticLabel,
    child: LiquidGlass(
      padding: const EdgeInsets.all(5),
      shadow: false,
      child: Row(
        children: [
          for (final kind in RoutineKind.values)
            Expanded(
              child: Semantics(
                button: true,
                selected: kind == selected,
                child: GestureDetector(
                  key: ValueKey('segment-$kind'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(kind),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    constraints: const BoxConstraints(minHeight: 44),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: ShapeDecoration(
                      color: kind == selected
                          ? ParlaColors.espresso
                          : Colors.transparent,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      labels[kind]!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: kind == selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: kind == selected ? _ink : ParlaColors.espresso,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

/// Dark ink on the light capsules of the night design.
const _ink = Color(0xFF1A0B2A);

/// Water as the prototype's blue tile: a tick scale with the lime marker
/// at today's count, the count in thin large figures, and − / + buttons.
class _WaterTile extends StatelessWidget {
  const _WaterTile({
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
    const tone = MeshTone.blue;
    return MeshTile(
      key: const ValueKey('habit-water'),
      tone: tone,
      blobAt: const Alignment(-0.2, 0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.habitWater,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _TileButton(
                icon: ParlaIconName.minus,
                label: l10n.habitWaterRemove,
                onPressed: onRemove,
              ),
              const SizedBox(width: 4),
              _TileButton(
                icon: ParlaIconName.plus,
                label: l10n.habitWaterAdd,
                onPressed: onAdd,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ExcludeSemantics(
            child: SizedBox(
              height: 30,
              width: double.infinity,
              child: CustomPaint(painter: _WaterScale(count, goal)),
            ),
          ),
          const Spacer(),
          const SizedBox(height: 8),
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
                    text: ' / $goal',
                    style: TextStyle(
                      fontSize: 15,
                      color: tone.ink.withValues(alpha: .7),
                    ),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w200,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterScale extends CustomPainter {
  _WaterScale(this.count, this.goal);

  final int count;
  final int goal;

  @override
  void paint(Canvas canvas, Size size) {
    final step = (size.width - 8) / goal;
    final on = Paint()
      ..color = const Color(0x8CF4E9FF)
      ..strokeWidth = 1.4;
    final off = Paint()
      ..color = const Color(0x33F4E9FF)
      ..strokeWidth = 1.4;
    for (var i = 0; i < goal; i++) {
      final x = 4 + step * i + step / 2;
      final top = i.isEven ? size.height * .4 : size.height * .55;
      canvas.drawLine(
        Offset(x, top),
        Offset(x, size.height - 4),
        i < count ? on : off,
      );
    }
    // The lime marker after the last glass.
    final x = 4 + step * count.clamp(0, goal);
    final marker = Paint()..color = ParlaColors.marker;
    canvas
      ..drawLine(
        Offset(x, 6),
        Offset(x, size.height - 4),
        marker..strokeWidth = 2,
      )
      ..drawPath(
        Path()
          ..moveTo(x - 4, 0)
          ..lineTo(x + 4, 0)
          ..lineTo(x, 6)
          ..close(),
        marker,
      );
  }

  @override
  bool shouldRepaint(_WaterScale old) => old.count != count || old.goal != goal;
}

/// A 44 px round glass button on a mesh tile.
class _TileButton extends StatelessWidget {
  const _TileButton({
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
    child: LiquidGlass(
      color: LiquidGlass.bright,
      shape: const CircleBorder(),
      shadow: false,
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
              color: onPressed == null
                  ? const Color(0x66F4E9FF)
                  : ParlaColors.espresso,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Movement as the prototype's sage tile: a rising line, the minutes in
/// thin large figures and a small log button.
class _MoveTile extends StatelessWidget {
  const _MoveTile({
    super.key,
    required this.title,
    required this.value,
    required this.empty,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;

  /// The logged minutes, or `null` when nothing is logged yet.
  final String? value;
  final String empty;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    const tone = MeshTone.sage;
    return MeshTile(
      tone: tone,
      blobAt: const Alignment(1.1, 1.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const ExcludeSemantics(
            child: SizedBox(
              height: 30,
              width: double.infinity,
              child: CustomPaint(painter: _MoveLine()),
            ),
          ),
          const Spacer(),
          const SizedBox(height: 8),
          Text(
            value ?? empty,
            style: value == null
                ? const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)
                : const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w200,
                    height: 1,
                  ),
          ),
          const SizedBox(height: 6),
          _SmallPill(label: actionLabel, onPressed: onAction, ink: tone.ink),
        ],
      ),
    );
  }
}

class _MoveLine extends CustomPainter {
  const _MoveLine();

  @override
  void paint(Canvas canvas, Size size) {
    final from = Offset(2, size.height - 6);
    final to = Offset(size.width - 6, 6);
    canvas.drawLine(
      from,
      to,
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..shader = const LinearGradient(
          colors: [Color(0x3310170F), Color(0xFFFF6B7A)],
        ).createShader(Rect.fromPoints(from, to)),
    );
    final mid = Offset.lerp(from, to, .55)!;
    canvas.drawPath(
      Path()
        ..moveTo(mid.dx - 4, mid.dy - 2)
        ..lineTo(mid.dx + 4, mid.dy + 5)
        ..lineTo(mid.dx - 5, mid.dy + 6)
        ..close(),
      Paint()..color = ParlaColors.marker,
    );
  }

  @override
  bool shouldRepaint(_MoveLine oldDelegate) => false;
}

/// A white capsule with dark text (log / edit on a tile).
class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.label,
    required this.onPressed,
    required this.ink,
  });

  final String label;
  final VoidCallback onPressed;
  final Color ink;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFFFFFFFF),
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
              // Dark ink on the white pill, whatever the tile's ink.
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A0B2A),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Sleep as the prototype's wide orange tile: name, last night's hours and
/// a white capsule to log or edit.
class _SleepTile extends StatelessWidget {
  const _SleepTile({
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
  Widget build(BuildContext context) {
    const tone = MeshTone.orange;
    return MeshTile(
      tone: tone,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      blobAt: const Alignment(0.55, 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: kMinTextSize,
                      color: tone.ink.withValues(alpha: .8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _SmallPill(label: actionLabel, onPressed: onAction, ink: tone.ink),
          ],
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Parla',
    excludeSemantics: true,
    child: const Text(
      'parla',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.5,
        height: 1.2,
        color: ParlaColors.espresso,
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
    return PebbleCard(
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
            route: '${Routes.habits}?area=${area.name}&slot=${slot.name}',
            title: '${areaLabel(l10n, area)} · ${slotLabel(l10n, slot)}',
            steps: ids.length,
            done: done,
            tile: area == RoutineArea.hair
                ? const Color(0xFF7E4BA6)
                : const Color(0xFF4E62C6),
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
          tile: const Color(0xFFA9558A),
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
          LiquidGlass(
            key: ValueKey(row.key),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => context.go(row.route),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: row.tile,
                        shape: BoxShape.circle,
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
                        color: ParlaColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
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
          child: LiquidGlass(
            key: const ValueKey('home-messages'),
            shape: const CircleBorder(),
            shadow: false,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.go(Routes.messages),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.mail_outline,
                  size: 20,
                  color: ParlaColors.espresso,
                ),
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
              backgroundColor: ParlaColors.marker,
            ),
          ),
      ],
    );
  }
}
