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

/// Website totals: how often [metric] with [target] happened on [day]
/// (UTC). Only counts: no row names a visitor, and no cookie, IP address
/// or identifier is kept (owner, 2026-11-27). Kept for
/// UsageRules.keepMonths.
abstract class SiteStatDaily
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SiteStatDaily._({
    this.id,
    required this.day,
    required this.metric,
    required this.target,
    required this.times,
  });

  factory SiteStatDaily({
    int? id,
    required String day,
    required String metric,
    required String target,
    required int times,
  }) = _SiteStatDailyImpl;

  factory SiteStatDaily.fromJson(Map<String, dynamic> jsonSerialization) {
    return SiteStatDaily(
      id: jsonSerialization['id'] as int?,
      day: jsonSerialization['day'] as String,
      metric: jsonSerialization['metric'] as String,
      target: jsonSerialization['target'] as String,
      times: jsonSerialization['times'] as int,
    );
  }

  static final t = SiteStatDailyTable();

  static const db = SiteStatDailyRepository._();

  @override
  int? id;

  String day;

  /// SiteMetric name: view, visitors, language, referrer, campaign,
  /// device, browser, os, click, depth.
  String metric;

  /// The page, language, referring site, campaign, device, browser,
  /// system, button or "page|percent" (see SiteStats).
  String target;

  int times;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SiteStatDaily]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SiteStatDaily copyWith({
    int? id,
    String? day,
    String? metric,
    String? target,
    int? times,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SiteStatDaily',
      if (id != null) 'id': id,
      'day': day,
      'metric': metric,
      'target': target,
      'times': times,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SiteStatDaily',
      if (id != null) 'id': id,
      'day': day,
      'metric': metric,
      'target': target,
      'times': times,
    };
  }

  static SiteStatDailyInclude include() {
    return SiteStatDailyInclude._();
  }

  static SiteStatDailyIncludeList includeList({
    _is.WhereExpressionBuilder<SiteStatDailyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteStatDailyTable>? orderBy,
    _is.OrderByListBuilder<SiteStatDailyTable>? orderByList,
    SiteStatDailyInclude? include,
  }) {
    return SiteStatDailyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SiteStatDaily.t),
      orderByList: orderByList?.call(SiteStatDaily.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SiteStatDailyImpl extends SiteStatDaily {
  _SiteStatDailyImpl({
    int? id,
    required String day,
    required String metric,
    required String target,
    required int times,
  }) : super._(
         id: id,
         day: day,
         metric: metric,
         target: target,
         times: times,
       );

  /// Returns a shallow copy of this [SiteStatDaily]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SiteStatDaily copyWith({
    Object? id = _Undefined,
    String? day,
    String? metric,
    String? target,
    int? times,
  }) {
    return SiteStatDaily(
      id: id is int? ? id : this.id,
      day: day ?? this.day,
      metric: metric ?? this.metric,
      target: target ?? this.target,
      times: times ?? this.times,
    );
  }
}

class SiteStatDailyUpdateTable extends _is.UpdateTable<SiteStatDailyTable> {
  SiteStatDailyUpdateTable(super.table);

  _is.ColumnValue<String, String> day(String value) => _is.ColumnValue(
    table.day,
    value,
  );

  _is.ColumnValue<String, String> metric(String value) => _is.ColumnValue(
    table.metric,
    value,
  );

  _is.ColumnValue<String, String> target(String value) => _is.ColumnValue(
    table.target,
    value,
  );

  _is.ColumnValue<int, int> times(int value) => _is.ColumnValue(
    table.times,
    value,
  );
}

class SiteStatDailyTable extends _is.Table<int?> {
  SiteStatDailyTable({super.tableRelation})
    : super(tableName: 'site_stat_daily') {
    updateTable = SiteStatDailyUpdateTable(this);
    day = _is.ColumnString(
      'day',
      this,
    );
    metric = _is.ColumnString(
      'metric',
      this,
    );
    target = _is.ColumnString(
      'target',
      this,
    );
    times = _is.ColumnInt(
      'times',
      this,
    );
  }

  late final SiteStatDailyUpdateTable updateTable;

  late final _is.ColumnString day;

  /// SiteMetric name: view, visitors, language, referrer, campaign,
  /// device, browser, os, click, depth.
  late final _is.ColumnString metric;

  /// The page, language, referring site, campaign, device, browser,
  /// system, button or "page|percent" (see SiteStats).
  late final _is.ColumnString target;

  late final _is.ColumnInt times;

  @override
  List<_is.Column> get columns => [
    id,
    day,
    metric,
    target,
    times,
  ];
}

class SiteStatDailyInclude extends _is.IncludeObject {
  SiteStatDailyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SiteStatDaily.t;
}

