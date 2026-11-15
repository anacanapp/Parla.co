import 'dart:ui';

import '../ui/brand.dart';

/// Morning or evening care routine.
enum RoutineKind { morning, evening }

/// One step of a routine, already in the user's language.
class RoutineStep {
  const RoutineStep({
    required this.id,
    required this.title,
    required this.meta,
    required this.tip,
    required this.minutes,
    required this.tile,
    this.approvedByDermatologist = false,
  });

  final String id;
  final String title;

  /// How much and how: "Noxud boyda · yüngül masajla".
  final String meta;

  /// Why the step matters, one or two sentences.
  final String tip;
  final int minutes;
  final Color tile;

  /// Only content approved in the expert CMS (M8) may show the
  /// "approved by a dermatologist" badge.
  final bool approvedByDermatologist;
}

/// SAMPLE CONTENT, NOT EXPERT-APPROVED.
///
/// Step texts for the step ids that the routine rules
/// (`planRoutine` in parla_shared) produce. None of it is marked approved,
/// so the dermatologist badge never shows for it.
List<RoutineStep> routineSteps(List<String> ids, String language) {
  final text = _sampleText[language] ?? _sampleText['az']!;
  return [
    for (final id in ids)
      if (text.containsKey(id))
        RoutineStep(
          id: id,
          title: text[id]![0],
          meta: text[id]![1],
          tip: text[id]![2],
          minutes: _minutes[id] ?? 1,
          tile: _tiles[id] ?? ParlaColors.lemon,
        ),
  ];
}

/// Every step id that has text, per language (for tests).
Iterable<String> knownStepIds(String language) =>
    (_sampleText[language] ?? const {}).keys;

const _minutes = {
  'makeup-off': 2,
  'hair-wash': 5,
  'hair-conditioner': 3,
  'hair-mask': 15,
  'hair-scalp-care': 2,
  'body-shower': 8,
  'body-scrub': 3,
  'body-hands-feet': 3,
};

const _tiles = {
  'cleanser': ParlaColors.sage,
  'cleanser-pm': ParlaColors.sage,
  'soothing-serum': ParlaColors.sage,
  'vitamin-c': ParlaColors.sky,
  'makeup-off': ParlaColors.sky,
  'retinoid-pm': ParlaColors.sky,
  'sunscreen': ParlaColors.sun,
  'lip-balm': ParlaColors.sun,
  'hair-detangle': ParlaColors.lilac,
  'hair-leave-in': ParlaColors.lilac,
  'hair-night-protect': ParlaColors.lilac,
  'hair-wash': ParlaColors.lilac,
  'hair-conditioner': ParlaColors.lilac,
  'hair-mask': ParlaColors.blush,
  'hair-scalp-care': ParlaColors.blush,
  'body-shower': ParlaColors.sky,
  'body-sunscreen': ParlaColors.sun,
  'body-lotion': ParlaColors.sageTint,
  'body-scrub': ParlaColors.sageTint,
  'body-hands-feet': ParlaColors.blush,
};

