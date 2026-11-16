import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:parla/app.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/screens/quiz_screen.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/skin/skin_analysis_screen.dart';
import 'package:parla/skin/skin_photo_analysis.dart';
import 'package:parla/state/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';

/// A synthetic 200×260 "face": an even skin tone with fine noise so it is
/// not blurry. [paint] changes single pixels on top.
img.Image _face({
  int r = 205,
  int g = 160,
  int b = 135,
  int noise = 2,
  void Function(img.Image image, int x, int y)? paint,
}) {
  final random = Random(7);
  final image = img.Image(width: 200, height: 260);
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      int n() => random.nextInt(noise * 2 + 1) - noise;
      image.setPixelRgb(
        x,
        y,
        (r + n()).clamp(0, 255),
        (g + n()).clamp(0, 255),
        (b + n()).clamp(0, 255),
      );
      paint?.call(image, x, y);
    }
  }
  return image;
}

/// Bright, colourless shine spots on a grid inside [inRegion].
void Function(img.Image, int, int) _shine(
  bool Function(int x, int y) inRegion,
) => (image, x, y) {
  if (inRegion(x, y) && x % 4 == 0 && y % 4 == 0) {
    image.setPixelRgb(x, y, 250, 248, 246);
  }
};

// Region tests in the 200×260 image (oval centre 100,130; rx 60, ry 97.5).
bool _tZone(int x, int y) =>
    ((x - 100).abs() < 28 && y > 50 && y < 85) ||
    ((x - 100).abs() < 8 && y > 105 && y < 148);
bool _cheeks(int x, int y) {
  final d = (x - 100).abs();
  return d > 22 && d < 46 && y > 122 && y < 162;
}