class SiteStatDailyIncludeList extends _is.IncludeList {
  SiteStatDailyIncludeList._({
    _is.WhereExpressionBuilder<SiteStatDailyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SiteStatDaily.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SiteStatDaily.t;
}

class SiteStatDailyRepository {
  const SiteStatDailyRepository._();

  /// Returns a list of [SiteStatDaily]s matching the given query parameters.
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
  Future<List<SiteStatDaily>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteStatDailyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteStatDailyTable>? orderBy,
    _is.OrderByListBuilder<SiteStatDailyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SiteStatDaily>(
      where: where?.call(SiteStatDaily.t),
      orderBy: orderBy?.call(SiteStatDaily.t),
      orderByList: orderByList?.call(SiteStatDaily.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [SiteStatDaily]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `SiteStatDaily.t`.
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
  _ida.Stream<List<SiteStatDaily>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteStatDailyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteStatDailyTable>? orderBy,
    _is.OrderByListBuilder<SiteStatDailyTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<SiteStatDaily>(
      where: where?.call(SiteStatDaily.t),
      orderBy: orderBy?.call(SiteStatDaily.t),
      orderByList: orderByList?.call(SiteStatDaily.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [SiteStatDaily] matching the given query parameters.
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
  Future<SiteStatDaily?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteStatDailyTable>? where,
    int? offset,
    _is.OrderByBuilder<SiteStatDailyTable>? orderBy,
    _is.OrderByListBuilder<SiteStatDailyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SiteStatDaily>(
      where: where?.call(SiteStatDaily.t),
      orderBy: orderBy?.call(SiteStatDaily.t),
      orderByList: orderByList?.call(SiteStatDaily.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SiteStatDaily] by its [id] or null if no such row exists.
  Future<SiteStatDaily?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SiteStatDaily>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SiteStatDaily]s in the list and returns the inserted rows.
  ///
  /// The returned [SiteStatDaily]s will have their `id` fields set.
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
  Future<List<SiteStatDaily>> insert(
    _is.DatabaseSession session,
    List<SiteStatDaily> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SiteStatDaily>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SiteStatDaily] and returns the inserted row.
  ///
  /// The returned [SiteStatDaily] will have its `id` field set.
  Future<SiteStatDaily> insertRow(
    _is.DatabaseSession session,
    SiteStatDaily row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SiteStatDaily>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SiteStatDaily]s in the list and returns the resulting rows.
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
  /// The returned [SiteStatDaily]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteStatDaily>> upsert(
    _is.DatabaseSession session,
    List<SiteStatDaily> rows, {
    required _is.ColumnSelections<SiteStatDailyTable> conflictColumns,
    _is.ColumnSelections<SiteStatDailyTable>? updateColumns,
    _is.WhereExpressionBuilder<SiteStatDailyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SiteStatDaily>(
      rows,
      conflictColumns: conflictColumns(SiteStatDaily.t),
      updateColumns: updateColumns?.call(SiteStatDaily.t),
      updateWhere: updateWhere?.call(SiteStatDaily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SiteStatDaily] and returns the resulting row.
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
  /// The returned [SiteStatDaily] will have its `id` field set.
  Future<SiteStatDaily?> upsertRow(
    _is.DatabaseSession session,
    SiteStatDaily row, {
    required _is.ColumnSelections<SiteStatDailyTable> conflictColumns,
    _is.ColumnSelections<SiteStatDailyTable>? updateColumns,
    _is.WhereExpressionBuilder<SiteStatDailyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SiteStatDaily>(
      row,
      conflictColumns: conflictColumns(SiteStatDaily.t),
      updateColumns: updateColumns?.call(SiteStatDaily.t),
      updateWhere: updateWhere?.call(SiteStatDaily.t),
      transaction: transaction,
    );
  }

  /// Updates all [SiteStatDaily]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteStatDaily>> update(
    _is.DatabaseSession session,
    List<SiteStatDaily> rows, {
    _is.ColumnSelections<SiteStatDailyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SiteStatDaily>(
      rows,
      columns: columns?.call(SiteStatDaily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SiteStatDaily]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SiteStatDaily> updateRow(
    _is.DatabaseSession session,
    SiteStatDaily row, {
    _is.ColumnSelections<SiteStatDailyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SiteStatDaily>(
      row,
      columns: columns?.call(SiteStatDaily.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SiteStatDaily] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SiteStatDaily?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SiteStatDailyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SiteStatDaily>(
      id,
      columnValues: columnValues(SiteStatDaily.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SiteStatDaily]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteStatDaily>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SiteStatDailyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SiteStatDailyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteStatDailyTable>? orderBy,
    _is.OrderByListBuilder<SiteStatDailyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SiteStatDaily>(
      columnValues: columnValues(SiteStatDaily.t.updateTable),
      where: where(SiteStatDaily.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SiteStatDaily.t),
      orderByList: orderByList?.call(SiteStatDaily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SiteStatDaily]s in the list and returns the deleted rows.
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
  Future<List<SiteStatDaily>> delete(
    _is.DatabaseSession session,
    List<SiteStatDaily> rows, {
    _is.OrderByBuilder<SiteStatDailyTable>? orderBy,
    _is.OrderByListBuilder<SiteStatDailyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SiteStatDaily>(
      rows,
      orderBy: orderBy?.call(SiteStatDaily.t),
      orderByList: orderByList?.call(SiteStatDaily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SiteStatDaily].
  Future<SiteStatDaily> deleteRow(
    _is.DatabaseSession session,
    SiteStatDaily row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SiteStatDaily>(
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
  Future<List<SiteStatDaily>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SiteStatDailyTable> where,
    _is.OrderByBuilder<SiteStatDailyTable>? orderBy,
    _is.OrderByListBuilder<SiteStatDailyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SiteStatDaily>(
      where: where(SiteStatDaily.t),
      orderBy: orderBy?.call(SiteStatDaily.t),
      orderByList: orderByList?.call(SiteStatDaily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteStatDailyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SiteStatDaily>(
      where: where?.call(SiteStatDaily.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SiteStatDaily] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SiteStatDailyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SiteStatDaily>(
      where: where(SiteStatDaily.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
