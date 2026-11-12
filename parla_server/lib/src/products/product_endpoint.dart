import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'catalog.dart';
import 'product_search.dart';

/// Product search (M-20). Signed-in users only for now, which also limits
/// load on Open Beauty Facts; guests get it with the guest flow.
class ProductEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Shared by all sessions so the cache works across requests.
  static ProductSearch instance = ProductSearch(catalog: parlaCatalog);

  /// Products whose name or brand matches [query] (2 to 80 characters).
  Future<List<ProductSummary>> search(Session session, String query) =>
      instance.search(query);
}
