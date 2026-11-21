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

/// A brand that pays for campaigns (admin panel, admins only). Company
/// facts only: no contact person's name or phone (decision of
/// 2026-11-21); those stay in the signed contract.
abstract class Advertiser
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Advertiser._({
    this.id,
    required this.company,
    this.email,
    this.contractNumber,
    this.contractStart,
    this.contractEnd,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Advertiser({
    int? id,
    required String company,
    String? email,
    String? contractNumber,
    String? contractStart,
    String? contractEnd,
    String? note,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AdvertiserImpl;

  factory Advertiser.fromJson(Map<String, dynamic> jsonSerialization) {
    return Advertiser(
      id: jsonSerialization['id'] as int?,
      company: jsonSerialization['company'] as String,
      email: jsonSerialization['email'] as String?,
      contractNumber: jsonSerialization['contractNumber'] as String?,
      contractStart: jsonSerialization['contractStart'] as String?,
      contractEnd: jsonSerialization['contractEnd'] as String?,
      note: jsonSerialization['note'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = AdvertiserTable();

  static const db = AdvertiserRepository._();

  @override
  int? id;

  String company;

  /// The company's general address (e.g. info@brand.az), optional.
  String? email;

  String? contractNumber;

  /// Contract dates as YYYY-MM-DD.
  String? contractStart;

  String? contractEnd;

  String? note;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Advertiser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Advertiser copyWith({
    int? id,
    String? company,
    String? email,
    String? contractNumber,
    String? contractStart,
    String? contractEnd,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Advertiser',
      if (id != null) 'id': id,
      'company': company,
      if (email != null) 'email': email,
      if (contractNumber != null) 'contractNumber': contractNumber,
      if (contractStart != null) 'contractStart': contractStart,
      if (contractEnd != null) 'contractEnd': contractEnd,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Advertiser',
      if (id != null) 'id': id,
      'company': company,
      if (email != null) 'email': email,
      if (contractNumber != null) 'contractNumber': contractNumber,
      if (contractStart != null) 'contractStart': contractStart,
      if (contractEnd != null) 'contractEnd': contractEnd,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AdvertiserInclude include() {
    return AdvertiserInclude._();
  }

  static AdvertiserIncludeList includeList({
    _is.WhereExpressionBuilder<AdvertiserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdvertiserTable>? orderBy,
    _is.OrderByListBuilder<AdvertiserTable>? orderByList,
    AdvertiserInclude? include,
  }) {
    return AdvertiserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Advertiser.t),
      orderByList: orderByList?.call(Advertiser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdvertiserImpl extends Advertiser {
  _AdvertiserImpl({
    int? id,
    required String company,
    String? email,
    String? contractNumber,
    String? contractStart,
    String? contractEnd,
    String? note,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         company: company,
         email: email,
         contractNumber: contractNumber,
         contractStart: contractStart,
         contractEnd: contractEnd,
         note: note,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Advertiser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Advertiser copyWith({
    Object? id = _Undefined,
    String? company,
    Object? email = _Undefined,
    Object? contractNumber = _Undefined,
    Object? contractStart = _Undefined,
    Object? contractEnd = _Undefined,
    Object? note = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Advertiser(
      id: id is int? ? id : this.id,
      company: company ?? this.company,
      email: email is String? ? email : this.email,
      contractNumber: contractNumber is String?
          ? contractNumber
          : this.contractNumber,
      contractStart: contractStart is String?
          ? contractStart
          : this.contractStart,
      contractEnd: contractEnd is String? ? contractEnd : this.contractEnd,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AdvertiserUpdateTable extends _is.UpdateTable<AdvertiserTable> {
  AdvertiserUpdateTable(super.table);

  _is.ColumnValue<String, String> company(String value) => _is.ColumnValue(
    table.company,
    value,
  );

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> contractNumber(String? value) =>
      _is.ColumnValue(
        table.contractNumber,
        value,
      );

  _is.ColumnValue<String, String> contractStart(String? value) =>
      _is.ColumnValue(
        table.contractStart,
        value,
      );

  _is.ColumnValue<String, String> contractEnd(String? value) => _is.ColumnValue(
    table.contractEnd,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class AdvertiserTable extends _is.Table<int?> {
  AdvertiserTable({super.tableRelation}) : super(tableName: 'advertiser') {
    updateTable = AdvertiserUpdateTable(this);
    company = _is.ColumnString(
      'company',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    contractNumber = _is.ColumnString(
      'contractNumber',
      this,
    );
    contractStart = _is.ColumnString(
      'contractStart',
      this,
    );
    contractEnd = _is.ColumnString(
      'contractEnd',
      this,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final AdvertiserUpdateTable updateTable;

  late final _is.ColumnString company;

  /// The company's general address (e.g. info@brand.az), optional.
  late final _is.ColumnString email;

  late final _is.ColumnString contractNumber;

  /// Contract dates as YYYY-MM-DD.
  late final _is.ColumnString contractStart;

  late final _is.ColumnString contractEnd;

  late final _is.ColumnString note;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    company,
    email,
    contractNumber,
    contractStart,
    contractEnd,
    note,
    createdAt,
    updatedAt,
  ];
}

class AdvertiserInclude extends _is.IncludeObject {
  AdvertiserInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Advertiser.t;
}

class AdvertiserIncludeList extends _is.IncludeList {
  AdvertiserIncludeList._({
    _is.WhereExpressionBuilder<AdvertiserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Advertiser.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Advertiser.t;
}

class AdvertiserRepository {
  const AdvertiserRepository._();

  /// Returns a list of [Advertiser]s matching the given query parameters.
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
  Future<List<Advertiser>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdvertiserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdvertiserTable>? orderBy,
    _is.OrderByListBuilder<AdvertiserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Advertiser>(
      where: where?.call(Advertiser.t),
      orderBy: orderBy?.call(Advertiser.t),
      orderByList: orderByList?.call(Advertiser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Advertiser]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Advertiser.t`.
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
  _ida.Stream<List<Advertiser>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdvertiserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdvertiserTable>? orderBy,
    _is.OrderByListBuilder<AdvertiserTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Advertiser>(
      where: where?.call(Advertiser.t),
      orderBy: orderBy?.call(Advertiser.t),
      orderByList: orderByList?.call(Advertiser.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Advertiser] matching the given query parameters.
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
  Future<Advertiser?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdvertiserTable>? where,
    int? offset,
    _is.OrderByBuilder<AdvertiserTable>? orderBy,
    _is.OrderByListBuilder<AdvertiserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Advertiser>(
      where: where?.call(Advertiser.t),
      orderBy: orderBy?.call(Advertiser.t),
      orderByList: orderByList?.call(Advertiser.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Advertiser] by its [id] or null if no such row exists.
  Future<Advertiser?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Advertiser>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Advertiser]s in the list and returns the inserted rows.
  ///
  /// The returned [Advertiser]s will have their `id` fields set.
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
  Future<List<Advertiser>> insert(
    _is.DatabaseSession session,
    List<Advertiser> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Advertiser>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Advertiser] and returns the inserted row.
  ///
  /// The returned [Advertiser] will have its `id` field set.
  Future<Advertiser> insertRow(
    _is.DatabaseSession session,
    Advertiser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Advertiser>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Advertiser]s in the list and returns the resulting rows.
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
  /// The returned [Advertiser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Advertiser>> upsert(
    _is.DatabaseSession session,
    List<Advertiser> rows, {
    required _is.ColumnSelections<AdvertiserTable> conflictColumns,
    _is.ColumnSelections<AdvertiserTable>? updateColumns,
    _is.WhereExpressionBuilder<AdvertiserTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Advertiser>(
      rows,
      conflictColumns: conflictColumns(Advertiser.t),
      updateColumns: updateColumns?.call(Advertiser.t),
      updateWhere: updateWhere?.call(Advertiser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Advertiser] and returns the resulting row.
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
  /// The returned [Advertiser] will have its `id` field set.
  Future<Advertiser?> upsertRow(
    _is.DatabaseSession session,
    Advertiser row, {
    required _is.ColumnSelections<AdvertiserTable> conflictColumns,
    _is.ColumnSelections<AdvertiserTable>? updateColumns,
    _is.WhereExpressionBuilder<AdvertiserTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Advertiser>(
      row,
      conflictColumns: conflictColumns(Advertiser.t),
      updateColumns: updateColumns?.call(Advertiser.t),
      updateWhere: updateWhere?.call(Advertiser.t),
      transaction: transaction,
    );
  }

  /// Updates all [Advertiser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Advertiser>> update(
    _is.DatabaseSession session,
    List<Advertiser> rows, {
    _is.ColumnSelections<AdvertiserTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Advertiser>(
      rows,
      columns: columns?.call(Advertiser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Advertiser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Advertiser> updateRow(
    _is.DatabaseSession session,
    Advertiser row, {
    _is.ColumnSelections<AdvertiserTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Advertiser>(
      row,
      columns: columns?.call(Advertiser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Advertiser] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Advertiser?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AdvertiserUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Advertiser>(
      id,
      columnValues: columnValues(Advertiser.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Advertiser]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Advertiser>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AdvertiserUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AdvertiserTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdvertiserTable>? orderBy,
    _is.OrderByListBuilder<AdvertiserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Advertiser>(
      columnValues: columnValues(Advertiser.t.updateTable),
      where: where(Advertiser.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Advertiser.t),
      orderByList: orderByList?.call(Advertiser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Advertiser]s in the list and returns the deleted rows.
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
  Future<List<Advertiser>> delete(
    _is.DatabaseSession session,
    List<Advertiser> rows, {
    _is.OrderByBuilder<AdvertiserTable>? orderBy,
    _is.OrderByListBuilder<AdvertiserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Advertiser>(
      rows,
      orderBy: orderBy?.call(Advertiser.t),
      orderByList: orderByList?.call(Advertiser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Advertiser].
  Future<Advertiser> deleteRow(
    _is.DatabaseSession session,
    Advertiser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Advertiser>(
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
  Future<List<Advertiser>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdvertiserTable> where,
    _is.OrderByBuilder<AdvertiserTable>? orderBy,
    _is.OrderByListBuilder<AdvertiserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Advertiser>(
      where: where(Advertiser.t),
      orderBy: orderBy?.call(Advertiser.t),
      orderByList: orderByList?.call(Advertiser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdvertiserTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Advertiser>(
      where: where?.call(Advertiser.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Advertiser] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdvertiserTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Advertiser>(
      where: where(Advertiser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
