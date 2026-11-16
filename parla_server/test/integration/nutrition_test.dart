import 'dart:convert';

import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/routines/nutrition_endpoint.dart';
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

String _list({bool pregnant = true}) => jsonEncode({
  'format': 1,
  'plates': {
    '2026-11-16': pregnant ? ['vegetables', 'protein'] : ['fruit'],
  },
});

void main() {
  const alice = '0b6c1f3e-8a4d-4c7e-9f21-3d5a7e9b1c01';
  const bob = '7f2e9d4c-1b3a-4e5f-8c6d-9a0b1c2d3e02';
  final healthVersion = currentConsentText(ConsentKind.health).version;

  withServerpod('Given the nutrition endpoint', (sessionBuilder, endpoints) {
    Future<void> decideHealth(String user, bool granted) =>
        endpoints.consent.decide(
          _as(sessionBuilder, user),
          consentType: ConsentType.health,
          granted: granted,
          textVersion: healthVersion,
          language: 'az',
          source: 'app',
        );

    test('without the health consent nothing is stored or returned', () async {
      final session = _as(sessionBuilder, alice);
      await expectLater(
        endpoints.nutrition.saveNutrition(session, _list()),
        throwsA(_parlaError(NutritionErrors.healthConsentRequired)),
      );
      expect(await endpoints.nutrition.myNutrition(session), isNull);
      expect(await NutritionRecord.db.count(sessionBuilder.build()), 0);
    });

    test(
      'the answers are stored encrypted and returned to its owner only',
      () async {
        await decideHealth(alice, true);
        await decideHealth(bob, true);
        final session = _as(sessionBuilder, alice);
        await endpoints.nutrition.saveNutrition(session, _list());
        final row = await NutritionRecord.db.findFirstRow(
          sessionBuilder.build(),
        );
        expect(row!.ciphertext, isNot(contains('vegetables')));
        expect(
          await endpoints.nutrition.myNutrition(session),
          contains('vegetables'),
        );
        expect(
          await endpoints.nutrition.myNutrition(_as(sessionBuilder, bob)),
          isNull,
        );
        await endpoints.nutrition.saveNutrition(
          session,
          _list(pregnant: false),
        );
        expect(await NutritionRecord.db.count(sessionBuilder.build()), 1);
      },
    );

    test('invalid data is refused', () async {
      await decideHealth(alice, true);
      await expectLater(
        endpoints.nutrition.saveNutrition(
          _as(sessionBuilder, alice),
          jsonEncode({'format': 1, 'calories': 1800}),
        ),
        throwsA(_parlaError(NutritionErrors.invalid)),
      );
    });

    test(
      'a consent to an older text does not cover the plate',
      () async {
        final old = consentTextByVersion(
          ConsentKind.health,
          'health-2026-11-draft4',
        )!;
        await ConsentRecord.db.insertRow(
          sessionBuilder.build(),
          ConsentRecord(
            authUserId: UuidValue.fromString(alice),
            consentType: ConsentType.health,
            granted: true,
            textVersion: old.version,
            textHash: old.hashFor('az')!,
            language: 'az',
            source: 'app',
            createdAt: DateTime.now().toUtc(),
          ),
        );
        await expectLater(
          endpoints.nutrition.saveNutrition(
            _as(sessionBuilder, alice),
            _list(),
          ),
          throwsA(_parlaError(NutritionErrors.healthConsentRequired)),
        );
      },
    );

    test(
      'withdrawal deletes it, export holds it, deletion removes it',
      () async {
        await decideHealth(alice, true);
        final session = _as(sessionBuilder, alice);
        await endpoints.nutrition.saveNutrition(session, _list());
        final export =
            jsonDecode(await endpoints.account.exportMyData(session)) as Map;
        expect(export['nutrition']['plates']['2026-11-16'], [
          'vegetables',
          'protein',
        ]);

        await decideHealth(alice, false);
        expect(await NutritionRecord.db.count(sessionBuilder.build()), 0);

        await decideHealth(alice, true);
        await endpoints.nutrition.saveNutrition(session, _list());
        await endpoints.account.deleteAccount(session);
        expect(await NutritionRecord.db.count(sessionBuilder.build()), 0);
      },
    );
  });
}
