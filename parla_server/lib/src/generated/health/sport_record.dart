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

/// The user's sport answers (goals, areas, pregnancy, injuries) and the
/// log of finished workouts, one row per user. [ciphertext] is AES-256-GCM
/// under the same data key as the health answers, with the user id bound
/// in as associated data. Stored only with a health consent whose text
/// covers it; deleted with the consent.
abstract class SportRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SportRecord._({
    this.id,
    required this.authUserId,
    required this.ciphertext,
    required this.nonce,
    required this.format,
    required this.updatedAt,
  });

  factory SportRecord({
    int? id,
    required _is.UuidValue authUserId,
    required String ciphertext,
    required String nonce,
    required int format,
    required DateTime updatedAt,
  }) = _SportRecordImpl;

  factory SportRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return SportRecord(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      ciphertext: jsonSerialization['ciphertext'] as String,
      nonce: jsonSerialization['nonce'] as String,
      format: jsonSerialization['format'] as int,
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = SportRecordTable();

  static const db = SportRecordRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String ciphertext;

  String nonce;

  int format;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SportRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SportRecord copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? ciphertext,
    String? nonce,
    int? format,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SportRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'format': format,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SportRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'format': format,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static SportRecordInclude include() {
    return SportRecordInclude._();
  }

  static SportRecordIncludeList includeList({
    _is.WhereExpressionBuilder<SportRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SportRecordTable>? orderBy,
    _is.OrderByListBuilder<SportRecordTable>? orderByList,
    SportRecordInclude? include,
  }) {
    return SportRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SportRecord.t),
      orderByList: orderByList?.call(SportRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SportRecordImpl extends SportRecord {
  _SportRecordImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String ciphertext,
    required String nonce,
    required int format,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         ciphertext: ciphertext,
         nonce: nonce,
         format: format,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SportRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SportRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? ciphertext,
    String? nonce,
    int? format,
    DateTime? updatedAt,
  }) {
    return SportRecord(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      ciphertext: ciphertext ?? this.ciphertext,
      nonce: nonce ?? this.nonce,
      format: format ?? this.format,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SportRecordUpdateTable extends _is.UpdateTable<SportRecordTable> {
  SportRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> ciphertext(String value) => _is.ColumnValue(
    table.ciphertext,
    value,
  );

  _is.ColumnValue<String, String> nonce(String value) => _is.ColumnValue(
    table.nonce,
    value,
  );

  _is.ColumnValue<int, int> format(int value) => _is.ColumnValue(
    table.format,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class SportRecordTable extends _is.Table<int?> {
  SportRecordTable({super.tableRelation}) : super(tableName: 'sport_record') {
    updateTable = SportRecordUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    ciphertext = _is.ColumnString(
      'ciphertext',
      this,
    );
    nonce = _is.ColumnString(
      'nonce',
      this,
    );
    format = _is.ColumnInt(
      'format',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final SportRecordUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString ciphertext;

  late final _is.ColumnString nonce;

  late final _is.ColumnInt format;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    ciphertext,
    nonce,
    format,
    updatedAt,
  ];
}

class SportRecordInclude extends _is.IncludeObject {
  SportRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SportRecord.t;
}

class SportRecordIncludeList extends _is.IncludeList {
  SportRecordIncludeList._({
    _is.WhereExpressionBuilder<SportRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SportRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SportRecord.t;
}

class SportRecordRepository {
  const SportRecordRepository._();

  /// Returns a list of [SportRecord]s matching the given query parameters.
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
  Future<List<SportRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SportRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SportRecordTable>? orderBy,
    _is.OrderByListBuilder<SportRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SportRecord>(
      where: where?.call(SportRecord.t),
      orderBy: orderBy?.call(SportRecord.t),
      orderByList: orderByList?.call(SportRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [SportRecord]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `SportRecord.t`.
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
  _ida.Stream<List<SportRecord>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SportRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SportRecordTable>? orderBy,
    _is.OrderByListBuilder<SportRecordTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<SportRecord>(
      where: where?.call(SportRecord.t),
      orderBy: orderBy?.call(SportRecord.t),
      orderByList: orderByList?.call(SportRecord.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [SportRecord] matching the given query parameters.
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
  Future<SportRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SportRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<SportRecordTable>? orderBy,
    _is.OrderByListBuilder<SportRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SportRecord>(
      where: where?.call(SportRecord.t),
      orderBy: orderBy?.call(SportRecord.t),
      orderByList: orderByList?.call(SportRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SportRecord] by its [id] or null if no such row exists.
  Future<SportRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SportRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SportRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [SportRecord]s will have their `id` fields set.
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
  Future<List<SportRecord>> insert(
    _is.DatabaseSession session,
    List<SportRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SportRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SportRecord] and returns the inserted row.
  ///
  /// The returned [SportRecord] will have its `id` field set.
  Future<SportRecord> insertRow(
    _is.DatabaseSession session,
    SportRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SportRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SportRecord]s in the list and returns the resulting rows.
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
  /// The returned [SportRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SportRecord>> upsert(
    _is.DatabaseSession session,
    List<SportRecord> rows, {
    required _is.ColumnSelections<SportRecordTable> conflictColumns,
    _is.ColumnSelections<SportRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<SportRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SportRecord>(
      rows,
      conflictColumns: conflictColumns(SportRecord.t),
      updateColumns: updateColumns?.call(SportRecord.t),
      updateWhere: updateWhere?.call(SportRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SportRecord] and returns the resulting row.
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
  /// The returned [SportRecord] will have its `id` field set.
  Future<SportRecord?> upsertRow(
    _is.DatabaseSession session,
    SportRecord row, {
    required _is.ColumnSelections<SportRecordTable> conflictColumns,
    _is.ColumnSelections<SportRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<SportRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SportRecord>(
      row,
      conflictColumns: conflictColumns(SportRecord.t),
      updateColumns: updateColumns?.call(SportRecord.t),
      updateWhere: updateWhere?.call(SportRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [SportRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SportRecord>> update(
    _is.DatabaseSession session,
    List<SportRecord> rows, {
    _is.ColumnSelections<SportRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SportRecord>(
      rows,
      columns: columns?.call(SportRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SportRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SportRecord> updateRow(
    _is.DatabaseSession session,
    SportRecord row, {
    _is.ColumnSelections<SportRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SportRecord>(
      row,
      columns: columns?.call(SportRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SportRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SportRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SportRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SportRecord>(
      id,
      columnValues: columnValues(SportRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SportRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SportRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SportRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SportRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SportRecordTable>? orderBy,
    _is.OrderByListBuilder<SportRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SportRecord>(
      columnValues: columnValues(SportRecord.t.updateTable),
      where: where(SportRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SportRecord.t),
      orderByList: orderByList?.call(SportRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SportRecord]s in the list and returns the deleted rows.
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
  Future<List<SportRecord>> delete(
    _is.DatabaseSession session,
    List<SportRecord> rows, {
    _is.OrderByBuilder<SportRecordTable>? orderBy,
    _is.OrderByListBuilder<SportRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SportRecord>(
      rows,
      orderBy: orderBy?.call(SportRecord.t),
      orderByList: orderByList?.call(SportRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SportRecord].
  Future<SportRecord> deleteRow(
    _is.DatabaseSession session,
    SportRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SportRecord>(
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
  Future<List<SportRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SportRecordTable> where,
    _is.OrderByBuilder<SportRecordTable>? orderBy,
    _is.OrderByListBuilder<SportRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SportRecord>(
      where: where(SportRecord.t),
      orderBy: orderBy?.call(SportRecord.t),
      orderByList: orderByList?.call(SportRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SportRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SportRecord>(
      where: where?.call(SportRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SportRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SportRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SportRecord>(
      where: where(SportRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
