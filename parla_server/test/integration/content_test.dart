import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/content/content_admin_endpoint.dart';
import 'package:parla_server/src/content/content_images_task.dart';
import 'package:parla_server/src/content/content_import.dart';
import 'package:parla_server/src/content/sample_experts.dart';
import 'package:parla_server/src/content/content_seed_import.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/media/media_store.dart';
import 'package:parla_server/src/media/video_processing.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

import 'staff_sign_in.dart';

Matcher _error(String code) =>
    isA<ParlaException>().having((e) => e.code, 'code', code);

Map<String, String> _l(String s) => {
  'az': '$s az',
  'ru': '$s ru',
  'en': '$s en',
};

final _article = jsonEncode({
  'title': _l('Qış'),
  'summary': _l('Qısa'),
  'body': _l('Mətn'),
  'minutes': 4,
});

final _expert = jsonEncode({
  'name': 'Dr. Test',
  'workplace': _l('Klinika'),
  'city': _l('Bakı'),
  'years': 8,
  'whatsapp': '+994501234567',
});

void main() {
  withServerpod('Given the content flow', (sessionBuilder, endpoints) {
    Future<TestSessionBuilder> staff(String email, StaffRole role) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      final s = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id.toString(),
          {},
          authId: await signInSession(db, user.id),
        ),
      );
      if (email.startsWith('first-admin')) {
        await endpoints.staff.claimFirstAdmin(s);
      } else {
        await endpoints.staff.acceptInvite(
          s,
          DevelopmentCodeSender.lastStaffInviteCode!,
        );
      }
      return s;
    }

    Future<
      ({
        TestSessionBuilder admin,
        TestSessionBuilder editor,
        TestSessionBuilder expert,
      })
    >
    team() async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      await endpoints.staffAdmin.invite(
        admin,
        'editor@example.com',
        StaffRole.editor,
      );
      final editor = await staff('editor@example.com', StaffRole.editor);
      await endpoints.staffAdmin.invite(
        admin,
        'expert@example.com',
        StaffRole.expert,
      );
      final expert = await staff('expert@example.com', StaffRole.expert);
      return (admin: admin, editor: editor, expert: expert);
    }

    test('an article goes draft, review, approval, publishing', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'article',
        'qis-deri',
        'care',
      );
      // Incomplete drafts may be saved but not sent for review.
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        jsonEncode({
          'title': {'az': 'Qış'},
        }),
        'care',
      );
      await expectLater(
        endpoints.contentAdmin.submitForReview(t.editor, item.id),
        throwsA(_error(ContentErrors.incomplete)),
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        _article,
        'care',
      );
      // Not approved yet: cannot be published.
      await expectLater(
        endpoints.contentAdmin.publish(t.editor, item.id),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
      await endpoints.contentAdmin.submitForReview(t.editor, item.id);
      // Editors cannot approve; experts can.
      await expectLater(
        endpoints.contentAdmin.approve(t.editor, item.id),
        throwsA(_error(StaffErrors.forbidden)),
      );
      await endpoints.contentAdmin.approve(t.expert, item.id);
      final published = await endpoints.contentAdmin.publish(
        t.editor,
        item.id,
      );
      expect(published.status, ContentStatus.published);
      expect(published.live, isTrue);

      final public = await endpoints.content.published(
        sessionBuilder,
        'article',
      );
      expect(public.single.slug, 'qis-deri');
      expect(public.single.reviewedAt, isNotNull);
      expect(public.single.json, _article);
    });

    test('editing a live article keeps the published copy until the next '
        'review and publishing', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'article',
        'spf',
        'care',
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        _article,
        'care',
      );
      await endpoints.contentAdmin.submitForReview(t.editor, item.id);
      await endpoints.contentAdmin.approve(t.expert, item.id);
      await endpoints.contentAdmin.publish(t.editor, item.id);

      final changed = jsonEncode({
        ...jsonDecode(_article) as Map,
        'minutes': 5,
      });
      final draft = await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        changed,
        'care',
      );
      expect(draft.status, ContentStatus.draft);
      expect(draft.live, isTrue);
      final public = await endpoints.content.published(
        sessionBuilder,
        'article',
      );
      expect(public.single.json, _article);
    });

    test('an expert returns a draft with a note', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'article',
        'note',
        'hair',
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        _article,
        'hair',
      );
      await endpoints.contentAdmin.submitForReview(t.editor, item.id);
      final back = await endpoints.contentAdmin.returnToWriter(
        t.expert,
        item.id,
        'Mənbə əlavə edin',
      );
      expect(back.status, ContentStatus.draft);
      expect(back.reviewNote, 'Mənbə əlavə edin');
    });

    test('expert profiles need the recorded consent to be published', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'expert',
        'dr-test',
        'dermatologist',
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        _expert,
        'dermatologist',
      );
      await expectLater(
        endpoints.contentAdmin.publish(t.editor, item.id),
        throwsA(_error(ContentErrors.consentMissing)),
      );
      await expectLater(
        endpoints.contentAdmin.recordConsent(t.editor, item.id, 'ref'),
        throwsA(_error(StaffErrors.forbidden)),
      );
      await endpoints.contentAdmin.recordConsent(
        t.admin,
        item.id,
        'Razılıq forması #12, ofis seyfi',
      );
      await endpoints.contentAdmin.publish(t.editor, item.id);
      final public = await endpoints.content.published(
        sessionBuilder,
        'expert',
      );
      expect(jsonDecode(public.single.json)['whatsapp'], '+994501234567');
      expect(public.single.reviewedAt, isNull);

      await endpoints.contentAdmin.unpublish(t.admin, item.id);
      expect(
        await endpoints.content.published(sessionBuilder, 'expert'),
        isEmpty,
      );
    });

    test('invalid content, slugs and categories are refused', () async {
      final t = await team();
      await expectLater(
        endpoints.contentAdmin.create(t.editor, 'article', 'Bad Slug', 'care'),
        throwsA(_error(ContentErrors.invalid)),
      );
      await expectLater(
        endpoints.contentAdmin.create(t.editor, 'article', 'ok', 'cars'),
        throwsA(_error(ContentErrors.invalid)),
      );
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'recipe',
        'yulaf',
        'breakfast',
      );
      await expectLater(
        endpoints.contentAdmin.create(t.editor, 'recipe', 'yulaf', 'lunch'),
        throwsA(_error(ContentErrors.slugTaken)),
      );
      await expectLater(
        endpoints.contentAdmin.saveDraft(
          t.editor,
          item.id,
          jsonEncode({'calories': 400}),
          'breakfast',
        ),
        throwsA(_error(ContentErrors.invalid)),
      );
      // Experts may not write.
      await expectLater(
        endpoints.contentAdmin.create(t.expert, 'article', 'x', 'care'),
        throwsA(_error(StaffErrors.forbidden)),
      );
    });

    test(
      'the public list needs no sign-in and holds only published items',
      () async {
        final t = await team();
        await endpoints.contentAdmin.create(
          t.editor,
          'article',
          'draft',
          'care',
        );
        expect(
          await endpoints.content.published(sessionBuilder, 'article'),
          isEmpty,
        );
        final rows = await AuditLogEntry.db.find(
          sessionBuilder.build(),
          where: (t) => t.action.equals('content.created'),
        );
        expect(rows, hasLength(1));
      },
    );

    test('the sheet import adds drafts once and keeps edits', () async {
      final t = await team();
      await expectLater(
        endpoints.contentAdmin.importSheet(t.editor),
        throwsA(_error(StaffErrors.forbidden)),
      );
      final added = await endpoints.contentAdmin.importSheet(t.admin);
      expect(added, importSeed.length);
      final recipes = await endpoints.contentAdmin.list(t.admin, 'recipe');
      final articles = await endpoints.contentAdmin.list(t.admin, 'article');
      expect(recipes.length + articles.length, importSeed.length);
      expect(
        [...recipes, ...articles].every((i) => i.status == ContentStatus.draft),
        isTrue,
      );
      expect([...recipes, ...articles].any((i) => i.live), isFalse);

      // An edited draft survives a second import.
      final oats = recipes.firstWhere((i) => i.slug == 'berry-oats');
      final edited = jsonEncode({
        ...jsonDecode(oats.draftJson) as Map<String, Object?>,
        'minutes': 12,
      });
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        oats.id,
        edited,
        'breakfast',
      );
      expect(await endpoints.contentAdmin.importSheet(t.admin), 0);
      final again = await endpoints.contentAdmin.list(t.admin, 'recipe');
      expect(
        jsonDecode(again.firstWhere((i) => i.slug == 'berry-oats').draftJson),
        containsPair('minutes', 12),
      );

      // The full articles are ready for the expert's review.
      final winter = articles.firstWhere((i) => i.slug == 'winter-dry-skin');
      final sent = await endpoints.contentAdmin.submitForReview(
        t.editor,
        winter.id,
      );
      expect(sent.status, ContentStatus.inReview);
      // Nothing imported is public.
      for (final kind in ['article', 'recipe']) {
        expect(
          await endpoints.content.published(sessionBuilder, kind),
          isEmpty,
        );
      }
    });

    test(
      'drafts that hold only the first writing plan get the full article',
      () async {
        final t = await team();
        final db = sessionBuilder.build();
        // As left by the first import: plans only, one of them edited.
        final plans = contentSeed.where((s) => s.kind == 'article').toList();
        final ids = <String, int>{};
        for (final p in plans) {
          final now = DateTime.now().toUtc();
          final row = await ContentItem.db.insertRow(
            db,
            ContentItem(
              kind: p.kind,
              slug: p.slug,
              category: p.category,
              status: ContentStatus.draft,
              draftJson: p.json,
              createdBy: UuidValue.fromString(
                '00000000-0000-4000-8000-000000000001',
              ),
              updatedBy: UuidValue.fromString(
                '00000000-0000-4000-8000-000000000001',
              ),
              createdAt: now,
              updatedAt: now,
            ),
          );
          ids[p.slug] = row.id!;
        }
        final edited = plans.firstWhere((p) => p.slug == 'winter-hands');
        await endpoints.contentAdmin.saveDraft(
          t.editor,
          ids['winter-hands']!,
          jsonEncode({
            ...jsonDecode(edited.json) as Map<String, Object?>,
            'minutes': 9,
          }),
          edited.category,
        );

        final changed = await endpoints.contentAdmin.importSheet(t.admin);
        // 20 new articles, 11 plans filled, the edited one kept; recipes.
        expect(changed, 20 + 11 + recipeSeed.length);
        final articles = await endpoints.contentAdmin.list(t.admin, 'article');
        expect(articles, hasLength(32));
        Map<String, Object?> draft(String slug) =>
            jsonDecode(articles.firstWhere((a) => a.slug == slug).draftJson)
                as Map<String, Object?>;
        final dry = draft('winter-dry-skin');
        final body = dry['body']! as Map<String, Object?>;
        expect(body.keys.toSet(), {'az', 'ru', 'en'});
        expect(body['az'], isNot(contains(ContentRules.planMarker)));
        expect(draft('winter-hands'), containsPair('minutes', 9));
        expect(
          (draft('winter-hands')['body']! as Map)['az'],
          startsWith(ContentRules.planMarker),
        );
        final audit = await AuditLogEntry.db.find(
          db,
          where: (a) => a.action.equals('content.reimported'),
        );
        expect(audit, hasLength(11));
        // A second run changes nothing.
        expect(await endpoints.contentAdmin.importSheet(t.admin), 0);

        // The owner's decision: admins publish the imported articles
        // without expert review; it stays visible in the audit and app.
        await expectLater(
          endpoints.contentAdmin.publishImported(t.editor),
          throwsA(_error(StaffErrors.forbidden)),
        );
        expect(
          await endpoints.contentAdmin.publishImported(t.admin),
          // All but the edited plan (incomplete), and every recipe.
          31 + recipeSeed.length,
        );
        final live = await endpoints.content.published(
          sessionBuilder,
          'article',
        );
        expect(live, hasLength(31));
        expect(live.every((a) => a.reviewedAt == null), isTrue);
        expect(
          await AuditLogEntry.db.count(
            db,
            where: (a) => a.action.equals('content.published_unreviewed'),
          ),
          31 + recipeSeed.length,
        );
        expect(
          await endpoints.contentAdmin.publishImported(t.admin),
          0,
        );
      },
    );

    test('sample experts: published without consent, never a real '
        'person, seeded once by the task', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'expert',
        'sample-x',
        'dermatologist',
      );
      final sample = {
        'sample': true,
        'name': 'Nümunə Dermatoloq 9',
        'workplace': {
          'az': 'Nümunə klinika',
          'ru': 'Пример клиники',
          'en': 'Sample clinic',
        },
        'city': {'az': 'Bakı', 'ru': 'Баку', 'en': 'Baku'},
        'years': 4,
        'phone': '+994000000009',
      };
      // A real-looking name or number, or an Instagram, is refused.
      for (final bad in [
        {...sample, 'name': 'Dr. Aysel'},
        {...sample, 'phone': '+994501234567'},
        {...sample, 'instagram': 'someone'},
        {...sample, 'sample': false},
      ]) {
        await expectLater(
          endpoints.contentAdmin.saveDraft(
            t.editor,
            item.id,
            jsonEncode(bad),
            'dermatologist',
          ),
          throwsA(_error(ContentErrors.invalid)),
          reason: '$bad',
        );
      }
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        jsonEncode(sample),
        'dermatologist',
      );
      await endpoints.contentAdmin.publish(t.editor, item.id);
      expect(
        await endpoints.content.published(sessionBuilder, 'expert'),
        hasLength(1),
      );
      // Saved with real data (no sample mark), it needs the consent again.
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        _expert,
        'dermatologist',
      );
      await expectLater(
        endpoints.contentAdmin.publish(t.editor, item.id),
        throwsA(_error(ContentErrors.consentMissing)),
      );

      final db = sessionBuilder.build();
      await expectLater(
        runSeedSampleExpertsTask(db, 'editor@example.com'),
        throwsA(isA<StateError>()),
      );
      expect(
        await runSeedSampleExpertsTask(db, 'first-admin@example.com'),
        'Added ${sampleExperts.length} sample experts.',
      );
      expect(
        await runSeedSampleExpertsTask(db, 'first-admin@example.com'),
        'Added 0 sample experts.',
      );
      final public = await endpoints.content.published(
        sessionBuilder,
        'expert',
      );
      expect(public, hasLength(1 + sampleExperts.length));
      for (final p in public.where((p) => p.slug.startsWith('sample-'))) {
        final json = jsonDecode(p.json) as Map<String, Object?>;
        expect(json['sample'], isTrue);
        expect(json['name'], startsWith('Nümunə'));
        expect(json['instagram'], isNull);
      }
      expect(
        await AuditLogEntry.db.count(
          db,
          where: (a) => a.action.equals('content.sample_published'),
        ),
        sampleExperts.length,
      );
    });

    test('the one-off task imports and publishes as a named admin', () async {
      await team();
      final db = sessionBuilder.build();
      await expectLater(
        runPublishImportedTask(db, 'editor@example.com'),
        throwsA(isA<StateError>()),
      );
      await expectLater(
        runPublishImportedTask(db, 'nobody@example.com'),
        throwsA(isA<StateError>()),
      );
      final result = await runPublishImportedTask(
        db,
        ' First-Admin@example.com ',
      );
      expect(
        result,
        'Imported or filled ${importSeed.length} items, refilled 0 plans, '
        'published ${blogSeed.length + recipeSeed.length}.',
      );
      expect(
        await endpoints.content.published(sessionBuilder, 'recipe'),
        hasLength(recipeSeed.length),
      );
      final audit = await AuditLogEntry.db.find(
        db,
        where: (a) => a.action.equals('content.published_unreviewed'),
      );
      expect(audit, hasLength(blogSeed.length + recipeSeed.length));
      // Run again: nothing left to do.
      expect(
        await runPublishImportedTask(db, 'first-admin@example.com'),
        'Imported or filled 0 items, refilled 0 plans, published 0.',
      );
    });

    test('the cover task attaches the waiting images once', () async {
      await team();
      final db = sessionBuilder.build();
      await runPublishImportedTask(db, 'first-admin@example.com');
      final store = MemoryMediaStore();
      final before = Media.instance;
      Media.instance = Media(store, publicBaseUrl: 'https://media.test');
      addTearDown(() => Media.instance = before);
      final jpeg = Uint8List.fromList(
        img.encodeJpg(img.Image(width: 40, height: 30)),
      );
      for (final f in ['skin-minimalism.jpg', 'herb-kuku.jpg']) {
        await store.put('$contentImagesPrefix$f', jpeg, 'image/jpeg');
      }
      Map<String, Object?> entry(String kind, String slug) => {
        'kind': kind,
        'slug': slug,
        'file': '$slug.jpg',
        'alt': {
          'az': '$slug: göyərti küküsü',
          'ru': '$slug ru',
          'en': '$slug en',
        },
      };
      await expectLater(
        runAttachContentImagesTask(db, 'first-admin@example.com'),
        throwsA(isA<StateError>()),
      );
      await store.put(
        contentImagesManifest,
        Uint8List.fromList(
          utf8.encode(
            jsonEncode([
              entry('article', 'skin-minimalism'),
              entry('recipe', 'herb-kuku'),
              entry('recipe', 'banana-oat-cookies'),
              entry('recipe', 'no-such-recipe'),
            ]),
          ),
        ),
        'application/json',
      );

      await expectLater(
        runAttachContentImagesTask(db, 'editor@example.com'),
        throwsA(isA<StateError>()),
      );
      final result = await runAttachContentImagesTask(
        db,
        'first-admin@example.com',
      );
      expect(result, startsWith('Attached 2 covers and 0 videos. Skipped: '));
      expect(result, contains('banana-oat-cookies (no file)'));
      expect(
        store.objects.keys.where((k) => k.startsWith('incoming/')),
        [contentImagesManifest],
      );
      expect(result, contains('no-such-recipe (no item)'));

      final kuku = await ContentItem.db.findFirstRow(
        db,
        where: (t) => t.slug.equals('herb-kuku'),
      );
      expect(kuku!.status, ContentStatus.published);
      final id = jsonDecode(kuku.publishedJson!)['image'] as int;
      expect(jsonDecode(kuku.draftJson)['image'], id);
      final asset = (await MediaAsset.db.findById(db, id))!;
      expect(asset.public, isTrue);
      expect(asset.license, contentImageLicense);
      expect(jsonDecode(asset.altJson)['az'], contains('küküsü'));
      expect(store.objects.keys, contains(Media.publicKey(asset.key)));
      expect(
        await AuditLogEntry.db.count(
          db,
          where: (a) => a.action.equals('content.cover_attached'),
        ),
        2,
      );

      // Run again: the covers stay, nothing is replaced.
      await store.put(
        '${contentImagesPrefix}herb-kuku.jpg',
        jpeg,
        'image/jpeg',
      );
      final again = await runAttachContentImagesTask(
        db,
        'first-admin@example.com',
      );
      expect(again, startsWith('Attached 0 covers and 0 videos.'));
      expect(again, contains('herb-kuku (has a cover)'));
    });

    test('the task attaches exercise videos, creating the item', () async {
      await team();
      final db = sessionBuilder.build();
      final store = MemoryMediaStore();
      final before = Media.instance;
      final cleaner = VideoCleaner.instance;
      Media.instance = Media(store, publicBaseUrl: 'https://media.test');
      VideoCleaner.instance = _FakeCleaner();
      addTearDown(() {
        Media.instance = before;
        VideoCleaner.instance = cleaner;
      });
      final mp4 = Uint8List.fromList(List.filled(64, 1));
      await store.put('${contentImagesPrefix}squat.mp4', mp4, 'video/mp4');
      await store.put('${contentImagesPrefix}bad.mp4', mp4, 'video/mp4');
      Map<String, Object?> entry(String slug, String file) => {
        'kind': 'exercise',
        'slug': slug,
        'file': file,
        'media': 'video',
        'alt': {'az': 'Video az', 'ru': 'Video ru', 'en': 'Video en'},
      };
      await store.put(
        contentImagesManifest,
        Uint8List.fromList(
          utf8.encode(
            jsonEncode([
              entry('squat', 'squat.mp4'),
              entry('fy_brow_lift', 'bad.mp4'),
              entry('not_an_exercise', 'squat.mp4'),
            ]),
          ),
        ),
        'application/json',
      );
      final result = await runAttachContentImagesTask(
        db,
        'first-admin@example.com',
      );
      expect(result, startsWith('Attached 0 covers and 1 videos.'));
      expect(result, contains('fy_brow_lift (not a valid video)'));
      expect(result, contains('not_an_exercise (no item)'));

      final squat = (await ContentItem.db.findFirstRow(
        db,
        where: (t) => t.kind.equals('exercise') & t.slug.equals('squat'),
      ))!;
      expect(squat.status, ContentStatus.published);
      final json = jsonDecode(squat.publishedJson!) as Map<String, Object?>;
      expect((json['name'] as Map)['az'], isNotEmpty);
      final asset = (await MediaAsset.db.findById(db, json['video']! as int))!;
      expect(asset.mediaType, MediaRules.video);
      expect((asset.pixelWidth, asset.pixelHeight), (540, 720));
      expect(asset.public, isTrue);
      expect(
        store.objects.keys,
        contains(Media.publicKey(asset.key, video: true)),
      );
      final published = await endpoints.content.published(
        sessionBuilder,
        'exercise',
      );
      expect(published.single.video?.pixelHeight, 720);

      // Run again: the video stays.
      await store.put('${contentImagesPrefix}squat.mp4', mp4, 'video/mp4');
      final again = await runAttachContentImagesTask(
        db,
        'first-admin@example.com',
      );
      expect(again, contains('squat (has a video)'));
    });

    test('an edited writing plan is still replaced by the task', () async {
      final t = await team();
      final db = sessionBuilder.build();
      final plan = contentSeed.firstWhere(
        (s) => s.slug == 'sunglasses-hats-uv',
      );
      final now = DateTime.now().toUtc();
      final row = await ContentItem.db.insertRow(
        db,
        ContentItem(
          kind: plan.kind,
          slug: plan.slug,
          category: plan.category,
          status: ContentStatus.draft,
          draftJson: plan.json,
          createdBy: UuidValue.fromString(
            '00000000-0000-4000-8000-000000000001',
          ),
          updatedBy: UuidValue.fromString(
            '00000000-0000-4000-8000-000000000001',
          ),
          createdAt: now,
          updatedAt: now,
        ),
      );
      // Edited in the panel: still the plan, with another reading time.
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        row.id!,
        jsonEncode({
          ...jsonDecode(plan.json) as Map<String, Object?>,
          'minutes': 7,
        }),
        plan.category,
      );
      final result = await runPublishImportedTask(
        db,
        'first-admin@example.com',
      );
      expect(result, contains('refilled 1 plans'));
      final live = await endpoints.content.published(sessionBuilder, 'article');
      final sun = live.singleWhere((a) => a.slug == 'sunglasses-hats-uv');
      expect(sun.json, isNot(contains(ContentRules.planMarker)));
      expect(live, hasLength(blogSeed.length));
    });

    test('the task restores a named article in full on request', () async {
      await team();
      final db = sessionBuilder.build();
      final plan = contentSeed.firstWhere(
        (s) => s.slug == 'sunglasses-hats-uv',
      );
      final json = jsonDecode(plan.json) as Map<String, Object?>;
      final now = DateTime.now().toUtc();
      final staffId = UuidValue.fromString(
        '00000000-0000-4000-8000-000000000001',
      );
      // Edited in the panel (the plan text gone, unfinished) and sent for
      // review: neither the import nor the refill touches it.
      await ContentItem.db.insertRow(
        db,
        ContentItem(
          kind: plan.kind,
          slug: plan.slug,
          category: plan.category,
          status: ContentStatus.inReview,
          draftJson: jsonEncode({
            ...json,
            'body': {'az': 'Qısa qeyd'},
          }),
          createdBy: staffId,
          updatedBy: staffId,
          createdAt: now,
          updatedAt: now,
        ),
      );
      final first = await runPublishImportedTask(
        db,
        'first-admin@example.com',
      );
      expect(first, contains('refilled 0 plans'));
      expect(
        await endpoints.content.published(sessionBuilder, 'article'),
        hasLength(blogSeed.length - 1),
      );

      final result = await runPublishImportedTask(
        db,
        'first-admin@example.com',
        restore: {'sunglasses-hats-uv', 'not-an-article'},
      );
      expect(
        result,
        'Imported or filled 0 items, refilled 0 plans, published 1. '
        'Restored 1: sunglasses-hats-uv.',
      );
      final live = await endpoints.content.published(sessionBuilder, 'article');
      expect(live, hasLength(blogSeed.length));
      final sun = live.singleWhere((a) => a.slug == 'sunglasses-hats-uv');
      expect(sun.json, isNot(contains('Qısa qeyd')));
      // Published now: a second run leaves it alone.
      expect(
        await runPublishImportedTask(
          db,
          'first-admin@example.com',
          restore: {'sunglasses-hats-uv'},
        ),
        'Imported or filled 0 items, refilled 0 plans, published 0. '
        'Restored none.',
      );
    });

    test('catalogue texts: known ids, review flow, hiding at once', () async {
      final t = await team();
      await expectLater(
        endpoints.contentAdmin.create(
          t.editor,
          'preference',
          'made-up',
          'catalogue',
        ),
        throwsA(_error(ContentErrors.invalid)),
      );
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'preference',
        'fragrance_free',
        'catalogue',
      );
      // Logic fields are not editable here.
      await expectLater(
        endpoints.contentAdmin.saveDraft(
          t.editor,
          item.id,
          jsonEncode({
            'name': _l('Ətirsiz'),
            'contains': ['parfum'],
          }),
          'catalogue',
        ),
        throwsA(_error(ContentErrors.invalid)),
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        jsonEncode({'name': _l('Ətirsiz'), 'hint': _l('Ətir yoxdur')}),
        'catalogue',
      );
      await endpoints.contentAdmin.submitForReview(t.editor, item.id);
      await endpoints.contentAdmin.approve(t.expert, item.id);
      await endpoints.contentAdmin.publish(t.editor, item.id);
      var public = await endpoints.content.published(
        sessionBuilder,
        'preference',
      );
      expect(public.single.hidden, isFalse);
      expect(
        jsonDecode(public.single.json),
        containsPair('name', _l('Ətirsiz')),
      );

      // Hiding needs no review and also lists unpublished items.
      final other = await endpoints.contentAdmin.create(
        t.editor,
        'step',
        'face-toner',
        'catalogue',
      );
      await expectLater(
        endpoints.contentAdmin.setHidden(t.expert, other.id, true),
        throwsA(_error(StaffErrors.forbidden)),
      );
      final hidden = await endpoints.contentAdmin.setHidden(
        t.editor,
        other.id,
        true,
      );
      expect(hidden.hidden, isTrue);
      public = await endpoints.content.published(sessionBuilder, 'step');
      expect(public.single.slug, 'face-toner');
      expect(public.single.hidden, isTrue);
      expect(public.single.json, '{}');

      await endpoints.contentAdmin.setHidden(t.editor, other.id, false);
      expect(
        await endpoints.content.published(sessionBuilder, 'step'),
        isEmpty,
      );

      // Articles cannot be hidden this way.
      final article = await endpoints.contentAdmin.create(
        t.editor,
        'article',
        'qis',
        'care',
      );
      await expectLater(
        endpoints.contentAdmin.setHidden(t.editor, article.id, true),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
    });

    test('banners: admins publish their own; editors need an admin; brand '
        'campaigns need an expert', () async {
      final t = await team();
      Map<String, Object?> banner({String? sponsor}) => {
        'title': _l('Yeni bölmə'),
        'link': 'nutrition',
        'startsOn': '2026-12-01',
        'endsOn': '2026-12-31',
        'sponsor': ?sponsor,
      };

      // An admin publishes the team's own banner directly.
      final own = await endpoints.contentAdmin.create(
        t.admin,
        'banner',
        'qidalanma',
        'today',
      );
      await endpoints.contentAdmin.saveDraft(
        t.admin,
        own.id,
        jsonEncode(banner()),
        'today',
      );
      expect(
        (await endpoints.contentAdmin.publish(t.admin, own.id)).live,
        isTrue,
      );

      // An editor's banner needs an admin's approval; experts do not
      // review the team's own banners.
      final ed = await endpoints.contentAdmin.create(
        t.editor,
        'banner',
        'yeni-il',
        'discover',
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        ed.id,
        jsonEncode(banner()),
        'discover',
      );
      await expectLater(
        endpoints.contentAdmin.publish(t.editor, ed.id),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
      await endpoints.contentAdmin.submitForReview(t.editor, ed.id);
      await expectLater(
        endpoints.contentAdmin.approve(t.expert, ed.id),
        throwsA(_error(StaffErrors.forbidden)),
      );
      await endpoints.contentAdmin.approve(t.admin, ed.id);
      await endpoints.contentAdmin.publish(t.editor, ed.id);

      // A brand campaign: only an expert approves, and an admin cannot
      // skip that.
      final ad = await endpoints.contentAdmin.create(
        t.admin,
        'banner',
        'brand-x',
        'discover',
      );
      await endpoints.contentAdmin.saveDraft(
        t.admin,
        ad.id,
        jsonEncode(banner(sponsor: 'Brand X')),
        'discover',
      );
      await expectLater(
        endpoints.contentAdmin.publish(t.admin, ad.id),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
      await endpoints.contentAdmin.submitForReview(t.admin, ad.id);
      await expectLater(
        endpoints.contentAdmin.approve(t.admin, ad.id),
        throwsA(_error(StaffErrors.forbidden)),
      );
      await endpoints.contentAdmin.approve(t.expert, ad.id);
      await endpoints.contentAdmin.publish(t.admin, ad.id);

      final public = await endpoints.content.published(
        sessionBuilder,
        'banner',
      );
      expect(public.map((p) => p.slug).toSet(), {
        'qidalanma',
        'yeni-il',
        'brand-x',
      });
      expect(
        jsonDecode(public.singleWhere((p) => p.slug == 'brand-x').json),
        containsPair('sponsor', 'Brand X'),
      );
    });
  });
}

/// Turns every upload but the second into a 540×720 portrait video.
class _FakeCleaner implements VideoCleaner {
  var _calls = 0;

  @override
  Future<CleanVideo?> clean(Uint8List upload) async =>
      ++_calls == 2 ? null : CleanVideo(upload, 540, 720, 8000);
}
