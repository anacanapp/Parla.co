import 'dart:convert';
import 'dart:io';

import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/site/site_routes.dart';
import 'package:parla_server/src/site/site_stats.dart';
import 'package:parla_server/src/site/site_stats_admin_endpoint.dart';
import 'package:parla_server/src/stats/activity.dart' show dayOf;
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _phone =
    'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) '
    'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 '
    'Safari/604.1';

final _team = UuidValue.fromString('00000000-0000-4000-8000-000000000001');

void main() {
  withServerpod('Given the website', (sessionBuilder, endpoints) {
    late SitePageRoute route;

    setUp(() async {
      route = SitePageRoute(
        SiteConfig(
          assets: Directory('web/site/assets'),
          legal: Directory('../parla_flutter/assets/legal'),
        ),
      );
      final db = sessionBuilder.build();
      Future<void> publish(String slug, Map<String, Object?> data) async {
        final now = DateTime.now().toUtc();
        await ContentItem.db.insertRow(
          db,
          ContentItem(
            kind: 'article',
            slug: slug,
            category: 'care',
            status: ContentStatus.published,
            draftJson: jsonEncode(data),
            publishedJson: jsonEncode(data),
            publishedAt: now,
            createdBy: _team,
            updatedBy: _team,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      await publish('winter-skin', {
        'title': {'az': 'Qışda dəri', 'ru': 'Кожа зимой', 'en': 'Winter skin'},
        'summary': {'az': 'Qısa', 'ru': 'Коротко', 'en': 'Short'},
        'body': {
          'az':
              '## Nə etməli\n\n- Nəmləndir\n\n<script>alert(1)</script> '
              '[bax](javascript:alert(1)) [mənbə](https://aad.org/x)',
          'ru': 'Текст',
          'en': 'Text',
        },
        'minutes': 4,
        'sources': ['https://aad.org/x'],
      });
      await publish('az-only', {
        'title': {'az': 'Yalnız AZ', 'ru': 'Только AZ', 'en': 'AZ only'},
        'summary': {'az': 'Q', 'ru': 'К', 'en': 'S'},
        'body': {'az': 'M', 'ru': 'Т', 'en': 'T'},
        'minutes': 2,
        'countries': ['AZ'],
      });
    });

    Future<(int, String)> get(String path, {String ua = _phone, String? ip}) =>
        route.serve(
          sessionBuilder.build(),
          SiteVisit(path: path, userAgent: ua, forwardedFor: ip ?? '10.0.0.1'),
        );

    test('the home page lists articles for every country only', () async {
      final (status, html) = await get('/');
      expect(status, 200);
      expect(html, contains('<html lang="az">'));
      expect(html, contains('Qışda dəri'));
      // The website does not know the visitor's country.
      expect(html, isNot(contains('Yalnız AZ')));
      final (_, ru) = await get('/ru');
      expect(ru, contains('<html lang="ru">'));
      expect(ru, contains('Кожа зимой'));
      expect(ru, contains('href="/ru/blog/winter-skin"'));
    });

    test('an article is rendered safely', () async {
      final (status, html) = await get('/blog/winter-skin');
      expect(status, 200);
      expect(html, contains('<h2>Nə etməli</h2>'));
      expect(html, contains('<li>Nəmləndir</li>'));
      expect(html, isNot(contains('<script>alert')));
      expect(html, contains('&lt;script&gt;'));
      expect(html, isNot(contains('javascript:')));
      expect(
        html,
        contains('href="https://aad.org/x" rel="noopener nofollow"'),
      );
      expect((await get('/blog/az-only')).$1, 404);
      expect((await get('/blog/missing')).$1, 404);
      expect((await get('/en/nothing')).$1, 404);
    });

    test('the privacy page starts with the website notice', () async {
      final (status, html) = await get('/privacy');
      expect(status, 200);
      expect(html, contains('Bu sayt haqqında'));
      expect(html, contains('cookie'));
      expect(html, contains('VÖEN'));
      final (_, terms) = await get('/en/terms');
      expect(terms, contains('<html lang="en">'));
    });

    test('views are daily totals; a visitor counts once a day', () async {
      await get('/', ip: '10.0.0.1');
      await get('/blog', ip: '10.0.0.1');
      await get('/', ip: '10.0.0.2');
      await get('/', ua: 'Googlebot/2.1', ip: '10.0.0.3');
      await route.serve(
        sessionBuilder.build(),
        const SiteVisit(
          path: '/ru',
          userAgent: _phone,
          forwardedFor: '10.0.0.4',
          referer: 'https://www.instagram.com/p/abc?x=1',
          query: {'utm_source': 'Instagram', 'utm_campaign': 'Launch 1'},
        ),
      );
      final db = sessionBuilder.build();
      final rows = await SiteStatDaily.db.find(db);
      int count(String metric, String target) => rows
          .where((r) => r.metric == metric && r.target == target)
          .fold(0, (a, r) => a + r.times);
      expect(count('view', '/'), 3);
      expect(count('view', '/blog'), 1);
      expect(count('visitors', 'all'), 3);
      expect(count('device', 'mobile'), 4);
      expect(count('browser', 'safari'), 4);
      expect(count('os', 'ios'), 4);
      expect(count('language', 'ru'), 1);
      expect(count('referrer', 'instagram.com'), 1);
      expect(count('campaign', 'instagram / - / launch1'), 1);
      // Nothing names the visitor: no address is stored anywhere.
      final marks = await SiteVisitorMark.db.find(db);
      expect(marks, hasLength(3));
      expect(marks.every((m) => !m.mark.contains('10.0.0')), isTrue);
    });

    test('clicks and reading depth count only known keys', () async {
      final db = sessionBuilder.build();
      expect(
        await SiteStats.recordEvent(
          db,
          kind: 'click',
          key: 'appstore',
          page: '/',
        ),
        isTrue,
      );
      expect(
        await SiteStats.recordEvent(db, kind: 'depth', key: '50', page: '/'),
        isTrue,
      );
      expect(
        await SiteStats.recordEvent(db, kind: 'click', key: 'x<y', page: '/'),
        isFalse,
      );
      final report = await buildSiteReport(db, 7);
      final clicks = report.groups.firstWhere((g) => g.metric == 'site:click');
      expect(clicks.counts.single.label, 'appstore');
      final depth = report.groups.firstWhere((g) => g.metric == 'site:depth');
      expect(depth.counts.single.label, '/|50');
    });

    test('marks and salts are deleted the next day', () async {
      await get('/');
      final db = sessionBuilder.build();
      expect(await SiteSalt.db.count(db), 1);
      final tomorrow = DateTime.now().toUtc().add(const Duration(days: 1));
      expect(await expireSiteMarks(db, now: tomorrow), 1);
      expect(await SiteVisitorMark.db.count(db), 0);
      expect(await SiteSalt.db.count(db), 0);
      // The totals stay.
      expect(
        await SiteStatDaily.db.count(
          db,
          where: (t) => t.day.equals(dayOf(DateTime.now())),
        ),
        greaterThan(0),
      );
    });
  });
}
