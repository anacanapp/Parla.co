import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../staff/staff_guard.dart';
import 'audit.dart';

/// The audit log, read-only, for admins (checklist AUD-1..AUD-4).
///
/// The rows hold ids only; nothing here resolves an id to an email or a
/// name. There is no update, delete or export: the table is append-only
/// and the panel only shows it. Opening the log (its first page) is itself
/// audited as `audit.viewed`.
class AuditAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Rows per page.
  static const pageSize = 100;

  /// The newest entries first. [actionPrefix] matches the start of the
  /// action (`content.` or `content.published`); [from] and [to] bound
  /// `createdAt` (from inclusive, to exclusive); [beforeId] continues
  /// after the last row of the previous page.
  Future<List<AuditLogEntry>> list(
    Session session,
    String? actionPrefix,
    String? actorRole,
    String? objectType,
    String? objectId,
    DateTime? from,
    DateTime? to,
    int? beforeId,
  ) async {
    final admin = await requireStaff(session, roles: {StaffRole.admin});
    final prefix = actionPrefix?.trim() ?? '';
    final role = actorRole?.trim() ?? '';
    final type = objectType?.trim() ?? '';
    final object = objectId?.trim() ?? '';
    if (prefix.length > 64 ||
        role.length > 32 ||
        type.length > 64 ||
        object.length > 128 ||
        !RegExp(r'^[a-z_.]*$').hasMatch(prefix)) {
      throw ParlaException(code: AuditErrors.invalidFilter);
    }
    final rows = await AuditLogEntry.db.find(
      session,
      where: (t) {
        Expression e = Constant.bool(true);
        if (prefix.isNotEmpty) {
          e &= t.action.like('${prefix.replaceAll('_', r'\_')}%');
        }
        if (role.isNotEmpty) e &= t.actorRole.equals(role);
        if (type.isNotEmpty) e &= t.objectType.equals(type);
        if (object.isNotEmpty) e &= t.objectId.equals(object);
        if (from != null) e &= t.createdAt >= from.toUtc();
        if (to != null) e &= t.createdAt < to.toUtc();
        if (beforeId != null) e &= t.id < beforeId;
        return e;
      },
      orderByList: (t) => [t.id.desc()],
      limit: pageSize,
    );
    if (beforeId == null) {
      await writeAudit(
        session,
        actorId: admin.authUserId,
        actorRole: AuditActor.staff,
        action: 'audit.viewed',
        objectType: 'audit_log',
      );
    }
    return rows;
  }
}

/// Error codes of the audit view.
abstract final class AuditErrors {
  static const invalidFilter = 'audit.invalid_filter';
}
