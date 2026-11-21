/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;
import '../shop/shop_order_status.dart' as _i78eg4or;

/// An order of a product sold in the app (phase 2). Card details never
/// reach Parla: the buyer pays on Epoint's page and Epoint reports the
/// result to `/shop/epoint/result`. The cardholder's name and card mask in
/// that report are dropped at once. Kept for accounting after the account
/// is deleted, with the user's id replaced by its pseudonym.
abstract class ShopOrder
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ShopOrder._({
    this.id,
    required this.number,
    required this.authUserId,
    required this.productId,
    required this.productSlug,
    required this.productTitle,
    required this.brand,
    required this.seller,
    required this.quantity,
    required this.unitQepik,
    required this.totalQepik,
    required this.status,
    this.transaction,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
  });

  factory ShopOrder({
    int? id,
    required String number,
    required _is.UuidValue authUserId,
    required int productId,
    required String productSlug,
    required String productTitle,
    required String brand,
    required String seller,
    required int quantity,
    required int unitQepik,
    required int totalQepik,
    required _i78eg4or.ShopOrderStatus status,
    String? transaction,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? paidAt,
  }) = _ShopOrderImpl;

  factory ShopOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShopOrder(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as String,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      productId: jsonSerialization['productId'] as int,
      productSlug: jsonSerialization['productSlug'] as String,
      productTitle: jsonSerialization['productTitle'] as String,
      brand: jsonSerialization['brand'] as String,
      seller: jsonSerialization['seller'] as String,
      quantity: jsonSerialization['quantity'] as int,
      unitQepik: jsonSerialization['unitQepik'] as int,
      totalQepik: jsonSerialization['totalQepik'] as int,
      status: _i78eg4or.ShopOrderStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      transaction: jsonSerialization['transaction'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
    );
  }

  static final t = ShopOrderTable();

  static const db = ShopOrderRepository._();

  @override
  int? id;

  /// Shown to the buyer and sent to Epoint as `order_id` (e.g. P7KQ2M9XA4).
  String number;

  _is.UuidValue authUserId;

  int productId;

  String productSlug;

  /// The product's name in az/ru/en at the time of the order (JSON).
  String productTitle;

  String brand;

  /// `parla` or `brand` (ContentRules.productSellers).
  String seller;

  int quantity;

  /// Price per item and total, in qəpik.
  int unitQepik;

  int totalQepik;

  _i78eg4or.ShopOrderStatus status;

  /// Epoint's transaction id.
  String? transaction;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? paidAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ShopOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShopOrder copyWith({
    int? id,
    String? number,
    _is.UuidValue? authUserId,
    int? productId,
    String? productSlug,
    String? productTitle,
    String? brand,
    String? seller,
    int? quantity,
    int? unitQepik,
    int? totalQepik,
    _i78eg4or.ShopOrderStatus? status,
    String? transaction,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? paidAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopOrder',
      if (id != null) 'id': id,
      'number': number,
      'authUserId': authUserId.toJson(),
      'productId': productId,
      'productSlug': productSlug,
      'productTitle': productTitle,
      'brand': brand,
      'seller': seller,
      'quantity': quantity,
      'unitQepik': unitQepik,
      'totalQepik': totalQepik,
      'status': status.toJson(),
      if (transaction != null) 'transaction': transaction,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShopOrder',
      if (id != null) 'id': id,
      'number': number,
      'authUserId': authUserId.toJson(),
      'productId': productId,
      'productSlug': productSlug,
      'productTitle': productTitle,
      'brand': brand,
      'seller': seller,
      'quantity': quantity,
      'unitQepik': unitQepik,
      'totalQepik': totalQepik,
      'status': status.toJson(),
      if (transaction != null) 'transaction': transaction,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
    };
  }

  static ShopOrderInclude include() {
    return ShopOrderInclude._();
  }

  static ShopOrderIncludeList includeList({
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    ShopOrderInclude? include,
  }) {
    return ShopOrderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShopOrderImpl extends ShopOrder {
  _ShopOrderImpl({
    int? id,
    required String number,
    required _is.UuidValue authUserId,
    required int productId,
    required String productSlug,
    required String productTitle,
    required String brand,
    required String seller,
    required int quantity,
    required int unitQepik,
    required int totalQepik,
    required _i78eg4or.ShopOrderStatus status,
    String? transaction,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? paidAt,
  }) : super._(
         id: id,
         number: number,
         authUserId: authUserId,
         productId: productId,
         productSlug: productSlug,
         productTitle: productTitle,
         brand: brand,
         seller: seller,
         quantity: quantity,
         unitQepik: unitQepik,
         totalQepik: totalQepik,
         status: status,
         transaction: transaction,
         createdAt: createdAt,
         updatedAt: updatedAt,
         paidAt: paidAt,
       );

  /// Returns a shallow copy of this [ShopOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShopOrder copyWith({
    Object? id = _Undefined,
    String? number,
    _is.UuidValue? authUserId,
    int? productId,
    String? productSlug,
    String? productTitle,
    String? brand,
    String? seller,
    int? quantity,
    int? unitQepik,
    int? totalQepik,
    _i78eg4or.ShopOrderStatus? status,
    Object? transaction = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? paidAt = const _is.$UndefinedDateTime(),
  }) {
    return ShopOrder(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
      authUserId: authUserId ?? this.authUserId,
      productId: productId ?? this.productId,
      productSlug: productSlug ?? this.productSlug,
      productTitle: productTitle ?? this.productTitle,
      brand: brand ?? this.brand,
      seller: seller ?? this.seller,
      quantity: quantity ?? this.quantity,
      unitQepik: unitQepik ?? this.unitQepik,
      totalQepik: totalQepik ?? this.totalQepik,
      status: status ?? this.status,
      transaction: transaction is String? ? transaction : this.transaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paidAt: paidAt is _is.UndefinedSentinel ? this.paidAt : paidAt,
    );
  }
}

