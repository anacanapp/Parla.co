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
import '../consent/consent_type.dart' as _ienhynl9;

/// One consent decision. Append-only: a change is a new row, never an update
/// (GDPR Art. 7(1), checklist CON-3). Retention: 3 years after account
/// deletion with a hashed user id (proposal, pending legal review).
abstract class ConsentRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ConsentRecord._({
    this.id,
    required this.authUserId,
    required this.consentType,
    required this.granted,
    required this.textVersion,
    required this.textHash,
    required this.language,
    required this.source,
    required this.createdAt,
  });

  factory ConsentRecord({
    int? id,
    required _is.UuidValue authUserId,
    required _ienhynl9.ConsentType consentType,
    required bool granted,
    required String textVersion,
    required String textHash,
    required String language,
    required String source,
    required DateTime createdAt,
  }) = _ConsentRecordImpl;

  factory ConsentRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConsentRecord(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      consentType: _ienhynl9.ConsentType.fromJson(
        (jsonSerialization['consentType'] as String),
      ),
      granted: _is.BoolJsonExtension.fromJson(jsonSerialization['granted']),
      textVersion: jsonSerialization['textVersion'] as String,
      textHash: jsonSerialization['textHash'] as String,
      language: jsonSerialization['language'] as String,
      source: jsonSerialization['source'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ConsentRecordTable();

  static const db = ConsentRecordRepository._();

  @override
  int? id;

  /// The authenticated user who decided.
  _is.UuidValue authUserId;

  _ienhynl9.ConsentType consentType;

  bool granted;

  /// Version of the text in parla_shared that was shown.
  String textVersion;

  /// SHA-256 of the exact text shown, in [language].
  String textHash;

  String language;

  /// Where the decision was made: app or web.
  String source;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ConsentRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ConsentRecord copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _ienhynl9.ConsentType? consentType,
    bool? granted,
    String? textVersion,
    String? textHash,
    String? language,
    String? source,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConsentRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'consentType': consentType.toJson(),
      'granted': granted,
      'textVersion': textVersion,
      'textHash': textHash,
      'language': language,
      'source': source,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConsentRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'consentType': consentType.toJson(),
      'granted': granted,
      'textVersion': textVersion,
      'textHash': textHash,
      'language': language,
      'source': source,
      'createdAt': createdAt.toJson(),
    };
  }

  static ConsentRecordInclude include() {
    return ConsentRecordInclude._();
  }

  static ConsentRecordIncludeList includeList({
    _is.WhereExpressionBuilder<ConsentRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ConsentRecordTable>? orderBy,
    _is.OrderByListBuilder<ConsentRecordTable>? orderByList,
    ConsentRecordInclude? include,
  }) {
    return ConsentRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ConsentRecord.t),
      orderByList: orderByList?.call(ConsentRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConsentRecordImpl extends ConsentRecord {
  _ConsentRecordImpl({
    int? id,
    required _is.UuidValue authUserId,
    required _ienhynl9.ConsentType consentType,
    required bool granted,
    required String textVersion,
    required String textHash,
    required String language,
    required String source,
    required DateTime createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         consentType: consentType,
         granted: granted,
         textVersion: textVersion,
         textHash: textHash,
         language: language,
         source: source,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ConsentRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ConsentRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    _ienhynl9.ConsentType? consentType,
    bool? granted,
    String? textVersion,
    String? textHash,
    String? language,
    String? source,
    DateTime? createdAt,
  }) {
    return ConsentRecord(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      consentType: consentType ?? this.consentType,
      granted: granted ?? this.granted,
      textVersion: textVersion ?? this.textVersion,
      textHash: textHash ?? this.textHash,
      language: language ?? this.language,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ConsentRecordUpdateTable extends _is.UpdateTable<ConsentRecordTable> {
  ConsentRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<_ienhynl9.ConsentType, _ienhynl9.ConsentType> consentType(
    _ienhynl9.ConsentType value,
  ) => _is.ColumnValue(
    table.consentType,
    value,
  );

  _is.ColumnValue<bool, bool> granted(bool value) => _is.ColumnValue(
    table.granted,
    value,
  );

  _is.ColumnValue<String, String> textVersion(String value) => _is.ColumnValue(
    table.textVersion,
    value,
  );

  _is.ColumnValue<String, String> textHash(String value) => _is.ColumnValue(
    table.textHash,
    value,
  );

  _is.ColumnValue<String, String> language(String value) => _is.ColumnValue(
    table.language,
    value,
  );

  _is.ColumnValue<String, String> source(String value) => _is.ColumnValue(
    table.source,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ConsentRecordTable extends _is.Table<int?> {
  ConsentRecordTable({super.tableRelation})
    : super(tableName: 'consent_record') {
    updateTable = ConsentRecordUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    consentType = _is.ColumnEnum(
      'consentType',
      this,
      _is.EnumSerialization.byName,
    );
    granted = _is.ColumnBool(
      'granted',
      this,
    );
    textVersion = _is.ColumnString(
      'textVersion',
      this,
    );
    textHash = _is.ColumnString(
      'textHash',
      this,
    );
    language = _is.ColumnString(
      'language',
      this,
    );
    source = _is.ColumnString(
      'source',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ConsentRecordUpdateTable updateTable;

  /// The authenticated user who decided.
  late final _is.ColumnUuid authUserId;

  late final _is.ColumnEnum<_ienhynl9.ConsentType> consentType;

  late final _is.ColumnBool granted;

  /// Version of the text in parla_shared that was shown.
  late final _is.ColumnString textVersion;

  /// SHA-256 of the exact text shown, in [language].
  late final _is.ColumnString textHash;

  late final _is.ColumnString language;

  /// Where the decision was made: app or web.
  late final _is.ColumnString source;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    consentType,
    granted,
    textVersion,
    textHash,
    language,
    source,
    createdAt,
  ];
}

class ConsentRecordInclude extends _is.IncludeObject {
  ConsentRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ConsentRecord.t;
}

class ConsentRecordIncludeList extends _is.IncludeList {
  ConsentRecordIncludeList._({
    _is.WhereExpressionBuilder<ConsentRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ConsentRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ConsentRecord.t;
}

class ConsentRecordRepository {
  const ConsentRecordRepository._();

  /// Returns a list of [ConsentRecord]s matching the given query parameters.
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
  Future<List<ConsentRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ConsentRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ConsentRecordTable>? orderBy,
    _is.OrderByListBuilder<ConsentRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ConsentRecord>(
      where: where?.call(ConsentRecord.t),
      orderBy: orderBy?.call(ConsentRecord.t),
      orderByList: orderByList?.call(ConsentRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ConsentRecord]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ConsentRecord.t`.
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
  _ida.Stream<List<ConsentRecord>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ConsentRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ConsentRecordTable>? orderBy,
    _is.OrderByListBuilder<ConsentRecordTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ConsentRecord>(
      where: where?.call(ConsentRecord.t),
      orderBy: orderBy?.call(ConsentRecord.t),
      orderByList: orderByList?.call(ConsentRecord.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ConsentRecord] matching the given query parameters.
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
  Future<ConsentRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ConsentRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<ConsentRecordTable>? orderBy,
    _is.OrderByListBuilder<ConsentRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ConsentRecord>(
      where: where?.call(ConsentRecord.t),
      orderBy: orderBy?.call(ConsentRecord.t),
      orderByList: orderByList?.call(ConsentRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ConsentRecord] by its [id] or null if no such row exists.
  Future<ConsentRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ConsentRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ConsentRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [ConsentRecord]s will have their `id` fields set.
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
  Future<List<ConsentRecord>> insert(
    _is.DatabaseSession session,
    List<ConsentRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ConsentRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ConsentRecord] and returns the inserted row.
  ///
  /// The returned [ConsentRecord] will have its `id` field set.
  Future<ConsentRecord> insertRow(
    _is.DatabaseSession session,
    ConsentRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ConsentRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ConsentRecord]s in the list and returns the resulting rows.
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
  /// The returned [ConsentRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ConsentRecord>> upsert(
    _is.DatabaseSession session,
    List<ConsentRecord> rows, {
    required _is.ColumnSelections<ConsentRecordTable> conflictColumns,
    _is.ColumnSelections<ConsentRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<ConsentRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ConsentRecord>(
      rows,
      conflictColumns: conflictColumns(ConsentRecord.t),
      updateColumns: updateColumns?.call(ConsentRecord.t),
      updateWhere: updateWhere?.call(ConsentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ConsentRecord] and returns the resulting row.
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
  /// The returned [ConsentRecord] will have its `id` field set.
  Future<ConsentRecord?> upsertRow(
    _is.DatabaseSession session,
    ConsentRecord row, {
    required _is.ColumnSelections<ConsentRecordTable> conflictColumns,
    _is.ColumnSelections<ConsentRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<ConsentRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ConsentRecord>(
      row,
      conflictColumns: conflictColumns(ConsentRecord.t),
      updateColumns: updateColumns?.call(ConsentRecord.t),
      updateWhere: updateWhere?.call(ConsentRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [ConsentRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ConsentRecord>> update(
    _is.DatabaseSession session,
    List<ConsentRecord> rows, {
    _is.ColumnSelections<ConsentRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ConsentRecord>(
      rows,
      columns: columns?.call(ConsentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ConsentRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ConsentRecord> updateRow(
    _is.DatabaseSession session,
    ConsentRecord row, {
    _is.ColumnSelections<ConsentRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ConsentRecord>(
      row,
      columns: columns?.call(ConsentRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ConsentRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ConsentRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ConsentRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ConsentRecord>(
      id,
      columnValues: columnValues(ConsentRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ConsentRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ConsentRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ConsentRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ConsentRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ConsentRecordTable>? orderBy,
    _is.OrderByListBuilder<ConsentRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ConsentRecord>(
      columnValues: columnValues(ConsentRecord.t.updateTable),
      where: where(ConsentRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ConsentRecord.t),
      orderByList: orderByList?.call(ConsentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ConsentRecord]s in the list and returns the deleted rows.
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
  Future<List<ConsentRecord>> delete(
    _is.DatabaseSession session,
    List<ConsentRecord> rows, {
    _is.OrderByBuilder<ConsentRecordTable>? orderBy,
    _is.OrderByListBuilder<ConsentRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ConsentRecord>(
      rows,
      orderBy: orderBy?.call(ConsentRecord.t),
      orderByList: orderByList?.call(ConsentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ConsentRecord].
  Future<ConsentRecord> deleteRow(
    _is.DatabaseSession session,
    ConsentRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ConsentRecord>(
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
  Future<List<ConsentRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ConsentRecordTable> where,
    _is.OrderByBuilder<ConsentRecordTable>? orderBy,
    _is.OrderByListBuilder<ConsentRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ConsentRecord>(
      where: where(ConsentRecord.t),
      orderBy: orderBy?.call(ConsentRecord.t),
      orderByList: orderByList?.call(ConsentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ConsentRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ConsentRecord>(
      where: where?.call(ConsentRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ConsentRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ConsentRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ConsentRecord>(
      where: where(ConsentRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
