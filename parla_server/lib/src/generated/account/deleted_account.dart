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

/// Marks a deleted account by its pseudonym only (never the real id), so
/// the retention job knows when the account's consent records may go
/// (3 years after deletion, proposal pending legal review).
abstract class DeletedAccount
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeletedAccount._({
    this.id,
    required this.pseudonym,
    required this.deletedAt,
  });

  factory DeletedAccount({
    int? id,
    required _is.UuidValue pseudonym,
    required DateTime deletedAt,
  }) = _DeletedAccountImpl;

  factory DeletedAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeletedAccount(
      id: jsonSerialization['id'] as int?,
      pseudonym: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['pseudonym'],
      ),
      deletedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['deletedAt'],
      ),
    );
  }

  static final t = DeletedAccountTable();

  static const db = DeletedAccountRepository._();

  @override
  int? id;

  _is.UuidValue pseudonym;

  DateTime deletedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeletedAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeletedAccount copyWith({
    int? id,
    _is.UuidValue? pseudonym,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeletedAccount',
      if (id != null) 'id': id,
      'pseudonym': pseudonym.toJson(),
      'deletedAt': deletedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeletedAccount',
      if (id != null) 'id': id,
      'pseudonym': pseudonym.toJson(),
      'deletedAt': deletedAt.toJson(),
    };
  }

  static DeletedAccountInclude include() {
    return DeletedAccountInclude._();
  }

  static DeletedAccountIncludeList includeList({
    _is.WhereExpressionBuilder<DeletedAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeletedAccountTable>? orderBy,
    _is.OrderByListBuilder<DeletedAccountTable>? orderByList,
    DeletedAccountInclude? include,
  }) {
    return DeletedAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeletedAccount.t),
      orderByList: orderByList?.call(DeletedAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeletedAccountImpl extends DeletedAccount {
  _DeletedAccountImpl({
    int? id,
    required _is.UuidValue pseudonym,
    required DateTime deletedAt,
  }) : super._(
         id: id,
         pseudonym: pseudonym,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [DeletedAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeletedAccount copyWith({
    Object? id = _Undefined,
    _is.UuidValue? pseudonym,
    DateTime? deletedAt,
  }) {
    return DeletedAccount(
      id: id is int? ? id : this.id,
      pseudonym: pseudonym ?? this.pseudonym,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class DeletedAccountUpdateTable extends _is.UpdateTable<DeletedAccountTable> {
  DeletedAccountUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> pseudonym(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.pseudonym,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> deletedAt(DateTime value) =>
      _is.ColumnValue(
        table.deletedAt,
        value,
      );
}

class DeletedAccountTable extends _is.Table<int?> {
  DeletedAccountTable({super.tableRelation})
    : super(tableName: 'deleted_account') {
    updateTable = DeletedAccountUpdateTable(this);
    pseudonym = _is.ColumnUuid(
      'pseudonym',
      this,
    );
    deletedAt = _is.ColumnDateTime(
      'deletedAt',
      this,
    );
  }

  late final DeletedAccountUpdateTable updateTable;

  late final _is.ColumnUuid pseudonym;

  late final _is.ColumnDateTime deletedAt;

  @override
  List<_is.Column> get columns => [
    id,
    pseudonym,
    deletedAt,
  ];
}

class DeletedAccountInclude extends _is.IncludeObject {
  DeletedAccountInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DeletedAccount.t;
}

class DeletedAccountIncludeList extends _is.IncludeList {
  DeletedAccountIncludeList._({
    _is.WhereExpressionBuilder<DeletedAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeletedAccount.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeletedAccount.t;
}

class DeletedAccountRepository {
  const DeletedAccountRepository._();

  /// Returns a list of [DeletedAccount]s matching the given query parameters.
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
  Future<List<DeletedAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeletedAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeletedAccountTable>? orderBy,
    _is.OrderByListBuilder<DeletedAccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeletedAccount>(
      where: where?.call(DeletedAccount.t),
      orderBy: orderBy?.call(DeletedAccount.t),
      orderByList: orderByList?.call(DeletedAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeletedAccount]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `DeletedAccount.t`.
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
  _ida.Stream<List<DeletedAccount>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeletedAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeletedAccountTable>? orderBy,
    _is.OrderByListBuilder<DeletedAccountTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeletedAccount>(
      where: where?.call(DeletedAccount.t),
      orderBy: orderBy?.call(DeletedAccount.t),
      orderByList: orderByList?.call(DeletedAccount.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeletedAccount] matching the given query parameters.
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
  Future<DeletedAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeletedAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<DeletedAccountTable>? orderBy,
    _is.OrderByListBuilder<DeletedAccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeletedAccount>(
      where: where?.call(DeletedAccount.t),
      orderBy: orderBy?.call(DeletedAccount.t),
      orderByList: orderByList?.call(DeletedAccount.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeletedAccount] by its [id] or null if no such row exists.
  Future<DeletedAccount?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeletedAccount>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeletedAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [DeletedAccount]s will have their `id` fields set.
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
  Future<List<DeletedAccount>> insert(
    _is.DatabaseSession session,
    List<DeletedAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeletedAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeletedAccount] and returns the inserted row.
  ///
  /// The returned [DeletedAccount] will have its `id` field set.
  Future<DeletedAccount> insertRow(
    _is.DatabaseSession session,
    DeletedAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeletedAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeletedAccount]s in the list and returns the resulting rows.
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
  /// The returned [DeletedAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeletedAccount>> upsert(
    _is.DatabaseSession session,
    List<DeletedAccount> rows, {
    required _is.ColumnSelections<DeletedAccountTable> conflictColumns,
    _is.ColumnSelections<DeletedAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<DeletedAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeletedAccount>(
      rows,
      conflictColumns: conflictColumns(DeletedAccount.t),
      updateColumns: updateColumns?.call(DeletedAccount.t),
      updateWhere: updateWhere?.call(DeletedAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeletedAccount] and returns the resulting row.
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
  /// The returned [DeletedAccount] will have its `id` field set.
  Future<DeletedAccount?> upsertRow(
    _is.DatabaseSession session,
    DeletedAccount row, {
    required _is.ColumnSelections<DeletedAccountTable> conflictColumns,
    _is.ColumnSelections<DeletedAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<DeletedAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeletedAccount>(
      row,
      conflictColumns: conflictColumns(DeletedAccount.t),
      updateColumns: updateColumns?.call(DeletedAccount.t),
      updateWhere: updateWhere?.call(DeletedAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeletedAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeletedAccount>> update(
    _is.DatabaseSession session,
    List<DeletedAccount> rows, {
    _is.ColumnSelections<DeletedAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeletedAccount>(
      rows,
      columns: columns?.call(DeletedAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeletedAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeletedAccount> updateRow(
    _is.DatabaseSession session,
    DeletedAccount row, {
    _is.ColumnSelections<DeletedAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeletedAccount>(
      row,
      columns: columns?.call(DeletedAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeletedAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeletedAccount?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeletedAccountUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeletedAccount>(
      id,
      columnValues: columnValues(DeletedAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeletedAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeletedAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeletedAccountUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DeletedAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeletedAccountTable>? orderBy,
    _is.OrderByListBuilder<DeletedAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeletedAccount>(
      columnValues: columnValues(DeletedAccount.t.updateTable),
      where: where(DeletedAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeletedAccount.t),
      orderByList: orderByList?.call(DeletedAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeletedAccount]s in the list and returns the deleted rows.
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
  Future<List<DeletedAccount>> delete(
    _is.DatabaseSession session,
    List<DeletedAccount> rows, {
    _is.OrderByBuilder<DeletedAccountTable>? orderBy,
    _is.OrderByListBuilder<DeletedAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeletedAccount>(
      rows,
      orderBy: orderBy?.call(DeletedAccount.t),
      orderByList: orderByList?.call(DeletedAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeletedAccount].
  Future<DeletedAccount> deleteRow(
    _is.DatabaseSession session,
    DeletedAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeletedAccount>(
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
  Future<List<DeletedAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeletedAccountTable> where,
    _is.OrderByBuilder<DeletedAccountTable>? orderBy,
    _is.OrderByListBuilder<DeletedAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeletedAccount>(
      where: where(DeletedAccount.t),
      orderBy: orderBy?.call(DeletedAccount.t),
      orderByList: orderByList?.call(DeletedAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeletedAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeletedAccount>(
      where: where?.call(DeletedAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeletedAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeletedAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeletedAccount>(
      where: where(DeletedAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
