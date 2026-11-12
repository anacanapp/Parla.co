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

  @override
  String get homeGreetingMorning => 'Günaydın!';

  @override
  String get homeGreetingAfternoon => 'Xeyirli gün!';

  @override
  String get homeGreetingEvening => 'Axşamınız xeyir!';

  @override
  String get homeTagline => 'Hər gün bir az daha sən.';

  @override
  String get homeProfileButton => 'Profil və məxfilik';

  @override
  String get routineSwitchLabel => 'Rutin seçimi';

  @override
  String get routineMorning => 'Səhər';

  @override
  String get routineEvening => 'Axşam';

  @override
  String get routineMorningTitle => 'Səhər rutini';

  @override
  String get routineEveningTitle => 'Axşam rutini';

  @override
  String get stepStatusDone => 'Tamamdır';

  @override
  String stepMarkDone(String step) {
    return '$step: tamamla';
  }

  @override
  String stepMarkUndone(String step) {
    return '$step: tamamlandı, geri qaytar';
  }

  @override
  String routineDoneHeader(String routine) {
    return '$routine hazırdır';
  }

  @override
  String get routineDoneTitle => 'Bu gün də parladın.';

  @override
  String get routineDoneBody =>
      'Bütün addımlar tamamdır. Növbəti rutində görüşərik.';

  @override
  String get routineRestart => 'Yenidən başla';

  @override
  String get habitsTitle => 'Bu günün vərdişləri';

  @override
  String get habitWater => 'Su';

  @override
  String habitWaterCount(int count, int goal) {
    return '$count / $goal stəkan';
  }

  @override
  String get habitWaterAdd => 'Bir stəkan əlavə et';

  @override
  String get habitWaterRemove => 'Bir stəkan çıx';

  @override
  String get habitSleep => 'Yuxu';

  @override
  String get habitMove => 'Hərəkət';

  @override
  String get habitNoEntry => 'Hələ qeyd yoxdur';

  @override
  String get habitLog => 'Qeyd et';

  @override
  String get scanTitle => 'Məhsulu yoxla';

  @override
  String get scanBody => 'Barkodu skan et, tərkibi sadə dildə gör';

  @override
  String get navMenuLabel => 'Əsas menyu';

  @override
  String get navToday => 'Bu gün';

  @override
  String get navScan => 'Skan';

  @override
  String get navHabits => 'Vərdiş';

  @override
  String get navProfile => 'Profil';

  @override
  String get comingSoon => 'Bu bölmə növbəti versiyada əlavə olunur.';

  @override
  String get routineMorningEyebrow => 'SƏHƏR RUTİNİ';

  @override
  String get routineEveningEyebrow => 'AXŞAM RUTİNİ';

  @override
  String get routineStatusStart => 'Başlayaq';

  @override
  String routineStatusLeft(int left) {
    return '$left addım qalıb';
  }

  @override
  String get routineStatusDone => 'Hamısı hazırdır';

  @override
  String routineMinutesLeft(int minutes) {
    return 'Təxminən $minutes dəqiqə';
  }

  @override
  String routineProgressLabel(String routine, int done, int total) {
    return '$routine: $done / $total addım tamamdır';
  }

  @override
  String get quizIntroTitle => 'Gəl tanış olaq.';

  @override
  String get quizIntroBody =>
      'Dəriniz, saçınız və gündəlik ritminiz haqqında bir neçə sual. Təxminən 3 dəqiqə çəkir.';

  @override
  String get quizStart => 'Başlayaq';

  @override
  String get quizLater => 'Sonra';

  @override
  String quizProgress(int current, int total) {
    return 'Sual $current / $total';
  }

  @override
  String get quizMultipleHint => 'Bir neçəsini seçə bilərsiniz';

  @override
  String get quizNext => 'Növbəti';

  @override
  String get quizBack => 'Geri';

  @override
  String get quizDecline => 'Cavab vermək istəmirəm';

  @override
  String get quizFinish => 'Bitir';

  @override
  String get healthGateTitle => 'Bir neçə həssas sual';

  @override
  String get healthGateBody =>
      'Növbəti suallar dəri diaqnozları, allergiya, hamiləlik və dərmanlar haqqındadır. Onlar rutini təhlükəsiz etməyə kömək edir. Cavablarınız şifrələnir və yalnız razılığınızla saxlanılır.';

  @override
  String get healthGateAgree => 'Razıyam, davam et';

  @override
  String get healthGateSkip => 'Bu bölməni keç';

  @override
  String get healthGateSkipNote => 'Keçsəniz, rutin daha ehtiyatlı qurulacaq.';

  @override
  String get redFlagTitle => 'Bunu həkimə göstərin';

  @override
  String get redFlagBody =>
      'Qeyd etdiyiniz əlamət həkim müayinəsi tələb edə bilər. Parla diaqnoz qoymur və həkimi əvəz etmir. Dermatoloqa müraciət etməyi tövsiyə edirik.';

  @override
  String get redFlagOk => 'Başa düşdüm';

  @override
  String get resultTitle => 'Rutininiz hazırdır';

  @override
  String get resultSkin => 'Dəri';

  @override
  String get resultHair => 'Saç';

  @override
  String get resultGoals => 'Məqsədlər';

  @override
  String get resultSeeRoutine => 'Rutinimi göstər';

  @override
  String get resultExclusionPregnancy =>
      'Retinol əlavə etmədik: hamiləlik və əmizdirmə dövründə, ya da bu suala cavab olmayanda onu tövsiyə etmirik.';

  @override
  String get resultExclusionMedication =>
      'Retinol əlavə etmədik: dərman sualı cavabsızdır və ya həkimin yazdığı dəri preparatından istifadə edirsiniz. Həkiminizlə məsləhətləşin.';

  @override
  String get resultExclusionSensitive =>
      'Həssas dəri üçün aktiv maddələr əvəzinə sakitləşdirici addımlar seçdik.';

  @override
  String get homeQuizTitle => 'Rutininizi fərdiləşdirək';

  @override
  String get homeQuizBody => '3 dəqiqəlik test — və rutin sizə uyğunlaşır.';

  @override
  String get homeQuizStart => 'Testə başla';

  @override
  String get error_consent_health_required =>
      'Bu cavablar üçün sağlamlıq razılığı lazımdır.';

  @override
  String get resultExclusionRetinoidBoth =>
      'Retinol əlavə etmədik: hamiləlik və dərmanlarla bağlı cavablar olmadan onu tövsiyə etmirik.';

  @override
  String get privacyTitle => 'Məxfilik mərkəzi';

  @override
  String get privacyIntro =>
      'Sənin datan, sənin seçimin. Hər hüququn bir toxunuş uzaqlığındadır.';

  @override
  String get privacyConsentsTitle => 'Razılıqlar';

  @override
  String get privacyHealthWithdrawTitle =>
      'Sağlamlıq razılığını geri götürürsünüz?';

  @override
  String get privacyHealthWithdrawBody =>
      'Sağlamlıq cavablarınız dərhal silinəcək və rutin daha ehtiyatlı qurulacaq. Razılığı sonra yenidən verə bilərsiniz.';

  @override
  String get privacyWithdraw => 'Geri götür və sil';

  @override
  String get privacyCancel => 'Ləğv et';

  @override
  String get privacyExportTitle => 'Datamı yüklə';

  @override
  String get privacyExportBody =>
      'Parla-nın sizin haqqınızda saxladığı hər şey, üstəlik bu telefondakı vərdiş qeydləri, bir faylda. Fayl indi yaradılır və serverlərimizdə saxlanılmır.';

  @override
  String get privacyExportButton => 'Fayl yarat';

  @override
  String get privacyLegalTitle => 'Hüquqi sənədlər';

  @override
  String get privacySignOut => 'Çıxış';

  @override
  String get privacyDeleteTitle => 'Hesabı sil';

  @override
  String get deleteTitle => 'Hesabınız silinsin?';

  @override
  String get deleteWhatGoes =>
      'Dərhal silinir: profiliniz, test cavablarınız, sağlamlıq cavablarınız və onların şifrə açarı, giriş hesabınız. Bu telefondakı vərdiş qeydləriniz də silinir.';

  @override
  String get deleteWhatStays =>
      'Adınız və e-poçtunuz olmadan sübut kimi qalır: razılıq tarixçəsi (3 il) və təhlükəsizlik qeydləri (1 il).';

  @override
  String get deleteExportFirst => 'Əvvəlcə datamı yüklə';

  @override
  String deleteConfirmLabel(String word) {
    return 'Təsdiq üçün $word yazın';
  }

  @override
  String get deleteConfirmWord => 'SİL';

  @override
  String get deleteButton => 'Hesabımı sil';

  @override
  String get deletedTitle => 'Hesabınız silindi';

  @override
  String get deletedBody =>
      'Bizimlə olduğunuz üçün təşəkkür edirik. Hər zaman geri qayıda bilərsiniz.';

  @override
  String get legalTitle => 'Hüquqi sənədlər';

  @override
  String get legalMedicalTitle => 'Tibbi məsləhət deyil';

  @override
  String get legalMedicalBody =>
      'Parla qulluq bələdçisidir. Diaqnoz qoymur, müalicə etmir və həkimi əvəz etmir. Dəri xəstəlikləri və ya narahatedici əlamətlər üçün dermatoloqa müraciət edin.';

  @override
  String get legalPolicyTitle => 'Məxfilik siyasəti və istifadə şərtləri';

  @override
  String get legalPolicyBody =>
      'Bu sənədlər hüquqşünasla hazırlanır və launch-dan əvvəl burada görünəcək.';

  @override
  String get legalConsentsTitle => 'Razılıq mətnləri';

  @override
  String get habitEdit => 'Dəyiş';

  @override
  String get habitSleepSheetTitle => 'Ötən gecə nə qədər yatdınız?';

  @override
  String get habitMoveSheetTitle => 'Bu gün nə qədər hərəkət etdiniz?';

  @override
  String habitSleepHours(String hours) {
    return '$hours saat';
  }

  @override
  String habitMoveMinutes(int minutes) {
    return '$minutes dəq';
  }

  @override
  String get habitLess => 'Azalt';

  @override
  String get habitMore => 'Artır';

  @override
  String get habitSave => 'Yadda saxla';

  @override
  String get habitClearEntry => 'Qeydi sil';

  @override
  String get habitsScreenTitle => 'Vərdişlər';

  @override
  String get habitsScreenIntro => 'Kiçik addımlar, öz tempinizlə.';

  @override
  String get habitsToday => 'Bu gün';

  @override
  String get habitsWeekTitle => 'Son 7 gün';

  @override
  String get habitsWeekCare => 'Rutinə vaxt ayırdığınız günlər';

  @override
  String habitsWeekCareValue(int days) {
    return '7 gündən $days';
  }

  @override
  String get habitsWeekNone => 'Hələ qeyd yoxdur';

  @override
  String habitsWeekWaterValue(String glasses) {
    return 'Gündə orta hesabla $glasses stəkan';
  }

  @override
  String habitsWeekSleepValue(String hours, int nights) {
    return 'Orta hesabla $hours saat, $nights gecə qeyd olunub';
  }

  @override
  String habitsWeekMoveValue(int minutes, int days) {
    return 'Cəmi $minutes dəq, $days gün';
  }

  @override
  String get habitsPrivacyNote =>
      'Vərdiş qeydləriniz yalnız bu telefonda saxlanılır və serverə göndərilmir. 90 gündən köhnə qeydlər avtomatik silinir.';

  @override
  String get privacyHabitsTitle => 'Bu telefondakı vərdiş qeydləri';

  @override
  String get privacyHabitsBody =>
      'Su, yuxu, hərəkət və rutin qeydləri yalnız bu telefonda saxlanılır. Onları istənilən vaxt silə bilərsiniz.';

  @override
  String get privacyHabitsDelete => 'Qeydləri sil';

  @override
  String get privacyHabitsDeleteTitle => 'Vərdiş qeydləri silinsin?';

  @override
  String get privacyHabitsDeleteBody =>
      'Bu telefondakı bütün su, yuxu, hərəkət və rutin qeydləriniz silinəcək. Bunu geri qaytarmaq olmur.';

  @override
  String get privacyHabitsDeleted => 'Vərdiş qeydləri silindi.';
}
