import 'dart:async';

import 'package:flutter/foundation.dart';

import 'api/admin_api.dart';

/// Where the signed-in person is on the way into the panel.
enum AdminStage { signedOut, notStaff, ready }

/// The panel's view of the signed-in staff member.
class StaffState extends ChangeNotifier {
  StaffState(this.api) {
    api.authChanges.addListener(refresh);
  }

  final AdminApi api;
  StaffMe? _me;
  bool _loaded = false;
  Timer? _expiry;

  StaffMe? get me => _me;
  bool get loaded => _loaded;

  /// Why the panel went back to the sign-in page, if it did on its own.
  String? notice;

  AdminStage get stage {
    if (!api.isSignedIn) return AdminStage.signedOut;
    final me = _me;
    if (me == null) return AdminStage.notStaff;
    return AdminStage.ready;
  }

  bool get isAdmin => _me?.role == StaffRole.admin;

  Future<void> refresh() async {
    StaffMe? me;
    if (api.isSignedIn) {
      try {
        me = await api.me();
      } on AdminError catch (e) {
        if (e.code == 'staff.sign_in_again') {
          notice = _expired;
          notifyListeners();
        }
        me = null;
      } on Object {
        me = null;
      }
    }
    _set(me);
    _loaded = true;
    notifyListeners();
  }

  void update(StaffMe me) {
    _set(me);
    notifyListeners();
  }

  static const _expired =
      'Təhlükəsizlik üçün 12 saatdan bir şifrə ilə yenidən daxil olun.';

  /// Keeps [me] and signs out by itself when the sign-in runs out.
  void _set(StaffMe? me) {
    _me = me;
    _expiry?.cancel();
    _expiry = null;
    if (me == null) return;
    notice = null;
    final left = me.signInExpiresAt.difference(DateTime.now().toUtc());
    _expiry = Timer(left.isNegative ? Duration.zero : left, () async {
      notice = _expired;
      await signOut();
    });
  }

  Future<void> signOut() async {
    await api.signOut();
    _set(null);
    notifyListeners();
  }

  @override
  void dispose() {
    _expiry?.cancel();
    api.authChanges.removeListener(refresh);
    super.dispose();
  }
}
