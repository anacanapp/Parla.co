import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:parla_server/src/content/content_admin_endpoint.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/media/media_admin_endpoint.dart';
import 'package:parla_server/src/media/media_store.dart';
import 'package:parla_server/src/media/video_processing.dart';
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

/// Whether ffmpeg is installed (it is in the server image and in CI).
final _hasFfmpeg = () {
  try {
    return Process.runSync('ffmpeg', ['-version']).exitCode == 0;
  } on ProcessException {
    return false;
  }
}();

/// A 2-second 1280×720 MOV with sound and location, title and date
/// metadata, made with ffmpeg.
Future<Uint8List> _phoneVideo() async {
  final dir = await Directory.systemTemp.createTemp('parla-video-test');
  try {
    final out = '${dir.path}/clip.mov';
    final r = await Process.run('ffmpeg', [
      '-loglevel', 'error', //
      '-f', 'lavfi', '-i', 'testsrc=size=1280x720:rate=30',
      '-f', 'lavfi', '-i', 'sine=frequency=440',
      '-t', '2',
      '-metadata', 'location=+40.4093+049.8671/',
      '-metadata', 'title=Secret name',
      '-metadata', 'creation_time=2026-11-20T10:00:00Z',
      '-metadata:s:a:0', 'title=Secret track',
      '-c:v', 'libx264', '-c:a', 'aac', out,
    ]);
    expect(r.exitCode, 0, reason: '${r.stderr}');
    return await File(out).readAsBytes();
  } finally {
    await dir.delete(recursive: true);
  }
}

