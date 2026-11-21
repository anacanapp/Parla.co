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
import 'package:parla_client/src/protocol/protocol.dart' as _id6y4bzp;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../media/public_image.dart' as _ium6b0ir;

/// A published content item as the app reads it.
abstract class PublicContent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PublicContent._({
    required this.id,
    required this.kind,
    required this.slug,
    required this.category,
    required this.json,
    this.reviewedAt,
    required this.publishedAt,
    this.image,
    this.video,
    this.inlineImages,
    required this.hidden,
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
    _ium6b0ir.PublicImage? video,
    List<_ium6b0ir.PublicImage>? inlineImages,
    required bool hidden,
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
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['reviewedAt'],
            ),
      publishedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['publishedAt'],
      ),
      image: jsonSerialization['image'] == null
          ? null
          : _id6y4bzp.Protocol().deserialize<_ium6b0ir.PublicImage>(
              jsonSerialization['image'],
            ),
      video: jsonSerialization['video'] == null
          ? null
          : _id6y4bzp.Protocol().deserialize<_ium6b0ir.PublicImage>(
              jsonSerialization['video'],
            ),
      inlineImages: jsonSerialization['inlineImages'] == null
          ? null
          : _id6y4bzp.Protocol().deserialize<List<_ium6b0ir.PublicImage>>(
              jsonSerialization['inlineImages'],
            ),
      hidden: _isc.BoolJsonExtension.fromJson(jsonSerialization['hidden']),
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

  /// An exercise's published video (an MP4 without sound).
  _ium6b0ir.PublicImage? video;

  /// Published images used inside an article's body.
  List<_ium6b0ir.PublicImage>? inlineImages;

  /// Catalogue items the app must not show.
  bool hidden;

  /// Returns a shallow copy of this [PublicContent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PublicContent copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    String? json,
    DateTime? reviewedAt = const _isc.$UndefinedDateTime(),
    DateTime? publishedAt,
    _ium6b0ir.PublicImage? image = const _UndefinedPublicContent$image(),
    _ium6b0ir.PublicImage? video = const _UndefinedPublicContent$image(),
    List<_ium6b0ir.PublicImage>? inlineImages =
        const _isc.$UndefinedList<_ium6b0ir.PublicImage>(),
    bool? hidden,
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
      if (video != null) 'video': video?.toJson(),
      if (inlineImages != null)
        'inlineImages': inlineImages?.toJson(valueToJson: (v) => v.toJson()),
      'hidden': hidden,
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
      if (video != null) 'video': video?.toJsonForProtocol(),
      if (inlineImages != null)
        'inlineImages': inlineImages?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'hidden': hidden,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _UndefinedPublicContent$image extends _isc.UndefinedSentinel
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
    _ium6b0ir.PublicImage? video,
    List<_ium6b0ir.PublicImage>? inlineImages,
    required bool hidden,
  }) : super._(
         id: id,
         kind: kind,
         slug: slug,
         category: category,
         json: json,
         reviewedAt: reviewedAt,
         publishedAt: publishedAt,
         image: image,
         video: video,
         inlineImages: inlineImages,
         hidden: hidden,
       );

  /// Returns a shallow copy of this [PublicContent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PublicContent copyWith({
    int? id,
    String? kind,
    String? slug,
    String? category,
    String? json,
    DateTime? reviewedAt = const _isc.$UndefinedDateTime(),
    DateTime? publishedAt,
    _ium6b0ir.PublicImage? image = const _UndefinedPublicContent$image(),
    _ium6b0ir.PublicImage? video = const _UndefinedPublicContent$image(),
    List<_ium6b0ir.PublicImage>? inlineImages =
        const _isc.$UndefinedList<_ium6b0ir.PublicImage>(),
    bool? hidden,
  }) {
    return PublicContent(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      json: json ?? this.json,
      reviewedAt: reviewedAt is _isc.UndefinedSentinel
          ? this.reviewedAt
          : reviewedAt,
      publishedAt: publishedAt ?? this.publishedAt,
      image: image is _isc.UndefinedSentinel ? this.image?.copyWith() : image,
      video: video is _isc.UndefinedSentinel ? this.video?.copyWith() : video,
      inlineImages: inlineImages is _isc.UndefinedSentinel
          ? this.inlineImages?.map((e0) => e0.copyWith()).toList()
          : inlineImages,
      hidden: hidden ?? this.hidden,
    );
  }
}
