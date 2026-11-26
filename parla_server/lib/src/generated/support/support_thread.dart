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

/// One user's conversation with the Parla team (one per account). The
/// messages are in [SupportMessage], encrypted. Deleted with the account
/// and 12 months after the last message.
abstract class SupportThread
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SupportThread._({
    this.id,
    required this.authUserId,
    required this.open,
    required this.unreadByStaff,
    required this.unreadByUser,
    required this.createdAt,
    required this.lastMessageAt,
    this.wrappedKey,
  });

  factory SupportThread({
    int? id,
    required _is.UuidValue authUserId,
    required bool open,
    required bool unreadByStaff,
    required bool unreadByUser,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    String? wrappedKey,
  }) = _SupportThreadImpl;

  factory SupportThread.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportThread(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      open: _is.BoolJsonExtension.fromJson(jsonSerialization['open']),
      unreadByStaff: _is.BoolJsonExtension.fromJson(
        jsonSerialization['unreadByStaff'],
      ),
      unreadByUser: _is.BoolJsonExtension.fromJson(
        jsonSerialization['unreadByUser'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastMessageAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastMessageAt'],
      ),
      wrappedKey: jsonSerialization['wrappedKey'] as String?,
    );
  }

  static final t = SupportThreadTable();

  static const db = SupportThreadRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  bool open;

  bool unreadByStaff;

  bool unreadByUser;

  DateTime createdAt;

  DateTime lastMessageAt;

  /// The thread's message key, wrapped by the KMS health key with the
  /// context parla:user = [authUserId] and parla:purpose = support (ENC-3).
  /// Set with the first message sealed under KMS; `null` before.
  String? wrappedKey;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SupportThread]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SupportThread copyWith({
    int? id,
    _is.UuidValue? authUserId,
    bool? open,
    bool? unreadByStaff,
    bool? unreadByUser,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    String? wrappedKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportThread',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'open': open,
      'unreadByStaff': unreadByStaff,
      'unreadByUser': unreadByUser,
      'createdAt': createdAt.toJson(),
      'lastMessageAt': lastMessageAt.toJson(),
      if (wrappedKey != null) 'wrappedKey': wrappedKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SupportThread',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'open': open,
      'unreadByStaff': unreadByStaff,
      'unreadByUser': unreadByUser,
      'createdAt': createdAt.toJson(),
      'lastMessageAt': lastMessageAt.toJson(),
    };
  }

  static SupportThreadInclude include() {
    return SupportThreadInclude._();
  }

  static SupportThreadIncludeList includeList({
    _is.WhereExpressionBuilder<SupportThreadTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SupportThreadTable>? orderBy,
    _is.OrderByListBuilder<SupportThreadTable>? orderByList,
    SupportThreadInclude? include,
  }) {
    return SupportThreadIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SupportThread.t),
      orderByList: orderByList?.call(SupportThread.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupportThreadImpl extends SupportThread {
  _SupportThreadImpl({
    int? id,
    required _is.UuidValue authUserId,
    required bool open,
    required bool unreadByStaff,
    required bool unreadByUser,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    String? wrappedKey,
  }) : super._(
         id: id,
         authUserId: authUserId,
         open: open,
         unreadByStaff: unreadByStaff,
         unreadByUser: unreadByUser,
         createdAt: createdAt,
         lastMessageAt: lastMessageAt,
         wrappedKey: wrappedKey,
       );

  /// Returns a shallow copy of this [SupportThread]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SupportThread copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    bool? open,
    bool? unreadByStaff,
    bool? unreadByUser,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    Object? wrappedKey = _Undefined,
  }) {
    return SupportThread(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      open: open ?? this.open,
      unreadByStaff: unreadByStaff ?? this.unreadByStaff,
      unreadByUser: unreadByUser ?? this.unreadByUser,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      wrappedKey: wrappedKey is String? ? wrappedKey : this.wrappedKey,
    );
  }
}

class SupportThreadUpdateTable extends _is.UpdateTable<SupportThreadTable> {
  SupportThreadUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<bool, bool> open(bool value) => _is.ColumnValue(
    table.open,
    value,
  );

  _is.ColumnValue<bool, bool> unreadByStaff(bool value) => _is.ColumnValue(
    table.unreadByStaff,
    value,
  );