class ShopOrderUpdateTable extends _is.UpdateTable<ShopOrderTable> {
  ShopOrderUpdateTable(super.table);

  _is.ColumnValue<String, String> number(String value) => _is.ColumnValue(
    table.number,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<int, int> productId(int value) => _is.ColumnValue(
    table.productId,
    value,
  );

  _is.ColumnValue<String, String> productSlug(String value) => _is.ColumnValue(
    table.productSlug,
    value,
  );

  _is.ColumnValue<String, String> productTitle(String value) => _is.ColumnValue(
    table.productTitle,
    value,
  );

  _is.ColumnValue<String, String> brand(String value) => _is.ColumnValue(
    table.brand,
    value,
  );

  _is.ColumnValue<String, String> seller(String value) => _is.ColumnValue(
    table.seller,
    value,
  );

  _is.ColumnValue<int, int> quantity(int value) => _is.ColumnValue(
    table.quantity,
    value,
  );

  _is.ColumnValue<int, int> unitQepik(int value) => _is.ColumnValue(
    table.unitQepik,
    value,
  );

  _is.ColumnValue<int, int> totalQepik(int value) => _is.ColumnValue(
    table.totalQepik,
    value,
  );

  _is.ColumnValue<_i78eg4or.ShopOrderStatus, _i78eg4or.ShopOrderStatus> status(
    _i78eg4or.ShopOrderStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> transaction(String? value) => _is.ColumnValue(
    table.transaction,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> paidAt(DateTime? value) =>
      _is.ColumnValue(
        table.paidAt,
        value,
      );
}

class ShopOrderTable extends _is.Table<int?> {
  ShopOrderTable({super.tableRelation}) : super(tableName: 'shop_order') {
    updateTable = ShopOrderUpdateTable(this);
    number = _is.ColumnString(
      'number',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    productId = _is.ColumnInt(
      'productId',
      this,
    );
    productSlug = _is.ColumnString(
      'productSlug',
      this,
    );
    productTitle = _is.ColumnString(
      'productTitle',
      this,
    );
    brand = _is.ColumnString(
      'brand',
      this,
    );
    seller = _is.ColumnString(
      'seller',
      this,
    );
    quantity = _is.ColumnInt(
      'quantity',
      this,
    );
    unitQepik = _is.ColumnInt(
      'unitQepik',
      this,
    );
    totalQepik = _is.ColumnInt(
      'totalQepik',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    transaction = _is.ColumnString(
      'transaction',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
    paidAt = _is.ColumnDateTime(
      'paidAt',
      this,
    );
  }

  late final ShopOrderUpdateTable updateTable;

  /// Shown to the buyer and sent to Epoint as `order_id` (e.g. P7KQ2M9XA4).
  late final _is.ColumnString number;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnInt productId;

  late final _is.ColumnString productSlug;

  /// The product's name in az/ru/en at the time of the order (JSON).
  late final _is.ColumnString productTitle;

  late final _is.ColumnString brand;

  /// `parla` or `brand` (ContentRules.productSellers).
  late final _is.ColumnString seller;

  late final _is.ColumnInt quantity;

  /// Price per item and total, in qəpik.
  late final _is.ColumnInt unitQepik;

  late final _is.ColumnInt totalQepik;

  late final _is.ColumnEnum<_i78eg4or.ShopOrderStatus> status;

  /// Epoint's transaction id.
  late final _is.ColumnString transaction;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime paidAt;

  @override
  List<_is.Column> get columns => [
    id,
    number,
    authUserId,
    productId,
    productSlug,
    productTitle,
    brand,
    seller,
    quantity,
    unitQepik,
    totalQepik,
    status,
    transaction,
    createdAt,
    updatedAt,
    paidAt,
  ];
}

class ShopOrderInclude extends _is.IncludeObject {
  ShopOrderInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ShopOrder.t;
}

class ShopOrderIncludeList extends _is.IncludeList {
  ShopOrderIncludeList._({
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShopOrder.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ShopOrder.t;
}

class ShopOrderRepository {
  const ShopOrderRepository._();

  /// Returns a list of [ShopOrder]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ShopOrder>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ShopOrder>(
      where: where?.call(ShopOrder.t),
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ShopOrder]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `ShopOrder.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<ShopOrder>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ShopOrder>(
      where: where?.call(ShopOrder.t),
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ShopOrder] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ShopOrder?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    int? offset,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ShopOrder>(
      where: where?.call(ShopOrder.t),
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ShopOrder] by its [id] or null if no such row exists.
  Future<ShopOrder?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ShopOrder>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ShopOrder]s in the list and returns the inserted rows.
  ///
  /// The returned [ShopOrder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> insert(
    _is.DatabaseSession session,
    List<ShopOrder> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ShopOrder>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ShopOrder] and returns the inserted row.
  ///
  /// The returned [ShopOrder] will have its `id` field set.
  Future<ShopOrder> insertRow(
    _is.DatabaseSession session,
    ShopOrder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShopOrder>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ShopOrder]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ShopOrder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> upsert(
    _is.DatabaseSession session,
    List<ShopOrder> rows, {
    required _is.ColumnSelections<ShopOrderTable> conflictColumns,
    _is.ColumnSelections<ShopOrderTable>? updateColumns,
    _is.WhereExpressionBuilder<ShopOrderTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ShopOrder>(
      rows,
      conflictColumns: conflictColumns(ShopOrder.t),
      updateColumns: updateColumns?.call(ShopOrder.t),
      updateWhere: updateWhere?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ShopOrder] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ShopOrder] will have its `id` field set.
  Future<ShopOrder?> upsertRow(
    _is.DatabaseSession session,
    ShopOrder row, {
    required _is.ColumnSelections<ShopOrderTable> conflictColumns,
    _is.ColumnSelections<ShopOrderTable>? updateColumns,
    _is.WhereExpressionBuilder<ShopOrderTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ShopOrder>(
      row,
      conflictColumns: conflictColumns(ShopOrder.t),
      updateColumns: updateColumns?.call(ShopOrder.t),
      updateWhere: updateWhere?.call(ShopOrder.t),
      transaction: transaction,
    );
  }

  /// Updates all [ShopOrder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> update(
    _is.DatabaseSession session,
    List<ShopOrder> rows, {
    _is.ColumnSelections<ShopOrderTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ShopOrder>(
      rows,
      columns: columns?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ShopOrder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShopOrder> updateRow(
    _is.DatabaseSession session,
    ShopOrder row, {
    _is.ColumnSelections<ShopOrderTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShopOrder>(
      row,
      columns: columns?.call(ShopOrder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShopOrder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShopOrder?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ShopOrderUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ShopOrder>(
      id,
      columnValues: columnValues(ShopOrder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShopOrder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ShopOrderUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ShopOrderTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ShopOrder>(
      columnValues: columnValues(ShopOrder.t.updateTable),
      where: where(ShopOrder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ShopOrder]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> delete(
    _is.DatabaseSession session,
    List<ShopOrder> rows, {
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ShopOrder>(
      rows,
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ShopOrder].
  Future<ShopOrder> deleteRow(
    _is.DatabaseSession session,
    ShopOrder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShopOrder>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ShopOrderTable> where,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ShopOrder>(
      where: where(ShopOrder.t),
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ShopOrder>(
      where: where?.call(ShopOrder.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ShopOrder] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ShopOrderTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ShopOrder>(
      where: where(ShopOrder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
