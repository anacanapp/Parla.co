/// The onboarding quiz (screens M-09 to M-13).
///
/// DRAFT CONTENT from the content sheet "Parla — Məzmun" (test_suallari),
/// NOT EXPERT-APPROVED: every question has `approved: false` until a
/// dermatologist (and, for the health questions, a lawyer) reviews it.
/// The sheet's age question is left out: the age comes from the birth year
/// and the app is 18+ only. The warning-signs question is our own. Questions only ask about diagnoses a doctor has already made,
/// never infer a condition (MDR rule, see the regulation analysis).
library;

import 'texts/translations.dart';

/// Groups of questions, in the order the quiz asks them.
enum QuizSection { skin, health, lifestyle, body, hair, safety }

/// One answer option with its text per language.
class QuizOption {
  const QuizOption(this.id, this.text, {this.exclusive = false});

  final String id;
  final Map<String, String> text;

  /// Cannot be combined with other options ("none of these").
  final bool exclusive;
}

/// One quiz question.
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.section,
    required this.text,
    required this.options,
    this.why = const {},
    this.multiple = false,
    this.sensitive = false,
    this.stored = true,
    this.redFlagOptionIds = const {},
    this.approved = false,
  });

  final String id;
  final QuizSection section;
  final Map<String, String> text;
  final List<QuizOption> options;

  /// Why we ask, per language (shown under the question).
  final Map<String, String> why;

  /// Several options may be chosen.
  final bool multiple;

  /// Health data (GDPR Art. 9): only asked with the health consent, stored
  /// encrypted, and every such question can be declined.
  final bool sensitive;

  /// `false`: the answer never leaves the device (warning signs).
  final bool stored;

  /// Options that must send the user to the "see a doctor" screen (M-12).
  final Set<String> redFlagOptionIds;

  /// Reviewed and approved by an expert.
  final bool approved;

  /// Whether the user may skip this question ("I'd rather not answer").
  bool get declinable => sensitive || !stored;

  QuizOption? option(String id) {
    for (final o in options) {
      if (o.id == id) return o;
    }
    return null;
  }

  /// Whether [optionIds] is a well-formed answer to this question.
  bool accepts(List<String> optionIds) {
    if (optionIds.isEmpty) return false;
    if (optionIds.toSet().length != optionIds.length) return false;
    if (!multiple && optionIds.length != 1) return false;
    final chosen = <QuizOption>[];
    for (final id in optionIds) {
      final o = option(id);
      if (o == null) return false;
      chosen.add(o);
    }
    if (chosen.length > 1 && chosen.any((o) => o.exclusive)) return false;
    return true;
  }
}

/// Version of the question set; stored with answers.
const quizContentVersion = 'quiz-2026-11-sheet1';

/// The text in az, ru and en, plus its translations into the other
/// interface languages (`texts/translations.dart`).
Map<String, String> _t(String az, String ru, String en) =>
    withTranslations({'az': az, 'ru': ru, 'en': en});

