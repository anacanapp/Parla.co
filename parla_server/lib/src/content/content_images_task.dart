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
}

/// Where the files wait in the (private) media bucket until the task runs.
/// The task deletes each file once it is attached.
const contentImagesPrefix = 'incoming/content-images/';

const contentImageLicense = 'AI ilə yaradılıb, öz istifadəmiz üçün';
const contentImageSource = 'AI ilə yaradılıb (Parla komandası)';

/// The owner's images of 2026-11-22: five article covers, five recipes.
const contentImages = [
  ContentImage(ContentKind.article, 'skin-minimalism', 'skin-minimalism.jpg', {
    'az': 'Düz daş üzərində krem tubu, şam budağı və evkalipt yarpaqları',
    'ru': 'Тюбик крема на плоском камне с веточкой ели и эвкалипта',
    'en':
        'A cream tube on a flat stone with a pine sprig and eucalyptus leaves',
  }),
  ContentImage(ContentKind.article, 'brittle-nails', 'brittle-nails.jpg', {
    'az': 'Sviterli əllərdə isti çay fincanı, masada krem tubu və evkalipt',
    'ru': 'Руки в свитере держат чашку чая, рядом тюбик крема и эвкалипт',
    'en':
        'Hands in a knit sweater holding a cup of tea, a cream tube and '
        'eucalyptus on the table',
  }),
  ContentImage(
    ContentKind.article,
    'bemotrizinol-news',
    'bemotrizinol-news.jpg',
    {
      'az': 'Günəşli daş üzərində krem tubu, kremin izi və yarpaqlar',
      'ru': 'Тюбик крема на освещённом солнцем камне, мазок крема и листья',
      'en': 'A cream tube on a sunlit stone with a cream swatch and leaves',
    },
  ),
  ContentImage(
    ContentKind.article,
    'ai-skin-analysis',
    'ai-skin-analysis.jpg',
    {
      'az': 'Kosmetika masasında bənövşəyi işıqlı ekranı olan telefon',
      'ru': 'Телефон со светящимся сиреневым экраном на туалетном столике',
      'en': 'A phone with a glowing lilac screen on a vanity table',
    },
  ),
  ContentImage(ContentKind.article, 'exosomes-pdrn', 'exosomes-pdrn.jpg', {
    'az': 'Çəhrayı maye ilə dolu şüşə ampullar və serum damcısı',
    'ru': 'Стеклянные ампулы с розовой жидкостью и капля сыворотки',
    'en': 'Glass ampoules with pink liquid and a drop of serum',
  }),
  ContentImage(
    ContentKind.recipe,
    'banana-oat-cookies',
    'banana-oat-cookies.jpg',
    {
      'az': 'Yağlı kağız üzərində şokolad parçalı yulaf peçenyeləri',
      'ru': 'Овсяное печенье с кусочками шоколада на пергаменте',
      'en': 'Oat cookies with chocolate chips on baking paper',
    },
  ),
  ContentImage(
    ContentKind.recipe,
    'banana-bread-oat-walnut',
    'banana-bread-oat-walnut.jpg',
    {
      'az': 'Taxta lövhədə dilimlənmiş banan çörəyi, yanında banan və qoz',
      'ru': 'Нарезанный банановый хлеб на доске, рядом банан и грецкие орехи',
      'en': 'Sliced banana bread on a board with a banana and walnuts',
    },
  ),
  ContentImage(ContentKind.recipe, 'herb-kuku', 'herb-kuku.jpg', {
    'az': 'Formada dilimlənmiş göyərti küküsü, yanında qatıq',
    'ru': 'Нарезанное кюкю с зеленью в форме, рядом йогурт',
    'en': 'Sliced herb kuku in a baking dish with yoghurt on the side',
  }),
  ContentImage(
    ContentKind.recipe,
    'tahini-almond-cookies',
    'tahini-almond-cookies.jpg',
    {
      'az': 'Yağlı kağız üzərində küncütlü peçenyelər və tahin bankası',
      'ru': 'Печенье с кунжутом на пергаменте и баночка тахини',
      'en': 'Sesame-coated cookies on baking paper with a jar of tahini',
    },
  ),
  ContentImage(
    ContentKind.recipe,
    'pomegranate-parfait',
    'pomegranate-parfait.jpg',
    {
      'az': 'Stəkanda qat-qat qatıq, nar dənələri və qoz',
      'ru': 'Слои йогурта, зёрен граната и грецких орехов в стакане',
      'en': 'Layers of yoghurt, pomegranate seeds and walnuts in a glass',
    },
  ),
];

/// The one-off task `PARLA_TASK=attach-content-images`: for each of
/// [images] whose item has no cover yet, re-encodes the waiting file like a
/// panel upload, stores it as a media asset and sets it as the cover of the
/// working and the published copy. The item's status and review stay as
/// they are (owner's decision of 2026-11-22: covers need no expert
/// review). Every step is audited with the admin [email] as the actor.
Future<String> runAttachContentImagesTask(
  Session session,
  String email, {
  List<ContentImage> images = contentImages,
}) async {
  final staff = await taskAdmin(session, email);
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
