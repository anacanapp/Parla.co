import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../home/home_controller.dart';
import '../home/routine.dart';
import '../home/widgets/home_cards.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../home/widgets/smile_meter.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';

/// M-14 "Bu gün": the next routine step first, then the whole routine,
/// today's habits and product scanning.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= HomeController(now: ParlaScope.of(context).clock());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).comingSoon)),
      );
  }

  void _onNav(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        context.go(Routes.guest); // M-19/M-20 placeholder for now.
      default:
        _comingSoon();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;
    return Scaffold(
      backgroundColor: ParlaColors.lemon,
      bottomNavigationBar: ParlaNavBar(selected: 0, onTap: _onNav),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => _HomeBody(
          controller: controller,
          onComingSoon: _comingSoon,
          onScan: () => context.go(Routes.guest),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.controller,
    required this.onComingSoon,
    required this.onScan,
  });

  final HomeController controller;
  final VoidCallback onComingSoon;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context);
    final now = scope.clock();
    final language = scope.settings.language ?? defaultLanguage;

    final kind = controller.kind;
    final progress = RoutineProgress(
      sampleRoutine(kind, language),
      controller,
    );
    final routineName = kind == RoutineKind.morning
        ? l10n.routineMorningTitle
        : l10n.routineEveningTitle;
    final greeting = now.hour >= 5 && now.hour < 12
        ? l10n.homeGreetingMorning
        : now.hour >= 12 && now.hour < 18
        ? l10n.homeGreetingAfternoon
        : l10n.homeGreetingEvening;
    final next = progress.next;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header on lemon.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
                      onPressed: onComingSoon,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  MaterialLocalizations.of(context).formatFullDate(now),
                  style: text.labelMedium?.copyWith(color: ParlaColors.sunInk),
                ),
                const SizedBox(height: 4),
                Semantics(
                  header: true,
                  child: Text(greeting, style: text.headlineLarge),
                ),
                const SizedBox(height: 6),
                Text(l10n.homeTagline, style: accentStyle(locale)),
                const SizedBox(height: 20),
                RoutineSwitch(kind: kind, onChanged: controller.selectKind),
                const SizedBox(height: 20),
                Center(
                  child: SmileMeter(
                    fraction: progress.fraction,
                    child: ExcludeSemantics(
                      child: Column(
                        children: [
                          Text(
                            '${progress.doneCount}/${progress.total}',
                            style: text.displayLarge,
                          ),
                          Text(
                            l10n.meterStepsDone,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: ParlaColors.sunInk,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    progress.allDone
                        ? l10n.meterAllDone(routineName)
                        : l10n.meterProgress(
                            progress.doneCount,
                            progress.total,
                            progress.minutesLeft,
                          ),
                    textAlign: TextAlign.center,
                    style: text.bodyMedium,
                  ),
                ),
              ],
            ),
          ),

          // Cream sheet with the content.
          Container(
            decoration: const BoxDecoration(
              color: ParlaColors.cream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: next == null
                      ? RoutineDoneCard(
                          key: const ValueKey('routine-done'),
                          routineName: routineName,
                          onRestart: controller.restart,
                        )
                      : NextStepCard(
                          key: ValueKey('next-${next.id}'),
                          step: next,
                          number: progress.nextNumber,
                          onDone: () => controller.toggle(next.id),
                        ),
                ),
                const SizedBox(height: 28),
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
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 16),
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
                HabitCard(
                  icon: ParlaIconName.moon,
                  title: l10n.habitSleep,
                  value: l10n.habitNoEntry,
                  background: ParlaColors.lemon,
                  fill: ParlaColors.sunInk,
                  actions: [
                    TextButton(
                      onPressed: onComingSoon,
                      child: Text(l10n.habitLog),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                HabitCard(
                  icon: ParlaIconName.move,
                  title: l10n.habitMove,
                  value: l10n.habitNoEntry,
                  background: ParlaColors.sage,
                  fill: ParlaColors.moveFill,
                  actions: [
                    TextButton(
                      onPressed: onComingSoon,
                      child: Text(l10n.habitLog),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _ScanCard(onTap: onScan),
              ],
            ),
          ),
        ],
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
    child: SizedBox(
      width: 84,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'parla',
            style: TextStyle(
              fontSize: 32,
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

class _ScanCard extends StatelessWidget {
  const _ScanCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Material(
      color: ParlaColors.white,
      borderRadius: BorderRadius.circular(28),
      shadowColor: const Color(0x331F1A14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: ParlaColors.sky,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const ParlaIcon(ParlaIconName.scan, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.scanTitle, style: text.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      l10n.scanBody,
                      style: text.bodyMedium?.copyWith(
                        color: ParlaColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const ParlaIcon(ParlaIconName.arrowRight, strokeWidth: 2.5),
            ],
          ),
        ),
      ),
    );
  }
}
