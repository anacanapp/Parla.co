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

/// A batch of counts from the app (see UsageRules): keys are
/// "event|target", values how many times. Nothing names the account.
abstract class UsageReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UsageReport._({
    required this.platform,
    required this.counts,
  });

  factory UsageReport({
    required String platform,
    required Map<String, int> counts,
  }) = _UsageReportImpl;

  factory UsageReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return UsageReport(
      platform: jsonSerialization['platform'] as String,
      counts: _id6y4bzp.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['counts'],
      ),
    );
  }

  /// UsagePlatform name.
  String platform;

  Map<String, int> counts;

  /// Returns a shallow copy of this [UsageReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UsageReport copyWith({
    String? platform,
    Map<String, int>? counts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UsageReport',
      'platform': platform,
      'counts': counts.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UsageReport',
      'platform': platform,
      'counts': counts.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _UsageReportImpl extends UsageReport {
  _UsageReportImpl({
    required String platform,
    required Map<String, int> counts,
  }) : super._(
         platform: platform,
         counts: counts,
       );

  /// Returns a shallow copy of this [UsageReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UsageReport copyWith({
    String? platform,
    Map<String, int>? counts,
  }) {
    return UsageReport(
      platform: platform ?? this.platform,
      counts:
          counts ??
          this.counts.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}
