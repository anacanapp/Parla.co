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
import '../staff/staff_role.dart' as _iopxo5n5;

/// An invitation to the admin panel. Only a hash of the one-time code is
/// kept; the code itself goes by email. Single use, expires after 72 hours.
abstract class StaffInvite
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StaffInvite._({
    this.id,
    required this.email,
    required this.role,
    required this.codeHash,
    required this.invitedBy,
    required this.expiresAt,
    this.usedAt,
    required this.createdAt,
  });

  factory StaffInvite({
    int? id,
    required String email,
    required _iopxo5n5.StaffRole role,
    required String codeHash,
    required _is.UuidValue invitedBy,
    required DateTime expiresAt,
    DateTime? usedAt,
    required DateTime createdAt,
  }) = _StaffInviteImpl;

  factory StaffInvite.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffInvite(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      role: _iopxo5n5.StaffRole.fromJson((jsonSerialization['role'] as String)),
      codeHash: jsonSerialization['codeHash'] as String,
      invitedBy: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['invitedBy'],
      ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      usedAt: jsonSerialization['usedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['usedAt']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = StaffInviteTable();

  static const db = StaffInviteRepository._();

  @override
  int? id;

  String email;

  _iopxo5n5.StaffRole role;

  String codeHash;

  _is.UuidValue invitedBy;

  DateTime expiresAt;

  DateTime? usedAt;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StaffInvite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StaffInvite copyWith({
    int? id,
    String? email,
    _iopxo5n5.StaffRole? role,
    String? codeHash,
    _is.UuidValue? invitedBy,
    DateTime? expiresAt,
    DateTime? usedAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffInvite',
      if (id != null) 'id': id,
      'email': email,
      'role': role.toJson(),
      'codeHash': codeHash,
      'invitedBy': invitedBy.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffInvite',
      if (id != null) 'id': id,
      'email': email,
      'role': role.toJson(),
      'codeHash': codeHash,
      'invitedBy': invitedBy.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static StaffInviteInclude include() {
    return StaffInviteInclude._();
  }

  static StaffInviteIncludeList includeList({
    _is.WhereExpressionBuilder<StaffInviteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StaffInviteTable>? orderBy,
    _is.OrderByListBuilder<StaffInviteTable>? orderByList,
    StaffInviteInclude? include,
  }) {
    return StaffInviteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StaffInvite.t),
      orderByList: orderByList?.call(StaffInvite.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StaffInviteImpl extends StaffInvite {
  _StaffInviteImpl({
    int? id,
    required String email,
    required _iopxo5n5.StaffRole role,
    required String codeHash,
    required _is.UuidValue invitedBy,
    required DateTime expiresAt,
    DateTime? usedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         role: role,
         codeHash: codeHash,
         invitedBy: invitedBy,
         expiresAt: expiresAt,
         usedAt: usedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [StaffInvite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StaffInvite copyWith({
    Object? id = _Undefined,
    String? email,
    _iopxo5n5.StaffRole? role,
    String? codeHash,
    _is.UuidValue? invitedBy,
    DateTime? expiresAt,
    DateTime? usedAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
  }) {
    return StaffInvite(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      codeHash: codeHash ?? this.codeHash,
      invitedBy: invitedBy ?? this.invitedBy,
      expiresAt: expiresAt ?? this.expiresAt,
      usedAt: usedAt is _is.UndefinedSentinel ? this.usedAt : usedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class StaffInviteUpdateTable extends _is.UpdateTable<StaffInviteTable> {
  StaffInviteUpdateTable(super.table);

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<_iopxo5n5.StaffRole, _iopxo5n5.StaffRole> role(
    _iopxo5n5.StaffRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<String, String> codeHash(String value) => _is.ColumnValue(
    table.codeHash,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> invitedBy(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.invitedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> usedAt(DateTime? value) =>
      _is.ColumnValue(
        table.usedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class StaffInviteTable extends _is.Table<int?> {
  StaffInviteTable({super.tableRelation}) : super(tableName: 'staff_invite') {
    updateTable = StaffInviteUpdateTable(this);
    email = _is.ColumnString(
      'email',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
    );
    codeHash = _is.ColumnString(
      'codeHash',
      this,
    );
    invitedBy = _is.ColumnUuid(
      'invitedBy',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    usedAt = _is.ColumnDateTime(
      'usedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final StaffInviteUpdateTable updateTable;

  late final _is.ColumnString email;

  late final _is.ColumnEnum<_iopxo5n5.StaffRole> role;

  late final _is.ColumnString codeHash;

  late final _is.ColumnUuid invitedBy;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime usedAt;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    email,
    role,
    codeHash,
    invitedBy,
    expiresAt,
    usedAt,
    createdAt,
  ];
}

class StaffInviteInclude extends _is.IncludeObject {
  StaffInviteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StaffInvite.t;
}

class StaffInviteIncludeList extends _is.IncludeList {
  StaffInviteIncludeList._({
    _is.WhereExpressionBuilder<StaffInviteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StaffInvite.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StaffInvite.t;
}

class StaffInviteRepository {
  const StaffInviteRepository._();

  /// Returns a list of [StaffInvite]s matching the given query parameters.
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
  Future<List<StaffInvite>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StaffInviteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StaffInviteTable>? orderBy,
    _is.OrderByListBuilder<StaffInviteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StaffInvite>(
      where: where?.call(StaffInvite.t),
      orderBy: orderBy?.call(StaffInvite.t),
      orderByList: orderByList?.call(StaffInvite.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [StaffInvite]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `StaffInvite.t`.
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
  _ida.Stream<List<StaffInvite>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StaffInviteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StaffInviteTable>? orderBy,
    _is.OrderByListBuilder<StaffInviteTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<StaffInvite>(
      where: where?.call(StaffInvite.t),
      orderBy: orderBy?.call(StaffInvite.t),
      orderByList: orderByList?.call(StaffInvite.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [StaffInvite] matching the given query parameters.
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
  Future<StaffInvite?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StaffInviteTable>? where,
    int? offset,
    _is.OrderByBuilder<StaffInviteTable>? orderBy,
    _is.OrderByListBuilder<StaffInviteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StaffInvite>(
      where: where?.call(StaffInvite.t),
      orderBy: orderBy?.call(StaffInvite.t),
      orderByList: orderByList?.call(StaffInvite.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StaffInvite] by its [id] or null if no such row exists.
  Future<StaffInvite?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StaffInvite>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StaffInvite]s in the list and returns the inserted rows.
  ///
  /// The returned [StaffInvite]s will have their `id` fields set.
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
  Future<List<StaffInvite>> insert(
    _is.DatabaseSession session,
    List<StaffInvite> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StaffInvite>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StaffInvite] and returns the inserted row.
  ///
  /// The returned [StaffInvite] will have its `id` field set.
  Future<StaffInvite> insertRow(
    _is.DatabaseSession session,
    StaffInvite row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StaffInvite>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StaffInvite]s in the list and returns the resulting rows.
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
  /// The returned [StaffInvite]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StaffInvite>> upsert(
    _is.DatabaseSession session,
    List<StaffInvite> rows, {
    required _is.ColumnSelections<StaffInviteTable> conflictColumns,
    _is.ColumnSelections<StaffInviteTable>? updateColumns,
    _is.WhereExpressionBuilder<StaffInviteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StaffInvite>(
      rows,
      conflictColumns: conflictColumns(StaffInvite.t),
      updateColumns: updateColumns?.call(StaffInvite.t),
      updateWhere: updateWhere?.call(StaffInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StaffInvite] and returns the resulting row.
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
  /// The returned [StaffInvite] will have its `id` field set.
  Future<StaffInvite?> upsertRow(
    _is.DatabaseSession session,
    StaffInvite row, {
    required _is.ColumnSelections<StaffInviteTable> conflictColumns,
    _is.ColumnSelections<StaffInviteTable>? updateColumns,
    _is.WhereExpressionBuilder<StaffInviteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StaffInvite>(
      row,
      conflictColumns: conflictColumns(StaffInvite.t),
      updateColumns: updateColumns?.call(StaffInvite.t),
      updateWhere: updateWhere?.call(StaffInvite.t),
      transaction: transaction,
    );
  }

  /// Updates all [StaffInvite]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StaffInvite>> update(
    _is.DatabaseSession session,
    List<StaffInvite> rows, {
    _is.ColumnSelections<StaffInviteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StaffInvite>(
      rows,
      columns: columns?.call(StaffInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StaffInvite]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StaffInvite> updateRow(
    _is.DatabaseSession session,
    StaffInvite row, {
    _is.ColumnSelections<StaffInviteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StaffInvite>(
      row,
      columns: columns?.call(StaffInvite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StaffInvite] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StaffInvite?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StaffInviteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StaffInvite>(
      id,
      columnValues: columnValues(StaffInvite.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StaffInvite]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StaffInvite>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StaffInviteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StaffInviteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StaffInviteTable>? orderBy,
    _is.OrderByListBuilder<StaffInviteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StaffInvite>(
      columnValues: columnValues(StaffInvite.t.updateTable),
      where: where(StaffInvite.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StaffInvite.t),
      orderByList: orderByList?.call(StaffInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StaffInvite]s in the list and returns the deleted rows.
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
  Future<List<StaffInvite>> delete(
    _is.DatabaseSession session,
    List<StaffInvite> rows, {
    _is.OrderByBuilder<StaffInviteTable>? orderBy,
    _is.OrderByListBuilder<StaffInviteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StaffInvite>(
      rows,
      orderBy: orderBy?.call(StaffInvite.t),
      orderByList: orderByList?.call(StaffInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StaffInvite].
  Future<StaffInvite> deleteRow(
    _is.DatabaseSession session,
    StaffInvite row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StaffInvite>(
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
  Future<List<StaffInvite>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StaffInviteTable> where,
    _is.OrderByBuilder<StaffInviteTable>? orderBy,
    _is.OrderByListBuilder<StaffInviteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StaffInvite>(
      where: where(StaffInvite.t),
      orderBy: orderBy?.call(StaffInvite.t),
      orderByList: orderByList?.call(StaffInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StaffInviteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StaffInvite>(
      where: where?.call(StaffInvite.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StaffInvite] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StaffInviteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StaffInvite>(
      where: where(StaffInvite.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
