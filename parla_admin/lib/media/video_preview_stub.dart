import 'dart:typed_data';

import 'package:flutter/widgets.dart';

/// Plays a stored video in the panel (web only; tests get a placeholder).
class VideoPreview extends StatelessWidget {
  const VideoPreview({super.key, required this.bytes});

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) =>
      const SizedBox(key: ValueKey('video-preview'), width: 360, height: 240);
}
