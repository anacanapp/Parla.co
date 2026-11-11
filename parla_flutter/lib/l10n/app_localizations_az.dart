// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'Parla';

  @override
  String get languageTitle => 'Dili seçin';

  @override
  String get languageName_az => 'Azərbaycanca';

  @override
  String get languageName_ru => 'Русский';

  @override
  String get languageName_en => 'English';

  @override
  String get continueButton => 'Davam et';

  @override
  String get welcomeTitle => 'Fərdi qulluq bələdçiniz';

  @override
  String get welcomeBody1 =>
      'Dəriniz, saçınız və bədəniniz üçün ekspertlərin yoxladığı rutinlər.';

  @override
  String get welcomeBody2 =>
      'Məhsulu skan edin və hər tərkib maddəsinin nə etdiyini rəsmi mənbələrlə görün.';

  @override
  String get welcomeBody3 => 'Yuxu, su və hərəkət: kiçik vərdişlər bir yerdə.';

  @override
  String get welcomeStart => 'Başla';

  @override
  String get welcomeBrowse => 'Hesabsız bax';

  @override
  String get welcomeSignIn => 'Artıq hesabım var';

  @override
  String get ageTitle => 'Hansı ildə doğulmusunuz?';

  @override
  String get ageWhy =>
      'Parla 18 yaş və yuxarı üçündür. Biz yalnız ili saxlayırıq, tam tarixi yox.';

  @override
  String get ageYearLabel => 'Doğum ili';

  @override
  String get ageInvalid => '1900 ilə bu il arasında bir il daxil edin.';

  @override
  String get ageBirthdayQuestion => 'Bu il ad gününüz artıq keçib?';

  @override
  String get yes => 'Bəli';

  @override
  String get no => 'Xeyr';

  @override
  String get underageTitle => 'Parla böyüklər üçündür';

  @override
  String get underageBody =>
      'Parla yalnız 18 yaş və yuxarı şəxslər üçün əlçatandır. Daxil etdiyiniz heç bir məlumat saxlanılmayıb.';

  @override
  String get close => 'Bağla';

  @override
  String get signInTitle => 'Daxil olun və ya hesab yaradın';

  @override
  String get signInBody =>
      'E-poçtunuza birdəfəlik kod göndərəcəyik. Şifrə lazım deyil.';

  @override
  String get signInFailed => 'Giriş alınmadı. Yenidən cəhd edin.';

  @override
  String get countryTitle => 'Harada yaşayırsınız?';

  @override
  String get countryWhy =>
      'Məlumatlarınız ölkənizin regionunda saxlanılır. Parla əvvəlcə Azərbaycanda açılır.';

  @override
  String get countryComingSoon => 'Tezliklə';

  @override
  String get countryName_AZ => 'Azərbaycan';

  @override
  String get countryName_TR => 'Türkiyə';

  @override
  String get countryName_KZ => 'Qazaxıstan';

  @override
  String get countryName_UZ => 'Özbəkistan';

  @override
  String get consentTitle => 'Seçimləriniz';

  @override
  String get consentIntro =>
      'Hər razılıq ayrıdır və default olaraq söndürülüb. Tətbiq onlarsız da işləyir. Onları istənilən vaxt Parametrlər → Məxfilik bölməsində dəyişə bilərsiniz.';

  @override
  String get consentHealthTitle => 'Sağlamlıqla bağlı cavablar';

  @override
  String get consentHealthHint =>
      'Yalnız dəri vəziyyətləri, allergiya, hamiləlik və dərmanlar haqqında könüllü suallar üçün lazımdır.';

  @override
  String get consentAnalyticsTitle => 'İstifadə statistikası';

  @override
  String get consentMarketingTitle => 'E-poçtla yeniliklər və məsləhətlər';

  @override
  String consentVersion(String version) {
    return 'Mətn versiyası: $version';
  }

  @override
  String get homeTitle => 'Bu gün';

  @override
  String get homePlaceholder =>
      'Dəri testindən sonra rutininiz burada görünəcək. Test növbəti versiyada əlavə olunur.';

  @override
  String get guestTitle => 'Məhsul axtarışı';

  @override
  String get guestPlaceholder =>
      'Məhsul axtarışı və skan növbəti versiyada əlavə olunur.';

  @override
  String get errorGeneric => 'Xəta baş verdi. Yenidən cəhd edin.';

  @override
  String get error_age_minor =>
      'Parla yalnız 18 yaş və yuxarı şəxslər üçün əlçatandır.';

  @override
  String get error_age_needs_confirmation => 'Ad günü sualına cavab verin.';

  @override
  String get error_age_invalid => 'Düzgün doğum ili daxil edin.';

  @override
  String get error_country_closed => 'Parla bu ölkədə hələ açılmayıb.';

  @override
  String get error_language_unsupported => 'Bu dil hələ dəstəklənmir.';

  @override
  String get error_profile_exists => 'Profiliniz artıq mövcuddur.';

  @override
  String get error_consent_outdated_version =>
      'Razılıq mətni dəyişib. Zəhmət olmasa, yenidən baxın.';
}
