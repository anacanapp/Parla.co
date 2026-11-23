import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'sport_book.dart';
import 'sport_labels.dart';

/// Fitness tab: the questions first, then the weekly plan.
class SportScreen extends StatefulWidget {
  const SportScreen({super.key});

  @override
  State<SportScreen> createState() => _SportScreenState();
}

class _SportScreenState extends State<SportScreen> {
  bool _attached = false;

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
    return Scaffold(
      backgroundColor: ParlaColors.cream,
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.discover),
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: book,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(
              ParlaSpace.page,
              14,
              ParlaSpace.page,
              120,
            ),
            children: [
              Row(
                children: [
                  BackButton(onPressed: () => context.go(Routes.discover)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        AppLocalizations.of(context).sportTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ParlaSpace.gap),
              if (book.plan == null) const _Intro() else _PlanView(book: book),
              const SizedBox(height: 16),
              _SessionCard(
                workout: faceYogaWorkout,
                done: book.doneThisWeek.contains(faceYogaWorkoutId),
                icon: ParlaIconName.sparkle,
              ),
              const SizedBox(height: 20),
              Semantics(
                header: true,
                child: Text(
                  AppLocalizations.of(context).sportTypeYoga,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
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
          ),
        ),
      ),
    );
  }
}

/// Blue card shown before the questions.
class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ParlaColors.sportBlue,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ExcludeSemantics(
            child: ParlaIcon(
              ParlaIconName.dumbbell,
              size: 32,
              color: ParlaColors.sportBlueText,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.sportIntroTitle,
            style: text.headlineSmall?.copyWith(color: ParlaColors.white),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.sportIntroBody,
            style: text.bodyMedium?.copyWith(color: ParlaColors.sportBlueText),
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: const ValueKey('sport-start'),
            style: FilledButton.styleFrom(
              backgroundColor: ParlaColors.white,
              foregroundColor: ParlaColors.sportBlue,
            ),
            onPressed: () => context.go(Routes.sportQuiz),
            child: Text(l10n.sportStart),
          ),
        ],
      ),
    );
  }
}

class _PlanView extends StatelessWidget {
  const _PlanView({required this.book});

  final SportBook book;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final plan = book.plan!;
    final done = book.doneThisWeek;
    final next = book.next;
    final muted = text.bodySmall?.copyWith(color: ParlaColors.muted);

    if (plan.blocked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            key: const ValueKey('sport-blocked'),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: ParlaColors.sky,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.sportBlockedTitle, style: text.titleLarge),
                const SizedBox(height: 6),
                Text(l10n.sportBlockedBody, style: text.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go(Routes.sportQuiz),
            child: Text(l10n.sportEditAnswers),
          ),
        ],
      );
    }

    final total = plan.workouts.length;
    final doneCount = plan.workouts.where((w) => done.contains(w.id)).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: ParlaColors.sportBlue,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sportWeekTitle.toUpperCase(),
                style: text.labelMedium?.copyWith(
                  color: ParlaColors.sportBlueText,
                  letterSpacing: .8,
                ),
              ),
              const SizedBox(height: 4),
              Semantics(
                liveRegion: true,
                child: Text(
                  l10n.sportWeekProgress(doneCount, total),
                  style: text.headlineSmall?.copyWith(color: ParlaColors.white),
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : doneCount / total,
                  minHeight: 8,
                  backgroundColor: ParlaColors.white.withValues(alpha: .2),
                  color: ParlaColors.sun,
                ),
              ),
              if (next == null) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.sportAllDone,
                  style: text.bodyMedium?.copyWith(color: ParlaColors.white),
                ),
              ],
            ],
          ),
        ),
        if (plan.gentle) ...[
          const SizedBox(height: 12),
          Container(
            key: const ValueKey('sport-gentle'),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ParlaColors.sky,
              borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
            ),
            child: Text(l10n.sportGentleNote, style: text.bodyMedium),
          ),
        ],
        const SizedBox(height: 16),
        for (var i = 0; i < plan.workouts.length; i++) ...[
          _WorkoutCard(
            workout: plan.workouts[i],
            number: i + 1,
            done: done.contains(plan.workouts[i].id),
            isNext: plan.workouts[i] == next,
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 6),
        OutlinedButton(
          key: const ValueKey('sport-edit'),
          onPressed: () => context.go(Routes.sportQuiz),
          child: Text(l10n.sportEditAnswers),
        ),
        const SizedBox(height: 16),
        Text(l10n.sportDraftNote, style: muted),
        const SizedBox(height: 6),
        Text(
          book.isSynced ? l10n.sportPrivacySynced : l10n.sportPrivacyDevice,
          style: muted,
        ),
      ],
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.workout,
    required this.number,
    required this.done,
    required this.isNext,
  });

  final Workout workout;
  final int number;
  final bool done;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final focus = workout.focus.map((a) => sportAreaLabel(l10n, a)).join(', ');
    return Material(
      key: ValueKey('workout-${workout.id}'),
      color: isNext ? ParlaColors.sportBlueText : ParlaColors.white,
      borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        onTap: () => context.go(Routes.workout, extra: workout.id),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: done ? ParlaColors.sun : ParlaColors.sportBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: ParlaIcon(
                  done ? ParlaIconName.check : ParlaIconName.dumbbell,
                  size: 22,
                  color: done ? ParlaColors.espresso : ParlaColors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sportWorkoutTitle(number),
                      style: text.titleMedium,
                    ),
                    Text(
                      l10n.sportWorkoutMeta(
                        sportTypeLabel(l10n, workout.type),
                        workout.minutes,
                      ),
                      style: text.bodySmall,
                    ),
                    Text(
                      focus,
                      style: text.bodySmall?.copyWith(color: ParlaColors.muted),
                    ),
                  ],
                ),
              ),
              if (done || isNext)
                Text(
                  done ? l10n.sportDone : l10n.sportNextLabel,
                  style: text.labelMedium?.copyWith(
                    color: ParlaColors.sportBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
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
    final text = Theme.of(context).textTheme;
    final faceYoga = workout.id == faceYogaWorkoutId;
    return Material(
      key: ValueKey(faceYoga ? 'face-yoga' : 'session-${workout.id}'),
      color: ParlaColors.white,
      borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        onTap: () => context.go(Routes.workout, extra: workout.id),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: done ? ParlaColors.sun : ParlaColors.sky,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: ParlaIcon(
                  done ? ParlaIconName.check : icon,
                  size: 22,
                  color: ParlaColors.espresso,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sessionTitle(l10n, workout.id),
                      style: text.titleMedium,
                    ),
                    Text(
                      faceYoga
                          ? l10n.sportFaceYogaCardBody(workout.minutes)
                          : l10n.sportSessionCardBody(
                              workout.items.length,
                              workout.minutes,
                            ),
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
              const ExcludeSemantics(
                child: Icon(Icons.chevron_right, color: ParlaColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
