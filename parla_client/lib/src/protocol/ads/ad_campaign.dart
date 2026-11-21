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

/// An advertiser's paid campaign. Its banners are content items of kind
/// banner whose JSON names it (`campaign`); the server writes the
/// advertiser's name into their "Ad · brand" label.
abstract class AdCampaign
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdCampaign._({
    this.id,
    required this.advertiserId,
    required this.title,
    required this.startsOn,
    required this.endsOn,
    this.priceNote,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdCampaign({
    int? id,
    required int advertiserId,
    required String title,
    required String startsOn,
    required String endsOn,
    String? priceNote,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AdCampaignImpl;

  factory AdCampaign.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdCampaign(
      id: jsonSerialization['id'] as int?,
      advertiserId: jsonSerialization['advertiserId'] as int,
      title: jsonSerialization['title'] as String,
      startsOn: jsonSerialization['startsOn'] as String,
      endsOn: jsonSerialization['endsOn'] as String,
      priceNote: jsonSerialization['priceNote'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int advertiserId;

  String title;

  /// YYYY-MM-DD; the campaign's banners must run inside these dates.
  String startsOn;

  String endsOn;

  /// Price or budget as agreed (free text for the team).
  String? priceNote;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AdCampaign]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdCampaign copyWith({
    int? id,
    int? advertiserId,
    String? title,
    String? startsOn,
    String? endsOn,
    String? priceNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdCampaign',
      if (id != null) 'id': id,
      'advertiserId': advertiserId,
      'title': title,
      'startsOn': startsOn,
      'endsOn': endsOn,
      if (priceNote != null) 'priceNote': priceNote,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdCampaign',
      if (id != null) 'id': id,
      'advertiserId': advertiserId,
      'title': title,
      'startsOn': startsOn,
      'endsOn': endsOn,
      if (priceNote != null) 'priceNote': priceNote,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdCampaignImpl extends AdCampaign {
  _AdCampaignImpl({
    int? id,
    required int advertiserId,
    required String title,
    required String startsOn,
    required String endsOn,
    String? priceNote,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         advertiserId: advertiserId,
         title: title,
         startsOn: startsOn,
         endsOn: endsOn,
         priceNote: priceNote,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AdCampaign]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdCampaign copyWith({
    Object? id = _Undefined,
    int? advertiserId,
    String? title,
    String? startsOn,
    String? endsOn,
    Object? priceNote = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdCampaign(
      id: id is int? ? id : this.id,
      advertiserId: advertiserId ?? this.advertiserId,
      title: title ?? this.title,
      startsOn: startsOn ?? this.startsOn,
      endsOn: endsOn ?? this.endsOn,
      priceNote: priceNote is String? ? priceNote : this.priceNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
