import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

void main() {
  test('the current consent texts exist in every interface language', () {
    for (final kind in ConsentKind.values) {
      final text = currentConsentText(kind);
      for (final language in interfaceLanguages) {
        expect(text.bodyFor(language), isNotEmpty, reason: '$kind $language');
        expect(text.languageFor(language), language);
      }
    }
  });

  test('the new versions keep the az, ru and en texts word for word', () {
    const before = {
      ConsentKind.health: 'health-2026-11-draft5',
      ConsentKind.analytics: 'analytics-2026-11-draft1',
      ConsentKind.marketing: 'marketing-2026-11-draft1',
    };
    for (final e in before.entries) {
      final old = consentTextByVersion(e.key, e.value)!;
      final now = currentConsentText(e.key);
      expect(now.version, isNot(old.version));
      for (final language in supportedLanguages) {
        expect(now.hashFor(language), old.hashFor(language));
      }
    }
    // The new health version covers the same data as the one before.
    const v = 'health-2026-11-draft6';
    expect(healthVersionsCoveringOwnRoutines, contains(v));
    expect(healthVersionsCoveringCareList, contains(v));
    expect(healthVersionsCoveringSport, contains(v));
    expect(healthVersionsCoveringNutrition, contains(v));
  });

  test('an older text falls back to the closest language', () {
    final old = consentTextByVersion(
      ConsentKind.health,
      'health-2026-11-draft5',
    )!;
    expect(old.languageFor('tr'), 'az');
    expect(old.languageFor('kk'), 'ru');
    expect(old.languageFor('ka'), 'en');
    expect(old.languageFor('ru'), 'ru');
  });
}
