import 'dart:convert';

import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/routines/care_list_endpoint.dart';
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

String _list({String title = 'Ekzema kremi'}) => jsonEncode({
  'format': 1,
  'preferences': ['fragrance_free', 'vegan'],
  'recent': [
    {
      'code': '123',
      'source': 'openbeautyfacts',
      'name': 'Cream',
      'at': '2026-11-15',
    },
  ],
  'shopping': [
    {'id': 'a1', 'title': title, 'area': 'body', 'bought': false},
  ],
});

void main() {
  const alice = '0b6c1f3e-8a4d-4c7e-9f21-3d5a7e9b1c01';
  const bob = '7f2e9d4c-1b3a-4e5f-8c6d-9a0b1c2d3e02';
  final healthVersion = currentConsentText(ConsentKind.health).version;

  withServerpod('Given the care list endpoint', (sessionBuilder, endpoints) {
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
        endpoints.careList.saveCareList(session, _list()),
        throwsA(_parlaError(CareListErrors.healthConsentRequired)),
      );
      expect(await endpoints.careList.myCareList(session), isNull);
      expect(await CareListRecord.db.count(sessionBuilder.build()), 0);
    });

    test(
      'the list is stored encrypted and returned to its owner only',
      () async {
        await decideHealth(alice, true);
        await decideHealth(bob, true);
        final session = _as(sessionBuilder, alice);
        await endpoints.careList.saveCareList(session, _list());
        final row = await CareListRecord.db.findFirstRow(
          sessionBuilder.build(),
        );
        expect(row!.ciphertext, isNot(contains('Ekzema')));
        expect(
          await endpoints.careList.myCareList(session),
          contains('Ekzema kremi'),
        );
        expect(
          await endpoints.careList.myCareList(_as(sessionBuilder, bob)),
          isNull,
        );
        await endpoints.careList.saveCareList(session, _list(title: 'SPF'));
        expect(await CareListRecord.db.count(sessionBuilder.build()), 1);
      },
    );

    test('invalid data is refused', () async {
      await decideHealth(alice, true);
      await expectLater(
        endpoints.careList.saveCareList(
          _as(sessionBuilder, alice),
          jsonEncode({'format': 1, 'photo': 'base64'}),
        ),
        throwsA(_parlaError(CareListErrors.invalid)),
      );
    });

    test('a consent to an older text does not cover the list', () async {
      final old = consentTextByVersion(
        ConsentKind.health,
        'health-2026-11-draft2',
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
        endpoints.careList.saveCareList(_as(sessionBuilder, alice), _list()),
        throwsA(_parlaError(CareListErrors.healthConsentRequired)),
      );
    });

    test(
      'withdrawal deletes it, export holds it, deletion removes it',
      () async {
        await decideHealth(alice, true);
        final session = _as(sessionBuilder, alice);
        await endpoints.careList.saveCareList(session, _list());
        final export =
            jsonDecode(await endpoints.account.exportMyData(session)) as Map;
        expect(export['careList']['shopping'][0]['title'], 'Ekzema kremi');

        await decideHealth(alice, false);
        expect(await CareListRecord.db.count(sessionBuilder.build()), 0);

        await decideHealth(alice, true);
        await endpoints.careList.saveCareList(session, _list());
        await endpoints.account.deleteAccount(session);
        expect(await CareListRecord.db.count(sessionBuilder.build()), 0);
      },
    );
  });
}
