import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../media/image_processing.dart';
import '../media/media_store.dart';
import '../media/media_sync.dart';
import '../media/video_processing.dart';
import 'content_import.dart' show mediaTypesMatch, taskAdmin;

/// A cover image (an article's or recipe's) or a video (an exercise's) the
/// team made, attached by the one-off task `PARLA_TASK=attach-content-images`
/// instead of the panel.
class ContentImage {
  const ContentImage(
    this.kind,
    this.slug,
    this.file,
    this.alt, {
    this.video = false,
  });

  final ContentKind kind;
  final String slug;

  /// File name under [contentImagesPrefix] in the media bucket.
  final String file;

  /// Alt text by language (az, ru, en).
  final Map<String, String> alt;

  /// A video (`"media": "video"` in the manifest) instead of an image.
  final bool video;

  /// Reads one entry of the manifest; `null` when it is malformed.
  static ContentImage? fromJson(Object? json) {
    if (json is! Map<String, Object?>) return null;
    final kind = ContentKind.values.asNameMap()[json['kind']];
    final slug = json['slug'];
    final file = json['file'];
    final alt = json['alt'];
    final media = json['media'] ?? 'image';
    if (kind == null ||
        (media != 'image' && media != 'video') ||
        slug is! String ||
        file is! String ||
        file.contains('/') ||
        alt is! Map<String, Object?> ||
        alt.values.any((v) => v is! String)) {
      return null;
    }
    return ContentImage(
      kind,
      slug,
      file,
      alt.cast<String, String>(),
      video: media == 'video',
    );
  }
}

/// Where the files wait in the (private) media bucket until the task runs.
/// The task deletes each file once it is attached.
const contentImagesPrefix = 'incoming/content-images/';

