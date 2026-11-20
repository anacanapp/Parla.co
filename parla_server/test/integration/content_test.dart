import 'dart:convert';

import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/content/content_admin_endpoint.dart';
import 'package:parla_server/src/content/content_seed_import.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

import 'staff_sign_in.dart';

Matcher _error(String code) =>
    isA<ParlaException>().having((e) => e.code, 'code', code);

Map<String, String> _l(String s) => {
  'az': '$s az',
  'ru': '$s ru',
  'en': '$s en',
};

final _article = jsonEncode({
  'title': _l('Qış'),
  'summary': _l('Qısa'),
  'body': _l('Mətn'),
  'minutes': 4,
});

final _expert = jsonEncode({
  'name': 'Dr. Test',
  'workplace': _l('Klinika'),
  'city': _l('Bakı'),
  'years': 8,
  'whatsapp': '+994501234567',
});

void main() {
  withServerpod('Given the content flow', (sessionBuilder, endpoints) {
    Future<TestSessionBuilder> staff(String email, StaffRole role) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      final s = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id.toString(),
          {},
          authId: await signInSession(db, user.id),
        ),
      );
      if (email.startsWith('first-admin')) {
        await endpoints.staff.claimFirstAdmin(s);
      } else {
        await endpoints.staff.acceptInvite(
          s,
          DevelopmentCodeSender.lastStaffInviteCode!,
        );
      }
      return s;
    }

    Future<
      ({
        TestSessionBuilder admin,
        TestSessionBuilder editor,
        TestSessionBuilder expert,
      })
    >
    team() async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      await endpoints.staffAdmin.invite(
        admin,
        'editor@example.com',
        StaffRole.editor,
      );
      final editor = await staff('editor@example.com', StaffRole.editor);
      await endpoints.staffAdmin.invite(
        admin,
        'expert@example.com',
        StaffRole.expert,
      );
      final expert = await staff('expert@example.com', StaffRole.expert);
      return (admin: admin, editor: editor, expert: expert);
    }

    test('an article goes draft, review, approval, publishing', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'article',
        'qis-deri',
        'care',
      );
      // Incomplete drafts may be saved but not sent for review.
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        jsonEncode({
          'title': {'az': 'Qış'},
        }),
        'care',
      );
      await expectLater(
        endpoints.contentAdmin.submitForReview(t.editor, item.id),
        throwsA(_error(ContentErrors.incomplete)),
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        _article,
        'care',
      );
      // Not approved yet: cannot be published.
      await expectLater(
        endpoints.contentAdmin.publish(t.editor, item.id),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
      await endpoints.contentAdmin.submitForReview(t.editor, item.id);
      // Editors cannot approve; experts can.
      await expectLater(
        endpoints.contentAdmin.approve(t.editor, item.id),
        throwsA(_error(StaffErrors.forbidden)),
      );
      await endpoints.contentAdmin.approve(t.expert, item.id);
      final published = await endpoints.contentAdmin.publish(
        t.editor,
        item.id,
      );
      expect(published.status, ContentStatus.published);
      expect(published.live, isTrue);

      final public = await endpoints.content.published(
        sessionBuilder,
        'article',
      );
      expect(public.single.slug, 'qis-deri');
      expect(public.single.reviewedAt, isNotNull);
      expect(public.single.json, _article);
    });

    test('editing a live article keeps the published copy until the next '
        'review and publishing', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'article',
        'spf',
        'care',
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        _article,
        'care',
      );
      await endpoints.contentAdmin.submitForReview(t.editor, item.id);
      await endpoints.contentAdmin.approve(t.expert, item.id);
      await endpoints.contentAdmin.publish(t.editor, item.id);

      final changed = jsonEncode({
        ...jsonDecode(_article) as Map,
        'minutes': 5,
      });
      final draft = await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        changed,
        'care',
      );
      expect(draft.status, ContentStatus.draft);
      expect(draft.live, isTrue);
      final public = await endpoints.content.published(
        sessionBuilder,
        'article',
      );
      expect(public.single.json, _article);
    });

    test('an expert returns a draft with a note', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'article',
        'note',
        'hair',
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        _article,
        'hair',
      );
      await endpoints.contentAdmin.submitForReview(t.editor, item.id);
      final back = await endpoints.contentAdmin.returnToWriter(
        t.expert,
        item.id,
        'Mənbə əlavə edin',
      );
      expect(back.status, ContentStatus.draft);
      expect(back.reviewNote, 'Mənbə əlavə edin');
    });

    test('expert profiles need the recorded consent to be published', () async {
      final t = await team();
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'expert',
        'dr-test',
        'dermatologist',
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        _expert,
        'dermatologist',
      );
      await expectLater(
        endpoints.contentAdmin.publish(t.editor, item.id),
        throwsA(_error(ContentErrors.consentMissing)),
      );
      await expectLater(
        endpoints.contentAdmin.recordConsent(t.editor, item.id, 'ref'),
        throwsA(_error(StaffErrors.forbidden)),
      );
      await endpoints.contentAdmin.recordConsent(
        t.admin,
        item.id,
        'Razılıq forması #12, ofis seyfi',
      );
      await endpoints.contentAdmin.publish(t.editor, item.id);
      final public = await endpoints.content.published(
        sessionBuilder,
        'expert',
      );
      expect(jsonDecode(public.single.json)['whatsapp'], '+994501234567');
      expect(public.single.reviewedAt, isNull);

      await endpoints.contentAdmin.unpublish(t.admin, item.id);
      expect(
        await endpoints.content.published(sessionBuilder, 'expert'),
        isEmpty,
      );
    });

    test('invalid content, slugs and categories are refused', () async {
      final t = await team();
      await expectLater(
        endpoints.contentAdmin.create(t.editor, 'article', 'Bad Slug', 'care'),
        throwsA(_error(ContentErrors.invalid)),
      );
      await expectLater(
        endpoints.contentAdmin.create(t.editor, 'article', 'ok', 'cars'),
        throwsA(_error(ContentErrors.invalid)),
      );
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'recipe',
        'yulaf',
        'breakfast',
      );
      await expectLater(
        endpoints.contentAdmin.create(t.editor, 'recipe', 'yulaf', 'lunch'),
        throwsA(_error(ContentErrors.slugTaken)),
      );
      await expectLater(
        endpoints.contentAdmin.saveDraft(
          t.editor,
          item.id,
          jsonEncode({'calories': 400}),
          'breakfast',
        ),
        throwsA(_error(ContentErrors.invalid)),
      );
      // Experts may not write.
      await expectLater(
        endpoints.contentAdmin.create(t.expert, 'article', 'x', 'care'),
        throwsA(_error(StaffErrors.forbidden)),
      );
    });

    test(
      'the public list needs no sign-in and holds only published items',
      () async {
        final t = await team();
        await endpoints.contentAdmin.create(
          t.editor,
          'article',
          'draft',
          'care',
        );
        expect(
          await endpoints.content.published(sessionBuilder, 'article'),
          isEmpty,
        );
        final rows = await AuditLogEntry.db.find(
          sessionBuilder.build(),
          where: (t) => t.action.equals('content.created'),
        );
        expect(rows, hasLength(1));
      },
    );

    test('the sheet import adds drafts once and keeps edits', () async {
      final t = await team();
      await expectLater(
        endpoints.contentAdmin.importSheet(t.editor),
        throwsA(_error(StaffErrors.forbidden)),
      );
      final added = await endpoints.contentAdmin.importSheet(t.admin);
      expect(added, importSeed.length);
      final recipes = await endpoints.contentAdmin.list(t.admin, 'recipe');
      final articles = await endpoints.contentAdmin.list(t.admin, 'article');
      expect(recipes.length + articles.length, importSeed.length);
      expect(
        [...recipes, ...articles].every((i) => i.status == ContentStatus.draft),
        isTrue,
      );
      expect([...recipes, ...articles].any((i) => i.live), isFalse);

      // An edited draft survives a second import.
      final oats = recipes.firstWhere((i) => i.slug == 'berry-oats');
      final edited = jsonEncode({
        ...jsonDecode(oats.draftJson) as Map<String, Object?>,
        'minutes': 12,
      });
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        oats.id,
        edited,
        'breakfast',
      );
      expect(await endpoints.contentAdmin.importSheet(t.admin), 0);
      final again = await endpoints.contentAdmin.list(t.admin, 'recipe');
      expect(
        jsonDecode(again.firstWhere((i) => i.slug == 'berry-oats').draftJson),
        containsPair('minutes', 12),
      );

      // The full articles are ready for the expert's review.
      final winter = articles.firstWhere((i) => i.slug == 'winter-dry-skin');
      final sent = await endpoints.contentAdmin.submitForReview(
        t.editor,
        winter.id,
      );
      expect(sent.status, ContentStatus.inReview);
      // Nothing imported is public.
      for (final kind in ['article', 'recipe']) {
        expect(
          await endpoints.content.published(sessionBuilder, kind),
          isEmpty,
        );
      }
    });

    test(
      'drafts that hold only the first writing plan get the full article',
      () async {
        final t = await team();
        final db = sessionBuilder.build();
        // As left by the first import: plans only, one of them edited.
        final plans = contentSeed.where((s) => s.kind == 'article').toList();
        final ids = <String, int>{};
        for (final p in plans) {
          final now = DateTime.now().toUtc();
          final row = await ContentItem.db.insertRow(
            db,
            ContentItem(
              kind: p.kind,
              slug: p.slug,
              category: p.category,
              status: ContentStatus.draft,
              draftJson: p.json,
              createdBy: UuidValue.fromString(
                '00000000-0000-4000-8000-000000000001',
              ),
              updatedBy: UuidValue.fromString(
                '00000000-0000-4000-8000-000000000001',
              ),
              createdAt: now,
              updatedAt: now,
            ),
          );
          ids[p.slug] = row.id!;
        }
        final edited = plans.firstWhere((p) => p.slug == 'winter-hands');
        await endpoints.contentAdmin.saveDraft(
          t.editor,
          ids['winter-hands']!,
          jsonEncode({
            ...jsonDecode(edited.json) as Map<String, Object?>,
            'minutes': 9,
          }),
          edited.category,
        );

        final changed = await endpoints.contentAdmin.importSheet(t.admin);
        // 20 new articles, 11 plans filled, the edited one kept; recipes.
        expect(changed, 20 + 11 + 20);
        final articles = await endpoints.contentAdmin.list(t.admin, 'article');
        expect(articles, hasLength(32));
        Map<String, Object?> draft(String slug) =>
            jsonDecode(articles.firstWhere((a) => a.slug == slug).draftJson)
                as Map<String, Object?>;
        final dry = draft('winter-dry-skin');
        final body = dry['body']! as Map<String, Object?>;
        expect(body.keys.toSet(), {'az', 'ru', 'en'});
        expect(body['az'], isNot(contains(ContentRules.planMarker)));
        expect(draft('winter-hands'), containsPair('minutes', 9));
        expect(
          (draft('winter-hands')['body']! as Map)['az'],
          startsWith(ContentRules.planMarker),
        );
        final audit = await AuditLogEntry.db.find(
          db,
          where: (a) => a.action.equals('content.reimported'),
        );
        expect(audit, hasLength(11));
        // A second run changes nothing.
        expect(await endpoints.contentAdmin.importSheet(t.admin), 0);

        // The owner's decision: admins publish the imported articles
        // without expert review; it stays visible in the audit and app.
        await expectLater(
          endpoints.contentAdmin.publishImportedArticles(t.editor),
          throwsA(_error(StaffErrors.forbidden)),
        );
        expect(
          await endpoints.contentAdmin.publishImportedArticles(t.admin),
          31, // all but the edited plan, which is incomplete
        );
        final live = await endpoints.content.published(
          sessionBuilder,
          'article',
        );
        expect(live, hasLength(31));
        expect(live.every((a) => a.reviewedAt == null), isTrue);
        expect(
          await AuditLogEntry.db.count(
            db,
            where: (a) => a.action.equals('content.published_unreviewed'),
          ),
          31,
        );
        expect(
          await endpoints.contentAdmin.publishImportedArticles(t.admin),
          0,
        );
      },
    );

    test('catalogue texts: known ids, review flow, hiding at once', () async {
      final t = await team();
      await expectLater(
        endpoints.contentAdmin.create(
          t.editor,
          'preference',
          'made-up',
          'catalogue',
        ),
        throwsA(_error(ContentErrors.invalid)),
      );
      final item = await endpoints.contentAdmin.create(
        t.editor,
        'preference',
        'fragrance_free',
        'catalogue',
      );
      // Logic fields are not editable here.
      await expectLater(
        endpoints.contentAdmin.saveDraft(
          t.editor,
          item.id,
          jsonEncode({
            'name': _l('Ətirsiz'),
            'contains': ['parfum'],
          }),
          'catalogue',
        ),
        throwsA(_error(ContentErrors.invalid)),
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        item.id,
        jsonEncode({'name': _l('Ətirsiz'), 'hint': _l('Ətir yoxdur')}),
        'catalogue',
      );
      await endpoints.contentAdmin.submitForReview(t.editor, item.id);
      await endpoints.contentAdmin.approve(t.expert, item.id);
      await endpoints.contentAdmin.publish(t.editor, item.id);
      var public = await endpoints.content.published(
        sessionBuilder,
        'preference',
      );
      expect(public.single.hidden, isFalse);
      expect(
        jsonDecode(public.single.json),
        containsPair('name', _l('Ətirsiz')),
      );

      // Hiding needs no review and also lists unpublished items.
      final other = await endpoints.contentAdmin.create(
        t.editor,
        'step',
        'face-toner',
        'catalogue',
      );
      await expectLater(
        endpoints.contentAdmin.setHidden(t.expert, other.id, true),
        throwsA(_error(StaffErrors.forbidden)),
      );
      final hidden = await endpoints.contentAdmin.setHidden(
        t.editor,
        other.id,
        true,
      );
      expect(hidden.hidden, isTrue);
      public = await endpoints.content.published(sessionBuilder, 'step');
      expect(public.single.slug, 'face-toner');
      expect(public.single.hidden, isTrue);
      expect(public.single.json, '{}');

      await endpoints.contentAdmin.setHidden(t.editor, other.id, false);
      expect(
        await endpoints.content.published(sessionBuilder, 'step'),
        isEmpty,
      );

      // Articles cannot be hidden this way.
      final article = await endpoints.contentAdmin.create(
        t.editor,
        'article',
        'qis',
        'care',
      );
      await expectLater(
        endpoints.contentAdmin.setHidden(t.editor, article.id, true),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
    });

    test('banners: admins publish their own; editors need an admin; brand '
        'campaigns need an expert', () async {
      final t = await team();
      Map<String, Object?> banner({String? sponsor}) => {
        'title': _l('Yeni bölmə'),
        'link': 'nutrition',
        'startsOn': '2026-12-01',
        'endsOn': '2026-12-31',
        'sponsor': ?sponsor,
      };

      // An admin publishes the team's own banner directly.
      final own = await endpoints.contentAdmin.create(
        t.admin,
        'banner',
        'qidalanma',
        'today',
      );
      await endpoints.contentAdmin.saveDraft(
        t.admin,
        own.id,
        jsonEncode(banner()),
        'today',
      );
      expect(
        (await endpoints.contentAdmin.publish(t.admin, own.id)).live,
        isTrue,
      );

      // An editor's banner needs an admin's approval; experts do not
      // review the team's own banners.
      final ed = await endpoints.contentAdmin.create(
        t.editor,
        'banner',
        'yeni-il',
        'discover',
      );
      await endpoints.contentAdmin.saveDraft(
        t.editor,
        ed.id,
        jsonEncode(banner()),
        'discover',
      );
      await expectLater(
        endpoints.contentAdmin.publish(t.editor, ed.id),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
      await endpoints.contentAdmin.submitForReview(t.editor, ed.id);
      await expectLater(
        endpoints.contentAdmin.approve(t.expert, ed.id),
        throwsA(_error(StaffErrors.forbidden)),
      );
      await endpoints.contentAdmin.approve(t.admin, ed.id);
      await endpoints.contentAdmin.publish(t.editor, ed.id);

      // A brand campaign: only an expert approves, and an admin cannot
      // skip that.
      final ad = await endpoints.contentAdmin.create(
        t.admin,
        'banner',
        'brand-x',
        'discover',
      );
      await endpoints.contentAdmin.saveDraft(
        t.admin,
        ad.id,
        jsonEncode(banner(sponsor: 'Brand X')),
        'discover',
      );
      await expectLater(
        endpoints.contentAdmin.publish(t.admin, ad.id),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
      await endpoints.contentAdmin.submitForReview(t.admin, ad.id);
      await expectLater(
        endpoints.contentAdmin.approve(t.admin, ad.id),
        throwsA(_error(StaffErrors.forbidden)),
      );
      await endpoints.contentAdmin.approve(t.expert, ad.id);
      await endpoints.contentAdmin.publish(t.admin, ad.id);

      final public = await endpoints.content.published(
        sessionBuilder,
        'banner',
      );
      expect(public.map((p) => p.slug).toSet(), {
        'qidalanma',
        'yeni-il',
        'brand-x',
      });
      expect(
        jsonDecode(public.singleWhere((p) => p.slug == 'brand-x').json),
        containsPair('sponsor', 'Brand X'),
      );
    });
  });
}
