// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

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
  String get continueButton => 'Devam et';

  @override
  String get welcomeTitle => 'Kişisel bakım rehberiniz';

  @override
  String get welcomeBody1 =>
      'Cildiniz, saçınız ve vücudunuz için uzmanların kontrol ettiği rutinler.';

  @override
  String get welcomeBody2 =>
      'Ürünü tarayın ve her içeriğin ne işe yaradığını resmi kaynaklarla görün.';

  @override
  String get welcomeBody3 =>
      'Uyku, su ve hareket: küçük alışkanlıklar tek bir yerde.';

  @override
  String get welcomeStart => 'Başla';

  @override
  String get welcomeBrowse => 'Hesapsız göz at';

  @override
  String get welcomeSignIn => 'Zaten hesabım var';

  @override
  String get ageTitle => 'Hangi yıl doğdunuz?';

  @override
  String get ageWhy =>
      'Parla 18 yaş ve üzeri içindir. Yalnızca yılı saklarız, tam tarihi değil.';

  @override
  String get ageYearLabel => 'Doğum yılı';

  @override
  String get ageInvalid => '1900 ile bu yıl arasında bir yıl girin.';

  @override
  String get ageBirthdayQuestion => 'Bu yıl doğum gününüz geçti mi?';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get underageTitle => 'Parla yetişkinler içindir';

  @override
  String get underageBody =>
      'Parla yalnızca 18 yaş ve üzeri kişiler tarafından kullanılabilir. Girdiğiniz hiçbir bilgi saklanmadı.';

  @override
  String get close => 'Kapat';

  @override
  String get signInTitle => 'Giriş yapın veya hesap oluşturun';

  @override
  String get signInBody =>
      'E-postanıza tek kullanımlık bir kod göndereceğiz. Şifre gerekmez.';

  @override
  String get signInFailed => 'Giriş yapılamadı. Tekrar deneyin.';

  @override
  String get signInLegalNote =>
      'Hesap oluşturarak Kullanım koşullarını kabul etmiş olursunuz. Verilerinizin nasıl işlendiği Gizlilik politikasında açıklanır.';

  @override
  String get countryTitle => 'Nerede yaşıyorsunuz?';

  @override
  String get countryWhy =>
      'Verileriniz ülkenizin bölgesinde saklanır. Parla önce Azerbaycan\'da açılıyor.';

  @override
  String get countryComingSoon => 'Yakında';

  @override
  String get countryName_AZ => 'Azerbaycan';

  @override
  String get countryName_TR => 'Türkiye';

  @override
  String get countryName_KZ => 'Kazakistan';

  @override
  String get countryName_UZ => 'Özbekistan';

  @override
  String get consentTitle => 'Tercihleriniz';

  @override
  String get consentIntro =>
      'Her onay ayrıdır ve varsayılan olarak kapalıdır. Uygulama onlar olmadan da çalışır. Bunları istediğiniz zaman Ayarlar → Gizlilik bölümünden değiştirebilirsiniz.';

  @override
  String get consentHealthTitle => 'Sağlıkla ilgili yanıtlar';

  @override
  String get consentHealthHint =>
      'Yalnızca cilt rahatsızlıkları, alerjiler, hamilelik ve ilaçlarla ilgili isteğe bağlı sorular için gereklidir.';

  @override
  String get consentAnalyticsTitle => 'Kullanım istatistikleri';

  @override
  String get consentMarketingTitle => 'E-postayla yenilikler ve öneriler';

  @override
  String consentVersion(String version) {
    return 'Metin sürümü: $version';
  }

  @override
  String get guestTitle => 'Ürün arama';

  @override
  String get guestPlaceholder =>
      'Ürün arama ve tarama bir sonraki sürümde eklenecek.';

  @override
  String get errorGeneric => 'Bir hata oluştu. Tekrar deneyin.';

  @override
  String get error_age_minor =>
      'Parla yalnızca 18 yaş ve üzeri kişiler tarafından kullanılabilir.';

  @override
  String get error_age_needs_confirmation => 'Doğum günü sorusunu yanıtlayın.';

  @override
  String get error_age_invalid => 'Geçerli bir doğum yılı girin.';

  @override
  String get error_country_closed => 'Parla bu ülkede henüz açılmadı.';

  @override
  String get error_language_unsupported => 'Bu dil henüz desteklenmiyor.';

  @override
  String get error_profile_exists => 'Profiliniz zaten var.';

  @override
  String get error_consent_outdated_version =>
      'Onay metni değişti. Lütfen tekrar gözden geçirin.';

  @override
  String get homeGreetingMorning => 'Günaydın!';

  @override
  String get homeGreetingAfternoon => 'İyi günler!';

  @override
  String get homeGreetingEvening => 'İyi akşamlar!';

  @override
  String get homeTagline => 'Her gün biraz daha sen.';

  @override
  String get homeProfileButton => 'Profil ve gizlilik';

  @override
  String get routineSwitchLabel => 'Rutin seçimi';

  @override
  String get routineMorning => 'Sabah';

  @override
  String get routineEvening => 'Akşam';

  @override
  String get routineMorningTitle => 'Sabah rutini';

  @override
  String get routineEveningTitle => 'Akşam rutini';

  @override
  String get stepStatusDone => 'Tamam';

  @override
  String stepMarkDone(String step) {
    return '$step: tamamla';
  }

  @override
  String stepMarkUndone(String step) {
    return '$step: tamamlandı, geri al';
  }

  @override
  String routineDoneHeader(String routine) {
    return '$routine hazır';
  }

  @override
  String get routineDoneTitle => 'Bugün de parladın.';

  @override
  String get routineDoneBody =>
      'Tüm adımlar tamam. Bir sonraki rutinde görüşürüz.';

  @override
  String get routineRestart => 'Yeniden başla';

  @override
  String get habitsTitle => 'Bugünün alışkanlıkları';

  @override
  String get habitWater => 'Su';

  @override
  String habitWaterCount(int count, int goal) {
    return '$count / $goal bardak';
  }

  @override
  String get habitWaterAdd => 'Bir bardak ekle';

  @override
  String get habitWaterRemove => 'Bir bardak çıkar';

  @override
  String get habitSleep => 'Uyku';

  @override
  String get habitMove => 'Hareket';

  @override
  String get habitNoEntry => 'Henüz kayıt yok';

  @override
  String get habitLog => 'Kaydet';

  @override
  String get navMenuLabel => 'Ana menü';

  @override
  String get navToday => 'Bugün';

  @override
  String get comingSoon => 'Bu bölüm bir sonraki sürümde eklenecek.';

  @override
  String get routineMorningEyebrow => 'SABAH RUTİNİ';

  @override
  String get routineEveningEyebrow => 'AKŞAM RUTİNİ';

  @override
  String get routineStatusStart => 'Başlayalım';

  @override
  String routineStatusLeft(int left) {
    return '$left adım kaldı';
  }

  @override
  String get routineStatusDone => 'Hepsi tamam';

  @override
  String routineMinutesLeft(int minutes) {
    return 'Yaklaşık $minutes dakika';
  }

  @override
  String routineProgressLabel(String routine, int done, int total) {
    return '$routine: $done / $total adım tamamlandı';
  }

  @override
  String get quizIntroTitle => 'Haydi tanışalım.';

  @override
  String get quizIntroBody =>
      'Cildiniz, saçınız ve günlük ritminiz hakkında birkaç soru. Yaklaşık 3 dakika sürer.';

  @override
  String get quizStart => 'Başlayalım';

  @override
  String get quizLater => 'Sonra';

  @override
  String quizProgress(int current, int total) {
    return 'Soru $current / $total';
  }

  @override
  String get quizMultipleHint => 'Birden fazla seçebilirsiniz';

  @override
  String get quizNext => 'İleri';

  @override
  String get quizBack => 'Geri';

  @override
  String get quizDecline => 'Yanıtlamak istemiyorum';

  @override
  String get quizFinish => 'Bitir';

  @override
  String get healthGateTitle => 'Birkaç hassas soru';

  @override
  String get healthGateBody =>
      'Sonraki sorular cilt teşhisleri, alerjiler, hamilelik ve ilaçlarla ilgili. Rutininizi güvenli hale getirmeye yardımcı olurlar. Yanıtlarınız şifrelenir ve yalnızca onayınızla saklanır.';

  @override
  String get healthGateAgree => 'Onaylıyorum, devam et';

  @override
  String get healthGateSkip => 'Bu bölümü atla';

  @override
  String get healthGateSkipNote =>
      'Atlarsanız rutininiz daha temkinli oluşturulur.';

  @override
  String get redFlagTitle => 'Bunu bir doktora gösterin';

  @override
  String get redFlagBody =>
      'Belirttiğiniz belirti doktor muayenesi gerektirebilir. Parla teşhis koymaz ve doktorun yerini tutmaz. Bir dermatoloğa başvurmanızı öneririz.';

  @override
  String get redFlagOk => 'Anladım';

  @override
  String get resultTitle => 'Rutininiz hazır';

  @override
  String get resultSkin => 'Cilt';

  @override
  String get resultHair => 'Saç';

  @override
  String get resultGoals => 'Endişeler';

  @override
  String get resultSeeRoutine => 'Rutinimi göster';

  @override
  String get recheckTitle => 'Yanıtın hâlâ aynı mı?';

  @override
  String recheckSkinBody(String answer, int months) {
    return 'Testte hamilelikle ilgili yanıtın: “$answer”. Bunu $months ay önce belirtmiştin; rutinin buna göre oluşturuluyor.';
  }

  @override
  String recheckSportBody(String answer, int months) {
    return 'Spor sorularındaki yanıtın: “$answer”. Bunu $months ay önce belirtmiştin; planın bu yüzden hafif.';
  }

  @override
  String get recheckYes => 'Evet, aynı';

  @override
  String get recheckChange => 'Değişti';

  @override
  String get recheckRemove => 'Yanıtı sil';

  @override
  String get recheckChooseTitle => 'Şimdi nasıl?';

  @override
  String get recheckSaved => 'Kaydedildi.';

  @override
  String get recheckPrivacy =>
      'Yanıt şifreli saklanır ve yalnızca rutinin ve planın için kullanılır. Yanıtı silersen rutinin temkinli kalır.';

  @override
  String get homeFocusTitle => 'Günün odağı';

  @override
  String get homeFocusSub => 'Rutinine göre';

  @override
  String get homeFocusDone => 'Bugünün rutini tamam. Kendine biraz zaman ayır.';

  @override
  String get homeFocusOpen => 'Rutini aç';

  @override
  String homeFocusSteps(int done, int total) {
    return '$done / $total adım';
  }

  @override
  String get homePulse => 'Kısa bakış';

  @override
  String get homeLater => 'Devamı';

  @override
  String get homeQuizTitle => 'Rutininizi kişiselleştirelim';

  @override
  String get homeQuizBody => '3 dakikalık test — ve rutin size uyum sağlar.';

  @override
  String get homeQuizStart => 'Teste başla';

  @override
  String get error_consent_health_required =>
      'Bu yanıtlar için sağlık onayı gerekir.';

  @override
  String get privacyTitle => 'Gizlilik merkezi';

  @override
  String get privacyIntro =>
      'Senin verin, senin seçimin. Her hakkın bir dokunuş uzağında.';

  @override
  String get profileAccountTitle => 'Hesabın';

  @override
  String get profileAccountNote => 'Adını sormuyoruz · yalnızca e-posta';

  @override
  String get profileEmailLabel => 'E-posta';

  @override
  String get profileAgeLabel => 'Yaş';

  @override
  String get profileCountryLabel => 'Ülke';

  @override
  String get profileLanguageLabel => 'Dil';

  @override
  String get privacyConsentsTitle => 'Onaylar';

  @override
  String get privacyHealthWithdrawTitle =>
      'Sağlık onayını geri çekiyor musunuz?';

  @override
  String get privacyHealthWithdrawBody =>
      'Sağlık yanıtlarınız ve kendi rutinlerinizin sunucudaki kopyası hemen silinecek, rutininiz daha temkinli oluşturulacak. Kendi rutinleriniz bu telefonda kalır. Onayı daha sonra yeniden verebilirsiniz.';

  @override
  String get privacyWithdraw => 'Geri çek ve sil';

  @override
  String get privacyCancel => 'İptal';

  @override
  String get privacyExportTitle => 'Verilerimi indir';

  @override
  String get privacyExportBody =>
      'Parla\'nın sizinle ilgili sakladığı her şey, ayrıca bu telefondaki alışkanlık kayıtları, kendi rutinleriniz ve günlüğünüz, tek bir dosyada. Dosya şimdi oluşturulur ve sunucularımızda saklanmaz.';

  @override
  String get privacyExportButton => 'Dosya oluştur';

  @override
  String get privacyLegalTitle => 'Yasal belgeler';

  @override
  String get privacySignOut => 'Çıkış yap';

  @override
  String get privacyDeleteTitle => 'Hesabı sil';

  @override
  String get deleteTitle => 'Hesabınız silinsin mi?';

  @override
  String get deleteWhatGoes =>
      'Hemen silinir: profiliniz, test ve sağlık yanıtlarınız, sunucuda saklanan kendi rutinleriniz, alışveriş listeniz, spor ve tabak kayıtlarınız (şifreleme anahtarıyla birlikte), destek yazışmalarınız ve giriş hesabınız. Bu telefondaki alışkanlık kayıtları, günlük ve kaydedilen tarifler de silinir.';

  @override
  String get deleteWhatStays =>
      'E-postanız olmadan ve hesabınızla bağlantısı olmadan kalır: kanıt olarak onay geçmişi (3 yıl) ve güvenlik kayıtları (1 yıl), muhasebe için ise siparişleriniz (varsa).';

  @override
  String get deleteExportFirst => 'Önce verilerimi indir';

  @override
  String deleteConfirmLabel(String word) {
    return 'Onaylamak için $word yazın';
  }

  @override
  String get deleteConfirmWord => 'SİL';

  @override
  String get deleteButton => 'Hesabımı sil';

  @override
  String get deletedTitle => 'Hesabınız silindi';

  @override
  String get deletedBody =>
      'Bizimle olduğunuz için teşekkür ederiz. Her zaman geri dönebilirsiniz.';

  @override
  String get legalTitle => 'Yasal belgeler';

  @override
  String get legalMedicalTitle => 'Tıbbi tavsiye değildir';

  @override
  String get legalMedicalBody =>
      'Parla bir bakım rehberidir. Teşhis koymaz, tedavi etmez ve doktorun yerini tutmaz. Cilt hastalıkları veya endişe verici belirtiler için bir dermatoloğa başvurun.';

  @override
  String get legalPolicyTitle => 'Gizlilik politikası ve kullanım koşulları';

  @override
  String get legalPolicyBody =>
      'Bu belgeler bir hukukçuyla hazırlanıyor ve lansmandan önce burada yer alacak.';

  @override
  String get legalPrivacyPolicy => 'Gizlilik politikası';

  @override
  String get legalTerms => 'Kullanım koşulları';

  @override
  String get legalConsentsTitle => 'Onay metinleri';

  @override
  String get habitEdit => 'Değiştir';

  @override
  String get habitSleepSheetTitle => 'Dün gece ne kadar uyudunuz?';

  @override
  String get habitMoveSheetTitle => 'Bugün ne kadar hareket ettiniz?';

  @override
  String habitSleepHours(String hours) {
    return '$hours saat';
  }

  @override
  String habitMoveMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get habitLess => 'Azalt';

  @override
  String get habitMore => 'Artır';

  @override
  String get habitSave => 'Kaydet';

  @override
  String get habitClearEntry => 'Kaydı sil';

  @override
  String get habitsScreenTitle => 'Rutin';

  @override
  String get habitsScreenIntro => 'Küçük adımlar, kendi temponuzda.';

  @override
  String get habitsToday => 'Bugün';

  @override
  String get habitsWeekTitle => 'Son 7 gün';

  @override
  String get habitsWeekCare => 'Rutininize zaman ayırdığınız günler';

  @override
  String habitsWeekCareValue(int days) {
    return '7 günden $days';
  }

  @override
  String get habitsWeekNone => 'Henüz kayıt yok';

  @override
  String habitsWeekWaterValue(String glasses) {
    return 'Günde ortalama $glasses bardak';
  }

  @override
  String habitsWeekSleepValue(String hours, int nights) {
    return 'Ortalama $hours saat, $nights gece kaydedildi';
  }

  @override
  String habitsWeekMoveValue(int minutes, int days) {
    return 'Toplam $minutes dk, $days gün';
  }

  @override
  String get habitsPrivacyNote =>
      'Alışkanlık kayıtlarınız yalnızca bu telefonda saklanır ve sunucuya gönderilmez. 90 günden eski kayıtlar otomatik olarak silinir.';

  @override
  String get privacyHabitsTitle => 'Bu telefondaki alışkanlık kayıtları';

  @override
  String get privacyHabitsBody =>
      'Su, uyku, hareket ve rutin kayıtları yalnızca bu telefonda saklanır. Bunları istediğiniz zaman silebilirsiniz.';

  @override
  String get privacyHabitsDelete => 'Kayıtları sil';

  @override
  String get privacyHabitsDeleteTitle => 'Alışkanlık kayıtları silinsin mi?';

  @override
  String get privacyHabitsDeleteBody =>
      'Bu telefondaki tüm su, uyku, hareket ve rutin kayıtlarınız silinecek. Bu işlem geri alınamaz.';

  @override
  String get privacyHabitsDeleted => 'Alışkanlık kayıtları silindi.';

  @override
  String get remindersTitle => 'Hatırlatıcılar';

  @override
  String get remindersIntro =>
      'Bildirimleri telefonunuz kendisi gösterir, sunucuya hiçbir şey gönderilmez. İstediğiniz zaman kapatabilirsiniz.';

  @override
  String get remindersOpen => 'Ayarla';

  @override
  String get remindersSummaryOff => 'Hepsi kapalı';

  @override
  String remindersSummaryOn(int count) {
    return 'Etkin: $count';
  }

  @override
  String get reminderMorningTitle => 'Sabah rutini';

  @override
  String get reminderEveningTitle => 'Akşam rutini';

  @override
  String get reminderSleepTitle => 'Uyku kaydı';

  @override
  String get reminderMorningBody => 'Sabah rutini zamanı.';

  @override
  String get reminderEveningBody => 'Akşam rutini zamanı.';

  @override
  String get reminderSleepBody => 'Dün geceyi kaydetmek ister misiniz?';

  @override
  String reminderAt(String time) {
    return 'Saat $time';
  }

  @override
  String get reminderChangeTime => 'Saati değiştir';

  @override
  String get reminderTimeSheetTitle => 'Ne zaman hatırlatalım?';

  @override
  String get reminderPermissionDenied =>
      'Bildirim izni verilmedi. Telefonunuzun ayarlarından açabilirsiniz.';

  @override
  String get remindersNote =>
      'Metinler nötrdür ve kilit ekranında sağlık bilgisi göstermez. Bildirim birkaç dakika gecikebilir.';

  @override
  String get productsTitle => 'Ürün kontrol et';

  @override
  String get productsIntro =>
      'Ürünün adını veya markasını yazın ve içeriğine bakın.';

  @override
  String get productsSearchLabel => 'Ürün adı veya marka';

  @override
  String get productsSearchButton => 'Ara';

  @override
  String get productsQueryTooShort => 'En az 2 harf yazın.';

  @override
  String get productsNotFoundTitle => 'Hiçbir şey bulunamadı';

  @override
  String get productsNotFoundBody =>
      'Farklı bir yazımla veya marka adıyla deneyin. Veritabanında henüz her ürün yok.';

  @override
  String get productsSourceObf => 'Open Beauty Facts';

  @override
  String get productsSourceParla => 'Parla kataloğu';

  @override
  String get error_product_query_invalid => 'Arama 2–80 karakter olmalıdır.';

  @override
  String get error_product_source_unavailable =>
      'Ürün veritabanı şu anda yanıt vermiyor. Biraz sonra tekrar deneyin.';

  @override
  String get productIngredientsTitle => 'İçerik';

  @override
  String get productNoIngredients =>
      'Bu ürün için içerik listesi yok. Ambalajdaki listeye bakın.';

  @override
  String productIngredientCount(int count) {
    return '$count içerik maddesi';
  }

  @override
  String productListedCount(int count) {
    return '$count madde için AB kaydı var';
  }

  @override
  String get productStatusesMissing =>
      'İçerik durumları henüz yüklenmedi. Şimdilik yalnızca içerik listesi gösteriliyor.';

  @override
  String get productDataNotice =>
      'İçerik listesi bir topluluk veritabanından gelir ve hatalar içerebilir. Ambalajdaki listeyle karşılaştırın.';

  @override
  String productLegalNotice(String date) {
    return 'Durumlar AB\'nin 1223/2009 sayılı Tüzüğü\'nün eklerine dayanır (CosIng, $date). Adlar otomatik olarak eşleştirilir. Bu bir Azerbaycan kuralı değildir ve ürünün güvenliğine dair bir değerlendirme değildir.';
  }

  @override
  String get productAttribution =>
      'Ürün verisi: Open Beauty Facts, ODbL lisansıyla.';

  @override
  String get annexIIShort => 'AB: yasaklı maddeler listesinde';

  @override
  String get annexIIIShort => 'AB: kısıtlamalarla izinli';

  @override
  String get annexIVShort => 'AB: izinli renklendirici';

  @override
  String get annexVShort => 'AB: izinli koruyucu';

  @override
  String get annexVIShort => 'AB: izinli UV filtresi';

  @override
  String annexEntry(String annex, String reference) {
    return 'Ek $annex, sıra no. $reference';
  }

  @override
  String get annexConditionsLabel =>
      'Resmi koşullar (CosIng\'deki haliyle, İngilizce)';

  @override
  String get ingredientNoEntry => 'AB eklerinde ayrı bir kayıt bulunamadı';

  @override
  String ingredientSheetSource(String date) {
    return 'Kaynak: CosIng, $date';
  }

  @override
  String get ingredientDetailsHint => 'Ayrıntılar';

  @override
  String get navRoutine => 'Rutin';

  @override
  String get navCheck => 'Kontrol';

  @override
  String get navSport => 'Spor';

  @override
  String get navDiscover => 'Keşfet';

  @override
  String get navProfile => 'Profil';

  @override
  String get sportTitle => 'Spor';

  @override
  String get discoverTitle => 'Keşfet';

  @override
  String get discoverBlogs => 'Bloglar';

  @override
  String get discoverBlogsHint => 'Bakım, güzellik, moda';

  @override
  String get discoverExperts => 'Uzmanlar';

  @override
  String get discoverExpertsHint => 'Dermatolog, kozmetolog';

  @override
  String get discoverNutrition => 'Beslenme';

  @override
  String get discoverNutritionHint => 'Günlük tabak ve tarifler';

  @override
  String get discoverShopping => 'Alışveriş listesi';

  @override
  String get discoverShoppingHint => 'Gerekenleri not al';

  @override
  String get discoverShop => 'Mağaza';

  @override
  String get discoverShopHint => 'Rutinindeki ürünler';

  @override
  String get soonBadge => 'Yakında';

  @override
  String get onboardingStepAbout => 'Tanışma';

  @override
  String get onboardingStepAccount => 'Hesap';

  @override
  String get onboardingStepCountry => 'Ülke';

  @override
  String get onboardingStepPrivacy => 'Gizlilik';

  @override
  String get routineAreaFace => 'Yüz';

  @override
  String get routineAreaHair => 'Saç';

  @override
  String get routineAreaBody => 'Vücut';

  @override
  String get routineSlotMorning => 'Sabah';

  @override
  String get routineSlotEvening => 'Akşam';

  @override
  String get routineSlotWeekly => 'Haftalık';

  @override
  String get routineWeeklyHint =>
      'Haftada bir kez. İşaretler pazartesi sıfırlanır.';

  @override
  String get routineSlotEmpty => 'Bu zaman için adım yok.';

  @override
  String get routineOwnButton => 'Kendi rutinin';

  @override
  String get routineOwnSection => 'Kendi rutinlerin';

  @override
  String get routineOwnEmpty =>
      'Kendi rutinini oluşturup burada takip edebilirsin.';

  @override
  String get routineOwnEveryDay => 'Her gün';

  @override
  String routineOwnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adım',
      one: '1 adım',
    );
    return '$_temp0';
  }

  @override
  String routineOwnEdit(String name) {
    return 'Değiştir: $name';
  }

  @override
  String get routineDayHabits => 'Gün boyunca';

  @override
  String get builderTitleNew => 'Kendi rutinini oluştur';

  @override
  String get builderTitleEdit => 'Rutini değiştir';

  @override
  String get builderName => 'Adı';

  @override
  String get builderNameHint => 'Örn. Pazar spası';

  @override
  String get builderArea => 'Bölüm';

  @override
  String get builderWhen => 'Ne zaman';

  @override
  String get builderEveryDay => 'Her gün';

  @override
  String get builderOnceWeek => 'Haftada bir kez';

  @override
  String get builderSteps => 'Adımlar';

  @override
  String get builderStepHint => 'Yeni adım';

  @override
  String get builderAddStep => 'Ekle';

  @override
  String get builderSuggestions => 'Hazır adımlardan seç';

  @override
  String builderMoveUp(String step) {
    return 'Yukarı: $step';
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
  String get builderSave => 'Kaydet';

  @override
  String get builderDelete => 'Rutini sil';

  @override
  String get builderDeleteConfirm => 'Bu rutin silinsin mi?';

  @override
  String get builderDeleteYes => 'Sil';

  @override
  String get builderCancel => 'İptal';

  @override
  String get builderNeedName => 'Rutine bir ad ver.';

  @override
  String get builderNeedStep => 'En az bir adım ekle.';

  @override
  String builderLimit(int count) {
    return 'En fazla $count adım.';
  }

  @override
  String get todayRoutinesTitle => 'Bugünün rutinleri';

  @override
  String get todayRoutinesAll => 'Tümü';

  @override
  String get todayRoutinesNone => 'Bugün için başka rutin yok.';

  @override
  String get builderPrivacySynced =>
      'Kendi rutinlerin sunucuda şifreli saklanır, çevrimdışı kullanım için bir kopyası da bu telefonda kalır.';

  @override
  String get builderPrivacyDevice =>
      'Kendi rutinlerin şimdilik yalnızca bu telefonda saklanıyor. Güncellenmiş sağlık onayıyla sunucuda şifreli saklanacak.';

  @override
  String get checkPrefsTitle => 'Tercihlerin';

  @override
  String get checkPrefsEdit => 'Değiştir';

  @override
  String get checkPrefsEmpty =>
      'Senin için önemli olanı seç, içeriği tercihlerinle karşılaştıralım.';

  @override
  String get checkPrefsAdd => 'Tercih ekle';

  @override
  String get checkPrefsSheetTitle => 'Senin için ne önemli?';

  @override
  String get checkPrefsSave => 'Kaydet';

  @override
  String get checkBarcodeSoon => 'Barkod tarayıcı · yakında';

  @override
  String get checkRecentTitle => 'Son kontrol edilenler';

  @override
  String get checkRecentClear => 'Temizle';

  @override
  String get resultPrefsTitle => 'Tercihlerine göre';

  @override
  String resultPrefsSummary(int fits, int count) {
    return 'Tercihlerinden $fits / $count uygun';
  }

  @override
  String get resultPrefFits => 'Uygun';

  @override
  String resultPrefContains(String names) {
    return 'İçeriğinde var: $names';
  }

  @override
  String get resultPrefVeganFits =>
      'Bilinen hayvansal kaynaklı madde bulunamadı';

  @override
  String get resultPrefUnknown =>
      'İçerik listesi olmadığı için kontrol edilemiyor';

  @override
  String get resultPrefsNone =>
      'Tercihlerini ekle, içeriği onlarla karşılaştıralım.';

  @override
  String get resultPrefsNote =>
      'Parla ürünleri değerlendirmez ve puan vermez. Uygunluk yalnızca senin tercihlerine ve içerik listesine dayanır.';

  @override
  String get resultAddToList => 'Alışveriş listesine';

  @override
  String get resultInList => 'Listede';

  @override
  String get resultAdded => 'Alışveriş listesine eklendi.';

  @override
  String shoppingCount(int bought, int total) {
    return '$bought / $total alındı';
  }

  @override
  String get shoppingNewHint => 'Yeni ürün';

  @override
  String get shoppingAdd => 'Ekle';

  @override
  String get shoppingEmpty => 'Liste boş. Gerekenleri buraya not al.';

  @override
  String get shoppingAreaOther => 'Diğer';

  @override
  String get shoppingFromCheck => 'Kontrol bölümünden';

  @override
  String shoppingRemove(String title) {
    return 'Sil: $title';
  }

  @override
  String get shoppingRemoveBought => 'Alınanları sil';

  @override
  String shoppingFull(int count) {
    return 'Listede en fazla $count ürün olabilir.';
  }

  @override
  String get careListSynced =>
      'Tercihlerin ve alışveriş listen sunucuda şifreli saklanır, çevrimdışı kullanım için bir kopyası da bu telefonda kalır.';

  @override
  String get careListDevice =>
      'Tercihlerin ve alışveriş listen şimdilik yalnızca bu telefonda saklanıyor. Güncellenmiş sağlık onayıyla sunucuda şifreli saklanacak.';

  @override
  String get shopTitle => 'Parla Mağaza';

  @override
  String get shopBody =>
      'Rutinindeki ürünler, tek dokunuşla. Alışveriş listeni doğrudan sipariş edebilecek, tercihlerine uygun ürünleri bulabileceksin.';

  @override
  String get shopSoonCard => 'Parla Mağaza';

  @override
  String get shopSoonCardBody => 'İş ortaklarımızın ürünlerine göz at';

  @override
  String get shopOpenList => 'Alışveriş listeme bak';

  @override
  String get shopIntro =>
      'İş ortaklarının ürünleri. Satın alma iş ortağının sitesinde yapılır; Parla seninle ilgili hiçbir şey aktarmaz.';

  @override
  String get shopAll => 'Tümü';

  @override
  String get shopCategoryFace => 'Yüz';

  @override
  String get shopCategoryHair => 'Saç';

  @override
  String get shopCategoryBody => 'Vücut';

  @override
  String get shopCategoryMakeup => 'Makyaj';

  @override
  String get shopCategoryOther => 'Diğer';

  @override
  String shopPrice(String price) {
    return '$price ₼';
  }

  @override
  String get shopVisitPartner => 'İş ortağının sitesine git';

  @override
  String get shopPriceNote =>
      'Fiyat ve stok durumu iş ortağının sitesinde değişebilir. Satın almadan önce içeriği kontrol et; cildinde bir sorun varsa doktora danış.';

  @override
  String get shopEmpty => 'Henüz ürün yok. Yakında burada olacak.';

  @override
  String get shopMyOrders => 'Siparişlerim';

  @override
  String get shopBuy => 'Satın al';

  @override
  String get shopBuyTitle => 'Siparişi onayla';

  @override
  String shopBuyBody(String product, String price, String seller) {
    return '$product: $price. $seller Ödeme Epoint sayfasında yapılır; kart bilgilerin Parla\'ya ulaşmaz.';
  }

  @override
  String get shopSellerParla => 'Satıcı: Parla.';

  @override
  String shopSellerBrand(String brand) {
    return 'Satıcı: $brand, ödemeyi Parla alır.';
  }

  @override
  String get shopBuyGo => 'Ödemeye geç';

  @override
  String get shopBuyError =>
      'Ödeme sayfası açılamadı. Biraz sonra tekrar dene.';

  @override
  String get shopTooMany =>
      'Son bir saatte çok fazla sipariş başlattın. Biraz sonra tekrar dene.';

  @override
  String get shopOrdersEmpty => 'Henüz siparişin yok.';

  @override
  String shopOrderMeta(String number, String date, int quantity) {
    return '$number · $date · $quantity adet';
  }

  @override
  String get shopOrderCreated => 'Ödeme bekleniyor';

  @override
  String get shopOrderPaid => 'Ödendi';

  @override
  String get shopOrderFailed => 'Ödeme başarısız';

  @override
  String get shopOrderShipped => 'Kargoya verildi';

  @override
  String get shopOrderDelivered => 'Teslim edildi';

  @override
  String get shopOrderCancelled => 'İptal edildi';

  @override
  String get shopOrderRefunded => 'Para iade edildi';

  @override
  String get sportIntroTitle => 'Sana uygun spor planı';

  @override
  String get sportIntroBody =>
      'Birkaç soru: hedef, bölgeler, sevdiğin antrenmanlar. Sonra set ve tekrar sayılarıyla haftalık plan ve zamanlayıcı. Müzik kendi uygulamandan çalar.';

  @override
  String get sportStart => 'Başla';

  @override
  String get sportNext => 'Devam';

  @override
  String get sportNeedOne => 'En az birini seç.';

  @override
  String get sportQGoals => 'Hedefin ne?';

  @override
  String get sportQGoalsHint => 'En fazla 2 seç';

  @override
  String get sportGoalTone => 'Tonus ve sıkılaşma';

  @override
  String get sportGoalMuscle => 'Kas kütlesi kazanmak';

  @override
  String get sportGoalFlexibility => 'Esneklik';

  @override
  String get sportGoalPosture => 'Duruş';

  @override
  String get sportGoalEndurance => 'Dayanıklılık';

  @override
  String get sportGoalRelax => 'Stres atmak';

  @override
  String get sportQAreas => 'Hangi bölgelere odaklanalım?';

  @override
  String get sportAreasNote =>
      'Tek bir bölgeden yağ yakmak mümkün değil. Bu hareketler o kasları güçlendirir ve sıkılaştırır.';

  @override
  String get sportAreaArms => 'Kollar';

  @override
  String get sportAreaLegs => 'Bacaklar';

  @override
  String get sportAreaCore => 'Karın ve core';

  @override
  String get sportAreaGlutes => 'Kalça';

  @override
  String get sportAreaBack => 'Sırt';

  @override
  String get sportAreaFull => 'Tüm vücut';

  @override
  String get sportQTypes => 'Hangi antrenmanları istiyorsun?';

  @override
  String get sportTypeFitness => 'Fitness';

  @override
  String get sportTypePilates => 'Pilates';

  @override
  String get sportTypeWallPilates => 'Duvar pilatesi';

  @override
  String get sportTypeStretching => 'Esneme';

  @override
  String get sportTypeCardio => 'Hafif kardiyo';

  @override
  String get sportTypeFaceYoga => 'Yüz yogası';

  @override
  String get sportTypeYoga => 'Yoga';

  @override
  String get sportYogaMorning => 'Sabah akışı';

  @override
  String get sportYogaEvening => 'Akşam sakinliği';

  @override
  String get sportYogaStretch => 'Esneme ve gevşeme';

  @override
  String sportSessionCardBody(int count, int minutes) {
    return '$count hareket · yaklaşık $minutes dk';
  }

  @override
  String get sportYogaSafetyTitle => 'Başlamadan önce';

  @override
  String get sportYogaSafetyBody =>
      'Yavaş hareket et, nefesini tutma, ağrı olursa dur. Hamilelikte, yüksek tansiyonda, bel, diz veya bilek sakatlığında önce doktora başvur. Ankette sakatlık veya hamilelik belirttiysen sana uygun olmayan duruşlar seanstan çıkarılır.';

  @override
  String sportFaceYogaCardBody(int minutes) {
    return '12 hareket · yaklaşık $minutes dk. Ayna karşısında, istediğin zaman.';
  }

  @override
  String get sportFaceYogaSafetyTitle => 'Başlamadan önce';

  @override
  String get sportFaceYogaSafetyBody =>
      'Ellerinizi yıkayın, cildinize yalnızca hafifçe dokunun, cildinizi germeyin. Ağrı veya rahatsızlık olursa durun. Yakın zamanda kozmetik bir işlem (botoks, dolgu) yaptırdıysanız, çene ekleminizde veya cildinizde bir sorun varsa önce doktora başvurun.';

  @override
  String get sportQLevel => 'Seviyen nasıl?';

  @override
  String get sportLevelBeginner => 'Yeni başlıyorum';

  @override
  String get sportLevelIntermediate => 'Orta';

  @override
  String get sportLevelAdvanced => 'Deneyimli';

  @override
  String get sportQSchedule => 'Ne kadar vaktin var?';

  @override
  String get sportDaysLabel => 'Haftada kaç gün';

  @override
  String get sportMinutesLabel => 'Bir antrenman';

  @override
  String sportDays(int count) {
    return '$count gün';
  }

  @override
  String sportMinutes(int count) {
    return '$count dk';
  }

  @override
  String get sportDumbbells => 'Evde dambılım var';

  @override
  String get sportQSafety => 'Güvenliğin için';

  @override
  String get sportSafetyIntro =>
      'Bu yanıtlar yalnızca sana uygun olmayan hareketleri plandan çıkarmak içindir.';

  @override
  String get sportPregnancyLabel => 'Hamilelik';

  @override
  String get sportPregNo => 'Hayır';

  @override
  String get sportPregPregnant => 'Hamileyim';

  @override
  String get sportPregPostpartum => 'Son 6 ayda doğum yaptım';

  @override
  String get sportInjuriesLabel => 'Ağrı veya sakatlık';

  @override
  String get sportInjKnee => 'Diz';

  @override
  String get sportInjBack => 'Bel';

  @override
  String get sportInjShoulder => 'Omuz';

  @override
  String get sportInjWrist => 'Bilek';

  @override
  String get sportDoctorLimit =>
      'Doktor sporu kısıtladı veya önce danışmamı söyledi';

  @override
  String get sportBuildPlan => 'Planı oluştur';

  @override
  String get sportWeekTitle => 'Bu hafta';

  @override
  String sportWeekProgress(int done, int total) {
    return '$done / $total antrenman';
  }

  @override
  String sportWorkoutTitle(int number) {
    return 'Antrenman $number';
  }

  @override
  String get sportWorkoutName_w6 => 'Hafif esneme';

  @override
  String get sportWorkoutName_w7 => 'Hafta finali';

  @override
  String get sportWorkoutName_p6 => 'Yumuşak akış';

  @override
  String get sportWorkoutName_p7 => 'Merkez finali';

  @override
  String get sportWorkoutName_v6 => 'Duvarda rahat gün';

  @override
  String get sportWorkoutName_v7 => 'Duvar finali';

  @override
  String get sportEveryDay => 'Her gün';

  @override
  String get sportWeekdaysLabel => 'Hangi günler?';

  @override
  String sportWeekdaysHint(int count) {
    return '$count gün seç. Aradaki günler dinlenme içindir.';
  }

  @override
  String get sportEveryDayNote =>
      'Her gün: kasların toparlanması için haftada iki gün hafif esneme yapılır.';

  @override
  String sportWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(
      day,
      {
        '1': 'Pzt',
        '2': 'Sal',
        '3': 'Çar',
        '4': 'Per',
        '5': 'Cum',
        '6': 'Cmt',
        'other': 'Paz',
      },
    );
    return '$_temp0';
  }

  @override
  String sportPickWeekdays(int count) {
    return 'Tam olarak $count gün seç.';
  }

  @override
  String get sportMonthTitle => 'Aylık plan';

  @override
  String sportMonthProgress(int day, int week) {
    return 'Gün $day / 28 · Hafta $week';
  }

  @override
  String get sportLegendDone => 'yapıldı';

  @override
  String get sportLegendWorkout => 'antrenman';

  @override
  String get sportLegendRest => 'dinlenme';

  @override
  String get sportToday => 'Bugün';

  @override
  String get sportRestToday => 'Bugün dinlenme günü';

  @override
  String sportNextOn(String when) {
    return 'Sonraki antrenman: $when';
  }

  @override
  String sportWeekBadge(int week) {
    return 'Hafta $week';
  }

  @override
  String get sportRecoveryWeek => 'Toparlanma haftası';

  @override
  String sportCardMeta(int minutes, int moves) {
    return '$minutes dk · $moves hareket';
  }

  @override
  String get sportMonthDoneTitle => 'Ay tamamlandı';

  @override
  String sportMonthDoneBody(int done) {
    return '$done antrenman yapıldı. Sonraki aydan önce yanıtlarını ve seviyeni kontrol edelim.';
  }

  @override
  String get sportNewMonth => 'Sonraki ay';

  @override
  String sportMonthCalendar(int done, int left) {
    return 'Ay takvimi: $done antrenman yapıldı, $left kaldı';
  }

  @override
  String get sportWorkoutName_w1 => 'Güçlü başlangıç';

  @override
  String get sportWorkoutName_w2 => 'Bacak günü';

  @override
  String get sportWorkoutName_w3 => 'Tüm vücut';

  @override
  String get sportWorkoutName_w4 => 'Enerji dalgası';

  @override
  String get sportWorkoutName_w5 => 'Güç ve denge';

  @override
  String get sportWorkoutName_p1 => 'Merkez uyanışı';

  @override
  String get sportWorkoutName_p2 => 'Yumuşak akış';

  @override
  String get sportWorkoutName_p3 => 'Duruş ve nefes';

  @override
  String get sportWorkoutName_p4 => 'Uzun çizgiler';

  @override
  String get sportWorkoutName_p5 => 'Sakin güç';

  @override
  String get sportWorkoutName_v1 => 'Duvarla tanışma';

  @override
  String get sportWorkoutName_v2 => 'Duvar desteği';

  @override
  String get sportWorkoutName_v3 => 'Duvarda akış';

  @override
  String get sportWorkoutName_v4 => 'Duvar ritmi';

  @override
  String get sportWorkoutName_v5 => 'Duvar dengesi';

  @override
  String sportWorkoutMeta(String type, int minutes) {
    return '$type · ~$minutes dk';
  }

  @override
  String get sportDone => 'Yapıldı';

  @override
  String get sportNextLabel => 'Sıradaki';

  @override
  String get sportEditAnswers => 'Anketi güncelle';

  @override
  String get sportBlockedTitle => 'Önce doktorunla konuş';

  @override
  String get sportBlockedBody =>
      'Doktor sporu kısıtladıysa plan oluşturmuyoruz. İzin aldığında anketi güncelle.';

  @override
  String get sportGentleNote =>
      'Hamilelik ve doğum sonrası dönem için hafif plan. Başlamadan önce doktoruna danış.';

  @override
  String get sportDraftNote =>
      'Hareketler ve sayılar henüz bir antrenör tarafından kontrol edilmedi. Ağrı hissedersen dur.';

  @override
  String get sportAllDone => 'Bu haftanın tüm antrenmanları yapıldı.';

  @override
  String sportSetsReps(int sets, int reps) {
    return '$sets × $reps tekrar';
  }

  @override
  String sportSetsSeconds(int sets, int seconds) {
    return '$sets × $seconds sn';
  }

  @override
  String sportRestSeconds(int seconds) {
    return 'Dinlenme $seconds sn';
  }

  @override
  String get sportStartWorkout => 'Antrenmana başla';

  @override
  String get sportMusicNote =>
      'Videoların kendi müziği var, düğmeyle kapatabilirsin. Parla sesli sinyal de verir.';

  @override
  String get sportVideoSoundOn => 'Video sesi açık';

  @override
  String get sportVideoSoundOff => 'Video sesi kapalı';

  @override
  String get sportSoundOn => 'Sinyal sesi açık';

  @override
  String get sportSoundOff => 'Sinyal sesi kapalı, yalnızca titreşim';

  @override
  String sportSetOf(int set, int sets) {
    return 'Set $set / $sets';
  }

  @override
  String sportRepsNow(int reps) {
    return '$reps tekrar';
  }

  @override
  String get sportPause => 'Duraklat';

  @override
  String get sportResume => 'Devam';

  @override
  String get sportResting => 'Dinlenme';

  @override
  String sportNextUp(String name) {
    return 'Sonra: $name';
  }

  @override
  String sportExerciseOf(int index, int total) {
    return 'Hareket $index / $total';
  }

  @override
  String get sportFinishedTitle => 'Antrenman bitti';

  @override
  String sportFinishedBody(int minutes) {
    return '$minutes dakikalık hareket bugünün kaydına eklendi.';
  }

  @override
  String get sportBackToPlan => 'Plana dön';

  @override
  String get sportQuit => 'Antrenmanı durdur';

  @override
  String get sportGetReady => 'Hazır ol';

  @override
  String get sportPrevious => 'Önceki hareket';

  @override
  String get sportNextMove => 'İleri';

  @override
  String get sportStopTitle => 'Antrenmanı durduralım mı?';

  @override
  String get sportStopBody => 'Bu antrenman yapılmış olarak işaretlenmeyecek.';

  @override
  String get sportStopConfirm => 'Durdur';

  @override
  String get sportKeepGoing => 'Devam et';

  @override
  String sportRepPace(int seconds) {
    return 'Her tekrar yaklaşık $seconds sn. Daha erken bitirirsen “İleri”ye dokun.';
  }

  @override
  String get sportPrivacySynced =>
      'Spor yanıtların sunucuda şifreli saklanır, çevrimdışı kullanım için bir kopyası da bu telefonda kalır.';

  @override
  String get sportPrivacyDevice =>
      'Spor yanıtların şimdilik yalnızca bu telefonda saklanıyor. Güncellenmiş sağlık onayıyla sunucuda şifreli saklanacak.';

  @override
  String get discoverLatest => 'Yeni yazılar';

  @override
  String get discoverAll => 'Tümü';

  @override
  String get expertSample => 'Örnek';

  @override
  String get expertSampleNote =>
      'Bu bir örnek profildir, iletişim bilgileri çalışmaz.';

  @override
  String get discoverJournal => 'Günlük';

  @override
  String get discoverJournalHint => 'Yalnızca senin için, bu telefonda';

  @override
  String get journalIntro =>
      'Günün hakkında yaz. Yazılar yalnızca bu telefonda, şifreli olarak saklanır; Parla ekibi onları göremez. Telefon değiştirdiğinde veya uygulamayı sildiğinde kaybolur. Saklamak için: Profil → Verilerimi indir.';

  @override
  String get journalNew => 'Yeni yazı';

  @override
  String get journalEmpty => 'Henüz yazı yok.';

  @override
  String get journalHint => 'Bugün nasıl geçti?';

  @override
  String get journalEntryTitle => 'Yazı';

  @override
  String get journalSave => 'Kaydet';

  @override
  String get journalDelete => 'Sil';

  @override
  String get journalDeleteTitle => 'Bu yazı silinsin mi?';

  @override
  String get journalDeleteBody => 'Bu işlem geri alınamaz.';

  @override
  String get journalFull =>
      'Günlük dolu. Yeni yazı için eskilerden birini sil.';

  @override
  String get discoverSportHint => 'Haftalık planın';

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
      other: '$count tarif',
    );
    return '$_temp0';
  }

  @override
  String get contentEmpty => 'Henüz yazı yok. Yakında burada olacak.';

  @override
  String get contentOffline => 'İnternet yok, son yüklenen kopya gösteriliyor.';

  @override
  String blogMeta(String category, int minutes) {
    return '$category · $minutes dk';
  }

  @override
  String blogReviewed(String date) {
    return 'Uzman kontrol etti · $date';
  }

  @override
  String get blogTips => 'Kısa adımlar';

  @override
  String get catCare => 'Bakım';

  @override
  String get catBeauty => 'Güzellik';

  @override
  String get catFashion => 'Moda';

  @override
  String get catHair => 'Saç';

  @override
  String get specDermatologist => 'Dermatolog';

  @override
  String get specCosmetologist => 'Kozmetolog';

  @override
  String get specTrainer => 'Antrenör';

  @override
  String get specDietitian => 'Diyetisyen';

  @override
  String get specTrichologist => 'Trikolog';

  @override
  String expertYears(int years) {
    return '$years yıl deneyim';
  }

  @override
  String get expertCall => 'Ara';

  @override
  String get expertWhatsapp => 'WhatsApp';

  @override
  String get expertInstagram => 'Instagram';

  @override
  String get expertsNote =>
      'Parla uzmanları yalnızca tanıtır, onların hizmetlerinden sorumlu değildir. İletişim uygulama dışında, doğrudan uzmanla kurulur; Parla görüşmeyi görmez.';

  @override
  String get nutritionHero => 'Güzellik tabakta başlar';

  @override
  String get nutritionPlate => 'Bugünün tabağı';

  @override
  String nutritionPlateCount(int count, int total) {
    return '$count / $total grup';
  }

  @override
  String get groupVegetables => 'Sebze';

  @override
  String get groupFruit => 'Meyve';

  @override
  String get groupProtein => 'Protein';

  @override
  String get groupWholeGrain => 'Tam tahıl';

  @override
  String get groupHealthyFat => 'Sağlıklı yağ';

  @override
  String get groupDairy => 'Süt ürünü';

  @override
  String nutritionWater(int count, int goal) {
    return 'Su: $count / $goal bardak';
  }

  @override
  String get nutritionNoCalories =>
      'Tabakta kalori saymıyoruz. Sadece çeşitlilik: her gün renkli bir tabak.';

  @override
  String get nutritionTip => 'Günün önerisi';

  @override
  String get nutritionRecipes => 'Güzellik tarifleri';

  @override
  String get nutritionDisclaimer =>
      'Genel bilgidir, diyet veya tıbbi tavsiye değildir. Özel beslenme ihtiyacın varsa bir diyetisyene danış.';

  @override
  String get nutritionPrivacySynced =>
      'Tabak kayıtların sunucuda şifreli saklanır, çevrimdışı kullanım için bir kopyası da bu telefonda kalır.';

  @override
  String get nutritionPrivacyDevice =>
      'Tabak kayıtların şimdilik yalnızca bu telefonda saklanıyor. Güncellenmiş sağlık onayıyla sunucuda şifreli saklanacak.';

  @override
  String get mealBreakfast => 'Kahvaltı';

  @override
  String get mealLunch => 'Öğle yemeği';

  @override
  String get mealDinner => 'Akşam yemeği';

  @override
  String get mealSnack => 'Ara öğün';

  @override
  String recipeMeta(String meal, int minutes, int servings) {
    return '$meal · $minutes dk · $servings kişilik';
  }

  @override
  String get recipeIngredients => 'Malzemeler';

  @override
  String get recipeSteps => 'Hazırlanışı';

  @override
  String get recipeAddAll => 'Malzemeleri alışveriş listesine ekle';

  @override
  String get recipeSave => 'Tarifi kaydet';

  @override
  String get recipeUnsave => 'Kaydedilenlerden çıkar';

  @override
  String get nutritionDailyRecipe => 'Bugünün önerisi';

  @override
  String get nutritionPlateIdeas => 'Tabağını tamamla';

  @override
  String get nutritionPlateIdeasNote =>
      'Bugün henüz seçmediğin gruplar için tarifler.';

  @override
  String get nutritionSaved => 'Kaydettiklerin';

  @override
  String recipeKcal(int kcal) {
    return '≈ $kcal kcal · 1 porsiyon (yaklaşık)';
  }

  @override
  String recipeAdded(int count) {
    return '$count ürün alışveriş listesine eklendi.';
  }

  @override
  String get skinCardTitle => 'Cilt analizi';

  @override
  String get skinCardBody => 'Soruları yanıtlayarak cildini yeniden analiz et.';

  @override
  String get catBody => 'Vücut';

  @override
  String get blogSources => 'Kaynaklar';

  @override
  String get blogRelated => 'Benzer yazılar';

  @override
  String recipeAllergens(String list) {
    return 'İçerir: $list';
  }

  @override
  String get recipeNoAllergens => '14 temel alerjenden hiçbirini içermez.';

  @override
  String get allergenGluten => 'gluten';

  @override
  String get allergenCrustaceans => 'kabuklu deniz ürünleri';

  @override
  String get allergenEgg => 'yumurta';

  @override
  String get allergenFish => 'balık';

  @override
  String get allergenPeanuts => 'yer fıstığı';

  @override
  String get allergenSoy => 'soya';

  @override
  String get allergenMilk => 'süt';

  @override
  String get allergenNuts => 'sert kabuklu yemişler';

  @override
  String get allergenCelery => 'kereviz';

  @override
  String get allergenMustard => 'hardal';

  @override
  String get allergenSesame => 'susam';

  @override
  String get allergenSulphites => 'sülfitler';

  @override
  String get allergenLupin => 'acı bakla (lupin)';

  @override
  String get allergenMolluscs => 'yumuşakçalar';

  @override
  String bannerAd(String brand) {
    return 'Reklam · $brand';
  }

  @override
  String get bannerLeaveTitle => 'Başka bir siteye geçiyorsun';

  @override
  String bannerLeaveBody(String host) {
    return '$host sitesi tarayıcıda açılacak. Parla bu siteye seninle ilgili hiçbir bilgi göndermez; sitenin kendi gizlilik kuralları vardır.';
  }

  @override
  String get bannerLeaveGo => 'Siteye git';

  @override
  String get bannerLeaveCancel => 'İptal';

  @override
  String get messagesTitle => 'Mesajlar';

  @override
  String get messagesButton => 'Mesajlar';

  @override
  String get messagesButtonUnread => 'Mesajlar, yeni yanıt var';

  @override
  String get messagesFromParla => 'Parla\'dan';

  @override
  String get messagesNone => 'Henüz duyuru yok.';

  @override
  String get supportTitle => 'Destek';

  @override
  String get supportIntro =>
      'Soruyu yaz, Parla ekibi yanıtlayacak. Mesajlar şifrelenmiş olarak saklanır ve son mesajdan 12 ay sonra silinir. Tıbbi tavsiye vermiyoruz: acil veya ciddi bir durumda doktora başvur.';

  @override
  String get supportHint => 'Mesajın';

  @override
  String get supportSend => 'Gönder';

  @override
  String get supportYou => 'Sen';

  @override
  String get supportTeam => 'Parla ekibi';

  @override
  String get supportSent => 'Gönderildi.';

  @override
  String get pushTitle => 'Bildirimler';

  @override
  String get pushBody =>
      'Destek yanıt verdiğinde haber alırsın. Pazarlama onayı verirsen Parla\'nın yenilikleri de gelir. İstediğin zaman kapatabilirsin.';

  @override
  String get pushDenied =>
      'Bildirimlere izin verilmedi. Telefonunun ayarlarından açabilirsin.';

  @override
  String get checkSuggestTitle => 'Testine göre öneri';

  @override
  String get checkSuggestBody =>
      'Test yanıtlarına göre bu tercihler sana uygun olabilir. Ekleyip eklememek senin kararın.';

  @override
  String checkSuggestAdd(String name) {
    return '$name ekle';
  }

  @override
  String get consentRefreshCardTitle => 'Onay metni güncellendi';

  @override
  String get consentRefreshCardBody =>
      'Sağlık verisi onayının yeni bir sürümü var. Okuyup onaylarsan rutinlerin, listelerin, spor ve beslenme kayıtların şifrelenmiş olarak sunucuda da saklanacak. Onaylamazsan yalnızca bu telefonda kalırlar.';

  @override
  String get consentRefreshOpen => 'Oku';

  @override
  String get consentRefreshTitle => 'Sağlık verisi onayı';

  @override
  String get consentRefreshIntro =>
      'Daha önce onayladığın metnin yeni sürümüdür. Onay vermek isteğe bağlıdır; istediğin zaman Gizlilik bölümünden geri çekebilirsin.';

  @override
  String get consentRefreshAgree => 'Onaylıyorum';

  @override
  String get consentRefreshLater => 'Şimdi değil';

  @override
  String get consentRefreshDone => 'Onay güncellendi.';

  @override
  String get appearanceTitle => 'Görünüm';

  @override
  String get appearanceSystem => 'Sistem';

  @override
  String get appearanceLight => 'Açık';

  @override
  String get appearanceDark => 'Koyu';
}
