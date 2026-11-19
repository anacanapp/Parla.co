import 'package:flutter_test/flutter_test.dart';
import 'package:parla/services/usage_meter.dart';
import 'package:parla_shared/parla_shared.dart';

void main() {
  late List<Map<String, int>> sent;
  late bool? consent;
  late bool fail;

  UsageMeter meter() => UsageMeter(
    hasConsent: () async => consent,
    send: (platform, counts) async {
      expect(platform, 'ios');
      if (fail) throw Exception('offline');
      sent.add(Map.of(counts));
      return consent ?? false;
    },
    platform: UsagePlatform.ios,
    appVersion: '1.2.0',
  );

  setUp(() {
    sent = [];
    consent = true;
    fail = false;
  });

  test('nothing is sent before or without the consent', () async {
    consent = false;
    final m = meter()..tool(UsageTool.check);
    expect(m.pending, {'tool|check': 1}); // waiting: consent not known yet
    await m.flush();
    expect(sent, isEmpty);
    await m.start('d1');
    expect(m.enabled, isFalse);
    expect(m.pending, isEmpty);
    m.tool(UsageTool.shop);
    await m.flush();
    expect(sent, isEmpty);
  });

  test('with the consent: one start a day, counts in batches', () async {
    final m = meter()
      ..tool(UsageTool.check)
      ..count(UsageEvent.recipe, 'green-salad')
      ..count(UsageEvent.recipe, 'Not a slug');
    await m.start('d1');
    expect(sent.single, {
      'tool|check': 1,
      'recipe|green-salad': 1,
      'appOpen|1.2.0': 1,
    });
    await m.start('d1');
    expect(sent, hasLength(1));
    m
      ..bannerShown(7)
      ..bannerShown(7)
      ..bannerTapped(7);
    await m.flush();
    expect(sent.last, {'bannerView|7': 1, 'bannerTap|7': 1});
  });

  test('failed sends are kept; withdrawal drops them', () async {
    final m = meter();
    await m.start('d1');
    fail = true;
    m.tool(UsageTool.sport);
    await m.flush();
    expect(m.pending, {'tool|sport': 1});
    m.setEnabled(false);
    expect(m.pending, isEmpty);
    m.reset();
    expect(m.enabled, isNull);
  });
}
