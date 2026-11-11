import 'package:parla_server/src/consent/consent_endpoint.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/profile/profile_endpoint.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

TestSessionBuilder _as(TestSessionBuilder builder, String userId) =>
    builder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(userId, {}),
    );

Matcher _parlaError(String code) =>
    isA<ParlaException>().having((e) => e.code, 'code', code);

void main() {
  const alice = '0b6c1f3e-8a4d-4c7e-9f21-3d5a7e9b1c01';
  const bob = '7f2e9d4c-1b3a-4e5f-8c6d-9a0b1c2d3e02';
  final healthVersion = currentConsentText(ConsentKind.health).version;
  final thisYear = DateTime.now().toUtc().year;

  withServerpod('Given the profile endpoint', (sessionBuilder, endpoints) {
    test('an anonymous caller is rejected', () async {
      await expectLater(
        endpoints.profile.me(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('an adult from an open market gets a profile', () async {
      final session = _as(sessionBuilder, alice);
      final profile = await endpoints.profile.create(
        session,
        birthYear: 1995,
        countryCode: 'AZ',
        language: 'az',
      );
      expect(profile.birthYear, 1995);
      expect((await endpoints.profile.me(session))?.id, profile.id);

      final audit = await AuditLogEntry.db.find(
        sessionBuilder.build(),
        where: (t) => t.action.equals('profile.created'),
      );
      expect(audit, hasLength(1));
      expect(audit.single.actorId, UuidValue.fromString(alice));
    });

    test('a minor is refused and nothing is stored', () async {
      final session = _as(sessionBuilder, alice);
      await expectLater(
        endpoints.profile.create(
          session,
          birthYear: thisYear - 16,
          countryCode: 'AZ',
          language: 'az',
        ),
        throwsA(_parlaError(ProfileErrors.ageMinor)),
      );
      expect(await endpoints.profile.me(session), isNull);
    });

    test('turning 18 this year needs the birthday answer', () async {
      final session = _as(sessionBuilder, alice);
      await expectLater(
        endpoints.profile.create(
          session,
          birthYear: thisYear - 18,
          countryCode: 'AZ',
          language: 'az',
        ),
        throwsA(_parlaError(ProfileErrors.ageNeedsConfirmation)),
      );
      await expectLater(
        endpoints.profile.create(
          session,
          birthYear: thisYear - 18,
          birthdayPassedThisYear: false,
          countryCode: 'AZ',
          language: 'az',
        ),
        throwsA(_parlaError(ProfileErrors.ageMinor)),
      );
      final profile = await endpoints.profile.create(
        session,
        birthYear: thisYear - 18,
        birthdayPassedThisYear: true,
        countryCode: 'AZ',
        language: 'az',
      );
      expect(profile.birthYear, thisYear - 18);
    });

    test('a closed market is refused', () async {
      await expectLater(
        endpoints.profile.create(
          _as(sessionBuilder, alice),
          birthYear: 1995,
          countryCode: 'TR',
          language: 'az',
        ),
        throwsA(_parlaError(ProfileErrors.countryClosed)),
      );
    });

    test('an unsupported language is refused', () async {
      await expectLater(
        endpoints.profile.create(
          _as(sessionBuilder, alice),
          birthYear: 1995,
          countryCode: 'AZ',
          language: 'de',
        ),
        throwsA(_parlaError(ProfileErrors.languageUnsupported)),
      );
    });

    test('a second profile for the same user is refused', () async {
      final session = _as(sessionBuilder, alice);
      await endpoints.profile.create(
        session,
        birthYear: 1995,
        countryCode: 'AZ',
        language: 'az',
      );
      await expectLater(
        endpoints.profile.create(
          session,
          birthYear: 1990,
          countryCode: 'AZ',
          language: 'ru',
        ),
        throwsA(_parlaError(ProfileErrors.profileExists)),
      );
    });

    test('users only see their own profile', () async {
      await endpoints.profile.create(
        _as(sessionBuilder, alice),
        birthYear: 1995,
        countryCode: 'AZ',
        language: 'az',
      );
      expect(await endpoints.profile.me(_as(sessionBuilder, bob)), isNull);
    });
  });

  withServerpod('Given the consent endpoint', (sessionBuilder, endpoints) {
    test('every consent starts as not granted', () async {
      final states = await endpoints.consent.current(
        _as(sessionBuilder, alice),
      );
      expect(states.map((s) => s.consentType), ConsentType.values);
      expect(states.every((s) => !s.granted), isTrue);
    });

    test(
      'granting stores the version and the hash of the text shown',
      () async {
        final session = _as(sessionBuilder, alice);
        final state = await endpoints.consent.decide(
          session,
          consentType: ConsentType.health,
          granted: true,
          textVersion: healthVersion,
          language: 'ru',
          source: 'app',
        );
        expect(state.granted, isTrue);

        final records = await ConsentRecord.db.find(sessionBuilder.build());
        expect(records, hasLength(1));
        expect(
          records.single.textHash,
          currentConsentText(ConsentKind.health).hashFor('ru'),
        );
        expect(records.single.language, 'ru');
      },
    );

    test('withdrawing appends a record instead of changing one', () async {
      final session = _as(sessionBuilder, alice);
      for (final granted in [true, false]) {
        await endpoints.consent.decide(
          session,
          consentType: ConsentType.health,
          granted: granted,
          textVersion: healthVersion,
          language: 'az',
          source: 'app',
        );
      }
      final records = await ConsentRecord.db.find(sessionBuilder.build());
      expect(records.map((r) => r.granted), unorderedEquals([true, false]));

      final health = (await endpoints.consent.current(
        session,
      )).firstWhere((s) => s.consentType == ConsentType.health);
      expect(health.granted, isFalse);

      final actions = (await AuditLogEntry.db.find(
        sessionBuilder.build(),
      )).map((e) => e.action);
      expect(
        actions,
        unorderedEquals(['consent.granted', 'consent.withdrawn']),
      );
    });

    test('hasConsent follows the latest decision', () async {
      final session = _as(sessionBuilder, alice);
      final userId = UuidValue.fromString(alice);
      expect(
        await hasConsent(sessionBuilder.build(), userId, ConsentType.health),
        isFalse,
      );
      await endpoints.consent.decide(
        session,
        consentType: ConsentType.health,
        granted: true,
        textVersion: healthVersion,
        language: 'az',
        source: 'app',
      );
      expect(
        await hasConsent(sessionBuilder.build(), userId, ConsentType.health),
        isTrue,
      );
    });

    test('an unknown text version is refused', () async {
      await expectLater(
        endpoints.consent.decide(
          _as(sessionBuilder, alice),
          consentType: ConsentType.health,
          granted: true,
          textVersion: 'health-made-up',
          language: 'az',
          source: 'app',
        ),
        throwsA(_parlaError(ConsentErrors.unknownVersion)),
      );
    });

    test('a text of another consent type is refused', () async {
      await expectLater(
        endpoints.consent.decide(
          _as(sessionBuilder, alice),
          consentType: ConsentType.marketing,
          granted: true,
          textVersion: healthVersion,
          language: 'az',
          source: 'app',
        ),
        throwsA(_parlaError(ConsentErrors.unknownVersion)),
      );
    });

    test('an unsupported language or source is refused', () async {
      final session = _as(sessionBuilder, alice);
      await expectLater(
        endpoints.consent.decide(
          session,
          consentType: ConsentType.health,
          granted: true,
          textVersion: healthVersion,
          language: 'de',
          source: 'app',
        ),
        throwsA(_parlaError(ConsentErrors.languageUnsupported)),
      );
      await expectLater(
        endpoints.consent.decide(
          session,
          consentType: ConsentType.health,
          granted: true,
          textVersion: healthVersion,
          language: 'az',
          source: 'sms',
        ),
        throwsA(_parlaError(ConsentErrors.sourceUnsupported)),
      );
    });

    test("one user's decisions do not affect another user", () async {
      await endpoints.consent.decide(
        _as(sessionBuilder, alice),
        consentType: ConsentType.analytics,
        granted: true,
        textVersion: currentConsentText(ConsentKind.analytics).version,
        language: 'en',
        source: 'app',
      );
      final bobStates = await endpoints.consent.current(
        _as(sessionBuilder, bob),
      );
      expect(bobStates.every((s) => !s.granted), isTrue);
    });
  });
}
