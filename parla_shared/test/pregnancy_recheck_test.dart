import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime(2027, 11, 3);

  test('skin answers other than "no" are asked again after 12 months', () {
    expect(PregnancyRecheck.skinDue(['pregnant'], '2026-11', now), isTrue);
    expect(
      PregnancyRecheck.skinDue(['breastfeeding'], '2026-12', now),
      isFalse,
    );
    expect(PregnancyRecheck.skinDue(['trying'], '2026-10', now), isTrue);
    expect(PregnancyRecheck.skinDue(['no'], '2020-01', now), isFalse);
    expect(PregnancyRecheck.skinDue(['prefer_not'], '2020-01', now), isFalse);
  });

  test('sport: pregnant after 12 months, after birth after 6', () {
    expect(PregnancyRecheck.sportDue('pregnant', '2027-01', now), isFalse);
    expect(PregnancyRecheck.sportDue('postpartum', '2027-05', now), isTrue);
    expect(PregnancyRecheck.sportDue('postpartum', '2027-06', now), isFalse);
    expect(PregnancyRecheck.sportDue('no', '2020-01', now), isFalse);
  });

  test('older answers without a month count from the release month', () {
    expect(
      PregnancyRecheck.monthsSince(null, now),
      PregnancyRecheck.monthsSince(PregnancyRecheck.since, now),
    );
    expect(
      PregnancyRecheck.skinDue(['pregnant'], null, DateTime(2027, 10)),
      isFalse,
    );
    expect(
      PregnancyRecheck.skinDue(['pregnant'], null, DateTime(2027, 11)),
      isTrue,
    );
    expect(PregnancyRecheck.monthOf(DateTime(2026, 3, 9)), '2026-03');
    expect(PregnancyRecheck.isMonth('2026-13'), isFalse);
  });

  test('the sport document checks the month', () {
    const a = SportAnswers(
      goals: ['tone'],
      areas: {'full'},
      types: ['fitness'],
      level: 'beginner',
      days: 3,
      minutes: 15,
      pregnancy: 'pregnant',
      pregnancyMonth: '2026-11',
    );
    String doc(Map<String, Object?> answers) =>
        '{"format": ${SportRules.format}, "answers": ${jsonEncode(answers)}}';
    expect(SportRules.isValid(doc(a.toJson())), isTrue);
    expect(
      SportRules.isValid(doc({...a.toJson(), 'pregnancyMonth': 'soon'})),
      isFalse,
    );
    expect(SportAnswers.fromJson(a.toJson()).pregnancyMonth, '2026-11');
  });
}
