import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/ui/parla_icons.dart';
import 'package:parla/ui/parla_ui.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  double textScale = 1,
  double width = 360,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: Size(width, 800),
          textScaler: TextScaler.linear(textScale),
        ),
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: width - 32,
              child: SingleChildScrollView(child: child),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('pill controls: tap targets, selection and choices', (
    tester,
  ) async {
    var taps = 0;
    var area = 'face';
    var chip = false;
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => Column(
          children: [
            PillButton(
              label: 'Səhər',
              icon: ParlaIconName.sun,
              tone: PillTone.dark,
              onPressed: () => taps++,
            ),
            PillChip(
              label: 'Axşam · 0/3',
              selected: chip,
              onTap: () => setState(() => chip = !chip),
            ),
            PillSegmented<String>(
              segments: const [
                PillSegment('face', 'Üz'),
                PillSegment('hair', 'Saç'),
                PillSegment('body', 'Bədən'),
              ],
              selected: area,
              onChanged: (v) => setState(() => area = v),
            ),
          ],
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(PillButton)).height,
      greaterThanOrEqualTo(44),
    );
    expect(
      tester.getSize(find.byType(PillChip)).height,
      greaterThanOrEqualTo(44),
    );
    await tester.tap(find.text('Səhər'));
    expect(taps, 1);
    await tester.tap(find.text('Axşam · 0/3'));
    await tester.pump();
    expect(chip, isTrue);
    expect(
      tester.getSemantics(find.text('Axşam · 0/3')),
      containsSemantics(isButton: true, isSelected: true),
    );
    await tester.tap(find.text('Saç'));
    await tester.pump();
    expect(area, 'hair');
  });

  testWidgets('ring, stat and hero hold at 200% text on a small phone', (
    tester,
  ) async {
    await _pump(
      tester,
      const Column(
        children: [
          HeroGlow(child: Text('Günaydın!')),
          ProgressRing(fraction: 0.5, label: '2/4'),
          Row(
            children: [
              Expanded(
                child: MiniStat(
                  label: 'Su',
                  value: '6',
                  unit: '/ 8',
                  fraction: .75,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: MiniStat(
                  label: 'İdman',
                  value: '12',
                  unit: 'dəq',
                  fraction: .4,
                  dark: true,
                ),
              ),
            ],
          ),
        ],
      ),
      textScale: 2,
      width: 320,
    );
    expect(tester.takeException(), isNull);
    expect(find.text('2/4'), findsOneWidget);
    expect(find.text('Günaydın!'), findsOneWidget);
  });
}
