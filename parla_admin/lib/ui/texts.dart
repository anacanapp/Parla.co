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
    'content.not_found' => 'Yazı tapılmadı.',
    'content.invalid' =>
      'Məlumat düzgün deyil (slug, kateqoriya və ya sahələr).',
    'content.incomplete' => 'Hər üç dildə bütün vacib sahələri doldurun.',
    'content.slug_taken' => 'Bu slug artıq istifadə olunur.',
    'content.wrong_status' => 'Bu addım indiki statusda mümkün deyil.',
    'content.consent_missing' => 'Mütəxəssisin yazılı razılığı qeyd olunmayıb.',
    'content.image_incomplete' =>
      'Şəklin lisenziyası və ya 3 dildə alternativ mətni çatışmır.',
    'media.not_found' => 'Şəkil tapılmadı.',
    'media.invalid' =>
      'Şəkil məlumatı düzgün deyil (lisenziya və ya alternativ mətn).',
    'media.not_image' =>
      'Fayl JPEG, PNG və ya WebP şəkli deyil, ya da 1 MB-dan böyükdür.',
    'media.in_use' => 'Bu şəkil hələ bir yazıda istifadə olunur.',
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

String statusLabel(ContentStatus s) => switch (s) {
  ContentStatus.draft => 'Qaralama',
  ContentStatus.inReview => 'Yoxlamada',
  ContentStatus.approved => 'Təsdiqlənib',
  ContentStatus.published => 'Dərc olunub',
};

String kindLabel(String kind) => switch (kind) {
  'article' => 'Bloqlar',
  'recipe' => 'Reseptlər',
  _ => 'Mütəxəssislər',
};

String categoryLabel(String id) => switch (id) {
  'care' => 'Qulluq',
  'beauty' => 'Gözəllik',
  'fashion' => 'Moda',
  'hair' => 'Saç',
  'body' => 'Bədən',
  'breakfast' => 'Səhər yeməyi',
  'lunch' => 'Nahar',
  'dinner' => 'Şam yeməyi',
  'snack' => 'Qəlyanaltı',
  'dermatologist' => 'Dermatoloq',
  'cosmetologist' => 'Kosmetoloq',
  'trainer' => 'Məşqçi',
  'dietitian' => 'Dietoloq',
  'trichologist' => 'Trixoloq',
  _ => id,
};

String allergenLabel(String id) => switch (id) {
  'gluten' => 'Qlüten',
  'crustaceans' => 'Xərçəngkimilər',
  'egg' => 'Yumurta',
  'fish' => 'Balıq',
  'peanuts' => 'Yer fındığı',
  'soy' => 'Soya',
  'milk' => 'Süd',
  'nuts' => 'Qoz-fındıq',
  'celery' => 'Kərəviz',
  'mustard' => 'Xardal',
  'sesame' => 'Küncüt',
  'sulphites' => 'Sulfitlər',
  'lupin' => 'Lüpin',
  'molluscs' => 'Molyusklar',
  _ => id,
};

String groupLabel(String id) => switch (id) {
  'vegetables' => 'Tərəvəz',
  'fruit' => 'Meyvə',
  'protein' => 'Protein',
  'whole_grain' => 'Tam taxıl',
  'healthy_fat' => 'Sağlam yağ',
  'dairy' => 'Süd məhsulu',
  _ => id,
};
