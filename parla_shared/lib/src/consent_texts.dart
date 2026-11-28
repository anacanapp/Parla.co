/// Consent texts shown on screen M-08 and recorded on the server.
///
/// The app shows exactly these strings and the server stores the version and
/// a SHA-256 hash of the text in the language the person saw (GDPR Art. 7(1),
/// checklist CON-3). Changing a text requires a new [ConsentText.version];
/// the old version stays here so existing records can still be verified.
///
/// LEGAL REVIEW PENDING: these are drafts, not reviewed by a lawyer.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'markets.dart';

/// The three separate consents (checklist CON-1). Names must match the
/// server's `ConsentType` enum.
enum ConsentKind { health, analytics, marketing }

/// One version of a consent text in every supported language.
class ConsentText {
  const ConsentText({
    required this.kind,
    required this.version,
    required this.bodies,
  });

  final ConsentKind kind;
  final String version;

  /// Text per language code.
  final Map<String, String> bodies;

  /// The text in [language], or `null` if that language is missing.
  String? bodyFor(String language) => bodies[language];

  /// The language this text is shown in for someone using the interface
  /// [language]: the language itself when the text has it (every
  /// interface language from health-2026-11-draft6 on), else the closest
  /// one ([contentLanguageFor]). The app shows and records this language.
  String languageFor(String language) =>
      bodies.containsKey(language) ? language : contentLanguageFor(language);

  /// SHA-256 of the text in [language], or `null` if that language is missing.
  String? hashFor(String language) {
    final body = bodyFor(language);
    return body == null ? null : consentTextHash(body);
  }
}

/// Hex SHA-256 of a consent text, as stored with each consent record.
String consentTextHash(String text) =>
    sha256.convert(utf8.encode(text)).toString();

