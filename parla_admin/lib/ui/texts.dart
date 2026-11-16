import '../api/admin_api.dart';

/// The panel is for the Parla team only, so it is in Azerbaijani.
String errorText(Object error) {
  if (error is! AdminError) return 'Xəta baş verdi. Yenidən cəhd edin.';
  return switch (error.code) {
    'staff.not_staff' => 'Bu hesab admin panelinə qoşulmayıb.',
    'staff.inactive' => 'Hesabınız deaktiv edilib. Admin ilə əlaqə saxlayın.',
    'staff.totp_required' => 'Əvvəlcə ikinci addımı (2FA) tamamlayın.',
    'staff.totp_invalid' => 'Kod səhvdir. Tətbiqdəki yeni kodu yazın.',
    'staff.locked' =>
      'Çox səhv cəhd oldu. 15 dəqiqədən sonra yenidən cəhd edin.',
    'staff.forbidden' => 'Bu əməliyyat üçün icazəniz yoxdur.',
    'staff.invite_invalid' =>
      'Dəvət kodu yanlışdır, vaxtı keçib və ya başqa e-poçta aiddir.',
    'staff.already' => 'Bu artıq edilib.',
    'staff.last_admin' => 'Sonuncu aktiv admini dəyişmək olmaz.',
    'staff.email_invalid' => 'E-poçt ünvanı düzgün deyil.',
    'auth.short_password' => 'Şifrə ən azı 12 simvol olmalıdır.',
    'auth.failed' =>
      'Alınmadı. E-poçtu, şifrəni və ya kodu yoxlayın və yenidən cəhd edin.',
    _ => 'Xəta baş verdi (${error.code}).',
  };
}

String roleLabel(StaffRole role) => switch (role) {
  StaffRole.admin => 'Admin',
  StaffRole.editor => 'Redaktor',
  StaffRole.expert => 'Mütəxəssis',
};

String roleHint(StaffRole role) => switch (role) {
  StaffRole.admin => 'Hər şey, işçi hesabları daxil',
  StaffRole.editor => 'Məzmun yazır və redaktə edir',
  StaffRole.expert => 'Öz sahəsində məzmunu yoxlayır və təsdiqləyir',
};
