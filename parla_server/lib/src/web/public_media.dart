import 'dart:typed_data';

import '../media/media_store.dart';

/// Serves the public copies of content images at `/media/<id>.jpg` and of
/// exercise videos at `/media/<id>.mp4`.
///
/// The bucket stays private: only the server reads it, with its task role.
/// An image is found only while published content uses it, because
/// `syncPublicMedia` keeps exactly those under the `public/` prefix; any
/// other id, and every uploaded but unpublished image, is "not found".
class PublicMedia {
  PublicMedia({this.maxCacheBytes = 64 * 1024 * 1024});

  /// Shared by the web route and `syncPublicMedia` (one server task).
  static PublicMedia instance = PublicMedia();

  /// Files are UUID v4 ids from the upload, `.jpg` for an image and
  /// `.mp4` for a video.
  static final _file = RegExp(
    r'^([0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})\.(jpg|mp4)$',
  );

  /// How long browsers may keep an image. Short, so that an image taken
  /// off the app (for example an expert's photo after the consent ends)
  /// disappears within the hour.
  static const browserMaxAge = Duration(hours: 1);

  /// Upper bound on the bytes kept in memory.
  final int maxCacheBytes;

  final _cache = <String, Uint8List>{};
  int _cachedBytes = 0;

  /// The media id in [fileName], or `null` when it is not a valid name.
  static String? idOf(String fileName) => _file.firstMatch(fileName)?.group(1);

  /// Whether [fileName] names a video (`.mp4`).
  static bool isVideo(String fileName) =>
      _file.firstMatch(fileName)?.group(2) == 'mp4';

  /// The bytes of the public copy (JPEG or MP4), or `null` when there is
  /// none.
  Future<Uint8List?> read(String fileName, MediaStore store) async {
    final id = idOf(fileName);
    if (id == null) return null;
    final video = isVideo(fileName);
    final name = video ? '$id.mp4' : id;
    final hit = _cache.remove(name);
    if (hit != null) {
      _cache[name] = hit; // Most recently used last.
      return hit;
    }
    final bytes = await store.get(Media.publicKey(id, video: video));
    if (bytes == null) return null;
    _remember(name, bytes);
    return bytes;
  }

  /// Drops [id] (an image or a video) from memory; called when its public
  /// copy is removed.
  void forget(String id) {
    for (final name in [id, '$id.mp4']) {
      final old = _cache.remove(name);
      if (old != null) _cachedBytes -= old.length;
    }
  }

  void _remember(String id, Uint8List bytes) {
    if (bytes.length > maxCacheBytes) return;
    _cache[id] = bytes;
    _cachedBytes += bytes.length;
    while (_cachedBytes > maxCacheBytes) {
      final oldest = _cache.keys.first;
      _cachedBytes -= _cache.remove(oldest)!.length;
    }
  }
}
