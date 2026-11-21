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

/// An image or video uploaded in the admin panel for content (article
/// covers, recipe photos, expert photos, exercise images and videos). The
/// server re-encodes every upload, so no camera or location metadata (and
/// no sound) is kept, and never stores the original file name. [key] names the object in the media
/// store; it is reachable by the app only while [public] is set, which the
/// server keeps in step with what is published.
abstract class MediaAsset
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MediaAsset._({
    this.id,
    required this.key,
    String? mediaType,
    this.durationMs,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.bytes,
    required this.license,
    this.source,
    required this.altJson,
    required this.public,
    required this.createdBy,
    required this.createdAt,
  }) : mediaType = mediaType ?? 'image';

  factory MediaAsset({
    int? id,
    required String key,
    String? mediaType,
    int? durationMs,
    required int pixelWidth,
    required int pixelHeight,
    required int bytes,
    required String license,
    String? source,
    required String altJson,
    required bool public,
    required _isc.UuidValue createdBy,
    required DateTime createdAt,
  }) = _MediaAssetImpl;

  factory MediaAsset.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaAsset(
      id: jsonSerialization['id'] as int?,
      key: jsonSerialization['key'] as String,
      mediaType: jsonSerialization['mediaType'] as String?,
      durationMs: jsonSerialization['durationMs'] as int?,
      pixelWidth: jsonSerialization['pixelWidth'] as int,
      pixelHeight: jsonSerialization['pixelHeight'] as int,
      bytes: jsonSerialization['bytes'] as int,
      license: jsonSerialization['license'] as String,
      source: jsonSerialization['source'] as String?,
      altJson: jsonSerialization['altJson'] as String,
      public: _isc.BoolJsonExtension.fromJson(jsonSerialization['public']),
      createdBy: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String key;

  /// `image` (a JPEG) or `video` (an H.264 MP4 without sound).
  String mediaType;

  /// A video's length in milliseconds.
  int? durationMs;

  int pixelWidth;

  int pixelHeight;

  int bytes;

  /// Licence or permission for the image (required), e.g. "Unsplash
  /// licence" or "own photo, consent on file".
  String license;

  /// Where it came from (a link or the photographer), optional.
  String? source;

  /// Text for screen readers in az, ru and en, as JSON.
  String altJson;

  bool public;

  _isc.UuidValue createdBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [MediaAsset]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MediaAsset copyWith({
    int? id,
    String? key,
    String? mediaType,
    int? durationMs,
    int? pixelWidth,
    int? pixelHeight,
    int? bytes,
    String? license,
    String? source,
    String? altJson,
    bool? public,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MediaAsset',
      if (id != null) 'id': id,
      'key': key,
      'mediaType': mediaType,
      if (durationMs != null) 'durationMs': durationMs,
      'pixelWidth': pixelWidth,
      'pixelHeight': pixelHeight,
      'bytes': bytes,
      'license': license,
      if (source != null) 'source': source,
      'altJson': altJson,
      'public': public,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MediaAsset',
      if (id != null) 'id': id,
      'key': key,
      'mediaType': mediaType,
      if (durationMs != null) 'durationMs': durationMs,
      'pixelWidth': pixelWidth,
      'pixelHeight': pixelHeight,
      'bytes': bytes,
      'license': license,
      if (source != null) 'source': source,
      'altJson': altJson,
      'public': public,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MediaAssetImpl extends MediaAsset {
  _MediaAssetImpl({
    int? id,
    required String key,
    String? mediaType,
    int? durationMs,
    required int pixelWidth,
    required int pixelHeight,
    required int bytes,
    required String license,
    String? source,
    required String altJson,
    required bool public,
    required _isc.UuidValue createdBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         key: key,
         mediaType: mediaType,
         durationMs: durationMs,
         pixelWidth: pixelWidth,
         pixelHeight: pixelHeight,
         bytes: bytes,
         license: license,
         source: source,
         altJson: altJson,
         public: public,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MediaAsset]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MediaAsset copyWith({
    Object? id = _Undefined,
    String? key,
    String? mediaType,
    Object? durationMs = _Undefined,
    int? pixelWidth,
    int? pixelHeight,
    int? bytes,
    String? license,
    Object? source = _Undefined,
    String? altJson,
    bool? public,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  }) {
    return MediaAsset(
      id: id is int? ? id : this.id,
      key: key ?? this.key,
      mediaType: mediaType ?? this.mediaType,
      durationMs: durationMs is int? ? durationMs : this.durationMs,
      pixelWidth: pixelWidth ?? this.pixelWidth,
      pixelHeight: pixelHeight ?? this.pixelHeight,
      bytes: bytes ?? this.bytes,
      license: license ?? this.license,
      source: source is String? ? source : this.source,
      altJson: altJson ?? this.altJson,
      public: public ?? this.public,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
