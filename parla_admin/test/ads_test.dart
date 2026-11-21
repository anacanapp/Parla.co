import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla_admin/ads/ad_report_files.dart';
import 'package:parla_admin/ads/save_file.dart';
import 'package:parla_admin/api/admin_api.dart';
import 'package:parla_admin/app.dart';

import 'fake_admin_api.dart';

Future<FakeAdminApi> _pump(WidgetTester tester, StaffRole role) async {
  tester.view.physicalSize = const Size(1400, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final api = FakeAdminApi()
    ..signedIn = true
    ..meValue = StaffMe(
      role: role,
      signInExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 12)),
    );
  await tester.pumpWidget(AdminApp(api: api));
  await tester.pumpAndSettle();
  return api;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Finder _nav(String label) => find.descendant(
  of: find.byKey(const ValueKey('admin-nav')),
  matching: find.text(label),
);

final _report = AdReport(
  campaignId: 2,
  campaign: 'Yaz',
  advertiser: '=Brand X',
  startsOn: '2026-12-01',
  endsOn: '2026-12-31',
  countedTo: '2026-12-02',
  views: 25,
  taps: 12,
  days: [
    AdReportRow(label: '2026-12-01', views: 20, taps: null),
    AdReportRow(label: '2026-12-02', views: null, taps: null),
  ],
  banners: [AdReportRow(label: 'Yaz; kolleksiya', views: 25, taps: 12)],
);

void main() {
  testWidgets('only admins see the ads section', (tester) async {
    await _pump(tester, StaffRole.editor);
    expect(_nav('Reklam'), findsNothing);
  });

  testWidgets('an admin adds an advertiser and a campaign', (tester) async {
    final api = await _pump(tester, StaffRole.admin);
    await _tap(tester, _nav('Reklam'));
    expect(find.text('Hələ kampaniya yoxdur'), findsOneWidget);
    // A campaign needs an advertiser first.
    await _tap(tester, find.byKey(const ValueKey('campaign-new')));
    expect(find.text('Əvvəlcə reklamçı əlavə edin.'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('ads-tab-advertisers')));
    expect(find.text('Yalnız şirkət məlumatı'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('advertiser-new')));
    await tester.enterText(
      find.byKey(const ValueKey('advertiser-company')),
      'Brand X',
    );
    await tester.enterText(
      find.byKey(const ValueKey('advertiser-email')),
      'info@brand.az',
    );
    await _tap(tester, find.byKey(const ValueKey('advertiser-save')));
    expect(api.calls, contains('saveAdvertiser:Brand X:info@brand.az'));
    expect(find.text('Brand X'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('ads-tab-campaigns')));
    await _tap(tester, find.byKey(const ValueKey('campaign-new')));
    await tester.enterText(find.byKey(const ValueKey('campaign-title')), 'Yaz');
    await tester.enterText(
      find.byKey(const ValueKey('campaign-start')),
      '2026-12-01',
    );
    await tester.enterText(
      find.byKey(const ValueKey('campaign-end')),
      '2026-12-31',
    );
    await _tap(tester, find.byKey(const ValueKey('campaign-save')));
    final id = api.advertiserRows.single.id;
    expect(api.calls, contains('saveCampaign:$id:Yaz:2026-12-01:2026-12-31'));
    expect(find.text('Yaz'), findsOneWidget);

    // An advertiser with a campaign is not deleted.
    await _tap(tester, find.byKey(const ValueKey('ads-tab-advertisers')));
    await _tap(tester, find.byKey(ValueKey('advertiser-delete-$id')));
    await _tap(tester, find.byKey(const ValueKey('confirm-yes')));
    expect(find.textContaining('Əvvəlcə bağlı olanları'), findsOneWidget);
    expect(api.advertiserRows, hasLength(1));
  });

  testWidgets('the report hides small counts and downloads CSV and PDF', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.admin);
    api.report = _report;
    final brand = await api.saveAdvertiser(
      Advertiser(
        company: '=Brand X',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    await api.saveAdCampaign(
      AdCampaign(
        advertiserId: brand.id!,
        title: 'Yaz',
        startsOn: '2026-12-01',
        endsOn: '2026-12-31',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    await _tap(tester, _nav('Reklam'));
    await _tap(tester, find.text('Yaz'));
    expect(api.calls.last, startsWith('report:'));
    expect(find.text('Reklamçıya yalnız cəm rəqəmlər verilir'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('report-views'))).data,
      '25',
    );
    expect(find.text('48.0%'), findsNWidgets(2));
    expect(find.text('<10'), findsNWidgets(3));

    savedFiles.clear();
    await _tap(tester, find.byKey(const ValueKey('report-csv')));
    final csvName = savedFiles.keys.single;
    expect(csvName, 'parla-reklam-brand-x-yaz-2026-12-01.csv');

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const ValueKey('report-pdf')));
      for (var i = 0; i < 100 && savedFiles.length < 2; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    });
    await tester.pumpAndSettle();
    final pdf = savedFiles['parla-reklam-brand-x-yaz-2026-12-01.pdf'];
    expect(pdf, isNotNull);
    expect(ascii.decode(pdf!.sublist(0, 5)), '%PDF-');
  });

  test('CSV: hidden counts, rates, quoting and no formulas', () {
    final bytes = adReportCsv(_report);
    expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
    final lines = utf8.decode(bytes.sublist(3)).split('\r\n');
    expect(lines[0], "Reklamçı;'=Brand X");
    expect(lines, contains('Cəmi;25;12;48.0%'));
    expect(lines, contains('"Yaz; kolleksiya";25;12;48.0%'));
    expect(lines, contains('2026-12-01;20;<10;–'));
    expect(lines, contains('2026-12-02;<10;<10;–'));
  });

  test('PDF: made with the panel font', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final pdf = await adReportPdf(
      _report,
      regular: await rootBundle.load('assets/fonts/Onest-Regular.ttf'),
      bold: await rootBundle.load('assets/fonts/Onest-Bold.ttf'),
      made: DateTime(2026, 12, 3),
    );
    expect(ascii.decode(pdf.sublist(0, 5)), '%PDF-');
    expect(pdf.length, greaterThan(1000));
  });
}
