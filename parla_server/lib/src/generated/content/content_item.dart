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
import '../content/content_status.dart' as _i13hi3mr;

/// Content written in the admin panel: an article, a recipe or an expert
/// profile ([kind] is a ContentKind name from parla_shared).
/// [draftJson] is the working copy; [publishedJson] is what the app shows,
/// set only by publishing, so editing never changes live content. Experts'
/// profiles may be published only after their written consent is recorded.
abstract class ContentItem
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ContentItem._({
    this.id,
    required this.kind,
    required this.slug,
    required this.category,
    required this.status,
    required this.draftJson,
    this.publishedJson,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNote,
    this.publishedReviewedAt,
    this.consentRecordedAt,
    this.consentNote,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  factory ContentItem({
    int? id,
    required String kind,
    required String slug,
    required String category,
    required _i13hi3mr.ContentStatus status,
    required String draftJson,
    String? publishedJson,
    _is.UuidValue? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNote,
    DateTime? publishedReviewedAt,
    DateTime? consentRecordedAt,
    String? consentNote,
    required _is.UuidValue createdBy,
    required _is.UuidValue updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? publishedAt,
  }) = _ContentItemImpl;

  factory ContentItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ContentItem(
      id: jsonSerialization['id'] as int?,
      kind: jsonSerialization['kind'] as String,
      slug: jsonSerialization['slug'] as String,
      category: jsonSerialization['category'] as String,
      status: _i13hi3mr.ContentStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      draftJson: jsonSerialization['draftJson'] as String,
      publishedJson: jsonSerialization['publishedJson'] as String?,
      reviewedBy: jsonSerialization['reviewedBy'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['reviewedBy'],
            ),
      reviewedAt: jsonSerialization['reviewedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['reviewedAt']),
      reviewNote: jsonSerialization['reviewNote'] as String?,
      publishedReviewedAt: jsonSerialization['publishedReviewedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['publishedReviewedAt'],
            ),
      consentRecordedAt: jsonSerialization['consentRecordedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['consentRecordedAt'],
            ),
      consentNote: jsonSerialization['consentNote'] as String?,
      createdBy: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      updatedBy: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['updatedBy'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      publishedAt: jsonSerialization['publishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['publishedAt'],
            ),
    );
  }

  static final t = ContentItemTable();

  static const db = ContentItemRepository._();

  @override
  int? id;

  String kind;

  String slug;

  String category;

  _i13hi3mr.ContentStatus status;

  String draftJson;

  String? publishedJson;

  _is.UuidValue? reviewedBy;

  DateTime? reviewedAt;

  String? reviewNote;

  /// When the published copy was reviewed (shown as "reviewed by an expert").
  DateTime? publishedReviewedAt;

  DateTime? consentRecordedAt;

  /// Where the expert's written consent is kept (a reference, not the
  /// document itself).
  String? consentNote;

  _is.UuidValue createdBy;

  _is.UuidValue updatedBy;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? publishedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ContentItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ContentItem copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    _i13hi3mr.ContentStatus? status,
    String? draftJson,
    String? publishedJson,
    _is.UuidValue? reviewedBy = const _is.$UndefinedUuidValue(),
    DateTime? reviewedAt = const _is.$UndefinedDateTime(),
    String? reviewNote,
    DateTime? publishedReviewedAt = const _is.$UndefinedDateTime(),
    DateTime? consentRecordedAt = const _is.$UndefinedDateTime(),
    String? consentNote,
    _is.UuidValue? createdBy,
    _is.UuidValue? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ContentItem',
      if (id != null) 'id': id,
      'kind': kind,
      'slug': slug,
      'category': category,
      'status': status.toJson(),
      'draftJson': draftJson,
      if (publishedJson != null) 'publishedJson': publishedJson,
      if (reviewedBy != null) 'reviewedBy': reviewedBy?.toJson(),
      if (reviewedAt != null) 'reviewedAt': reviewedAt?.toJson(),
      if (reviewNote != null) 'reviewNote': reviewNote,
      if (publishedReviewedAt != null)
        'publishedReviewedAt': publishedReviewedAt?.toJson(),
      if (consentRecordedAt != null)
        'consentRecordedAt': consentRecordedAt?.toJson(),
      if (consentNote != null) 'consentNote': consentNote,
      'createdBy': createdBy.toJson(),
      'updatedBy': updatedBy.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ContentItem',
      if (id != null) 'id': id,
      'kind': kind,
      'slug': slug,
      'category': category,
      'status': status.toJson(),
      'draftJson': draftJson,
      if (publishedJson != null) 'publishedJson': publishedJson,
      if (reviewedBy != null) 'reviewedBy': reviewedBy?.toJson(),
      if (reviewedAt != null) 'reviewedAt': reviewedAt?.toJson(),
      if (reviewNote != null) 'reviewNote': reviewNote,
      if (publishedReviewedAt != null)
        'publishedReviewedAt': publishedReviewedAt?.toJson(),
      if (consentRecordedAt != null)
        'consentRecordedAt': consentRecordedAt?.toJson(),
      if (consentNote != null) 'consentNote': consentNote,
      'createdBy': createdBy.toJson(),
      'updatedBy': updatedBy.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
    };
  }

  static ContentItemInclude include() {
    return ContentItemInclude._();
  }

  static ContentItemIncludeList includeList({
    _is.WhereExpressionBuilder<ContentItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ContentItemTable>? orderBy,
    _is.OrderByListBuilder<ContentItemTable>? orderByList,
    ContentItemInclude? include,
  }) {
    return ContentItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ContentItem.t),
      orderByList: orderByList?.call(ContentItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ContentItemImpl extends ContentItem {
  _ContentItemImpl({
    int? id,
    required String kind,
    required String slug,
    required String category,
    required _i13hi3mr.ContentStatus status,
    required String draftJson,
    String? publishedJson,
    _is.UuidValue? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNote,
    DateTime? publishedReviewedAt,
    DateTime? consentRecordedAt,
    String? consentNote,
    required _is.UuidValue createdBy,
    required _is.UuidValue updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? publishedAt,
  }) : super._(
         id: id,
         kind: kind,
         slug: slug,
         category: category,
         status: status,
         draftJson: draftJson,
         publishedJson: publishedJson,
         reviewedBy: reviewedBy,
         reviewedAt: reviewedAt,
         reviewNote: reviewNote,
         publishedReviewedAt: publishedReviewedAt,
         consentRecordedAt: consentRecordedAt,
         consentNote: consentNote,
         createdBy: createdBy,
         updatedBy: updatedBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
         publishedAt: publishedAt,
       );

  /// Returns a shallow copy of this [ContentItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ContentItem copyWith({
    Object? id = _Undefined,
    String? kind,
    String? slug,
    String? category,
    _i13hi3mr.ContentStatus? status,
    String? draftJson,
    Object? publishedJson = _Undefined,
    _is.UuidValue? reviewedBy = const _is.$UndefinedUuidValue(),
    DateTime? reviewedAt = const _is.$UndefinedDateTime(),
    Object? reviewNote = _Undefined,
    DateTime? publishedReviewedAt = const _is.$UndefinedDateTime(),
    DateTime? consentRecordedAt = const _is.$UndefinedDateTime(),
    Object? consentNote = _Undefined,
    _is.UuidValue? createdBy,
    _is.UuidValue? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt = const _is.$UndefinedDateTime(),
  }) {
    return ContentItem(
      id: id is int? ? id : this.id,
      kind: kind ?? this.kind,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      status: status ?? this.status,
      draftJson: draftJson ?? this.draftJson,
      publishedJson: publishedJson is String?
          ? publishedJson
          : this.publishedJson,
      reviewedBy: reviewedBy is _is.UndefinedSentinel
          ? this.reviewedBy
          : reviewedBy,
      reviewedAt: reviewedAt is _is.UndefinedSentinel
          ? this.reviewedAt
          : reviewedAt,
      reviewNote: reviewNote is String? ? reviewNote : this.reviewNote,
      publishedReviewedAt: publishedReviewedAt is _is.UndefinedSentinel
          ? this.publishedReviewedAt
          : publishedReviewedAt,
      consentRecordedAt: consentRecordedAt is _is.UndefinedSentinel
          ? this.consentRecordedAt
          : consentRecordedAt,
      consentNote: consentNote is String? ? consentNote : this.consentNote,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt is _is.UndefinedSentinel
          ? this.publishedAt
          : publishedAt,
    );
  }
}

