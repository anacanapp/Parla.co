import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../shop/shop.dart';

/// `POST /shop/epoint/result`: Epoint's report of a payment (form fields
/// `data` and `signature`). Only a report signed with Parla's private key
/// changes an order; its contents are never logged (they hold the
/// cardholder's name and card mask, which are dropped).
class EpointResultRoute extends Route {
  EpointResultRoute() : super(methods: {Method.post});

  static const _maxBody = 64 * 1024;

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final gateway = Shop.gatewayFor(session);
    if (gateway == null) return Response.notFound();
    final String body;
    try {
      body = await request.readAsString(maxLength: _maxBody);
    } on Object {
      return Response.badRequest();
    }
    final Map<String, String> form;
    try {
      form = Uri.splitQueryString(body);
    } on Object {
      return Response.badRequest();
    }
    final data = form['data'];
    final signature = form['signature'];
    if (data == null || signature == null) return Response.badRequest();
    final result = gateway.readResult(data, signature);
    if (result == null) {
      session.log(
        'Epoint report with a bad signature.',
        level: LogLevel.warning,
      );
      return Response.forbidden();
    }
    final known = await applyPaymentResult(session, result);
    return known
        ? Response.ok(body: Body.fromString('OK'))
        : Response.notFound();
  }
}

/// `GET /shop/done`: where Epoint sends the buyer back. A plain page that
/// asks to return to the app (which then reads the order's status). It
/// shows nothing about the order.
class ShopDoneRoute extends Route {
  ShopDoneRoute() : super(methods: {Method.get, Method.head});

  static const contentSecurityPolicy =
      "default-src 'none'; style-src 'unsafe-inline'; "
      "base-uri 'none'; form-action 'none'; frame-ancestors 'none'";

  static String page({required bool failed}) {
    final lines = failed
        ? const [
            'Ödəniş alınmadı. Parla tətbiqinə qayıdıb yenidən cəhd edə bilərsən.',
            'Оплата не прошла. Вернись в приложение Parla и попробуй снова.',
            'The payment did not go through. Go back to the Parla app to try again.',
          ]
        : const [
            'Ödəniş qəbul olundu. Parla tətbiqinə qayıt: sifarişin "Sifarişlərim" bölməsindədir.',
            'Оплата принята. Вернись в приложение Parla: заказ в разделе «Мои заказы».',
            'Payment received. Go back to the Parla app: your order is under "My orders".',
          ];
    final escape = const HtmlEscape();
    return '<!doctype html><html lang="az"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        '<meta name="robots" content="noindex">'
        '<title>Parla</title><style>'
        'body{font-family:system-ui,sans-serif;background:#FBF7F2;color:#1F1A17;'
        'margin:0;padding:48px 20px;line-height:1.5}'
        'main{max-width:480px;margin:auto}p{margin:0 0 16px}'
        '</style></head><body><main><h1>Parla</h1>'
        '${lines.map((l) => '<p>${escape.convert(l)}</p>').join()}'
        '</main></body></html>';
  }

  Future<Result> _serve(Request request) async {
    final failed = request.url.queryParameters['e'] == '1';
    return Response.ok(
      body: Body.fromString(
        page(failed: failed),
        mimeType: MimeType.html,
      ),
      headers: Headers.build((h) {
        h['Content-Security-Policy'] = [contentSecurityPolicy];
        h['Referrer-Policy'] = ['no-referrer'];
        h['Cache-Control'] = ['no-store'];
        h['X-Robots-Tag'] = ['noindex'];
      }),
    );
  }

  @override
  Future<Result> call(Request req) => _serve(req);

  @override
  Future<Result> handleCall(Session session, Request request) =>
      _serve(request);
}
