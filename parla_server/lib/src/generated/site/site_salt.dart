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

/// The random salt of [day]'s visitor marks; deleted with them.
abstract class SiteSalt
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SiteSalt._({
    this.id,
    required this.day,
    required this.salt,
  });

  factory SiteSalt({
    int? id,
    required String day,
    required String salt,
  }) = _SiteSaltImpl;

  factory SiteSalt.fromJson(Map<String, dynamic> jsonSerialization) {
    return SiteSalt(
      id: jsonSerialization['id'] as int?,
      day: jsonSerialization['day'] as String,
      salt: jsonSerialization['salt'] as String,
    );
  }

  static final t = SiteSaltTable();

  static const db = SiteSaltRepository._();

  @override
  int? id;

  String day;

  String salt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SiteSalt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SiteSalt copyWith({
    int? id,
    String? day,
    String? salt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SiteSalt',
      if (id != null) 'id': id,
      'day': day,
      'salt': salt,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SiteSaltInclude include() {
    return SiteSaltInclude._();
  }

  static SiteSaltIncludeList includeList({
    _is.WhereExpressionBuilder<SiteSaltTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteSaltTable>? orderBy,
    _is.OrderByListBuilder<SiteSaltTable>? orderByList,
    SiteSaltInclude? include,
  }) {
    return SiteSaltIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SiteSalt.t),
      orderByList: orderByList?.call(SiteSalt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SiteSaltImpl extends SiteSalt {
  _SiteSaltImpl({
    int? id,
    required String day,
    required String salt,
  }) : super._(
         id: id,
         day: day,
         salt: salt,
       );

  /// Returns a shallow copy of this [SiteSalt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SiteSalt copyWith({
    Object? id = _Undefined,
    String? day,
    String? salt,
  }) {
    return SiteSalt(
      id: id is int? ? id : this.id,
      day: day ?? this.day,
      salt: salt ?? this.salt,
    );
  }
}

class SiteSaltUpdateTable extends _is.UpdateTable<SiteSaltTable> {
  SiteSaltUpdateTable(super.table);

  _is.ColumnValue<String, String> day(String value) => _is.ColumnValue(
    table.day,
    value,
  );

  _is.ColumnValue<String, String> salt(String value) => _is.ColumnValue(
    table.salt,
    value,
  );
}

class SiteSaltTable extends _is.Table<int?> {
  SiteSaltTable({super.tableRelation}) : super(tableName: 'site_salt') {
    updateTable = SiteSaltUpdateTable(this);
    day = _is.ColumnString(
      'day',
      this,
    );
    salt = _is.ColumnString(
      'salt',
      this,
    );
  }

  late final SiteSaltUpdateTable updateTable;

  late final _is.ColumnString day;

  late final _is.ColumnString salt;

  @override
  List<_is.Column> get columns => [
    id,
    day,
    salt,
  ];
}

class SiteSaltInclude extends _is.IncludeObject {
  SiteSaltInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SiteSalt.t;
}

class SiteSaltIncludeList extends _is.IncludeList {
  SiteSaltIncludeList._({
    _is.WhereExpressionBuilder<SiteSaltTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SiteSalt.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SiteSalt.t;
}

class SiteSaltRepository {
  const SiteSaltRepository._();

  /// Returns a list of [SiteSalt]s matching the given query parameters.
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
  Future<List<SiteSalt>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteSaltTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteSaltTable>? orderBy,
    _is.OrderByListBuilder<SiteSaltTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SiteSalt>(
      where: where?.call(SiteSalt.t),
      orderBy: orderBy?.call(SiteSalt.t),
      orderByList: orderByList?.call(SiteSalt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [SiteSalt]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `SiteSalt.t`.
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
  _ida.Stream<List<SiteSalt>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteSaltTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteSaltTable>? orderBy,
    _is.OrderByListBuilder<SiteSaltTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<SiteSalt>(
      where: where?.call(SiteSalt.t),
      orderBy: orderBy?.call(SiteSalt.t),
      orderByList: orderByList?.call(SiteSalt.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [SiteSalt] matching the given query parameters.
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
  Future<SiteSalt?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteSaltTable>? where,
    int? offset,
    _is.OrderByBuilder<SiteSaltTable>? orderBy,
    _is.OrderByListBuilder<SiteSaltTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SiteSalt>(
      where: where?.call(SiteSalt.t),
      orderBy: orderBy?.call(SiteSalt.t),
      orderByList: orderByList?.call(SiteSalt.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SiteSalt] by its [id] or null if no such row exists.
  Future<SiteSalt?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SiteSalt>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SiteSalt]s in the list and returns the inserted rows.
  ///
  /// The returned [SiteSalt]s will have their `id` fields set.
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
  Future<List<SiteSalt>> insert(
    _is.DatabaseSession session,
    List<SiteSalt> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SiteSalt>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SiteSalt] and returns the inserted row.
  ///
  /// The returned [SiteSalt] will have its `id` field set.
  Future<SiteSalt> insertRow(
    _is.DatabaseSession session,
    SiteSalt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SiteSalt>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SiteSalt]s in the list and returns the resulting rows.
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
  /// The returned [SiteSalt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteSalt>> upsert(
    _is.DatabaseSession session,
    List<SiteSalt> rows, {
    required _is.ColumnSelections<SiteSaltTable> conflictColumns,
    _is.ColumnSelections<SiteSaltTable>? updateColumns,
    _is.WhereExpressionBuilder<SiteSaltTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SiteSalt>(
      rows,
      conflictColumns: conflictColumns(SiteSalt.t),
      updateColumns: updateColumns?.call(SiteSalt.t),
      updateWhere: updateWhere?.call(SiteSalt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SiteSalt] and returns the resulting row.
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
  /// The returned [SiteSalt] will have its `id` field set.
  Future<SiteSalt?> upsertRow(
    _is.DatabaseSession session,
    SiteSalt row, {
    required _is.ColumnSelections<SiteSaltTable> conflictColumns,
    _is.ColumnSelections<SiteSaltTable>? updateColumns,
    _is.WhereExpressionBuilder<SiteSaltTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SiteSalt>(
      row,
      conflictColumns: conflictColumns(SiteSalt.t),
      updateColumns: updateColumns?.call(SiteSalt.t),
      updateWhere: updateWhere?.call(SiteSalt.t),
      transaction: transaction,
    );
  }

  /// Updates all [SiteSalt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteSalt>> update(
    _is.DatabaseSession session,
    List<SiteSalt> rows, {
    _is.ColumnSelections<SiteSaltTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SiteSalt>(
      rows,
      columns: columns?.call(SiteSalt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SiteSalt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SiteSalt> updateRow(
    _is.DatabaseSession session,
    SiteSalt row, {
    _is.ColumnSelections<SiteSaltTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SiteSalt>(
      row,
      columns: columns?.call(SiteSalt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SiteSalt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SiteSalt?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SiteSaltUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SiteSalt>(
      id,
      columnValues: columnValues(SiteSalt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SiteSalt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteSalt>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SiteSaltUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SiteSaltTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteSaltTable>? orderBy,
    _is.OrderByListBuilder<SiteSaltTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SiteSalt>(
      columnValues: columnValues(SiteSalt.t.updateTable),
      where: where(SiteSalt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SiteSalt.t),
      orderByList: orderByList?.call(SiteSalt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SiteSalt]s in the list and returns the deleted rows.
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
  Future<List<SiteSalt>> delete(
    _is.DatabaseSession session,
    List<SiteSalt> rows, {
    _is.OrderByBuilder<SiteSaltTable>? orderBy,
    _is.OrderByListBuilder<SiteSaltTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SiteSalt>(
      rows,
      orderBy: orderBy?.call(SiteSalt.t),
      orderByList: orderByList?.call(SiteSalt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SiteSalt].
  Future<SiteSalt> deleteRow(
    _is.DatabaseSession session,
    SiteSalt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SiteSalt>(
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
  Future<List<SiteSalt>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SiteSaltTable> where,
    _is.OrderByBuilder<SiteSaltTable>? orderBy,
    _is.OrderByListBuilder<SiteSaltTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SiteSalt>(
      where: where(SiteSalt.t),
      orderBy: orderBy?.call(SiteSalt.t),
      orderByList: orderByList?.call(SiteSalt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteSaltTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SiteSalt>(
      where: where?.call(SiteSalt.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SiteSalt] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SiteSaltTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SiteSalt>(
      where: where(SiteSalt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
