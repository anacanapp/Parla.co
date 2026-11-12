/// The onboarding quiz (screens M-09 to M-13).
///
/// SAMPLE CONTENT, NOT EXPERT-APPROVED. Every question has
/// `approved: false` until a dermatologist reviews it (open item in the
/// data map). Questions only ask about diagnoses a doctor has already made,
/// never infer a condition (MDR rule, see the regulation analysis).
library;

/// Groups of questions, in the order the quiz asks them.
enum QuizSection { skin, hair, lifestyle, health, safety }

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
const quizContentVersion = 'quiz-2026-11-sample1';

Map<String, String> _t(String az, String ru, String en) => {
  'az': az,
  'ru': ru,
  'en': en,
};

final List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 'skin_type',
    section: QuizSection.skin,
    text: _t(
      'Gün ərzində dəriniz özünü necə hiss edir?',
      'Как ведёт себя ваша кожа в течение дня?',
      'How does your skin feel during the day?',
    ),
    options: [
      QuizOption(
        'oily',
        _t(
          'Parlayır, xüsusən T-zonada',
          'Блестит, особенно в Т-зоне',
          'Shiny, especially in the T-zone',
        ),
      ),
      QuizOption(
        'dry',
        _t(
          'Dartılır, bəzən qabıqlanır',
          'Стянута, иногда шелушится',
          'Tight, sometimes flaky',
        ),
      ),
      QuizOption(
        'combination',
        _t(
          'T-zona parlaq, yanaqlar quru',
          'Т-зона блестит, щёки сухие',
          'Shiny T-zone, dry cheeks',
        ),
      ),
      QuizOption(
        'normal',
        _t(
          'Rahat: nə yağlı, nə quru',
          'Комфортно: ни жирная, ни сухая',
          'Comfortable: neither oily nor dry',
        ),
      ),
      QuizOption('unsure', _t('Bilmirəm', 'Не знаю', "I'm not sure")),
    ],
  ),
  QuizQuestion(
    id: 'skin_sensitivity',
    section: QuizSection.skin,
    text: _t(
      'Yeni məhsula dəriniz necə reaksiya verir?',
      'Как кожа реагирует на новые средства?',
      'How does your skin react to new products?',
    ),
    options: [
      QuizOption(
        'often',
        _t(
          'Tez-tez qızarır və ya göynəyir',
          'Часто краснеет или щиплет',
          'Often turns red or stings',
        ),
      ),
      QuizOption('sometimes', _t('Bəzən', 'Иногда', 'Sometimes')),
      QuizOption(
        'rarely',
        _t('Demək olar ki, heç vaxt', 'Почти никогда', 'Almost never'),
      ),
    ],
  ),
  QuizQuestion(
    id: 'skin_goals',
    section: QuizSection.skin,
    multiple: true,
    text: _t(
      'Dəriniz üçün nə istəyirsiniz?',
      'Чего вы хотите для своей кожи?',
      'What would you like for your skin?',
    ),
    options: [
      QuizOption(
        'hydration',
        _t('Daha nəmli dəri', 'Больше увлажнения', 'More hydration'),
      ),
      QuizOption(
        'oil_balance',
        _t('Daha az parıltı', 'Меньше жирного блеска', 'Less shine'),
      ),
      QuizOption(
        'even_tone',
        _t('Daha bərabər ton', 'Более ровный тон', 'A more even tone'),
      ),
      QuizOption(
        'fewer_breakouts',
        _t('Daha az səpgi', 'Меньше высыпаний', 'Fewer breakouts'),
      ),
      QuizOption(
        'calm',
        _t(
          'Daha sakit, az qızaran dəri',
          'Спокойная кожа, меньше покраснений',
          'Calmer, less red skin',
        ),
      ),
      QuizOption(
        'glow',
        _t('Təbii parıltı', 'Естественное сияние', 'A natural glow'),
      ),
    ],
  ),
  QuizQuestion(
    id: 'hair_type',
    section: QuizSection.hair,
    text: _t(
      'Saçınız hansı tipdədir?',
      'Какой у вас тип волос?',
      'What is your hair type?',
    ),
    options: [
      QuizOption('straight', _t('Düz', 'Прямые', 'Straight')),
      QuizOption('wavy', _t('Dalğalı', 'Волнистые', 'Wavy')),
      QuizOption('curly', _t('Buruq', 'Кудрявые', 'Curly')),
      QuizOption('coily', _t('Çox buruq', 'Мелкие кудри', 'Coily')),
    ],
  ),
  QuizQuestion(
    id: 'hair_concerns',
    section: QuizSection.hair,
    multiple: true,
    text: _t(
      'Saçınızla bağlı nə sizi narahat edir?',
      'Что беспокоит вас в волосах?',
      'What bothers you about your hair?',
    ),
    options: [
      QuizOption('dryness', _t('Quruluq', 'Сухость', 'Dryness')),
      QuizOption(
        'oiliness',
        _t('Tez yağlanma', 'Быстро жирнеют', 'Gets oily fast'),
      ),
      QuizOption('frizz', _t('Pırpızlıq', 'Пушатся', 'Frizz')),
      QuizOption('breakage', _t('Qırılma', 'Ломкость', 'Breakage')),
      QuizOption('none', _t('Heç biri', 'Ничего', 'Nothing'), exclusive: true),
    ],
  ),
  QuizQuestion(
    id: 'routine_time',
    section: QuizSection.lifestyle,
    text: _t(
      'Səhər qulluğa nə qədər vaxt ayıra bilərsiniz?',
      'Сколько времени утром вы готовы уделять уходу?',
      'How much time can you spend on your morning routine?',
    ),
    options: [
      QuizOption(
        'minimal',
        _t('5 dəqiqəyə qədər', 'До 5 минут', 'Up to 5 minutes'),
      ),
      QuizOption('standard', _t('5–10 dəqiqə', '5–10 минут', '5–10 minutes')),
      QuizOption(
        'full',
        _t('10 dəqiqədən çox', 'Больше 10 минут', 'More than 10 minutes'),
      ),
    ],
  ),
  QuizQuestion(
    id: 'sun_exposure',
    section: QuizSection.lifestyle,
    text: _t(
      'Gün ərzində günəşdə nə qədər olursunuz?',
      'Сколько времени вы проводите на солнце?',
      'How much time do you spend in the sun?',
    ),
    options: [
      QuizOption(
        'indoors',
        _t('Əsasən qapalı yerdə', 'В основном в помещении', 'Mostly indoors'),
      ),
      QuizOption('mixed', _t('Qarışıq', 'По-разному', 'A mix')),
      QuizOption(
        'outdoors',
        _t('Əsasən açıq havada', 'В основном на улице', 'Mostly outdoors'),
      ),
    ],
  ),
  QuizQuestion(
    id: 'conditions',
    section: QuizSection.health,
    sensitive: true,
    multiple: true,
    text: _t(
      'Həkim sizə bunlardan hansının diaqnozunu qoyub?',
      'Какой из этих диагнозов вам ставил врач?',
      'Has a doctor diagnosed you with any of these?',
    ),
    options: [
      QuizOption('acne', _t('Akne', 'Акне', 'Acne')),
      QuizOption('eczema', _t('Ekzema', 'Экзема', 'Eczema')),
      QuizOption('rosacea', _t('Rozasea', 'Розацеа', 'Rosacea')),
      QuizOption('psoriasis', _t('Psoriaz', 'Псориаз', 'Psoriasis')),
      QuizOption(
        'none',
        _t('Heç biri', 'Ни одного', 'None of these'),
        exclusive: true,
      ),
    ],
  ),
  QuizQuestion(
    id: 'allergies',
    section: QuizSection.health,
    sensitive: true,
    multiple: true,
    text: _t(
      'Bunlardan hansına allergiyanız var?',
      'На что из этого у вас аллергия?',
      'Are you allergic to any of these?',
    ),
    options: [
      QuizOption('fragrance', _t('Ətir', 'Отдушки', 'Fragrance')),
      QuizOption('nickel', _t('Nikel', 'Никель', 'Nickel')),
      QuizOption(
        'preservatives',
        _t('Konservantlar', 'Консерванты', 'Preservatives'),
      ),
      QuizOption('lanolin', _t('Lanolin', 'Ланолин', 'Lanolin')),
      QuizOption(
        'none',
        _t('Heç biri', 'Ни на что', 'None of these'),
        exclusive: true,
      ),
      QuizOption(
        'unsure',
        _t('Bilmirəm', 'Не знаю', "I'm not sure"),
        exclusive: true,
      ),
    ],
  ),
  QuizQuestion(
    id: 'pregnancy',
    section: QuizSection.health,
    sensitive: true,
    text: _t(
      'Hazırda hamiləsiniz və ya əmizdirirsiniz?',
      'Вы сейчас беременны или кормите грудью?',
      'Are you currently pregnant or breastfeeding?',
    ),
    options: [
      QuizOption('pregnant', _t('Hamiləyəm', 'Беременна', 'Pregnant')),
      QuizOption(
        'breastfeeding',
        _t('Əmizdirirəm', 'Кормлю грудью', 'Breastfeeding'),
      ),
      QuizOption('no', _t('Xeyr', 'Нет', 'No')),
    ],
  ),
  QuizQuestion(
    id: 'medication',
    section: QuizSection.health,
    sensitive: true,
    multiple: true,
    text: _t(
      'Bunlardan hansını qəbul edirsiniz?',
      'Что из этого вы принимаете?',
      'Do you take any of these?',
    ),
    options: [
      QuizOption(
        'oral_retinoid',
        _t(
          'Ağızdan retinoid (məs. izotretinoin)',
          'Ретиноиды внутрь (напр. изотретиноин)',
          'Oral retinoids (e.g. isotretinoin)',
        ),
      ),
      QuizOption(
        'prescription_cream',
        _t(
          'Həkimin yazdığı dəri kremi',
          'Крем для кожи по рецепту',
          'A prescription skin cream',
        ),
      ),
      QuizOption(
        'hormonal',
        _t('Hormonal dərman', 'Гормональные препараты', 'Hormonal medicine'),
      ),
      QuizOption(
        'none',
        _t('Heç biri', 'Ничего', 'None of these'),
        exclusive: true,
      ),
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
      'Son vaxtlar bunlardan hər hansı birini görmüsünüz?',
      'Замечали ли вы недавно что-то из этого?',
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
  const QuizAnswers({this.chosen = const {}, this.declined = const {}});

  final Map<String, List<String>> chosen;
  final Set<String> declined;

  List<String> of(String questionId) => chosen[questionId] ?? const [];

  bool has(String questionId, String optionId) =>
      of(questionId).contains(optionId);

  bool answered(String questionId) => chosen.containsKey(questionId);
}

/// Whether any answer is a warning sign that needs a doctor (M-12).
bool hasRedFlag(QuizAnswers answers) => quizQuestions.any(
  (q) => q.redFlagOptionIds.any((id) => answers.has(q.id, id)),
);
