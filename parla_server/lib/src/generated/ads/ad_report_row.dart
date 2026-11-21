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

/// One line of an AdReport: a day (YYYY-MM-DD) or a banner (its title).
abstract class AdReportRow
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdReportRow._({
    required this.label,
    this.views,
    this.taps,
  });

  factory AdReportRow({
    required String label,
    int? views,
    int? taps,
  }) = _AdReportRowImpl;

  factory AdReportRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdReportRow(
      label: jsonSerialization['label'] as String,
      views: jsonSerialization['views'] as int?,
      taps: jsonSerialization['taps'] as int?,
    );
  }

  String label;

  int? views;

  int? taps;

  /// Returns a shallow copy of this [AdReportRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdReportRow copyWith({
    String? label,
    int? views,
    int? taps,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdReportRow',
      'label': label,
      if (views != null) 'views': views,
      if (taps != null) 'taps': taps,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdReportRow',
      'label': label,
      if (views != null) 'views': views,
      if (taps != null) 'taps': taps,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdReportRowImpl extends AdReportRow {
  _AdReportRowImpl({
    required String label,
    int? views,
    int? taps,
  }) : super._(
         label: label,
         views: views,
         taps: taps,
       );

  /// Returns a shallow copy of this [AdReportRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdReportRow copyWith({
    String? label,
    Object? views = _Undefined,
    Object? taps = _Undefined,
  }) {
    return AdReportRow(
      label: label ?? this.label,
      views: views is int? ? views : this.views,
      taps: taps is int? ? taps : this.taps,
    );
  }
}
