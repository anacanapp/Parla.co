import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

void main() {
  final today = DateTime(2026, 11, 11);

  group('checkAge', () {
    test('19 or more years apart is adult without asking', () {
      expect(checkAge(birthYear: 2007, today: today), AgeCheck.adult);
      expect(checkAge(birthYear: 1960, today: today), AgeCheck.adult);
    });

    test('fewer than 18 years apart is minor', () {
      expect(checkAge(birthYear: 2009, today: today), AgeCheck.minor);
      expect(checkAge(birthYear: 2026, today: today), AgeCheck.minor);
    });

    test('turning 18 this year needs the birthday answer', () {
      expect(
        checkAge(birthYear: 2008, today: today),
        AgeCheck.needsBirthdayConfirmation,
      );
      expect(
        checkAge(birthYear: 2008, today: today, birthdayPassedThisYear: true),
        AgeCheck.adult,
      );
      expect(
        checkAge(birthYear: 2008, today: today, birthdayPassedThisYear: false),
        AgeCheck.minor,
      );
    });

    test('years out of range are invalid', () {
      expect(checkAge(birthYear: 1899, today: today), AgeCheck.invalid);
      expect(checkAge(birthYear: 2027, today: today), AgeCheck.invalid);
    });
  });

  group('markets', () {
    test('only Azerbaijan is open in the MVP', () {
      expect(isMarketOpen('AZ'), isTrue);
      expect(isMarketOpen('TR'), isFalse);
      expect(isMarketOpen('RU'), isFalse);
    });
  });

  group('consent texts', () {
    test('every current text exists in every supported language', () {
      for (final kind in ConsentKind.values) {
        final text = currentConsentText(kind);
        for (final language in supportedLanguages) {
          expect(
            text.bodyFor(language),
            isNotEmpty,
            reason: '${text.version} is missing "$language"',
          );
        }
      }
    });

    test('versions are unique', () {
      final versions = consentTextHistory.map((t) => t.version).toList();
      expect(versions.toSet().length, versions.length);
    });

    test('hash is stable SHA-256 hex', () {
      expect(
        consentTextHash('abc'),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
    });

    test('lookup by version', () {
      final current = currentConsentText(ConsentKind.health);
      expect(
        consentTextByVersion(ConsentKind.health, current.version),
        same(current),
      );
      expect(consentTextByVersion(ConsentKind.health, 'nope'), isNull);
    });
  });
}
