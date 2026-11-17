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

/// One support message, sealed with a key derived from the server KEK and
/// bound to the thread's owner. [staffId] is set for the team's replies.
abstract class SupportMessage
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SupportMessage._({
    this.id,
    required this.threadId,
    required this.fromStaff,
    this.staffId,
    required this.ciphertext,
    required this.nonce,
    required this.createdAt,
  });

  factory SupportMessage({
    int? id,
    required int threadId,
    required bool fromStaff,
    _is.UuidValue? staffId,
    required String ciphertext,
    required String nonce,
    required DateTime createdAt,
  }) = _SupportMessageImpl;

  factory SupportMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportMessage(
      id: jsonSerialization['id'] as int?,
      threadId: jsonSerialization['threadId'] as int,
      fromStaff: _is.BoolJsonExtension.fromJson(jsonSerialization['fromStaff']),
      staffId: jsonSerialization['staffId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['staffId']),
      ciphertext: jsonSerialization['ciphertext'] as String,
      nonce: jsonSerialization['nonce'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = SupportMessageTable();

  static const db = SupportMessageRepository._();

  @override
  int? id;

  int threadId;

  bool fromStaff;

  _is.UuidValue? staffId;

  String ciphertext;

  String nonce;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SupportMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SupportMessage copyWith({
    int? id,
    int? threadId,
    bool? fromStaff,
    _is.UuidValue? staffId = const _is.$UndefinedUuidValue(),
    String? ciphertext,
    String? nonce,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportMessage',
      if (id != null) 'id': id,
      'threadId': threadId,
      'fromStaff': fromStaff,
      if (staffId != null) 'staffId': staffId?.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SupportMessage',
      if (id != null) 'id': id,
      'threadId': threadId,
      'fromStaff': fromStaff,
      if (staffId != null) 'staffId': staffId?.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'createdAt': createdAt.toJson(),
    };
  }

  static SupportMessageInclude include() {
    return SupportMessageInclude._();
  }

  static SupportMessageIncludeList includeList({
    _is.WhereExpressionBuilder<SupportMessageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SupportMessageTable>? orderBy,
    _is.OrderByListBuilder<SupportMessageTable>? orderByList,
    SupportMessageInclude? include,
  }) {
    return SupportMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SupportMessage.t),
      orderByList: orderByList?.call(SupportMessage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupportMessageImpl extends SupportMessage {
  _SupportMessageImpl({
    int? id,
    required int threadId,
    required bool fromStaff,
    _is.UuidValue? staffId,
    required String ciphertext,
    required String nonce,
    required DateTime createdAt,
  }) : super._(
         id: id,
         threadId: threadId,
         fromStaff: fromStaff,
         staffId: staffId,
         ciphertext: ciphertext,
         nonce: nonce,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SupportMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SupportMessage copyWith({
    Object? id = _Undefined,
    int? threadId,
    bool? fromStaff,
    _is.UuidValue? staffId = const _is.$UndefinedUuidValue(),
    String? ciphertext,
    String? nonce,
    DateTime? createdAt,
  }) {
    return SupportMessage(
      id: id is int? ? id : this.id,
      threadId: threadId ?? this.threadId,
      fromStaff: fromStaff ?? this.fromStaff,
      staffId: staffId is _is.UndefinedSentinel ? this.staffId : staffId,
      ciphertext: ciphertext ?? this.ciphertext,
      nonce: nonce ?? this.nonce,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SupportMessageUpdateTable extends _is.UpdateTable<SupportMessageTable> {
  SupportMessageUpdateTable(super.table);

  _is.ColumnValue<int, int> threadId(int value) => _is.ColumnValue(
    table.threadId,
    value,
  );

  _is.ColumnValue<bool, bool> fromStaff(bool value) => _is.ColumnValue(
    table.fromStaff,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> staffId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.staffId,
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

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SupportMessageTable extends _is.Table<int?> {
  SupportMessageTable({super.tableRelation})
    : super(tableName: 'support_message') {
    updateTable = SupportMessageUpdateTable(this);
    threadId = _is.ColumnInt(
      'threadId',
      this,
    );
    fromStaff = _is.ColumnBool(
      'fromStaff',
      this,
    );
    staffId = _is.ColumnUuid(
      'staffId',
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
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final SupportMessageUpdateTable updateTable;

  late final _is.ColumnInt threadId;

  late final _is.ColumnBool fromStaff;

  late final _is.ColumnUuid staffId;

  late final _is.ColumnString ciphertext;

  late final _is.ColumnString nonce;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    threadId,
    fromStaff,
    staffId,
    ciphertext,
    nonce,
    createdAt,
  ];
}

class SupportMessageInclude extends _is.IncludeObject {
  SupportMessageInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SupportMessage.t;
}

class SupportMessageIncludeList extends _is.IncludeList {
  SupportMessageIncludeList._({
    _is.WhereExpressionBuilder<SupportMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SupportMessage.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SupportMessage.t;
}

class SupportMessageRepository {
  const SupportMessageRepository._();

  /// Returns a list of [SupportMessage]s matching the given query parameters.
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
  Future<List<SupportMessage>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SupportMessageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SupportMessageTable>? orderBy,
    _is.OrderByListBuilder<SupportMessageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SupportMessage>(
      where: where?.call(SupportMessage.t),
      orderBy: orderBy?.call(SupportMessage.t),
      orderByList: orderByList?.call(SupportMessage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [SupportMessage]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `SupportMessage.t`.
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
  _ida.Stream<List<SupportMessage>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SupportMessageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SupportMessageTable>? orderBy,
    _is.OrderByListBuilder<SupportMessageTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<SupportMessage>(
      where: where?.call(SupportMessage.t),
      orderBy: orderBy?.call(SupportMessage.t),
      orderByList: orderByList?.call(SupportMessage.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [SupportMessage] matching the given query parameters.
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
  Future<SupportMessage?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SupportMessageTable>? where,
    int? offset,
    _is.OrderByBuilder<SupportMessageTable>? orderBy,
    _is.OrderByListBuilder<SupportMessageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SupportMessage>(
      where: where?.call(SupportMessage.t),
      orderBy: orderBy?.call(SupportMessage.t),
      orderByList: orderByList?.call(SupportMessage.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SupportMessage] by its [id] or null if no such row exists.
  Future<SupportMessage?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SupportMessage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SupportMessage]s in the list and returns the inserted rows.
  ///
  /// The returned [SupportMessage]s will have their `id` fields set.
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
  Future<List<SupportMessage>> insert(
    _is.DatabaseSession session,
    List<SupportMessage> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SupportMessage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SupportMessage] and returns the inserted row.
  ///
  /// The returned [SupportMessage] will have its `id` field set.
  Future<SupportMessage> insertRow(
    _is.DatabaseSession session,
    SupportMessage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SupportMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SupportMessage]s in the list and returns the resulting rows.
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
  /// The returned [SupportMessage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SupportMessage>> upsert(
    _is.DatabaseSession session,
    List<SupportMessage> rows, {
    required _is.ColumnSelections<SupportMessageTable> conflictColumns,
    _is.ColumnSelections<SupportMessageTable>? updateColumns,
    _is.WhereExpressionBuilder<SupportMessageTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SupportMessage>(
      rows,
      conflictColumns: conflictColumns(SupportMessage.t),
      updateColumns: updateColumns?.call(SupportMessage.t),
      updateWhere: updateWhere?.call(SupportMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SupportMessage] and returns the resulting row.
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
  /// The returned [SupportMessage] will have its `id` field set.
  Future<SupportMessage?> upsertRow(
    _is.DatabaseSession session,
    SupportMessage row, {
    required _is.ColumnSelections<SupportMessageTable> conflictColumns,
    _is.ColumnSelections<SupportMessageTable>? updateColumns,
    _is.WhereExpressionBuilder<SupportMessageTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SupportMessage>(
      row,
      conflictColumns: conflictColumns(SupportMessage.t),
      updateColumns: updateColumns?.call(SupportMessage.t),
      updateWhere: updateWhere?.call(SupportMessage.t),
      transaction: transaction,
    );
  }

  /// Updates all [SupportMessage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SupportMessage>> update(
    _is.DatabaseSession session,
    List<SupportMessage> rows, {
    _is.ColumnSelections<SupportMessageTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SupportMessage>(
      rows,
      columns: columns?.call(SupportMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SupportMessage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SupportMessage> updateRow(
    _is.DatabaseSession session,
    SupportMessage row, {
    _is.ColumnSelections<SupportMessageTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SupportMessage>(
      row,
      columns: columns?.call(SupportMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SupportMessage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SupportMessage?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SupportMessageUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SupportMessage>(
      id,
      columnValues: columnValues(SupportMessage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SupportMessage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SupportMessage>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SupportMessageUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SupportMessageTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SupportMessageTable>? orderBy,
    _is.OrderByListBuilder<SupportMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SupportMessage>(
      columnValues: columnValues(SupportMessage.t.updateTable),
      where: where(SupportMessage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SupportMessage.t),
      orderByList: orderByList?.call(SupportMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SupportMessage]s in the list and returns the deleted rows.
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
  Future<List<SupportMessage>> delete(
    _is.DatabaseSession session,
    List<SupportMessage> rows, {
    _is.OrderByBuilder<SupportMessageTable>? orderBy,
    _is.OrderByListBuilder<SupportMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SupportMessage>(
      rows,
      orderBy: orderBy?.call(SupportMessage.t),
      orderByList: orderByList?.call(SupportMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SupportMessage].
  Future<SupportMessage> deleteRow(
    _is.DatabaseSession session,
    SupportMessage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SupportMessage>(
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
  Future<List<SupportMessage>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SupportMessageTable> where,
    _is.OrderByBuilder<SupportMessageTable>? orderBy,
    _is.OrderByListBuilder<SupportMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SupportMessage>(
      where: where(SupportMessage.t),
      orderBy: orderBy?.call(SupportMessage.t),
      orderByList: orderByList?.call(SupportMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SupportMessageTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SupportMessage>(
      where: where?.call(SupportMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SupportMessage] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SupportMessageTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SupportMessage>(
      where: where(SupportMessage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
