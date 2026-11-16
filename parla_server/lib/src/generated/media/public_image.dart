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

/// A published image as the app reads it.
abstract class PublicImage
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PublicImage._({
    required this.url,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.altJson,
  });

  factory PublicImage({
    required String url,
    required int pixelWidth,
    required int pixelHeight,
    required String altJson,
  }) = _PublicImageImpl;

  factory PublicImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return PublicImage(
      url: jsonSerialization['url'] as String,
      pixelWidth: jsonSerialization['pixelWidth'] as int,
      pixelHeight: jsonSerialization['pixelHeight'] as int,
      altJson: jsonSerialization['altJson'] as String,
    );
  }

  String url;

  int pixelWidth;

  int pixelHeight;

  String altJson;

  /// Returns a shallow copy of this [PublicImage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PublicImage copyWith({
    String? url,
    int? pixelWidth,
    int? pixelHeight,
    String? altJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PublicImage',
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

class _PublicImageImpl extends PublicImage {
  _PublicImageImpl({
    required String url,
    required int pixelWidth,
    required int pixelHeight,
    required String altJson,
  }) : super._(
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
    String? url,
    int? pixelWidth,
    int? pixelHeight,
    String? altJson,
  }) {
    return PublicImage(
      url: url ?? this.url,
      pixelWidth: pixelWidth ?? this.pixelWidth,
      pixelHeight: pixelHeight ?? this.pixelHeight,
      altJson: altJson ?? this.altJson,
    );
  }
}
