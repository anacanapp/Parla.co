import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Plays a stored video in the panel: muted, looping, with the browser's
/// controls. The bytes come from the server's preview call and play from a
/// `blob:` URL that never leaves the browser (allowed by the panel's
/// `media-src` policy); the URL is revoked when the preview closes.
class VideoPreview extends StatefulWidget {
  const VideoPreview({super.key, required this.bytes});

  final Uint8List bytes;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late final String _url = web.URL.createObjectURL(
    web.Blob(
      [widget.bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'video/mp4'),
    ),
  );

  @override
  void dispose() {
    web.URL.revokeObjectURL(_url);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    key: const ValueKey('video-preview'),
    width: 360,
    height: 240,
    child: HtmlElementView.fromTagName(
      tagName: 'video',
      onElementCreated: (element) {
        final video = element as web.HTMLVideoElement;
        video
          ..src = _url
          ..muted = true
          ..loop = true
          ..autoplay = true
          ..controls = true
          ..style.width = '100%'
          ..style.height = '100%';
        video.setAttribute('playsinline', '');
      },
    ),
  );
}
