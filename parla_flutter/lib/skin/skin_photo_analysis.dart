import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Why a photo cannot be analysed; the user is asked to take another.
enum PhotoProblem { tooDark, tooBright, blurry, unreadable }

/// What the photo suggests for the quiz. Only cosmetic look, never a
/// condition: shine, visible redness and visible texture.
class SkinPhotoResult {
  const SkinPhotoResult({
    this.problem,
    this.tZoneShine = 0,
    this.cheekShine = 0,
    this.redness = 0,
    this.texture = 0,
  });

  /// Set when the photo cannot be used.
  final PhotoProblem? problem;

  /// Share of shiny pixels (0..1) in the T-zone and on the cheeks.
  final double tZoneShine;
  final double cheekShine;

  /// How much redder than the forehead the cheeks look (0..1).
  final double redness;

  /// Fine local contrast on the cheeks (0..1).
  final double texture;

  bool get ok => problem == null;

  /// A suggested `skin_type` answer, or `null` (dryness cannot be seen
  /// reliably in a photo, so "dry" is never suggested).
  String? get skinType {
    if (!ok) return null;
    if (tZoneShine >= shineHigh && cheekShine >= shineHigh) return 'oily';
    if (tZoneShine >= shineHigh) return 'combination';
    if (tZoneShine < shineLow && cheekShine < shineLow) return 'normal';
    return null;
  }

  /// Suggested `concerns` answers.
  List<String> get concerns => [
    if (ok && redness >= rednessHigh) 'redness',
    if (ok && texture >= textureHigh) 'pores',
  ];

  // DRAFT THRESHOLDS, tuned on test images only; they need checking on
  // real photos before launch.
  static const shineHigh = 0.035;
  static const shineLow = 0.01;
  static const rednessHigh = 0.35;
  static const textureHigh = 0.45;
}

/// Analyses an encoded photo (JPEG or PNG) entirely in memory. The face is
/// expected inside the oval guide in the middle of the picture.
SkinPhotoResult analyseSkinPhoto(Uint8List encoded) {
  final decoded = img.decodeImage(encoded);
  if (decoded == null) {
    return const SkinPhotoResult(problem: PhotoProblem.unreadable);
  }
  final oriented = img.bakeOrientation(decoded);
  final small = img.copyResize(
    oriented,
    width: oriented.width >= oriented.height ? 256 : null,
    height: oriented.height > oriented.width ? 256 : null,
    interpolation: img.Interpolation.average,
  );
  return analyseSkinPixels(small);
}

/// The analysis on decoded pixels (also used by tests).
SkinPhotoResult analyseSkinPixels(img.Image image) {
  final w = image.width;
  final h = image.height;
  // The guide oval: centred, 60 % of the width, 75 % of the height.
  final cx = w / 2;
  final cy = h / 2;
  final rx = w * 0.30;
  final ry = h * 0.375;

  bool inOval(int x, int y) {
    final dx = (x - cx) / rx;
    final dy = (y - cy) / ry;
    return dx * dx + dy * dy <= 1;
  }

  // Regions relative to the oval: forehead (top band), nose (centre
  // column) and cheeks (left and right of the centre).
  bool forehead(int x, int y) =>
      y < cy - ry * 0.45 && y > cy - ry * 0.85 && (x - cx).abs() < rx * 0.5;
  bool nose(int x, int y) =>
      (x - cx).abs() < rx * 0.15 && y > cy - ry * 0.3 && y < cy + ry * 0.2;
  bool cheek(int x, int y) {
    final d = (x - cx).abs();
    return d > rx * 0.35 &&
        d < rx * 0.8 &&
        y > cy - ry * 0.1 &&
        y < cy + ry * 0.35;
  }

  var count = 0;
  var lumaSum = 0.0;
  var clipped = 0;
  var tShiny = 0, tCount = 0, cShiny = 0, cCount = 0;
  var foreheadRed = 0.0, foreheadCount = 0;
  var cheekRed = 0.0;

  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      if (!inOval(x, y)) continue;
      final p = image.getPixel(x, y);
      final r = p.rNormalized.toDouble();
      final g = p.gNormalized.toDouble();
      final b = p.bNormalized.toDouble();
      final luma = 0.299 * r + 0.587 * g + 0.114 * b;
      final maxC = max(r, max(g, b));
      final minC = min(r, min(g, b));
      final sat = maxC == 0 ? 0 : (maxC - minC) / maxC;
      final shiny = luma > 0.9 && sat < 0.12;
      count++;
      lumaSum += luma;
      if (luma > 0.97 || luma < 0.03) clipped++;
      // Redness relative to brightness, so lighting matters less.
      final red = (r - g) / max(luma, 0.05);
      if (forehead(x, y) || nose(x, y)) {
        tCount++;
        if (shiny) tShiny++;
      }
      if (forehead(x, y)) {
        foreheadRed += red;
        foreheadCount++;
      }
      if (cheek(x, y)) {
        cCount++;
        if (shiny) cShiny++;
        cheekRed += red;
      }
    }
  }
  if (count == 0 || tCount == 0 || cCount == 0 || foreheadCount == 0) {
    return const SkinPhotoResult(problem: PhotoProblem.unreadable);
  }
  final meanLuma = lumaSum / count;
  if (meanLuma < 0.22) {
    return const SkinPhotoResult(problem: PhotoProblem.tooDark);
  }
  if (meanLuma > 0.85 || clipped / count > 0.25) {
    return const SkinPhotoResult(problem: PhotoProblem.tooBright);
  }

  // Sharpness and cheek texture from the Laplacian of the luma.
  double lumaAt(int x, int y) {
    final p = image.getPixel(x.clamp(0, w - 1), y.clamp(0, h - 1));
    return 0.299 * p.rNormalized +
        0.587 * p.gNormalized +
        0.114 * p.bNormalized;
  }

  var lapSum = 0.0, lapCount = 0, cheekLap = 0.0, cheekLapCount = 0;
  for (var y = 1; y < h - 1; y++) {
    for (var x = 1; x < w - 1; x++) {
      if (!inOval(x, y)) continue;
      final lap =
          (4 * lumaAt(x, y) -
                  lumaAt(x - 1, y) -
                  lumaAt(x + 1, y) -
                  lumaAt(x, y - 1) -
                  lumaAt(x, y + 1))
              .abs();
      lapSum += lap;
      lapCount++;
      if (cheek(x, y)) {
        cheekLap += lap;
        cheekLapCount++;
      }
    }
  }
  final sharpness = lapSum / max(lapCount, 1);
  if (sharpness < 0.004) {
    return const SkinPhotoResult(problem: PhotoProblem.blurry);
  }

  final rednessDelta = cheekRed / cCount - foreheadRed / foreheadCount;
  return SkinPhotoResult(
    tZoneShine: tShiny / tCount,
    cheekShine: cShiny / cCount,
    redness: (rednessDelta / 0.25).clamp(0, 1).toDouble(),
    texture: ((cheekLap / max(cheekLapCount, 1)) / 0.08).clamp(0, 1).toDouble(),
  );
}
