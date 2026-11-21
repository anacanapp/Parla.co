import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../discover/content_library.dart';
import '../discover/discover_widgets.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'exercise_text.dart';
import 'exercise_video.dart';
import 'sport_labels.dart';

enum _Phase { overview, countdown, work, rest, finished }

/// One workout: the list of moves, then a guided run. Every set starts
/// with a 3-2-1 countdown and runs on a timer (a move counted in reps gets
/// [WorkoutPace.secondsPerRep] a rep), then a rest; everything moves on by
/// itself, with pause, previous, next and stop. The move's video plays
/// muted and looping. Music plays from the user's own app; Parla only
/// gives a short signal (sound and vibration, or vibration only) and keeps
/// the screen on while the workout runs.
class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.workoutId});

  final String workoutId;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

/// Timings of the guided run.
abstract final class WorkoutPace {
  static const countdownSeconds = 3;

  /// A calm pace for one rep, so reps moves run on a timer too.
  static const secondsPerRep = 3;
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  _Phase _phase = _Phase.overview;
  int _index = 0;
  int _set = 1;
  int _left = 0;
  int _total = 1;
  bool _paused = false;
  Timer? _timer;

  bool get _running =>
      _phase == _Phase.countdown ||
      _phase == _Phase.work ||
      _phase == _Phase.rest;

  @override
  void dispose() {
    _timer?.cancel();
    if (_running) WakelockPlus.disable().ignore();
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

  static int _workSeconds(WorkoutItem item) =>
      item.exercise.mode == ExerciseMode.reps
      ? item.amount * WorkoutPace.secondsPerRep
      : item.amount;

  void _start(Workout w) {
    _index = 0;
    _set = 1;
    WakelockPlus.enable().ignore();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick(w));
    _countdown();
  }

  void _enter(_Phase phase, int seconds) => setState(() {
    _phase = phase;
    _left = seconds;
    _total = seconds < 1 ? 1 : seconds;
  });

  void _countdown() {
    _paused = false;
    _enter(_Phase.countdown, WorkoutPace.countdownSeconds);
    HapticFeedback.selectionClick();
  }

  void _work(Workout w) {
    _enter(_Phase.work, _workSeconds(w.items[_index]));
    _signal();
  }

  void _tick(Workout w) {
    if (_paused || !mounted || !_running) return;
    setState(() => _left--);
    if (_left > 0) {
      if (_phase == _Phase.countdown) HapticFeedback.selectionClick();
      return;
    }
    _next(w);
  }

  /// Ends the current step: countdown → set, set → rest (or the end),
  /// rest → the next set's countdown. Also the "next" button.
  void _next(Workout w) {
    switch (_phase) {
      case _Phase.countdown:
        _work(w);
      case _Phase.work:
        final item = w.items[_index];
        final lastSet = _set >= item.sets;
        final lastItem = _index >= w.items.length - 1;
        if (lastSet && lastItem) {
          _signal();
          _finish(w);
        } else if (item.restSeconds > 0) {
          _signal();
          _enter(_Phase.rest, item.restSeconds);
        } else {
          _advance(w);
        }
      case _Phase.rest:
        _advance(w);
      case _Phase.overview || _Phase.finished:
        break;
    }
  }

  /// To the next set, or the next move's first set.
  void _advance(Workout w) {
    if (_set < w.items[_index].sets) {
      _set++;
    } else {
      _index++;
      _set = 1;
    }
    _countdown();
  }

  /// Back to the move before the one on screen (or the start of the
  /// first move).
  void _previous(Workout w) {
    final shown = _shownIndex(w);
    _index = shown > 0 ? shown - 1 : 0;
    _set = 1;
    _countdown();
  }

  /// The move on screen: while resting after a move's last set, the next
  /// one, so the user can get ready.
  int _shownIndex(Workout w) =>
      _phase == _Phase.rest && _set >= w.items[_index].sets
      ? _index + 1
      : _index;

  Future<void> _stop() async {
    final l10n = AppLocalizations.of(context);
    final wasPaused = _paused;
    setState(() => _paused = true);
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sportStopTitle),
        content: Text(l10n.sportStopBody),
        actions: [
          TextButton(
            key: const ValueKey('workout-keep-going'),
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.sportKeepGoing),
          ),
          TextButton(
            key: const ValueKey('workout-stop-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.sportStopConfirm),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (sure != true) {
      setState(() => _paused = wasPaused);
      return;
    }
    _timer?.cancel();
    WakelockPlus.disable().ignore();
    context.go(Routes.sport);
  }