/// id → [title, meta, tip] per language.
const Map<String, Map<String, List<String>>> _sampleText = {
  'az': {
    'hair-detangle': [
      "Saçı daramaq",
      "Uclardan köklərə · geniş dişli daraq",
      "Uclardan başlamaq qırılmanı azaldır.",
    ],
    'hair-leave-in': [
      "Yuyulmayan kondisioner",
      "Bir az · yalnız uclara",
      "Saçı yumşaq saxlayır, daramağı asanlaşdırır.",
    ],
    'hair-night-protect': [
      "Gecə saçı qorumaq",
      "Yumşaq rezin və ya ipək yastıq üzü",
      "Sürtünmə azalır, saç səhər daha az dolaşır.",
    ],
    'hair-wash': [
      "Saçı yumaq",
      "Şampun baş dərisinə · ılıq su",
      "Şampunu əsasən köklərə çək, uclar köpüklə təmizlənir.",
    ],
    'hair-conditioner': [
      "Kondisioner",
      "Uclara · 2–3 dəqiqə",
      "Köklərə çəkmə ki, saç tez yağlanmasın.",
    ],
    'hair-mask': [
      "Saç maskası",
      "Uclara · 10–15 dəqiqə",
      "Həftədə bir dəfə əlavə qulluq.",
    ],
    'hair-scalp-care': [
      "Baş dərisinə qulluq",
      "Yumşaq masaj · 2 dəqiqə",
      "Dırnaqla yox, barmaq ucları ilə yüngül masaj et.",
    ],
    'body-shower': [
      "Ilıq duş",
      "5–10 dəqiqə · ılıq su",
      "Çox isti su dərini qurudur.",
    ],
    'body-sunscreen': [
      "Bədənə günəşdən qoruyucu",
      "Açıq qalan yerlərə · SPF 30+",
      "Qollar, boyun və dekolte tez-tez unudulur.",
    ],
    'body-lotion': [
      "Bədən losyonu",
      "Duşdan sonra · dəri bir az nəmkən",
      "Nəm dəriyə çəkilən losyon daha yaxşı hopur.",
    ],
    'body-scrub': [
      "Yumşaq skrab",
      "Həftədə 1 dəfə · yüngül hərəkətlə",
      "Güclü sürtmək lazım deyil.",
    ],
    'body-hands-feet': [
      "Əl və ayaq qulluğu",
      "Krem · dırnaq ətrafına da",
      "Ayaqlara gecə krem çəkib pambıq corab geyinmək olar.",
    ],
    'moisturiser-light': [
      "Yüngül gel krem",
      "Noxud boyda · nazik qat",
      "Yağlı dəri üçün: nəmləndirir, parıltı artırmır.",
    ],
    'moisturiser-rich': [
      "Qidalandırıcı krem",
      "Noxud boyda · yüngül masajla",
      "Quru dəri üçün: dartılma hissini azaldır.",
    ],
    'soothing-serum': [
      "Sakitləşdirici serum",
      "2–3 damcı · üz",
      "Həssas dəri üçün: aktiv turşular olmadan.",
    ],
    'retinoid-pm': [
      "Retinol (axşam)",
      "Noxud boyda · həftədə 2 dəfə",
      "Yavaş başla ki, dəri uyğunlaşsın. Səhər günəşdən qoruyucu vacibdir.",
    ],
    'cleanser': [
      'Yumşaq təmizləyici',
      '60 saniyə · ılıq su',
      'Ilıq su dərini qurutmadan təmizləyir.',
    ],
    'vitamin-c': [
      'C vitamini serumu',
      '3 damcı · üz və boyun',
      'Quru dəriyə çək və növbəti addımdan əvvəl 1 dəqiqə gözlə.',
    ],
    'moisturiser': [
      'Nəmləndirici krem',
      'Noxud boyda · yüngül masajla',
      'Dərini gün boyu yumşaq saxlayır.',
    ],
    'sunscreen': [
      'Günəşdən qoruyucu',
      'SPF 30+ · iki barmaq uzunluğu',
      'Buludlu gündə də lazımdır: UV şüaları buluddan keçir.',
    ],
    'makeup-off': [
      'Makiyajı təmizlə',
      'Mitselyar su · pambıq disk',
      'Gözləri sürtmə: diski 10 saniyə saxla, sonra yumşaq sil.',
    ],
    'cleanser-pm': [
      'Yumşaq təmizləyici',
      '60 saniyə · ılıq su',
      'Axşam ikinci təmizləmə günün qalığını götürür.',
    ],
    'night-cream': [
      'Gecə kremi',
      'Noxud boyda',
      'Gecə ərzində dərini nəmli saxlayır.',
    ],
    'lip-balm': [
      'Dodaq balzamı',
      'Nazik qat',
      'Səhərə qədər dodaqları quruluqdan qoruyur.',
    ],
  },
  'ru': {
    'hair-detangle': [
      "Расчесать волосы",
      "От кончиков к корням · широкая расчёска",
      "Если начинать с кончиков, волосы меньше ломаются.",
    ],
    'hair-leave-in': [
      "Несмываемый кондиционер",
      "Немного · только на кончики",
      "Волосы остаются мягкими и легче расчёсываются.",
    ],
    'hair-night-protect': [
      "Защита волос на ночь",
      "Мягкая резинка или шёлковая наволочка",
      "Меньше трения, утром волосы меньше путаются.",
    ],
    'hair-wash': [
      "Мытьё волос",
      "Шампунь на кожу головы · тёплая вода",
      "Наносите шампунь в основном на корни, длину очистит пена.",
    ],
    'hair-conditioner': [
      "Кондиционер",
      "На кончики · 2–3 минуты",
      "Не наносите на корни, чтобы волосы не жирнели быстрее.",
    ],
    'hair-mask': [
      "Маска для волос",
      "На кончики · 10–15 минут",
      "Дополнительный уход раз в неделю.",
    ],
    'hair-scalp-care': [
      "Уход за кожей головы",
      "Мягкий массаж · 2 минуты",
      "Массируйте подушечками пальцев, не ногтями.",
    ],
    'body-shower': [
      "Тёплый душ",
      "5–10 минут · тёплая вода",
      "Слишком горячая вода сушит кожу.",
    ],
    'body-sunscreen': [
      "Солнцезащита для тела",
      "На открытые места · SPF 30+",
      "Руки, шею и зону декольте часто забывают.",
    ],
    'body-lotion': [
      "Лосьон для тела",
      "После душа · на слегка влажную кожу",
      "На влажной коже лосьон впитывается лучше.",
    ],
    'body-scrub': [
      "Мягкий скраб",
      "Раз в неделю · лёгкими движениями",
      "Сильно тереть не нужно.",
    ],
    'body-hands-feet': [
      "Уход за руками и ногами",
      "Крем · и вокруг ногтей",
      "На ночь можно нанести крем на стопы и надеть хлопковые носки.",
    ],
    'moisturiser-light': [
      "Лёгкий гель-крем",
      "С горошину · тонкий слой",
      "Для жирной кожи: увлажняет, не добавляя блеска.",
    ],
    'moisturiser-rich': [
      "Питательный крем",
      "С горошину · лёгкий массаж",
      "Для сухой кожи: снимает ощущение стянутости.",
    ],
    'soothing-serum': [
      "Успокаивающая сыворотка",
      "2–3 капли · лицо",
      "Для чувствительной кожи: без активных кислот.",
    ],
    'retinoid-pm': [
      "Ретинол (вечер)",
      "С горошину · 2 раза в неделю",
      "Начинай постепенно, чтобы кожа привыкла. Утром обязательно SPF.",
    ],
    'cleanser': [
      'Мягкое очищение',
      '60 секунд · тёплая вода',
      'Тёплая вода очищает, не пересушивая кожу.',
    ],
    'vitamin-c': [
      'Сыворотка с витамином C',
      '3 капли · лицо и шея',
      'Нанеси на сухую кожу и подожди минуту перед следующим шагом.',
    ],
    'moisturiser': [
      'Увлажняющий крем',
      'С горошину · лёгкий массаж',
      'Сохраняет кожу мягкой весь день.',
    ],
    'sunscreen': [
      'Солнцезащитный крем',
      'SPF 30+ · длина двух пальцев',
      'Нужен и в пасмурный день: UV-лучи проходят сквозь облака.',
    ],
    'makeup-off': [
      'Снять макияж',
      'Мицеллярная вода · ватный диск',
      'Не три глаза: подержи диск 10 секунд, затем мягко сотри.',
    ],
    'cleanser-pm': [
      'Мягкое очищение',
      '60 секунд · тёплая вода',
      'Второе очищение вечером убирает остатки дня.',
    ],
    'night-cream': [
      'Ночной крем',
      'С горошину',
      'Сохраняет кожу увлажнённой ночью.',
    ],
    'lip-balm': [
      'Бальзам для губ',
      'Тонкий слой',
      'Защищает губы от сухости до утра.',
    ],
  },
  'en': {
    'hair-detangle': [
      "Detangle",
      "Ends to roots · wide-tooth comb",
      "Starting at the ends means less breakage.",
    ],
    'hair-leave-in': [
      "Leave-in conditioner",
      "A little · ends only",
      "Keeps hair soft and easier to comb.",
    ],
    'hair-night-protect': [
      "Protect hair overnight",
      "Soft scrunchie or silk pillowcase",
      "Less friction, fewer tangles in the morning.",
    ],
    'hair-wash': [
      "Wash day",
      "Shampoo on the scalp · lukewarm water",
      "Shampoo mainly the roots; the lather cleans the lengths.",
    ],
    'hair-conditioner': [
      "Conditioner",
      "On the ends · 2–3 minutes",
      "Keep it off the roots so hair stays fresh longer.",
    ],
    'hair-mask': [
      "Hair mask",
      "On the ends · 10–15 minutes",
      "Extra care once a week.",
    ],
    'hair-scalp-care': [
      "Scalp care",
      "Gentle massage · 2 minutes",
      "Use your fingertips, not your nails.",
    ],
    'body-shower': [
      "Lukewarm shower",
      "5–10 minutes · lukewarm water",
      "Very hot water dries the skin.",
    ],
    'body-sunscreen': [
      "Body sunscreen",
      "On uncovered skin · SPF 30+",
      "Arms, neck and chest are easy to forget.",
    ],
    'body-lotion': [
      "Body lotion",
      "After the shower · on slightly damp skin",
      "Lotion on damp skin absorbs better.",
    ],
    'body-scrub': [
      "Gentle scrub",
      "Once a week · light movements",
      "No need to rub hard.",
    ],
    'body-hands-feet': [
      "Hands and feet",
      "Cream · around the nails too",
      "At night you can put cream on your feet and wear cotton socks.",
    ],
    'moisturiser-light': [
      "Light gel moisturiser",
      "Pea-sized · thin layer",
      "For oily skin: hydrates without adding shine.",
    ],
    'moisturiser-rich': [
      "Rich cream",
      "Pea-sized · light massage",
      "For dry skin: eases the tight feeling.",
    ],
    'soothing-serum': [
      "Soothing serum",
      "2–3 drops · face",
      "For sensitive skin: no active acids.",
    ],
    'retinoid-pm': [
      "Retinol (evening)",
      "Pea-sized · twice a week",
      "Start slowly so your skin adapts. Sunscreen in the morning is a must.",
    ],
    'cleanser': [
      'Gentle cleanser',
      '60 seconds · lukewarm water',
      'Lukewarm water cleans without drying your skin.',
    ],
    'vitamin-c': [
      'Vitamin C serum',
      '3 drops · face and neck',
      'Apply to dry skin and wait a minute before the next step.',
    ],
    'moisturiser': [
      'Moisturiser',
      'Pea-sized · light massage',
      'Keeps your skin soft through the day.',
    ],
    'sunscreen': [
      'Sunscreen',
      'SPF 30+ · two finger lengths',
      'Needed on cloudy days too: UV passes through clouds.',
    ],
    'makeup-off': [
      'Remove make-up',
      'Micellar water · cotton pad',
      'Don\'t rub your eyes: hold the pad for 10 seconds, then wipe gently.',
    ],
    'cleanser-pm': [
      'Gentle cleanser',
      '60 seconds · lukewarm water',
      'A second evening cleanse removes the rest of the day.',
    ],
    'night-cream': [
      'Night cream',
      'Pea-sized',
      'Keeps your skin hydrated overnight.',
    ],
    'lip-balm': [
      'Lip balm',
      'Thin layer',
      'Protects your lips from dryness until morning.',
    ],
  },
};
