import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../discover/content_library.dart';
import '../discover/discover_widgets.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'exercise_text.dart';
import 'sport_labels.dart';

enum _Phase { overview, work, rest, finished }

/// One workout: the list of moves, then a guided run with sets, a timer
/// and rests. Music plays from the user's own app; Parla only gives a
/// short signal (sound and vibration, or vibration only).
class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.workoutId});

  final String workoutId;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  _Phase _phase = _Phase.overview;
  int _index = 0;
  int _set = 1;
  int _left = 0;
  bool _paused = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Workout? _workout(BuildContext context) {
    for (final w in ParlaScope.of(context).sport.plan?.workouts ?? const []) {
      if (w.id == widget.workoutId) return w;
    }
    return null;
  }

  void _signal() {
    if (ParlaScope.of(context).sport.sound) {
      SystemSound.play(SystemSoundType.click);
    }
    HapticFeedback.mediumImpact();
  }

  void _start(Workout w) {
    setState(() {
      _phase = _Phase.work;
      _index = 0;
      _set = 1;
    });
    _beginWork(w);
  }

  void _beginWork(Workout w) {
    final item = w.items[_index];
    _timer?.cancel();
    setState(() {
      _phase = _Phase.work;
      _paused = false;
      _left = item.exercise.mode == ExerciseMode.reps ? 0 : item.amount;
    });
    if (_left > 0) _tick(w);
  }

  void _tick(Workout w) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused || !mounted) return;
      setState(() => _left--);
      if (_left <= 0) {
        _timer?.cancel();
        _advance(w);
      }
    });
  }

  /// After a set (or a rest): rest, next set, next move or the end.
  void _advance(Workout w) {
    _signal();
    final item = w.items[_index];
    if (_phase == _Phase.work) {
      final lastSet = _set >= item.sets;
      final lastItem = _index >= w.items.length - 1;
      if (lastSet && lastItem) {
        _finish(w);
        return;
      }
      setState(() {
        _phase = _Phase.rest;
        _left = item.restSeconds;
        _paused = false;
      });
      _tick(w);
      return;
    }
    // End of a rest.
    if (_set < item.sets) {
      _set++;
    } else {
      _index++;
      _set = 1;
    }
    _beginWork(w);
  }

  void _skip(Workout w) {
    _timer?.cancel();
    _advance(w);
  }

  Future<void> _finish(Workout w) async {
    _timer?.cancel();
    setState(() => _phase = _Phase.finished);
    final scope = ParlaScope.of(context);
    await scope.sport.markDone(w.id);
    final habits = scope.habits;
    habits.setMove((habits.moveMinutes ?? 0) + w.minutes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final book = ParlaScope.of(context).sport;
    final w = _workout(context);
    return ListenableBuilder(
      listenable: book,
      builder: (context, _) => Scaffold(
        backgroundColor: ParlaColors.cream,
        appBar: AppBar(
          backgroundColor: ParlaColors.cream,
          leading: _phase == _Phase.work || _phase == _Phase.rest
              ? IconButton(
                  tooltip: l10n.sportQuit,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _timer?.cancel();
                    context.go(Routes.sport);
                  },
                )
              : BackButton(onPressed: () => context.go(Routes.sport)),
          actions: [
            IconButton(
              key: const ValueKey('sport-sound'),
              tooltip: book.sound ? l10n.sportSoundOn : l10n.sportSoundOff,
              onPressed: () => book.setSound(!book.sound),
              icon: Icon(
                book.sound ? Icons.volume_up_outlined : Icons.vibration,
              ),
            ),
          ],
        ),
        body: w == null
            ? const SizedBox.shrink()
            : switch (_phase) {
                _Phase.overview => _overview(context, w),
                _Phase.finished => _finished(context, w),
                _ => _player(context, w),
              },
      ),
    );
  }

  Widget _overview(BuildContext context, Workout w) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final plan = ParlaScope.of(context).sport.plan!;
    final number = plan.workouts.indexOf(w) + 1;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.sportWorkoutTitle(number),
            style: text.headlineMedium,
          ),
        ),
        Text(
          l10n.sportWorkoutMeta(sportTypeLabel(l10n, w.type), w.minutes),
          style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
        ),
        const SizedBox(height: 12),
        Text(l10n.sportMusicNote, style: text.bodySmall),
        const SizedBox(height: 16),
        for (var i = 0; i < w.items.length; i++) ...[
          _ItemRow(item: w.items[i], number: i + 1, language: language),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 12),
        FilledButton(
          key: const ValueKey('workout-start'),
          style: FilledButton.styleFrom(
            backgroundColor: ParlaColors.sportBlue,
            foregroundColor: ParlaColors.white,
          ),
          onPressed: () => _start(w),
          child: Text(l10n.sportStartWorkout),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.sportDraftNote,
          style: text.bodySmall?.copyWith(color: ParlaColors.muted),
        ),
      ],
    );
  }

  Widget _player(BuildContext context, Workout w) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final item = w.items[_index];
    final (name, how) = exerciseText(item.exercise.id, language);
    final image = ContentLibrary.current
        ?.find('exercise', item.exercise.id)
        ?.image;
    final resting = _phase == _Phase.rest;
    final reps = item.exercise.mode == ExerciseMode.reps;
    String? nextName;
    if (resting) {
      final nextIndex = _set < item.sets ? _index : _index + 1;
      nextName = exerciseText(w.items[nextIndex].exercise.id, language).$1;
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Text(
          l10n.sportExerciseOf(_index + 1, w.items.length),
          style: text.labelMedium?.copyWith(color: ParlaColors.muted),
        ),
        const SizedBox(height: 8),
        // The licensed photo the team published, else a placeholder.
        if (image != null && !resting)
          SizedBox(
            height: 200,
            child: ContentImage(
              key: const ValueKey('workout-image'),
              image: image,
              radius: 24,
              aspectRatio: image.aspectRatio,
            ),
          )
        else
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: resting ? ParlaColors.sky : ParlaColors.sportBlue,
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: ExcludeSemantics(
              child: ParlaIcon(
                resting ? ParlaIconName.moon : ParlaIconName.dumbbell,
                size: 56,
                color: resting ? ParlaColors.espresso : ParlaColors.white,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Semantics(
          header: true,
          child: Text(
            resting ? l10n.sportResting : name,
            style: text.headlineMedium,
          ),
        ),
        const SizedBox(height: 4),
        Semantics(
          liveRegion: true,
          child: Text(
            resting
                ? l10n.sportNextUp(nextName!)
                : l10n.sportSetOf(_set, item.sets),
            style: text.titleMedium?.copyWith(color: ParlaColors.sportBlue),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            resting || !reps ? _clock(_left) : l10n.sportRepsNow(item.amount),
            key: const ValueKey('workout-count'),
            style: text.displayMedium,
          ),
        ),
        const SizedBox(height: 16),
        if (!resting) Text(how, style: text.bodyLarge),
        if (!resting && exerciseCaution(item.exercise.id, language) != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              key: const ValueKey('workout-caution'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ParlaColors.sky,
                borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
              ),
              child: Text(
                exerciseCaution(item.exercise.id, language)!,
                style: text.bodyMedium,
              ),
            ),
          ),
        const SizedBox(height: 20),
        if (!resting && reps)
          FilledButton(
            key: const ValueKey('set-done'),
            style: FilledButton.styleFrom(
              backgroundColor: ParlaColors.sportBlue,
              foregroundColor: ParlaColors.white,
            ),
            onPressed: () => _advance(w),
            child: Text(l10n.sportSetDone),
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const ValueKey('workout-pause'),
                  onPressed: () => setState(() => _paused = !_paused),
                  child: Text(_paused ? l10n.sportResume : l10n.sportPause),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  key: const ValueKey('workout-skip'),
                  style: FilledButton.styleFrom(
                    backgroundColor: ParlaColors.sportBlue,
                    foregroundColor: ParlaColors.white,
                  ),
                  onPressed: () => _skip(w),
                  child: Text(l10n.sportSkip),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _finished(BuildContext context, Workout w) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        const ExcludeSemantics(
          child: Center(
            child: ParlaIcon(
              ParlaIconName.check,
              size: 64,
              color: ParlaColors.sportBlue,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          header: true,
          child: Text(
            l10n.sportFinishedTitle,
            style: text.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.sportFinishedBody(w.minutes),
          style: text.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          key: const ValueKey('workout-back'),
          onPressed: () => context.go(Routes.sport),
          child: Text(l10n.sportBackToPlan),
        ),
      ],
    );
  }

  static String _clock(int seconds) {
    final s = seconds.clamp(0, 5999);
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.number,
    required this.language,
  });

  final WorkoutItem item;
  final int number;
  final String language;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final (name, _) = exerciseText(item.exercise.id, language);
    final amount = item.exercise.mode == ExerciseMode.reps
        ? l10n.sportSetsReps(item.sets, item.amount)
        : l10n.sportSetsSeconds(item.sets, item.amount);
    return Container(
      key: ValueKey('item-${item.exercise.id}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ParlaColors.white,
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ParlaColors.sportBlueText,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text('$number', style: text.titleMedium),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: text.titleMedium),
                Text(
                  item.sets > 1
                      ? '$amount · ${l10n.sportRestSeconds(item.restSeconds)}'
                      : amount,
                  style: text.bodySmall?.copyWith(color: ParlaColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