class ContentItemUpdateTable extends _is.UpdateTable<ContentItemTable> {
  ContentItemUpdateTable(super.table);

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> slug(String value) => _is.ColumnValue(
    table.slug,
    value,
  );

  _is.ColumnValue<String, String> category(String value) => _is.ColumnValue(
    table.category,
    value,
  );

  _is.ColumnValue<_i13hi3mr.ContentStatus, _i13hi3mr.ContentStatus> status(
    _i13hi3mr.ContentStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> draftJson(String value) => _is.ColumnValue(
    table.draftJson,
    value,
  );

  _is.ColumnValue<String, String> publishedJson(String? value) =>
      _is.ColumnValue(
        table.publishedJson,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> reviewedBy(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.reviewedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> reviewedAt(DateTime? value) =>
      _is.ColumnValue(
        table.reviewedAt,
        value,
      );

  _is.ColumnValue<String, String> reviewNote(String? value) => _is.ColumnValue(
    table.reviewNote,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> publishedReviewedAt(DateTime? value) =>
      _is.ColumnValue(
        table.publishedReviewedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> consentRecordedAt(DateTime? value) =>
      _is.ColumnValue(
        table.consentRecordedAt,
        value,
      );

  _is.ColumnValue<String, String> consentNote(String? value) => _is.ColumnValue(
    table.consentNote,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> createdBy(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.createdBy,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> updatedBy(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.updatedBy,
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

  _is.ColumnValue<DateTime, DateTime> publishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.publishedAt,
        value,
      );
}

class ContentItemTable extends _is.Table<int?> {
  ContentItemTable({super.tableRelation}) : super(tableName: 'content_item') {
    updateTable = ContentItemUpdateTable(this);
    kind = _is.ColumnString(
      'kind',
      this,
    );
    slug = _is.ColumnString(
      'slug',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    draftJson = _is.ColumnString(
      'draftJson',
      this,
    );
    publishedJson = _is.ColumnString(
      'publishedJson',
      this,
    );
    reviewedBy = _is.ColumnUuid(
      'reviewedBy',
      this,
    );
    reviewedAt = _is.ColumnDateTime(
      'reviewedAt',
      this,
    );
    reviewNote = _is.ColumnString(
      'reviewNote',
      this,
    );
    publishedReviewedAt = _is.ColumnDateTime(
      'publishedReviewedAt',
      this,
    );
    consentRecordedAt = _is.ColumnDateTime(
      'consentRecordedAt',
      this,
    );
    consentNote = _is.ColumnString(
      'consentNote',
      this,
    );
    createdBy = _is.ColumnUuid(
      'createdBy',
      this,
    );
    updatedBy = _is.ColumnUuid(
      'updatedBy',
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
    publishedAt = _is.ColumnDateTime(
      'publishedAt',
      this,
    );
  }

  late final ContentItemUpdateTable updateTable;

  late final _is.ColumnString kind;

  late final _is.ColumnString slug;

  late final _is.ColumnString category;

  late final _is.ColumnEnum<_i13hi3mr.ContentStatus> status;

  late final _is.ColumnString draftJson;

  late final _is.ColumnString publishedJson;

  late final _is.ColumnUuid reviewedBy;

  late final _is.ColumnDateTime reviewedAt;

  late final _is.ColumnString reviewNote;

  /// When the published copy was reviewed (shown as "reviewed by an expert").
  late final _is.ColumnDateTime publishedReviewedAt;

  late final _is.ColumnDateTime consentRecordedAt;

  /// Where the expert's written consent is kept (a reference, not the
  /// document itself).
  late final _is.ColumnString consentNote;

  late final _is.ColumnUuid createdBy;

  late final _is.ColumnUuid updatedBy;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime publishedAt;

  @override
  List<_is.Column> get columns => [
    id,
    kind,
    slug,
    category,
    status,
    draftJson,
    publishedJson,
    reviewedBy,
    reviewedAt,
    reviewNote,
    publishedReviewedAt,
    consentRecordedAt,
    consentNote,
    createdBy,
    updatedBy,
    createdAt,
    updatedAt,
    publishedAt,
  ];
}

class ContentItemInclude extends _is.IncludeObject {
  ContentItemInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ContentItem.t;
}

class ContentItemIncludeList extends _is.IncludeList {
  ContentItemIncludeList._({
    _is.WhereExpressionBuilder<ContentItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ContentItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ContentItem.t;
}

class ContentItemRepository {
  const ContentItemRepository._();

  /// Returns a list of [ContentItem]s matching the given query parameters.
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
  Future<List<ContentItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ContentItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ContentItemTable>? orderBy,
    _is.OrderByListBuilder<ContentItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ContentItem>(
      where: where?.call(ContentItem.t),
      orderBy: orderBy?.call(ContentItem.t),
      orderByList: orderByList?.call(ContentItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ContentItem]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ContentItem.t`.
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
  _ida.Stream<List<ContentItem>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ContentItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ContentItemTable>? orderBy,
    _is.OrderByListBuilder<ContentItemTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ContentItem>(
      where: where?.call(ContentItem.t),
      orderBy: orderBy?.call(ContentItem.t),
      orderByList: orderByList?.call(ContentItem.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ContentItem] matching the given query parameters.
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
  Future<ContentItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ContentItemTable>? where,
    int? offset,
    _is.OrderByBuilder<ContentItemTable>? orderBy,
    _is.OrderByListBuilder<ContentItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ContentItem>(
      where: where?.call(ContentItem.t),
      orderBy: orderBy?.call(ContentItem.t),
      orderByList: orderByList?.call(ContentItem.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ContentItem] by its [id] or null if no such row exists.
  Future<ContentItem?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ContentItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ContentItem]s in the list and returns the inserted rows.
  ///
  /// The returned [ContentItem]s will have their `id` fields set.
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
  Future<List<ContentItem>> insert(
    _is.DatabaseSession session,
    List<ContentItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ContentItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ContentItem] and returns the inserted row.
  ///
  /// The returned [ContentItem] will have its `id` field set.
  Future<ContentItem> insertRow(
    _is.DatabaseSession session,
    ContentItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ContentItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ContentItem]s in the list and returns the resulting rows.
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
  /// The returned [ContentItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ContentItem>> upsert(
    _is.DatabaseSession session,
    List<ContentItem> rows, {
    required _is.ColumnSelections<ContentItemTable> conflictColumns,
    _is.ColumnSelections<ContentItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ContentItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ContentItem>(
      rows,
      conflictColumns: conflictColumns(ContentItem.t),
      updateColumns: updateColumns?.call(ContentItem.t),
      updateWhere: updateWhere?.call(ContentItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ContentItem] and returns the resulting row.
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
  /// The returned [ContentItem] will have its `id` field set.
  Future<ContentItem?> upsertRow(
    _is.DatabaseSession session,
    ContentItem row, {
    required _is.ColumnSelections<ContentItemTable> conflictColumns,
    _is.ColumnSelections<ContentItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ContentItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ContentItem>(
      row,
      conflictColumns: conflictColumns(ContentItem.t),
      updateColumns: updateColumns?.call(ContentItem.t),
      updateWhere: updateWhere?.call(ContentItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [ContentItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ContentItem>> update(
    _is.DatabaseSession session,
    List<ContentItem> rows, {
    _is.ColumnSelections<ContentItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ContentItem>(
      rows,
      columns: columns?.call(ContentItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ContentItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ContentItem> updateRow(
    _is.DatabaseSession session,
    ContentItem row, {
    _is.ColumnSelections<ContentItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ContentItem>(
      row,
      columns: columns?.call(ContentItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ContentItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ContentItem?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ContentItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ContentItem>(
      id,
      columnValues: columnValues(ContentItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ContentItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ContentItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ContentItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ContentItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ContentItemTable>? orderBy,
    _is.OrderByListBuilder<ContentItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ContentItem>(
      columnValues: columnValues(ContentItem.t.updateTable),
      where: where(ContentItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ContentItem.t),
      orderByList: orderByList?.call(ContentItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ContentItem]s in the list and returns the deleted rows.
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
  Future<List<ContentItem>> delete(
    _is.DatabaseSession session,
    List<ContentItem> rows, {
    _is.OrderByBuilder<ContentItemTable>? orderBy,
    _is.OrderByListBuilder<ContentItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ContentItem>(
      rows,
      orderBy: orderBy?.call(ContentItem.t),
      orderByList: orderByList?.call(ContentItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ContentItem].
  Future<ContentItem> deleteRow(
    _is.DatabaseSession session,
    ContentItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ContentItem>(
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
  Future<List<ContentItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ContentItemTable> where,
    _is.OrderByBuilder<ContentItemTable>? orderBy,
    _is.OrderByListBuilder<ContentItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ContentItem>(
      where: where(ContentItem.t),
      orderBy: orderBy?.call(ContentItem.t),
      orderByList: orderByList?.call(ContentItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ContentItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ContentItem>(
      where: where?.call(ContentItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ContentItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ContentItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ContentItem>(
      where: where(ContentItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
