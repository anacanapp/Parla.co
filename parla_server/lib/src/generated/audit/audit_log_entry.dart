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

/// Audit log (data map row 17, checklist AUD-1..AUD-4). Holds ids only,
/// never health content, emails or tokens. Append-only, kept 1 year.
abstract class AuditLogEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AuditLogEntry._({
    this.id,
    this.actorId,
    required this.actorRole,
    required this.action,
    required this.objectType,
    this.objectId,
    required this.createdAt,
  });

  factory AuditLogEntry({
    int? id,
    _is.UuidValue? actorId,
    required String actorRole,
    required String action,
    required String objectType,
    String? objectId,
    required DateTime createdAt,
  }) = _AuditLogEntryImpl;

  factory AuditLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLogEntry(
      id: jsonSerialization['id'] as int?,
      actorId: jsonSerialization['actorId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['actorId']),
      actorRole: jsonSerialization['actorRole'] as String,
      action: jsonSerialization['action'] as String,
      objectType: jsonSerialization['objectType'] as String,
      objectId: jsonSerialization['objectId'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AuditLogEntryTable();

  static const db = AuditLogEntryRepository._();

  @override
  int? id;

  /// Who acted: the user themself or an internal account.
  _is.UuidValue? actorId;

  String actorRole;

  /// For example: consent.granted, consent.withdrawn, profile.created.
  String action;

  String objectType;

  String? objectId;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuditLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuditLogEntry copyWith({
    int? id,
    _is.UuidValue? actorId = const _is.$UndefinedUuidValue(),
    String? actorRole,
    String? action,
    String? objectType,
    String? objectId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLogEntry',
      if (id != null) 'id': id,
      if (actorId != null) 'actorId': actorId?.toJson(),
      'actorRole': actorRole,
      'action': action,
      'objectType': objectType,
      if (objectId != null) 'objectId': objectId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditLogEntry',
      if (id != null) 'id': id,
      if (actorId != null) 'actorId': actorId?.toJson(),
      'actorRole': actorRole,
      'action': action,
      'objectType': objectType,
      if (objectId != null) 'objectId': objectId,
      'createdAt': createdAt.toJson(),
    };
  }

  static AuditLogEntryInclude include() {
    return AuditLogEntryInclude._();
  }

  static AuditLogEntryIncludeList includeList({
    _is.WhereExpressionBuilder<AuditLogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditLogEntryTable>? orderBy,
    _is.OrderByListBuilder<AuditLogEntryTable>? orderByList,
    AuditLogEntryInclude? include,
  }) {
    return AuditLogEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditLogEntry.t),
      orderByList: orderByList?.call(AuditLogEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditLogEntryImpl extends AuditLogEntry {
  _AuditLogEntryImpl({
    int? id,
    _is.UuidValue? actorId,
    required String actorRole,
    required String action,
    required String objectType,
    String? objectId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actorId: actorId,
         actorRole: actorRole,
         action: action,
         objectType: objectType,
         objectId: objectId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuditLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuditLogEntry copyWith({
    Object? id = _Undefined,
    _is.UuidValue? actorId = const _is.$UndefinedUuidValue(),
    String? actorRole,
    String? action,
    String? objectType,
    Object? objectId = _Undefined,
    DateTime? createdAt,
  }) {
    return AuditLogEntry(
      id: id is int? ? id : this.id,
      actorId: actorId is _is.UndefinedSentinel ? this.actorId : actorId,
      actorRole: actorRole ?? this.actorRole,
      action: action ?? this.action,
      objectType: objectType ?? this.objectType,
      objectId: objectId is String? ? objectId : this.objectId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuditLogEntryUpdateTable extends _is.UpdateTable<AuditLogEntryTable> {
  AuditLogEntryUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> actorId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.actorId,
        value,
      );

  _is.ColumnValue<String, String> actorRole(String value) => _is.ColumnValue(
    table.actorRole,
    value,
  );

  _is.ColumnValue<String, String> action(String value) => _is.ColumnValue(
    table.action,
    value,
  );

  _is.ColumnValue<String, String> objectType(String value) => _is.ColumnValue(
    table.objectType,
    value,
  );

  _is.ColumnValue<String, String> objectId(String? value) => _is.ColumnValue(
    table.objectId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AuditLogEntryTable extends _is.Table<int?> {
  AuditLogEntryTable({super.tableRelation}) : super(tableName: 'audit_log') {
    updateTable = AuditLogEntryUpdateTable(this);
    actorId = _is.ColumnUuid(
      'actorId',
      this,
    );
    actorRole = _is.ColumnString(
      'actorRole',
      this,
    );
    action = _is.ColumnString(
      'action',
      this,
    );
    objectType = _is.ColumnString(
      'objectType',
      this,
    );
    objectId = _is.ColumnString(
      'objectId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AuditLogEntryUpdateTable updateTable;

  /// Who acted: the user themself or an internal account.
  late final _is.ColumnUuid actorId;

  late final _is.ColumnString actorRole;

  /// For example: consent.granted, consent.withdrawn, profile.created.
  late final _is.ColumnString action;

  late final _is.ColumnString objectType;

  late final _is.ColumnString objectId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    actorId,
    actorRole,
    action,
    objectType,
    objectId,
    createdAt,
  ];
}

class AuditLogEntryInclude extends _is.IncludeObject {
  AuditLogEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AuditLogEntry.t;
}

class AuditLogEntryIncludeList extends _is.IncludeList {
  AuditLogEntryIncludeList._({
    _is.WhereExpressionBuilder<AuditLogEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuditLogEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AuditLogEntry.t;
}

class AuditLogEntryRepository {
  const AuditLogEntryRepository._();

  /// Returns a list of [AuditLogEntry]s matching the given query parameters.
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
  Future<List<AuditLogEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditLogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditLogEntryTable>? orderBy,
    _is.OrderByListBuilder<AuditLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AuditLogEntry>(
      where: where?.call(AuditLogEntry.t),
      orderBy: orderBy?.call(AuditLogEntry.t),
      orderByList: orderByList?.call(AuditLogEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [AuditLogEntry]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `AuditLogEntry.t`.
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
  _ida.Stream<List<AuditLogEntry>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditLogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditLogEntryTable>? orderBy,
    _is.OrderByListBuilder<AuditLogEntryTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<AuditLogEntry>(
      where: where?.call(AuditLogEntry.t),
      orderBy: orderBy?.call(AuditLogEntry.t),
      orderByList: orderByList?.call(AuditLogEntry.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [AuditLogEntry] matching the given query parameters.
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
  Future<AuditLogEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditLogEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<AuditLogEntryTable>? orderBy,
    _is.OrderByListBuilder<AuditLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AuditLogEntry>(
      where: where?.call(AuditLogEntry.t),
      orderBy: orderBy?.call(AuditLogEntry.t),
      orderByList: orderByList?.call(AuditLogEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AuditLogEntry] by its [id] or null if no such row exists.
  Future<AuditLogEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AuditLogEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AuditLogEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [AuditLogEntry]s will have their `id` fields set.
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
  Future<List<AuditLogEntry>> insert(
    _is.DatabaseSession session,
    List<AuditLogEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AuditLogEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AuditLogEntry] and returns the inserted row.
  ///
  /// The returned [AuditLogEntry] will have its `id` field set.
  Future<AuditLogEntry> insertRow(
    _is.DatabaseSession session,
    AuditLogEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuditLogEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AuditLogEntry]s in the list and returns the resulting rows.
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
  /// The returned [AuditLogEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuditLogEntry>> upsert(
    _is.DatabaseSession session,
    List<AuditLogEntry> rows, {
    required _is.ColumnSelections<AuditLogEntryTable> conflictColumns,
    _is.ColumnSelections<AuditLogEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<AuditLogEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AuditLogEntry>(
      rows,
      conflictColumns: conflictColumns(AuditLogEntry.t),
      updateColumns: updateColumns?.call(AuditLogEntry.t),
      updateWhere: updateWhere?.call(AuditLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AuditLogEntry] and returns the resulting row.
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
  /// The returned [AuditLogEntry] will have its `id` field set.
  Future<AuditLogEntry?> upsertRow(
    _is.DatabaseSession session,
    AuditLogEntry row, {
    required _is.ColumnSelections<AuditLogEntryTable> conflictColumns,
    _is.ColumnSelections<AuditLogEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<AuditLogEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AuditLogEntry>(
      row,
      conflictColumns: conflictColumns(AuditLogEntry.t),
      updateColumns: updateColumns?.call(AuditLogEntry.t),
      updateWhere: updateWhere?.call(AuditLogEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [AuditLogEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuditLogEntry>> update(
    _is.DatabaseSession session,
    List<AuditLogEntry> rows, {
    _is.ColumnSelections<AuditLogEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AuditLogEntry>(
      rows,
      columns: columns?.call(AuditLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AuditLogEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuditLogEntry> updateRow(
    _is.DatabaseSession session,
    AuditLogEntry row, {
    _is.ColumnSelections<AuditLogEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuditLogEntry>(
      row,
      columns: columns?.call(AuditLogEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuditLogEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuditLogEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AuditLogEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AuditLogEntry>(
      id,
      columnValues: columnValues(AuditLogEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuditLogEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuditLogEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AuditLogEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AuditLogEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditLogEntryTable>? orderBy,
    _is.OrderByListBuilder<AuditLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AuditLogEntry>(
      columnValues: columnValues(AuditLogEntry.t.updateTable),
      where: where(AuditLogEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditLogEntry.t),
      orderByList: orderByList?.call(AuditLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AuditLogEntry]s in the list and returns the deleted rows.
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
  Future<List<AuditLogEntry>> delete(
    _is.DatabaseSession session,
    List<AuditLogEntry> rows, {
    _is.OrderByBuilder<AuditLogEntryTable>? orderBy,
    _is.OrderByListBuilder<AuditLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AuditLogEntry>(
      rows,
      orderBy: orderBy?.call(AuditLogEntry.t),
      orderByList: orderByList?.call(AuditLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AuditLogEntry].
  Future<AuditLogEntry> deleteRow(
    _is.DatabaseSession session,
    AuditLogEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuditLogEntry>(
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
  Future<List<AuditLogEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuditLogEntryTable> where,
    _is.OrderByBuilder<AuditLogEntryTable>? orderBy,
    _is.OrderByListBuilder<AuditLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AuditLogEntry>(
      where: where(AuditLogEntry.t),
      orderBy: orderBy?.call(AuditLogEntry.t),
      orderByList: orderByList?.call(AuditLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditLogEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AuditLogEntry>(
      where: where?.call(AuditLogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AuditLogEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuditLogEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AuditLogEntry>(
      where: where(AuditLogEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
