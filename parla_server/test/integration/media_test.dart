import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/content/content_admin_endpoint.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/media/media_admin_endpoint.dart';
import 'package:parla_server/src/media/media_store.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
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

/// A JPEG of [w]×[h] carrying camera and GPS metadata.
ByteData _photo({int w = 40, int h = 30}) {
  final image = img.Image(width: w, height: h);
  img.fill(image, color: img.ColorRgb8(200, 150, 120));
  image.exif.imageIfd['Make'] = img.IfdValueAscii('PhoneMaker');
  image.exif.gpsIfd['GPSLatitude'] = img.IfdValueRational(40, 1);
  final bytes = img.encodeJpg(image);
  return ByteData.sublistView(bytes);
}

void main() {
  late MemoryMediaStore store;

  setUp(() {
    store = MemoryMediaStore();
    Media.instance = Media(store, publicBaseUrl: 'https://media.test');
  });

  withServerpod('Given content images', (sessionBuilder, endpoints) {
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

    test('uploads are re-encoded without metadata and kept private', () async {
      final t = await team();
      final original = _photo();
      expect(
        img.decodeJpgExif(original.buffer.asUint8List())!.gpsIfd.isEmpty,
        isFalse,
      );
      final item = await endpoints.mediaAdmin.upload(
        t.editor,
        original,
        'Own photo',
        null,
        jsonEncode({'az': 'Yulaf'}),
      );
      expect(item.public, isFalse);
      expect((item.pixelWidth, item.pixelHeight), (40, 30));
      expect(store.objects.keys.single, startsWith('uploads/'));
      final stored = store.objects.values.single;
      final exif = img.decodeJpgExif(stored);
      expect(
        exif == null || (exif.gpsIfd.isEmpty && exif.imageIfd.isEmpty),
        isTrue,
      );

      final preview = await endpoints.mediaAdmin.preview(t.expert, item.id);
      expect(preview.lengthInBytes, stored.length);

      // Large images are shrunk.
      final big = await endpoints.mediaAdmin.upload(
        t.editor,
        _photo(w: 3200, h: 1600),
        'Own photo',
        null,
        '{}',
      );
      expect((big.pixelWidth, big.pixelHeight), (1600, 800));
    });

    test('bad uploads and roles are refused', () async {
      final t = await team();
      await expectLater(
        endpoints.mediaAdmin.upload(
          t.editor,
          ByteData.sublistView(Uint8List.fromList(utf8.encode('<svg/>'))),
          'x',
          null,
          '{}',
        ),
        throwsA(_error(MediaErrors.notImage)),
      );
      await expectLater(
        endpoints.mediaAdmin.upload(t.editor, _photo(), ' ', null, '{}'),
        throwsA(_error(MediaErrors.invalid)),
      );
      await expectLater(
        endpoints.mediaAdmin.upload(t.expert, _photo(), 'x', null, '{}'),
        throwsA(_error(StaffErrors.forbidden)),
      );
    });

    test('an image goes public with its article and back', () async {
      final t = await team();
      final image = await endpoints.mediaAdmin.upload(
        t.editor,
        _photo(),
        'Own photo',
        null,
        jsonEncode({'az': 'Krem'}),
      );
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'article',
        'krem',
        'care',
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        jsonEncode({
          'title': _l('Krem'),
          'summary': _l('Qısa'),
          'body': _l('Mətn'),
          'minutes': 3,
          'image': image.id,
        }),
        'care',
      );
      await endpoints.contentAdmin.submitForReview(t.editor, item.id);
      await endpoints.contentAdmin.approve(t.expert, item.id);
      // Alt text only in Azerbaijani: not ready to publish.
      await expectLater(
        endpoints.contentAdmin.publish(t.editor, item.id),
        throwsA(_error(ContentErrors.imageIncomplete)),
      );
      await endpoints.mediaAdmin.update(
        t.editor,
        image.id,
        'Own photo',
        'Parla team',
        jsonEncode(_l('Krem')),
      );
      await endpoints.contentAdmin.publish(t.editor, item.id);
      final key = (await MediaAsset.db.findById(
        sessionBuilder.build(),
        image.id,
      ))!.key;
      expect(store.objects.containsKey('public/$key.jpg'), isTrue);
      final public = await endpoints.content.published(
        sessionBuilder,
        'article',
      );
      expect(public.single.image!.url, 'https://media.test/$key.jpg');
      expect(jsonDecode(public.single.image!.altJson), _l('Krem'));

      // In use: cannot be deleted; once a published image, the alt text
      // must stay complete.
      await expectLater(
        endpoints.mediaAdmin.delete(t.admin, image.id),
        throwsA(_error(MediaErrors.inUse)),
      );
      await expectLater(
        endpoints.mediaAdmin.update(
          t.editor,
          image.id,
          'Own photo',
          null,
          jsonEncode({'az': 'Krem'}),
        ),
        throwsA(_error(MediaErrors.invalid)),
      );

      await endpoints.contentAdmin.unpublish(t.editor, item.id);
      expect(store.objects.containsKey('public/$key.jpg'), isFalse);
      expect(
        (await endpoints.mediaAdmin.list(t.admin)).single.public,
        isFalse,
      );
    });

    test('a draft may only point to an existing image', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'recipe',
        'oats',
        'breakfast',
      );
      await expectLater(
        endpoints.contentAdmin.saveDraft(
          t.editor,
          item.id,
          jsonEncode({'image': 999}),
          'breakfast',
        ),
        throwsA(_error(ContentErrors.invalid)),
      );
    });

    test('unused images can be deleted by admins', () async {
      final t = await team();
      final image = await endpoints.mediaAdmin.upload(
        t.editor,
        _photo(),
        'Own photo',
        null,
        '{}',
      );
      await expectLater(
        endpoints.mediaAdmin.delete(t.editor, image.id),
        throwsA(_error(StaffErrors.forbidden)),
      );
      await endpoints.mediaAdmin.delete(t.admin, image.id);
      expect(store.objects, isEmpty);
      expect(await endpoints.mediaAdmin.list(t.admin), isEmpty);
    });

    test(
      'images inside an article body are checked and published too',
      () async {
        final t = await team();
        final cover = await endpoints.mediaAdmin.upload(
          t.editor,
          _photo(),
          'Own photo',
          null,
          jsonEncode(_l('Örtük')),
        );
        final inline = await endpoints.mediaAdmin.upload(
          t.editor,
          _photo(),
          'Own photo',
          null,
          jsonEncode({'az': 'Addım'}),
        );
        final item = await endpoints.contentAdmin.create(
          t.editor,
          'article',
          'addimlar',
          'care',
        );
        await expectLater(
          endpoints.contentAdmin.saveDraft(
            t.editor,
            item.id,
            jsonEncode({
              'body': {'az': '![x](media:99999)'},
            }),
            'care',
          ),
          throwsA(_error(ContentErrors.invalid)),
        );
        final body = _l('Mətn');
        body['az'] = '## Addımlar\n\n![Addım](media:${inline.id})\n\nSon.';
        await endpoints.contentAdmin.saveDraft(
          t.editor,
          item.id,
          jsonEncode({
            'title': _l('Addımlar'),
            'summary': _l('Qısa'),
            'body': body,
            'minutes': 3,
            'image': cover.id,
            'tags': {
              'az': ['qulluq'],
            },
          }),
          'care',
        );
        await endpoints.contentAdmin.submitForReview(t.editor, item.id);
        await endpoints.contentAdmin.approve(t.expert, item.id);
        // The inline image lacks ru/en alt text.
        await expectLater(
          endpoints.contentAdmin.publish(t.editor, item.id),
          throwsA(_error(ContentErrors.imageIncomplete)),
        );
        await endpoints.mediaAdmin.update(
          t.editor,
          inline.id,
          'Own photo',
          null,
          jsonEncode(_l('Addım')),
        );
        await endpoints.contentAdmin.publish(t.editor, item.id);
        final public = (await endpoints.content.published(
          sessionBuilder,
          'article',
        )).single;
        expect(public.image!.id, cover.id);
        expect(public.inlineImages!.single.id, inline.id);
        expect(
          public.inlineImages!.single.url,
          startsWith('https://media.test/'),
        );
        expect(
          store.objects.keys.where((k) => k.startsWith('public/')),
          hasLength(2),
        );
      },
    );
  });
}
