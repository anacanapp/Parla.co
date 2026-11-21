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
import '../ads/ad_report_row.dart' as _ir7f614l;

/// Views and taps of a campaign's banners, as totals over all users who
/// gave the analytics consent. A count under the minimum group size is
/// `null` (shown as "<10"); nothing per user exists.
abstract class AdReport
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdReport._({
    required this.campaignId,
    required this.campaign,
    required this.advertiser,
    required this.startsOn,
    required this.endsOn,
    required this.countedTo,
    this.views,
    this.taps,
    required this.days,
    required this.banners,
  });

  factory AdReport({
    required int campaignId,
    required String campaign,
    required String advertiser,
    required String startsOn,
    required String endsOn,
    required String countedTo,
    int? views,
    int? taps,
    required List<_ir7f614l.AdReportRow> days,
    required List<_ir7f614l.AdReportRow> banners,
  }) = _AdReportImpl;

  factory AdReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdReport(
      campaignId: jsonSerialization['campaignId'] as int,
      campaign: jsonSerialization['campaign'] as String,
      advertiser: jsonSerialization['advertiser'] as String,
      startsOn: jsonSerialization['startsOn'] as String,
      endsOn: jsonSerialization['endsOn'] as String,
      countedTo: jsonSerialization['countedTo'] as String,
      views: jsonSerialization['views'] as int?,
      taps: jsonSerialization['taps'] as int?,
      days: _i19kjxmt.Protocol().deserialize<List<_ir7f614l.AdReportRow>>(
        jsonSerialization['days'],
      ),
      banners: _i19kjxmt.Protocol().deserialize<List<_ir7f614l.AdReportRow>>(
        jsonSerialization['banners'],
      ),
    );
  }

  int campaignId;

  String campaign;

  String advertiser;

  String startsOn;

  String endsOn;

  /// The last day counted (today while the campaign runs).
  String countedTo;

  int? views;

  int? taps;

  List<_ir7f614l.AdReportRow> days;

  List<_ir7f614l.AdReportRow> banners;

  /// Returns a shallow copy of this [AdReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdReport copyWith({
    int? campaignId,
    String? campaign,
    String? advertiser,
    String? startsOn,
    String? endsOn,
    String? countedTo,
    int? views,
    int? taps,
    List<_ir7f614l.AdReportRow>? days,
    List<_ir7f614l.AdReportRow>? banners,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdReport',
      'campaignId': campaignId,
      'campaign': campaign,
      'advertiser': advertiser,
      'startsOn': startsOn,
      'endsOn': endsOn,
      'countedTo': countedTo,
      if (views != null) 'views': views,
      if (taps != null) 'taps': taps,
      'days': days.toJson(valueToJson: (v) => v.toJson()),
      'banners': banners.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdReport',
      'campaignId': campaignId,
      'campaign': campaign,
      'advertiser': advertiser,
      'startsOn': startsOn,
      'endsOn': endsOn,
      'countedTo': countedTo,
      if (views != null) 'views': views,
      if (taps != null) 'taps': taps,
      'days': days.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'banners': banners.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdReportImpl extends AdReport {
  _AdReportImpl({
    required int campaignId,
    required String campaign,
    required String advertiser,
    required String startsOn,
    required String endsOn,
    required String countedTo,
    int? views,
    int? taps,
    required List<_ir7f614l.AdReportRow> days,
    required List<_ir7f614l.AdReportRow> banners,
  }) : super._(
         campaignId: campaignId,
         campaign: campaign,
         advertiser: advertiser,
         startsOn: startsOn,
         endsOn: endsOn,
         countedTo: countedTo,
         views: views,
         taps: taps,
         days: days,
         banners: banners,
       );

  /// Returns a shallow copy of this [AdReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdReport copyWith({
    int? campaignId,
    String? campaign,
    String? advertiser,
    String? startsOn,
    String? endsOn,
    String? countedTo,
    Object? views = _Undefined,
    Object? taps = _Undefined,
    List<_ir7f614l.AdReportRow>? days,
    List<_ir7f614l.AdReportRow>? banners,
  }) {
    return AdReport(
      campaignId: campaignId ?? this.campaignId,
      campaign: campaign ?? this.campaign,
      advertiser: advertiser ?? this.advertiser,
      startsOn: startsOn ?? this.startsOn,
      endsOn: endsOn ?? this.endsOn,
      countedTo: countedTo ?? this.countedTo,
      views: views is int? ? views : this.views,
      taps: taps is int? ? taps : this.taps,
      days: days ?? this.days.map((e0) => e0.copyWith()).toList(),
      banners: banners ?? this.banners.map((e0) => e0.copyWith()).toList(),
    );
  }
}
