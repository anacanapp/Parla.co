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

/// The user's own routines and their daily ticks (data map: own
/// routines), one row per user. [ciphertext] is AES-256-GCM under the same
/// data key as the health answers, with the user id bound in as associated
/// data, so deleting the key in `health_key` makes it unreadable too.
/// Stored only with the health consent, because the names and steps are
/// free text that may hold health details; deleted with the consent.
abstract class CustomRoutineRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CustomRoutineRecord._({
    this.id,
    required this.authUserId,
    required this.ciphertext,
    required this.nonce,
    required this.format,
    required this.updatedAt,
  });

  factory CustomRoutineRecord({
    int? id,
    required _is.UuidValue authUserId,
    required String ciphertext,
    required String nonce,
    required int format,
    required DateTime updatedAt,
  }) = _CustomRoutineRecordImpl;

  factory CustomRoutineRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomRoutineRecord(
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

  static final t = CustomRoutineRecordTable();

  static const db = CustomRoutineRecordRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String ciphertext;

  String nonce;

  int format;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CustomRoutineRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomRoutineRecord copyWith({
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
      '__className__': 'CustomRoutineRecord',
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
      '__className__': 'CustomRoutineRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'format': format,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CustomRoutineRecordInclude include() {
    return CustomRoutineRecordInclude._();
  }

  static CustomRoutineRecordIncludeList includeList({
    _is.WhereExpressionBuilder<CustomRoutineRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomRoutineRecordTable>? orderBy,
    _is.OrderByListBuilder<CustomRoutineRecordTable>? orderByList,
    CustomRoutineRecordInclude? include,
  }) {
    return CustomRoutineRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomRoutineRecord.t),
      orderByList: orderByList?.call(CustomRoutineRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomRoutineRecordImpl extends CustomRoutineRecord {
  _CustomRoutineRecordImpl({
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

  /// Returns a shallow copy of this [CustomRoutineRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomRoutineRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? ciphertext,
    String? nonce,
    int? format,
    DateTime? updatedAt,
  }) {
    return CustomRoutineRecord(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      ciphertext: ciphertext ?? this.ciphertext,
      nonce: nonce ?? this.nonce,
      format: format ?? this.format,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CustomRoutineRecordUpdateTable
    extends _is.UpdateTable<CustomRoutineRecordTable> {
  CustomRoutineRecordUpdateTable(super.table);

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

class CustomRoutineRecordTable extends _is.Table<int?> {
  CustomRoutineRecordTable({super.tableRelation})
    : super(tableName: 'custom_routine_record') {
    updateTable = CustomRoutineRecordUpdateTable(this);
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

  late final CustomRoutineRecordUpdateTable updateTable;

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

class CustomRoutineRecordInclude extends _is.IncludeObject {
  CustomRoutineRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CustomRoutineRecord.t;
}

class CustomRoutineRecordIncludeList extends _is.IncludeList {
  CustomRoutineRecordIncludeList._({
    _is.WhereExpressionBuilder<CustomRoutineRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CustomRoutineRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CustomRoutineRecord.t;
}

class CustomRoutineRecordRepository {
  const CustomRoutineRecordRepository._();

  /// Returns a list of [CustomRoutineRecord]s matching the given query parameters.
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
  Future<List<CustomRoutineRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomRoutineRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomRoutineRecordTable>? orderBy,
    _is.OrderByListBuilder<CustomRoutineRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CustomRoutineRecord>(
      where: where?.call(CustomRoutineRecord.t),
      orderBy: orderBy?.call(CustomRoutineRecord.t),
      orderByList: orderByList?.call(CustomRoutineRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [CustomRoutineRecord]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `CustomRoutineRecord.t`.
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
  _ida.Stream<List<CustomRoutineRecord>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomRoutineRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomRoutineRecordTable>? orderBy,
    _is.OrderByListBuilder<CustomRoutineRecordTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<CustomRoutineRecord>(
      where: where?.call(CustomRoutineRecord.t),
      orderBy: orderBy?.call(CustomRoutineRecord.t),
      orderByList: orderByList?.call(CustomRoutineRecord.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [CustomRoutineRecord] matching the given query parameters.
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
  Future<CustomRoutineRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomRoutineRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<CustomRoutineRecordTable>? orderBy,
    _is.OrderByListBuilder<CustomRoutineRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CustomRoutineRecord>(
      where: where?.call(CustomRoutineRecord.t),
      orderBy: orderBy?.call(CustomRoutineRecord.t),
      orderByList: orderByList?.call(CustomRoutineRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CustomRoutineRecord] by its [id] or null if no such row exists.
  Future<CustomRoutineRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CustomRoutineRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CustomRoutineRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [CustomRoutineRecord]s will have their `id` fields set.
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
  Future<List<CustomRoutineRecord>> insert(
    _is.DatabaseSession session,
    List<CustomRoutineRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CustomRoutineRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CustomRoutineRecord] and returns the inserted row.
  ///
  /// The returned [CustomRoutineRecord] will have its `id` field set.
  Future<CustomRoutineRecord> insertRow(
    _is.DatabaseSession session,
    CustomRoutineRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CustomRoutineRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CustomRoutineRecord]s in the list and returns the resulting rows.
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
  /// The returned [CustomRoutineRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomRoutineRecord>> upsert(
    _is.DatabaseSession session,
    List<CustomRoutineRecord> rows, {
    required _is.ColumnSelections<CustomRoutineRecordTable> conflictColumns,
    _is.ColumnSelections<CustomRoutineRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomRoutineRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CustomRoutineRecord>(
      rows,
      conflictColumns: conflictColumns(CustomRoutineRecord.t),
      updateColumns: updateColumns?.call(CustomRoutineRecord.t),
      updateWhere: updateWhere?.call(CustomRoutineRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CustomRoutineRecord] and returns the resulting row.
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
  /// The returned [CustomRoutineRecord] will have its `id` field set.
  Future<CustomRoutineRecord?> upsertRow(
    _is.DatabaseSession session,
    CustomRoutineRecord row, {
    required _is.ColumnSelections<CustomRoutineRecordTable> conflictColumns,
    _is.ColumnSelections<CustomRoutineRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomRoutineRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CustomRoutineRecord>(
      row,
      conflictColumns: conflictColumns(CustomRoutineRecord.t),
      updateColumns: updateColumns?.call(CustomRoutineRecord.t),
      updateWhere: updateWhere?.call(CustomRoutineRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [CustomRoutineRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomRoutineRecord>> update(
    _is.DatabaseSession session,
    List<CustomRoutineRecord> rows, {
    _is.ColumnSelections<CustomRoutineRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CustomRoutineRecord>(
      rows,
      columns: columns?.call(CustomRoutineRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CustomRoutineRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CustomRoutineRecord> updateRow(
    _is.DatabaseSession session,
    CustomRoutineRecord row, {
    _is.ColumnSelections<CustomRoutineRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CustomRoutineRecord>(
      row,
      columns: columns?.call(CustomRoutineRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomRoutineRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CustomRoutineRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CustomRoutineRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CustomRoutineRecord>(
      id,
      columnValues: columnValues(CustomRoutineRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CustomRoutineRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomRoutineRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CustomRoutineRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CustomRoutineRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomRoutineRecordTable>? orderBy,
    _is.OrderByListBuilder<CustomRoutineRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CustomRoutineRecord>(
      columnValues: columnValues(CustomRoutineRecord.t.updateTable),
      where: where(CustomRoutineRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomRoutineRecord.t),
      orderByList: orderByList?.call(CustomRoutineRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CustomRoutineRecord]s in the list and returns the deleted rows.
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
  Future<List<CustomRoutineRecord>> delete(
    _is.DatabaseSession session,
    List<CustomRoutineRecord> rows, {
    _is.OrderByBuilder<CustomRoutineRecordTable>? orderBy,
    _is.OrderByListBuilder<CustomRoutineRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CustomRoutineRecord>(
      rows,
      orderBy: orderBy?.call(CustomRoutineRecord.t),
      orderByList: orderByList?.call(CustomRoutineRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CustomRoutineRecord].
  Future<CustomRoutineRecord> deleteRow(
    _is.DatabaseSession session,
    CustomRoutineRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CustomRoutineRecord>(
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
  Future<List<CustomRoutineRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomRoutineRecordTable> where,
    _is.OrderByBuilder<CustomRoutineRecordTable>? orderBy,
    _is.OrderByListBuilder<CustomRoutineRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CustomRoutineRecord>(
      where: where(CustomRoutineRecord.t),
      orderBy: orderBy?.call(CustomRoutineRecord.t),
      orderByList: orderByList?.call(CustomRoutineRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomRoutineRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CustomRoutineRecord>(
      where: where?.call(CustomRoutineRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CustomRoutineRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomRoutineRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CustomRoutineRecord>(
      where: where(CustomRoutineRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
