import 'dart:typed_data';

/// Where images and videos are kept. Staging and production use S3 ([S3MediaStore]);
/// tests and local development keep them in memory.
abstract class MediaStore {
  Future<void> put(String key, Uint8List bytes, String contentType);
  Future<Uint8List?> get(String key);
  Future<void> copy(String from, String to);
  Future<void> delete(String key);
}

/// Keeps images in memory (tests and local development).
class MemoryMediaStore implements MediaStore {
  final Map<String, Uint8List> objects = {};

  @override
  Future<void> put(String key, Uint8List bytes, String contentType) async =>
      objects[key] = bytes;

  @override
  Future<Uint8List?> get(String key) async => objects[key];

  @override
  Future<void> copy(String from, String to) async {
    final bytes = objects[from];
    if (bytes == null) throw StateError('missing $from');
    objects[to] = bytes;
  }

  @override
  Future<void> delete(String key) async => objects.remove(key);
}

/// Used in staging and production when no bucket is configured: uploads
/// fail with a clear error instead of being lost on the next restart.
class UnconfiguredMediaStore implements MediaStore {
  Never _fail() => throw StateError('PARLA_MEDIA_BUCKET is not set');

  @override
  Future<void> put(String key, Uint8List bytes, String contentType) async =>
      _fail();

  @override
  Future<Uint8List?> get(String key) async => null;

  @override
  Future<void> copy(String from, String to) async => _fail();

  @override
  Future<void> delete(String key) async {}
}

/// The media store and the address the app loads public images from.
/// Set once at start-up (see `server.dart`); tests replace it.
class Media {
  Media(this.store, {this.publicBaseUrl});

  final MediaStore store;

  /// Base URL of the public copies (a CloudFront distribution serving the
  /// `public/` prefix), or `null` when there is none (local development):
  /// the app then shows no images.
  final String? publicBaseUrl;

  static Media instance = Media(MemoryMediaStore());

  /// Object key of an uploaded image (or, with [video], an uploaded
  /// video), not reachable by the app.
  static String privateKey(String id, {bool video = false}) =>
      'uploads/$id.${_ext(video)}';

  /// Object key of the public copy, served under [publicBaseUrl].
  static String publicKey(String id, {bool video = false}) =>
      'public/$id.${_ext(video)}';

  /// Object key of one chunk of a video upload in progress. The upload
  /// belongs to the staff member [owner]; finishing or aborting it removes
  /// the chunks.
  static String chunkKey(String owner, String upload, int index) =>
      'incoming/$owner/$upload/$index';

  String? publicUrl(String id, {bool video = false}) =>
      publicBaseUrl == null ? null : '$publicBaseUrl/$id.${_ext(video)}';

  static String _ext(bool video) => video ? 'mp4' : 'jpg';
}