void main() {
  group('analyseSkinPixels', () {
    test('even skin: usable, normal, nothing stands out', () {
      final r = analyseSkinPixels(_face());
      expect(r.ok, isTrue);
      expect(r.skinType, 'normal');
      expect(r.concerns, isEmpty);
    });

    test('a dark photo asks for a retake', () {
      final r = analyseSkinPixels(_face(r: 40, g: 30, b: 25));
      expect(r.problem, PhotoProblem.tooDark);
      expect(r.skinType, isNull);
      expect(r.concerns, isEmpty);
    });

    test('a washed-out photo asks for a retake', () {
      expect(
        analyseSkinPixels(_face(r: 252, g: 250, b: 248)).problem,
        PhotoProblem.tooBright,
      );
    });

    test('a photo without detail counts as blurry', () {
      expect(analyseSkinPixels(_face(noise: 0)).problem, PhotoProblem.blurry);
    });

    test('shine in the T-zone only suggests combination', () {
      final r = analyseSkinPixels(_face(paint: _shine(_tZone)));
      expect(r.ok, isTrue);
      expect(r.skinType, 'combination');
    });

    test('shine in the T-zone and on the cheeks suggests oily', () {
      final r = analyseSkinPixels(
        _face(paint: _shine((x, y) => _tZone(x, y) || _cheeks(x, y))),
      );
      expect(r.skinType, 'oily');
    });

    test('redder cheeks than forehead suggest redness', () {
      final r = analyseSkinPixels(
        _face(
          paint: (image, x, y) {
            if (_cheeks(x, y)) {
              final p = image.getPixel(x, y);
              image.setPixelRgb(x, y, 225, p.g.toInt() - 30, p.b.toInt() - 15);
            }
          },
        ),
      );
      expect(r.concerns, contains('redness'));
    });

    test('rough cheek texture suggests pores', () {
      final r = analyseSkinPixels(
        _face(
          paint: (image, x, y) {
            if (_cheeks(x, y) && (x + y).isEven) {
              image.setPixelRgb(x, y, 170, 128, 108);
            }
          },
        ),
      );
      expect(r.concerns, contains('pores'));
      expect(r.concerns, isNot(contains('redness')));
    });

    test('dry is never suggested from a photo', () {
      for (final image in [
        _face(),
        _face(paint: _shine(_tZone)),
        _face(r: 230, g: 200, b: 185),
      ]) {
        expect(analyseSkinPixels(image).skinType, isNot('dry'));
      }
    });
  });

  group('analyseSkinPhoto', () {
    test('decodes an encoded photo', () {
      final bytes = img.encodePng(_face(paint: _shine(_tZone)));
      expect(analyseSkinPhoto(bytes).skinType, 'combination');
    });

    test('unreadable bytes ask for a retake', () {
      expect(
        analyseSkinPhoto(Uint8List.fromList([1, 2, 3])).problem,
        PhotoProblem.unreadable,
      );
    });
  });

  group('skin analysis screen', () {
    late List<Uint8List> analysed;

    setUp(() {
      analysed = [];
      SkinAnalysisScreen.analyse = (bytes) async {
        analysed.add(bytes);
        return analyseSkinPhoto(bytes);
      };
    });

    tearDown(() {
      SkinAnalysisScreen.takePhoto = (_) async => null;
    });

    Future<FakeApi> open(WidgetTester tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues({'language': 'en'});
      final settings = await AppSettings.load();
      final api = FakeApi()
        ..signedIn = true
        ..profile = const ProfileSummary(countryCode: 'AZ', language: 'en');
      await tester.pumpWidget(
        ParlaApp(
          api: api,
          settings: settings,
          reminderScheduler: FakeReminderScheduler(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find
            .descendant(
              of: find.byType(ParlaNavBar),
              matching: find.byType(InkWell),
            )
            .at(1),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('habits-skin-analysis')));
      await tester.pumpAndSettle();
      return api;
    }

    testWidgets('the question path opens the quiz without prefill', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Skin analysis'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('skin-by-questions')));
      await tester.pumpAndSettle();
      expect(find.byType(QuizScreen), findsOneWidget);
      expect(find.byKey(const ValueKey('quiz-prefill-note')), findsNothing);
    });

    testWidgets('the photo path needs agreement, then prefills the quiz', (
      tester,
    ) async {
      final photo = img.encodePng(_face(paint: _shine(_tZone)));
      var shots = 0;
      SkinAnalysisScreen.takePhoto = (_) async {
        shots++;
        return photo;
      };
      await open(tester);
      await tester.tap(find.byKey(const ValueKey('skin-by-photo')));
      await tester.pumpAndSettle();
      expect(find.textContaining('not sent to a server'), findsOneWidget);

      // Without the tick the camera does not open.
      await tester.tap(find.text('Take photo'));
      await tester.pumpAndSettle();
      expect(shots, 0);

      await tester.tap(find.byKey(const ValueKey('skin-agree')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take photo'));
      await tester.pumpAndSettle();
      expect(shots, 1);
      expect(analysed, hasLength(1));
      expect(find.text('First suggestion'), findsOneWidget);
      expect(find.textContaining('Combination'), findsOneWidget);
      expect(find.textContaining('already been deleted'), findsOneWidget);

      await tester.tap(find.text('Check in the questions'));
      await tester.pumpAndSettle();
      final quiz = tester.widget<QuizScreen>(find.byType(QuizScreen));
      expect(quiz.prefill, {
        'skin_type': ['combination'],
      });
      expect(find.byKey(const ValueKey('quiz-prefill-note')), findsOneWidget);
    });

    testWidgets('a dark photo asks for a retake and offers questions', (
      tester,
    ) async {
      SkinAnalysisScreen.takePhoto = (_) async =>
          img.encodePng(_face(r: 30, g: 25, b: 20));
      await open(tester);
      await tester.tap(find.byKey(const ValueKey('skin-by-photo')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('skin-agree')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take photo'));
      await tester.pumpAndSettle();
      expect(find.text('The photo is too dark.'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('skin-problem-questions')));
      await tester.pumpAndSettle();
      expect(find.byType(QuizScreen), findsOneWidget);
    });

    testWidgets('backing out of the camera stays on the notice', (
      tester,
    ) async {
      SkinAnalysisScreen.takePhoto = (_) async => null;
      await open(tester);
      await tester.tap(find.byKey(const ValueKey('skin-by-photo')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('skin-agree')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take photo'));
      await tester.pumpAndSettle();
      expect(analysed, isEmpty);
      expect(find.text('About the photo'), findsOneWidget);
    });
  });

  test('the photo code has no network or storage access', () {
    const banned = [
      'parla_api',
      'client.dart',
      'parla_client',
      'package:http',
      'shared_preferences',
      'path_provider',
      'secure_storage',
      'parla_scope',
      'sync/',
    ];
    for (final file in Directory('lib/skin').listSync().whereType<File>()) {
      if (file.path.endsWith('skin_analysis_screen.dart')) continue;
      final imports = file.readAsLinesSync().where(
        (l) => l.startsWith('import') || l.startsWith('export'),
      );
      for (final line in imports) {
        for (final word in banned) {
          expect(line, isNot(contains(word)), reason: file.path);
        }
      }
    }
    // The screen reads only the language from the scope.
    final screen = File(
      'lib/skin/skin_analysis_screen.dart',
    ).readAsStringSync();
    expect(screen, isNot(contains('.api')));
    expect(screen, isNot(contains('parla_api')));
    expect(screen, isNot(contains('sync/')));
  });
}
