/// Rules for images and videos uploaded in the admin panel. The panel
/// shrinks an image before upload; the server checks again and re-encodes
/// every image and video, which drops all metadata (camera, location,
/// dates) and a video's sound.
library;

import 'dart:convert';

import 'content_rules.dart';

abstract final class MediaRules {
  /// Largest upload the server accepts (after the panel shrinks it).
  static const maxUploadBytes = 1024 * 1024;

  /// Longest side, in pixels, of a stored image.
  static const maxSide = 1600;

  /// Largest video file (MP4, MOV, WebM or GIF) the panel uploads. It is
  /// sent in chunks of [videoChunkBytes], each its own request.
  static const maxVideoUploadBytes = 40 * 1024 * 1024;
  static const videoChunkBytes = 768 * 1024;

  /// Most chunks one video upload can have.
  static const maxVideoChunks =
      (maxVideoUploadBytes + videoChunkBytes - 1) ~/ videoChunkBytes;

  /// A stored video: longest side, longest duration and largest file after
  /// the server re-encodes it (H.264 MP4, AAC sound kept).
  static const maxVideoSide = 720;
  static const maxVideoSeconds = 30;
  static const maxVideoBytes = 12 * 1024 * 1024;

  /// The two kinds of media (`MediaAsset.mediaType`).
  static const image = 'image';
  static const video = 'video';

  static const maxLicense = 300;
  static const maxSource = 500;
  static const maxAlt = 200;

  /// Problems with an image's details; empty when they are fine. With
  /// [complete], the alt text must exist in all three languages (needed
  /// before the image can be published).
  static List<String> problems({
    required String license,
    String? source,
    required String altJson,
    bool complete = false,
  }) {
    final out = <String>[];
    final l = license.trim();
    if (l.isEmpty || l.length > maxLicense) out.add('license.invalid');
    if (source != null && source.length > maxSource) {
      out.add('source.invalid');
    }
    Object? alt;
    try {
      alt = jsonDecode(altJson);
    } on FormatException {
      return [...out, 'alt.invalid'];
    }
    if (alt is! Map<String, Object?>) return [...out, 'alt.invalid'];
    for (final k in alt.keys) {
      if (!ContentRules.languages.contains(k)) out.add('alt.$k.unknown');
    }
    for (final lang in ContentRules.languages) {
      final v = alt[lang];
      if (v == null || (v is String && v.trim().isEmpty)) {
        if (complete) out.add('alt.$lang.missing');
      } else if (v is! String || v.length > maxAlt) {
        out.add('alt.$lang.invalid');
      }
    }
    return out;
  }

  /// Every image content [json] uses: the cover and images inside an
  /// article's body.
  static Set<int> imageIdsOf(Map<String, Object?> json) => {
    ?imageOf(json),
    ...ContentRules.inlineImageIds(json),
  };

  /// Every image and video content [json] uses: what must exist, and what
  /// the app may see while the content is published.
  static Set<int> mediaIdsOf(Map<String, Object?> json) => {
    ...imageIdsOf(json),
    ?videoOf(json),
  };

  /// The video id in content [json] (an exercise's video), or `null`.
  static int? videoOf(Map<String, Object?> json) {
    final v = json['video'];
    return v is int ? v : null;
  }

  /// The image id in content [json], or `null`.
  static int? imageOf(Map<String, Object?> json) {
    final v = json['image'];
    return v is int ? v : null;
  }
}