final List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 'skin_type',
    section: QuizSection.skin,
    text: _t(
      "Üz dərin gün ərzində özünü necə hiss edir?",
      "Как ведёт себя кожа твоего лица в течение дня?",
      "How does your facial skin feel during the day?",
    ),
    why: _t(
      "Təmizləyicini və kremin teksturasını buna görə seçirik.",
      "По этому подбираем тебе очищение и текстуру крема.",
      "This helps us pick your cleanser and moisturiser texture.",
    ),
    options: [
      QuizOption(
        'dry',
        _t("Quru, dartılır", "Сухая, стянутая", "Dry, feels tight"),
      ),
      QuizOption(
        'oily',
        _t("Yağlı, parlayır", "Жирная, блестит", "Oily, gets shiny"),
      ),
      QuizOption(
        'combination',
        _t(
          "Qarışıq (alın, burun, çənə yağlı)",
          "Комбинированная (жирная Т-зона)",
          "Combination (oily T-zone)",
        ),
      ),
      QuizOption(
        'normal',
        _t("Normal, rahat", "Нормальная, комфортная", "Normal, comfortable"),
      ),
      QuizOption('unsure', _t("Bilmirəm", "Не знаю", "Not sure")),
    ],
  ),
  QuizQuestion(
    id: 'sensitivity',
    section: QuizSection.skin,
    text: _t(
      "Yeni məhsuldan sonra dərin qızarır, yanır və ya gicişir?",
      "После нового средства твоя кожа краснеет, жжёт или зудит?",
      "Does your skin turn red, burn or itch after a new product?",
    ),
    why: _t(
      "Həssas dəri üçün ətirsiz, yumşaq məhsullar seçir və güclü turşuları çıxarırıq.",
      "Для чувствительной кожи выбираем мягкие средства без отдушек и убираем сильные кислоты.",
      "For sensitive skin we choose gentle, fragrance-free products and skip strong acids.",
    ),
    options: [
      QuizOption('often', _t("Tez-tez", "Часто", "Often")),
      QuizOption('sometimes', _t("Bəzən", "Иногда", "Sometimes")),
      QuizOption(
        'never',
        _t("Demək olar ki, heç vaxt", "Почти никогда", "Almost never"),
      ),
    ],
  ),
  QuizQuestion(
    id: 'concerns',
    section: QuizSection.skin,
    multiple: true,
    text: _t(
      "Səni ən çox nə narahat edir? Bir neçəsini seçə bilərsən.",
      "Что тебя беспокоит больше всего? Можно выбрать несколько.",
      "What bothers you most? You can pick several.",
    ),
    why: _t(
      "Aktiv addımları bu məqsədlərə görə əlavə edirik.",
      "Активные шаги добавляем под эти цели.",
      "We add active steps based on these goals.",
    ),
    options: [
      QuizOption('breakouts', _t("Səpgilər", "Высыпания", "Breakouts")),
      QuizOption(
        'dark_spots',
        _t(
          "Ləkələr, qeyri-bərabər ton",
          "Пятна, неровный тон",
          "Dark spots, uneven tone",
        ),
      ),
      QuizOption('redness', _t("Qızartı", "Покраснение", "Redness")),
      QuizOption(
        'dryness',
        _t("Quruluq, dartılma", "Сухость, стянутость", "Dryness, tightness"),
      ),
      QuizOption(
        'fine_lines',
        _t("İncə xətlər", "Мелкие морщины", "Fine lines"),
      ),
      QuizOption(
        'pores',
        _t("Geniş məsamələr", "Расширенные поры", "Enlarged pores"),
      ),
      QuizOption(
        'none',
        _t(
          "Xüsusi narahatlıq yoxdur",
          "Ничего особенного",
          "Nothing in particular",
        ),
        exclusive: true,
      ),
    ],
  ),
  QuizQuestion(
    id: 'pregnancy',
    section: QuizSection.health,
    sensitive: true,
    text: _t(
      "Hazırda hamiləsən, uşağı əmizdirirsən və ya hamiləlik planlaşdırırsan?",
      "Ты сейчас беременна, кормишь грудью или планируешь беременность?",
      "Are you pregnant, breastfeeding or planning a pregnancy?",
    ),
    why: _t(
      "Bu dövrdə bəzi tərkiblər (məs. retinoidlər) tövsiyə olunmur. Cavabın yalnız rutini qurmaq üçün istifadə olunur və istənilən vaxt onu silə bilərsən.",
      "В этот период некоторые компоненты (напр., ретиноиды) не рекомендуются. Твой ответ используется только для подбора ухода, и ты можешь удалить его в любое время.",
      "Some ingredients, such as retinoids, aren't recommended during this time. Your answer is only used to build your routine and can be deleted any time.",
    ),
    options: [
      QuizOption('pregnant', _t("Hamiləyəm", "Беременна", "Pregnant")),
      QuizOption(
        'breastfeeding',
        _t("Əmizdirirəm", "Кормлю грудью", "Breastfeeding"),
      ),
      QuizOption(
        'trying',
        _t(
          "Hamiləlik planlaşdırıram",
          "Планирую беременность",
          "Planning a pregnancy",
        ),
      ),
      QuizOption('no', _t("Xeyr", "Нет", "No")),
      QuizOption(
        'prefer_not',
        _t("Demək istəmirəm", "Предпочитаю не отвечать", "Prefer not to say"),
      ),
    ],
  ),
  QuizQuestion(
    id: 'medications',
    section: QuizSection.health,
    sensitive: true,
    text: _t(
      "Həkimin təyin etdiyi dəri dərmanı istifadə edirsən?",
      "Ты используешь назначенные врачом препараты для кожи?",
      "Are you using any skin medication prescribed by a doctor?",
    ),
    why: _t(
      "Reseptli dərmanla eyni vaxtda güclü aktivlər qıcıqlanma yarada bilər. Belə halda rutinini sadə saxlayırıq.",
      "Сильные активы вместе с рецептурными средствами могут раздражать кожу. В таком случае твой уход будет простым.",
      "Strong actives alongside prescription treatments can irritate skin, so we keep your routine simple.",
    ),
    options: [
      QuizOption(
        'oral_isotretinoin',
        _t(
          "Ağızdan izotretinoin qəbul edirəm",
          "Принимаю изотретиноин внутрь",
          "Taking oral isotretinoin",
        ),
      ),
      QuizOption(
        'topical_rx',
        _t(
          "Dəriyə sürtülən reseptli dərman",
          "Наружное средство по рецепту",
          "A prescription cream or gel",
        ),
      ),
      QuizOption('none', _t("Xeyr", "Нет", "No")),
      QuizOption(
        'prefer_not',
        _t("Demək istəmirəm", "Предпочитаю не отвечать", "Prefer not to say"),
      ),
    ],
  ),
  QuizQuestion(
    id: 'allergies',
    section: QuizSection.health,
    multiple: true,
    sensitive: true,
    text: _t(
      "Kosmetikaya qarşı məlum allergiya və ya həssaslığın var?",
      "Есть ли у тебя известная аллергия или чувствительность к косметике?",
      "Do you have a known allergy or sensitivity to cosmetics?",
    ),
    why: _t(
      "“Yoxla” bölməsində bu maddələri sənin üçün işarələyirik.",
      "В разделе «Проверить» мы отметим эти вещества для тебя.",
      "We'll flag these ingredients for you in the Check section.",
    ),
    options: [
      QuizOption('fragrance', _t("Ətir", "Отдушки", "Fragrance")),
      QuizOption(
        'preservatives',
        _t("Konservantlar", "Консерванты", "Preservatives"),
      ),
      QuizOption('lanolin', _t("Lanolin", "Ланолин", "Lanolin")),
      QuizOption('none', _t("Yoxdur", "Нет", "None"), exclusive: true),
      QuizOption(
        'unsure',
        _t("Bilmirəm", "Не знаю", "Not sure"),
        exclusive: true,
      ),
    ],
  ),
  QuizQuestion(
    id: 'sun_exposure',
    section: QuizSection.lifestyle,
    text: _t(
      "Gündə çöldə nə qədər vaxt keçirirsən?",
      "Сколько времени в день ты проводишь на улице?",
      "How much time do you spend outdoors each day?",
    ),
    why: _t(
      "SPF-i təzələmək üçün xatırlatmaları buna görə qururuq.",
      "По этому настраиваем тебе напоминания обновить SPF.",
      "We use this to set reminders to reapply sunscreen.",
    ),
    options: [
      QuizOption('low', _t("1 saatdan az", "Меньше часа", "Less than an hour")),
      QuizOption('medium', _t("1–3 saat", "1–3 часа", "1–3 hours")),
      QuizOption(
        'high',
        _t("3 saatdan çox", "Больше 3 часов", "More than 3 hours"),
      ),
    ],
  ),
  QuizQuestion(
    id: 'makeup_spf',
    section: QuizSection.lifestyle,
    text: _t(
      "Makiyaj və ya suya davamlı SPF istifadə edirsən?",
      "Ты пользуешься макияжем или водостойким SPF?",
      "Do you wear makeup or water-resistant sunscreen?",
    ),
    why: _t(
      "Belədirsə, axşam rutininə iki mərhələli təmizləmə əlavə edirik.",
      "Если да, добавим тебе вечернее двухэтапное очищение.",
      "If so, we add an evening double cleanse.",
    ),
    options: [
      QuizOption('daily', _t("Hər gün", "Каждый день", "Every day")),
      QuizOption('sometimes', _t("Bəzən", "Иногда", "Sometimes")),
      QuizOption('no', _t("Xeyr", "Нет", "No")),
    ],
  ),
  QuizQuestion(
    id: 'routine_level',
    section: QuizSection.lifestyle,
    text: _t(
      "Rutinə nə qədər vaxt ayıra bilərsən?",
      "Сколько времени ты готова уделять уходу?",
      "How much time can you give your routine?",
    ),
    why: _t(
      "Qısa və sadə rutini hər gün davam etdirmək daha asandır.",
      "Короткий простой уход легче соблюдать каждый день.",
      "A short, simple routine is easier to stick with.",
    ),
    options: [
      QuizOption(
        'minimal',
        _t("Minimum: 3 addım", "Минимум: 3 шага", "Minimal: 3 steps"),
      ),
      QuizOption(
        'standard',
        _t("Orta: 4–5 addım", "Средний: 4–5 шагов", "Standard: 4–5 steps"),
      ),
      QuizOption('full', _t("Tam rutin", "Полный уход", "Full routine")),
    ],
  ),
  QuizQuestion(
    id: 'actives_experience',
    section: QuizSection.lifestyle,
    text: _t(
      "Retinol və ya turşulu məhsullar istifadə etmisən?",
      "Ты пользовалась ретинолом или кислотами?",
      "Have you used retinol or acid products before?",
    ),
    why: _t(
      "Təcrübən yoxdursa, aktivləri yavaş-yavaş, bir-bir əlavə edirik.",
      "Если опыта нет, добавляем активы постепенно, по одному.",
      "If you're new to them, we add actives slowly, one at a time.",
    ),
    options: [
      QuizOption('never', _t("Heç vaxt", "Никогда", "Never")),
      QuizOption('some', _t("Bir neçə dəfə", "Несколько раз", "A few times")),
      QuizOption('regular', _t("Müntəzəm", "Регулярно", "Regularly")),
    ],
  ),
  QuizQuestion(
    id: 'fragrance_pref',
    section: QuizSection.lifestyle,
    text: _t(
      "Ətirli məhsullara münasibətin necədir?",
      "Как ты относишься к средствам с отдушками?",
      "How do you feel about fragranced products?",
    ),
    why: _t(
      "Ətir dərini ən çox qıcıqlandıran tərkiblərdəndir.",
      "Отдушки — одна из самых частых причин раздражения.",
      "Fragrance is one of the most common causes of irritation.",
    ),
    options: [
      QuizOption(
        'avoid',
        _t("Ətirsiz istəyirəm", "Хочу без отдушек", "I prefer fragrance-free"),
      ),
      QuizOption('ok', _t("Fərqi yoxdur", "Всё равно", "No preference")),
    ],
  ),
  QuizQuestion(
    id: 'body_skin',
    section: QuizSection.body,
    text: _t(
      "Bədən dərin necədir?",
      "Какая у тебя кожа тела?",
      "How is the skin on your body?",
    ),
    why: _t(
      "Bədən rutinini buna görə qururuq.",
      "По этому строим твой уход за телом.",
      "We build your body routine from this.",
    ),
    options: [
      QuizOption('dry', _t("Quru", "Сухая", "Dry")),
      QuizOption('normal', _t("Normal", "Нормальная", "Normal")),
      QuizOption('oily', _t("Yağlı", "Жирная", "Oily")),
      QuizOption(
        'rough_bumps',
        _t(
          "Qollarda/budlarda kobud düyünlər",
          "Шершавые бугорки на руках/бёдрах",
          "Rough bumps on arms/thighs",
        ),
      ),
    ],
  ),
  QuizQuestion(
    id: 'body_concerns',
    section: QuizSection.body,
    multiple: true,
    text: _t(
      "Bədəndə səni nə narahat edir?",
      "Что тебя беспокоит в коже тела?",
      "What bothers you about your body skin?",
    ),
    why: _t(
      "Sənə lazım olan addımları (əl, ayaq, kürək) buna görə əlavə edirik.",
      "По этому добавляем нужные тебе шаги (руки, стопы, спина).",
      "We add the steps you need (hands, feet, back).",
    ),
    options: [
      QuizOption(
        'back_acne',
        _t(
          "Kürək/sinədə səpgi",
          "Высыпания на спине/груди",
          "Back/chest breakouts",
        ),
      ),
      QuizOption(
        'dry_hands',
        _t(
          "Quru, çatlayan əllər",
          "Сухие, трескающиеся руки",
          "Dry, cracked hands",
        ),
      ),
      QuizOption(
        'cracked_heels',
        _t("Daban çatları", "Трещины на пятках", "Cracked heels"),
      ),
      QuizOption('none', _t("Yoxdur", "Ничего", "Nothing"), exclusive: true),
    ],
  ),
  QuizQuestion(
    id: 'hair_type',
    section: QuizSection.hair,
    text: _t(
      "Saçının təbii forması?",
      "Естественная форма твоих волос?",
      "Your hair's natural texture?",
    ),
    why: _t(
      "Buruq saç daha tez quruyur və əlavə nəmləndirmə istəyir.",
      "Кудрявые волосы суше и нуждаются в дополнительном увлажнении.",
      "Curly hair tends to be drier and needs extra moisture.",
    ),
    options: [
      QuizOption('straight', _t("Düz", "Прямые", "Straight")),
      QuizOption('wavy', _t("Dalğalı", "Волнистые", "Wavy")),
      QuizOption('curly', _t("Buruq", "Кудрявые", "Curly")),
      QuizOption(
        'coily',
        _t("Çox buruq (qıvrım)", "Очень кудрявые (завитки-пружинки)", "Coily"),
      ),
    ],
  ),
  QuizQuestion(
    id: 'scalp',
    section: QuizSection.hair,
    text: _t(
      "Baş dərin necədir?",
      "Какая у тебя кожа головы?",
      "How is your scalp?",
    ),
    why: _t(
      "Şampunun növünü və yuyunma tezliyini buna görə seçirik.",
      "По этому выбираем тебе шампунь и частоту мытья.",
      "We choose your shampoo and wash frequency from this.",
    ),
    options: [
      QuizOption(
        'oily',
        _t("Tez yağlanır", "Быстро жирнеет", "Gets oily quickly"),
      ),
      QuizOption('dry', _t("Quru, dartılır", "Сухая, стянутая", "Dry, tight")),
      QuizOption('flaky', _t("Kəpək var", "Есть перхоть", "Flaky / dandruff")),
      QuizOption('normal', _t("Normal", "Нормальная", "Normal")),
    ],
  ),
  QuizQuestion(
    id: 'hair_concerns',
    section: QuizSection.hair,
    multiple: true,
    text: _t(
      "Saçında səni nə narahat edir?",
      "Что тебя беспокоит в волосах?",
      "What bothers you about your hair?",
    ),
    why: _t(
      "Saç rutinində hansı addımların olacağını bu müəyyənləşdirir.",
      "От этого зависят шаги твоего ухода за волосами.",
      "This decides which steps go into your hair routine.",
    ),
    options: [
      QuizOption('shedding', _t("Tökülmə", "Выпадение", "Shedding")),
      QuizOption(
        'breakage',
        _t(
          "Qırılma, parçalanmış uclar",
          "Ломкость, секущиеся кончики",
          "Breakage, split ends",
        ),
      ),
      QuizOption('frizz', _t("Qabarma", "Пушистость", "Frizz")),
      QuizOption('dullness', _t("Parlaqlıq yoxdur", "Тусклость", "Dullness")),
      QuizOption('none', _t("Yoxdur", "Ничего", "Nothing"), exclusive: true),
    ],
  ),
  QuizQuestion(
    id: 'heat_styling',
    section: QuizSection.hair,
    text: _t(
      "Fen, ütü və ya büzmə maşasını nə qədər tez-tez istifadə edirsən?",
      "Как часто ты пользуешься феном, утюжком или плойкой?",
      "How often do you use a blow-dryer, flat iron or curling iron?",
    ),
    why: _t(
      "İstidən qoruyucu addımı buna görə əlavə edirik.",
      "По этому добавляем шаг с термозащитой.",
      "We add a heat-protection step based on this.",
    ),
    options: [
      QuizOption(
        'often',
        _t(
          "Həftədə 3 dəfə və daha çox",
          "3 и более раз в неделю",
          "3+ times a week",
        ),
      ),
      QuizOption(
        'sometimes',
        _t("Həftədə 1–2 dəfə", "1–2 раза в неделю", "1–2 times a week"),
      ),
      QuizOption(
        'rarely',
        _t("Nadir və ya heç", "Редко или никогда", "Rarely or never"),
      ),
    ],
  ),
  QuizQuestion(
    id: 'wash_frequency',
    section: QuizSection.hair,
    text: _t(
      "Saçını nə qədər tez-tez yuyursan?",
      "Как часто ты моешь волосы?",
      "How often do you wash your hair?",
    ),
    why: _t(
      "Saç rutinin “yuyunma günləri”nə görə qurulur.",
      "Твой уход за волосами строится по дням мытья.",
      "Your hair routine is planned around wash days.",
    ),
    options: [
      QuizOption('daily', _t("Hər gün", "Каждый день", "Every day")),
      QuizOption(
        'every_2_3',
        _t("2–3 gündən bir", "Раз в 2–3 дня", "Every 2–3 days"),
      ),
      QuizOption('weekly', _t("Həftədə bir", "Раз в неделю", "Once a week")),
    ],
  ),
  QuizQuestion(
    id: 'hair_treated',
    section: QuizSection.hair,
    multiple: true,
    text: _t(
      "Saçın boyanıb və ya kimyəvi işlənib?",
      "Твои волосы окрашены или химически обработаны?",
      "Is your hair coloured or chemically treated?",
    ),
    why: _t(
      "Boyanmış saça həftəlik maska və yaxalanmayan kondisioner əlavə edirik.",
      "Для окрашенных волос добавляем маску и несмываемый кондиционер.",
      "For coloured hair we add a weekly mask and a leave-in conditioner.",
    ),
    options: [
      QuizOption('colored', _t("Boyanıb", "Окрашены", "Coloured")),
      QuizOption(
        'chemical',
        _t(
          "Kimyəvi düzləşdirmə və ya buruq",
          "Химическое выпрямление или завивка",
          "Chemically straightened or permed",
        ),
      ),
      QuizOption('none', _t("Xeyr", "Нет", "No"), exclusive: true),
    ],
  ),
  QuizQuestion(
    id: 'warning_signs',
    section: QuizSection.safety,
    stored: false,
    multiple: true,
    redFlagOptionIds: {
      'changing_mole',
      'non_healing',
      'hair_loss',
      'painful_rash',
    },
    text: _t(
      'Son vaxtlar bunlardan hər hansı birini görmüsən?',
      'Замечала ли ты недавно что-то из этого?',
      'Have you recently noticed any of these?',
    ),
    options: [
      QuizOption(
        'changing_mole',
        _t(
          'Forması və ya rəngi dəyişən xal',
          'Родинка, которая меняет форму или цвет',
          'A mole that changes shape or colour',
        ),
      ),
      QuizOption(
        'non_healing',
        _t(
          '4 həftədən çox sağalmayan yara',
          'Ранка, которая не заживает больше 4 недель',
          "A sore that hasn't healed in over 4 weeks",
        ),
      ),
      QuizOption(
        'hair_loss',
        _t(
          'Qəfil, güclü saç tökülməsi',
          'Внезапное сильное выпадение волос',
          'Sudden, heavy hair loss',
        ),
      ),
      QuizOption(
        'painful_rash',
        _t(
          'Ağrılı və ya sürətlə yayılan səpgi',
          'Болезненная или быстро распространяющаяся сыпь',
          'A painful or fast-spreading rash',
        ),
      ),
      QuizOption(
        'none',
        _t('Heç biri', 'Ничего из этого', 'None of these'),
        exclusive: true,
      ),
    ],
  ),
];

/// The question with [id], or `null`.
QuizQuestion? quizQuestion(String id) {
  for (final q in quizQuestions) {
    if (q.id == id) return q;
  }
  return null;
}

/// Answers keyed by question id. A declined question is absent from
/// [chosen] and present in [declined].
class QuizAnswers {
  const QuizAnswers({
    this.chosen = const {},
    this.declined = const {},
    this.months = const {},
  });

  final Map<String, List<String>> chosen;
  final Set<String> declined;

  /// The month ("2026-11") each health answer was last given or confirmed,
  /// as the server stored it; missing for older answers.
  final Map<String, String> months;

  List<String> of(String questionId) => chosen[questionId] ?? const [];

  bool has(String questionId, String optionId) =>
      of(questionId).contains(optionId);

  bool answered(String questionId) => chosen.containsKey(questionId);
}

/// Whether any answer is a warning sign that needs a doctor (M-12).
bool hasRedFlag(QuizAnswers answers) => quizQuestions.any(
  (q) => q.redFlagOptionIds.any((id) => answers.has(q.id, id)),
);
