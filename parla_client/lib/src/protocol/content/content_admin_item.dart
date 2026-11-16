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

/// A content item as the admin panel shows it.
abstract class ContentAdminItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      live: _isc.BoolJsonExtension.fromJson(jsonSerialization['live']),
      reviewedAt: jsonSerialization['reviewedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['reviewedAt'],
            ),
      reviewNote: jsonSerialization['reviewNote'] as String?,
      consentRecorded: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['consentRecorded'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
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

  DateTime updatedAt;

  /// Returns a shallow copy of this [ContentAdminItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ContentAdminItem copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    _i13hi3mr.ContentStatus? status,
    String? draftJson,
    bool? live,
    DateTime? reviewedAt = const _isc.$UndefinedDateTime(),
    String? reviewNote,
    bool? consentRecorded,
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
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ContentAdminItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ContentAdminItem copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    _i13hi3mr.ContentStatus? status,
    String? draftJson,
    bool? live,
    DateTime? reviewedAt = const _isc.$UndefinedDateTime(),
    Object? reviewNote = _Undefined,
    bool? consentRecorded,
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
      reviewedAt: reviewedAt is _isc.UndefinedSentinel
          ? this.reviewedAt
          : reviewedAt,
      reviewNote: reviewNote is String? ? reviewNote : this.reviewNote,
      consentRecorded: consentRecorded ?? this.consentRecorded,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
