import 'package:flutter/foundation.dart';

import 'api/admin_api.dart';

/// Where the signed-in person is on the way into the panel.
enum AdminStage { signedOut, notStaff, setupTotp, verifyTotp, ready }

/// The panel's view of the signed-in staff member.
class StaffState extends ChangeNotifier {
  StaffState(this.api) {
    api.authChanges.addListener(refresh);
  }

  final AdminApi api;
  StaffMe? _me;
  bool _loaded = false;

  StaffMe? get me => _me;
  bool get loaded => _loaded;

  AdminStage get stage {
    if (!api.isSignedIn) return AdminStage.signedOut;
    final me = _me;
    if (me == null) return AdminStage.notStaff;
    if (!me.totpEnrolled) return AdminStage.setupTotp;
    if (!me.verified) return AdminStage.verifyTotp;
    return AdminStage.ready;
  }

  bool get isAdmin => _me?.role == StaffRole.admin;

  Future<void> refresh() async {
    StaffMe? me;
    if (api.isSignedIn) {
      try {
        me = await api.me();
      } on Object {
        me = null;
      }
    }
    _me = me;
    _loaded = true;
    notifyListeners();
  }

  void update(StaffMe me) {
    _me = me;
    notifyListeners();
  }

  Future<void> signOut() async {
    await api.signOut();
    _me = null;
    notifyListeners();
  }

  @override
  void dispose() {
    api.authChanges.removeListener(refresh);
    super.dispose();
  }
}
