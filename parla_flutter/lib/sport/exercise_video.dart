import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:video_player/video_player.dart';

import '../services/parla_api.dart';
import '../ui/locale_text.dart';

/// An exercise's video: looping, from our own server (the team uploads it;
/// the server keeps one sound track and strips metadata). Its sound
/// follows [sound]; it mixes with the user's own music instead of pausing
/// it. With "reduce motion" on, it
/// waits on its first frame until tapped. Shows [fallback] while loading
/// and if it cannot play.
class ExerciseVideo extends StatefulWidget {
  const ExerciseVideo({
    super.key,
    required this.video,
    required this.fallback,
    this.playing = true,
    this.sound = true,
  });

  final ContentImageRef video;
  final Widget fallback;

  /// Follows the workout's pause.
  final bool playing;

  /// The video's own sound; off plays it muted.
  final bool sound;

  /// Replaces the player in tests (no video plugin there).
  static Widget Function(ContentImageRef video, bool playing)? debugPlayer;

  @override
  State<ExerciseVideo> createState() => _ExerciseVideoState();
}

class _ExerciseVideoState extends State<ExerciseVideo> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _failed = false;
  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    if (ExerciseVideo.debugPlayer == null) _open();
  }

  @override
  void didUpdateWidget(ExerciseVideo old) {
    super.didUpdateWidget(old);
    if (ExerciseVideo.debugPlayer != null) return;
    if (old.video.url != widget.video.url) {
      _close();
      _tapped = false;
      _open();
    } else {
      if (old.playing != widget.playing) _sync();
      if (old.sound != widget.sound && _ready) {
        _controller?.setVolume(widget.sound ? 1 : 0);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  bool get _shouldPlay {
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return widget.playing && (!still || _tapped);
  }

  Future<void> _open() async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller = controller;
    _ready = false;
    _failed = false;
    try {
      await controller.initialize();
      await controller.setVolume(widget.sound ? 1 : 0);
      await controller.setLooping(true);
      if (!mounted || _controller != controller) return;
      setState(() => _ready = true);
      _sync();
    } on Object {
      if (mounted && _controller == controller) setState(() => _failed = true);
    }
  }

  void _sync() {
    final c = _controller;
    if (c == null || !_ready) return;
    if (_shouldPlay) {
      c.play();
    } else {
      c.pause();
    }
  }

  void _close() {
    _controller?.dispose();
    _controller = null;
    _ready = false;
  }

  @override
  Widget build(BuildContext context) {
    final language = contentLanguageOf(context);
    final alt = ContentRules.pick(widget.video.alt, language);
    final Widget child;
    if (ExerciseVideo.debugPlayer case final player?) {
      child = player(widget.video, widget.playing);
    } else if (_failed || !_ready || _controller == null) {
      child = widget.fallback;
    } else {
      final c = _controller!;
      child = GestureDetector(
        onTap: () {
          setState(() => _tapped = !_tapped);
          _sync();
        },
        child: FittedBox(
          // A portrait video (face yoga) is shown whole, not cropped.
          fit: c.value.size.height > c.value.size.width
              ? BoxFit.contain
              : BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: c.value.size.width,
            height: c.value.size.height,
            child: VideoPlayer(c),
          ),
        ),
      );
    }
    return Semantics(
      image: true,
      label: alt,
      excludeSemantics: true,
      child: child,
    );
  }
}
