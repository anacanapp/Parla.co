import 'dart:typed_data';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../staff/staff_guard.dart';
import 'image_processing.dart';
import 'media_store.dart';
import 'media_sync.dart';
import 'video_processing.dart';

/// Error codes of the image flow. The panel translates them.
abstract final class MediaErrors {
  static const notFound = 'media.not_found';
  static const invalid = 'media.invalid';
  static const notImage = 'media.not_image';
  static const inUse = 'media.in_use';
  static const notVideo = 'media.not_video';
}

/// An upload id from the panel (a UUID v4).
final _uploadId = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

const _writers = {StaffRole.admin, StaffRole.editor};
const _all = {StaffRole.admin, StaffRole.editor, StaffRole.expert};

/// Images and videos for content, uploaded in the admin panel. Every upload
/// is re-encoded on the server (no metadata or sound kept) and stored
/// privately; the app sees one only while published content uses it.
///
/// A video is larger than one request may be, so the panel sends it in
/// chunks ([uploadVideoChunk]) kept in the media store under the uploader's
/// id, then [finishVideoUpload] joins, re-encodes and removes them.
class MediaAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<MediaAdminItem> upload(
    Session session,
    ByteData data,
    String license,
    String? source,
    String altJson,
  ) async {
    final staff = await requireStaff(session, roles: _writers);
    final cleanSource = _clean(source);
    if (MediaRules.problems(
      license: license,
      source: cleanSource,
      altJson: altJson,
    ).isNotEmpty) {
      throw ParlaException(code: MediaErrors.invalid);
    }
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final clean = cleanImage(bytes);
    if (clean == null) throw ParlaException(code: MediaErrors.notImage);
    final id = const Uuid().v4();
    await Media.instance.store.put(
      Media.privateKey(id),
      clean.jpeg,
      'image/jpeg',
    );
    final row = await MediaAsset.db.insertRow(
      session,
      MediaAsset(
        key: id,
        mediaType: MediaRules.image,
        pixelWidth: clean.width,
        pixelHeight: clean.height,
        bytes: clean.jpeg.length,
        license: license.trim(),
        source: cleanSource,
        altJson: altJson,
        public: false,
        createdBy: staff.authUserId,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(session, staff, 'media.uploaded', row);
    return _view(row);
  }

  /// Stores chunk [index] of video upload [upload] (an id the panel makes).
  Future<void> uploadVideoChunk(
    Session session,
    String upload,
    int index,
    ByteData chunk,
  ) async {
    final staff = await requireStaff(session, roles: _writers);
    if (!_uploadId.hasMatch(upload) ||
        index < 0 ||
        index >= MediaRules.maxVideoChunks ||
        chunk.lengthInBytes < 1 ||
        chunk.lengthInBytes > MediaRules.videoChunkBytes) {
      throw ParlaException(code: MediaErrors.invalid);
    }
    await Media.instance.store.put(
      Media.chunkKey(staff.authUserId.uuid, upload, index),
      chunk.buffer.asUint8List(chunk.offsetInBytes, chunk.lengthInBytes),
      'application/octet-stream',
    );
  }

  /// Joins the [chunks] of [upload], re-encodes the video and adds it to
  /// the library. The chunks are removed whatever the outcome.
  Future<MediaAdminItem> finishVideoUpload(
    Session session,
    String upload,
    int chunks,
    String license,
    String? source,
    String altJson,
  ) async {
    final staff = await requireStaff(session, roles: _writers);
    final cleanSource = _clean(source);
    if (!_uploadId.hasMatch(upload) ||
        chunks < 1 ||
        chunks > MediaRules.maxVideoChunks) {
      throw ParlaException(code: MediaErrors.invalid);
    }
    final CleanVideo? clean;
    try {
      if (MediaRules.problems(
        license: license,
        source: cleanSource,
        altJson: altJson,
      ).isNotEmpty) {
        throw ParlaException(code: MediaErrors.invalid);
      }
      final joined = BytesBuilder(copy: false);
      for (var i = 0; i < chunks; i++) {
        final part = await Media.instance.store.get(
          Media.chunkKey(staff.authUserId.uuid, upload, i),
        );
        if (part == null) throw ParlaException(code: MediaErrors.invalid);
        joined.add(part);
        if (joined.length > MediaRules.maxVideoUploadBytes) {
          throw ParlaException(code: MediaErrors.notVideo);
        }
      }
      clean = await VideoCleaner.instance.clean(joined.takeBytes());
    } finally {
      await _dropChunks(staff, upload, chunks);
    }
    if (clean == null) throw ParlaException(code: MediaErrors.notVideo);
    final id = const Uuid().v4();
    await Media.instance.store.put(
      Media.privateKey(id, video: true),
      clean.mp4,
      'video/mp4',
    );
    final row = await MediaAsset.db.insertRow(
      session,
      MediaAsset(
        key: id,
        mediaType: MediaRules.video,
        durationMs: clean.durationMs,
        pixelWidth: clean.width,
        pixelHeight: clean.height,
        bytes: clean.mp4.length,
        license: license.trim(),
        source: cleanSource,
        altJson: altJson,
        public: false,
        createdBy: staff.authUserId,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(session, staff, 'media.uploaded', row);
    return _view(row);
  }

  /// Removes the chunks of an upload the panel gave up on.
  Future<void> abortVideoUpload(
    Session session,
    String upload,
    int chunks,
  ) async {
    final staff = await requireStaff(session, roles: _writers);
    if (!_uploadId.hasMatch(upload)) return;
    await _dropChunks(
      staff,
      upload,
      chunks.clamp(0, MediaRules.maxVideoChunks),
    );
  }

  Future<void> _dropChunks(StaffMember staff, String upload, int chunks) async {
    for (var i = 0; i < chunks; i++) {
      await Media.instance.store.delete(
        Media.chunkKey(staff.authUserId.uuid, upload, i),
      );
    }
  }

  Future<List<MediaAdminItem>> list(Session session) async {
    await requireStaff(session, roles: _all);
    final rows = await MediaAsset.db.find(
      session,
      orderByList: (t) => [t.createdAt.desc()],
      limit: 500,
    );
    return [for (final r in rows) _view(r)];
  }

  /// The stored (cleaned) image or video, for the panel's preview.
  Future<ByteData> preview(Session session, int id) async {
    await requireStaff(session, roles: _all);
    final row = await _get(session, id);
    final bytes = await Media.instance.store.get(_privateKey(row));
    if (bytes == null) throw ParlaException(code: MediaErrors.notFound);
    return ByteData.sublistView(bytes);
  }

  /// Changes the licence, source or alt text. Applies to the app at once
  /// when the image is already published.
  Future<MediaAdminItem> update(
    Session session,
    int id,
    String license,
    String? source,
    String altJson,
  ) async {
    final staff = await requireStaff(session, roles: _writers);
    final row = await _get(session, id);
    final cleanSource = _clean(source);
    final complete = row.public;
    if (MediaRules.problems(
      license: license,
      source: cleanSource,
      altJson: altJson,
      complete: complete,
    ).isNotEmpty) {
      throw ParlaException(code: MediaErrors.invalid);
    }
    final updated = await MediaAsset.db.updateRow(
      session,
      row.copyWith(
        license: license.trim(),
        source: cleanSource,
        altJson: altJson,
      ),
    );
    await _audit(session, staff, 'media.updated', updated);
    return _view(updated);
  }

  /// Deletes an image or video no content uses (admins only).
  Future<void> delete(Session session, int id) async {
    final staff = await requireStaff(session, roles: {StaffRole.admin});
    final row = await _get(session, id);
    if ((await usedImageIds(session, drafts: true)).contains(id)) {
      throw ParlaException(code: MediaErrors.inUse);
    }
    await Media.instance.store.delete(_privateKey(row));
    if (row.public) {
      await Media.instance.store.delete(
        Media.publicKey(row.key, video: row.mediaType == MediaRules.video),
      );
    }
    await MediaAsset.db.deleteRow(session, row);
    await _audit(session, staff, 'media.deleted', row);
  }

  static String _privateKey(MediaAsset row) =>
      Media.privateKey(row.key, video: row.mediaType == MediaRules.video);

  static String? _clean(String? s) {
    final t = s?.trim();
    return t == null || t.isEmpty ? null : t;
  }

  Future<MediaAsset> _get(Session session, int id) async {
    final row = await MediaAsset.db.findById(session, id);
    if (row == null) throw ParlaException(code: MediaErrors.notFound);
    return row;
  }

  Future<void> _audit(
    Session session,
    StaffMember staff,
    String action,
    MediaAsset row,
  ) => writeAudit(
    session,
    actorId: staff.authUserId,
    actorRole: AuditActor.staff,
    action: action,
    objectType: 'media_asset',
    objectId: row.id.toString(),
  );

  static MediaAdminItem _view(MediaAsset r) => MediaAdminItem(
    id: r.id!,
    mediaType: r.mediaType,
    durationMs: r.durationMs,
    pixelWidth: r.pixelWidth,
    pixelHeight: r.pixelHeight,
    bytes: r.bytes,
    license: r.license,
    source: r.source,
    altJson: r.altJson,
    public: r.public,
    createdAt: r.createdAt,
  );
}

/// Decoded alt text of an image (for the app).
