import 'dart:convert';

import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/products/product_search.dart';
import 'package:test/test.dart';

String _obf(List<Map<String, Object?>> products) =>
    jsonEncode({'count': products.length, 'products': products});

ProductSummary _own(String code, String name, {String? brand}) =>
    ProductSummary(
      source: 'parla',
      code: code,
      productName: name,
      brand: brand,
    );

void main() {
  test('queries are trimmed and must be 2 to 80 characters', () {
    expect(ProductSearch.cleanQuery('  nivea   creme '), 'nivea creme');
    for (final bad in ['', ' a ', 'x' * 81]) {
      expect(
        () => ProductSearch.cleanQuery(bad),
        throwsA(
          isA<ParlaException>().having(
            (e) => e.code,
            'code',
            ProductErrors.queryInvalid,
          ),
        ),
      );
    }
  });

  test('the request asks only for the fields we show, without images', () {
    final uri = ProductSearch.openBeautyFactsUri('nivea');
    expect(uri.host, 'world.openbeautyfacts.org');
    expect(uri.queryParameters['search_terms'], 'nivea');
    expect(uri.queryParameters['fields'], isNot(contains('image')));
  });

  test('parsing keeps named products and the first brand', () {
    final parsed = ProductSearch.parseOpenBeautyFacts(
      _obf([
        {
          'code': '42164104',
          'product_name': 'Creme',
          'brands': 'NIVEA, Beiersdorf',
          'ingredients_text': 'Aqua, Glycerin',
        },
        {'code': '1', 'product_name': ''},
        {'product_name': 'No code'},
        {'code': '2', 'product_name_en': 'English only'},
      ]),
    );
    expect(parsed.map((p) => p.productName), ['Creme', 'English only']);
    expect(parsed.first.brand, 'NIVEA');
    expect(parsed.first.ingredientsText, 'Aqua, Glycerin');
    expect(
      parsed.first.sourceUrl,
      'https://world.openbeautyfacts.org/product/42164104',
    );
    expect(ProductSearch.parseOpenBeautyFacts('{"products": 3}'), isEmpty);
  });

  test('our catalogue comes first and is not duplicated', () async {
    final search = ProductSearch(
      fetch: (_) async => _obf([
        {'code': 'A1', 'product_name': 'Krem A'},
        {'code': 'B2', 'product_name': 'Krem B'},
      ]),
      catalog: [
        _own('A1', 'Krem A (ours)'),
        _own('Z9', 'Other', brand: 'X'),
      ],
    );
    final results = await search.search('krem');
    expect(results.map((p) => p.code), ['A1', 'B2']);
    expect(results.first.source, 'parla');
  });

  test('results are cached for a while, per query text only', () async {
    var calls = 0;
    var now = DateTime(2026, 11, 12, 10);
    final search = ProductSearch(
      fetch: (_) async {
        calls++;
        return _obf([]);
      },
      clock: () => now,
    );
    await search.search('Nivea');
    await search.search('nivea ');
    expect(calls, 1);
    now = now.add(ProductSearch.cacheTime);
    await search.search('nivea');
    expect(calls, 2);
  });

  test('a failing source still returns our own matches, or a clear '
      'error', () async {
    Future<String> down(Uri _) async => throw Exception('down');
    final withOwn = ProductSearch(
      fetch: down,
      catalog: [_own('A1', 'Krem A')],
    );
    expect((await withOwn.search('krem')).single.code, 'A1');

    final without = ProductSearch(fetch: down);
    expect(
      () => without.search('krem'),
      throwsA(
        isA<ParlaException>().having(
          (e) => e.code,
          'code',
          ProductErrors.sourceUnavailable,
        ),
      ),
    );
  });
}
