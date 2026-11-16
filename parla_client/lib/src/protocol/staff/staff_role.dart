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

/// What a staff member may do in the admin panel.
/// admin: everything, including staff accounts. editor: writes content.
/// expert: reviews and approves content in their field.
enum StaffRole implements _isc.SerializableModel {
  admin,
  editor,
  expert;

  static StaffRole fromJson(String name) {
    switch (name) {
      case 'admin':
        return StaffRole.admin;
      case 'editor':
        return StaffRole.editor;
      case 'expert':
        return StaffRole.expert;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "StaffRole"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
