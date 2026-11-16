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

/// The user's daily plate entries (food groups per day, no amounts), one
/// row per user. [ciphertext] is AES-256-GCM
/// under the same data key as the health answers, with the user id bound
/// in as associated data. Stored only with a health consent whose text
/// covers it; deleted with the consent.
abstract class NutritionRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  NutritionRecord._({
    this.id,
    required this.authUserId,
    required this.ciphertext,
    required this.nonce,
    required this.format,
    required this.updatedAt,
  });

  factory NutritionRecord({
    int? id,
    required _is.UuidValue authUserId,
    required String ciphertext,
    required String nonce,
    required int format,
    required DateTime updatedAt,
  }) = _NutritionRecordImpl;

  factory NutritionRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return NutritionRecord(
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

  static final t = NutritionRecordTable();

  static const db = NutritionRecordRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String ciphertext;

  String nonce;

  int format;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [NutritionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NutritionRecord copyWith({
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
      '__className__': 'NutritionRecord',
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
      '__className__': 'NutritionRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'format': format,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static NutritionRecordInclude include() {
    return NutritionRecordInclude._();
  }

  static NutritionRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NutritionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NutritionRecordTable>? orderBy,
    _is.OrderByListBuilder<NutritionRecordTable>? orderByList,
    NutritionRecordInclude? include,
  }) {
    return NutritionRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NutritionRecord.t),
      orderByList: orderByList?.call(NutritionRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NutritionRecordImpl extends NutritionRecord {
  _NutritionRecordImpl({
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

  /// Returns a shallow copy of this [NutritionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NutritionRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? ciphertext,
    String? nonce,
    int? format,
    DateTime? updatedAt,
  }) {
    return NutritionRecord(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      ciphertext: ciphertext ?? this.ciphertext,
      nonce: nonce ?? this.nonce,
      format: format ?? this.format,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NutritionRecordUpdateTable extends _is.UpdateTable<NutritionRecordTable> {
  NutritionRecordUpdateTable(super.table);

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

class NutritionRecordTable extends _is.Table<int?> {
  NutritionRecordTable({super.tableRelation})
    : super(tableName: 'nutrition_record') {
    updateTable = NutritionRecordUpdateTable(this);
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

  late final NutritionRecordUpdateTable updateTable;

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

class NutritionRecordInclude extends _is.IncludeObject {
  NutritionRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => NutritionRecord.t;
}

class NutritionRecordIncludeList extends _is.IncludeList {
  NutritionRecordIncludeList._({
    _is.WhereExpressionBuilder<NutritionRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NutritionRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => NutritionRecord.t;
}

class NutritionRecordRepository {
  const NutritionRecordRepository._();

  /// Returns a list of [NutritionRecord]s matching the given query parameters.
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
  Future<List<NutritionRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NutritionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NutritionRecordTable>? orderBy,
    _is.OrderByListBuilder<NutritionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NutritionRecord>(
      where: where?.call(NutritionRecord.t),
      orderBy: orderBy?.call(NutritionRecord.t),
      orderByList: orderByList?.call(NutritionRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [NutritionRecord]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `NutritionRecord.t`.
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
  _ida.Stream<List<NutritionRecord>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NutritionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NutritionRecordTable>? orderBy,
    _is.OrderByListBuilder<NutritionRecordTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<NutritionRecord>(
      where: where?.call(NutritionRecord.t),
      orderBy: orderBy?.call(NutritionRecord.t),
      orderByList: orderByList?.call(NutritionRecord.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [NutritionRecord] matching the given query parameters.
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
  Future<NutritionRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NutritionRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NutritionRecordTable>? orderBy,
    _is.OrderByListBuilder<NutritionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NutritionRecord>(
      where: where?.call(NutritionRecord.t),
      orderBy: orderBy?.call(NutritionRecord.t),
      orderByList: orderByList?.call(NutritionRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NutritionRecord] by its [id] or null if no such row exists.
  Future<NutritionRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NutritionRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NutritionRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NutritionRecord]s will have their `id` fields set.
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
  Future<List<NutritionRecord>> insert(
    _is.DatabaseSession session,
    List<NutritionRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NutritionRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NutritionRecord] and returns the inserted row.
  ///
  /// The returned [NutritionRecord] will have its `id` field set.
  Future<NutritionRecord> insertRow(
    _is.DatabaseSession session,
    NutritionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NutritionRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NutritionRecord]s in the list and returns the resulting rows.
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
  /// The returned [NutritionRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NutritionRecord>> upsert(
    _is.DatabaseSession session,
    List<NutritionRecord> rows, {
    required _is.ColumnSelections<NutritionRecordTable> conflictColumns,
    _is.ColumnSelections<NutritionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NutritionRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NutritionRecord>(
      rows,
      conflictColumns: conflictColumns(NutritionRecord.t),
      updateColumns: updateColumns?.call(NutritionRecord.t),
      updateWhere: updateWhere?.call(NutritionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NutritionRecord] and returns the resulting row.
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
  /// The returned [NutritionRecord] will have its `id` field set.
  Future<NutritionRecord?> upsertRow(
    _is.DatabaseSession session,
    NutritionRecord row, {
    required _is.ColumnSelections<NutritionRecordTable> conflictColumns,
    _is.ColumnSelections<NutritionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NutritionRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NutritionRecord>(
      row,
      conflictColumns: conflictColumns(NutritionRecord.t),
      updateColumns: updateColumns?.call(NutritionRecord.t),
      updateWhere: updateWhere?.call(NutritionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NutritionRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NutritionRecord>> update(
    _is.DatabaseSession session,
    List<NutritionRecord> rows, {
    _is.ColumnSelections<NutritionRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NutritionRecord>(
      rows,
      columns: columns?.call(NutritionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NutritionRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NutritionRecord> updateRow(
    _is.DatabaseSession session,
    NutritionRecord row, {
    _is.ColumnSelections<NutritionRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NutritionRecord>(
      row,
      columns: columns?.call(NutritionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NutritionRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NutritionRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<NutritionRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NutritionRecord>(
      id,
      columnValues: columnValues(NutritionRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NutritionRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NutritionRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NutritionRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NutritionRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NutritionRecordTable>? orderBy,
    _is.OrderByListBuilder<NutritionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NutritionRecord>(
      columnValues: columnValues(NutritionRecord.t.updateTable),
      where: where(NutritionRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NutritionRecord.t),
      orderByList: orderByList?.call(NutritionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NutritionRecord]s in the list and returns the deleted rows.
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
  Future<List<NutritionRecord>> delete(
    _is.DatabaseSession session,
    List<NutritionRecord> rows, {
    _is.OrderByBuilder<NutritionRecordTable>? orderBy,
    _is.OrderByListBuilder<NutritionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NutritionRecord>(
      rows,
      orderBy: orderBy?.call(NutritionRecord.t),
      orderByList: orderByList?.call(NutritionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NutritionRecord].
  Future<NutritionRecord> deleteRow(
    _is.DatabaseSession session,
    NutritionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NutritionRecord>(
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
  Future<List<NutritionRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NutritionRecordTable> where,
    _is.OrderByBuilder<NutritionRecordTable>? orderBy,
    _is.OrderByListBuilder<NutritionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NutritionRecord>(
      where: where(NutritionRecord.t),
      orderBy: orderBy?.call(NutritionRecord.t),
      orderByList: orderByList?.call(NutritionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NutritionRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NutritionRecord>(
      where: where?.call(NutritionRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NutritionRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NutritionRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NutritionRecord>(
      where: where(NutritionRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
