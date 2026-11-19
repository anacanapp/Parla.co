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
import '../stats/stats_count.dart' as _i62qlqsa;
import '../stats/stats_group.dart' as _i0pg7yn7;

/// The admin dashboard: headline numbers, daily series and breakdowns for
/// the last [days] days. Daily series and headline numbers are totals;
/// in breakdowns (country, platform, tool, content) every count under
/// [minGroupSize] is null ("<10").
abstract class DashboardReport
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DashboardReport._({
    required this.generatedAt,
    required this.minGroupSize,
    required this.days,
    required this.kpis,
    required this.groups,
  });

  factory DashboardReport({
    required DateTime generatedAt,
    required int minGroupSize,
    required int days,
    required List<_i62qlqsa.StatsCount> kpis,
    required List<_i0pg7yn7.StatsGroup> groups,
  }) = _DashboardReportImpl;

  factory DashboardReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return DashboardReport(
      generatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      minGroupSize: jsonSerialization['minGroupSize'] as int,
      days: jsonSerialization['days'] as int,
      kpis: _i19kjxmt.Protocol().deserialize<List<_i62qlqsa.StatsCount>>(
        jsonSerialization['kpis'],
      ),
      groups: _i19kjxmt.Protocol().deserialize<List<_i0pg7yn7.StatsGroup>>(
        jsonSerialization['groups'],
      ),
    );
  }

  DateTime generatedAt;

  int minGroupSize;

  int days;

  /// Headline numbers (label = metric id).
  List<_i62qlqsa.StatsCount> kpis;

  /// Daily series and breakdowns (labels are days or ids).
  List<_i0pg7yn7.StatsGroup> groups;

  /// Returns a shallow copy of this [DashboardReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DashboardReport copyWith({
    DateTime? generatedAt,
    int? minGroupSize,
    int? days,
    List<_i62qlqsa.StatsCount>? kpis,
    List<_i0pg7yn7.StatsGroup>? groups,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DashboardReport',
      'generatedAt': generatedAt.toJson(),
      'minGroupSize': minGroupSize,
      'days': days,
      'kpis': kpis.toJson(valueToJson: (v) => v.toJson()),
      'groups': groups.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DashboardReport',
      'generatedAt': generatedAt.toJson(),
      'minGroupSize': minGroupSize,
      'days': days,
      'kpis': kpis.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'groups': groups.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DashboardReportImpl extends DashboardReport {
  _DashboardReportImpl({
    required DateTime generatedAt,
    required int minGroupSize,
    required int days,
    required List<_i62qlqsa.StatsCount> kpis,
    required List<_i0pg7yn7.StatsGroup> groups,
  }) : super._(
         generatedAt: generatedAt,
         minGroupSize: minGroupSize,
         days: days,
         kpis: kpis,
         groups: groups,
       );

  /// Returns a shallow copy of this [DashboardReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DashboardReport copyWith({
    DateTime? generatedAt,
    int? minGroupSize,
    int? days,
    List<_i62qlqsa.StatsCount>? kpis,
    List<_i0pg7yn7.StatsGroup>? groups,
  }) {
    return DashboardReport(
      generatedAt: generatedAt ?? this.generatedAt,
      minGroupSize: minGroupSize ?? this.minGroupSize,
      days: days ?? this.days,
      kpis: kpis ?? this.kpis.map((e0) => e0.copyWith()).toList(),
      groups: groups ?? this.groups.map((e0) => e0.copyWith()).toList(),
    );
  }
}
