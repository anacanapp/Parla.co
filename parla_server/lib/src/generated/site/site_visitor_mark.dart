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

/// A visitor counted on [day]: an HMAC of the address and browser with
/// that day's random salt (SiteSalt). It only stops a visitor from being
/// counted twice the same day; marks and salts of earlier days are deleted
/// by the daily retention run, after which nothing links the count to
/// anyone.
abstract class SiteVisitorMark
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SiteVisitorMark._({
    this.id,
    required this.day,
    required this.mark,
  });

  factory SiteVisitorMark({
    int? id,
    required String day,
    required String mark,
  }) = _SiteVisitorMarkImpl;

  factory SiteVisitorMark.fromJson(Map<String, dynamic> jsonSerialization) {
    return SiteVisitorMark(
      id: jsonSerialization['id'] as int?,
      day: jsonSerialization['day'] as String,
      mark: jsonSerialization['mark'] as String,
    );
  }

  static final t = SiteVisitorMarkTable();

  static const db = SiteVisitorMarkRepository._();

  @override
  int? id;

  String day;

  String mark;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SiteVisitorMark]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SiteVisitorMark copyWith({
    int? id,
    String? day,
    String? mark,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SiteVisitorMark',
      if (id != null) 'id': id,
      'day': day,
      'mark': mark,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SiteVisitorMarkInclude include() {
    return SiteVisitorMarkInclude._();
  }

  static SiteVisitorMarkIncludeList includeList({
    _is.WhereExpressionBuilder<SiteVisitorMarkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteVisitorMarkTable>? orderBy,
    _is.OrderByListBuilder<SiteVisitorMarkTable>? orderByList,
    SiteVisitorMarkInclude? include,
  }) {
    return SiteVisitorMarkIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SiteVisitorMark.t),
      orderByList: orderByList?.call(SiteVisitorMark.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SiteVisitorMarkImpl extends SiteVisitorMark {
  _SiteVisitorMarkImpl({
    int? id,
    required String day,
    required String mark,
  }) : super._(
         id: id,
         day: day,
         mark: mark,
       );

  /// Returns a shallow copy of this [SiteVisitorMark]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SiteVisitorMark copyWith({
    Object? id = _Undefined,
    String? day,
    String? mark,
  }) {
    return SiteVisitorMark(
      id: id is int? ? id : this.id,
      day: day ?? this.day,
      mark: mark ?? this.mark,
    );
  }
}

class SiteVisitorMarkUpdateTable extends _is.UpdateTable<SiteVisitorMarkTable> {
  SiteVisitorMarkUpdateTable(super.table);

  _is.ColumnValue<String, String> day(String value) => _is.ColumnValue(
    table.day,
    value,
  );

  _is.ColumnValue<String, String> mark(String value) => _is.ColumnValue(
    table.mark,
    value,
  );
}

class SiteVisitorMarkTable extends _is.Table<int?> {
  SiteVisitorMarkTable({super.tableRelation})
    : super(tableName: 'site_visitor_mark') {
    updateTable = SiteVisitorMarkUpdateTable(this);
    day = _is.ColumnString(
      'day',
      this,
    );
    mark = _is.ColumnString(
      'mark',
      this,
    );
  }

  late final SiteVisitorMarkUpdateTable updateTable;

  late final _is.ColumnString day;

  late final _is.ColumnString mark;

  @override
  List<_is.Column> get columns => [
    id,
    day,
    mark,
  ];
}

class SiteVisitorMarkInclude extends _is.IncludeObject {
  SiteVisitorMarkInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SiteVisitorMark.t;
}

class SiteVisitorMarkIncludeList extends _is.IncludeList {
  SiteVisitorMarkIncludeList._({
    _is.WhereExpressionBuilder<SiteVisitorMarkTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SiteVisitorMark.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SiteVisitorMark.t;
}

class SiteVisitorMarkRepository {
  const SiteVisitorMarkRepository._();

  /// Returns a list of [SiteVisitorMark]s matching the given query parameters.
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
  Future<List<SiteVisitorMark>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteVisitorMarkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteVisitorMarkTable>? orderBy,
    _is.OrderByListBuilder<SiteVisitorMarkTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SiteVisitorMark>(
      where: where?.call(SiteVisitorMark.t),
      orderBy: orderBy?.call(SiteVisitorMark.t),
      orderByList: orderByList?.call(SiteVisitorMark.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [SiteVisitorMark]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `SiteVisitorMark.t`.
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
  _ida.Stream<List<SiteVisitorMark>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteVisitorMarkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteVisitorMarkTable>? orderBy,
    _is.OrderByListBuilder<SiteVisitorMarkTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<SiteVisitorMark>(
      where: where?.call(SiteVisitorMark.t),
      orderBy: orderBy?.call(SiteVisitorMark.t),
      orderByList: orderByList?.call(SiteVisitorMark.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [SiteVisitorMark] matching the given query parameters.
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
  Future<SiteVisitorMark?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteVisitorMarkTable>? where,
    int? offset,
    _is.OrderByBuilder<SiteVisitorMarkTable>? orderBy,
    _is.OrderByListBuilder<SiteVisitorMarkTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SiteVisitorMark>(
      where: where?.call(SiteVisitorMark.t),
      orderBy: orderBy?.call(SiteVisitorMark.t),
      orderByList: orderByList?.call(SiteVisitorMark.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SiteVisitorMark] by its [id] or null if no such row exists.
  Future<SiteVisitorMark?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SiteVisitorMark>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SiteVisitorMark]s in the list and returns the inserted rows.
  ///
  /// The returned [SiteVisitorMark]s will have their `id` fields set.
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
  Future<List<SiteVisitorMark>> insert(
    _is.DatabaseSession session,
    List<SiteVisitorMark> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SiteVisitorMark>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SiteVisitorMark] and returns the inserted row.
  ///
  /// The returned [SiteVisitorMark] will have its `id` field set.
  Future<SiteVisitorMark> insertRow(
    _is.DatabaseSession session,
    SiteVisitorMark row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SiteVisitorMark>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SiteVisitorMark]s in the list and returns the resulting rows.
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
  /// The returned [SiteVisitorMark]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteVisitorMark>> upsert(
    _is.DatabaseSession session,
    List<SiteVisitorMark> rows, {
    required _is.ColumnSelections<SiteVisitorMarkTable> conflictColumns,
    _is.ColumnSelections<SiteVisitorMarkTable>? updateColumns,
    _is.WhereExpressionBuilder<SiteVisitorMarkTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SiteVisitorMark>(
      rows,
      conflictColumns: conflictColumns(SiteVisitorMark.t),
      updateColumns: updateColumns?.call(SiteVisitorMark.t),
      updateWhere: updateWhere?.call(SiteVisitorMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SiteVisitorMark] and returns the resulting row.
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
  /// The returned [SiteVisitorMark] will have its `id` field set.
  Future<SiteVisitorMark?> upsertRow(
    _is.DatabaseSession session,
    SiteVisitorMark row, {
    required _is.ColumnSelections<SiteVisitorMarkTable> conflictColumns,
    _is.ColumnSelections<SiteVisitorMarkTable>? updateColumns,
    _is.WhereExpressionBuilder<SiteVisitorMarkTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SiteVisitorMark>(
      row,
      conflictColumns: conflictColumns(SiteVisitorMark.t),
      updateColumns: updateColumns?.call(SiteVisitorMark.t),
      updateWhere: updateWhere?.call(SiteVisitorMark.t),
      transaction: transaction,
    );
  }

  /// Updates all [SiteVisitorMark]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteVisitorMark>> update(
    _is.DatabaseSession session,
    List<SiteVisitorMark> rows, {
    _is.ColumnSelections<SiteVisitorMarkTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SiteVisitorMark>(
      rows,
      columns: columns?.call(SiteVisitorMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SiteVisitorMark]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SiteVisitorMark> updateRow(
    _is.DatabaseSession session,
    SiteVisitorMark row, {
    _is.ColumnSelections<SiteVisitorMarkTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SiteVisitorMark>(
      row,
      columns: columns?.call(SiteVisitorMark.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SiteVisitorMark] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SiteVisitorMark?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SiteVisitorMarkUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SiteVisitorMark>(
      id,
      columnValues: columnValues(SiteVisitorMark.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SiteVisitorMark]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteVisitorMark>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SiteVisitorMarkUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<SiteVisitorMarkTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteVisitorMarkTable>? orderBy,
    _is.OrderByListBuilder<SiteVisitorMarkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SiteVisitorMark>(
      columnValues: columnValues(SiteVisitorMark.t.updateTable),
      where: where(SiteVisitorMark.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SiteVisitorMark.t),
      orderByList: orderByList?.call(SiteVisitorMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SiteVisitorMark]s in the list and returns the deleted rows.
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
  Future<List<SiteVisitorMark>> delete(
    _is.DatabaseSession session,
    List<SiteVisitorMark> rows, {
    _is.OrderByBuilder<SiteVisitorMarkTable>? orderBy,
    _is.OrderByListBuilder<SiteVisitorMarkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SiteVisitorMark>(
      rows,
      orderBy: orderBy?.call(SiteVisitorMark.t),
      orderByList: orderByList?.call(SiteVisitorMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SiteVisitorMark].
  Future<SiteVisitorMark> deleteRow(
    _is.DatabaseSession session,
    SiteVisitorMark row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SiteVisitorMark>(
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
  Future<List<SiteVisitorMark>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SiteVisitorMarkTable> where,
    _is.OrderByBuilder<SiteVisitorMarkTable>? orderBy,
    _is.OrderByListBuilder<SiteVisitorMarkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SiteVisitorMark>(
      where: where(SiteVisitorMark.t),
      orderBy: orderBy?.call(SiteVisitorMark.t),
      orderByList: orderByList?.call(SiteVisitorMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteVisitorMarkTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SiteVisitorMark>(
      where: where?.call(SiteVisitorMark.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SiteVisitorMark] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SiteVisitorMarkTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SiteVisitorMark>(
      where: where(SiteVisitorMark.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
