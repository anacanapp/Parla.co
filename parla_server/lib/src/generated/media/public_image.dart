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

/// A published image (or an exercise's video) as the app reads it.
abstract class PublicImage
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PublicImage._({
    this.id,
    required this.url,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.altJson,
  });

  factory PublicImage({
    int? id,
    required String url,
    required int pixelWidth,
    required int pixelHeight,
    required String altJson,
  }) = _PublicImageImpl;

  factory PublicImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return PublicImage(
      id: jsonSerialization['id'] as int?,
      url: jsonSerialization['url'] as String,
      pixelWidth: jsonSerialization['pixelWidth'] as int,
      pixelHeight: jsonSerialization['pixelHeight'] as int,
      altJson: jsonSerialization['altJson'] as String,
    );
  }

  /// The image's id (`media:<id>` inside article bodies).
  int? id;

  String url;

  int pixelWidth;

  int pixelHeight;

  String altJson;

  /// Returns a shallow copy of this [PublicImage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PublicImage copyWith({
    int? id,
    String? url,
    int? pixelWidth,
    int? pixelHeight,
    String? altJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PublicImage',
      if (id != null) 'id': id,
      'url': url,
      'pixelWidth': pixelWidth,
      'pixelHeight': pixelHeight,
      'altJson': altJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PublicImage',
      if (id != null) 'id': id,
      'url': url,
      'pixelWidth': pixelWidth,
      'pixelHeight': pixelHeight,
      'altJson': altJson,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PublicImageImpl extends PublicImage {
  _PublicImageImpl({
    int? id,
    required String url,
    required int pixelWidth,
    required int pixelHeight,
    required String altJson,
  }) : super._(
         id: id,
         url: url,
         pixelWidth: pixelWidth,
         pixelHeight: pixelHeight,
         altJson: altJson,
       );

  /// Returns a shallow copy of this [PublicImage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PublicImage copyWith({
    Object? id = _Undefined,
    String? url,
    int? pixelWidth,
    int? pixelHeight,
    String? altJson,
  }) {
    return PublicImage(
      id: id is int? ? id : this.id,
      url: url ?? this.url,
      pixelWidth: pixelWidth ?? this.pixelWidth,
      pixelHeight: pixelHeight ?? this.pixelHeight,
      altJson: altJson ?? this.altJson,
    );
  }
}
