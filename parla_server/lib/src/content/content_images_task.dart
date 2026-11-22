import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../media/image_processing.dart';
import '../media/media_store.dart';
import '../media/media_sync.dart';
import 'content_import.dart' show taskAdmin;

/// A cover image the team made for one article or recipe, attached by the
/// one-off task `PARLA_TASK=attach-content-images` instead of the panel.
class ContentImage {
  const ContentImage(this.kind, this.slug, this.file, this.alt);

  final ContentKind kind;
  final String slug;

  /// File name under [contentImagesPrefix] in the media bucket.
  final String file;

  /// Alt text by language (az, ru, en).
  final Map<String, String> alt;

  /// Reads one entry of the manifest; `null` when it is malformed.
  static ContentImage? fromJson(Object? json) {
    if (json is! Map<String, Object?>) return null;
    final kind = ContentKind.values.asNameMap()[json['kind']];
    final slug = json['slug'];
    final file = json['file'];
    final alt = json['alt'];
    if (kind == null ||
        slug is! String ||
        file is! String ||
        file.contains('/') ||
        alt is! Map<String, Object?> ||
        alt.values.any((v) => v is! String)) {
      return null;
    }
    return ContentImage(kind, slug, file, alt.cast<String, String>());
  }
}

/// Where the files wait in the (private) media bucket until the task runs.
/// The task deletes each file once it is attached.
const contentImagesPrefix = 'incoming/content-images/';

/// The list of covers to attach: a JSON array of
/// `{"kind", "slug", "file", "alt": {"az", "ru", "en"}}`, uploaded next to
/// the files.
const contentImagesManifest = '${contentImagesPrefix}manifest.json';

const contentImageLicense = 'AI ilə yaradılıb, öz istifadəmiz üçün';
const contentImageSource = 'AI ilə yaradılıb (Parla komandası)';

/// The entries of the manifest in the bucket. Throws [StateError] when it
/// is missing or not a list of valid entries.
Future<List<ContentImage>> readContentImagesManifest() async {
  final bytes = await Media.instance.store.get(contentImagesManifest);
  if (bytes == null) throw StateError('No $contentImagesManifest.');
  final decoded = jsonDecode(utf8.decode(bytes));
  if (decoded is! List) throw StateError('The manifest is not a list.');
  final out = <ContentImage>[];
  for (final (i, e) in decoded.indexed) {
    final image = ContentImage.fromJson(e);
    if (image == null) throw StateError('Manifest entry $i is malformed.');
    out.add(image);
  }
  return out;
}

/// The one-off task `PARLA_TASK=attach-content-images`: for each entry of
/// the manifest (or [images]) whose item has no cover yet, re-encodes the waiting file like a
/// panel upload, stores it as a media asset and sets it as the cover of the
/// working and the published copy. The item's status and review stay as
/// they are (owner's decision of 2026-11-22: covers need no expert
/// review). Every step is audited with the admin [email] as the actor.
Future<String> runAttachContentImagesTask(
  Session session,
  String email, {
  List<ContentImage>? images,
}) async {
  final staff = await taskAdmin(session, email);
  images ??= await readContentImagesManifest();
  final store = Media.instance.store;
  final skipped = <String>[];
  var attached = 0;
  for (final image in images) {
    final row = await ContentItem.db.findFirstRow(
      session,
      where: (t) => t.kind.equals(image.kind.name) & t.slug.equals(image.slug),
    );
    if (row == null) {
      skipped.add('${image.slug} (no item)');
      continue;
    }
    final draft = jsonDecode(row.draftJson) as Map<String, Object?>;
    final published = row.publishedJson == null
        ? null
        : jsonDecode(row.publishedJson!) as Map<String, Object?>;
    if (MediaRules.imageOf(draft) != null ||
        (published != null && MediaRules.imageOf(published) != null)) {
      skipped.add('${image.slug} (has a cover)');
      continue;
    }
    final key = '$contentImagesPrefix${image.file}';
    final bytes = await store.get(key);
    if (bytes == null) {
      skipped.add('${image.slug} (no file)');
      continue;
    }
    final clean = cleanImage(bytes);
    final altJson = jsonEncode(image.alt);
    if (clean == null ||
        MediaRules.problems(
          license: contentImageLicense,
          source: contentImageSource,
          altJson: altJson,
          complete: true,
        ).isNotEmpty) {
      skipped.add('${image.slug} (not a valid image)');
      continue;
    }
    final id = const Uuid().v4();
    await store.put(Media.privateKey(id), clean.jpeg, 'image/jpeg');
    final now = DateTime.now().toUtc();
    final asset = await MediaAsset.db.insertRow(
      session,
      MediaAsset(
        key: id,
        mediaType: MediaRules.image,
        pixelWidth: clean.width,
        pixelHeight: clean.height,
        bytes: clean.jpeg.length,
        license: contentImageLicense,
        source: contentImageSource,
        altJson: altJson,
        public: false,
        createdBy: staff.authUserId,
        createdAt: now,
      ),
    );
    await _audit(session, staff, 'media.uploaded', 'media_asset', asset.id!);
    final updated = await ContentItem.db.updateRow(
      session,
      row.copyWith(
        draftJson: jsonEncode({...draft, 'image': asset.id}),
        publishedJson: published == null
            ? null
            : jsonEncode({...published, 'image': asset.id}),
        updatedBy: staff.authUserId,
        updatedAt: now,
      ),
    );
    await _audit(
      session,
      staff,
      'content.cover_attached',
      'content_item',
      updated.id!,
    );
    await store.delete(key);
    attached++;
  }
  if (attached > 0) await syncPublicMedia(session);
  return [
    'Attached $attached covers.',
    if (skipped.isNotEmpty) 'Skipped: ${skipped.join('; ')}.',
  ].join(' ');
}

Future<void> _audit(
  Session session,
  StaffMember staff,
  String action,
  String objectType,
  int id,
) => writeAudit(
  session,
  actorId: staff.authUserId,
  actorRole: AuditActor.staff,
  action: action,
  objectType: objectType,
  objectId: id.toString(),
);
