import 'dart:convert';

import 'package:parla_server/src/ads/ad_admin_endpoint.dart';
import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/content/content_admin_endpoint.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
import 'package:parla_shared/parla_shared.dart';
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

Advertiser _advertiser(String name, {String? email}) => Advertiser(
  company: name,
  email: email,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

AdCampaign _campaign(
  int advertiserId, {
  String name = 'Yaz',
  String startsOn = '2026-12-01',
  String endsOn = '2026-12-31',
}) => AdCampaign(
  advertiserId: advertiserId,
  title: name,
  startsOn: startsOn,
  endsOn: endsOn,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

void main() {
  withServerpod('Given the ads section', (sessionBuilder, endpoints) {
    Future<TestSessionBuilder> staff(String email) async {
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
      final admin = await staff('first-admin@example.com');
      await endpoints.staffAdmin.invite(
        admin,
        'editor@example.com',
        StaffRole.editor,
      );
      final editor = await staff('editor@example.com');
      await endpoints.staffAdmin.invite(
        admin,
        'expert@example.com',
        StaffRole.expert,
      );
      final expert = await staff('expert@example.com');
      return (admin: admin, editor: editor, expert: expert);
    }

    test(
      'only admins keep advertisers and campaigns; input is checked',
      () async {
        final t = await team();
        final ads = endpoints.adAdmin;
        await expectLater(
          ads.saveAdvertiser(t.editor, _advertiser('Brand X')),
          throwsA(_error(StaffErrors.forbidden)),
        );
        await expectLater(
          ads.advertisers(t.expert),
          throwsA(_error(StaffErrors.forbidden)),
        );
        final brand = await ads.saveAdvertiser(
          t.admin,
          _advertiser('  Brand X ', email: 'Info@Brand.az'),
        );
        expect(brand.company, 'Brand X');
        expect(brand.email, 'info@brand.az');
        await expectLater(
          ads.saveAdvertiser(t.admin, _advertiser('brand x')),
          throwsA(_error(AdErrors.nameTaken)),
        );
        for (final bad in [
          _advertiser(''),
          _advertiser('B', email: 'not-an-email'),
          _advertiser('B').copyWith(contractStart: '2026-13-01'),
          _advertiser(
            'B',
          ).copyWith(contractStart: '2026-12-02', contractEnd: '2026-12-01'),
          _advertiser('x' * 81),
        ]) {
          await expectLater(
            ads.saveAdvertiser(t.admin, bad),
            throwsA(_error(AdErrors.invalid)),
          );
        }
        final renamed = await ads.saveAdvertiser(
          t.admin,
          brand.copyWith(company: 'Brand Y', contractNumber: 'M-12'),
        );
        expect(renamed.id, brand.id);
        expect(renamed.contractNumber, 'M-12');

        await expectLater(
          ads.saveCampaign(t.admin, _campaign(brand.id!, endsOn: '2026-11-30')),
          throwsA(_error(AdErrors.invalid)),
        );
        await expectLater(
          ads.saveCampaign(t.admin, _campaign(9999)),
          throwsA(_error(AdErrors.notFound)),
        );
        final c = await ads.saveCampaign(t.admin, _campaign(brand.id!));
        await expectLater(
          ads.saveCampaign(t.editor, _campaign(brand.id!)),
          throwsA(_error(StaffErrors.forbidden)),
        );
        // Writers and reviewers see the campaigns to choose from.
        final options = await ads.campaignOptions(t.editor);
        expect(options.single.id, c.id);
        expect(options.single.advertiser, 'Brand Y');
        expect(await ads.campaignOptions(t.expert), hasLength(1));

        // An advertiser with campaigns cannot be deleted.
        await expectLater(
          ads.deleteAdvertiser(t.admin, brand.id!),
          throwsA(_error(AdErrors.inUse)),
        );
        await ads.deleteCampaign(t.admin, c.id!);
        await ads.deleteAdvertiser(t.admin, brand.id!);
        expect(await ads.advertisers(t.admin), isEmpty);

        final db = sessionBuilder.build();
        final actions = (await AuditLogEntry.db.find(
          db,
        )).map((e) => e.action).where((a) => a.startsWith('ads.')).toList();
        expect(actions, [
          'ads.advertiser_saved',
          'ads.advertiser_saved',
          'ads.campaign_saved',
          'ads.campaign_deleted',
          'ads.advertiser_deleted',
        ]);
      },
    );

    test(
      'a campaign banner carries the brand, its dates and its link',
      () async {
        final t = await team();
        final ads = endpoints.adAdmin;
        final content = endpoints.contentAdmin;
        final brand = await ads.saveAdvertiser(t.admin, _advertiser('Brand X'));
        final c = await ads.saveCampaign(t.admin, _campaign(brand.id!));
        Map<String, Object?> banner({
          Object? campaign,
          String startsOn = '2026-12-05',
          String endsOn = '2026-12-20',
          List<String>? topics,
        }) => {
          'title': _l('Yaz kolleksiyası'),
          'url': 'https://brand.az/spring',
          'campaign': campaign ?? c.id,
          'startsOn': startsOn,
          'endsOn': endsOn,
          'topics': ?topics,
        };

        final item = await content.create(
          t.editor,
          'banner',
          'brand-x',
          'blog',
        );
        // The brand's name comes from the advertiser, whatever the draft says.
        final saved = await content.saveDraft(
          t.editor,
          item.id,
          jsonEncode({...banner(), 'sponsor': 'Someone else'}),
          'blog',
        );
        expect(jsonDecode(saved.draftJson), containsPair('sponsor', 'Brand X'));
        await expectLater(
          content.saveDraft(
            t.editor,
            item.id,
            jsonEncode(banner(endsOn: '2027-01-05')),
            'blog',
          ),
          throwsA(_error(ContentErrors.outsideCampaign)),
        );
        await expectLater(
          content.saveDraft(
            t.editor,
            item.id,
            jsonEncode(banner(campaign: 9999)),
            'blog',
          ),
          throwsA(_error(ContentErrors.invalid)),
        );
        // Topics must belong to the placement: article categories under
        // articles, meals under recipes.
        await expectLater(
          content.saveDraft(
            t.editor,
            item.id,
            jsonEncode(banner(topics: ['lunch'])),
            'blog',
          ),
          throwsA(_error(ContentErrors.invalid)),
        );
        await content.saveDraft(
          t.editor,
          item.id,
          jsonEncode(banner(topics: ['care', 'hair'])),
          'blog',
        );

        // A brand banner needs the expert's approval.
        await content.submitForReview(t.editor, item.id);
        await content.approve(t.expert, item.id);

        // Renamed brand: publishing writes the current name.
        await ads.saveAdvertiser(t.admin, brand.copyWith(company: 'Brand Z'));
        await content.publish(t.editor, item.id);
        final public = await endpoints.content.published(
          sessionBuilder,
          'banner',
        );
        final json = jsonDecode(public.single.json) as Map<String, Object?>;
        expect(json['sponsor'], 'Brand Z');
        expect(json['url'], 'https://brand.az/spring');
        expect(json['topics'], ['care', 'hair']);
        expect(public.single.category, 'blog');

        // The campaign cannot be deleted or shrunk past its banner.
        await expectLater(
          ads.deleteCampaign(t.admin, c.id!),
          throwsA(_error(AdErrors.inUse)),
        );
        await expectLater(
          ads.saveCampaign(t.admin, c.copyWith(endsOn: '2026-12-10')),
          throwsA(_error(AdErrors.inUse)),
        );
        await ads.saveCampaign(t.admin, c.copyWith(title: 'Yaz 2026'));
      },
    );

    test(
      'the report shows totals by day and banner, hiding small counts',
      () async {
        final t = await team();
        final ads = endpoints.adAdmin;
        final content = endpoints.contentAdmin;
        final brand = await ads.saveAdvertiser(t.admin, _advertiser('Brand X'));
        final c = await ads.saveCampaign(t.admin, _campaign(brand.id!));
        final item = await content.create(
          t.admin,
          'banner',
          'brand-x',
          'today',
        );
        await content.saveDraft(
          t.admin,
          item.id,
          jsonEncode({
            'title': _l('Yaz'),
            'link': 'check',
            'campaign': c.id,
            'startsOn': '2026-12-01',
            'endsOn': '2026-12-31',
          }),
          'today',
        );
        final db = sessionBuilder.build();
        Future<void> usage(String day, UsageEvent e, String target, int n) =>
            UsageDaily.db.insertRow(
              db,
              UsageDaily(
                day: day,
                country: 'AZ',
                platform: 'ios',
                event: e.name,
                target: target,
                times: n,
              ),
            );
        final id = '${item.id}';
        await usage('2026-12-01', UsageEvent.bannerView, id, 20);
        await usage('2026-12-01', UsageEvent.bannerTap, id, 3);
        await usage('2026-12-02', UsageEvent.bannerView, id, 5);
        await usage('2026-12-02', UsageEvent.bannerTap, id, 9);
        // Another banner and days outside the campaign are not counted.
        await usage('2026-12-01', UsageEvent.bannerView, '99999', 500);
        await usage('2026-11-30', UsageEvent.bannerView, id, 500);

        final r = await buildAdReport(
          db,
          c.id!,
          now: DateTime.utc(2026, 12, 3),
        );
        expect(r.advertiser, 'Brand X');
        expect(r.countedTo, '2026-12-03');
        expect(r.views, 25);
        expect(r.taps, 12);
        expect(
          [for (final d in r.days) d.label],
          [
            '2026-12-01',
            '2026-12-02',
            '2026-12-03',
          ],
        );
        expect(r.days.first.views, 20);
        expect(r.days.first.taps, isNull); // under 10: "<10"
        expect(r.days[1].views, isNull);
        expect(r.banners.single.label, 'Yaz az');
        expect(r.banners.single.views, 25);

        // Before the campaign starts there is nothing to count.
        final early = await buildAdReport(
          db,
          c.id!,
          now: DateTime.utc(2026, 11, 21),
        );
        expect(early.days, isEmpty);
        expect(early.views, isNull);

        // Admins only; reading a report is audited.
        await expectLater(
          ads.report(t.editor, c.id!),
          throwsA(_error(StaffErrors.forbidden)),
        );
        await ads.report(t.admin, c.id!);
        final audit = await AuditLogEntry.db.find(
          db,
          where: (e) => e.action.equals('ads.report_viewed'),
        );
        expect(audit.single.objectId, '${c.id}');
      },
    );
  });
}
