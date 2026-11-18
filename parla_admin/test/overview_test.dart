import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla_admin/api/admin_api.dart';
import 'package:parla_admin/app.dart';

import 'fake_admin_api.dart';

ContentAdminItem _item(int id, String kind, ContentStatus status) =>
    ContentAdminItem(
      id: id,
      kind: kind,
      slug: '$kind-$id',
      category: 'umumi',
      status: status,
      draftJson: '{}',
      live: false,
      consentRecorded: false,
      hidden: false,
      updatedAt: DateTime.utc(2026, 11, 16),
    );

Future<void> _pump(WidgetTester tester, StaffRole role) async {
  tester.view.physicalSize = const Size(1400, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final api = FakeAdminApi()
    ..signedIn = true
    ..meValue = StaffMe(
      role: role,
      signInExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 12)),
    );
  api.content.addAll([
    // An article waits for an expert, a team banner for an admin.
    _item(1, 'article', ContentStatus.inReview),
    _item(2, 'banner', ContentStatus.inReview),
    _item(3, 'recipe', ContentStatus.approved),
    _item(4, 'article', ContentStatus.draft),
  ]);
  api.threads.add(
    SupportThreadSummary(
      id: 1,
      email: 'aysel@example.com',
      open: true,
      unreadByStaff: true,
      lastMessageAt: DateTime.utc(2026, 11, 17, 9),
    ),
  );
  await tester.pumpWidget(AdminApp(api: api));
  await tester.pumpAndSettle();
}

String _count(WidgetTester tester, String key) =>
    tester.widget<Text>(find.byKey(ValueKey('$key-count'))).data!;

void main() {
  testWidgets('an admin sees every section and what waits for them', (
    tester,
  ) async {
    await _pump(tester, StaffRole.admin);
    expect(find.text('Xoş gəldiniz'), findsOneWidget);
    expect(_count(tester, 'todo-review'), '1'); // the banner only
    expect(_count(tester, 'todo-approved'), '1');
    expect(_count(tester, 'todo-drafts'), '1');
    expect(_count(tester, 'todo-support'), '1');
    for (final g in ['content', 'users', 'stats', 'messages', 'staff']) {
      expect(find.byKey(ValueKey('guide-$g')), findsOneWidget, reason: g);
    }
  });

  testWidgets('an expert sees only the review queue', (tester) async {
    await _pump(tester, StaffRole.expert);
    expect(_count(tester, 'todo-review'), '1'); // the article only
    expect(find.byKey(const ValueKey('todo-approved')), findsNothing);
    expect(find.byKey(const ValueKey('todo-support')), findsNothing);
    expect(find.byKey(const ValueKey('guide-content')), findsOneWidget);
    expect(find.byKey(const ValueKey('guide-users')), findsNothing);
  });

  testWidgets('an editor sees content work but no users or support', (
    tester,
  ) async {
    await _pump(tester, StaffRole.editor);
    expect(find.byKey(const ValueKey('todo-review')), findsNothing);
    expect(_count(tester, 'todo-drafts'), '1');
    expect(find.byKey(const ValueKey('todo-support')), findsNothing);
    expect(find.byKey(const ValueKey('guide-users')), findsNothing);
    expect(find.byKey(const ValueKey('guide-messages')), findsNothing);
  });

  testWidgets('a card opens its section', (tester) async {
    await _pump(tester, StaffRole.admin);
    await tester.tap(find.byKey(const ValueKey('todo-support')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('thread-1')), findsOneWidget);
  });
}