  _is.ColumnValue<bool, bool> unreadByUser(bool value) => _is.ColumnValue(
    table.unreadByUser,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastMessageAt(DateTime value) =>
      _is.ColumnValue(
        table.lastMessageAt,
        value,
      );

  _is.ColumnValue<String, String> wrappedKey(String? value) => _is.ColumnValue(
    table.wrappedKey,
    value,
  );
}

class SupportThreadTable extends _is.Table<int?> {
  SupportThreadTable({super.tableRelation})
    : super(tableName: 'support_thread') {
    updateTable = SupportThreadUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    open = _is.ColumnBool(
      'open',
      this,
    );
    unreadByStaff = _is.ColumnBool(
      'unreadByStaff',
      this,
    );
    unreadByUser = _is.ColumnBool(
      'unreadByUser',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    lastMessageAt = _is.ColumnDateTime(
      'lastMessageAt',
      this,
    );
    wrappedKey = _is.ColumnString(
      'wrappedKey',
      this,
    );
  }

  late final SupportThreadUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnBool open;

  late final _is.ColumnBool unreadByStaff;

  late final _is.ColumnBool unreadByUser;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime lastMessageAt;

  /// The thread's message key, wrapped by the KMS health key with the
  /// context parla:user = [authUserId] and parla:purpose = support (ENC-3).
  /// Set with the first message sealed under KMS; `null` before.
  late final _is.ColumnString wrappedKey;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    open,
    unreadByStaff,
    unreadByUser,
    createdAt,
    lastMessageAt,
    wrappedKey,
  ];
}

class SupportThreadInclude extends _is.IncludeObject {
  SupportThreadInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SupportThread.t;
}

class SupportThreadIncludeList extends _is.IncludeList {
  SupportThreadIncludeList._({
    _is.WhereExpressionBuilder<SupportThreadTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SupportThread.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SupportThread.t;
}

class SupportThreadRepository {
  const SupportThreadRepository._();

  /// Returns a list of [SupportThread]s matching the given query parameters.
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
  Future<List<SupportThread>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SupportThreadTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SupportThreadTable>? orderBy,
    _is.OrderByListBuilder<SupportThreadTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SupportThread>(
      where: where?.call(SupportThread.t),
      orderBy: orderBy?.call(SupportThread.t),
      orderByList: orderByList?.call(SupportThread.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [SupportThread]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `SupportThread.t`.
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
  _ida.Stream<List<SupportThread>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SupportThreadTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SupportThreadTable>? orderBy,
    _is.OrderByListBuilder<SupportThreadTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<SupportThread>(
      where: where?.call(SupportThread.t),
      orderBy: orderBy?.call(SupportThread.t),
      orderByList: orderByList?.call(SupportThread.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [SupportThread] matching the given query parameters.
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
  Future<SupportThread?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SupportThreadTable>? where,
    int? offset,
    _is.OrderByBuilder<SupportThreadTable>? orderBy,
    _is.OrderByListBuilder<SupportThreadTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SupportThread>(
      where: where?.call(SupportThread.t),
      orderBy: orderBy?.call(SupportThread.t),
      orderByList: orderByList?.call(SupportThread.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SupportThread] by its [id] or null if no such row exists.
  Future<SupportThread?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SupportThread>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SupportThread]s in the list and returns the inserted rows.
  ///
  /// The returned [SupportThread]s will have their `id` fields set.
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
  Future<List<SupportThread>> insert(
    _is.DatabaseSession session,
    List<SupportThread> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SupportThread>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SupportThread] and returns the inserted row.
  ///
  /// The returned [SupportThread] will have its `id` field set.
  Future<SupportThread> insertRow(
    _is.DatabaseSession session,
    SupportThread row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SupportThread>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SupportThread]s in the list and returns the resulting rows.
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
  /// The returned [SupportThread]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SupportThread>> upsert(
    _is.DatabaseSession session,
    List<SupportThread> rows, {
    required _is.ColumnSelections<SupportThreadTable> conflictColumns,
    _is.ColumnSelections<SupportThreadTable>? updateColumns,
    _is.WhereExpressionBuilder<SupportThreadTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SupportThread>(
      rows,
      conflictColumns: conflictColumns(SupportThread.t),
      updateColumns: updateColumns?.call(SupportThread.t),
      updateWhere: updateWhere?.call(SupportThread.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SupportThread] and returns the resulting row.
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
  /// The returned [SupportThread] will have its `id` field set.
  Future<SupportThread?> upsertRow(
    _is.DatabaseSession session,
    SupportThread row, {
    required _is.ColumnSelections<SupportThreadTable> conflictColumns,
    _is.ColumnSelections<SupportThreadTable>? updateColumns,
    _is.WhereExpressionBuilder<SupportThreadTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SupportThread>(
      row,
      conflictColumns: conflictColumns(SupportThread.t),
      updateColumns: updateColumns?.call(SupportThread.t),
      updateWhere: updateWhere?.call(SupportThread.t),
      transaction: transaction,
    );
  }

  /// Updates all [SupportThread]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SupportThread>> update(
    _is.DatabaseSession session,
    List<SupportThread> rows, {
    _is.ColumnSelections<SupportThreadTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SupportThread>(
      rows,
      columns: columns?.call(SupportThread.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SupportThread]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SupportThread> updateRow(
    _is.DatabaseSession session,
    SupportThread row, {
    _is.ColumnSelections<SupportThreadTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SupportThread>(
      row,
      columns: columns?.call(SupportThread.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SupportThread] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SupportThread?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SupportThreadUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SupportThread>(
      id,
      columnValues: columnValues(SupportThread.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SupportThread]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SupportThread>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SupportThreadUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SupportThreadTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SupportThreadTable>? orderBy,
    _is.OrderByListBuilder<SupportThreadTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SupportThread>(
      columnValues: columnValues(SupportThread.t.updateTable),
      where: where(SupportThread.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SupportThread.t),
      orderByList: orderByList?.call(SupportThread.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SupportThread]s in the list and returns the deleted rows.
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
  Future<List<SupportThread>> delete(
    _is.DatabaseSession session,
    List<SupportThread> rows, {
    _is.OrderByBuilder<SupportThreadTable>? orderBy,
    _is.OrderByListBuilder<SupportThreadTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SupportThread>(
      rows,
      orderBy: orderBy?.call(SupportThread.t),
      orderByList: orderByList?.call(SupportThread.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SupportThread].
  Future<SupportThread> deleteRow(
    _is.DatabaseSession session,
    SupportThread row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SupportThread>(
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
  Future<List<SupportThread>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SupportThreadTable> where,
    _is.OrderByBuilder<SupportThreadTable>? orderBy,
    _is.OrderByListBuilder<SupportThreadTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SupportThread>(
      where: where(SupportThread.t),
      orderBy: orderBy?.call(SupportThread.t),
      orderByList: orderByList?.call(SupportThread.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SupportThreadTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SupportThread>(
      where: where?.call(SupportThread.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SupportThread] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SupportThreadTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SupportThread>(
      where: where(SupportThread.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
