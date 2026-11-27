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

/// Website totals: how often [metric] with [target] happened on [day]
/// (UTC). Only counts: no row names a visitor, and no cookie, IP address
/// or identifier is kept (owner, 2026-11-27). Kept for
/// UsageRules.keepMonths.
abstract class SiteStatDaily
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SiteStatDaily._({
    this.id,
    required this.day,
    required this.metric,
    required this.target,
    required this.times,
  });

  factory SiteStatDaily({
    int? id,
    required String day,
    required String metric,
    required String target,
    required int times,
  }) = _SiteStatDailyImpl;

  factory SiteStatDaily.fromJson(Map<String, dynamic> jsonSerialization) {
    return SiteStatDaily(
      id: jsonSerialization['id'] as int?,
      day: jsonSerialization['day'] as String,
      metric: jsonSerialization['metric'] as String,
      target: jsonSerialization['target'] as String,
      times: jsonSerialization['times'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String day;

  /// SiteMetric name: view, visitors, language, referrer, campaign,
  /// device, browser, os, click, depth.
  String metric;

  /// The page, language, referring site, campaign, device, browser,
  /// system, button or "page|percent" (see SiteStats).
  String target;

  int times;

  /// Returns a shallow copy of this [SiteStatDaily]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SiteStatDaily copyWith({
    int? id,
    String? day,
    String? metric,
    String? target,
    int? times,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SiteStatDaily',
      if (id != null) 'id': id,
      'day': day,
      'metric': metric,
      'target': target,
      'times': times,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SiteStatDaily',
      if (id != null) 'id': id,
      'day': day,
      'metric': metric,
      'target': target,
      'times': times,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SiteStatDailyImpl extends SiteStatDaily {
  _SiteStatDailyImpl({
    int? id,
    required String day,
    required String metric,
    required String target,
    required int times,
  }) : super._(
         id: id,
         day: day,
         metric: metric,
         target: target,
         times: times,
       );

  /// Returns a shallow copy of this [SiteStatDaily]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SiteStatDaily copyWith({
    Object? id = _Undefined,
    String? day,
    String? metric,
    String? target,
    int? times,
  }) {
    return SiteStatDaily(
      id: id is int? ? id : this.id,
      day: day ?? this.day,
      metric: metric ?? this.metric,
      target: target ?? this.target,
      times: times ?? this.times,
    );
  }
}
