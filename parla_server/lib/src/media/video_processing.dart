import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:parla_shared/parla_shared.dart';

/// A cleaned video ready to store: H.264 MP4 with at most one AAC sound
/// track, no metadata.
class CleanVideo {
  const CleanVideo(this.mp4, this.width, this.height, this.durationMs);

  final Uint8List mp4;
  final int width;
  final int height;
  final int durationMs;
}

/// The upload as MP4/MOV, WebM/Matroska or GIF by its first bytes, or
/// `null`. Anything else (a playlist, a text file naming other files or
/// URLs) never reaches ffmpeg.
String? sniffVideoType(Uint8List b) {
  if (b.length >= 12 && String.fromCharCodes(b.sublist(4, 8)) == 'ftyp') {
    return 'mp4';
  }
  if (b.length >= 4 &&
      b[0] == 0x1A &&
      b[1] == 0x45 &&
      b[2] == 0xDF &&
      b[3] == 0xA3) {
    return 'webm';
  }
  if (b.length >= 6) {
    final head = String.fromCharCodes(b.sublist(0, 6));
    if (head == 'GIF87a' || head == 'GIF89a') return 'gif';
  }
  return null;
}

/// Re-encodes an uploaded video. Replaced in tests.
abstract class VideoCleaner {
  static VideoCleaner instance = FfmpegVideoCleaner();

  /// The upload as a [CleanVideo], or `null` when it is not a readable
  /// video or is too large.
  Future<CleanVideo?> clean(Uint8List upload);
}

/// Re-encodes with ffmpeg (installed in the server's Docker image):
///
/// - only the first video and first sound stream are kept (sound
///   re-encoded to AAC): no subtitles, data
///   streams, chapters or metadata (camera, location, dates, file names);
/// - at most [MediaRules.maxVideoSide] pixels on the longest side, 30
///   frames a second and [MediaRules.maxVideoSeconds] seconds;
/// - H.264 in an MP4 with the index first, so phones start playing at once.
///
/// ffmpeg may only read the local file (`-protocol_whitelist file`), runs
/// one video at a time with two threads, and is stopped after [timeout].
class FfmpegVideoCleaner implements VideoCleaner {
  FfmpegVideoCleaner({
    this.ffmpeg = 'ffmpeg',
    this.ffprobe = 'ffprobe',
    this.timeout = const Duration(minutes: 3),
  });

  final String ffmpeg;
  final String ffprobe;
  final Duration timeout;

  Future<void> _queue = Future.value();

  @override
  Future<CleanVideo?> clean(Uint8List upload) {
    final done = _queue.then((_) => _clean(upload));
    _queue = done.then((_) {}, onError: (_) {});
    return done;
  }

  Future<CleanVideo?> _clean(Uint8List upload) async {
    if (upload.isEmpty || upload.length > MediaRules.maxVideoUploadBytes) {
      return null;
    }
    final type = sniffVideoType(upload);
    if (type == null) return null;
    final dir = await Directory.systemTemp.createTemp('parla-video-');
    try {
      final input = File('${dir.path}/in.$type');
      final output = File('${dir.path}/out.mp4');
      await input.writeAsBytes(upload, flush: true);
      final source = await _probe(input.path);
      if (source == null) return null;
      final side = MediaRules.maxVideoSide;
      final ok = await _run(ffmpeg, [
        '-nostdin',
        '-hide_banner',
        '-loglevel',
        'error',
        '-protocol_whitelist',
        'file',
        '-i',
        input.path,
        '-t',
        '${MediaRules.maxVideoSeconds}',
        '-map',
        '0:v:0',
        // The first sound track, if any (owner 2026-11-24: videos keep
        // their music). Re-encoded, so nothing of the original stream
        // survives but the audio itself.
        '-map',
        '0:a:0?',
        '-sn',
        '-dn',
        '-map_metadata',
        '-1',
        '-map_chapters',
        '-1',
        '-vf',
        'scale=w=$side:h=$side:force_original_aspect_ratio=decrease:'
            'force_divisible_by=2,fps=30,format=yuv420p',
        '-c:v',
        'libx264',
        '-preset',
        'veryfast',
        '-crf',
        '26',
        '-profile:v',
        'main',
        '-movflags',
        '+faststart',
        '-fflags',
        '+bitexact',
        '-flags:v',
        '+bitexact',
        '-c:a',
        'aac',
        '-b:a',
        '96k',
        '-ac',
        '2',
        '-flags:a',
        '+bitexact',
        '-threads',
        '2',
        '-y',
        output.path,
      ]);
      if (!ok || !output.existsSync()) return null;
      final result = await _probe(output.path);
      final bytes = await output.readAsBytes();
      if (result == null || bytes.length > MediaRules.maxVideoBytes) {
        return null;
      }
      return CleanVideo(bytes, result.width, result.height, result.durationMs);
    } finally {
      await dir.delete(recursive: true);
    }
  }

  /// Size and length of the first video stream, or `null` when the file
  /// has none or is not a video container ffprobe can read.
  Future<({int width, int height, int durationMs})?> _probe(String path) async {
    final out = StringBuffer();
    final ok = await _run(ffprobe, [
      '-v',
      'error',
      '-protocol_whitelist',
      'file',
      '-select_streams',
      'v:0',
      '-show_entries',
      'stream=width,height:format=duration,format_name',
      '-of',
      'json',
      path,
    ], stdout: out);
    if (!ok) return null;
    try {
      final json = jsonDecode(out.toString()) as Map<String, Object?>;
      final format = json['format'] as Map<String, Object?>?;
      final name = format?['format_name'] as String? ?? '';
      const allowed = {'mov', 'mp4', 'matroska', 'webm', 'gif'};
      if (!name.split(',').any(allowed.contains)) return null;
      final streams = json['streams'] as List?;
      if (streams == null || streams.isEmpty) return null;
      final s = streams.first as Map<String, Object?>;
      final width = (s['width'] as num?)?.toInt() ?? 0;
      final height = (s['height'] as num?)?.toInt() ?? 0;
      final seconds = double.tryParse('${format?['duration']}') ?? 0;
      if (width < 1 || height < 1) return null;
      return (
        width: width,
        height: height,
        durationMs: (seconds * 1000).round(),
      );
    } on Object {
      return null;
    }
  }

  Future<bool> _run(
    String executable,
    List<String> args, {
    StringBuffer? stdout,
  }) async {
    final Process process;
    try {
      process = await Process.start(executable, args);
    } on ProcessException {
      return false;
    }
    final out = process.stdout
        .transform(utf8.decoder)
        .forEach((s) => stdout?.write(s));
    // Drained, not logged: the messages could only name the temp file.
    final err = process.stderr.drain<void>();
    final code = await process.exitCode.timeout(
      timeout,
      onTimeout: () {
        process.kill(ProcessSignal.sigkill);
        return -1;
      },
    );
    await Future.wait([out, err]).timeout(
      const Duration(seconds: 5),
      onTimeout: () => const [],
    );
    return code == 0;
  }
}
