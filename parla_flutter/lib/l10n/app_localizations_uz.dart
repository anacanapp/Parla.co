// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Parla';

  @override
  String get languageTitle => 'Tilni tanlang';

  @override
  String get languageName_az => 'Azərbaycanca';

  @override
  String get languageName_ru => 'Русский';

  @override
  String get languageName_en => 'English';

  @override
  String get continueButton => 'Davom etish';

  @override
  String get welcomeTitle => 'Shaxsiy parvarish qoʻllanmangiz';

  @override
  String get welcomeBody1 =>
      'Teringiz, sochingiz va tanangiz uchun mutaxassislar tekshirgan parvarish tartiblari.';

  @override
  String get welcomeBody2 =>
      'Mahsulotni skanerlang va har bir tarkibiy qism nima qilishini rasmiy manbalar asosida koʻring.';

  @override
  String get welcomeBody3 => 'Uyqu, suv va harakat: kichik odatlar bir joyda.';

  @override
  String get welcomeStart => 'Boshlash';

  @override
  String get welcomeBrowse => 'Hisobsiz koʻrish';

  @override
  String get welcomeSignIn => 'Hisobim bor';

  @override
  String get ageTitle => 'Qaysi yilda tugʻilgansiz?';

  @override
  String get ageWhy =>
      'Parla 18 yosh va undan kattalar uchun. Biz faqat yilni saqlaymiz, toʻliq sanani emas.';

  @override
  String get ageYearLabel => 'Tugʻilgan yil';

  @override
  String get ageInvalid => '1900-yil bilan joriy yil orasidagi yilni kiriting.';

  @override
  String get ageBirthdayQuestion => 'Bu yil tugʻilgan kuningiz oʻtdimi?';

  @override
  String get yes => 'Ha';

  @override
  String get no => 'Yoʻq';

  @override
  String get underageTitle => 'Parla kattalar uchun';

  @override
  String get underageBody =>
      'Parla faqat 18 yosh va undan katta shaxslar uchun mavjud. Siz kiritgan hech qanday maʼlumot saqlanmagan.';

  @override
  String get close => 'Yopish';

  @override
  String get signInTitle => 'Kiring yoki hisob yarating';

  @override
  String get signInBody =>
      'Elektron pochtangizga bir martalik kod yuboramiz. Parol kerak emas.';

  @override
  String get signInFailed => 'Kirish amalga oshmadi. Qayta urinib koʻring.';

  @override
  String get signInLegalNote =>
      'Hisob yaratish orqali Foydalanish shartlarini qabul qilgan boʻlasiz. Maʼlumotlaringiz qanday qayta ishlanishi Maxfiylik siyosatida tavsiflangan.';

  @override
  String get countryTitle => 'Qayerda yashaysiz?';

  @override
  String get countryWhy =>
      'Maʼlumotlaringiz mamlakatingiz mintaqasida saqlanadi. Parla avval Ozarbayjonda ishga tushadi.';

  @override
  String get countryComingSoon => 'Tez orada';

  @override
  String get countryName_AZ => 'Ozarbayjon';

  @override
  String get countryName_TR => 'Turkiya';

  @override
  String get countryName_KZ => 'Qozogʻiston';

  @override
  String get countryName_UZ => 'Oʻzbekiston';

  @override
  String get consentTitle => 'Tanlovlaringiz';

  @override
  String get consentIntro =>
      'Har bir rozilik alohida va sukut boʻyicha oʻchirilgan. Ilova ularsiz ham ishlaydi. Ularni istalgan vaqtda Sozlamalar → Maxfiylik boʻlimida oʻzgartirishingiz mumkin.';

  @override
  String get consentHealthTitle => 'Sogʻliqqa oid javoblar';

  @override
  String get consentHealthHint =>
      'Faqat teri holatlari, allergiya, homiladorlik va dori-darmonlar haqidagi ixtiyoriy savollar uchun kerak.';

  @override
  String get consentAnalyticsTitle => 'Foydalanish statistikasi';

  @override
  String get consentMarketingTitle =>
      'Elektron pochta orqali yangiliklar va maslahatlar';

  @override
  String consentVersion(String version) {
    return 'Matn versiyasi: $version';
  }

  @override
  String get guestTitle => 'Mahsulot qidirish';

  @override
  String get guestPlaceholder =>
      'Mahsulot qidirish va skanerlash keyingi versiyada qoʻshiladi.';

  @override
  String get errorGeneric => 'Xatolik yuz berdi. Qayta urinib koʻring.';

  @override
  String get error_age_minor =>
      'Parla faqat 18 yosh va undan katta shaxslar uchun mavjud.';

  @override
  String get error_age_needs_confirmation =>
      'Tugʻilgan kun haqidagi savolga javob bering.';

  @override
  String get error_age_invalid => 'Toʻgʻri tugʻilgan yilni kiriting.';

  @override
  String get error_country_closed =>
      'Parla bu mamlakatda hali ishga tushmagan.';

  @override
  String get error_language_unsupported =>
      'Bu til hozircha qoʻllab-quvvatlanmaydi.';

  @override
  String get error_profile_exists => 'Profilingiz allaqachon mavjud.';

  @override
  String get error_consent_outdated_version =>
      'Rozilik matni oʻzgardi. Iltimos, qaytadan koʻrib chiqing.';

  @override
  String get homeGreetingMorning => 'Xayrli tong!';

  @override
  String get homeGreetingAfternoon => 'Xayrli kun!';

  @override
  String get homeGreetingEvening => 'Xayrli kech!';

  @override
  String get homeTagline => 'Har kuni oʻzingga biroz yaqinroq.';

  @override
  String get homeProfileButton => 'Profil va maxfiylik';

  @override
  String get routineSwitchLabel => 'Tartibni tanlash';

  @override
  String get routineMorning => 'Ertalab';

  @override
  String get routineEvening => 'Kechqurun';

  @override
  String get routineMorningTitle => 'Ertalabki tartib';

  @override
  String get routineEveningTitle => 'Kechki tartib';

  @override
  String get stepStatusDone => 'Bajarildi';

  @override
  String stepMarkDone(String step) {
    return '$step: bajarildi deb belgilash';
  }

  @override
  String stepMarkUndone(String step) {
    return '$step: bajarildi, bekor qilish';
  }

  @override
  String routineDoneHeader(String routine) {
    return '$routine tayyor';
  }

  @override
  String get routineDoneTitle => 'Bugun ham porlading.';

  @override
  String get routineDoneBody =>
      'Barcha qadamlar bajarildi. Keyingi tartibda koʻrishamiz.';

  @override
  String get routineRestart => 'Qaytadan boshlash';

  @override
  String get habitsTitle => 'Bugungi odatlar';

  @override
  String get habitWater => 'Suv';

  @override
  String habitWaterCount(int count, int goal) {
    return '$count / $goal stakan';
  }

  @override
  String get habitWaterAdd => 'Bir stakan qoʻshish';

  @override
  String get habitWaterRemove => 'Bir stakan ayirish';

  @override
  String get habitSleep => 'Uyqu';

  @override
  String get habitMove => 'Harakat';

  @override
  String get habitNoEntry => 'Hali yozuv yoʻq';

  @override
  String get habitLog => 'Belgilash';

  @override
  String get navMenuLabel => 'Asosiy menyu';

  @override
  String get navToday => 'Bugun';

  @override
  String get comingSoon => 'Bu boʻlim keyingi versiyada qoʻshiladi.';

  @override
  String get routineMorningEyebrow => 'ERTALABKI TARTIB';

  @override
  String get routineEveningEyebrow => 'KECHKI TARTIB';

  @override
  String get routineStatusStart => 'Boshlaymiz';

  @override
  String routineStatusLeft(int left) {
    return '$left qadam qoldi';
  }

  @override
  String get routineStatusDone => 'Hammasi tayyor';

  @override
  String routineMinutesLeft(int minutes) {
    return 'Taxminan $minutes daqiqa';
  }

  @override
  String routineProgressLabel(String routine, int done, int total) {
    return '$routine: $done / $total qadam bajarildi';
  }

  @override
  String get quizIntroTitle => 'Kel, tanishaylik.';

  @override
  String get quizIntroBody =>
      'Teringiz, sochingiz va kundalik ritmingiz haqida bir nechta savol. Taxminan 3 daqiqa vaqt oladi.';

  @override
  String get quizStart => 'Boshlaymiz';

  @override
  String get quizLater => 'Keyinroq';

  @override
  String quizProgress(int current, int total) {
    return 'Savol $current / $total';
  }

  @override
  String get quizMultipleHint => 'Bir nechtasini tanlashingiz mumkin';

  @override
  String get quizNext => 'Keyingi';

  @override
  String get quizBack => 'Orqaga';

  @override
  String get quizDecline => 'Javob bermoqchi emasman';

  @override
  String get quizFinish => 'Yakunlash';

  @override
  String get healthGateTitle => 'Bir nechta nozik savol';

  @override
  String get healthGateBody =>
      'Keyingi savollar teri tashxislari, allergiya, homiladorlik va dori-darmonlar haqida. Ular tartibni xavfsiz qilishga yordam beradi. Javoblaringiz shifrlanadi va faqat roziligingiz bilan saqlanadi.';

  @override
  String get healthGateAgree => 'Roziman, davom etish';

  @override
  String get healthGateSkip => 'Bu boʻlimni oʻtkazib yuborish';

  @override
  String get healthGateSkipNote =>
      'Oʻtkazib yuborsangiz, tartib ehtiyotkorroq tuziladi.';

  @override
  String get redFlagTitle => 'Buni shifokorga koʻrsating';

  @override
  String get redFlagBody =>
      'Siz belgilagan alomat shifokor koʻrigini talab qilishi mumkin. Parla tashxis qoʻymaydi va shifokor oʻrnini bosmaydi. Dermatologga murojaat qilishingizni tavsiya qilamiz.';

  @override
  String get redFlagOk => 'Tushundim';

  @override
  String get resultTitle => 'Tartibingiz tayyor';

  @override
  String get resultSkin => 'Teri';

  @override
  String get resultHair => 'Soch';

  @override
  String get resultGoals => 'Muammolar';

  @override
  String get resultSeeRoutine => 'Tartibimni koʻrsatish';

  @override
  String get recheckTitle => 'Javobing hali ham shundaymi?';

  @override
  String recheckSkinBody(String answer, int months) {
    return 'Testda homiladorlik haqidagi javobing: «$answer». Buni $months oy oldin belgilagan eding; tartibing shunga qarab tuziladi.';
  }

  @override
  String recheckSportBody(String answer, int months) {
    return 'Sport soʻrovnomasidagi javobing: «$answer». Buni $months oy oldin belgilagan eding; reja shuning uchun yengil.';
  }

  @override
  String get recheckYes => 'Ha, shunday';

  @override
  String get recheckChange => 'Oʻzgardi';

  @override
  String get recheckRemove => 'Javobni oʻchirish';

  @override
  String get recheckChooseTitle => 'Hozir qanday?';

  @override
  String get recheckSaved => 'Saqlandi.';

  @override
  String get recheckPrivacy =>
      'Javob shifrlangan holda saqlanadi va faqat tartibing va rejang uchun ishlatiladi. Javobni oʻchirsang, tartib ehtiyotkor boʻlib qoladi.';

  @override
  String get homeFocusTitle => 'Kunning fokusi';

  @override
  String get homeFocusSub => 'Tartibing asosida';

  @override
  String get homeFocusDone =>
      'Bugungi tartib bajarildi. Oʻzingga biroz vaqt ajrat.';

  @override
  String get homeFocusOpen => 'Tartibni ochish';

  @override
  String homeFocusSteps(int done, int total) {
    return '$done / $total qadam';
  }

  @override
  String get homePulse => 'Qisqacha';

  @override
  String get homeLater => 'Davomi';

  @override
  String get homeQuizTitle => 'Tartibingizni moslashtiraylik';

  @override
  String get homeQuizBody => '3 daqiqalik test — va tartib sizga moslashadi.';

  @override
  String get homeQuizStart => 'Testni boshlash';

  @override
  String get error_consent_health_required =>
      'Bu javoblar uchun sogʻliq roziligi kerak.';

  @override
  String get privacyTitle => 'Maxfiylik markazi';

  @override
  String get privacyIntro =>
      'Sening maʼlumoting — sening tanloving. Har bir huquqing bir teginish masofasida.';

  @override
  String get profileAccountTitle => 'Hisobing';

  @override
  String get profileAccountNote => 'Ism soʻramaymiz · faqat e-pochta';

  @override
  String get profileEmailLabel => 'E-pochta';

  @override
  String get profileAgeLabel => 'Yosh';

  @override
  String get profileCountryLabel => 'Mamlakat';

  @override
  String get profileLanguageLabel => 'Til';

  @override
  String get privacyConsentsTitle => 'Roziliklar';

  @override
  String get privacyHealthWithdrawTitle =>
      'Sogʻliq roziligini qaytarib olasizmi?';

  @override
  String get privacyHealthWithdrawBody =>
      'Sogʻliq javoblaringiz va oʻz tartiblaringizning serverdagi nusxasi darhol oʻchiriladi, tartib ehtiyotkorroq tuziladi. Oʻz tartiblaringiz shu telefonda qoladi. Rozilikni keyinroq yana berishingiz mumkin.';

  @override
  String get privacyWithdraw => 'Qaytarib olish va oʻchirish';

  @override
  String get privacyCancel => 'Bekor qilish';

  @override
  String get privacyExportTitle => 'Maʼlumotlarimni yuklab olish';

  @override
  String get privacyExportBody =>
      'Parla siz haqingizda saqlaydigan hamma narsa, shuningdek, shu telefondagi odat yozuvlari, oʻz tartiblaringiz va kundaligingiz — bitta faylda. Fayl hozir yaratiladi va serverlarimizda saqlanmaydi.';

  @override
  String get privacyExportButton => 'Fayl yaratish';

  @override
  String get privacyLegalTitle => 'Huquqiy hujjatlar';

  @override
  String get privacySignOut => 'Chiqish';

  @override
  String get privacyDeleteTitle => 'Hisobni oʻchirish';

  @override
  String get deleteTitle => 'Hisobingiz oʻchirilsinmi?';

  @override
  String get deleteWhatGoes =>
      'Darhol oʻchiriladi: profilingiz, test va sogʻliq javoblaringiz, serverda saqlangan oʻz tartiblaringiz, xarid roʻyxatingiz, sport va likopcha yozuvlaringiz (shifr kaliti bilan birga), yordam xizmati bilan yozishmalaringiz va kirish hisobingiz. Shu telefondagi odat yozuvlari, kundalik va saqlangan retseptlar ham oʻchiriladi.';

  @override
  String get deleteWhatStays =>
      'Elektron pochtangiz va hisobingizga bogʻlanmagan holda qoladi: rozilik tarixi (3 yil) va xavfsizlik yozuvlari (1 yil) dalil sifatida, buyurtmalaringiz (agar boʻlsa) esa buxgalteriya hisobi uchun.';

  @override
  String get deleteExportFirst => 'Avval maʼlumotlarimni yuklab olish';

  @override
  String deleteConfirmLabel(String word) {
    return 'Tasdiqlash uchun $word deb yozing';
  }

  @override
  String get deleteConfirmWord => 'OʻCHIRISH';

  @override
  String get deleteButton => 'Hisobimni oʻchirish';

  @override
  String get deletedTitle => 'Hisobingiz oʻchirildi';

  @override
  String get deletedBody =>
      'Biz bilan boʻlganingiz uchun rahmat. Istalgan vaqtda qaytishingiz mumkin.';

  @override
  String get legalTitle => 'Huquqiy hujjatlar';

  @override
  String get legalMedicalTitle => 'Tibbiy maslahat emas';

  @override
  String get legalMedicalBody =>
      'Parla — parvarish qoʻllanmasi. U tashxis qoʻymaydi, davolamaydi va shifokor oʻrnini bosmaydi. Teri kasalliklari yoki bezovta qiluvchi alomatlar boʻyicha dermatologga murojaat qiling.';

  @override
  String get legalPolicyTitle => 'Maxfiylik siyosati va foydalanish shartlari';

  @override
  String get legalPolicyBody =>
      'Bu hujjatlar yurist bilan tayyorlanmoqda va ishga tushirishdan oldin shu yerda paydo boʻladi.';

  @override
  String get legalPrivacyPolicy => 'Maxfiylik siyosati';

  @override
  String get legalTerms => 'Foydalanish shartlari';

  @override
  String get legalConsentsTitle => 'Rozilik matnlari';

  @override
  String get habitEdit => 'Oʻzgartirish';

  @override
  String get habitSleepSheetTitle => 'Oʻtgan kecha qancha uxladingiz?';

  @override
  String get habitMoveSheetTitle => 'Bugun qancha harakat qildingiz?';

  @override
  String habitSleepHours(String hours) {
    return '$hours soat';
  }

  @override
  String habitMoveMinutes(int minutes) {
    return '$minutes daq';
  }

  @override
  String get habitLess => 'Kamaytirish';

  @override
  String get habitMore => 'Koʻpaytirish';

  @override
  String get habitSave => 'Saqlash';

  @override
  String get habitClearEntry => 'Yozuvni oʻchirish';

  @override
  String get habitsScreenTitle => 'Tartib';

  @override
  String get habitsScreenIntro => 'Kichik qadamlar, oʻz surʼatingizda.';

  @override
  String get habitsToday => 'Bugun';

  @override
  String get habitsWeekTitle => 'Soʻnggi 7 kun';

  @override
  String get habitsWeekCare => 'Tartibga vaqt ajratgan kunlaringiz';

  @override
  String habitsWeekCareValue(int days) {
    return '7 kundan $days';
  }

  @override
  String get habitsWeekNone => 'Hali yozuv yoʻq';

  @override
  String habitsWeekWaterValue(String glasses) {
    return 'Kuniga oʻrtacha $glasses stakan';
  }

  @override
  String habitsWeekSleepValue(String hours, int nights) {
    return 'Oʻrtacha $hours soat, $nights kecha belgilangan';
  }

  @override
  String habitsWeekMoveValue(int minutes, int days) {
    return 'Jami $minutes daq, $days kun';
  }

  @override
  String get habitsPrivacyNote =>
      'Odat yozuvlaringiz faqat shu telefonda saqlanadi va serverga yuborilmaydi. 90 kundan eski yozuvlar avtomatik oʻchiriladi.';

  @override
  String get privacyHabitsTitle => 'Shu telefondagi odat yozuvlari';

  @override
  String get privacyHabitsBody =>
      'Suv, uyqu, harakat va tartib yozuvlari faqat shu telefonda saqlanadi. Ularni istalgan vaqtda oʻchirishingiz mumkin.';

  @override
  String get privacyHabitsDelete => 'Yozuvlarni oʻchirish';

  @override
  String get privacyHabitsDeleteTitle => 'Odat yozuvlari oʻchirilsinmi?';

  @override
  String get privacyHabitsDeleteBody =>
      'Shu telefondagi barcha suv, uyqu, harakat va tartib yozuvlaringiz oʻchiriladi. Buni qaytarib boʻlmaydi.';

  @override
  String get privacyHabitsDeleted => 'Odat yozuvlari oʻchirildi.';

  @override
  String get remindersTitle => 'Eslatmalar';

  @override
  String get remindersIntro =>
      'Bildirishnomalarni telefoningizning oʻzi koʻrsatadi, serverga hech narsa yuborilmaydi. Istalgan vaqtda oʻchirib qoʻyishingiz mumkin.';

  @override
  String get remindersOpen => 'Sozlash';

  @override
  String get remindersSummaryOff => 'Hammasi oʻchirilgan';

  @override
  String remindersSummaryOn(int count) {
    return 'Faol: $count';
  }

  @override
  String get reminderMorningTitle => 'Ertalabki tartib';

  @override
  String get reminderEveningTitle => 'Kechki tartib';

  @override
  String get reminderSleepTitle => 'Uyqu yozuvi';

  @override
  String get reminderMorningBody => 'Ertalabki tartib vaqti keldi.';

  @override
  String get reminderEveningBody => 'Kechki tartib vaqti keldi.';

  @override
  String get reminderSleepBody => 'Oʻtgan kechani belgilab qoʻymoqchimisiz?';

  @override
  String reminderAt(String time) {
    return 'Soat $time';
  }

  @override
  String get reminderChangeTime => 'Vaqtni oʻzgartirish';

  @override
  String get reminderTimeSheetTitle => 'Qachon eslataylik?';

  @override
  String get reminderPermissionDenied =>
      'Bildirishnomalarga ruxsat berilmagan. Uni telefon sozlamalarida yoqishingiz mumkin.';

  @override
  String get remindersNote =>
      'Matnlar neytral va qulflangan ekranda sogʻliq haqidagi maʼlumotni koʻrsatmaydi. Bildirishnoma bir necha daqiqa kechikib kelishi mumkin.';

  @override
  String get productsTitle => 'Mahsulotni tekshirish';

  @override
  String get productsIntro =>
      'Mahsulot nomi yoki brendini yozing va tarkibini koʻring.';

  @override
  String get productsSearchLabel => 'Mahsulot nomi yoki brend';

  @override
  String get productsSearchButton => 'Qidirish';

  @override
  String get productsQueryTooShort => 'Kamida 2 ta harf yozing.';

  @override
  String get productsNotFoundTitle => 'Hech narsa topilmadi';

  @override
  String get productsNotFoundBody =>
      'Boshqacha yozib yoki brend nomi bilan qidirib koʻring. Bazada hali hamma mahsulot yoʻq.';

  @override
  String get productsSourceObf => 'Open Beauty Facts';

  @override
  String get productsSourceParla => 'Parla katalogi';

  @override
  String get error_product_query_invalid =>
      'Qidiruv 2–80 belgidan iborat boʻlishi kerak.';

  @override
  String get error_product_source_unavailable =>
      'Mahsulotlar bazasi hozir javob bermayapti. Birozdan soʻng qayta urinib koʻring.';

  @override
  String get productIngredientsTitle => 'Tarkib';

  @override
  String get productNoIngredients =>
      'Bu mahsulot uchun tarkib roʻyxati yoʻq. Qadoqdagi roʻyxatga qarang.';

  @override
  String productIngredientCount(int count) {
    return '$count ta tarkibiy qism';
  }

  @override
  String productListedCount(int count) {
    return '$count ta modda uchun YeI yozuvi bor';
  }

  @override
  String get productStatusesMissing =>
      'Tarkib maqomlari hali yuklanmagan. Hozircha faqat tarkib roʻyxati koʻrsatiladi.';

  @override
  String get productDataNotice =>
      'Tarkib roʻyxati hamjamiyat bazasidan olinadi va unda xatolar boʻlishi mumkin. Qadoqdagi roʻyxat bilan solishtiring.';

  @override
  String productLegalNotice(String date) {
    return 'Maqomlar YeIning 1223/2009-sonli Reglamenti ilovalariga asoslanadi (CosIng, $date). Nomlar avtomatik moslashtiriladi. Bu Ozarbayjon qoidasi emas va mahsulot xavfsizligi boʻyicha baho emas.';
  }

  @override
  String get productAttribution =>
      'Mahsulot maʼlumotlari: Open Beauty Facts, ODbL litsenziyasi asosida.';

  @override
  String get annexIIShort => 'YeI: taqiqlangan moddalar roʻyxatida';

  @override
  String get annexIIIShort => 'YeI: cheklovlar bilan ruxsat etilgan';

  @override
  String get annexIVShort => 'YeI: ruxsat etilgan rang beruvchi modda';

  @override
  String get annexVShort => 'YeI: ruxsat etilgan konservant';

  @override
  String get annexVIShort => 'YeI: ruxsat etilgan UV filtr';

  @override
  String annexEntry(String annex, String reference) {
    return 'Ilova $annex, tartib № $reference';
  }

  @override
  String get annexConditionsLabel =>
      'Rasmiy shartlar (CosIng manbasidagidek, ingliz tilida)';

  @override
  String get ingredientNoEntry => 'YeI ilovalarida alohida yozuv topilmadi';

  @override
  String ingredientSheetSource(String date) {
    return 'Manba: CosIng, $date';
  }

  @override
  String get ingredientDetailsHint => 'Batafsil';

  @override
  String get navRoutine => 'Tartib';

  @override
  String get navCheck => 'Tekshirish';

  @override
  String get navSport => 'Sport';

  @override
  String get navDiscover => 'Kashf et';

  @override
  String get navProfile => 'Profil';

  @override
  String get sportTitle => 'Sport';

  @override
  String get discoverTitle => 'Kashf et';

  @override
  String get discoverBlogs => 'Bloglar';

  @override
  String get discoverBlogsHint => 'Parvarish, goʻzallik, moda';

  @override
  String get discoverExperts => 'Mutaxassislar';

  @override
  String get discoverExpertsHint => 'Dermatolog, kosmetolog';

  @override
  String get discoverNutrition => 'Ovqatlanish';

  @override
  String get discoverNutritionHint => 'Kundalik likopcha va retseptlar';

  @override
  String get discoverShopping => 'Xarid roʻyxati';

  @override
  String get discoverShoppingHint => 'Keraklilarni yozib qoʻy';

  @override
  String get discoverShop => 'Doʻkon';

  @override
  String get discoverShopHint => 'Tartibingdagi mahsulotlar';

  @override
  String get soonBadge => 'Tez orada';

  @override
  String get onboardingStepAbout => 'Tanishuv';

  @override
  String get onboardingStepAccount => 'Hisob';

  @override
  String get onboardingStepCountry => 'Mamlakat';

  @override
  String get onboardingStepPrivacy => 'Maxfiylik';

  @override
  String get routineAreaFace => 'Yuz';

  @override
  String get routineAreaHair => 'Soch';

  @override
  String get routineAreaBody => 'Tana';

  @override
  String get routineSlotMorning => 'Ertalab';

  @override
  String get routineSlotEvening => 'Kechqurun';

  @override
  String get routineSlotWeekly => 'Haftalik';

  @override
  String get routineWeeklyHint =>
      'Haftada bir marta. Belgilar dushanba kuni yangilanadi.';

  @override
  String get routineSlotEmpty => 'Bu vaqt uchun qadam yoʻq.';

  @override
  String get routineOwnButton => 'Oʻz tartibing';

  @override
  String get routineOwnSection => 'Oʻz tartiblaring';

  @override
  String get routineOwnEmpty =>
      'Oʻz tartibingni yaratib, shu yerda kuzatib borishing mumkin.';

  @override
  String get routineOwnEveryDay => 'Har kuni';

  @override
  String routineOwnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count qadam',
      one: '1 qadam',
    );
    return '$_temp0';
  }

  @override
  String routineOwnEdit(String name) {
    return 'Oʻzgartirish: $name';
  }

  @override
  String get routineDayHabits => 'Kun davomida';

  @override
  String get builderTitleNew => 'Oʻz tartibingni yarat';

  @override
  String get builderTitleEdit => 'Tartibni oʻzgartirish';

  @override
  String get builderName => 'Nomi';

  @override
  String get builderNameHint => 'Mas. Yakshanba spa';

  @override
  String get builderArea => 'Boʻlim';

  @override
  String get builderWhen => 'Qachon';

  @override
  String get builderEveryDay => 'Har kuni';

  @override
  String get builderOnceWeek => 'Haftada bir marta';

  @override
  String get builderSteps => 'Qadamlar';

  @override
  String get builderStepHint => 'Yangi qadam';

  @override
  String get builderAddStep => 'Qoʻshish';

  @override
  String get builderSuggestions => 'Tayyor qadamlardan tanla';

  @override
  String builderMoveUp(String step) {
    return 'Yuqoriga: $step';
  }

  @override
  String builderMoveDown(String step) {
    return 'Pastga: $step';
  }

  @override
  String builderRemoveStep(String step) {
    return 'Oʻchirish: $step';
  }

  @override
  String get builderSave => 'Saqlash';

  @override
  String get builderDelete => 'Tartibni oʻchirish';

  @override
  String get builderDeleteConfirm => 'Bu tartib oʻchirilsinmi?';

  @override
  String get builderDeleteYes => 'Oʻchirish';

  @override
  String get builderCancel => 'Bekor qilish';

  @override
  String get builderNeedName => 'Tartibga nom ber.';

  @override
  String get builderNeedStep => 'Kamida bitta qadam qoʻsh.';

  @override
  String builderLimit(int count) {
    return 'Koʻpi bilan $count ta qadam.';
  }

  @override
  String get todayRoutinesTitle => 'Bugungi tartiblar';

  @override
  String get todayRoutinesAll => 'Hammasi';

  @override
  String get todayRoutinesNone => 'Bugun uchun boshqa tartib yoʻq.';

  @override
  String get builderPrivacySynced =>
      'Oʻz tartiblaring serverda shifrlangan holda saqlanadi, shu telefonda esa oflayn foydalanish uchun nusxasi qoladi.';

  @override
  String get builderPrivacyDevice =>
      'Oʻz tartiblaring hozircha faqat shu telefonda saqlanadi. Yangilangan sogʻliq roziligi bilan serverda shifrlangan holda saqlanadi.';

  @override
  String get checkPrefsTitle => 'Sening tanlovlaring';

  @override
  String get checkPrefsEdit => 'Oʻzgartirish';

  @override
  String get checkPrefsEmpty =>
      'Sen uchun muhim narsani tanla, tarkibni tanlovlaring bilan solishtiramiz.';

  @override
  String get checkPrefsAdd => 'Tanlov qoʻshish';

  @override
  String get checkPrefsSheetTitle => 'Sen uchun nima muhim?';

  @override
  String get checkPrefsSave => 'Saqlash';

  @override
  String get checkBarcodeSoon => 'Shtrix-kod skaneri · tez orada';

  @override
  String get checkRecentTitle => 'Oxirgi tekshirilganlar';

  @override
  String get checkRecentClear => 'Tozalash';

  @override
  String get resultPrefsTitle => 'Tanlovlaring boʻyicha';

  @override
  String resultPrefsSummary(int fits, int count) {
    return 'Tanlovlaringdan $fits / $count mos keladi';
  }

  @override
  String get resultPrefFits => 'Mos keladi';

  @override
  String resultPrefContains(String names) {
    return 'Tarkibida bor: $names';
  }

  @override
  String get resultPrefVeganFits => 'Maʼlum hayvon manbali modda topilmadi';

  @override
  String get resultPrefUnknown =>
      'Tarkib roʻyxati yoʻqligi sababli tekshirib boʻlmaydi';

  @override
  String get resultPrefsNone =>
      'Tarkibni solishtirishimiz uchun tanlovlaringni qoʻsh.';

  @override
  String get resultPrefsNote =>
      'Parla mahsulotlarga baho bermaydi va ball qoʻymaydi. Moslik faqat sening tanlovlaring va tarkib roʻyxatiga asoslanadi.';

  @override
  String get resultAddToList => 'Xarid roʻyxatiga';

  @override
  String get resultInList => 'Roʻyxatda';

  @override
  String get resultAdded => 'Xarid roʻyxatiga qoʻshildi.';

  @override
  String shoppingCount(int bought, int total) {
    return '$bought / $total olindi';
  }

  @override
  String get shoppingNewHint => 'Yangi mahsulot';

  @override
  String get shoppingAdd => 'Qoʻshish';

  @override
  String get shoppingEmpty =>
      'Roʻyxat boʻsh. Keraklilarni shu yerga yozib qoʻy.';

  @override
  String get shoppingAreaOther => 'Boshqa';

  @override
  String get shoppingFromCheck => 'Tekshirish boʻlimidan';

  @override
  String shoppingRemove(String title) {
    return 'Oʻchirish: $title';
  }

  @override
  String get shoppingRemoveBought => 'Olinganlarni oʻchirish';

  @override
  String shoppingFull(int count) {
    return 'Roʻyxatda koʻpi bilan $count ta mahsulot boʻlishi mumkin.';
  }

  @override
  String get careListSynced =>
      'Tanlovlaring va xarid roʻyxating serverda shifrlangan holda saqlanadi, shu telefonda esa oflayn foydalanish uchun nusxasi qoladi.';

  @override
  String get careListDevice =>
      'Tanlovlaring va xarid roʻyxating hozircha faqat shu telefonda saqlanadi. Yangilangan sogʻliq roziligi bilan serverda shifrlangan holda saqlanadi.';

  @override
  String get shopTitle => 'Parla Doʻkon';

  @override
  String get shopBody =>
      'Tartibingdagi mahsulotlar — bir teginishda. Xarid roʻyxatingni toʻgʻridan-toʻgʻri buyurtma qila, tanlovlaringga mos mahsulotlarni topa olasan.';

  @override
  String get shopSoonCard => 'Parla Doʻkon';

  @override
  String get shopSoonCardBody => 'Hamkorlar mahsulotlarini koʻr';

  @override
  String get shopOpenList => 'Xarid roʻyxatimni koʻrish';

  @override
  String get shopIntro =>
      'Hamkorlar mahsulotlari. Xarid hamkor saytida amalga oshadi; Parla sen haqingda hech narsa uzatmaydi.';

  @override
  String get shopAll => 'Hammasi';

  @override
  String get shopCategoryFace => 'Yuz';

  @override
  String get shopCategoryHair => 'Soch';

  @override
  String get shopCategoryBody => 'Tana';

  @override
  String get shopCategoryMakeup => 'Makiyaj';

  @override
  String get shopCategoryOther => 'Boshqa';

  @override
  String shopPrice(String price) {
    return '$price ₼';
  }

  @override
  String get shopVisitPartner => 'Hamkor saytiga oʻtish';

  @override
  String get shopPriceNote =>
      'Narx va mavjudlik hamkor saytida oʻzgarishi mumkin. Xarid qilishdan oldin tarkibini tekshir; terida muammo boʻlsa, shifokor bilan maslahatlash.';

  @override
  String get shopEmpty => 'Hali mahsulot yoʻq. Tez orada shu yerda boʻladi.';

  @override
  String get shopMyOrders => 'Buyurtmalarim';

  @override
  String get shopBuy => 'Sotib olish';

  @override
  String get shopBuyTitle => 'Buyurtmani tasdiqlash';

  @override
  String shopBuyBody(String product, String price, String seller) {
    return '$product: $price. $seller Toʻlov Epoint sahifasida amalga oshadi; karta maʼlumotlaring Parlaga kelmaydi.';
  }

  @override
  String get shopSellerParla => 'Sotuvchi: Parla.';

  @override
  String shopSellerBrand(String brand) {
    return 'Sotuvchi: $brand, toʻlovni Parla qabul qiladi.';
  }

  @override
  String get shopBuyGo => 'Toʻlovga oʻtish';

  @override
  String get shopBuyError =>
      'Toʻlov sahifasi ochilmadi. Birozdan soʻng qayta urinib koʻr.';

  @override
  String get shopTooMany =>
      'Soʻnggi bir soatda juda koʻp buyurtma boshlading. Birozdan soʻng qayta urinib koʻr.';

  @override
  String get shopOrdersEmpty => 'Hali buyurtmang yoʻq.';

  @override
  String shopOrderMeta(String number, String date, int quantity) {
    return '$number · $date · $quantity dona';
  }

  @override
  String get shopOrderCreated => 'Toʻlov kutilmoqda';

  @override
  String get shopOrderPaid => 'Toʻlangan';

  @override
  String get shopOrderFailed => 'Toʻlov amalga oshmadi';

  @override
  String get shopOrderShipped => 'Joʻnatilgan';

  @override
  String get shopOrderDelivered => 'Yetkazilgan';

  @override
  String get shopOrderCancelled => 'Bekor qilingan';

  @override
  String get shopOrderRefunded => 'Pul qaytarilgan';

  @override
  String get sportIntroTitle => 'Senga mos sport rejasi';

  @override
  String get sportIntroBody =>
      'Bir nechta savol: maqsad, sohalar, yoqtirgan mashgʻulotlaring. Keyin haftalik reja, setlar va takrorlar soni, taymer. Musiqa oʻz ilovangdan chaladi.';

  @override
  String get sportStart => 'Boshlash';

  @override
  String get sportNext => 'Davom';

  @override
  String get sportNeedOne => 'Kamida bittasini tanla.';

  @override
  String get sportQGoals => 'Maqsading nima?';

  @override
  String get sportQGoalsHint => '2 tagacha tanla';

  @override
  String get sportGoalTone => 'Tonus va taranglik';

  @override
  String get sportGoalMuscle => 'Mushak massasini oshirish';

  @override
  String get sportGoalFlexibility => 'Egiluvchanlik';

  @override
  String get sportGoalPosture => 'Qad-qomat';

  @override
  String get sportGoalEndurance => 'Chidamlilik';

  @override
  String get sportGoalRelax => 'Stressdan xalos boʻlish';

  @override
  String get sportQAreas => 'Qaysi sohalarga eʼtibor qaratamiz?';

  @override
  String get sportAreasNote =>
      'Bir joydan yogʻ yoqib boʻlmaydi. Bu harakatlar oʻsha mushaklarni kuchaytiradi va tonus beradi.';

  @override
  String get sportAreaArms => 'Qoʻllar';

  @override
  String get sportAreaLegs => 'Oyoqlar';

  @override
  String get sportAreaCore => 'Qorin va kor';

  @override
  String get sportAreaGlutes => 'Dumba';

  @override
  String get sportAreaBack => 'Orqa';

  @override
  String get sportAreaFull => 'Butun tana';

  @override
  String get sportQTypes => 'Qanday mashgʻulotlarni xohlaysan?';

  @override
  String get sportTypeFitness => 'Fitnes';

  @override
  String get sportTypePilates => 'Pilates';

  @override
  String get sportTypeWallPilates => 'Devor pilatesi';

  @override
  String get sportTypeStretching => 'Stretching';

  @override
  String get sportTypeCardio => 'Yengil kardio';

  @override
  String get sportTypeFaceYoga => 'Yuz yogasi';

  @override
  String get sportTypeYoga => 'Yoga';

  @override
  String get sportYogaMorning => 'Ertalabki oqim';

  @override
  String get sportYogaEvening => 'Kechki osoyishtalik';

  @override
  String get sportYogaStretch => 'Choʻzilish va boʻshashish';

  @override
  String sportSessionCardBody(int count, int minutes) {
    return '$count ta harakat · taxminan $minutes daq';
  }

  @override
  String get sportYogaSafetyTitle => 'Boshlashdan oldin';

  @override
  String get sportYogaSafetyBody =>
      'Sekin harakat qil, nafasingni ushlab turma, ogʻriq boʻlsa, toʻxta. Homiladorlikda, yuqori qon bosimida, bel, tizza yoki bilak jarohatida avval shifokorga murojaat qil. Soʻrovnomada jarohat yoki homiladorlikni belgilagan boʻlsang, senga mos kelmaydigan holatlar seansdan olib tashlanadi.';

  @override
  String sportFaceYogaCardBody(int minutes) {
    return '12 ta harakat · taxminan $minutes daq. Koʻzgu oldida, istalgan vaqtda.';
  }

  @override
  String get sportFaceYogaSafetyTitle => 'Boshlashdan oldin';

  @override
  String get sportFaceYogaSafetyBody =>
      'Qoʻllaringizni yuving, teriga faqat yengil teging, terini tortmang. Ogʻriq yoki noqulaylik boʻlsa, toʻxtating. Yaqinda kosmetik muolaja (botoks, filler) olgan boʻlsangiz, jagʻ boʻgʻimida yoki terida muammo boʻlsa, avval shifokorga murojaat qiling.';

  @override
  String get sportQLevel => 'Darajang qanday?';

  @override
  String get sportLevelBeginner => 'Endi boshlayapman';

  @override
  String get sportLevelIntermediate => 'Oʻrta';

  @override
  String get sportLevelAdvanced => 'Tajribali';

  @override
  String get sportQSchedule => 'Qancha vaqting bor?';

  @override
  String get sportDaysLabel => 'Haftada necha kun';

  @override
  String get sportMinutesLabel => 'Bitta mashgʻulot';

  @override
  String sportDays(int count) {
    return '$count kun';
  }

  @override
  String sportMinutes(int count) {
    return '$count daq';
  }

  @override
  String get sportDumbbells => 'Uyda gantelim bor';

  @override
  String get sportQSafety => 'Xavfsizlik uchun';

  @override
  String get sportSafetyIntro =>
      'Bu javoblar faqat senga mos kelmaydigan harakatlarni rejadan olib tashlash uchun.';

  @override
  String get sportPregnancyLabel => 'Homiladorlik';

  @override
  String get sportPregNo => 'Yoʻq';

  @override
  String get sportPregPregnant => 'Homiladorman';

  @override
  String get sportPregPostpartum => 'Soʻnggi 6 oyda tugʻganman';

  @override
  String get sportInjuriesLabel => 'Ogʻriq yoki jarohat';

  @override
  String get sportInjKnee => 'Tizza';

  @override
  String get sportInjBack => 'Bel';

  @override
  String get sportInjShoulder => 'Yelka';

  @override
  String get sportInjWrist => 'Bilak';

  @override
  String get sportDoctorLimit =>
      'Shifokor sportni cheklagan yoki avval maslahatlashishni aytgan';

  @override
  String get sportBuildPlan => 'Rejani tuzish';

  @override
  String get sportWeekTitle => 'Bu hafta';

  @override
  String sportWeekProgress(int done, int total) {
    return '$done / $total mashgʻulot';
  }

  @override
  String sportWorkoutTitle(int number) {
    return 'Mashgʻulot $number';
  }

  @override
  String get sportWorkoutName_w6 => 'Yengil choʻzilish';

  @override
  String get sportWorkoutName_w7 => 'Hafta finali';

  @override
  String get sportWorkoutName_p6 => 'Yumshoq oqim';

  @override
  String get sportWorkoutName_p7 => 'Markaz finali';

  @override
  String get sportWorkoutName_v6 => 'Devorda boʻshashish';

  @override
  String get sportWorkoutName_v7 => 'Devor finali';

  @override
  String get sportEveryDay => 'Har kuni';

  @override
  String get sportWeekdaysLabel => 'Qaysi kunlar?';

  @override
  String sportWeekdaysHint(int count) {
    return '$count kun tanla. Oradagi kunlar — dam olish.';
  }

  @override
  String get sportEveryDayNote =>
      'Har kuni: mushaklar tiklanishi uchun haftada ikki kun yengil choʻzilish boʻladi.';

  @override
  String sportWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(
      day,
      {
        '1': 'Du',
        '2': 'Se',
        '3': 'Ch',
        '4': 'Pa',
        '5': 'Ju',
        '6': 'Sh',
        'other': 'Ya',
      },
    );
    return '$_temp0';
  }

  @override
  String sportPickWeekdays(int count) {
    return 'Aynan $count kun tanla.';
  }

  @override
  String get sportMonthTitle => 'Oylik reja';

  @override
  String sportMonthProgress(int day, int week) {
    return 'Kun $day / 28 · Hafta $week';
  }

  @override
  String get sportLegendDone => 'bajarildi';

  @override
  String get sportLegendWorkout => 'mashgʻulot';

  @override
  String get sportLegendRest => 'dam olish';

  @override
  String get sportToday => 'Bugun';

  @override
  String get sportRestToday => 'Bugun dam olish kuni';

  @override
  String sportNextOn(String when) {
    return 'Keyingi mashgʻulot: $when';
  }

  @override
  String sportWeekBadge(int week) {
    return 'Hafta $week';
  }

  @override
  String get sportRecoveryWeek => 'Tiklanish haftasi';

  @override
  String sportCardMeta(int minutes, int moves) {
    return '$minutes daq · $moves ta harakat';
  }

  @override
  String get sportMonthDoneTitle => 'Oy yakunlandi';

  @override
  String sportMonthDoneBody(int done) {
    return '$done ta mashgʻulot bajarildi. Keyingi oydan oldin javoblaring va darajangni tekshirib olaylik.';
  }

  @override
  String get sportNewMonth => 'Keyingi oy';

  @override
  String sportMonthCalendar(int done, int left) {
    return 'Oy taqvimi: $done ta mashgʻulot bajarildi, $left ta qoldi';
  }

  @override
  String get sportWorkoutName_w1 => 'Kuchli start';

  @override
  String get sportWorkoutName_w2 => 'Oyoq kuni';

  @override
  String get sportWorkoutName_w3 => 'Butun tana';

  @override
  String get sportWorkoutName_w4 => 'Energiya toʻlqini';

  @override
  String get sportWorkoutName_w5 => 'Kuch va muvozanat';

  @override
  String get sportWorkoutName_p1 => 'Markaz uygʻonishi';

  @override
  String get sportWorkoutName_p2 => 'Yumshoq oqim';

  @override
  String get sportWorkoutName_p3 => 'Qad-qomat va nafas';

  @override
  String get sportWorkoutName_p4 => 'Uzun chiziqlar';

  @override
  String get sportWorkoutName_p5 => 'Osoyishta kuch';

  @override
  String get sportWorkoutName_v1 => 'Devor bilan tanishuv';

  @override
  String get sportWorkoutName_v2 => 'Devor tayanchi';

  @override
  String get sportWorkoutName_v3 => 'Devorda oqim';

  @override
  String get sportWorkoutName_v4 => 'Devor ritmi';

  @override
  String get sportWorkoutName_v5 => 'Devor muvozanati';

  @override
  String sportWorkoutMeta(String type, int minutes) {
    return '$type · ~$minutes daq';
  }

  @override
  String get sportDone => 'Bajarildi';

  @override
  String get sportNextLabel => 'Keyingi';

  @override
  String get sportEditAnswers => 'Soʻrovnomani yangilash';

  @override
  String get sportBlockedTitle => 'Avval shifokoring bilan gaplash';

  @override
  String get sportBlockedBody =>
      'Shifokor sportni cheklagan boʻlsa, reja tuzmaymiz. Ruxsat olganingda soʻrovnomani yangila.';

  @override
  String get sportGentleNote =>
      'Homiladorlik va tugʻruqdan keyingi davr uchun yengil reja. Boshlashdan oldin shifokoringdan soʻra.';

  @override
  String get sportDraftNote =>
      'Harakatlar va sonlar hali murabbiy tomonidan tekshirilmagan. Ogʻriq sezsang, toʻxta.';

  @override
  String get sportAllDone => 'Bu haftaning barcha mashgʻulotlari bajarildi.';

  @override
  String sportSetsReps(int sets, int reps) {
    return '$sets × $reps takror';
  }

  @override
  String sportSetsSeconds(int sets, int seconds) {
    return '$sets × $seconds son';
  }

  @override
  String sportRestSeconds(int seconds) {
    return 'Dam olish $seconds son';
  }

  @override
  String get sportStartWorkout => 'Mashgʻulotni boshlash';

  @override
  String get sportMusicNote =>
      'Videolarning oʻz musiqasi bor, uni tugma bilan oʻchirib qoʻyishing mumkin. Parla signal ham beradi.';

  @override
  String get sportVideoSoundOn => 'Video ovozi yoqilgan';

  @override
  String get sportVideoSoundOff => 'Video ovozi oʻchirilgan';

  @override
  String get sportSoundOn => 'Signal ovozi yoqilgan';

  @override
  String get sportSoundOff => 'Signal ovozi oʻchirilgan, faqat tebranish';

  @override
  String sportSetOf(int set, int sets) {
    return 'Set $set / $sets';
  }

  @override
  String sportRepsNow(int reps) {
    return '$reps takror';
  }

  @override
  String get sportPause => 'Pauza';

  @override
  String get sportResume => 'Davom';

  @override
  String get sportResting => 'Dam olish';

  @override
  String sportNextUp(String name) {
    return 'Keyin: $name';
  }

  @override
  String sportExerciseOf(int index, int total) {
    return 'Harakat $index / $total';
  }

  @override
  String get sportFinishedTitle => 'Mashgʻulot tugadi';

  @override
  String sportFinishedBody(int minutes) {
    return '$minutes daqiqalik harakat bugungi yozuvga qoʻshildi.';
  }

  @override
  String get sportBackToPlan => 'Rejaga qaytish';

  @override
  String get sportQuit => 'Mashgʻulotni toʻxtatish';

  @override
  String get sportGetReady => 'Tayyorlan';

  @override
  String get sportPrevious => 'Oldingi harakat';

  @override
  String get sportNextMove => 'Keyingi';

  @override
  String get sportStopTitle => 'Mashgʻulotni toʻxtatamizmi?';

  @override
  String get sportStopBody => 'Bu mashgʻulot bajarilgan deb belgilanmaydi.';

  @override
  String get sportStopConfirm => 'Toʻxtatish';

  @override
  String get sportKeepGoing => 'Davom etish';

  @override
  String sportRepPace(int seconds) {
    return 'Har bir takror taxminan $seconds son. Tezroq tugatsang, “Keyingi”ni bos.';
  }

  @override
  String get sportPrivacySynced =>
      'Sport javoblaring serverda shifrlangan holda saqlanadi, shu telefonda esa oflayn foydalanish uchun nusxasi qoladi.';

  @override
  String get sportPrivacyDevice =>
      'Sport javoblaring hozircha faqat shu telefonda saqlanadi. Yangilangan sogʻliq roziligi bilan serverda shifrlangan holda saqlanadi.';

  @override
  String get discoverLatest => 'Yangi maqolalar';

  @override
  String get discoverAll => 'Hammasi';

  @override
  String get expertSample => 'Namuna';

  @override
  String get expertSampleNote =>
      'Bu namuna profil, aloqa maʼlumotlari ishlamaydi.';

  @override
  String get discoverJournal => 'Kundalik';

  @override
  String get discoverJournalHint => 'Faqat sen uchun, shu telefonda';

  @override
  String get journalIntro =>
      'Kuning haqida yoz. Yozuvlar faqat shu telefonda, shifrlangan holda saqlanadi; Parla jamoasi ularni koʻrmaydi. Telefonni almashtirganingda yoki ilovani oʻchirganingda yoʻqoladi. Saqlab qolish uchun: Profil → Maʼlumotlarimni yuklab olish.';

  @override
  String get journalNew => 'Yangi yozuv';

  @override
  String get journalEmpty => 'Hali yozuv yoʻq.';

  @override
  String get journalHint => 'Bugun qanday oʻtdi?';

  @override
  String get journalEntryTitle => 'Yozuv';

  @override
  String get journalSave => 'Saqlash';

  @override
  String get journalDelete => 'Oʻchirish';

  @override
  String get journalDeleteTitle => 'Bu yozuv oʻchirilsinmi?';

  @override
  String get journalDeleteBody => 'Uni qaytarib boʻlmaydi.';

  @override
  String get journalFull =>
      'Kundalik toʻldi. Yangi yozuv uchun eskilaridan birini oʻchir.';

  @override
  String get discoverSportHint => 'Haftalik rejang';

  @override
  String discoverArticleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta maqola',
    );
    return '$_temp0';
  }

  @override
  String discoverRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta retsept',
    );
    return '$_temp0';
  }

  @override
  String get contentEmpty => 'Hali maqola yoʻq. Tez orada shu yerda boʻladi.';

  @override
  String get contentOffline =>
      'Internet yoʻq, oxirgi yuklangan nusxa koʻrsatilmoqda.';

  @override
  String blogMeta(String category, int minutes) {
    return '$category · $minutes daq';
  }

  @override
  String blogReviewed(String date) {
    return 'Mutaxassis tekshirgan · $date';
  }

  @override
  String get blogTips => 'Qisqa qadamlar';

  @override
  String get catCare => 'Parvarish';

  @override
  String get catBeauty => 'Goʻzallik';

  @override
  String get catFashion => 'Moda';

  @override
  String get catHair => 'Soch';

  @override
  String get specDermatologist => 'Dermatolog';

  @override
  String get specCosmetologist => 'Kosmetolog';

  @override
  String get specTrainer => 'Murabbiy';

  @override
  String get specDietitian => 'Dietolog';

  @override
  String get specTrichologist => 'Trixolog';

  @override
  String expertYears(int years) {
    return '$years yillik tajriba';
  }

  @override
  String get expertCall => 'Qoʻngʻiroq qilish';

  @override
  String get expertWhatsapp => 'WhatsApp';

  @override
  String get expertInstagram => 'Instagram';

  @override
  String get expertsNote =>
      'Parla mutaxassislar bilan faqat tanishtiradi, ularning xizmatlari uchun javobgar emas. Aloqa ilovadan tashqarida, bevosita mutaxassis bilan oʻrnatiladi; Parla suhbatni koʻrmaydi.';

  @override
  String get nutritionHero => 'Goʻzallik likopchadan boshlanadi';

  @override
  String get nutritionPlate => 'Bugungi likopcha';

  @override
  String nutritionPlateCount(int count, int total) {
    return '$count / $total guruh';
  }

  @override
  String get groupVegetables => 'Sabzavot';

  @override
  String get groupFruit => 'Meva';

  @override
  String get groupProtein => 'Oqsil';

  @override
  String get groupWholeGrain => 'Butun don';

  @override
  String get groupHealthyFat => 'Sogʻlom yogʻ';

  @override
  String get groupDairy => 'Sut mahsuloti';

  @override
  String nutritionWater(int count, int goal) {
    return 'Suv: $count / $goal stakan';
  }

  @override
  String get nutritionNoCalories =>
      'Likopchada kaloriya sanamaymiz. Faqat xilma-xillik: har kuni rang-barang likopcha.';

  @override
  String get nutritionTip => 'Kun maslahati';

  @override
  String get nutritionRecipes => 'Goʻzallik retseptlari';

  @override
  String get nutritionDisclaimer =>
      'Bu umumiy maʼlumot, parhez yoki tibbiy tavsiya emas. Maxsus ovqatlanish ehtiyojing boʻlsa, dietolog bilan maslahatlash.';

  @override
  String get nutritionPrivacySynced =>
      'Likopcha yozuvlaring serverda shifrlangan holda saqlanadi, shu telefonda esa oflayn foydalanish uchun nusxasi qoladi.';

  @override
  String get nutritionPrivacyDevice =>
      'Likopcha yozuvlaring hozircha faqat shu telefonda saqlanadi. Yangilangan sogʻliq roziligi bilan serverda shifrlangan holda saqlanadi.';

  @override
  String get mealBreakfast => 'Nonushta';

  @override
  String get mealLunch => 'Tushlik';

  @override
  String get mealDinner => 'Kechki ovqat';

  @override
  String get mealSnack => 'Tamaddi';

  @override
  String recipeMeta(String meal, int minutes, int servings) {
    return '$meal · $minutes daq · $servings kishilik';
  }

  @override
  String get recipeIngredients => 'Masalliqlar';

  @override
  String get recipeSteps => 'Tayyorlanishi';

  @override
  String get recipeAddAll => 'Masalliqlarni xarid roʻyxatiga qoʻshish';

  @override
  String get recipeSave => 'Retseptni saqlash';

  @override
  String get recipeUnsave => 'Saqlanganlardan olib tashlash';

  @override
  String get nutritionDailyRecipe => 'Bugungi tavsiya';

  @override
  String get nutritionPlateIdeas => 'Likopchangni toʻldir';

  @override
  String get nutritionPlateIdeasNote =>
      'Bugun hali tanlamagan guruhlaring uchun retseptlar.';

  @override
  String get nutritionSaved => 'Saqlaganlaring';

  @override
  String recipeKcal(int kcal) {
    return '≈ $kcal kkal · 1 porsiya (taxminiy)';
  }

  @override
  String recipeAdded(int count) {
    return '$count ta mahsulot xarid roʻyxatiga qoʻshildi.';
  }

  @override
  String get skinCardTitle => 'Teri tahlili';

  @override
  String get skinCardBody =>
      'Savollarga javob berib, teringni qayta tahlil qil.';

  @override
  String get catBody => 'Tana';

  @override
  String get blogSources => 'Manbalar';

  @override
  String get blogRelated => 'Oʻxshash maqolalar';

  @override
  String recipeAllergens(String list) {
    return 'Tarkibida: $list';
  }

  @override
  String get recipeNoAllergens => '14 ta asosiy allergendan hech biri yoʻq.';

  @override
  String get allergenGluten => 'glyuten';

  @override
  String get allergenCrustaceans => 'qisqichbaqasimonlar';

  @override
  String get allergenEgg => 'tuxum';

  @override
  String get allergenFish => 'baliq';

  @override
  String get allergenPeanuts => 'yeryongʻoq';

  @override
  String get allergenSoy => 'soya';

  @override
  String get allergenMilk => 'sut';

  @override
  String get allergenNuts => 'yongʻoqlar';

  @override
  String get allergenCelery => 'selderey';

  @override
  String get allergenMustard => 'xantal';

  @override
  String get allergenSesame => 'kunjut';

  @override
  String get allergenSulphites => 'sulfitlar';

  @override
  String get allergenLupin => 'lyupin';

  @override
  String get allergenMolluscs => 'mollyuskalar';

  @override
  String bannerAd(String brand) {
    return 'Reklama · $brand';
  }

  @override
  String get bannerLeaveTitle => 'Boshqa saytga oʻtyapsan';

  @override
  String bannerLeaveBody(String host) {
    return '$host sayti brauzerda ochiladi. Parla bu saytga sen haqingda hech qanday maʼlumot yubormaydi; saytning oʻz maxfiylik qoidalari bor.';
  }

  @override
  String get bannerLeaveGo => 'Saytga oʻtish';

  @override
  String get bannerLeaveCancel => 'Bekor qilish';

  @override
  String get messagesTitle => 'Xabarlar';

  @override
  String get messagesButton => 'Xabarlar';

  @override
  String get messagesButtonUnread => 'Xabarlar, yangi javob bor';

  @override
  String get messagesFromParla => 'Parladan';

  @override
  String get messagesNone => 'Hali eʼlon yoʻq.';

  @override
  String get supportTitle => 'Yordam';

  @override
  String get supportIntro =>
      'Savolingni yoz, Parla jamoasi javob beradi. Xabarlar shifrlangan holda saqlanadi va oxirgi xabardan 12 oy oʻtgach oʻchiriladi. Biz tibbiy maslahat bermaymiz: shoshilinch yoki jiddiy holatda shifokorga murojaat qil.';

  @override
  String get supportHint => 'Xabaring';

  @override
  String get supportSend => 'Yuborish';

  @override
  String get supportYou => 'Sen';

  @override
  String get supportTeam => 'Parla jamoasi';

  @override
  String get supportSent => 'Yuborildi.';

  @override
  String get pushTitle => 'Bildirishnomalar';

  @override
  String get pushBody =>
      'Yordam xizmati javob berganda xabar olasan. Marketing roziligini bersang, Parlaning yangiliklari ham keladi. Istalgan vaqtda oʻchirib qoʻyishing mumkin.';

  @override
  String get pushDenied =>
      'Bildirishnomalarga ruxsat berilmadi. Telefon sozlamalarida yoqishing mumkin.';

  @override
  String get checkSuggestTitle => 'Testingga koʻra taklif';

  @override
  String get checkSuggestBody =>
      'Test javoblaringga koʻra bu tanlovlar senga mos kelishi mumkin. Qoʻshish-qoʻshmaslik — sening qaroring.';

  @override
  String checkSuggestAdd(String name) {
    return '$name qoʻshish';
  }

  @override
  String get consentRefreshCardTitle => 'Rozilik matni yangilandi';

  @override
  String get consentRefreshCardBody =>
      'Sogʻliq maʼlumotlari roziligining yangi versiyasi bor. Oʻqib rozi boʻlsang, tartiblaring, roʻyxatlaring, sport va ovqatlanish yozuvlaring shifrlangan serverda ham saqlanadi. Rozi boʻlmasang, ular faqat shu telefonda qoladi.';

  @override
  String get consentRefreshOpen => 'Oʻqish';

  @override
  String get consentRefreshTitle => 'Sogʻliq maʼlumotlari roziligi';

  @override
  String get consentRefreshIntro =>
      'Bu avval rozi boʻlgan matningning yangi versiyasi. Rozi boʻlish ixtiyoriy; istalgan vaqtda Maxfiylik boʻlimida qaytarib olishing mumkin.';

  @override
  String get consentRefreshAgree => 'Roziman';

  @override
  String get consentRefreshLater => 'Hozir emas';

  @override
  String get consentRefreshDone => 'Rozilik yangilandi.';

  @override
  String get appearanceTitle => 'Koʻrinish';

  @override
  String get appearanceSystem => 'Tizim';

  @override
  String get appearanceLight => 'Yorugʻ';

  @override
  String get appearanceDark => 'Qorongʻi';
}
