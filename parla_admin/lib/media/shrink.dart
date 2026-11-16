import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:parla_shared/parla_shared.dart';

/// Shrinks a picked image to [MediaRules.maxSide] and encodes it as JPEG
/// under [MediaRules.maxUploadBytes], so uploads stay small. The server
/// re-encodes it again and drops all metadata. `null` when the file is not
/// a readable image.
Uint8List? shrinkForUpload(Uint8List file) {
  final decoded = img.decodeImage(file);
  if (decoded == null) return null;
  var image = img.bakeOrientation(decoded);
  final longest = image.width > image.height ? image.width : image.height;
  if (longest > MediaRules.maxSide) {
    image = image.width >= image.height
        ? img.copyResize(image, width: MediaRules.maxSide)
        : img.copyResize(image, height: MediaRules.maxSide);
  }
  for (final quality in [85, 75, 65, 55]) {
    final jpeg = img.encodeJpg(image, quality: quality);
    if (jpeg.length <= MediaRules.maxUploadBytes) return jpeg;
  }
  return null;
}
