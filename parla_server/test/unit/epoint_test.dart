import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:parla_server/src/shop/epoint.dart';
import 'package:test/test.dart';

void main() {
  // Made with Python's hashlib, independently of this code:
  // base64(sha1('k' + data + 'k')).
  const data =
      'eyJvcmRlcl9pZCI6IlBBQkMiLCJzdGF0dXMiOiJzdWNjZXNzIiwiYW1vdW50IjoyNS4wLCJ0'
      'cmFuc2FjdGlvbiI6InRlMSIsImNhcmRfbmFtZSI6IkFZVEFOIiwiY2FyZF9tYXNrIjoiMTIz'
      'NDU2KioqKioqMTIzNCJ9';
  const signature = 't5AhG64hM+4vDQsPXMhN0Aq2BbQ=';

  test('a signed report is read; card details are not kept', () {
    final g = EpointGateway(publicKey: 'i1', privateKey: 'k');
    expect(g.sign(data), signature);
    final r = g.readResult(data, signature)!;
    expect(r.orderNumber, 'PABC');
    expect(r.success, isTrue);
    expect(r.amountQepik, 2500);
    expect(r.transaction, 'te1');
    // A wrong key or a changed report is refused.
    expect(
      EpointGateway(publicKey: 'i1', privateKey: 'x').readResult(
        data,
        signature,
      ),
      isNull,
    );
    expect(g.readResult('${data}x', signature), isNull);
    expect(g.readResult(data, ''), isNull);
  });

  test(
    'a payment request is signed form data with the order, in manat',
    () async {
      late Map<String, String> sent;
      final client = MockClient((req) async {
        expect(req.url.toString(), 'https://epoint.az/api/1/request');
        sent = Uri.splitQueryString(req.body);
        return http.Response(
          jsonEncode({
            'status': 'success',
            'transaction': 'te9',
            'redirect_url': 'https://epoint.az/pay/te9',
          }),
          200,
        );
      });
      final g = EpointGateway(publicKey: 'i1', privateKey: 'k', client: client);
      final started = await g.start(
        orderNumber: 'P1',
        amountQepik: 2505,
        language: 'ru',
        description: 'Parla P1',
        successUrl: 'https://parla.test/shop/done?o=P1',
        errorUrl: 'https://parla.test/shop/done?o=P1&e=1',
      );
      expect(started?.transaction, 'te9');
      expect(started?.url, 'https://epoint.az/pay/te9');
      expect(sent['signature'], g.sign(sent['data']!));
      final json = jsonDecode(utf8.decode(base64.decode(sent['data']!)));
      expect(json, {
        'public_key': 'i1',
        'amount': '25.05',
        'currency': 'AZN',
        'language': 'ru',
        'order_id': 'P1',
        'description': 'Parla P1',
        'success_redirect_url': 'https://parla.test/shop/done?o=P1',
        'error_redirect_url': 'https://parla.test/shop/done?o=P1&e=1',
      });
    },
  );

  test('a refused or broken answer starts nothing', () async {
    for (final answer in [
      http.Response(jsonEncode({'status': 'error'}), 200),
      http.Response('oops', 500),
      http.Response(
        jsonEncode({
          'status': 'success',
          'transaction': 't',
          'redirect_url': 'http://not-https',
        }),
        200,
      ),
    ]) {
      final g = EpointGateway(
        publicKey: 'i1',
        privateKey: 'k',
        client: MockClient((_) async => answer),
      );
      expect(
        await g.start(
          orderNumber: 'P1',
          amountQepik: 100,
          language: 'az',
          description: 'x',
          successUrl: 'https://a',
          errorUrl: 'https://b',
        ),
        isNull,
      );
    }
    expect(manat(5), '0.05');
    expect(manat(1250), '12.50');
  });
}
