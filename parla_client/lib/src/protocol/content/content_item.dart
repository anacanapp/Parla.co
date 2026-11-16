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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../content/content_status.dart' as _i13hi3mr;

/// Content written in the admin panel: an article, a recipe or an expert
/// profile ([kind] is a ContentKind name from parla_shared).
/// [draftJson] is the working copy; [publishedJson] is what the app shows,
/// set only by publishing, so editing never changes live content. Experts'
/// profiles may be published only after their written consent is recorded.
abstract class ContentItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _isc.UuidValue? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNote,
    DateTime? publishedReviewedAt,
    DateTime? consentRecordedAt,
    String? consentNote,
    required _isc.UuidValue createdBy,
    required _isc.UuidValue updatedBy,
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
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['reviewedBy'],
            ),
      reviewedAt: jsonSerialization['reviewedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['reviewedAt'],
            ),
      reviewNote: jsonSerialization['reviewNote'] as String?,
      publishedReviewedAt: jsonSerialization['publishedReviewedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['publishedReviewedAt'],
            ),
      consentRecordedAt: jsonSerialization['consentRecordedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['consentRecordedAt'],
            ),
      consentNote: jsonSerialization['consentNote'] as String?,
      createdBy: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      updatedBy: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['updatedBy'],
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      publishedAt: jsonSerialization['publishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['publishedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String kind;

  String slug;

  String category;

  _i13hi3mr.ContentStatus status;

  String draftJson;

  String? publishedJson;

  _isc.UuidValue? reviewedBy;

  DateTime? reviewedAt;

  String? reviewNote;

  /// When the published copy was reviewed (shown as "reviewed by an expert").
  DateTime? publishedReviewedAt;

  DateTime? consentRecordedAt;

  /// Where the expert's written consent is kept (a reference, not the
  /// document itself).
  String? consentNote;

  _isc.UuidValue createdBy;

  _isc.UuidValue updatedBy;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? publishedAt;

  /// Returns a shallow copy of this [ContentItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ContentItem copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    _i13hi3mr.ContentStatus? status,
    String? draftJson,
    String? publishedJson,
    _isc.UuidValue? reviewedBy = const _isc.$UndefinedUuidValue(),
    DateTime? reviewedAt = const _isc.$UndefinedDateTime(),
    String? reviewNote,
    DateTime? publishedReviewedAt = const _isc.$UndefinedDateTime(),
    DateTime? consentRecordedAt = const _isc.$UndefinedDateTime(),
    String? consentNote,
    _isc.UuidValue? createdBy,
    _isc.UuidValue? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt = const _isc.$UndefinedDateTime(),
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
    _isc.UuidValue? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNote,
    DateTime? publishedReviewedAt,
    DateTime? consentRecordedAt,
    String? consentNote,
    required _isc.UuidValue createdBy,
    required _isc.UuidValue updatedBy,
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
  @_isc.useResult
  @override
  ContentItem copyWith({
    Object? id = _Undefined,
    String? kind,
    String? slug,
    String? category,
    _i13hi3mr.ContentStatus? status,
    String? draftJson,
    Object? publishedJson = _Undefined,
    _isc.UuidValue? reviewedBy = const _isc.$UndefinedUuidValue(),
    DateTime? reviewedAt = const _isc.$UndefinedDateTime(),
    Object? reviewNote = _Undefined,
    DateTime? publishedReviewedAt = const _isc.$UndefinedDateTime(),
    DateTime? consentRecordedAt = const _isc.$UndefinedDateTime(),
    Object? consentNote = _Undefined,
    _isc.UuidValue? createdBy,
    _isc.UuidValue? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt = const _isc.$UndefinedDateTime(),
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
      reviewedBy: reviewedBy is _isc.UndefinedSentinel
          ? this.reviewedBy
          : reviewedBy,
      reviewedAt: reviewedAt is _isc.UndefinedSentinel
          ? this.reviewedAt
          : reviewedAt,
      reviewNote: reviewNote is String? ? reviewNote : this.reviewNote,
      publishedReviewedAt: publishedReviewedAt is _isc.UndefinedSentinel
          ? this.publishedReviewedAt
          : publishedReviewedAt,
      consentRecordedAt: consentRecordedAt is _isc.UndefinedSentinel
          ? this.consentRecordedAt
          : consentRecordedAt,
      consentNote: consentNote is String? ? consentNote : this.consentNote,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt is _isc.UndefinedSentinel
          ? this.publishedAt
          : publishedAt,
    );
  }
}
