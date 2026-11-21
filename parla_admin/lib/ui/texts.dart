import '../api/admin_api.dart';

/// The panel is for the Parla team only, so it is in Azerbaijani.
String errorText(Object error) {
  if (error is! AdminError) return 'Xəta baş verdi. Yenidən cəhd edin.';
  return switch (error.code) {
    'staff.not_staff' => 'Bu hesab admin panelinə qoşulmayıb.',
    'staff.inactive' => 'Hesabınız deaktiv edilib. Admin ilə əlaqə saxlayın.',
    'staff.sign_in_again' =>
      'Təhlükəsizlik üçün 12 saatdan bir şifrə ilə yenidən daxil olun.',
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
    'content.outside_campaign' =>
      'Bannerin tarixləri kampaniyanın tarixlərindən kənara çıxır.',
    'ads.not_found' => 'Reklamçı və ya kampaniya tapılmadı.',
    'ads.invalid' =>
      'Məlumat düzgün deyil: ad, e-poçt və ya tarixləri (YYYY-AA-GG) yoxlayın.',
    'ads.name_taken' => 'Bu adda reklamçı artıq var.',
    'ads.in_use' =>
      'Əvvəlcə bağlı olanları dəyişin: reklamçının kampaniyası və ya '
          'kampaniyanın banneri var (və ya banner yeni tarixlərə sığmır).',
    'media.not_found' => 'Şəkil tapılmadı.',
    'media.invalid' =>
      'Şəkil məlumatı düzgün deyil (lisenziya və ya alternativ mətn).',
    'media.not_image' =>
      'Fayl JPEG, PNG və ya WebP şəkli deyil, ya da 1 MB-dan böyükdür.',
    'media.in_use' => 'Bu şəkil və ya video hələ bir yazıda istifadə olunur.',
    'media.not_video' =>
      'Fayl oxunan video deyil (MP4, MOV, WebM, GIF), 40 MB-dan böyükdür, '
          'ya da sıxılandan sonra da çox böyük qalır.',
    'users.not_found' => 'Hesab tapılmadı.',
    'users.confirm_mismatch' => 'Təsdiq üçün yazılan e-poçt uyğun gəlmir.',
    'support.empty' => 'Mesaj boşdur.',
    'support.too_long' => 'Mesaj çox uzundur (ən çox 2000 simvol).',
    'support.not_found' => 'Yazışma tapılmadı.',
    'users.is_staff' => 'Bu, işçi hesabıdır. İşçilər bölməsində idarə olunur.',
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
  StaffRole.support => 'Dəstək',
};

String roleHint(StaffRole role) => switch (role) {
  StaffRole.admin => 'Hər şey, işçi hesabları daxil',
  StaffRole.editor => 'Məzmun yazır və redaktə edir',
  StaffRole.expert => 'Öz sahəsində məzmunu yoxlayır və təsdiqləyir',
  StaffRole.support =>
    'İstifadəçilərin dəstək mesajlarını oxuyur və cavablayır',
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
  'preference' => 'Seçimlər',
  'exercise' => 'Məşqlər',
  'step' => 'Addımlar',
  'banner' => 'Bannerlər',
  'message' => 'Elanlar',
  'push' => 'Push',
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
  'catalogue' => 'Tətbiqin kataloqu',
  'today' => 'Bu gün ekranı',
  'discover' => 'Kəşf ekranı',
  'blog' => 'Bloq yazısının altı',
  'recipe' => 'Reseptin altı',
  'announcement' => 'Elan',
  'marketing' => 'Marketinq',
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
