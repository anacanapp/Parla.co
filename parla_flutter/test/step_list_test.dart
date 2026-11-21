import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/home/routine.dart';
import 'package:parla/home/widgets/home_cards.dart';
import 'package:parla/l10n/app_localizations.dart';

const _long =
    'Rutinin son addımı. Üz və boyun üçün təxminən iki barmaq uzunluğunda '
    'krem sürt; çöldə 2 saatdan bir təzələ.';

void main() {
  testWidgets('a step hint shows on one line and opens in full on tap; '
      'the check still toggles', (tester) async {
    final done = <bool>[false, true];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('az'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => StepList(
              steps: const [
                RoutineStep(
                  id: 'spf',
                  title: 'Günəşdən qoruyucu',
                  meta: _long,
                  tip: '',
                  minutes: 1,
                  tile: Colors.pink,
                ),
                RoutineStep(
                  id: 'cleanse',
                  title: 'Təmizləyici',
                  meta: 'Ilıq su ilə',
                  tip: '',
                  minutes: 1,
                  tile: Colors.purple,
                ),
              ],
              rowKey: (s) => ValueKey('step-${s.id}'),
              isDone: (i) => done[i],
              onToggle: (i) => setState(() => done[i] = !done[i]),
            ),
          ),
        ),
      ),
    );
    Text hint() => tester.widget<Text>(find.text(_long));
    expect(hint().maxLines, 1);
    await tester.tap(find.text(_long));
    await tester.pumpAndSettle();
    expect(hint().maxLines, isNull);
    await tester.tap(find.text(_long));
    await tester.pumpAndSettle();
    expect(hint().maxLines, 1);

    // A done step shows only "done".
    expect(find.text('Ilıq su ilə'), findsNothing);
    await tester.tap(find.bySemanticsLabel(RegExp('Təmizləyici: ')));
    await tester.pumpAndSettle();
    expect(done[1], isFalse);
    expect(find.text('Ilıq su ilə'), findsOneWidget);
  });
}
