import 'dart:convert';

import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/products/product_endpoint.dart';
import 'package:parla_server/src/products/product_search.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  const alice = '0b6c1f3e-8a4d-4c7e-9f21-3d5a7e9b1c01';

  withServerpod('Given the product endpoint', (sessionBuilder, endpoints) {
    final original = ProductEndpoint.instance;
    setUp(() {
      // Never call the real Open Beauty Facts from tests.
      ProductEndpoint.instance = ProductSearch(
        fetch: (_) async => jsonEncode({
          'products': [
            {'code': '1', 'product_name': 'Test krem', 'brands': 'Brand'},
          ],
        }),
      );
    });
    tearDown(() => ProductEndpoint.instance = original);

    test('signed-in users can search', () async {
      final session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(alice, {}),
      );
      final results = await endpoints.product.search(session, 'krem');
      expect(results.single.productName, 'Test krem');
    });

    test('search needs a signed-in user', () async {
      expect(
        () => endpoints.product.search(sessionBuilder, 'krem'),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('a too short query is refused with a stable code', () async {
      final session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(alice, {}),
      );
      expect(
        () => endpoints.product.search(session, 'k'),
        throwsA(
          isA<ParlaException>().having(
            (e) => e.code,
            'code',
            ProductErrors.queryInvalid,
          ),
        ),
      );
    });
  });
}
