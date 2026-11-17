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
import '../stats/stats_group.dart' as _i0pg7yn7;

/// Anonymous aggregate statistics for the admin panel.
abstract class StatsReport
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StatsReport._({
    required this.generatedAt,
    required this.minGroupSize,
    required this.groups,
  });

  factory StatsReport({
    required DateTime generatedAt,
    required int minGroupSize,
    required List<_i0pg7yn7.StatsGroup> groups,
  }) = _StatsReportImpl;

  factory StatsReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return StatsReport(
      generatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      minGroupSize: jsonSerialization['minGroupSize'] as int,
      groups: _i19kjxmt.Protocol().deserialize<List<_i0pg7yn7.StatsGroup>>(
        jsonSerialization['groups'],
      ),
    );
  }

  DateTime generatedAt;

  int minGroupSize;

  List<_i0pg7yn7.StatsGroup> groups;

  /// Returns a shallow copy of this [StatsReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StatsReport copyWith({
    DateTime? generatedAt,
    int? minGroupSize,
    List<_i0pg7yn7.StatsGroup>? groups,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StatsReport',
      'generatedAt': generatedAt.toJson(),
      'minGroupSize': minGroupSize,
      'groups': groups.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StatsReport',
      'generatedAt': generatedAt.toJson(),
      'minGroupSize': minGroupSize,
      'groups': groups.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _StatsReportImpl extends StatsReport {
  _StatsReportImpl({
    required DateTime generatedAt,
    required int minGroupSize,
    required List<_i0pg7yn7.StatsGroup> groups,
  }) : super._(
         generatedAt: generatedAt,
         minGroupSize: minGroupSize,
         groups: groups,
       );

  /// Returns a shallow copy of this [StatsReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StatsReport copyWith({
    DateTime? generatedAt,
    int? minGroupSize,
    List<_i0pg7yn7.StatsGroup>? groups,
  }) {
    return StatsReport(
      generatedAt: generatedAt ?? this.generatedAt,
      minGroupSize: minGroupSize ?? this.minGroupSize,
      groups: groups ?? this.groups.map((e0) => e0.copyWith()).toList(),
    );
  }
}
