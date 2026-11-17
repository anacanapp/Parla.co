import 'dart:typed_data';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../staff/staff_guard.dart';
import 'image_processing.dart';
import 'media_store.dart';
import 'media_sync.dart';

/// Error codes of the image flow. The panel translates them.
abstract final class MediaErrors {
  static const notFound = 'media.not_found';
  static const invalid = 'media.invalid';
  static const notImage = 'media.not_image';
  static const inUse = 'media.in_use';
}

const _writers = {StaffRole.admin, StaffRole.editor};
const _all = {StaffRole.admin, StaffRole.editor, StaffRole.expert};

/// Images for content, uploaded in the admin panel. Every upload is
/// re-encoded on the server (no metadata kept) and stored privately; the
/// app sees an image only while published content uses it.
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

  Future<List<MediaAdminItem>> list(Session session) async {
    await requireStaff(session, roles: _all);
    final rows = await MediaAsset.db.find(
      session,
      orderByList: (t) => [t.createdAt.desc()],
      limit: 500,
    );
    return [for (final r in rows) _view(r)];
  }

  /// The stored (cleaned) image, for the panel's preview.
  Future<ByteData> preview(Session session, int id) async {
    await requireStaff(session, roles: _all);
    final row = await _get(session, id);
    final bytes = await Media.instance.store.get(Media.privateKey(row.key));
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

  /// Deletes an image no content uses (admins only).
  Future<void> delete(Session session, int id) async {
    final staff = await requireStaff(session, roles: {StaffRole.admin});
    final row = await _get(session, id);
    if ((await usedImageIds(session, drafts: true)).contains(id)) {
      throw ParlaException(code: MediaErrors.inUse);
    }
    await Media.instance.store.delete(Media.privateKey(row.key));
    if (row.public) {
      await Media.instance.store.delete(Media.publicKey(row.key));
    }
    await MediaAsset.db.deleteRow(session, row);
    await _audit(session, staff, 'media.deleted', row);
  }

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