/// The list of covers to attach: a JSON array of
/// `{"kind", "slug", "file", "alt": {"az", "ru", "en"}}` (and
/// `"media": "video"` for a video), uploaded next to the files.
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
/// the manifest (or [images]) whose item has no cover (or video) yet,
/// re-encodes the waiting file like a panel upload, stores it as a media
/// asset and sets it on the working and the published copy. An exercise
/// without an item gets one, published with the app's own texts. The item's status and review stay as
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
  var covers = 0;
  var videos = 0;
  for (final image in images) {
    final field = image.video ? 'video' : 'image';
    var row = await ContentItem.db.findFirstRow(
      session,
      where: (t) => t.kind.equals(image.kind.name) & t.slug.equals(image.slug),
    );
    if (row == null && !image.kind.isCatalogue) {
      skipped.add('${image.slug} (no item)');
      continue;
    }
    if (row == null && !ContentRules.isValidSlug(image.kind, image.slug)) {
      skipped.add('${image.slug} (no item)');
      continue;
    }
    final draft = row == null
        ? ContentRules.catalogueDefaults(image.kind, image.slug)
        : jsonDecode(row.draftJson) as Map<String, Object?>;
    final published = row == null
        ? null
        : row.publishedJson == null
        ? null
        : jsonDecode(row.publishedJson!) as Map<String, Object?>;
    if (draft[field] != null || published?[field] != null) {
      skipped.add('${image.slug} (has ${image.video ? 'a video' : 'a cover'})');
      continue;
    }
    final key = '$contentImagesPrefix${image.file}';
    final bytes = await store.get(key);
    if (bytes == null) {
      skipped.add('${image.slug} (no file)');
      continue;
    }
    final altJson = jsonEncode(image.alt);
    if (MediaRules.problems(
      license: contentImageLicense,
      source: contentImageSource,
      altJson: altJson,
      complete: true,
    ).isNotEmpty) {
      skipped.add('${image.slug} (alt text)');
      continue;
    }
    final id = const Uuid().v4();
    final MediaAsset asset;
    final now = DateTime.now().toUtc();
    MediaAsset row0({
      required String type,
      required int width,
      required int height,
      required int size,
      int? durationMs,
    }) => MediaAsset(
      key: id,
      mediaType: type,
      durationMs: durationMs,
      pixelWidth: width,
      pixelHeight: height,
      bytes: size,
      license: contentImageLicense,
      source: contentImageSource,
      altJson: altJson,
      public: false,
      createdBy: staff.authUserId,
      createdAt: now,
    );
    if (image.video) {
      final clean = await VideoCleaner.instance.clean(bytes);
      if (clean == null) {
        skipped.add('${image.slug} (not a valid video)');
        continue;
      }
      await store.put(
        Media.privateKey(id, video: true),
        clean.mp4,
        'video/mp4',
      );
      asset = await MediaAsset.db.insertRow(
        session,
        row0(
          type: MediaRules.video,
          width: clean.width,
          height: clean.height,
          size: clean.mp4.length,
          durationMs: clean.durationMs,
        ),
      );
    } else {
      final clean = cleanImage(bytes);
      if (clean == null) {
        skipped.add('${image.slug} (not a valid image)');
        continue;
      }
      await store.put(Media.privateKey(id), clean.jpeg, 'image/jpeg');
      asset = await MediaAsset.db.insertRow(
        session,
        row0(
          type: MediaRules.image,
          width: clean.width,
          height: clean.height,
          size: clean.jpeg.length,
        ),
      );
    }
    await _audit(session, staff, 'media.uploaded', 'media_asset', asset.id!);
    if (row == null) {
      // A catalogue item (an exercise) the panel never touched: published
      // with the texts the app ships with, plus the video.
      final json = jsonEncode({...draft, field: asset.id});
      row = await ContentItem.db.insertRow(
        session,
        ContentItem(
          kind: image.kind.name,
          slug: image.slug,
          category: ContentRules.catalogueCategory,
          status: ContentStatus.published,
          draftJson: json,
          publishedJson: json,
          publishedAt: now,
          createdBy: staff.authUserId,
          updatedBy: staff.authUserId,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await _audit(session, staff, 'content.created', 'content_item', row.id!);
    } else {
      row = await ContentItem.db.updateRow(
        session,
        row.copyWith(
          draftJson: jsonEncode({...draft, field: asset.id}),
          publishedJson: published == null
              ? null
              : jsonEncode({...published, field: asset.id}),
          updatedBy: staff.authUserId,
          updatedAt: now,
        ),
      );
    }
    await _audit(
      session,
      staff,
      image.video ? 'content.video_attached' : 'content.cover_attached',
      'content_item',
      row.id!,
    );
    await store.delete(key);
    if (image.video) {
      videos++;
    } else {
      covers++;
    }
  }
  if (covers + videos > 0) await syncPublicMedia(session);
  return [
    'Attached $covers covers and $videos videos.',
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

/// The one-off task `PARLA_TASK=publish-exercise-drafts`: publishes the
/// working copy of the exercises in [slugs] that are not published yet
/// (drafts the panel made before the videos were attached), when it is
/// complete. Audited as `content.published_unreviewed` with the admin
/// [email] as the actor (owner's decision of 2026-11-23).
Future<String> runPublishExerciseDraftsTask(
  Session session,
  String email,
  Set<String> slugs,
) async {
  final staff = await taskAdmin(session, email);
  final rows = await ContentItem.db.find(
    session,
    where: (t) =>
        t.kind.equals(ContentKind.exercise.name) & t.slug.inSet(slugs),
  );
  final done = <String>[];
  final skipped = <String>[];
  for (final row in rows) {
    if (row.status == ContentStatus.published) {
      skipped.add('${row.slug} (already published)');
      continue;
    }
    final problems = ContentRules.problems(
      ContentKind.exercise,
      row.draftJson,
      complete: true,
    );
    if (problems.isNotEmpty || !await mediaTypesMatch(session, row.draftJson)) {
      skipped.add(
        '${row.slug} (${problems.isEmpty ? 'media' : problems.join(', ')})',
      );
      continue;
    }
    final now = DateTime.now().toUtc();
    final updated = await ContentItem.db.updateRow(
      session,
      row.copyWith(
        status: ContentStatus.published,
        publishedJson: row.draftJson,
        publishedReviewedAt: null,
        publishedAt: now,
        updatedBy: staff.authUserId,
        updatedAt: now,
      ),
    );
    await _audit(
      session,
      staff,
      'content.published_unreviewed',
      'content_item',
      updated.id!,
    );
    done.add(row.slug);
  }
  for (final s in slugs) {
    if (!rows.any((r) => r.slug == s)) skipped.add('$s (no item)');
  }
  if (done.isNotEmpty) await syncPublicMedia(session);
  return [
    'Published ${done.length}: ${done.join(', ')}.',
    if (skipped.isNotEmpty) 'Skipped: ${skipped.join('; ')}.',
  ].join(' ');
}