/// ffprobe's view of an MP4: streams and tags.
Future<Map<String, Object?>> _probe(Uint8List mp4) async {
  final dir = await Directory.systemTemp.createTemp('parla-video-probe');
  try {
    final f = File('${dir.path}/x.mp4')..writeAsBytesSync(mp4);
    final r = await Process.run('ffprobe', [
      '-v', 'error', //
      '-show_streams', '-show_format', '-of', 'json', f.path,
    ]);
    return jsonDecode(r.stdout as String) as Map<String, Object?>;
  } finally {
    await dir.delete(recursive: true);
  }
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

    group('videos', skip: _hasFfmpeg ? null : 'ffmpeg is not installed', () {
      setUp(() => VideoCleaner.instance = FfmpegVideoCleaner());

      Future<MediaAdminItem> upload(
        TestSessionBuilder who,
        Uint8List bytes, {
        String upload = '1b2c3d4e-5f60-4a1b-9c2d-3e4f5a6b7c8d',
        int chunk = 16 * 1024,
      }) async {
        var n = 0;
        for (var at = 0; at < bytes.length; at += chunk, n++) {
          final end = at + chunk > bytes.length ? bytes.length : at + chunk;
          await endpoints.mediaAdmin.uploadVideoChunk(
            who,
            upload,
            n,
            ByteData.sublistView(bytes, at, end),
          );
        }
        return endpoints.mediaAdmin.finishVideoUpload(
          who,
          upload,
          n,
          'Own video',
          null,
          jsonEncode(_l('Squat')),
        );
      }

      test('a video is re-encoded with its sound but no metadata and '
          'joins an exercise', () async {
        final t = await team();
        final clip = await _phoneVideo();
        expect(clip.length, greaterThan(16 * 1024));
        final video = await upload(t.editor, clip);
        expect(video.mediaType, 'video');
        // 16:9 shrunk to 720 wide; the height is rounded to an even number.
        expect(video.pixelWidth, 720);
        expect(video.pixelHeight, inInclusiveRange(404, 406));
        expect(video.durationMs, inInclusiveRange(1900, 2100));
        // Chunks are gone; only the cleaned video is kept, privately.
        expect(
          store.objects.keys.single,
          'uploads/${(await MediaAsset.db.findById(sessionBuilder.build(), video.id))!.key}.mp4',
        );

        final probe = await _probe(store.objects.values.single);
        final streams = probe['streams']! as List;
        // Its sound is kept as AAC (owner 2026-11-24); nothing else.
        expect(
          [for (final s in streams) (s as Map)['codec_type']],
          ['video', 'audio'],
        );
        expect((streams[1] as Map)['codec_name'], 'aac');
        final tags = jsonEncode([
          (probe['format']! as Map)['tags'],
          for (final s in streams) (s as Map)['tags'],
        ]);
        expect(tags, isNot(contains('40.4093')));
        expect(tags, isNot(contains('Secret')));
        expect(tags, isNot(contains('2026-11-20')));

        // The panel's preview returns it to any team member.
        final preview = await endpoints.mediaAdmin.preview(t.expert, video.id);
        expect(preview.lengthInBytes, video.bytes);

        // An image cannot stand in for the video, nor the other way round.
        final photo = await endpoints.mediaAdmin.upload(
          t.editor,
          _photo(),
          'Own photo',
          null,
          jsonEncode(_l('Squat')),
        );
        final item = await endpoints.contentAdmin.create(
          t.editor,
          'exercise',
          'squat',
          'catalogue',
        );
        Future<void> save(Map<String, Object?> media) =>
            endpoints.contentAdmin.saveDraft(
              t.editor,
              item.id,
              jsonEncode({'name': _l('Squat'), 'how': _l('Aşağı'), ...media}),
              'catalogue',
            );
        await expectLater(
          save({'video': photo.id}),
          throwsA(_error(ContentErrors.invalid)),
        );
        await expectLater(
          save({'image': video.id}),
          throwsA(_error(ContentErrors.invalid)),
        );
        await save({'image': photo.id, 'video': video.id});
        await endpoints.contentAdmin.submitForReview(t.editor, item.id);
        await endpoints.contentAdmin.approve(t.expert, item.id);
        await endpoints.contentAdmin.publish(t.editor, item.id);

        final public = (await endpoints.content.published(
          sessionBuilder,
          'exercise',
        )).single;
        expect(public.video!.url, endsWith('.mp4'));
        expect(public.video!.id, video.id);
        expect(public.image!.url, endsWith('.jpg'));
        expect(
          store.objects.keys.where((k) => k.startsWith('public/')).toSet(),
          hasLength(2),
        );
        // In use: it cannot be deleted.
        await expectLater(
          endpoints.mediaAdmin.delete(t.admin, video.id),
          throwsA(_error(MediaErrors.inUse)),
        );
      });

      test('bad video uploads are refused and leave nothing behind', () async {
        final t = await team();
        // Not a video (a playlist naming a URL): refused before ffmpeg.
        await expectLater(
          upload(
            t.editor,
            Uint8List.fromList(utf8.encode('#EXTM3U\nhttp://example.com/x')),
          ),
          throwsA(_error(MediaErrors.notVideo)),
        );
        // A missing chunk.
        await endpoints.mediaAdmin.uploadVideoChunk(
          t.editor,
          '2b2c3d4e-5f60-4a1b-9c2d-3e4f5a6b7c8d',
          1,
          ByteData(4),
        );
        await expectLater(
          endpoints.mediaAdmin.finishVideoUpload(
            t.editor,
            '2b2c3d4e-5f60-4a1b-9c2d-3e4f5a6b7c8d',
            2,
            'x',
            null,
            '{}',
          ),
          throwsA(_error(MediaErrors.invalid)),
        );
        // Odd ids, chunks too large, experts.
        await expectLater(
          endpoints.mediaAdmin.uploadVideoChunk(
            t.editor,
            '../x',
            0,
            ByteData(4),
          ),
          throwsA(_error(MediaErrors.invalid)),
        );
        await expectLater(
          endpoints.mediaAdmin.uploadVideoChunk(
            t.editor,
            '3b2c3d4e-5f60-4a1b-9c2d-3e4f5a6b7c8d',
            0,
            ByteData(MediaRules.videoChunkBytes + 1),
          ),
          throwsA(_error(MediaErrors.invalid)),
        );
        await expectLater(
          endpoints.mediaAdmin.uploadVideoChunk(
            t.expert,
            '3b2c3d4e-5f60-4a1b-9c2d-3e4f5a6b7c8d',
            0,
            ByteData(4),
          ),
          throwsA(_error(StaffErrors.forbidden)),
        );
        expect(store.objects, isEmpty);
        expect(
          await MediaAsset.db.count(sessionBuilder.build()),
          0,
        );
      });
    });
  });
}
