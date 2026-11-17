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
import 'package:serverpod/serverpod.dart' as _is;
import '../content/content_status.dart' as _i13hi3mr;

/// A content item as the admin panel shows it.
abstract class ContentAdminItem
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ContentAdminItem._({
    required this.id,
    required this.kind,
    required this.slug,
    required this.category,
    required this.status,
    required this.draftJson,
    required this.live,
    this.reviewedAt,
    this.reviewNote,
    required this.consentRecorded,
    required this.hidden,
    required this.updatedAt,
  });

  factory ContentAdminItem({
    required int id,
    required String kind,
    required String slug,
    required String category,
    required _i13hi3mr.ContentStatus status,
    required String draftJson,
    required bool live,
    DateTime? reviewedAt,
    String? reviewNote,
    required bool consentRecorded,
    required bool hidden,
    required DateTime updatedAt,
  }) = _ContentAdminItemImpl;

  factory ContentAdminItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ContentAdminItem(
      id: jsonSerialization['id'] as int,
      kind: jsonSerialization['kind'] as String,
      slug: jsonSerialization['slug'] as String,
      category: jsonSerialization['category'] as String,
      status: _i13hi3mr.ContentStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      draftJson: jsonSerialization['draftJson'] as String,
      live: _is.BoolJsonExtension.fromJson(jsonSerialization['live']),
      reviewedAt: jsonSerialization['reviewedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['reviewedAt']),
      reviewNote: jsonSerialization['reviewNote'] as String?,
      consentRecorded: _is.BoolJsonExtension.fromJson(
        jsonSerialization['consentRecorded'],
      ),
      hidden: _is.BoolJsonExtension.fromJson(jsonSerialization['hidden']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int id;

  String kind;

  String slug;

  String category;

  _i13hi3mr.ContentStatus status;

  String draftJson;

  bool live;

  DateTime? reviewedAt;

  String? reviewNote;

  bool consentRecorded;

  bool hidden;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ContentAdminItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ContentAdminItem copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    _i13hi3mr.ContentStatus? status,
    String? draftJson,
    bool? live,
    DateTime? reviewedAt = const _is.$UndefinedDateTime(),
    String? reviewNote,
    bool? consentRecorded,
    bool? hidden,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ContentAdminItem',
      'id': id,
      'kind': kind,
      'slug': slug,
      'category': category,
      'status': status.toJson(),
      'draftJson': draftJson,
      'live': live,
      if (reviewedAt != null) 'reviewedAt': reviewedAt?.toJson(),
      if (reviewNote != null) 'reviewNote': reviewNote,
      'consentRecorded': consentRecorded,
      'hidden': hidden,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ContentAdminItem',
      'id': id,
      'kind': kind,
      'slug': slug,
      'category': category,
      'status': status.toJson(),
      'draftJson': draftJson,
      'live': live,
      if (reviewedAt != null) 'reviewedAt': reviewedAt?.toJson(),
      if (reviewNote != null) 'reviewNote': reviewNote,
      'consentRecorded': consentRecorded,
      'hidden': hidden,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ContentAdminItemImpl extends ContentAdminItem {
  _ContentAdminItemImpl({
    required int id,
    required String kind,
    required String slug,
    required String category,
    required _i13hi3mr.ContentStatus status,
    required String draftJson,
    required bool live,
    DateTime? reviewedAt,
    String? reviewNote,
    required bool consentRecorded,
    required bool hidden,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         kind: kind,
         slug: slug,
         category: category,
         status: status,
         draftJson: draftJson,
         live: live,
         reviewedAt: reviewedAt,
         reviewNote: reviewNote,
         consentRecorded: consentRecorded,
         hidden: hidden,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ContentAdminItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ContentAdminItem copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    _i13hi3mr.ContentStatus? status,
    String? draftJson,
    bool? live,
    DateTime? reviewedAt = const _is.$UndefinedDateTime(),
    Object? reviewNote = _Undefined,
    bool? consentRecorded,
    bool? hidden,
    DateTime? updatedAt,
  }) {
    return ContentAdminItem(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      status: status ?? this.status,
      draftJson: draftJson ?? this.draftJson,
      live: live ?? this.live,
      reviewedAt: reviewedAt is _is.UndefinedSentinel
          ? this.reviewedAt
          : reviewedAt,
      reviewNote: reviewNote is String? ? reviewNote : this.reviewNote,
      consentRecorded: consentRecorded ?? this.consentRecorded,
      hidden: hidden ?? this.hidden,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
