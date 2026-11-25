import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/ui/brand.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/screens/legal_docs.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';
import 'support/text_sizes.dart';

class _Harness {
  _Harness(this.api, this.shared, this.store);

  final FakeApi api;
  final List<String> shared;
  final MemoryHabitStore store;
}

/// Signed-in user with a quiz and the health consent, opened on the privacy
/// centre through the avatar on the Today screen.
Future<_Harness> _openPrivacy(
  WidgetTester tester, {
  String language = 'en',
  MemoryHabitStore? store,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({'language': language});
  final settings = await AppSettings.load();
  final shared = <String>[];
  final habitStore = store ?? MemoryHabitStore();
  final api = FakeApi()
    ..signedIn = true
    ..profile = ProfileSummary(
      countryCode: 'AZ',
      language: language,
      birthYear: 1995,
      email: 'member@example.com',
    )
    ..healthConsent = true
    ..quizAnswers = const QuizAnswers(
      chosen: {
        'skin_type': ['dry'],
      },
    );
  await tester.pumpWidget(
    ParlaApp(
      api: api,
      reminderScheduler: FakeReminderScheduler(),
      settings: settings,
      shareExport: (json) async => shared.add(json),
      habitStore: habitStore,
    ),
  );
  await tester.pumpAndSettle();
  // Profile and privacy is the last tab.
  await tester.tap(
    find
        .descendant(
          of: find.byType(ParlaNavBar),
          matching: find.byType(InkWell),
        )
        .at(4),
  );
  await tester.pumpAndSettle();
  return _Harness(api, shared, habitStore);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  final list = find.byType(Scrollable);
  if (finder.evaluate().isEmpty && list.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(finder, 200, scrollable: list.first);
  }
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  // The floating tab bar covers the bottom of the Profile tab: lift a
  // target that sits under it.
  final bar = find.byType(ParlaNavBar);
  if (bar.evaluate().isNotEmpty && list.evaluate().isNotEmpty) {
    final top = tester.getRect(bar).top;
    final target = tester.getRect(finder.first);
    if (target.bottom > top) {
      await tester.drag(list.first, Offset(0, top - target.bottom - 24));
      await tester.pumpAndSettle();
    }
  }
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

SwitchListTile _switch(WidgetTester tester, ConsentKind kind) =>
    tester.widget<SwitchListTile>(
      find.byKey(ValueKey('consent-switch-${kind.name}')),
    );

void main() {
  testWidgets('the avatar opens the privacy centre with the current '
      'consents', (tester) async {
    await _openPrivacy(tester);
    expect(find.text('Privacy centre'), findsOneWidget);
    expect(_switch(tester, ConsentKind.health).value, isTrue);
    expect(_switch(tester, ConsentKind.analytics).value, isFalse);
  });

  testWidgets('the account card shows email, age, country and language, '
      'and no name', (tester) async {
    await _openPrivacy(tester);
    final facts = find.byKey(const ValueKey('profile-account-facts'));
    expect(facts, findsOneWidget);
    String all() => tester
        .widgetList<Text>(
          find.descendant(of: facts, matching: find.byType(Text)),
        )
        .map((t) => t.textSpan?.toPlainText() ?? t.data)
        .join(' | ');
    expect(all(), contains('member@example.com'));
    expect(all(), contains('Age  ${DateTime.now().year - 1995}'));
    expect(all(), contains('Country  Azerbaijan'));
    expect(all(), contains('Language  English'));
    expect(all(), isNot(contains('Name')));
  });

  testWidgets('granting a consent records the current text version', (
    tester,
  ) async {
    final h = await _openPrivacy(tester);
    await _tap(
      tester,
      find.byKey(const ValueKey('consent-switch-analytics')),
    );
    expect(h.api.consentCalls.single.$1, ConsentKind.analytics);
    expect(h.api.consentCalls.single.$2, isTrue);
    expect(
      h.api.consentCalls.single.$3,
      currentConsentText(ConsentKind.analytics).version,
    );
    expect(_switch(tester, ConsentKind.analytics).value, isTrue);
  });

  testWidgets('withdrawing the health consent asks first; cancel keeps it', (
    tester,
  ) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.byKey(const ValueKey('consent-switch-health')));
    expect(find.text('Withdraw the health consent?'), findsOneWidget);

    await _tap(tester, find.text('Cancel'));
    expect(h.api.consentCalls, isEmpty);
    expect(_switch(tester, ConsentKind.health).value, isTrue);

    await _tap(tester, find.byKey(const ValueKey('consent-switch-health')));
    await _tap(tester, find.text('Withdraw and delete'));
    expect(h.api.consentCalls.single.$2, isFalse);
    expect(h.api.healthConsent, isFalse);
    expect(_switch(tester, ConsentKind.health).value, isFalse);
  });

  testWidgets('download my data hands the export to the share sheet', (
    tester,
  ) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.text('Create file'));
    expect(h.api.exports, 1);
    expect(h.shared.single, contains('parla-export-v1'));
  });

  testWidgets('the export also holds the habit entries kept on this phone', (
    tester,
  ) async {
    final store = MemoryHabitStore()
      ..data['user-1'] = jsonEncode({
        'format': 'parla-habits-v1',
        'days': {
          '2026-11-12': {'water': 3},
        },
      });
    final h = await _openPrivacy(tester, store: store);
    await _tap(tester, find.text('Create file'));
    final file = jsonDecode(h.shared.single) as Map<String, Object?>;
    expect(file['format'], 'parla-export-v1');
    expect(
      (file['deviceReminders'] as Map)['morningRoutine'],
      {'enabled': false, 'minutes': 480},
    );
    expect(file['deviceHabits'], {
      'format': 'parla-habits-v1',
      'days': {
        '2026-11-12': {'water': 3},
      },
    });
  });

  testWidgets('habit entries on this phone can be deleted after a '
      'confirmation', (tester) async {
    final store = MemoryHabitStore()..data['user-1'] = '{}';
    await _openPrivacy(tester, store: store);
    await _tap(tester, find.byKey(const ValueKey('delete-habits')));
    expect(find.text('Delete your habit entries?'), findsOneWidget);
    await _tap(tester, find.text('Cancel'));
    expect(store.data, contains('user-1'));

    await _tap(tester, find.byKey(const ValueKey('delete-habits')));
    await _tap(tester, find.text('Delete entries').last);
    expect(store.data, isEmpty);
    expect(find.text('Habit entries deleted.'), findsOneWidget);
  });

  testWidgets('signing out keeps the habit entries for the next sign-in', (
    tester,
  ) async {
    final store = MemoryHabitStore()..data['user-1'] = '{}';
    await _openPrivacy(tester, store: store);
    await _tap(tester, find.text('Sign out'));
    expect(store.data, contains('user-1'));
  });

  testWidgets('deleting the account also deletes the habit entries on this '
      'phone', (tester) async {
    final store = MemoryHabitStore()
      ..data['user-1'] = '{}'
      ..data['other-user'] = '{}';
    final h = await _openPrivacy(tester, store: store);
    await _tap(tester, find.text('Delete account'));
    await tester.enterText(
      find.byKey(const ValueKey('delete-confirm')),
      'delete',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.widgetWithText(FilledButton, 'Delete my account'));
    expect(h.api.deleted, isTrue);
    expect(store.data.keys, ['other-user']);
  });

  testWidgets('deleting needs the typed word, then signs out to the '
      'goodbye screen', (tester) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.text('Delete account'));
    expect(find.text('Delete your account?'), findsOneWidget);

    final button = find.widgetWithText(FilledButton, 'Delete my account');
    expect(tester.widget<FilledButton>(button).onPressed, isNull);

    await tester.enterText(find.byKey(const ValueKey('delete-confirm')), 'del');
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(button).onPressed, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('delete-confirm')),
      'delete',
    );
    await tester.pumpAndSettle();
    await _tap(tester, button);

    expect(h.api.deleted, isTrue);
    expect(find.text('Your account is deleted'), findsOneWidget);
    await _tap(tester, find.text('Close'));
    expect(find.text('Your personal care guide'), findsOneWidget);
  });

  testWidgets('az: lower-case "sil" confirms deletion', (tester) async {
    final h = await _openPrivacy(tester, language: 'az');
    await _tap(tester, find.text('Hesabı sil'));
    await tester.enterText(find.byKey(const ValueKey('delete-confirm')), 'sil');
    await tester.pumpAndSettle();
    await _tap(tester, find.widgetWithText(FilledButton, 'Hesabımı sil'));
    expect(h.api.deleted, isTrue);
  });

  testWidgets('the delete screen offers the export first', (tester) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.text('Delete account'));
    await _tap(tester, find.text('Download my data first'));
    expect(h.shared, hasLength(1));
    expect(h.api.deleted, isFalse);
  });

  testWidgets('sign out goes to the welcome screen', (tester) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.text('Sign out'));
    expect(h.api.signedIn, isFalse);
    expect(find.text('Your personal care guide'), findsOneWidget);
  });

  testWidgets('legal documents show the medical disclaimer and consent '
      'texts', (tester) async {
    await _openPrivacy(tester);
    await _tap(tester, find.text('Legal documents'));
    expect(find.text('Not medical advice'), findsOneWidget);
    expect(
      find.textContaining(currentConsentText(ConsentKind.health).version),
      findsOneWidget,
    );
  });

  test('the shipped legal texts are ready in every language', () {
    final company =
        (jsonDecode(File('assets/legal/company.json').readAsStringSync())
                as Map<String, dynamic>)
            .cast<String, String>();
    for (final doc in LegalDoc.values) {
      for (final language in ['az', 'ru', 'en']) {
        final path = 'assets/legal/${doc.name}.$language.md';
        final text = LegalDoc.fill(File(path).readAsStringSync(), company);
        expect(LegalDoc.isReady(text), isTrue, reason: path);
        expect(text, contains(company['email']), reason: path);
        expect(text, contains(company['effectiveDate']), reason: path);
      }
    }
  });

  test('company details fill in, and empty ones drop their line', () {
    const text = '# Policy\n\n- Company: {{legalName}}\n- Email: {{email}}';
    expect(
      LegalDoc.fill(text, {'legalName': '', 'email': 'a@b.az'}),
      '# Policy\n\n- Email: a@b.az',
    );
    expect(LegalDoc.isReady(LegalDoc.fill(text, {'email': 'a@b.az'})), isFalse);
    const ready = '# Privacy policy\n\nParla LLC.';
    expect(LegalDoc.isReady(ready), isTrue);
    expect(LegalDoc.isReady('**QARALAMA**\n$ready'), isFalse);
    expect(
      LegalDoc.isReady('$ready\n> ⚖️ Hüquqşünas yoxlamalıdır: x'),
      isFalse,
    );
    expect(LegalDoc.fromLink('privacy.az.md'), LegalDoc.privacy);
    expect(LegalDoc.fromLink('terms.ru.md'), LegalDoc.terms);
    expect(LegalDoc.fromLink('https://example.com'), isNull);
  });

  testWidgets('a language without its own text shows the Azerbaijani one', (
    tester,
  ) async {
    final read = LegalDoc.read;
    addTearDown(() => LegalDoc.read = read);
    LegalDoc.read = (path) async => switch (path) {
      'assets/legal/company.json' =>
        '{"email": "info@anacan.az", "effectiveDate": "1.1.2027"}',
      'assets/legal/privacy.az.md' =>
        '# Məxfilik siyasəti\n\nParla MMC. {{email}}',
      _ => throw StateError('none'),
    };
    await _openPrivacy(tester, language: 'en');
    await _tap(tester, find.byKey(const ValueKey('privacy-legal')));
    expect(find.byKey(const ValueKey('legal-pending')), findsNothing);
    expect(find.byKey(const ValueKey('legal-terms')), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('legal-privacy')));
    expect(find.byKey(const ValueKey('legal-doc')), findsOneWidget);
    expect(find.text('Parla MMC. info@anacan.az'), findsOneWidget);
  });

  testWidgets('without a contact email the "being prepared" note stays', (
    tester,
  ) async {
    final read = LegalDoc.read;
    addTearDown(() => LegalDoc.read = read);
    LegalDoc.read = (path) async => path.endsWith('company.json')
        ? '{"email": "", "effectiveDate": "1.1.2027"}'
        : '# Policy';
    await _openPrivacy(tester);
    await _tap(tester, find.byKey(const ValueKey('privacy-legal')));
    expect(find.byKey(const ValueKey('legal-pending')), findsOneWidget);
    expect(find.byKey(const ValueKey('legal-privacy')), findsNothing);
  });

  testWidgets('the shipped privacy policy and terms open', (tester) async {
    final read = LegalDoc.read;
    addTearDown(() => LegalDoc.read = read);
    // The shipped files, read without real (asynchronous) asset IO.
    LegalDoc.read = (path) async => File(path).readAsStringSync();
    await _openPrivacy(tester);
    await _tap(tester, find.byKey(const ValueKey('privacy-legal')));
    expect(find.byKey(const ValueKey('legal-privacy')), findsOneWidget);
    expect(find.byKey(const ValueKey('legal-terms')), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('legal-terms')));
    expect(find.byKey(const ValueKey('legal-doc')), findsOneWidget);
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets(
      '$language: privacy screens keep text at the minimum size or more '
      'without overflow',
      (tester) async {
        await _openPrivacy(tester, language: language);
        final sizes = <double>[];
        Future<void> scrollAndCollect() async {
          final list = find.byType(Scrollable);
          for (var i = 0; i < 4; i++) {
            sizes.addAll(paintedFontSizes(tester));
            expect(tester.takeException(), isNull);
            if (list.evaluate().isEmpty) break;
            await tester.drag(list.first, const Offset(0, -400));
            await tester.pumpAndSettle();
          }
        }

        await scrollAndCollect();
        // Legal documents, then back, then delete account.
        await _tap(tester, find.byKey(const ValueKey('privacy-legal')));
        await scrollAndCollect();
        await _tap(tester, find.byType(BackButton));
        await _tap(tester, find.byKey(const ValueKey('privacy-delete')));
        await scrollAndCollect();

        expect(sizes, isNotEmpty);
        expect(sizes.where((s) => s < kMinTextSize), isEmpty);
      },
    );
  }
}
