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

/// A push campaign being sent in the background, in batches of users,
/// so a large audience does not run inside the publish request and a
/// restart resumes where it stopped. Holds ids and counts only.
abstract class PushJob
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PushJob._({
    this.id,
    required this.contentId,
    required this.status,
    required this.sent,
    this.cursor,
    this.leaseUntil,
    required this.createdAt,
    this.finishedAt,
  });

  factory PushJob({
    int? id,
    required int contentId,
    required String status,
    required int sent,
    _is.UuidValue? cursor,
    DateTime? leaseUntil,
    required DateTime createdAt,
    DateTime? finishedAt,
  }) = _PushJobImpl;

  factory PushJob.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushJob(
      id: jsonSerialization['id'] as int?,
      contentId: jsonSerialization['contentId'] as int,
      status: jsonSerialization['status'] as String,
      sent: jsonSerialization['sent'] as int,
      cursor: jsonSerialization['cursor'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['cursor']),
      leaseUntil: jsonSerialization['leaseUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['leaseUntil']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
    );
  }

  static final t = PushJobTable();

  static const db = PushJobRepository._();

  @override
  int? id;

  /// The published `push` content item.
  int contentId;

  /// queued, sending, done or stopped (the campaign was unpublished).
  String status;

  /// Phones the campaign reached so far.
  int sent;

  /// The last account handled, in id order; the next batch starts after it.
  _is.UuidValue? cursor;

  /// While set and in the future, one server instance is sending.
  DateTime? leaseUntil;

  DateTime createdAt;

  DateTime? finishedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PushJob]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PushJob copyWith({
    int? id,
    int? contentId,
    String? status,
    int? sent,
    _is.UuidValue? cursor = const _is.$UndefinedUuidValue(),
    DateTime? leaseUntil = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? finishedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushJob',
      if (id != null) 'id': id,
      'contentId': contentId,
      'status': status,
      'sent': sent,
      if (cursor != null) 'cursor': cursor?.toJson(),
      if (leaseUntil != null) 'leaseUntil': leaseUntil?.toJson(),
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushJob',
      if (id != null) 'id': id,
      'contentId': contentId,
      'status': status,
      'sent': sent,
      if (cursor != null) 'cursor': cursor?.toJson(),
      if (leaseUntil != null) 'leaseUntil': leaseUntil?.toJson(),
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  static PushJobInclude include() {
    return PushJobInclude._();
  }

  static PushJobIncludeList includeList({
    _is.WhereExpressionBuilder<PushJobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushJobTable>? orderBy,
    _is.OrderByListBuilder<PushJobTable>? orderByList,
    PushJobInclude? include,
  }) {
    return PushJobIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushJob.t),
      orderByList: orderByList?.call(PushJob.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushJobImpl extends PushJob {
  _PushJobImpl({
    int? id,
    required int contentId,
    required String status,
    required int sent,
    _is.UuidValue? cursor,
    DateTime? leaseUntil,
    required DateTime createdAt,
    DateTime? finishedAt,
  }) : super._(
         id: id,
         contentId: contentId,
         status: status,
         sent: sent,
         cursor: cursor,
         leaseUntil: leaseUntil,
         createdAt: createdAt,
         finishedAt: finishedAt,
       );

  /// Returns a shallow copy of this [PushJob]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PushJob copyWith({
    Object? id = _Undefined,
    int? contentId,
    String? status,
    int? sent,
    _is.UuidValue? cursor = const _is.$UndefinedUuidValue(),
    DateTime? leaseUntil = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? finishedAt = const _is.$UndefinedDateTime(),
  }) {
    return PushJob(
      id: id is int? ? id : this.id,
      contentId: contentId ?? this.contentId,
      status: status ?? this.status,
      sent: sent ?? this.sent,
      cursor: cursor is _is.UndefinedSentinel ? this.cursor : cursor,
      leaseUntil: leaseUntil is _is.UndefinedSentinel
          ? this.leaseUntil
          : leaseUntil,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt is _is.UndefinedSentinel
          ? this.finishedAt
          : finishedAt,
    );
  }
}

class PushJobUpdateTable extends _is.UpdateTable<PushJobTable> {
  PushJobUpdateTable(super.table);

  _is.ColumnValue<int, int> contentId(int value) => _is.ColumnValue(
    table.contentId,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> sent(int value) => _is.ColumnValue(
    table.sent,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> cursor(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.cursor,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> leaseUntil(DateTime? value) =>
      _is.ColumnValue(
        table.leaseUntil,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.finishedAt,
        value,
      );
}

class PushJobTable extends _is.Table<int?> {
  PushJobTable({super.tableRelation}) : super(tableName: 'push_job') {
    updateTable = PushJobUpdateTable(this);
    contentId = _is.ColumnInt(
      'contentId',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    sent = _is.ColumnInt(
      'sent',
      this,
    );
    cursor = _is.ColumnUuid(
      'cursor',
      this,
    );
    leaseUntil = _is.ColumnDateTime(
      'leaseUntil',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    finishedAt = _is.ColumnDateTime(
      'finishedAt',
      this,
    );
  }

  late final PushJobUpdateTable updateTable;

  /// The published `push` content item.
  late final _is.ColumnInt contentId;

  /// queued, sending, done or stopped (the campaign was unpublished).
  late final _is.ColumnString status;

  /// Phones the campaign reached so far.
  late final _is.ColumnInt sent;

  /// The last account handled, in id order; the next batch starts after it.
  late final _is.ColumnUuid cursor;

  /// While set and in the future, one server instance is sending.
  late final _is.ColumnDateTime leaseUntil;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime finishedAt;

  @override
  List<_is.Column> get columns => [
    id,
    contentId,
    status,
    sent,
    cursor,
    leaseUntil,
    createdAt,
    finishedAt,
  ];
}

class PushJobInclude extends _is.IncludeObject {
  PushJobInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PushJob.t;
}

class PushJobIncludeList extends _is.IncludeList {
  PushJobIncludeList._({
    _is.WhereExpressionBuilder<PushJobTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PushJob.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PushJob.t;
}

class PushJobRepository {
  const PushJobRepository._();

  /// Returns a list of [PushJob]s matching the given query parameters.
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
  Future<List<PushJob>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushJobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushJobTable>? orderBy,
    _is.OrderByListBuilder<PushJobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PushJob>(
      where: where?.call(PushJob.t),
      orderBy: orderBy?.call(PushJob.t),
      orderByList: orderByList?.call(PushJob.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [PushJob]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `PushJob.t`.
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
  _ida.Stream<List<PushJob>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushJobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushJobTable>? orderBy,
    _is.OrderByListBuilder<PushJobTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<PushJob>(
      where: where?.call(PushJob.t),
      orderBy: orderBy?.call(PushJob.t),
      orderByList: orderByList?.call(PushJob.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [PushJob] matching the given query parameters.
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
  Future<PushJob?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushJobTable>? where,
    int? offset,
    _is.OrderByBuilder<PushJobTable>? orderBy,
    _is.OrderByListBuilder<PushJobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PushJob>(
      where: where?.call(PushJob.t),
      orderBy: orderBy?.call(PushJob.t),
      orderByList: orderByList?.call(PushJob.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PushJob] by its [id] or null if no such row exists.
  Future<PushJob?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PushJob>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PushJob]s in the list and returns the inserted rows.
  ///
  /// The returned [PushJob]s will have their `id` fields set.
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
  Future<List<PushJob>> insert(
    _is.DatabaseSession session,
    List<PushJob> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PushJob>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PushJob] and returns the inserted row.
  ///
  /// The returned [PushJob] will have its `id` field set.
  Future<PushJob> insertRow(
    _is.DatabaseSession session,
    PushJob row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PushJob>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PushJob]s in the list and returns the resulting rows.
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
  /// The returned [PushJob]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushJob>> upsert(
    _is.DatabaseSession session,
    List<PushJob> rows, {
    required _is.ColumnSelections<PushJobTable> conflictColumns,
    _is.ColumnSelections<PushJobTable>? updateColumns,
    _is.WhereExpressionBuilder<PushJobTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PushJob>(
      rows,
      conflictColumns: conflictColumns(PushJob.t),
      updateColumns: updateColumns?.call(PushJob.t),
      updateWhere: updateWhere?.call(PushJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PushJob] and returns the resulting row.
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
  /// The returned [PushJob] will have its `id` field set.
  Future<PushJob?> upsertRow(
    _is.DatabaseSession session,
    PushJob row, {
    required _is.ColumnSelections<PushJobTable> conflictColumns,
    _is.ColumnSelections<PushJobTable>? updateColumns,
    _is.WhereExpressionBuilder<PushJobTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PushJob>(
      row,
      conflictColumns: conflictColumns(PushJob.t),
      updateColumns: updateColumns?.call(PushJob.t),
      updateWhere: updateWhere?.call(PushJob.t),
      transaction: transaction,
    );
  }

  /// Updates all [PushJob]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushJob>> update(
    _is.DatabaseSession session,
    List<PushJob> rows, {
    _is.ColumnSelections<PushJobTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PushJob>(
      rows,
      columns: columns?.call(PushJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PushJob]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PushJob> updateRow(
    _is.DatabaseSession session,
    PushJob row, {
    _is.ColumnSelections<PushJobTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PushJob>(
      row,
      columns: columns?.call(PushJob.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PushJob] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PushJob?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PushJobUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PushJob>(
      id,
      columnValues: columnValues(PushJob.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PushJob]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushJob>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PushJobUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PushJobTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushJobTable>? orderBy,
    _is.OrderByListBuilder<PushJobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PushJob>(
      columnValues: columnValues(PushJob.t.updateTable),
      where: where(PushJob.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushJob.t),
      orderByList: orderByList?.call(PushJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PushJob]s in the list and returns the deleted rows.
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
  Future<List<PushJob>> delete(
    _is.DatabaseSession session,
    List<PushJob> rows, {
    _is.OrderByBuilder<PushJobTable>? orderBy,
    _is.OrderByListBuilder<PushJobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PushJob>(
      rows,
      orderBy: orderBy?.call(PushJob.t),
      orderByList: orderByList?.call(PushJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PushJob].
  Future<PushJob> deleteRow(
    _is.DatabaseSession session,
    PushJob row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PushJob>(
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
  Future<List<PushJob>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushJobTable> where,
    _is.OrderByBuilder<PushJobTable>? orderBy,
    _is.OrderByListBuilder<PushJobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PushJob>(
      where: where(PushJob.t),
      orderBy: orderBy?.call(PushJob.t),
      orderByList: orderByList?.call(PushJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushJobTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PushJob>(
      where: where?.call(PushJob.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PushJob] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushJobTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PushJob>(
      where: where(PushJob.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
