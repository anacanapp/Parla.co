import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// The money for one order, as a payment page shows it.
String manat(int qepik) =>
    '${qepik ~/ 100}.${(qepik % 100).toString().padLeft(2, '0')}';

/// What a payment provider reported about one payment. Only what Parla
/// needs: the cardholder's name, card mask and bank references in the
/// report are never read into this.
class PaymentResult {
  const PaymentResult({
    required this.orderNumber,
    required this.success,
    required this.amountQepik,
    this.transaction,
  });

  final String orderNumber;
  final bool success;
  final int? amountQepik;
  final String? transaction;
}

/// Takes card payments on the provider's own page. Replaced in tests.
abstract class PaymentGateway {
  /// Starts a payment; returns the provider's transaction and the page to
  /// open, or `null` when the provider refused or could not be reached.
  Future<({String transaction, String url})?> start({
    required String orderNumber,
    required int amountQepik,
    required String language,
    required String description,
    required String successUrl,
    required String errorUrl,
  });

  /// The provider's status of [transaction]: `new`, `success`, `returned`,
  /// `error`, or `null` when it could not be asked.
  Future<String?> status(String transaction);

  /// Returns the money of [transaction] to the card.
  Future<bool> reverse(String transaction, int amountQepik, String language);

  /// The provider's result report, or `null` when it is not genuine.
  PaymentResult? readResult(String data, String signature);
}

/// Epoint (epoint.az), API v1. Requests and reports are a base64 JSON
/// `data` with `signature = base64(sha1(private_key + data +
/// private_key))`. The card is entered on Epoint's page only.
class EpointGateway implements PaymentGateway {
  EpointGateway({
    required this.publicKey,
    required this._privateKey,
    http.Client? client,
    this.base = 'https://epoint.az/api/1',
    this.timeout = const Duration(seconds: 20),
  }) : _client = client ?? http.Client();

  final String publicKey;
  final String _privateKey;
  final http.Client _client;
  final String base;
  final Duration timeout;

  String sign(String data) => base64.encode(
    sha1.convert(utf8.encode('$_privateKey$data$_privateKey')).bytes,
  );

  Future<Map<String, Object?>?> _post(
    String path,
    Map<String, Object?> json,
  ) async {
    final data = base64.encode(utf8.encode(jsonEncode(json)));
    try {
      final res = await _client
          .post(
            Uri.parse('$base/$path'),
            body: {'data': data, 'signature': sign(data)},
          )
          .timeout(timeout);
      if (res.statusCode != 200) return null;
      final body = jsonDecode(res.body);
      return body is Map<String, Object?> ? body : null;
    } on Object {
      return null;
    }
  }

  @override
  Future<({String transaction, String url})?> start({
    required String orderNumber,
    required int amountQepik,
    required String language,
    required String description,
    required String successUrl,
    required String errorUrl,
  }) async {
    final res = await _post('request', {
      'public_key': publicKey,
      'amount': manat(amountQepik),
      'currency': 'AZN',
      'language': const {'az', 'ru', 'en'}.contains(language) ? language : 'az',
      'order_id': orderNumber,
      'description': description,
      'success_redirect_url': successUrl,
      'error_redirect_url': errorUrl,
    });
    final url = res?['redirect_url'];
    final transaction = res?['transaction'];
    if (res?['status'] != 'success' ||
        url is! String ||
        transaction is! String ||
        !url.startsWith('https://')) {
      return null;
    }
    return (transaction: transaction, url: url);
  }

  @override
  Future<String?> status(String transaction) async {
    final res = await _post('get-status', {
      'public_key': publicKey,
      'transaction': transaction,
    });
    final s = res?['status'];
    return s is String ? s : null;
  }

  @override
  Future<bool> reverse(
    String transaction,
    int amountQepik,
    String language,
  ) async {
    final res = await _post('reverse', {
      'public_key': publicKey,
      'language': language,
      'transaction': transaction,
      'amount': manat(amountQepik),
      'currency': 'AZN',
    });
    return res?['status'] == 'success';
  }

  @override
  PaymentResult? readResult(String data, String signature) {
    final expected = utf8.encode(sign(data));
    final given = utf8.encode(signature);
    // Constant-time comparison.
    var diff = expected.length ^ given.length;
    for (var i = 0; i < expected.length && i < given.length; i++) {
      diff |= expected[i] ^ given[i];
    }
    if (diff != 0) return null;
    try {
      final json = jsonDecode(utf8.decode(base64.decode(data)));
      if (json is! Map<String, Object?>) return null;
      final order = json['order_id'];
      if (order is! String) return null;
      final amount = json['amount'];
      final qepik = amount is num
          ? (amount * 100).round()
          : amount is String
          ? ((double.tryParse(amount) ?? -1) * 100).round()
          : null;
      final transaction = json['transaction'];
      return PaymentResult(
        orderNumber: order,
        success: json['status'] == 'success',
        amountQepik: qepik != null && qepik >= 0 ? qepik : null,
        transaction: transaction is String ? transaction : null,
      );
    } on Object {
      return null;
    }
  }
}
