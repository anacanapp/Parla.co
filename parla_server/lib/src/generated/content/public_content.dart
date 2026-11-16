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
import 'package:parla_server/src/generated/protocol.dart' as _i19kjxmt;
import 'package:serverpod/serverpod.dart' as _is;
import '../media/public_image.dart' as _ium6b0ir;

/// A published content item as the app reads it.
abstract class PublicContent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PublicContent._({
    required this.id,
    required this.kind,
    required this.slug,
    required this.category,
    required this.json,
    this.reviewedAt,
    required this.publishedAt,
    this.image,
  });

  factory PublicContent({
    required int id,
    required String kind,
    required String slug,
    required String category,
    required String json,
    DateTime? reviewedAt,
    required DateTime publishedAt,
    _ium6b0ir.PublicImage? image,
  }) = _PublicContentImpl;

  factory PublicContent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PublicContent(
      id: jsonSerialization['id'] as int,
      kind: jsonSerialization['kind'] as String,
      slug: jsonSerialization['slug'] as String,
      category: jsonSerialization['category'] as String,
      json: jsonSerialization['json'] as String,
      reviewedAt: jsonSerialization['reviewedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['reviewedAt']),
      publishedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['publishedAt'],
      ),
      image: jsonSerialization['image'] == null
          ? null
          : _i19kjxmt.Protocol().deserialize<_ium6b0ir.PublicImage>(
              jsonSerialization['image'],
            ),
    );
  }

  int id;

  String kind;

  String slug;

  String category;

  String json;

  DateTime? reviewedAt;

  DateTime publishedAt;

  /// The item's image, when it has a published one.
  _ium6b0ir.PublicImage? image;

  /// Returns a shallow copy of this [PublicContent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PublicContent copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    String? json,
    DateTime? reviewedAt = const _is.$UndefinedDateTime(),
    DateTime? publishedAt,
    _ium6b0ir.PublicImage? image = const _UndefinedPublicContent$image(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PublicContent',
      'id': id,
      'kind': kind,
      'slug': slug,
      'category': category,
      'json': json,
      if (reviewedAt != null) 'reviewedAt': reviewedAt?.toJson(),
      'publishedAt': publishedAt.toJson(),
      if (image != null) 'image': image?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PublicContent',
      'id': id,
      'kind': kind,
      'slug': slug,
      'category': category,
      'json': json,
      if (reviewedAt != null) 'reviewedAt': reviewedAt?.toJson(),
      'publishedAt': publishedAt.toJson(),
      if (image != null) 'image': image?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UndefinedPublicContent$image extends _is.UndefinedSentinel
    implements _ium6b0ir.PublicImage {
  const _UndefinedPublicContent$image();
}

class _PublicContentImpl extends PublicContent {
  _PublicContentImpl({
    required int id,
    required String kind,
    required String slug,
    required String category,
    required String json,
    DateTime? reviewedAt,
    required DateTime publishedAt,
    _ium6b0ir.PublicImage? image,
  }) : super._(
         id: id,
         kind: kind,
         slug: slug,
         category: category,
         json: json,
         reviewedAt: reviewedAt,
         publishedAt: publishedAt,
         image: image,
       );

  /// Returns a shallow copy of this [PublicContent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PublicContent copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    String? json,
    DateTime? reviewedAt = const _is.$UndefinedDateTime(),
    DateTime? publishedAt,
    _ium6b0ir.PublicImage? image = const _UndefinedPublicContent$image(),
  }) {
    return PublicContent(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      json: json ?? this.json,
      reviewedAt: reviewedAt is _is.UndefinedSentinel
          ? this.reviewedAt
          : reviewedAt,
      publishedAt: publishedAt ?? this.publishedAt,
      image: image is _is.UndefinedSentinel ? this.image?.copyWith() : image,
    );
  }
}
