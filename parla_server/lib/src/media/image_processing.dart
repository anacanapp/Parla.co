import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:parla_shared/parla_shared.dart';

/// A cleaned image ready to store.
class CleanImage {
  const CleanImage(this.jpeg, this.width, this.height);

  final Uint8List jpeg;
  final int width;
  final int height;
}

/// The upload as JPEG, PNG or WebP by its first bytes, or `null`.
String? sniffImageType(Uint8List b) {
  if (b.length >= 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) {
    return 'jpeg';
  }
  if (b.length >= 8 &&
      b[0] == 0x89 &&
      b[1] == 0x50 &&
      b[2] == 0x4E &&
      b[3] == 0x47) {
    return 'png';
  }
  if (b.length >= 12 &&
      String.fromCharCodes(b.sublist(0, 4)) == 'RIFF' &&
      String.fromCharCodes(b.sublist(8, 12)) == 'WEBP') {
    return 'webp';
  }
  return null;
}

/// Decodes the upload, applies its rotation, shrinks it to
/// [MediaRules.maxSide] and encodes a fresh JPEG. Only pixels survive: no
/// EXIF, GPS, camera or date metadata is copied. `null` when the upload is
/// not a readable JPEG, PNG or WebP image or is too large.
CleanImage? cleanImage(Uint8List upload) {
  if (upload.length > MediaRules.maxUploadBytes) return null;
  final type = sniffImageType(upload);
  if (type == null) return null;
  final decoded = switch (type) {
    'jpeg' => img.decodeJpg(upload),
    'png' => img.decodePng(upload),
    _ => img.decodeWebP(upload),
  };
  if (decoded == null || decoded.width < 1 || decoded.height < 1) return null;
  var image = img.bakeOrientation(decoded);
  final longest = image.width > image.height ? image.width : image.height;
  if (longest > MediaRules.maxSide) {
    image = image.width >= image.height
        ? img.copyResize(image, width: MediaRules.maxSide)
        : img.copyResize(image, height: MediaRules.maxSide);
  }
  // A new image with pixels only, so no metadata can be carried over.
  final pixels = img.Image.from(image)
    ..exif = img.ExifData()
    ..iccProfile = null;
  final jpeg = img.encodeJpg(pixels, quality: 85);
  return CleanImage(jpeg, pixels.width, pixels.height);
}
