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

/// A campaign as the banner editor offers it.
abstract class AdCampaignOption
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdCampaignOption._({
    required this.id,
    required this.title,
    required this.advertiser,
    required this.startsOn,
    required this.endsOn,
  });

  factory AdCampaignOption({
    required int id,
    required String title,
    required String advertiser,
    required String startsOn,
    required String endsOn,
  }) = _AdCampaignOptionImpl;

  factory AdCampaignOption.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdCampaignOption(
      id: jsonSerialization['id'] as int,
      title: jsonSerialization['title'] as String,
      advertiser: jsonSerialization['advertiser'] as String,
      startsOn: jsonSerialization['startsOn'] as String,
      endsOn: jsonSerialization['endsOn'] as String,
    );
  }

  int id;

  String title;

  String advertiser;

  String startsOn;

  String endsOn;

  /// Returns a shallow copy of this [AdCampaignOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdCampaignOption copyWith({
    int? id,
    String? title,
    String? advertiser,
    String? startsOn,
    String? endsOn,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdCampaignOption',
      'id': id,
      'title': title,
      'advertiser': advertiser,
      'startsOn': startsOn,
      'endsOn': endsOn,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdCampaignOption',
      'id': id,
      'title': title,
      'advertiser': advertiser,
      'startsOn': startsOn,
      'endsOn': endsOn,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AdCampaignOptionImpl extends AdCampaignOption {
  _AdCampaignOptionImpl({
    required int id,
    required String title,
    required String advertiser,
    required String startsOn,
    required String endsOn,
  }) : super._(
         id: id,
         title: title,
         advertiser: advertiser,
         startsOn: startsOn,
         endsOn: endsOn,
       );

  /// Returns a shallow copy of this [AdCampaignOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdCampaignOption copyWith({
    int? id,
    String? title,
    String? advertiser,
    String? startsOn,
    String? endsOn,
  }) {
    return AdCampaignOption(
      id: id ?? this.id,
      title: title ?? this.title,
      advertiser: advertiser ?? this.advertiser,
      startsOn: startsOn ?? this.startsOn,
      endsOn: endsOn ?? this.endsOn,
    );
  }
}
