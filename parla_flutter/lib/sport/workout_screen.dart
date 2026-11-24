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
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/night.dart';
import '../ui/parla_icons.dart';
import 'exercise_text.dart';
import 'exercise_video.dart';
import 'sport_labels.dart';
import 'sport_night.dart';

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
    if (fixedWorkoutById(widget.workoutId) case final fixed?) {
      // The same safety answers as the plan leave moves out.
      return withoutAvoided(fixed, ParlaScope.of(context).sport.answers);
    }
    for (final w in ParlaScope.of(context).sport.allWorkouts) {
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
    context.go(
      Routes.sport,
      extra: SportOptions.sectionOfWorkout(widget.workoutId),
    );
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
    // The whole flow runs on the night page (design 3.0, prototype
    // "Gecə · Məşq"): no app bar, a glass button row on top.
    return ListenableBuilder(
      listenable: book,
      builder: (context, _) {
        final sound = GlassIconButton(
          key: const ValueKey('sport-sound'),
          tooltip: book.sound ? l10n.sportSoundOn : l10n.sportSoundOff,
          onPressed: () => book.setSound(!book.sound),
          icon: Icon(book.sound ? Icons.volume_up_outlined : Icons.vibration),
        );
        return PopScope(
          canPop: !_running,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _stop();
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: w == null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: GlassIconButton(
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).backButtonTooltip,
                            onPressed: () => context.go(
                              Routes.sport,
                              extra: SportOptions.sectionOfWorkout(
                                widget.workoutId,
                              ),
                            ),
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                      )
                    : switch (_phase) {
                        _Phase.overview => _overview(context, w, sound),
                        _Phase.finished => _finished(context, w),
                        _ => _player(context, w, sound),
                      },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _overview(BuildContext context, Workout w, Widget sound) {
    final l10n = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final fixed = fixedWorkoutById(w.id) != null;
    // Plan workouts are numbered in their ids ("w2", "p1", "v3").
    final number = fixed ? 0 : int.tryParse(w.id.substring(1)) ?? 1;
    const body = TextStyle(fontSize: 14, height: 1.45, color: SportNight.ink);
    const muted = TextStyle(
      fontSize: kMinTextSize,
      height: 1.4,
      color: SportNight.soft,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 32),
      children: [
        SportHeader(
          title: fixed
              ? sessionTitle(l10n, w.id)
              : l10n.sportWorkoutTitle(number),
          onBack: () => context.go(
            Routes.sport,
            extra: SportOptions.sectionOfWorkout(widget.workoutId),
          ),
          trailing: sound,
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Text(
            l10n.sportWorkoutMeta(sportTypeLabel(l10n, w.type), w.minutes),
            style: const TextStyle(fontSize: 13, color: SportNight.soft),
          ),
        ),
        const SizedBox(height: 18),
        if (w.type == 'face_yoga' || w.type == 'yoga') ...[
          GlassRow(
            key: ValueKey(
              w.type == 'yoga' ? 'yoga-safety' : 'face-yoga-safety',
            ),
            highlight: true,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  w.type == 'yoga'
                      ? l10n.sportYogaSafetyTitle
                      : l10n.sportFaceYogaSafetyTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: SportNight.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  w.type == 'yoga'
                      ? l10n.sportYogaSafetyBody
                      : l10n.sportFaceYogaSafetyBody,
                  style: body,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(l10n.sportMusicNote, style: muted),
        const SizedBox(height: 16),
        for (var i = 0; i < w.items.length; i++) ...[
          _ItemRow(item: w.items[i], number: i + 1, language: language),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        OrbPill(
          key: const ValueKey('workout-start'),
          label: l10n.sportStartWorkout,
          icon: Icons.play_arrow_rounded,
          height: 68,
          background: const Color(0x99140620),
          onPressed: () => _start(w),
        ),
        const SizedBox(height: 14),
        Text(l10n.sportDraftNote, style: muted),
      ],
    );
  }

  Widget _player(BuildContext context, Workout w, Widget sound) {
    final l10n = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final resting = _phase == _Phase.rest;
    final counting = _phase == _Phase.countdown;
    final item = w.items[_shownIndex(w)];
    final (name, how) = exerciseText(item.exercise.id, language);
    final caution = exerciseCaution(item.exercise.id, language);
    final reps = item.exercise.mode == ExerciseMode.reps;
    return DecoratedBox(
      // The prototype's magenta glow behind the stage.
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.45),
          radius: 0.85,
          colors: [Color(0x59C43CAA), Color(0x00C43CAA)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 32),
        children: [
          Row(
            children: [
              GlassIconButton(
                key: const ValueKey('workout-stop'),
                tooltip: l10n.sportQuit,
                onPressed: _stop,
                icon: const Icon(Icons.close),
              ),
              Expanded(
                child: Text(
                  l10n.sportExerciseOf(_index + 1, w.items.length),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xBFF4E9FF),
                  ),
                ),
              ),
              sound,
            ],
          ),
          const SizedBox(height: 18),
          _Media(
            exerciseId: item.exercise.id,
            playing: !_paused,
            resting: resting,
            countdown: counting ? _left : null,
          ),
          const SizedBox(height: 18),
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: kMinTextSize,
                letterSpacing: 1.6,
                color: SportNight.soft,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Semantics(
            header: true,
            child: Text(
              resting ? l10n.sportResting : name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                letterSpacing: -.6,
                height: 1.15,
                color: SportNight.ink,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: DashedRing(
              fraction: _left / _total,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    counting ? '$_left' : _clock(_left),
                    key: ValueKey(
                      counting ? 'workout-countdown' : 'workout-count',
                    ),
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w200,
                      letterSpacing: -1,
                      height: 1.1,
                      color: SportNight.ink,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (!resting && !counting && reps)
                    Text(
                      l10n.sportRepsNow(item.amount),
                      key: const ValueKey('workout-reps'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: kMinTextSize,
                        color: SportNight.soft,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!resting && !counting && reps)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.sportRepPace(WorkoutPace.secondsPerRep),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: kMinTextSize,
                  color: SportNight.soft,
                ),
              ),
            ),
          const SizedBox(height: 22),
          _Controls(
            paused: _paused,
            onPrevious: () => _previous(w),
            onPause: () => setState(() => _paused = !_paused),
            onNext: () => _next(w),
          ),
          const SizedBox(height: 22),
          if (!resting)
            Text(
              how,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: SportNight.ink,
              ),
            ),
          if (!resting && caution != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: GlassRow(
                key: const ValueKey('workout-caution'),
                highlight: true,
                child: Text(
                  caution,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: SportNight.ink,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _finished(BuildContext context, Workout w) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 40, 22, 32),
      children: [
        const Center(
          child: ExcludeSemantics(
            child: DashedRing(
              fraction: 1,
              child: ParlaIcon(
                ParlaIconName.check,
                size: 48,
                color: SportNight.ink,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Semantics(
          header: true,
          child: Text(
            l10n.sportFinishedTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
              letterSpacing: -1,
              color: SportNight.ink,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.sportFinishedBody(w.minutes),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            height: 1.45,
            color: SportNight.soft,
          ),
        ),
        const SizedBox(height: 28),
        OrbPill(
          key: const ValueKey('workout-back'),
          label: l10n.sportBackToPlan,
          height: 68,
          background: const Color(0x99140620),
          onPressed: () => context.go(
            Routes.sport,
            extra: SportOptions.sectionOfWorkout(widget.workoutId),
          ),
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
      alignment: Alignment.center,
      // Placeholder until the team uploads the move's photo or video.
      child: ExcludeSemantics(
        child: ParlaIcon(
          resting ? ParlaIconName.moon : ParlaIconName.dumbbell,
          size: 48,
          color: SportNight.soft,
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
            aspectRatio: 4 / 3,
          );
    final video = item?.video;
    // The stage takes the video's own shape (a 3:4 portrait video shows
    // whole), at most about half the screen high so the timer still fits.
    final aspect = video != null && video.width > 0 && video.height > 0
        ? video.width / video.height
        : 4 / 3;
    final maxHeight = MediaQuery.sizeOf(context).height * .45;
    return LayoutBuilder(
      builder: (context, box) {
        final width = box.maxWidth.isFinite
            ? (box.maxWidth < maxHeight * aspect
                  ? box.maxWidth
                  : maxHeight * aspect)
            : maxHeight * aspect;
        return Center(
          child: SizedBox(
            key: const ValueKey('workout-stage'),
            width: width,
            child: _stage(context, aspect, video, still),
          ),
        );
      },
    );
  }

  Widget _stage(
    BuildContext context,
    double aspect,
    ContentImageRef? video,
    Widget still,
  ) {
    const radius = BorderRadius.all(Radius.circular(44));
    // Glass frame of the prototype: a light-to-clear fill, a hairline and
    // a deep shadow.
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Color(0x8C1E003C),
            blurRadius: 60,
            offset: Offset(0, 30),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: AspectRatio(
          aspectRatio: aspect,
          child: DecoratedBox(
            // An opaque base, so the shadow below does not show through
            // the glass.
            decoration: const BoxDecoration(
              color: Color(0xFF1E1430),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF443A57), Color(0xFF221A33)],
              ),
            ),
            position: DecorationPosition.background,
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
                if (resting) const ColoredBox(color: Color(0x6608070F)),
                if (countdown != null)
                  ColoredBox(
                    color: const Color(0x8C08070F),
                    child: Center(
                      child: ExcludeSemantics(
                        child: Text(
                          '$countdown',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w200,
                            color: SportNight.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                const IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      border: Border.fromBorderSide(
                        BorderSide(color: Color(0x33FFFFFF)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The player's controls (prototype "Gecə · Məşq"): a round glass
/// "previous" button and the dark capsule with the pause orb, its label
/// and "next".
class _Controls extends StatelessWidget {
  const _Controls({
    required this.paused,
    required this.onPrevious,
    required this.onPause,
    required this.onNext,
  });

  final bool paused;
  final VoidCallback onPrevious;
  final VoidCallback onPause;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        LiquidGlass(
          shape: const CircleBorder(),
          shadow: false,
          child: SizedBox(
            width: 56,
            height: 56,
            child: IconButton(
              key: const ValueKey('workout-previous'),
              tooltip: l10n.sportPrevious,
              onPressed: onPrevious,
              style: IconButton.styleFrom(foregroundColor: SportNight.ink),
              icon: const Icon(Icons.skip_previous_rounded),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LiquidGlass(
            color: const Color(0x99140620),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.all(7),
            child: SizedBox(
              height: 54,
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey('workout-pause'),
                    tooltip: paused ? l10n.sportResume : l10n.sportPause,
                    onPressed: onPause,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 54,
                      height: 54,
                    ),
                    icon: SportOrb(
                      icon: paused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      size: 54,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ExcludeSemantics(
                      child: Text(
                        paused ? l10n.sportResume : l10n.sportPause,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: SportNight.ink,
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: l10n.sportNextMove,
                    excludeFromSemantics: true,
                    child: Semantics(
                      button: true,
                      label: l10n.sportNextMove,
                      excludeSemantics: true,
                      child: InkWell(
                        key: const ValueKey('workout-skip'),
                        customBorder: const StadiumBorder(),
                        onTap: onNext,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 54,
                            minWidth: 54,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Center(
                              widthFactor: 1,
                              child: Icon(
                                Icons.skip_next_rounded,
                                color: Color(0x99F4E9FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
    final (name, _) = exerciseText(item.exercise.id, language);
    final amount = item.exercise.mode == ExerciseMode.reps
        ? l10n.sportSetsReps(item.sets, item.amount)
        : l10n.sportSetsSeconds(item.sets, item.amount);
    return GlassRow(
      key: ValueKey('item-${item.exercise.id}'),
      child: Row(
        children: [
          TickDot(done: false, label: '$number'),
          const SizedBox(width: 12),
          Expanded(
            child: RowTexts(
              title: name,
              subtitle: item.sets > 1
                  ? '$amount · ${l10n.sportRestSeconds(item.restSeconds)}'
                  : amount,
            ),
          ),
        ],
      ),
    );
  }
}
