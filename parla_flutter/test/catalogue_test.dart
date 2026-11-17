import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/check/preference_ui.dart';
import 'package:parla/discover/content_library.dart';
import 'package:parla/home/routine.dart';
import 'package:parla/l10n/app_localizations.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/sport/exercise_text.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';

Map<String, String> _l(String s) => {
  'az': '$s az',
  'ru': '$s ru',
  'en': '$s en',
};

PublishedItem _item(
  String kind,
  String slug, {
  Map<String, Object?> data = const {},
  bool hidden = false,
}) => PublishedItem(
  id: slug.hashCode,
  kind: kind,
  slug: slug,
  category: 'catalogue',
  data: data,
  publishedAt: DateTime.utc(2026, 11, 16),
  hidden: hidden,
);

void main() {
  late FakeApi api;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    api = FakeApi();
    api.published.addAll({
      'preference': [
        _item(
          'preference',
          'fragrance_free',
          data: {'name': _l('No perfume'), 'hint': _l('Nothing added')},
        ),
        _item('preference', 'alcohol_free', hidden: true),
      ],
      'exercise': [
        _item(
          'exercise',
          'squat',
          data: {'name': _l('Team squat'), 'how': _l('Sit back')},
        ),
      ],
      'step': [
        _item(
          'step',
          'face-cleanser-am',
          data: {'title': _l('Wash'), 'how': _l('Lukewarm water')},
        ),
        _item('step', 'face-toner', hidden: true),
      ],
    });
    await ContentLibrary(api).loadCatalogue();
  });

  test('published team texts replace the app texts', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(preferenceLabel(l10n, 'fragrance_free'), 'No perfume en');
    expect(preferenceHint(l10n, 'fragrance_free'), 'Nothing added en');
    // Without team text the app's own text stays.
    expect(preferenceLabel(l10n, 'vegan'), 'Vegan');

    expect(exerciseText('squat', 'ru'), ('Team squat ru', 'Sit back ru'));
    // The team's version has no caution, so none is shown.
    expect(exerciseCaution('squat', 'en'), isNull);
    expect(exerciseText('glute_bridge', 'en').$1, isNot(contains('Team')));

    final steps = routineSteps(['face-cleanser-am'], 'az');
    expect(steps.single.title, 'Wash az');
    expect(steps.single.meta, 'Lukewarm water az');
  });

  test('hidden items are left out', () {
    expect(ContentLibrary.hiddenIds('preference'), {'alcohol_free'});
    expect(ContentLibrary.hiddenIds('step'), {'face-toner'});
    expect(
      routineSteps(['face-cleanser-am', 'face-toner'], 'en').map((s) => s.id),
      ['face-cleanser-am'],
    );
    expect(ContentLibrary.hiddenIds('exercise'), isEmpty);
  });

  test('the catalogue is kept for offline use', () async {
    api.contentError = 'down';
    final offline = ContentLibrary(api);
    await offline.loadCatalogue();
    expect(offline.offline, isTrue);
    expect(ContentLibrary.hiddenIds('step'), {'face-toner'});
    expect(
      ContentLibrary.catalogueText('exercise', 'squat', 'name', 'en'),
      'Team squat en',
    );
  });

  test('every catalogue id has app text to fall back on', () {
    for (final kind in [
      ContentKind.preference,
      ContentKind.exercise,
      ContentKind.step,
    ]) {
      for (final id in ContentRules.catalogueIds(kind)) {
        expect(
          ContentRules.catalogueDefaults(kind, id),
          isNotEmpty,
          reason: '$kind $id',
        );
      }
    }
  });
}