/// All versions ever shown, newest last per kind.
const List<ConsentText> consentTextHistory = [
  ConsentText(
    kind: ConsentKind.health,
    version: 'health-2026-11-draft1',
    bodies: {
      'az':
          'Dəri vəziyyətləri, allergiyalar, hamiləlik və qəbul etdiyim dərman '
          'kateqoriyaları haqqında cavablarımın yalnız mənə fərdi və təhlükəsiz '
          'qulluq rutini qurmaq üçün emal olunmasına açıq razılıq verirəm. Bu '
          'məlumatlar şifrələnmiş saxlanılır, üçüncü tərəflərə verilmir və '
          'analitikada istifadə olunmur. Razılığı istənilən vaxt Parametrlər → '
          'Məxfilik bölməsində geri götürə bilərəm; bu halda həmin məlumatlar 24 '
          'saat ərzində silinir.',
      'ru':
          'Я даю явное согласие на обработку моих ответов о состоянии кожи, '
          'аллергиях, беременности и категориях принимаемых лекарств '
          'исключительно для составления персонального и безопасного ухода. Эти '
          'данные хранятся в зашифрованном виде, не передаются третьим лицам и не '
          'используются в аналитике. Я могу отозвать согласие в любой момент в '
          'разделе Настройки → Конфиденциальность; в этом случае данные '
          'удаляются в течение 24 часов.',
      'en':
          'I give explicit consent to the processing of my answers about skin '
          'conditions, allergies, pregnancy and the categories of medicines I '
          'take, solely to build a personal and safe care routine. This data is '
          'stored encrypted, is not shared with third parties and is not used '
          'for analytics. I can withdraw consent at any time in Settings → '
          'Privacy; the data is then deleted within 24 hours.',
    },
  ),
  ConsentText(
    kind: ConsentKind.analytics,
    version: 'analytics-2026-11-draft1',
    bodies: {
      'az':
          'Tətbiqin necə istifadə olunduğunu anlamaq üçün şəxsiyyətimi birbaşa '
          'göstərməyən identifikatorla istifadə statistikasının (açılan ekranlar, '
          'istifadə olunan funksiyalar) toplanmasına razıyam. Sağlamlıq '
          'cavablarım analitikaya heç vaxt göndərilmir.',
      'ru':
          'Я даю согласие на сбор статистики использования (открытые экраны, '
          'используемые функции) с идентификатором, который не раскрывает мою '
          'личность напрямую, чтобы понять, как используется приложение. Мои '
          'ответы о здоровье никогда не передаются в аналитику.',
      'en':
          'I agree to the collection of usage statistics (screens opened, '
          'features used) under an identifier that does not directly reveal who '
          'I am, to understand how the app is used. My health answers are never '
          'sent to analytics.',
    },
  ),
  ConsentText(
    kind: ConsentKind.marketing,
    version: 'marketing-2026-11-draft1',
    bodies: {
      'az':
          'Parla yenilikləri və məsləhətləri haqqında e-poçt almağa razıyam. '
          'İstənilən məktubdakı linklə abunəlikdən çıxa bilərəm.',
      'ru':
          'Я даю согласие получать по электронной почте новости и советы Parla. '
          'Я могу отписаться по ссылке в любом письме.',
      'en':
          'I agree to receive emails with Parla news and tips. I can unsubscribe '
          'via the link in any email.',
    },
  ),
  // Adds the user's own routines and their daily ticks (2026-11-15).
  ConsentText(
    kind: ConsentKind.health,
    version: 'health-2026-11-draft2',
    bodies: {
      'az':
          'Dəri vəziyyətləri, allergiyalar, hamiləlik və qəbul etdiyim dərman '
          'kateqoriyaları haqqında cavablarımın, həmçinin özüm yaratdığım '
          'rutinlərin və onların gündəlik qeydlərinin yalnız mənə fərdi və '
          'təhlükəsiz qulluq rutini qurmaq və saxlamaq üçün emal olunmasına açıq '
          'razılıq verirəm. Bu məlumatlar şifrələnmiş saxlanılır, üçüncü '
          'tərəflərə verilmir və analitikada istifadə olunmur. Razılığı '
          'istənilən vaxt Parametrlər → Məxfilik bölməsində geri götürə bilərəm; '
          'bu halda həmin məlumatlar 24 saat ərzində serverdən silinir.',
      'ru':
          'Я даю явное согласие на обработку моих ответов о состоянии кожи, '
          'аллергиях, беременности и категориях принимаемых лекарств, а также '
          'созданных мной рутин и отметок об их выполнении исключительно для '
          'составления и хранения персонального и безопасного ухода. Эти данные '
          'хранятся в зашифрованном виде, не передаются третьим лицам и не '
          'используются в аналитике. Я могу отозвать согласие в любой момент в '
          'разделе Настройки → Конфиденциальность; в этом случае данные '
          'удаляются с сервера в течение 24 часов.',
      'en':
          'I give explicit consent to the processing of my answers about skin '
          'conditions, allergies, pregnancy and the categories of medicines I '
          'take, and of the routines I create and their daily ticks, solely to '
          'build and keep a personal and safe care routine. This data is stored '
          'encrypted, is not shared with third parties and is not used for '
          'analytics. I can withdraw consent at any time in Settings → Privacy; '
          'the data is then deleted from the server within 24 hours.',
    },
  ),
  // Adds product preferences, checked products and the shopping list
  // (2026-11-15).
  ConsentText(
    kind: ConsentKind.health,
    version: 'health-2026-11-draft3',
    bodies: {
      'az':
          'Dəri vəziyyətləri, allergiyalar, hamiləlik və qəbul etdiyim dərman '
          'kateqoriyaları haqqında cavablarımın, özüm yaratdığım rutinlərin və '
          'onların gündəlik qeydlərinin, həmçinin məhsul seçimlərimin, '
          'yoxladığım məhsulların və alış siyahımın yalnız mənə fərdi və '
          'təhlükəsiz qulluq rutini qurmaq və saxlamaq üçün emal olunmasına açıq '
          'razılıq verirəm. Bu məlumatlar şifrələnmiş saxlanılır, üçüncü '
          'tərəflərə verilmir və analitikada istifadə olunmur. Razılığı '
          'istənilən vaxt Parametrlər → Məxfilik bölməsində geri götürə bilərəm; '
          'bu halda həmin məlumatlar 24 saat ərzində serverdən silinir.',
      'ru':
          'Я даю явное согласие на обработку моих ответов о состоянии кожи, '
          'аллергиях, беременности и категориях принимаемых лекарств, созданных '
          'мной рутин и отметок об их выполнении, а также моих предпочтений по '
          'продуктам, проверенных мной продуктов и списка покупок исключительно '
          'для составления и хранения персонального и безопасного ухода. Эти '
          'данные хранятся в зашифрованном виде, не передаются третьим лицам и не '
          'используются в аналитике. Я могу отозвать согласие в любой момент в '
          'разделе Настройки → Конфиденциальность; в этом случае данные '
          'удаляются с сервера в течение 24 часов.',
      'en':
          'I give explicit consent to the processing of my answers about skin '
          'conditions, allergies, pregnancy and the categories of medicines I '
          'take, of the routines I create and their daily ticks, and of my '
          'product preferences, the products I check and my shopping list, '
          'solely to build and keep a personal and safe care routine. This data '
          'is stored encrypted, is not shared with third parties and is not used '
          'for analytics. I can withdraw consent at any time in Settings → '
          'Privacy; the data is then deleted from the server within 24 hours.',
    },
  ),
  // Adds the sport questions (pregnancy, injuries, goals) and the workout
  // log (2026-11-15).
  ConsentText(
    kind: ConsentKind.health,
    version: 'health-2026-11-draft4',
    bodies: {
      'az':
          'Dəri vəziyyətləri, allergiyalar, hamiləlik və qəbul etdiyim dərman '
          'kateqoriyaları haqqında cavablarımın, özüm yaratdığım rutinlərin və '
          'onların gündəlik qeydlərinin, məhsul seçimlərimin, yoxladığım '
          'məhsulların və alış siyahımın, həmçinin idman sorğusuna cavablarımın '
          '(hamiləlik, zədələr, məqsədlər) və etdiyim məşqlərin yalnız mənə '
          'fərdi və təhlükəsiz qulluq və idman planı qurmaq və saxlamaq üçün '
          'emal olunmasına açıq razılıq verirəm. Bu məlumatlar şifrələnmiş '
          'saxlanılır, üçüncü tərəflərə verilmir və analitikada istifadə '
          'olunmur. Razılığı istənilən vaxt Parametrlər → Məxfilik bölməsində '
          'geri götürə bilərəm; bu halda həmin məlumatlar 24 saat ərzində '
          'serverdən silinir.',
      'ru':
          'Я даю явное согласие на обработку моих ответов о состоянии кожи, '
          'аллергиях, беременности и категориях принимаемых лекарств, созданных '
          'мной рутин и отметок об их выполнении, моих предпочтений по '
          'продуктам, проверенных мной продуктов и списка покупок, а также моих '
          'ответов в спортивной анкете (беременность, травмы, цели) и '
          'выполненных тренировок исключительно для составления и хранения '
          'персонального и безопасного ухода и плана тренировок. Эти данные '
          'хранятся в зашифрованном виде, не передаются третьим лицам и не '
          'используются в аналитике. Я могу отозвать согласие в любой момент в '
          'разделе Настройки → Конфиденциальность; в этом случае данные '
          'удаляются с сервера в течение 24 часов.',
      'en':
          'I give explicit consent to the processing of my answers about skin '
          'conditions, allergies, pregnancy and the categories of medicines I '
          'take, of the routines I create and their daily ticks, of my product '
          'preferences, the products I check and my shopping list, and of my '
          'answers to the fitness questions (pregnancy, injuries, goals) and the '
          'workouts I do, solely to build and keep a personal and safe care and '
          'workout plan. This data is stored encrypted, is not shared with third '
          'parties and is not used for analytics. I can withdraw consent at any '
          'time in Settings → Privacy; the data is then deleted from the server '
          'within 24 hours.',
    },
  ),
  // Adds the daily plate of the nutrition tool (2026-11-16).
  ConsentText(
    kind: ConsentKind.health,
    version: 'health-2026-11-draft5',
    bodies: {
      'az':
          'Dəri vəziyyətləri, allergiyalar, hamiləlik və qəbul etdiyim dərman '
          'kateqoriyaları haqqında cavablarımın, özüm yaratdığım rutinlərin və '
          'onların gündəlik qeydlərinin, məhsul seçimlərimin, yoxladığım '
          'məhsulların və alış siyahımın, idman sorğusuna cavablarımın '
          '(hamiləlik, zədələr, məqsədlər) və etdiyim məşqlərin, həmçinin '
          'gündəlik boşqab qeydlərimin yalnız mənə fərdi və təhlükəsiz qulluq, '
          'idman və qidalanma planı qurmaq və saxlamaq üçün emal olunmasına '
          'açıq razılıq verirəm. Bu məlumatlar şifrələnmiş saxlanılır, üçüncü '
          'tərəflərə verilmir və analitikada istifadə olunmur. Razılığı '
          'istənilən vaxt Parametrlər → Məxfilik bölməsində geri götürə bilərəm; '
          'bu halda həmin məlumatlar 24 saat ərzində serverdən silinir.',
      'ru':
          'Я даю явное согласие на обработку моих ответов о состоянии кожи, '
          'аллергиях, беременности и категориях принимаемых лекарств, созданных '
          'мной рутин и отметок об их выполнении, моих предпочтений по '
          'продуктам, проверенных мной продуктов и списка покупок, моих ответов '
          'в спортивной анкете (беременность, травмы, цели) и выполненных '
          'тренировок, а также моих ежедневных записей о тарелке исключительно '
          'для составления и хранения персонального и безопасного плана ухода, '
          'тренировок и питания. Эти данные хранятся в зашифрованном виде, не '
          'передаются третьим лицам и не используются в аналитике. Я могу '
          'отозвать согласие в любой момент в разделе Настройки → '
          'Конфиденциальность; в этом случае данные удаляются с сервера в '
          'течение 24 часов.',
      'en':
          'I give explicit consent to the processing of my answers about skin '
          'conditions, allergies, pregnancy and the categories of medicines I '
          'take, of the routines I create and their daily ticks, of my product '
          'preferences, the products I check and my shopping list, of my answers '
          'to the fitness questions (pregnancy, injuries, goals) and the '
          'workouts I do, and of my daily plate entries, solely to build and '
          'keep a personal and safe care, workout and nutrition plan. This data '
          'is stored encrypted, is not shared with third parties and is not used '
          'for analytics. I can withdraw consent at any time in Settings → '
          'Privacy; the data is then deleted from the server within 24 hours.',
    },
  ),
  // The same texts in every interface language (2026-11-27).
  ConsentText(
    kind: ConsentKind.health,
    version: 'health-2026-11-draft6',
    bodies: {
      'az':
          'Dəri vəziyyətləri, allergiyalar, hamiləlik və qəbul etdiyim dərman kateqoriyaları haqqında cavablarımın, özüm yaratdığım rutinlərin və onların gündəlik qeydlərinin, məhsul seçimlərimin, yoxladığım məhsulların və alış siyahımın, idman sorğusuna cavablarımın (hamiləlik, zədələr, məqsədlər) və etdiyim məşqlərin, həmçinin gündəlik boşqab qeydlərimin yalnız mənə fərdi və təhlükəsiz qulluq, idman və qidalanma planı qurmaq və saxlamaq üçün emal olunmasına açıq razılıq verirəm. Bu məlumatlar şifrələnmiş saxlanılır, üçüncü tərəflərə verilmir və analitikada istifadə olunmur. Razılığı istənilən vaxt Parametrlər → Məxfilik bölməsində geri götürə bilərəm; bu halda həmin məlumatlar 24 saat ərzində serverdən silinir.',
      'tr':
          'Cilt durumları, alerjiler, hamilelik ve kullandığım ilaç kategorileri hakkındaki yanıtlarımın, kendi oluşturduğum rutinlerin ve bunların günlük kayıtlarının, ürün tercihlerimin, kontrol ettiğim ürünlerin ve alışveriş listemin, spor anketine verdiğim yanıtların (hamilelik, sakatlıklar, hedefler) ve yaptığım antrenmanların, ayrıca günlük tabak kayıtlarımın yalnızca bana kişisel ve güvenli bir bakım, spor ve beslenme planı oluşturmak ve saklamak amacıyla işlenmesine açık rıza veriyorum. Bu veriler şifrelenmiş olarak saklanır, üçüncü taraflara aktarılmaz ve analitikte kullanılmaz. Rızamı istediğim zaman Ayarlar → Gizlilik bölümünden geri alabilirim; bu durumda söz konusu veriler 24 saat içinde sunucudan silinir.',
      'ru':
          'Я даю явное согласие на обработку моих ответов о состоянии кожи, аллергиях, беременности и категориях принимаемых лекарств, созданных мной рутин и отметок об их выполнении, моих предпочтений по продуктам, проверенных мной продуктов и списка покупок, моих ответов в спортивной анкете (беременность, травмы, цели) и выполненных тренировок, а также моих ежедневных записей о тарелке исключительно для составления и хранения персонального и безопасного плана ухода, тренировок и питания. Эти данные хранятся в зашифрованном виде, не передаются третьим лицам и не используются в аналитике. Я могу отозвать согласие в любой момент в разделе Настройки → Конфиденциальность; в этом случае данные удаляются с сервера в течение 24 часов.',
      'en':
          'I give explicit consent to the processing of my answers about skin conditions, allergies, pregnancy and the categories of medicines I take, of the routines I create and their daily ticks, of my product preferences, the products I check and my shopping list, of my answers to the fitness questions (pregnancy, injuries, goals) and the workouts I do, and of my daily plate entries, solely to build and keep a personal and safe care, workout and nutrition plan. This data is stored encrypted, is not shared with third parties and is not used for analytics. I can withdraw consent at any time in Settings → Privacy; the data is then deleted from the server within 24 hours.',
      'kk':
          'Тері жағдайлары, аллергиялар, жүктілік және өзім қабылдайтын дәрі санаттары туралы жауаптарымның, өзім жасаған рутиналардың және олардың күнделікті белгілерінің, өнімге қатысты таңдауларымның, өзім тексерген өнімдердің және сатып алу тізімімнің, спорт сауалнамасына берген жауаптарымның (жүктілік, жарақаттар, мақсаттар) және орындаған жаттығуларымның, сондай-ақ күнделікті тәрелке жазбаларымның тек маған арналған жеке және қауіпсіз күтім, жаттығу және тамақтану жоспарын құру және сақтау үшін өңделуіне айқын келісім беремін. Бұл деректер шифрланған түрде сақталады, үшінші тұлғаларға берілмейді және аналитикада пайдаланылмайды. Келісімді кез келген уақытта Баптаулар → Құпиялық бөлімінде кері қайтарып ала аламын; бұл жағдайда аталған деректер 24 сағат ішінде серверден жойылады.',
      'uz':
          'Teri holatlari, allergiyalar, homiladorlik va qabul qiladigan dori toifalarim haqidagi javoblarimning, oʻzim yaratgan tartiblar va ularning kundalik belgilarining, mahsulot tanlovlarimning, tekshirgan mahsulotlarim va xarid roʻyxatimning, sport soʻrovnomasiga bergan javoblarimning (homiladorlik, jarohatlar, maqsadlar) va bajargan mashgʻulotlarimning, shuningdek kundalik likopcha yozuvlarimning faqat men uchun shaxsiy va xavfsiz parvarish, sport va ovqatlanish rejasini tuzish va saqlash maqsadida qayta ishlanishiga aniq rozilik beraman. Bu maʼlumotlar shifrlangan holda saqlanadi, uchinchi shaxslarga berilmaydi va analitikada foydalanilmaydi. Rozilikni istalgan vaqtda Sozlamalar → Maxfiylik boʻlimida qaytarib olishim mumkin; bu holda ushbu maʼlumotlar 24 soat ichida serverdan oʻchiriladi.',
      'tk':
          'Deri ýagdaýlary, allergiýalar, göwrelilik we kabul edýän dermanlarymyň kategoriýalary barada jogaplarymyň, özüm döreden tertiplerimiň we olaryň gündelik ýazgylarynyň, önüm saýlawlarymyň, barlan önümlerimiň we satyn alyş sanawymyň, sport soragnamasyna jogaplarymyň (göwrelilik, şikesler, maksatlar) we eden türgenleşiklerimiň, şeýle hem gündelik tabak ýazgylarymyň diňe maňa şahsy we howpsuz ideg, sport we iýmitlenme meýilnamasyny düzmek we saklamak üçin işlenip taýýarlanmagyna aç-açan razylyk berýärin. Bu maglumatlar şifrlenen görnüşde saklanýar, üçünji taraplara berilmeýär we analitikada ulanylmaýar. Razylygy islendik wagt Sazlamalar → Gizlinlik bölüminde yzyna alyp bilerin; bu ýagdaýda şol maglumatlar 24 sagadyň dowamynda serwerden pozulýar.',
      'ky':
          'Мен теринин абалы, аллергиялар, кош бойлуулук жана мен кабыл алган дарылардын категориялары жөнүндө жоопторумду, өзүм түзгөн рутиналарды жана алардын күнүмдүк белгилерин, продукт тандоолорумду, мен текшерген продукттарды жана сатып алуу тизмемди, спорттук сурамжылоого берген жоопторумду (кош бойлуулук, жаракаттар, максаттар) жана аткарган машыгууларымды, ошондой эле күнүмдүк табак жазууларымды мага жеке жана коопсуз кам көрүү, машыгуу жана тамактануу планын түзүү жана сактоо үчүн гана иштетүүгө ачык макулдук берем. Бул маалыматтар шифрленген түрдө сакталат, үчүнчү жактарга берилбейт жана аналитикада колдонулбайт. Макулдукту каалаган убакта Жөндөөлөр → Купуялык бөлүмүндө кайтарып ала алам; бул учурда ал маалыматтар 24 сааттын ичинде серверден өчүрүлөт.',
      'ka':
          'ვაძლევ აშკარა თანხმობას, რომ ჩემი პასუხები კანის მდგომარეობის, ალერგიების, ორსულობისა და ჩემ მიერ მიღებული მედიკამენტების კატეგორიების შესახებ, ჩემ მიერ შექმნილი რუტინები და მათი ყოველდღიური აღნიშვნები, პროდუქტებთან დაკავშირებული ჩემი არჩევანი, ჩემ მიერ შემოწმებული პროდუქტები და ჩემი საყიდლების სია, ჩემი პასუხები სპორტულ კითხვარზე (ორსულობა, ტრავმები, მიზნები) და ჩემ მიერ შესრულებული ვარჯიშები, ასევე ჩემი ყოველდღიური თეფშის ჩანაწერები დამუშავდეს მხოლოდ იმისათვის, რომ ჩემთვის შედგეს და შენახულ იქნეს პერსონალური და უსაფრთხო მოვლის, ვარჯიშისა და კვების გეგმა. ეს მონაცემები ინახება დაშიფრული სახით, არ გადაეცემა მესამე პირებს და არ გამოიყენება ანალიტიკაში. თანხმობის გამოხმობა ნებისმიერ დროს შემიძლია განყოფილებაში პარამეტრები → კონფიდენციალურობა; ამ შემთხვევაში ეს მონაცემები სერვერიდან იშლება 24 საათის განმავლობაში.',
    },
  ),
  ConsentText(
    kind: ConsentKind.analytics,
    version: 'analytics-2026-11-draft2',
    bodies: {
      'az':
          'Tətbiqin necə istifadə olunduğunu anlamaq üçün şəxsiyyətimi birbaşa göstərməyən identifikatorla istifadə statistikasının (açılan ekranlar, istifadə olunan funksiyalar) toplanmasına razıyam. Sağlamlıq cavablarım analitikaya heç vaxt göndərilmir.',
      'tr':
          'Uygulamanın nasıl kullanıldığını anlamak amacıyla, kimliğimi doğrudan ortaya koymayan bir tanımlayıcıyla kullanım istatistiklerinin (açılan ekranlar, kullanılan özellikler) toplanmasını kabul ediyorum. Sağlık yanıtlarım hiçbir zaman analitiğe gönderilmez.',
      'ru':
          'Я даю согласие на сбор статистики использования (открытые экраны, используемые функции) с идентификатором, который не раскрывает мою личность напрямую, чтобы понять, как используется приложение. Мои ответы о здоровье никогда не передаются в аналитику.',
      'en':
          'I agree to the collection of usage statistics (screens opened, features used) under an identifier that does not directly reveal who I am, to understand how the app is used. My health answers are never sent to analytics.',
      'kk':
          'Қолданбаның қалай пайдаланылатынын түсіну үшін менің жеке басымды тікелей ашпайтын сәйкестендіргішпен пайдалану статистикасының (ашылған экрандар, пайдаланылған функциялар) жиналуына келісемін. Денсаулыққа қатысты жауаптарым аналитикаға ешқашан жіберілмейді.',
      'uz':
          'Ilovadan qanday foydalanilishini tushunish uchun shaxsimni bevosita koʻrsatmaydigan identifikator bilan foydalanish statistikasi (ochilgan ekranlar, foydalanilgan funksiyalar) yigʻilishiga roziman. Sogʻligʻimga oid javoblarim hech qachon analitikaga yuborilmaydi.',
      'tk':
          'Programmanyň nähili ulanylýandygyna düşünmek üçin şahsyýetimi gönüden-göni görkezmeýän identifikator bilen ulanyş statistikasynyň (açylan ekranlar, ulanylýan funksiýalar) ýygnalmagyna razydyryn. Saglyk bilen bagly jogaplarym analitika hiç haçan iberilmeýär.',
      'ky':
          'Тиркеме кантип колдонуларын түшүнүү үчүн менин инсандыгымды түздөн-түз ачыкка чыгарбаган идентификатор менен колдонуу статистикасын (ачылган экрандар, колдонулган функциялар) чогултууга макулмун. Ден соолук тууралуу жоопторум аналитикага эч качан жөнөтүлбөйт.',
      'ka':
          'ვეთანხმები, რომ აპლიკაციის გამოყენების წესის გასაგებად შეგროვდეს გამოყენების სტატისტიკა (გახსნილი ეკრანები, გამოყენებული ფუნქციები) იდენტიფიკატორით, რომელიც პირდაპირ არ ავლენს ჩემს ვინაობას. ჩემი პასუხები ჯანმრთელობის შესახებ ანალიტიკაში არასდროს იგზავნება.',
    },
  ),
  ConsentText(
    kind: ConsentKind.marketing,
    version: 'marketing-2026-11-draft2',
    bodies: {
      'az':
          'Parla yenilikləri və məsləhətləri haqqında e-poçt almağa razıyam. İstənilən məktubdakı linklə abunəlikdən çıxa bilərəm.',
      'tr':
          'Parla yenilikleri ve önerileri hakkında e-posta almayı kabul ediyorum. Herhangi bir e-postadaki bağlantıyla abonelikten çıkabilirim.',
      'ru':
          'Я даю согласие получать по электронной почте новости и советы Parla. Я могу отписаться по ссылке в любом письме.',
      'en':
          'I agree to receive emails with Parla news and tips. I can unsubscribe via the link in any email.',
      'kk':
          'Parla жаңалықтары мен кеңестері туралы электрондық хаттар алуға келісемін. Кез келген хаттағы сілтеме арқылы жазылымнан бас тарта аламын.',
      'uz':
          'Parla yangiliklari va maslahatlari haqida elektron pochta orqali xatlar olishga roziman. Istalgan xatdagi havola orqali obunadan chiqishim mumkin.',
      'tk':
          'Parla-nyň täzelikleri we maslahatlary barada e-poçta arkaly hat almaga razydyryn. Islendik hatdaky baglanyşyk arkaly abunalykdan çykyp bilerin.',
      'ky':
          'Parla жаңылыктары жана кеңештери тууралуу электрондук каттарды алууга макулмун. Каалаган каттагы шилтеме аркылуу жазылуудан баш тарта алам.',
      'ka':
          'ვეთანხმები, რომ ელფოსტით მივიღო წერილები Parla-ს სიახლეებისა და რჩევების შესახებ. გამოწერის გაუქმება შემიძლია ნებისმიერ წერილში მოცემული ბმულით.',
    },
  ),
];

