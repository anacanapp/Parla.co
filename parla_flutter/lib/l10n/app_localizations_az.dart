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
  String get signInLegalNote =>
      'Hesab yaratmaqla İstifadə şərtlərini qəbul etmiş olursunuz. Məlumatlarınızın necə emal olunduğu Məxfilik siyasətində təsvir olunur.';

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
  String get navMenuLabel => 'Əsas menyu';

  @override
  String get navToday => 'Bu gün';

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
  String get resultGoals => 'Narahatlıqlar';

  @override
  String get resultSeeRoutine => 'Rutinimi göstər';

  @override
  String get recheckTitle => 'Cavabın hələ də belədir?';

  @override
  String recheckSkinBody(String answer, int months) {
    return 'Testdə hamiləlik barədə cavabın: «$answer». Bunu $months ay əvvəl qeyd etmişdin; rutinin buna görə qurulur.';
  }

  @override
  String recheckSportBody(String answer, int months) {
    return 'İdman sorğusunda cavabın: «$answer». Bunu $months ay əvvəl qeyd etmişdin; plan buna görə yumşaqdır.';
  }

  @override
  String get recheckYes => 'Bəli, belədir';

  @override
  String get recheckChange => 'Dəyişdi';

  @override
  String get recheckRemove => 'Cavabı sil';

  @override
  String get recheckChooseTitle => 'İndi necədir?';

  @override
  String get recheckSaved => 'Yadda saxlandı.';

  @override
  String get recheckPrivacy =>
      'Cavab şifrəli saxlanılır və yalnız rutinin və planın üçün istifadə olunur. Cavabı silsən, rutin ehtiyatlı qalır.';

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
  String get privacyTitle => 'Məxfilik mərkəzi';

  @override
  String get privacyIntro =>
      'Sənin datan, sənin seçimin. Hər hüququn bir toxunuş uzaqlığındadır.';

  @override
  String get profileAccountTitle => 'Hesabın';

  @override
  String get profileAccountNote => 'Ad soruşmuruq · yalnız e-poçt';

  @override
  String get profileEmailLabel => 'E-poçt';

  @override
  String get profileAgeLabel => 'Yaş';

  @override
  String get profileCountryLabel => 'Ölkə';

  @override
  String get profileLanguageLabel => 'Dil';

  @override
  String get privacyConsentsTitle => 'Razılıqlar';

  @override
  String get privacyHealthWithdrawTitle =>
      'Sağlamlıq razılığını geri götürürsünüz?';

  @override
  String get privacyHealthWithdrawBody =>
      'Sağlamlıq cavablarınız və öz rutinlərinizin serverdəki nüsxəsi dərhal silinəcək, rutin daha ehtiyatlı qurulacaq. Öz rutinləriniz bu telefonda qalır. Razılığı sonra yenidən verə bilərsiniz.';

  @override
  String get privacyWithdraw => 'Geri götür və sil';

  @override
  String get privacyCancel => 'Ləğv et';

  @override
  String get privacyExportTitle => 'Datamı yüklə';

  @override
  String get privacyExportBody =>
      'Parla-nın sizin haqqınızda saxladığı hər şey, üstəlik bu telefondakı vərdiş qeydləri, öz rutinləriniz və gündəliyiniz, bir faylda. Fayl indi yaradılır və serverlərimizdə saxlanılmır.';

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
      'Dərhal silinir: profiliniz, test və sağlamlıq cavablarınız, serverdə saxlanan öz rutinləriniz, alış siyahınız, idman və boşqab qeydləriniz (şifrə açarı ilə birlikdə), dəstək yazışmalarınız və giriş hesabınız. Bu telefondakı vərdiş qeydləri, gündəlik və saxlanılan reseptlər də silinir.';

  @override
  String get deleteWhatStays =>
      'E-poçtunuz və hesabınızla əlaqəsi olmadan qalır: razılıq tarixçəsi (3 il) və təhlükəsizlik qeydləri (1 il) sübut kimi, sifarişləriniz (varsa) isə mühasibat üçün.';

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
  String get legalPrivacyPolicy => 'Məxfilik siyasəti';

  @override
  String get legalTerms => 'İstifadə şərtləri';

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
  String get habitsScreenTitle => 'Rutin';

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

  @override
  String get remindersTitle => 'Xatırlatmalar';

  @override
  String get remindersIntro =>
      'Bildirişləri telefonunuz özü göstərir, heç nə serverə göndərilmir. İstədiyiniz vaxt söndürə bilərsiniz.';

  @override
  String get remindersOpen => 'Ayarla';

  @override
  String get remindersSummaryOff => 'Hamısı söndürülüb';

  @override
  String remindersSummaryOn(int count) {
    return 'Aktiv: $count';
  }

  @override
  String get reminderMorningTitle => 'Səhər rutini';

  @override
  String get reminderEveningTitle => 'Axşam rutini';

  @override
  String get reminderSleepTitle => 'Yuxu qeydi';

  @override
  String get reminderMorningBody => 'Səhər rutini vaxtıdır.';

  @override
  String get reminderEveningBody => 'Axşam rutini vaxtıdır.';

  @override
  String get reminderSleepBody => 'Keçən gecəni qeyd etmək istəyirsiniz?';

  @override
  String reminderAt(String time) {
    return 'Saat $time';
  }

  @override
  String get reminderChangeTime => 'Vaxtı dəyiş';

  @override
  String get reminderTimeSheetTitle => 'Nə vaxt xatırladaq?';

  @override
  String get reminderPermissionDenied =>
      'Bildiriş icazəsi verilməyib. Onu telefonun ayarlarında aça bilərsiniz.';

  @override
  String get remindersNote =>
      'Mətnlər neytraldır və kilid ekranında sağlamlıq məlumatı göstərmir. Bildiriş bir neçə dəqiqə gec gələ bilər.';

  @override
  String get productsTitle => 'Məhsul yoxla';

  @override
  String get productsIntro =>
      'Məhsulun adını və ya brendini yazın və tərkibinə baxın.';

  @override
  String get productsSearchLabel => 'Məhsul adı və ya brend';

  @override
  String get productsSearchButton => 'Axtar';

  @override
  String get productsQueryTooShort => 'Ən azı 2 hərf yazın.';

  @override
  String get productsNotFoundTitle => 'Heç nə tapılmadı';

  @override
  String get productsNotFoundBody =>
      'Başqa yazılışla və ya brend adı ilə yoxlayın. Bazada hələ hər məhsul yoxdur.';

  @override
  String get productsSourceObf => 'Open Beauty Facts';

  @override
  String get productsSourceParla => 'Parla kataloqu';

  @override
  String get error_product_query_invalid => 'Axtarış 2–80 simvol olmalıdır.';

  @override
  String get error_product_source_unavailable =>
      'Məhsul bazası hazırda cavab vermir. Bir az sonra yenidən cəhd edin.';

  @override
  String get productIngredientsTitle => 'Tərkib';

  @override
  String get productNoIngredients =>
      'Bu məhsul üçün tərkib siyahısı yoxdur. Qutudakı siyahıya baxın.';

  @override
  String productIngredientCount(int count) {
    return '$count tərkib maddəsi';
  }

  @override
  String productListedCount(int count) {
    return '$count maddə üçün AB qeydi var';
  }

  @override
  String get productStatusesMissing =>
      'Tərkib statusları hələ yüklənməyib. Hazırda yalnız tərkib siyahısı göstərilir.';

  @override
  String get productDataNotice =>
      'Tərkib siyahısı icma bazasından gəlir və səhvlər ola bilər. Qutudakı siyahı ilə müqayisə edin.';

  @override
  String productLegalNotice(String date) {
    return 'Statuslar AB-nin 1223/2009 saylı Reqlamentinin əlavələrinə əsaslanır (CosIng, $date). Adlar avtomatik uyğunlaşdırılır. Bu, Azərbaycan qaydası deyil və məhsulun təhlükəsizliyi barədə qiymətləndirmə deyil.';
  }

  @override
  String get productAttribution =>
      'Məhsul datası: Open Beauty Facts, ODbL lisenziyası ilə.';

  @override
  String get annexIIShort => 'AB: qadağan olunmuş maddələr siyahısında';

  @override
  String get annexIIIShort => 'AB: məhdudiyyətlərlə icazəlidir';

  @override
  String get annexIVShort => 'AB: icazəli rəngləndirici';

  @override
  String get annexVShort => 'AB: icazəli konservant';

  @override
  String get annexVIShort => 'AB: icazəli UV filtr';

  @override
  String annexEntry(String annex, String reference) {
    return 'Əlavə $annex, sıra № $reference';
  }

  @override
  String get annexConditionsLabel =>
      'Rəsmi şərtlər (CosIng-dən olduğu kimi, ingiliscə)';

  @override
  String get ingredientNoEntry => 'AB əlavələrində ayrıca qeyd tapılmadı';

  @override
  String ingredientSheetSource(String date) {
    return 'Mənbə: CosIng, $date';
  }

  @override
  String get ingredientDetailsHint => 'Ətraflı';

  @override
  String get navRoutine => 'Rutin';

  @override
  String get navCheck => 'Yoxla';

  @override
  String get navSport => 'İdman';

  @override
  String get navDiscover => 'Kəşf et';

  @override
  String get navProfile => 'Profil';

  @override
  String get sportTitle => 'İdman';

  @override
  String get discoverTitle => 'Kəşf et';

  @override
  String get discoverBlogs => 'Bloqlar';

  @override
  String get discoverBlogsHint => 'Qulluq, gözəllik, moda';

  @override
  String get discoverExperts => 'Mütəxəssislər';

  @override
  String get discoverExpertsHint => 'Dermatoloq, kosmetoloq';

  @override
  String get discoverNutrition => 'Qidalanma';

  @override
  String get discoverNutritionHint => 'Gündəlik boşqab və reseptlər';

  @override
  String get discoverShopping => 'Alış siyahısı';

  @override
  String get discoverShoppingHint => 'Lazım olanları qeyd et';

  @override
  String get discoverShop => 'Mağaza';

  @override
  String get discoverShopHint => 'Rutinindəki məhsullar';

  @override
  String get soonBadge => 'Tezliklə';

  @override
  String get onboardingStepAbout => 'Tanışlıq';

  @override
  String get onboardingStepAccount => 'Hesab';

  @override
  String get onboardingStepCountry => 'Ölkə';

  @override
  String get onboardingStepPrivacy => 'Məxfilik';

  @override
  String get routineAreaFace => 'Üz';

  @override
  String get routineAreaHair => 'Saç';

  @override
  String get routineAreaBody => 'Bədən';

  @override
  String get routineSlotMorning => 'Səhər';

  @override
  String get routineSlotEvening => 'Axşam';

  @override
  String get routineSlotWeekly => 'Həftəlik';

  @override
  String get routineWeeklyHint =>
      'Həftədə bir dəfə. İşarələr bazar ertəsi yenilənir.';

  @override
  String get routineSlotEmpty => 'Bu vaxt üçün addım yoxdur.';

  @override
  String get routineOwnButton => 'Öz rutinin';

  @override
  String get routineOwnSection => 'Öz rutinlərin';

  @override
  String get routineOwnEmpty => 'Öz rutinini yaradıb burada izləyə bilərsən.';

  @override
  String get routineOwnEveryDay => 'Hər gün';

  @override
  String routineOwnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count addım',
      one: '1 addım',
    );
    return '$_temp0';
  }

  @override
  String routineOwnEdit(String name) {
    return 'Dəyiş: $name';
  }

  @override
  String get routineDayHabits => 'Gün ərzində';

  @override
  String get builderTitleNew => 'Öz rutinini yarat';

  @override
  String get builderTitleEdit => 'Rutini dəyiş';

  @override
  String get builderName => 'Adı';

  @override
  String get builderNameHint => 'Məs. Bazar günü spa';

  @override
  String get builderArea => 'Bölmə';

  @override
  String get builderWhen => 'Nə vaxt';

  @override
  String get builderEveryDay => 'Hər gün';

  @override
  String get builderOnceWeek => 'Həftədə bir dəfə';

  @override
  String get builderSteps => 'Addımlar';

  @override
  String get builderStepHint => 'Yeni addım';

  @override
  String get builderAddStep => 'Əlavə et';

  @override
  String get builderSuggestions => 'Hazır addımlardan seç';

  @override
  String builderMoveUp(String step) {
    return 'Yuxarı: $step';
  }

  @override
  String builderMoveDown(String step) {
    return 'Aşağı: $step';
  }

  @override
  String builderRemoveStep(String step) {
    return 'Sil: $step';
  }

  @override
  String get builderSave => 'Yadda saxla';

  @override
  String get builderDelete => 'Rutini sil';

  @override
  String get builderDeleteConfirm => 'Bu rutin silinsin?';

  @override
  String get builderDeleteYes => 'Sil';

  @override
  String get builderCancel => 'Ləğv et';

  @override
  String get builderNeedName => 'Rutinə ad ver.';

  @override
  String get builderNeedStep => 'Ən azı bir addım əlavə et.';

  @override
  String builderLimit(int count) {
    return 'Ən çox $count addım.';
  }

  @override
  String get todayRoutinesTitle => 'Bu günün rutinləri';

  @override
  String get todayRoutinesAll => 'Hamısı';

  @override
  String get todayRoutinesNone => 'Bu gün üçün başqa rutin yoxdur.';

  @override
  String get builderPrivacySynced =>
      'Öz rutinlərin serverdə şifrəli saxlanılır, bu telefonda isə oflayn üçün nüsxəsi qalır.';

  @override
  String get builderPrivacyDevice =>
      'Öz rutinlərin hələlik yalnız bu telefonda saxlanılır. Yenilənmiş sağlamlıq razılığı ilə serverdə şifrəli saxlanılacaq.';

  @override
  String get checkPrefsTitle => 'Sənin seçimlərin';

  @override
  String get checkPrefsEdit => 'Dəyiş';

  @override
  String get checkPrefsEmpty =>
      'Sənin üçün vacib olanı seç, tərkibi seçimlərinlə tutuşduraq.';

  @override
  String get checkPrefsAdd => 'Seçim əlavə et';

  @override
  String get checkPrefsSheetTitle => 'Sənin üçün nə vacibdir?';

  @override
  String get checkPrefsSave => 'Yadda saxla';

  @override
  String get checkBarcodeSoon => 'Barkod skaneri · tezliklə';

  @override
  String get checkRecentTitle => 'Son yoxlanılanlar';

  @override
  String get checkRecentClear => 'Təmizlə';

  @override
  String get resultPrefsTitle => 'Sənin seçimlərinlə';

  @override
  String resultPrefsSummary(int fits, int count) {
    return 'Seçimlərindən $fits / $count uyğundur';
  }

  @override
  String get resultPrefFits => 'Uyğundur';

  @override
  String resultPrefContains(String names) {
    return 'Tərkibdə var: $names';
  }

  @override
  String get resultPrefVeganFits => 'Tanınan heyvan mənşəli maddə tapılmadı';

  @override
  String get resultPrefUnknown =>
      'Tərkib siyahısı olmadığı üçün yoxlamaq olmur';

  @override
  String get resultPrefsNone =>
      'Seçimlərini əlavə et ki, tərkibi onlarla tutuşduraq.';

  @override
  String get resultPrefsNote =>
      'Parla məhsulları qiymətləndirmir və bal vermir. Uyğunluq yalnız sənin seçimlərinə və tərkib siyahısına əsaslanır.';

  @override
  String get resultAddToList => 'Alış siyahısına';

  @override
  String get resultInList => 'Siyahıdadır';

  @override
  String get resultAdded => 'Alış siyahısına əlavə olundu.';

  @override
  String shoppingCount(int bought, int total) {
    return '$bought / $total alındı';
  }

  @override
  String get shoppingNewHint => 'Yeni məhsul';

  @override
  String get shoppingAdd => 'Əlavə et';

  @override
  String get shoppingEmpty => 'Siyahı boşdur. Lazım olanları burada qeyd et.';

  @override
  String get shoppingAreaOther => 'Digər';

  @override
  String get shoppingFromCheck => 'Yoxla bölməsindən';

  @override
  String shoppingRemove(String title) {
    return 'Sil: $title';
  }

  @override
  String get shoppingRemoveBought => 'Alınanları sil';

  @override
  String shoppingFull(int count) {
    return 'Siyahıda ən çox $count məhsul ola bilər.';
  }

  @override
  String get careListSynced =>
      'Seçimlərin və alış siyahın serverdə şifrəli saxlanılır, bu telefonda isə oflayn üçün nüsxəsi qalır.';

  @override
  String get careListDevice =>
      'Seçimlərin və alış siyahın hələlik yalnız bu telefonda saxlanılır. Yenilənmiş sağlamlıq razılığı ilə serverdə şifrəli saxlanılacaq.';

  @override
  String get shopTitle => 'Parla Mağaza';

  @override
  String get shopBody =>
      'Rutinindəki məhsullar, bir toxunuşla. Alış siyahını birbaşa sifariş edə, seçimlərinə uyğun məhsulları tapa biləcəksən.';

  @override
  String get shopSoonCard => 'Parla Mağaza';

  @override
  String get shopSoonCardBody => 'Partnyorların məhsullarına bax';

  @override
  String get shopOpenList => 'Alış siyahıma bax';

  @override
  String get shopIntro =>
      'Partnyorların məhsulları. Alış partnyorun saytında olur; Parla sənin haqqında heç nə ötürmür.';

  @override
  String get shopAll => 'Hamısı';

  @override
  String get shopCategoryFace => 'Üz';

  @override
  String get shopCategoryHair => 'Saç';

  @override
  String get shopCategoryBody => 'Bədən';

  @override
  String get shopCategoryMakeup => 'Makiyaj';

  @override
  String get shopCategoryOther => 'Digər';

  @override
  String shopPrice(String price) {
    return '$price ₼';
  }

  @override
  String get shopVisitPartner => 'Partnyorun saytına keç';

  @override
  String get shopPriceNote =>
      'Qiymət və mövcudluq partnyorun saytında dəyişə bilər. Almazdan əvvəl tərkibi yoxla; dəridə problem varsa, həkimlə məsləhətləş.';

  @override
  String get shopEmpty => 'Hələ məhsul yoxdur. Tezliklə burada olacaq.';

  @override
  String get shopMyOrders => 'Sifarişlərim';

  @override
  String get shopBuy => 'Al';

  @override
  String get shopBuyTitle => 'Sifarişi təsdiqlə';

  @override
  String shopBuyBody(String product, String price, String seller) {
    return '$product: $price. $seller Ödəniş Epoint səhifəsində olur; kart məlumatın Parla-ya gəlmir.';
  }

  @override
  String get shopSellerParla => 'Satıcı: Parla.';

  @override
  String shopSellerBrand(String brand) {
    return 'Satıcı: $brand, ödənişi Parla qəbul edir.';
  }

  @override
  String get shopBuyGo => 'Ödənişə keç';

  @override
  String get shopBuyError =>
      'Ödəniş səhifəsi açılmadı. Bir az sonra yenidən cəhd et.';

  @override
  String get shopTooMany =>
      'Son bir saatda çox sifariş başladın. Bir az sonra yenidən cəhd et.';

  @override
  String get shopOrdersEmpty => 'Hələ sifarişin yoxdur.';

  @override
  String shopOrderMeta(String number, String date, int quantity) {
    return '$number · $date · $quantity əd.';
  }

  @override
  String get shopOrderCreated => 'Ödəniş gözlənilir';

  @override
  String get shopOrderPaid => 'Ödənilib';

  @override
  String get shopOrderFailed => 'Ödəniş alınmadı';

  @override
  String get shopOrderShipped => 'Göndərilib';

  @override
  String get shopOrderDelivered => 'Çatdırılıb';

  @override
  String get shopOrderCancelled => 'Ləğv edilib';

  @override
  String get shopOrderRefunded => 'Pul qaytarılıb';

  @override
  String get sportIntroTitle => 'Sənə uyğun idman planı';

  @override
  String get sportIntroBody =>
      'Bir neçə sual: məqsəd, bölgələr, sevdiyin məşqlər. Sonra həftəlik plan, set və təkrar sayı, taymer. Musiqi öz tətbiqindən çalır.';

  @override
  String get sportStart => 'Başla';

  @override
  String get sportNext => 'Davam';

  @override
  String get sportNeedOne => 'Ən azı birini seç.';

  @override
  String get sportQGoals => 'Məqsədin nədir?';

  @override
  String get sportQGoalsHint => '2-yə qədər seç';

  @override
  String get sportGoalTone => 'Tonus və sıxlıq';

  @override
  String get sportGoalMuscle => 'Əzələ kütləsi artırmaq';

  @override
  String get sportGoalFlexibility => 'Elastiklik';

  @override
  String get sportGoalPosture => 'Duruş';

  @override
  String get sportGoalEndurance => 'Dözümlülük';

  @override
  String get sportGoalRelax => 'Stresdən rahatlama';

  @override
  String get sportQAreas => 'Hansı bölgələrə fokuslanaq?';

  @override
  String get sportAreasNote =>
      'Bir bölgədən yağ yandırmaq mümkün deyil. Bu hərəkətlər həmin əzələləri gücləndirir və tonus verir.';

  @override
  String get sportAreaArms => 'Qollar';

  @override
  String get sportAreaLegs => 'Ayaqlar';

  @override
  String get sportAreaCore => 'Qarın və kor';

  @override
  String get sportAreaGlutes => 'Omba';

  @override
  String get sportAreaBack => 'Kürək';

  @override
  String get sportAreaFull => 'Bütün bədən';

  @override
  String get sportQTypes => 'Hansı məşqləri istəyirsən?';

  @override
  String get sportTypeFitness => 'Fitnes';

  @override
  String get sportTypePilates => 'Pilates';

  @override
  String get sportTypeWallPilates => 'Divar pilatesi';

  @override
  String get sportTypeStretching => 'Stretching';

  @override
  String get sportTypeCardio => 'Yüngül kardio';

  @override
  String get sportTypeFaceYoga => 'Üz yoqası';

  @override
  String get sportTypeYoga => 'Yoqa';

  @override
  String get sportYogaMorning => 'Səhər axını';

  @override
  String get sportYogaEvening => 'Axşam sakitliyi';

  @override
  String get sportYogaStretch => 'Dartma və rahatlama';

  @override
  String sportSessionCardBody(int count, int minutes) {
    return '$count hərəkət · təxminən $minutes dəq';
  }

  @override
  String get sportYogaSafetyTitle => 'Başlamazdan əvvəl';

  @override
  String get sportYogaSafetyBody =>
      'Yavaş hərəkət et, nəfəsini saxlama, ağrı olarsa dayan. Hamiləlikdə, yüksək qan təzyiqində, bel, diz və ya bilək zədəsində əvvəlcə həkimə müraciət et. Sorğuda zədə və ya hamiləlik qeyd etmisənsə, sənə uyğun olmayan duruşlar seansdan çıxarılır.';

  @override
  String sportFaceYogaCardBody(int minutes) {
    return '12 hərəkət · təxminən $minutes dəq. Güzgü önündə, istənilən vaxt.';
  }

  @override
  String get sportFaceYogaSafetyTitle => 'Başlamazdan əvvəl';

  @override
  String get sportFaceYogaSafetyBody =>
      'Əllərinizi yuyun, dəriyə yalnız yüngül toxunun, dərini dartmayın. Ağrı və ya narahatlıq olarsa, dayandırın. Yaxın vaxtlarda kosmetik prosedura (botoks, filler) keçmisinizsə, çənə oynağında və ya dəridə problem varsa, əvvəlcə həkimə müraciət edin.';

  @override
  String get sportQLevel => 'Səviyyən necədir?';

  @override
  String get sportLevelBeginner => 'Yeni başlayıram';

  @override
  String get sportLevelIntermediate => 'Orta';

  @override
  String get sportLevelAdvanced => 'Təcrübəli';

  @override
  String get sportQSchedule => 'Nə qədər vaxtın var?';

  @override
  String get sportDaysLabel => 'Həftədə neçə gün';

  @override
  String get sportMinutesLabel => 'Bir məşq';

  @override
  String sportDays(int count) {
    return '$count gün';
  }

  @override
  String sportMinutes(int count) {
    return '$count dəq';
  }

  @override
  String get sportDumbbells => 'Evdə hantelim var';

  @override
  String get sportQSafety => 'Təhlükəsizlik üçün';

  @override
  String get sportSafetyIntro =>
      'Bu cavablar yalnız sənə uyğun olmayan hərəkətləri plandan çıxarmaq üçündür.';

  @override
  String get sportPregnancyLabel => 'Hamiləlik';

  @override
  String get sportPregNo => 'Yox';

  @override
  String get sportPregPregnant => 'Hamiləyəm';

  @override
  String get sportPregPostpartum => 'Son 6 ayda doğmuşam';

  @override
  String get sportInjuriesLabel => 'Ağrı və ya zədə';

  @override
  String get sportInjKnee => 'Diz';

  @override
  String get sportInjBack => 'Bel';

  @override
  String get sportInjShoulder => 'Çiyin';

  @override
  String get sportInjWrist => 'Bilək';

  @override
  String get sportDoctorLimit =>
      'Həkim idmanı məhdudlaşdırıb və ya əvvəlcə soruşmağı deyib';

  @override
  String get sportBuildPlan => 'Planı qur';

  @override
  String get sportWeekTitle => 'Bu həftə';

  @override
  String sportWeekProgress(int done, int total) {
    return '$done / $total məşq';
  }

  @override
  String sportWorkoutTitle(int number) {
    return 'Məşq $number';
  }

  @override
  String get sportWorkoutName_w6 => 'Yüngül dartınma';

  @override
  String get sportWorkoutName_w7 => 'Həftənin finalı';

  @override
  String get sportWorkoutName_p6 => 'Yumşaq axın';

  @override
  String get sportWorkoutName_p7 => 'Mərkəz finalı';

  @override
  String get sportWorkoutName_v6 => 'Divarda rahatlıq';

  @override
  String get sportWorkoutName_v7 => 'Divar finalı';

  @override
  String get sportEveryDay => 'Hər gün';

  @override
  String get sportWeekdaysLabel => 'Hansı günlər?';

  @override
  String sportWeekdaysHint(int count) {
    return '$count gün seç. Aradakı günlər istirahətdir.';
  }

  @override
  String get sportEveryDayNote =>
      'Hər gün: həftədə iki gün yüngül dartınma olur ki, əzələlər bərpa olunsun.';

  @override
  String sportWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(
      day,
      {
        '1': 'B.e',
        '2': 'Ç.a',
        '3': 'Ç',
        '4': 'C.a',
        '5': 'C',
        '6': 'Ş',
        'other': 'B',
      },
    );
    return '$_temp0';
  }

  @override
  String sportPickWeekdays(int count) {
    return 'Düz $count gün seç.';
  }

  @override
  String get sportMonthTitle => 'Aylıq plan';

  @override
  String sportMonthProgress(int day, int week) {
    return 'Gün $day / 28 · Həftə $week';
  }

  @override
  String get sportLegendDone => 'edildi';

  @override
  String get sportLegendWorkout => 'məşq';

  @override
  String get sportLegendRest => 'istirahət';

  @override
  String get sportToday => 'Bu gün';

  @override
  String get sportRestToday => 'Bu gün istirahət günüdür';

  @override
  String sportNextOn(String when) {
    return 'Növbəti məşq: $when';
  }

  @override
  String sportWeekBadge(int week) {
    return 'Həftə $week';
  }

  @override
  String get sportRecoveryWeek => 'Bərpa həftəsi';

  @override
  String sportCardMeta(int minutes, int moves) {
    return '$minutes dəq · $moves hərəkət';
  }

  @override
  String get sportMonthDoneTitle => 'Ay tamamlandı';

  @override
  String sportMonthDoneBody(int done) {
    return '$done məşq edildi. Növbəti aydan əvvəl cavablarını və səviyyəni yoxlayaq.';
  }

  @override
  String get sportNewMonth => 'Növbəti ay';

  @override
  String sportMonthCalendar(int done, int left) {
    return 'Ay təqvimi: $done məşq edildi, $left qaldı';
  }

  @override
  String get sportWorkoutName_w1 => 'Güclü start';

  @override
  String get sportWorkoutName_w2 => 'Ayaq günü';

  @override
  String get sportWorkoutName_w3 => 'Tam bədən';

  @override
  String get sportWorkoutName_w4 => 'Enerji dalğası';

  @override
  String get sportWorkoutName_w5 => 'Güc və tarazlıq';

  @override
  String get sportWorkoutName_p1 => 'Mərkəz oyanışı';

  @override
  String get sportWorkoutName_p2 => 'Yumşaq axın';

  @override
  String get sportWorkoutName_p3 => 'Duruş və nəfəs';

  @override
  String get sportWorkoutName_p4 => 'Uzun xətlər';

  @override
  String get sportWorkoutName_p5 => 'Sakit güc';

  @override
  String get sportWorkoutName_v1 => 'Divarla tanışlıq';

  @override
  String get sportWorkoutName_v2 => 'Divar dəstəyi';

  @override
  String get sportWorkoutName_v3 => 'Divarda axın';

  @override
  String get sportWorkoutName_v4 => 'Divar ritmi';

  @override
  String get sportWorkoutName_v5 => 'Divar balansı';

  @override
  String sportWorkoutMeta(String type, int minutes) {
    return '$type · ~$minutes dəq';
  }

  @override
  String get sportDone => 'Edildi';

  @override
  String get sportNextLabel => 'Növbəti';

  @override
  String get sportEditAnswers => 'Sorğunu yenilə';

  @override
  String get sportBlockedTitle => 'Əvvəlcə həkiminlə danış';

  @override
  String get sportBlockedBody =>
      'Həkim idmanı məhdudlaşdırıbsa, plan qurmuruq. İcazə alanda sorğunu yenilə.';

  @override
  String get sportGentleNote =>
      'Hamiləlik və doğuşdan sonrakı dövr üçün yüngül plan. Başlamazdan əvvəl həkimindən soruş.';

  @override
  String get sportDraftNote =>
      'Hərəkətlər və saylar hələ məşqçi tərəfindən yoxlanılmayıb. Ağrı hiss etsən, dayan.';

  @override
  String get sportAllDone => 'Bu həftənin bütün məşqləri edildi.';

  @override
  String sportSetsReps(int sets, int reps) {
    return '$sets × $reps təkrar';
  }

  @override
  String sportSetsSeconds(int sets, int seconds) {
    return '$sets × $seconds san';
  }

  @override
  String sportRestSeconds(int seconds) {
    return 'İstirahət $seconds san';
  }

  @override
  String get sportStartWorkout => 'Məşqə başla';

  @override
  String get sportMusicNote =>
      'Videoların öz musiqisi var, onu düymə ilə bağlaya bilərsən. Parla siqnal da verir.';

  @override
  String get sportVideoSoundOn => 'Video səsi açıqdır';

  @override
  String get sportVideoSoundOff => 'Video səsi bağlıdır';

  @override
  String get sportSoundOn => 'Siqnal səsi açıqdır';

  @override
  String get sportSoundOff => 'Siqnal səsi bağlıdır, yalnız vibrasiya';

  @override
  String sportSetOf(int set, int sets) {
    return 'Set $set / $sets';
  }

  @override
  String sportRepsNow(int reps) {
    return '$reps təkrar';
  }

  @override
  String get sportPause => 'Fasilə';

  @override
  String get sportResume => 'Davam';

  @override
  String get sportResting => 'İstirahət';

  @override
  String sportNextUp(String name) {
    return 'Sonra: $name';
  }

  @override
  String sportExerciseOf(int index, int total) {
    return 'Hərəkət $index / $total';
  }

  @override
  String get sportFinishedTitle => 'Məşq bitdi';

  @override
  String sportFinishedBody(int minutes) {
    return '$minutes dəqiqə hərəkət bu günün qeydinə əlavə olundu.';
  }

  @override
  String get sportBackToPlan => 'Plana qayıt';

  @override
  String get sportQuit => 'Məşqi dayandır';

  @override
  String get sportGetReady => 'Hazır ol';

  @override
  String get sportPrevious => 'Əvvəlki hərəkət';

  @override
  String get sportNextMove => 'Növbəti';

  @override
  String get sportStopTitle => 'Məşqi dayandıraq?';

  @override
  String get sportStopBody => 'Bu məşq edilmiş kimi qeyd olunmayacaq.';

  @override
  String get sportStopConfirm => 'Dayandır';

  @override
  String get sportKeepGoing => 'Davam et';

  @override
  String sportRepPace(int seconds) {
    return 'Hər təkrar təxminən $seconds san. Tez bitirsən, “Növbəti”ni bas.';
  }

  @override
  String get sportPrivacySynced =>
      'İdman cavabların serverdə şifrəli saxlanılır, bu telefonda isə oflayn üçün nüsxəsi qalır.';

  @override
  String get sportPrivacyDevice =>
      'İdman cavabların hələlik yalnız bu telefonda saxlanılır. Yenilənmiş sağlamlıq razılığı ilə serverdə şifrəli saxlanılacaq.';

  @override
  String get discoverLatest => 'Yeni yazılar';

  @override
  String get discoverAll => 'Hamısı';

  @override
  String get expertSample => 'Nümunə';

  @override
  String get expertSampleNote =>
      'Bu nümunə profildir, əlaqə məlumatları işləmir.';

  @override
  String get discoverJournal => 'Gündəlik';

  @override
  String get discoverJournalHint => 'Yalnız sənin üçün, bu telefonda';

  @override
  String get journalIntro =>
      'Günün haqqında yaz. Yazılar yalnız bu telefonda, şifrəli saxlanılır; Parla komandası onları görmür. Telefonu dəyişəndə və ya tətbiqi siləndə itir. Saxlamaq üçün: Profil → Datamı yüklə.';

  @override
  String get journalNew => 'Yeni yazı';

  @override
  String get journalEmpty => 'Hələ yazı yoxdur.';

  @override
  String get journalHint => 'Bu gün necə keçdi?';

  @override
  String get journalEntryTitle => 'Yazı';

  @override
  String get journalSave => 'Yadda saxla';

  @override
  String get journalDelete => 'Sil';

  @override
  String get journalDeleteTitle => 'Bu yazı silinsin?';

  @override
  String get journalDeleteBody => 'Geri qaytarmaq olmayacaq.';

  @override
  String get journalFull =>
      'Gündəlik doludur. Yeni yazı üçün köhnələrdən birini sil.';

  @override
  String get discoverSportHint => 'Həftəlik planın';

  @override
  String discoverArticleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yazı',
    );
    return '$_temp0';
  }

  @override
  String discoverRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resept',
    );
    return '$_temp0';
  }

  @override
  String get contentEmpty => 'Hələ yazı yoxdur. Tezliklə burada olacaq.';

  @override
  String get contentOffline =>
      'İnternet yoxdur, son yüklənmiş nüsxə göstərilir.';

  @override
  String blogMeta(String category, int minutes) {
    return '$category · $minutes dəq';
  }

  @override
  String blogReviewed(String date) {
    return 'Mütəxəssis yoxlayıb · $date';
  }

  @override
  String get blogTips => 'Qısa addımlar';

  @override
  String get catCare => 'Qulluq';

  @override
  String get catBeauty => 'Gözəllik';

  @override
  String get catFashion => 'Moda';

  @override
  String get catHair => 'Saç';

  @override
  String get specDermatologist => 'Dermatoloq';

  @override
  String get specCosmetologist => 'Kosmetoloq';

  @override
  String get specTrainer => 'Məşqçi';

  @override
  String get specDietitian => 'Dietoloq';

  @override
  String get specTrichologist => 'Trixoloq';

  @override
  String expertYears(int years) {
    return '$years il təcrübə';
  }

  @override
  String get expertCall => 'Zəng et';

  @override
  String get expertWhatsapp => 'WhatsApp';

  @override
  String get expertInstagram => 'Instagram';

  @override
  String get expertsNote =>
      'Parla mütəxəssisləri yalnız tanış edir, onların xidmətlərinə görə məsuliyyət daşımır. Əlaqə tətbiqdən kənarda, birbaşa mütəxəssislə qurulur; Parla söhbəti görmür.';

  @override
  String get nutritionHero => 'Gözəllik boşqabdan başlayır';

  @override
  String get nutritionPlate => 'Bu günün boşqabı';

  @override
  String nutritionPlateCount(int count, int total) {
    return '$count / $total qrup';
  }

  @override
  String get groupVegetables => 'Tərəvəz';

  @override
  String get groupFruit => 'Meyvə';

  @override
  String get groupProtein => 'Protein';

  @override
  String get groupWholeGrain => 'Tam taxıl';

  @override
  String get groupHealthyFat => 'Sağlam yağ';

  @override
  String get groupDairy => 'Süd məhsulu';

  @override
  String nutritionWater(int count, int goal) {
    return 'Su: $count / $goal stəkan';
  }

  @override
  String get nutritionNoCalories =>
      'Boşqabda kalori saymırıq. Sadəcə müxtəliflik: hər gün rəngli boşqab.';

  @override
  String get nutritionTip => 'Günün məsləhəti';

  @override
  String get nutritionRecipes => 'Gözəllik reseptləri';

  @override
  String get nutritionDisclaimer =>
      'Ümumi məlumatdır, pəhriz və ya tibbi tövsiyə deyil. Xüsusi qidalanma ehtiyacın varsa, dietoloqla məsləhətləş.';

  @override
  String get nutritionPrivacySynced =>
      'Boşqab qeydlərin serverdə şifrəli saxlanılır, bu telefonda isə oflayn üçün nüsxəsi qalır.';

  @override
  String get nutritionPrivacyDevice =>
      'Boşqab qeydlərin hələlik yalnız bu telefonda saxlanılır. Yenilənmiş sağlamlıq razılığı ilə serverdə şifrəli saxlanılacaq.';

  @override
  String get mealBreakfast => 'Səhər yeməyi';

  @override
  String get mealLunch => 'Nahar';

  @override
  String get mealDinner => 'Şam yeməyi';

  @override
  String get mealSnack => 'Qəlyanaltı';

  @override
  String recipeMeta(String meal, int minutes, int servings) {
    return '$meal · $minutes dəq · $servings nəfər';
  }

  @override
  String get recipeIngredients => 'Tərkib';

  @override
  String get recipeSteps => 'Hazırlanması';

  @override
  String get recipeAddAll => 'Tərkibi alış siyahısına əlavə et';

  @override
  String get recipeSave => 'Resepti saxla';

  @override
  String get recipeUnsave => 'Saxlanılanlardan çıxar';

  @override
  String get nutritionDailyRecipe => 'Bu günün tövsiyəsi';

  @override
  String get nutritionPlateIdeas => 'Boşqabını tamamla';

  @override
  String get nutritionPlateIdeasNote =>
      'Bu gün hələ seçmədiyin qruplar üçün reseptlər.';

  @override
  String get nutritionSaved => 'Saxladıqların';

  @override
  String recipeKcal(int kcal) {
    return '≈ $kcal kkal · 1 porsiya (təxmini)';
  }

  @override
  String recipeAdded(int count) {
    return '$count məhsul alış siyahısına əlavə olundu.';
  }

  @override
  String get skinCardTitle => 'Dəri analizi';

  @override
  String get skinCardBody => 'Suallara cavab verərək dərini yenidən təhlil et.';

  @override
  String get catBody => 'Bədən';

  @override
  String get blogSources => 'Mənbələr';

  @override
  String get blogRelated => 'Oxşar yazılar';

  @override
  String recipeAllergens(String list) {
    return 'Tərkibində: $list';
  }

  @override
  String get recipeNoAllergens => '14 əsas allergendən heç biri yoxdur.';

  @override
  String get allergenGluten => 'qlüten';

  @override
  String get allergenCrustaceans => 'xərçəngkimilər';

  @override
  String get allergenEgg => 'yumurta';

  @override
  String get allergenFish => 'balıq';

  @override
  String get allergenPeanuts => 'yer fındığı';

  @override
  String get allergenSoy => 'soya';

  @override
  String get allergenMilk => 'süd';

  @override
  String get allergenNuts => 'qoz-fındıq';

  @override
  String get allergenCelery => 'kərəviz';

  @override
  String get allergenMustard => 'xardal';

  @override
  String get allergenSesame => 'küncüt';

  @override
  String get allergenSulphites => 'sulfitlər';

  @override
  String get allergenLupin => 'lüpin';

  @override
  String get allergenMolluscs => 'molyusklar';

  @override
  String bannerAd(String brand) {
    return 'Reklam · $brand';
  }

  @override
  String get bannerLeaveTitle => 'Başqa sayta keçirsən';

  @override
  String bannerLeaveBody(String host) {
    return '$host saytı brauzerdə açılacaq. Parla bu sayta sənin haqqında heç bir məlumat göndərmir; saytın öz məxfilik qaydaları var.';
  }

  @override
  String get bannerLeaveGo => 'Sayta keç';

  @override
  String get bannerLeaveCancel => 'Ləğv et';

  @override
  String get messagesTitle => 'Mesajlar';

  @override
  String get messagesButton => 'Mesajlar';

  @override
  String get messagesButtonUnread => 'Mesajlar, yeni cavab var';

  @override
  String get messagesFromParla => 'Parla-dan';

  @override
  String get messagesNone => 'Hələ elan yoxdur.';

  @override
  String get supportTitle => 'Dəstək';

  @override
  String get supportIntro =>
      'Sualını yaz, Parla komandası cavab verəcək. Mesajlar şifrələnmiş saxlanır və son mesajdan 12 ay sonra silinir. Biz tibbi məsləhət vermirik: təcili və ya ciddi halda həkimə müraciət et.';

  @override
  String get supportHint => 'Mesajın';

  @override
  String get supportSend => 'Göndər';

  @override
  String get supportYou => 'Sən';

  @override
  String get supportTeam => 'Parla komandası';

  @override
  String get supportSent => 'Göndərildi.';

  @override
  String get pushTitle => 'Bildirişlər';

  @override
  String get pushBody =>
      'Dəstək cavab verəndə xəbər alırsan. Marketinq razılığı versən, Parla-nın yenilikləri də gəlir. İstənilən vaxt söndürə bilərsən.';

  @override
  String get pushDenied =>
      'Bildirişlərə icazə verilmədi. Telefonun ayarlarından aça bilərsən.';

  @override
  String get checkSuggestTitle => 'Testinə görə təklif';

  @override
  String get checkSuggestBody =>
      'Test cavablarına görə bu seçimlər sənə uyğun ola bilər. Əlavə edib-etməmək sənin qərarındır.';

  @override
  String checkSuggestAdd(String name) {
    return '$name əlavə et';
  }

  @override
  String get consentRefreshCardTitle => 'Razılıq mətni yeniləndi';

  @override
  String get consentRefreshCardBody =>
      'Sağlamlıq məlumatı razılığının yeni versiyası var. Oxuyub razılaşsan, rutinlərin, siyahıların, idman və qidalanma qeydlərin şifrələnmiş serverə də saxlanacaq. Razılaşmasan, onlar yalnız bu telefonda qalır.';

  @override
  String get consentRefreshOpen => 'Oxu';

  @override
  String get consentRefreshTitle => 'Sağlamlıq məlumatı razılığı';

  @override
  String get consentRefreshIntro =>
      'Əvvəl razılaşdığın mətnin yeni versiyasıdır. Razılaşmaq könüllüdür; istənilən vaxt Məxfilik bölməsində geri götürə bilərsən.';

  @override
  String get consentRefreshAgree => 'Razıyam';

  @override
  String get consentRefreshLater => 'İndi yox';

  @override
  String get consentRefreshDone => 'Razılıq yeniləndi.';
}
