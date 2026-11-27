/// The website's texts in az, ru and en (the languages Parla stands behind
/// in writing). The privacy claims here must stay true to
/// docs/ARCHITECTURE.md and the privacy policy.
library;

/// The website's languages; Azerbaijani is served at `/`, the others
/// below `/ru` and `/en`.
const siteLanguages = ['az', 'ru', 'en'];

/// The site's text [key] in [language].
String siteText(String key, String language) =>
    _texts[key]?[language] ?? _texts[key]?['az'] ?? key;

const _texts = <String, Map<String, String>>{
  'title': {
    'az': 'Parla — gözəllik və qulluq bələdçin',
    'ru': 'Parla — твой гид по красоте и уходу',
    'en': 'Parla — your beauty and care guide',
  },
  'description': {
    'az':
        'Dərinə, saçına və gününə uyğun sadə rutin, tərkib izahları, '
        'məqalələr, reseptlər və yüngül məşqlər — hamısı bir tətbiqdə.',
    'ru':
        'Простой уход под твою кожу, волосы и день, разбор составов, '
        'статьи, рецепты и лёгкие тренировки — в одном приложении.',
    'en':
        'A simple routine for your skin, hair and day, ingredient '
        'explanations, articles, recipes and light workouts — in one app.',
  },
  'navFeatures': {'az': 'İmkanlar', 'ru': 'Возможности', 'en': 'Features'},
  'navPrivacy': {'az': 'Məxfilik', 'ru': 'Приватность', 'en': 'Privacy'},
  'navBlog': {'az': 'Bloq', 'ru': 'Блог', 'en': 'Blog'},
  'heroPill': {
    'az': '18+ qadınlar üçün',
    'ru': 'Для женщин 18+',
    'en': 'For women 18+',
  },
  'heroBefore': {'az': 'Sənin ', 'ru': 'Твой гид по ', 'en': 'Your '},
  'heroAccent': {'az': 'gözəllik', 'ru': 'красоте', 'en': 'beauty'},
  'heroAfter': {
    'az': ' və qulluq bələdçin',
    'ru': ' и уходу',
    'en': ' and care guide',
  },
  'storeGet': {'az': 'Yüklə', 'ru': 'Скачать в', 'en': 'Get it on'},
  'languagesNote': {
    'az': 'Azərbaycan, rus və ingilis dillərində, interfeys isə 9 dildə.',
    'ru': 'На азербайджанском, русском и английском, интерфейс — на 9 языках.',
    'en':
        'In Azerbaijani, Russian and English, with the interface in 9 '
        'languages.',
  },
  'featuresTitle': {
    'az': 'Gündəlik qulluq, sadə addımlarla',
    'ru': 'Ежедневный уход простыми шагами',
    'en': 'Everyday care, in simple steps',
  },
  'f1Title': {'az': 'Şəxsi rutin', 'ru': 'Личный уход', 'en': 'Your routine'},
  'f1Body': {
    'az':
        'Qısa testdən sonra səhər və axşam addımları. Bildirişləri özün '
        'qurursan.',
    'ru':
        'После короткого теста — утренние и вечерние шаги. Напоминания '
        'настраиваешь сама.',
    'en':
        'Morning and evening steps after a short quiz. You set the '
        'reminders yourself.',
  },
  'f2Title': {
    'az': 'Tərkibi yoxla',
    'ru': 'Проверь состав',
    'en': 'Check ingredients',
  },
  'f2Body': {
    'az':
        'Məhsulun tərkibini oxu, hər komponentin nə üçün olduğunu sadə '
        'dildə gör.',
    'ru':
        'Читай состав средства и смотри простыми словами, зачем каждый '
        'компонент.',
    'en':
        'Read a product\'s ingredients and see what each one is for, in '
        'plain words.',
  },
  'f3Title': {
    'az': 'Məqalə və reseptlər',
    'ru': 'Статьи и рецепты',
    'en': 'Articles and recipes',
  },
  'f3Body': {
    'az':
        'Dəri, saç, qidalanma və mövsümi qulluq barədə maarifləndirici '
        'yazılar.',
    'ru':
        'Познавательные материалы о коже, волосах, питании и сезонном '
        'уходе.',
    'en': 'Educational reads on skin, hair, food and seasonal care.',
  },
  'privacyPill': {'az': 'Məxfilik', 'ru': 'Приватность', 'en': 'Privacy'},
  'privacyTitle': {
    'az': 'Məlumatın sənindir',
    'ru': 'Твои данные — твои',
    'en': 'Your data is yours',
  },
  'privacyLead': {
    'az':
        'Parla sağlamlıqla bağlı həssas məlumatla işləyir, ona görə ancaq '
        'lazım olanı soruşur.',
    'ru':
        'Parla работает с чувствительными данными о здоровье, поэтому '
        'спрашивает только необходимое.',
    'en':
        'Parla handles sensitive health data, so it only asks for what it '
        'needs.',
  },
  'p1Bold': {
    'az': 'Ad, telefon, tam doğum tarixi, yer və şəkil soruşmuruq.',
    'ru':
        'Мы не спрашиваем имя, телефон, полную дату рождения, '
        'местоположение и фото.',
    'en':
        'We never ask for your name, phone, full birth date, location or '
        'photos.',
  },
  'p1': {
    'az': 'Qeydiyyat yalnız e-poçtla.',
    'ru': 'Регистрация — только по e-mail.',
    'en': 'You sign up with an email only.',
  },
  'p2Bold': {
    'az': 'Sağlamlıq cavabları şifrələnir',
    'ru': 'Ответы о здоровье шифруются',
    'en': 'Health answers are encrypted',
  },
  'p2': {
    'az': 'və yalnız razılığınla saxlanılır. Razılığı geri götürəndə silinir.',
    'ru':
        'и хранятся только с твоего согласия. При отзыве согласия они '
        'удаляются.',
    'en':
        'and kept only with your consent. Withdraw it and they are '
        'deleted.',
  },
  'p3Bold': {
    'az': 'Reklam izləməsi yoxdur.',
    'ru': 'Нет рекламной слежки.',
    'en': 'No ad tracking.',
  },
  'p3': {
    'az': 'Məlumatın satılmır və başqasına verilmir.',
    'ru': 'Твои данные не продаются и не передаются другим.',
    'en': 'Your data is not sold or given to others.',
  },
  'p4Bold': {
    'az': 'Hesabını istədiyin an silə bilərsən',
    'ru': 'Аккаунт можно удалить в любой момент',
    'en': 'You can delete your account any time',
  },
  'p4': {
    'az': '— tətbiqin içindən.',
    'ru': '— прямо в приложении.',
    'en': '— right in the app.',
  },
  'blogTitle': {'az': 'Bloqdan', 'ru': 'Из блога', 'en': 'From the blog'},
  'blogAll': {
    'az': 'Bütün məqalələr',
    'ru': 'Все статьи',
    'en': 'All articles',
  },
  'blogPageTitle': {'az': 'Bloq', 'ru': 'Блог', 'en': 'Blog'},
  'blogPageLead': {
    'az': 'Dəri, saç, bədən və gündəlik qulluq barədə maarifləndirici yazılar.',
    'ru': 'Познавательные статьи о коже, волосах, теле и ежедневном уходе.',
    'en': 'Educational articles on skin, hair, body and everyday care.',
  },
  'blogEmpty': {
    'az': 'Tezliklə burada məqalələr olacaq.',
    'ru': 'Скоро здесь появятся статьи.',
    'en': 'Articles are coming soon.',
  },
  'disclaimer': {
    'az':
        'Məqalələr maarifləndirici xarakter daşıyır və həkim məsləhətini '
        'əvəz etmir.',
    'ru':
        'Статьи носят познавательный характер и не заменяют консультацию '
        'врача.',
    'en': 'Articles are for education and do not replace a doctor\'s advice.',
  },
  'minutes': {'az': '{n} dəq', 'ru': '{n} мин', 'en': '{n} min'},
  'sources': {'az': 'Mənbələr', 'ru': 'Источники', 'en': 'Sources'},
  'backToBlog': {
    'az': '← Bütün məqalələr',
    'ru': '← Все статьи',
    'en': '← All articles',
  },
  'articleCta': {
    'az': 'Rutinini Parla tətbiqində qur',
    'ru': 'Собери свой уход в приложении Parla',
    'en': 'Build your routine in the Parla app',
  },
  'catCare': {'az': 'Qulluq', 'ru': 'Уход', 'en': 'Care'},
  'catBeauty': {'az': 'Gözəllik', 'ru': 'Красота', 'en': 'Beauty'},
  'catFashion': {'az': 'Moda', 'ru': 'Мода', 'en': 'Fashion'},
  'catHair': {'az': 'Saç', 'ru': 'Волосы', 'en': 'Hair'},
  'catBody': {'az': 'Bədən', 'ru': 'Тело', 'en': 'Body'},
  'docs': {'az': 'Sənədlər', 'ru': 'Документы', 'en': 'Documents'},
  'privacyPolicy': {
    'az': 'Məxfilik siyasəti',
    'ru': 'Политика конфиденциальности',
    'en': 'Privacy policy',
  },
  'terms': {
    'az': 'İstifadə şərtləri',
    'ru': 'Условия использования',
    'en': 'Terms of use',
  },
  'language': {'az': 'Dil', 'ru': 'Язык', 'en': 'Language'},
  'dpo': {
    'az': 'Fərdi məlumatlar üzrə məsul şəxs',
    'ru': 'Ответственная за персональные данные',
    'en': 'Data protection officer',
  },
  'taxId': {'az': 'VÖEN', 'ru': 'ИНН (VÖEN)', 'en': 'Tax ID (VÖEN)'},
  'legalMissing': {
    'az': 'Sənəd hazırlanır.',
    'ru': 'Документ готовится.',
    'en': 'The document is being prepared.',
  },
  'notFound': {
    'az': 'Səhifə tapılmadı.',
    'ru': 'Страница не найдена.',
    'en': 'Page not found.',
  },
  'home': {'az': 'Ana səhifə', 'ru': 'Главная', 'en': 'Home'},
  // The website's own processing, shown above the privacy policy. Needs
  // the lawyer's check (docs/legal/lawyer-questions.md).
  'siteNoticeTitle': {
    'az': 'Bu sayt haqqında',
    'ru': 'Об этом сайте',
    'en': 'About this website',
  },
  'siteNotice': {
    'az':
        'Sayt cookie istifadə etmir və kənar izləmə xidmətlərinə qoşulmur. '
        'Saytın necə istifadə olunduğunu bilmək üçün yalnız gündəlik cəm '
        'saylar saxlayırıq: hansı səhifəyə baxılıb, dil, hansı saytdan '
        'keçid edilib, cihaz, brauzer və əməliyyat sisteminin növü, düymə '
        'klikləri və oxuma dərinliyi. Gündəlik ziyarətçi sayını bilmək üçün '
        'IP ünvanı və brauzer məlumatı həmin günün təsadüfi açarı ilə '
        'geri qaytarılmayan koda çevrilir; IP ünvanı saxlanılmır, kodlar və '
        'açar növbəti gün silinir. Cəm saylar 24 ay saxlanılır və heç kimi '
        'tanımağa imkan vermir.',
    'ru':
        'Сайт не использует cookie и не подключает сторонние сервисы '
        'отслеживания. Чтобы понимать, как пользуются сайтом, мы храним '
        'только ежедневные суммарные счётчики: какие страницы открывали, '
        'язык, с какого сайта перешли, тип устройства, браузера и '
        'операционной системы, нажатия кнопок и глубину прочтения. Для '
        'подсчёта посетителей за день IP-адрес и данные браузера '
        'превращаются в необратимый код со случайным ключом этого дня; '
        'IP-адрес не хранится, коды и ключ удаляются на следующий день. '
        'Суммарные счётчики хранятся 24 месяца и не позволяют никого '
        'узнать.',
    'en':
        'This website sets no cookies and loads no third-party tracking. To '
        'see how it is used we keep only daily totals: which pages were '
        'viewed, the language, the referring site, the kind of device, '
        'browser and operating system, button clicks and reading depth. To '
        'count each day\'s visitors, the IP address and browser details are '
        'turned into a one-way code with a random key for that day; the IP '
        'address is not stored, and the codes and the key are deleted the '
        'next day. The totals are kept for 24 months and identify no one.',
  },
};
