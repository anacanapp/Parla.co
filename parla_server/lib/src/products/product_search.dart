import 'dart:convert';
import 'dart:io';

import '../generated/protocol.dart';

/// Error codes of product search. The app translates them.
abstract final class ProductErrors {
  static const queryInvalid = 'product.query_invalid';
  static const sourceUnavailable = 'product.source_unavailable';
}

/// Fetches a URL and returns the body; replaced in tests.
typedef Fetch = Future<String> Function(Uri uri);

/// Searches our catalogue and Open Beauty Facts.
///
/// Privacy: the app never calls Open Beauty Facts itself, so the user's IP
/// address does not reach a third party. Searches are not stored or logged
/// and are not linked to the user; the short cache below is keyed by the
/// query text only.
class ProductSearch {
  ProductSearch({
    Fetch? fetch,
    List<ProductSummary>? catalog,
    DateTime Function()? clock,
  }) : _fetch = fetch ?? _httpGet,
       _catalog = catalog ?? const [],
       _clock = clock ?? DateTime.now;

  static const minQuery = 2;
  static const maxQuery = 80;
  static const maxResults = 20;
  static const cacheTime = Duration(minutes: 10);
  static const cacheSize = 200;

  final Fetch _fetch;
  final List<ProductSummary> _catalog;
  final DateTime Function() _clock;
  final _cache = <String, (DateTime, List<ProductSummary>)>{};

  /// Trimmed, single-spaced query; throws [ParlaException] when too short or
  /// too long.
  static String cleanQuery(String query) {
    final q = query.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (q.length < minQuery || q.length > maxQuery) {
      throw ParlaException(code: ProductErrors.queryInvalid);
    }
    return q;
  }

  Future<List<ProductSummary>> search(String query) async {
    final q = cleanQuery(query);
    final key = q.toLowerCase();
    final cached = _cache[key];
    final now = _clock();
    if (cached != null && now.difference(cached.$1) < cacheTime) {
      return cached.$2;
    }

    final own = _catalog.where((p) => _matches(p, key)).toList();
    List<ProductSummary> external;
    try {
      external = parseOpenBeautyFacts(await _fetch(openBeautyFactsUri(q)));
    } on Object {
      // Our own catalogue still answers when the external source is down.
      if (own.isNotEmpty) return own.take(maxResults).toList();
      throw ParlaException(code: ProductErrors.sourceUnavailable);
    }
    final ownCodes = {for (final p in own) p.code};
    final results = [
      ...own,
      ...external.where((p) => !ownCodes.contains(p.code)),
    ].take(maxResults).toList();

    if (_cache.length >= cacheSize) _cache.remove(_cache.keys.first);
    _cache[key] = (now, results);
    return results;
  }

  static bool _matches(ProductSummary p, String key) =>
      p.productName.toLowerCase().contains(key) ||
      (p.brand?.toLowerCase().contains(key) ?? false);

  /// The Open Beauty Facts full-text search, asking only for the fields we
  /// show (no images: they would be loaded from a third party).
  static Uri openBeautyFactsUri(String query) => Uri.https(
    'world.openbeautyfacts.org',
    '/cgi/search.pl',
    {
      'search_terms': query,
      'search_simple': '1',
      'json': '1',
      'page_size': '$maxResults',
      'fields':
          'code,product_name,product_name_en,brands,ingredients_text,'
          'ingredients_text_en',
    },
  );

  /// Turns the search response into products; skips records without a name.
  static List<ProductSummary> parseOpenBeautyFacts(String body) {
    final json = jsonDecode(body);
    final products = json is Map ? json['products'] : null;
    if (products is! List) return const [];
    final results = <ProductSummary>[];
    for (final p in products) {
      if (p is! Map) continue;
      String? text(String field) {
        final v = p[field];
        return v is String && v.trim().isNotEmpty ? v.trim() : null;
      }

      final code = text('code');
      final name = text('product_name') ?? text('product_name_en');
      if (code == null || name == null) continue;
      results.add(
        ProductSummary(
          source: 'openbeautyfacts',
          code: code,
          productName: name,
          brand: text('brands')?.split(',').first.trim(),
          ingredientsText:
              text('ingredients_text') ?? text('ingredients_text_en'),
          sourceUrl: 'https://world.openbeautyfacts.org/product/$code',
        ),
      );
    }
    return results;
  }

  static Future<String> _httpGet(Uri uri) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    try {
      final request = await client.getUrl(uri);
      // Open Beauty Facts asks API users to identify the app.
      request.headers.set(HttpHeaders.userAgentHeader, 'Parla/0.1 (server)');
      final response = await request.close().timeout(
        const Duration(seconds: 8),
      );
      if (response.statusCode != 200) {
        throw HttpException('Status ${response.statusCode}', uri: uri);
      }
      return await response.transform(utf8.decoder).join();
    } finally {
      client.close(force: true);
    }
  }
}