  Future<void> _finish(Workout w) async {
    _timer?.cancel();
    WakelockPlus.disable().ignore();
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
      builder: (context, _) => PopScope(
        canPop: !_running,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _stop();
        },
        child: Scaffold(
          backgroundColor: ParlaColors.cream,
          appBar: AppBar(
            backgroundColor: ParlaColors.cream,
            leading: _running
                ? IconButton(
                    key: const ValueKey('workout-stop'),
                    tooltip: l10n.sportQuit,
                    icon: const Icon(Icons.close),
                    onPressed: _stop,
                  )
                : BackButton(onPressed: () => context.go(Routes.sport)),
            title: _running && w != null
                ? Text(
                    l10n.sportExerciseOf(_index + 1, w.items.length),
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : null,
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
    final resting = _phase == _Phase.rest;
    final counting = _phase == _Phase.countdown;
    final item = w.items[_shownIndex(w)];
    final (name, how) = exerciseText(item.exercise.id, language);
    final caution = exerciseCaution(item.exercise.id, language);
    final reps = item.exercise.mode == ExerciseMode.reps;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        _Media(
          exerciseId: item.exercise.id,
          playing: !_paused,
          resting: resting,
          countdown: counting ? _left : null,
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
            switch (_phase) {
              _Phase.rest => l10n.sportNextUp(name),
              _Phase.countdown =>
                '${l10n.sportGetReady} · '
                    '${l10n.sportSetOf(_set, item.sets)}',
              _ => l10n.sportSetOf(_set, item.sets),
            },
            style: text.titleMedium?.copyWith(color: ParlaColors.sportBlue),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: _Ring(
            progress: _left / _total,
            resting: resting,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!resting && !counting && reps)
                  Text(
                    l10n.sportRepsNow(item.amount),
                    key: const ValueKey('workout-reps'),
                    textAlign: TextAlign.center,
                    style: text.titleLarge,
                  ),
                Text(
                  counting ? '$_left' : _clock(_left),
                  key: ValueKey(
                    counting ? 'workout-countdown' : 'workout-count',
                  ),
                  style: counting ? text.displayLarge : text.displayMedium,
                ),
              ],
            ),
          ),
        ),
        if (!resting && !counting && reps)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l10n.sportRepPace(WorkoutPace.secondsPerRep),
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(color: ParlaColors.muted),
            ),
          ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              key: const ValueKey('workout-previous'),
              tooltip: l10n.sportPrevious,
              iconSize: 28,
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              onPressed: () => _previous(w),
              icon: const Icon(Icons.skip_previous_rounded),
            ),
            const SizedBox(width: 20),
            IconButton.filled(
              key: const ValueKey('workout-pause'),
              tooltip: _paused ? l10n.sportResume : l10n.sportPause,
              iconSize: 40,
              style: IconButton.styleFrom(
                backgroundColor: ParlaColors.sportBlue,
                foregroundColor: ParlaColors.white,
              ),
              constraints: const BoxConstraints(minWidth: 76, minHeight: 76),
              onPressed: () => setState(() => _paused = !_paused),
              icon: Icon(
                _paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              ),
            ),
            const SizedBox(width: 20),
            IconButton.outlined(
              key: const ValueKey('workout-skip'),
              tooltip: l10n.sportNextMove,
              iconSize: 28,
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              onPressed: () => _next(w),
              icon: const Icon(Icons.skip_next_rounded),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (!resting) Text(how, style: text.bodyLarge),
        if (!resting && caution != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              key: const ValueKey('workout-caution'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ParlaColors.sky,
                borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
              ),
              child: Text(caution, style: text.bodyMedium),
            ),
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

/// The move's video, else its photo, else a tinted block with an icon.
/// During the countdown the number sits over it.
class _Media extends StatelessWidget {
  const _Media({
    required this.exerciseId,
    required this.playing,
    required this.resting,
    this.countdown,
  });

  final String exerciseId;
  final bool playing;
  final bool resting;
  final int? countdown;

  @override
  Widget build(BuildContext context) {
    final item = ContentLibrary.current?.find('exercise', exerciseId);
    final placeholder = Container(
      color: resting ? ParlaColors.sky : ParlaColors.sportBlue,
      alignment: Alignment.center,
      child: ExcludeSemantics(
        child: ParlaIcon(
          resting ? ParlaIconName.moon : ParlaIconName.dumbbell,
          size: 56,
          color: resting ? ParlaColors.espresso : ParlaColors.white,
        ),
      ),
    );
    final image = item?.image;
    final still = image == null
        ? placeholder
        : ContentImage(
            key: const ValueKey('workout-image'),
            image: image,
            radius: 0,
            aspectRatio: 16 / 10,
          );
    final video = item?.video;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (video != null)
              ExerciseVideo(
                key: ValueKey('workout-video-$exerciseId'),
                video: video,
                playing: playing && countdown == null,
                fallback: still,
              )
            else
              still,
            if (resting) const ColoredBox(color: Color(0x66FFFFFF)),
            if (countdown != null)
              ColoredBox(
                color: const Color(0x8C1F1A14),
                child: Center(
                  child: ExcludeSemantics(
                    child: Text(
                      '$countdown',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: ParlaColors.white,
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
}

/// The step's timer as a ring that empties as time runs out.
class _Ring extends StatelessWidget {
  const _Ring({
    required this.progress,
    required this.resting,
    required this.child,
  });

  final double progress;
  final bool resting;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180, minHeight: 180),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: CircularProgressIndicator(
                value: progress.clamp(0, 1),
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
                backgroundColor: ParlaColors.line,
                color: resting ? ParlaColors.sunInk : ParlaColors.sportBlue,
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(24), child: child),
        ],
      ),
    );
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
