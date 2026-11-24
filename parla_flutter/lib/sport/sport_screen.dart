import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../home/widgets/parla_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/night.dart';
import '../ui/parla_icons.dart';
import 'sport_book.dart';
import 'sport_labels.dart';
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
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 120),
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

/// The five sections as capsules; the open one is light.
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
          Semantics(
            button: true,
            selected: id == selected,
            child: LiquidGlass(
              key: ValueKey('sport-section-$id'),
              color: id == selected ? SportNight.ink : null,
              shape: const StadiumBorder(),
              shadow: false,
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: () => onSelected(id),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      sportTypeLabel(l10n, id),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: id == selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: id == selected
                            ? const Color(0xFF1A0B2A)
                            : SportNight.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
        style: const TextStyle(fontSize: 13, color: SportNight.soft),
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
      radius: 32,
      padding: const EdgeInsets.all(16),
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
                colors: [Color(0xFF9E4D8C), Color(0xFF7E4BA6)],
              ),
            ),
            alignment: Alignment.center,
            child: const ParlaIcon(
              ParlaIconName.sparkle,
              size: 22,
              color: SportNight.ink,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(child: RowTexts(title: l10n.sportEditAnswers)),
          const ExcludeSemantics(
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
    final done = book.doneThisWeek;
    final next = book.nextOf(section);
    const muted = TextStyle(
      fontSize: kMinTextSize,
      height: 1.4,
      color: SportNight.soft,
    );

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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: SportNight.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.sportBlockedBody,
                  style: const TextStyle(
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

    final total = plan.workouts.length;
    final doneCount = plan.workouts.where((w) => done.contains(w.id)).length;
    final progress = l10n.sportWeekProgress(doneCount, total);
    final lead = '$doneCount';
    final nextNumber = next == null
        ? 0
        : plan.workouts.indexWhere((w) => w.id == next.id) + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BluePebble(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Eyebrow(l10n.sportWeekTitle),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Semantics(
                      liveRegion: true,
                      label: progress,
                      excludeSemantics: true,
                      // The count large and thin, the rest of the sentence
                      // smaller (the same localized sentence).
                      child: Text.rich(
                        progress.startsWith(lead)
                            ? TextSpan(
                                text: lead,
                                children: [
                                  TextSpan(
                                    text: progress.substring(lead.length),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Color(0xBFF4E9FF),
                                    ),
                                  ),
                                ],
                              )
                            : TextSpan(
                                text: progress,
                                style: const TextStyle(fontSize: 28),
                              ),
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w200,
                          height: 1,
                          color: SportNight.ink,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ExcludeSemantics(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final w in plan.workouts)
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done.contains(w.id)
                                  ? SportNight.ink
                                  : null,
                              border: done.contains(w.id)
                                  ? null
                                  : Border.all(
                                      color: const Color(0x80F4E9FF),
                                      width: 1.5,
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (next != null)
                OrbPill(
                  key: const ValueKey('sport-next'),
                  label:
                      '${l10n.sportWorkoutTitle(nextNumber)} · '
                      '${l10n.sportWorkoutMeta(sportTypeLabel(l10n, next.type), next.minutes)}',
                  onPressed: () => context.go(Routes.workout, extra: next.id),
                )
              else
                Text(
                  l10n.sportAllDone,
                  style: const TextStyle(fontSize: 14, color: SportNight.ink),
                ),
            ],
          ),
        ),
        if (plan.gentle) ...[
          const SizedBox(height: 12),
          GlassRow(
            key: const ValueKey('sport-gentle'),
            highlight: true,
            child: Text(
              l10n.sportGentleNote,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: SportNight.ink,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        _EditRow(section: section),
        const SizedBox(height: 22),
        _SectionLabel(l10n.sportWeekTitle),
        const SizedBox(height: 10),
        for (var i = 0; i < plan.workouts.length; i++) ...[
          _WorkoutCard(
            workout: plan.workouts[i],
            number: i + 1,
            done: done.contains(plan.workouts[i].id),
            isNext: plan.workouts[i].id == next?.id,
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
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
    final focus = workout.focus.map((a) => sportAreaLabel(l10n, a)).join(', ');
    return GlassRow(
      key: ValueKey('workout-${workout.id}'),
      highlight: isNext,
      onTap: () => context.go(Routes.workout, extra: workout.id),
      child: Row(
        children: [
          TickDot(done: done),
          const SizedBox(width: 12),
          Expanded(
            child: RowTexts(
              title: l10n.sportWorkoutTitle(number),
              subtitle: l10n.sportWorkoutMeta(
                sportTypeLabel(l10n, workout.type),
                workout.minutes,
              ),
              extra: focus,
            ),
          ),
          if (done || isNext)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                done ? l10n.sportDone : l10n.sportNextLabel,
                style: const TextStyle(
                  fontSize: kMinTextSize,
                  color: SportNight.ink,
                ),
              ),
            ),
        ],
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
    return GlassRow(
      key: ValueKey(faceYoga ? 'face-yoga' : 'session-${workout.id}'),
      onTap: () => context.go(Routes.workout, extra: workout.id),
      child: Row(
        children: [
          TickDot(done: done, icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: RowTexts(
              title: sessionTitle(l10n, workout.id),
              subtitle: faceYoga
                  ? l10n.sportFaceYogaCardBody(workout.minutes)
                  : l10n.sportSessionCardBody(
                      workout.items.length,
                      workout.minutes,
                    ),
            ),
          ),
          const ExcludeSemantics(
            child: Icon(Icons.chevron_right, color: SportNight.soft),
          ),
        ],
      ),
    );
  }
}