/// Health consent versions that cover the user's own routines and their
/// ticks. Older versions only cover the quiz answers, so the server keeps
/// own routines only for someone who agreed to one of these.
const healthVersionsCoveringOwnRoutines = {
  'health-2026-11-draft2',
  'health-2026-11-draft3',
  'health-2026-11-draft4',
  'health-2026-11-draft5',
  'health-2026-11-draft6',
};

/// Health consent versions that cover product preferences, checked
/// products and the shopping list.
const healthVersionsCoveringCareList = {
  'health-2026-11-draft3',
  'health-2026-11-draft4',
  'health-2026-11-draft5',
  'health-2026-11-draft6',
};

/// Health consent versions that cover the sport answers and workout log.
const healthVersionsCoveringSport = {
  'health-2026-11-draft4',
  'health-2026-11-draft5',
  'health-2026-11-draft6',
};

/// Health consent versions that cover the daily plate.
const healthVersionsCoveringNutrition = {
  'health-2026-11-draft5',
  'health-2026-11-draft6',
};

/// The version currently shown for [kind].
ConsentText currentConsentText(ConsentKind kind) =>
    consentTextHistory.lastWhere((t) => t.kind == kind);

/// Looks up a specific version, or `null` if it does not exist.
ConsentText? consentTextByVersion(ConsentKind kind, String version) {
  for (final text in consentTextHistory) {
    if (text.kind == kind && text.version == version) return text;
  }
  return null;
}
