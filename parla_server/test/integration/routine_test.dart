import 'dart:convert';

import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/routines/routine_endpoint.dart';
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

String _book({String name = 'Ekzema kremi', Map<String, Object?>? ticks}) =>
    jsonEncode({
      'format': 1,
      'routines': [
        {
          'id': 'r1',
          'name': name,
          'area': 'body',
          'steps': [
            {'id': 's1', 'title': 'Krem'},
          ],
        },
      ],
      'ticks': ticks ?? {},
    });

void main() {
  const alice = '0b6c1f3e-8a4d-4c7e-9f21-3d5a7e9b1c01';
  const bob = '7f2e9d4c-1b3a-4e5f-8c6d-9a0b1c2d3e02';
  final healthVersion = currentConsentText(ConsentKind.health).version;

  withServerpod('Given the routine endpoint', (sessionBuilder, endpoints) {
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
        endpoints.routine.saveRoutines(session, _book()),
        throwsA(_parlaError(RoutineErrors.healthConsentRequired)),
      );
      expect(await endpoints.routine.myRoutines(session), isNull);
      expect(await CustomRoutineRecord.db.count(sessionBuilder.build()), 0);
    });

    test(
      'routines are stored encrypted and returned to their owner only',
      () async {
        await decideHealth(alice, true);
        await decideHealth(bob, true);
        final session = _as(sessionBuilder, alice);
        await endpoints.routine.saveRoutines(session, _book());

        final row = await CustomRoutineRecord.db.findFirstRow(
          sessionBuilder.build(),
        );
        expect(row!.ciphertext, isNot(contains('Ekzema')));
        expect(
          (jsonDecode((await endpoints.routine.myRoutines(session))!)
              as Map)['routines'][0]['name'],
          'Ekzema kremi',
        );
        expect(
          await endpoints.routine.myRoutines(_as(sessionBuilder, bob)),
          isNull,
        );

        await endpoints.routine.saveRoutines(session, _book(name: 'Spa'));
        expect(await CustomRoutineRecord.db.count(sessionBuilder.build()), 1);
        expect(await endpoints.routine.myRoutines(session), contains('Spa'));
      },
    );

    test('invalid data is refused', () async {
      await decideHealth(alice, true);
      final session = _as(sessionBuilder, alice);
      await expectLater(
        endpoints.routine.saveRoutines(
          session,
          jsonEncode({'format': 1, 'phone': '+994'}),
        ),
        throwsA(_parlaError(RoutineErrors.invalid)),
      );
      await expectLater(
        endpoints.routine.saveRoutines(session, _book(name: 'x' * 41)),
        throwsA(_parlaError(RoutineErrors.invalid)),
      );
    });

    test('ticks older than 90 days are dropped on save', () async {
      await decideHealth(alice, true);
      final session = _as(sessionBuilder, alice);
      final today = DateTime.now().toUtc();
      String day(int ago) => today
          .subtract(Duration(days: ago))
          .toIso8601String()
          .substring(0, 10);
      await endpoints.routine.saveRoutines(
        session,
        _book(
          ticks: {
            day(200): ['s1'],
            day(1): ['s1'],
          },
        ),
      );
      final ticks =
          (jsonDecode((await endpoints.routine.myRoutines(session))!)
                  as Map)['ticks']
              as Map;
      expect(ticks.keys, [day(1)]);
    });

    test(
      'a health consent to the older text does not cover routines',
      () async {
        // A record from before the routines were added to the text.
        final old = consentTextByVersion(
          ConsentKind.health,
          'health-2026-11-draft1',
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
          endpoints.routine.saveRoutines(_as(sessionBuilder, alice), _book()),
          throwsA(_parlaError(RoutineErrors.healthConsentRequired)),
        );
      },
    );

    test('withdrawing the health consent deletes the routines', () async {
      await decideHealth(alice, true);
      final session = _as(sessionBuilder, alice);
      await endpoints.routine.saveRoutines(session, _book());
      await decideHealth(alice, false);
      expect(await CustomRoutineRecord.db.count(sessionBuilder.build()), 0);
      await decideHealth(alice, true);
      expect(await endpoints.routine.myRoutines(session), isNull);
    });

    test(
      'the export holds the routines and account deletion removes them',
      () async {
        await decideHealth(alice, true);
        final session = _as(sessionBuilder, alice);
        await endpoints.routine.saveRoutines(session, _book());
        final export =
            jsonDecode(await endpoints.account.exportMyData(session)) as Map;
        expect(export['customRoutines']['routines'][0]['name'], 'Ekzema kremi');

        await endpoints.account.deleteAccount(session);
        expect(await CustomRoutineRecord.db.count(sessionBuilder.build()), 0);
      },
    );
  });
}
