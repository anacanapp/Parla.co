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

/// An image or video as the admin panel lists it.
abstract class MediaAdminItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MediaAdminItem._({
    required this.id,
    required this.mediaType,
    this.durationMs,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.bytes,
    required this.license,
    this.source,
    required this.altJson,
    required this.public,
    required this.createdAt,
  });

  factory MediaAdminItem({
    required int id,
    required String mediaType,
    int? durationMs,
    required int pixelWidth,
    required int pixelHeight,
    required int bytes,
    required String license,
    String? source,
    required String altJson,
    required bool public,
    required DateTime createdAt,
  }) = _MediaAdminItemImpl;

  factory MediaAdminItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaAdminItem(
      id: jsonSerialization['id'] as int,
      mediaType: jsonSerialization['mediaType'] as String,
      durationMs: jsonSerialization['durationMs'] as int?,
      pixelWidth: jsonSerialization['pixelWidth'] as int,
      pixelHeight: jsonSerialization['pixelHeight'] as int,
      bytes: jsonSerialization['bytes'] as int,
      license: jsonSerialization['license'] as String,
      source: jsonSerialization['source'] as String?,
      altJson: jsonSerialization['altJson'] as String,
      public: _isc.BoolJsonExtension.fromJson(jsonSerialization['public']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  /// `image` or `video`.
  String mediaType;

  int? durationMs;

  int pixelWidth;

  int pixelHeight;

  int bytes;

  String license;

  String? source;

  String altJson;

  bool public;

  DateTime createdAt;

  /// Returns a shallow copy of this [MediaAdminItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MediaAdminItem copyWith({
    int? id,
    String? mediaType,
    int? durationMs,
    int? pixelWidth,
    int? pixelHeight,
    int? bytes,
    String? license,
    String? source,
    String? altJson,
    bool? public,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MediaAdminItem',
      'id': id,
      'mediaType': mediaType,
      if (durationMs != null) 'durationMs': durationMs,
      'pixelWidth': pixelWidth,
      'pixelHeight': pixelHeight,
      'bytes': bytes,
      'license': license,
      if (source != null) 'source': source,
      'altJson': altJson,
      'public': public,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MediaAdminItem',
      'id': id,
      'mediaType': mediaType,
      if (durationMs != null) 'durationMs': durationMs,
      'pixelWidth': pixelWidth,
      'pixelHeight': pixelHeight,
      'bytes': bytes,
      'license': license,
      if (source != null) 'source': source,
      'altJson': altJson,
      'public': public,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MediaAdminItemImpl extends MediaAdminItem {
  _MediaAdminItemImpl({
    required int id,
    required String mediaType,
    int? durationMs,
    required int pixelWidth,
    required int pixelHeight,
    required int bytes,
    required String license,
    String? source,
    required String altJson,
    required bool public,
    required DateTime createdAt,
  }) : super._(
         id: id,
         mediaType: mediaType,
         durationMs: durationMs,
         pixelWidth: pixelWidth,
         pixelHeight: pixelHeight,
         bytes: bytes,
         license: license,
         source: source,
         altJson: altJson,
         public: public,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MediaAdminItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MediaAdminItem copyWith({
    int? id,
    String? mediaType,
    Object? durationMs = _Undefined,
    int? pixelWidth,
    int? pixelHeight,
    int? bytes,
    String? license,
    Object? source = _Undefined,
    String? altJson,
    bool? public,
    DateTime? createdAt,
  }) {
    return MediaAdminItem(
      id: id ?? this.id,
      mediaType: mediaType ?? this.mediaType,
      durationMs: durationMs is int? ? durationMs : this.durationMs,
      pixelWidth: pixelWidth ?? this.pixelWidth,
      pixelHeight: pixelHeight ?? this.pixelHeight,
      bytes: bytes ?? this.bytes,
      license: license ?? this.license,
      source: source is String? ? source : this.source,
      altJson: altJson ?? this.altJson,
      public: public ?? this.public,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
