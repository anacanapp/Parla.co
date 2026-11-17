/// Rules for images uploaded in the admin panel. The panel shrinks an
/// image before upload; the server checks again and re-encodes it, which
/// drops all metadata (camera, location, dates).
library;

import 'dart:convert';

import 'content_rules.dart';

abstract final class MediaRules {
  /// Largest upload the server accepts (after the panel shrinks it).
  static const maxUploadBytes = 1024 * 1024;

  /// Longest side, in pixels, of a stored image.
  static const maxSide = 1600;

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

  /// The image id in content [json], or `null`.
  static int? imageOf(Map<String, Object?> json) {
    final v = json['image'];
    return v is int ? v : null;
  }
}
