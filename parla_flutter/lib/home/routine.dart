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
/// Placeholder routine until the onboarding test and the expert CMS (M3,
/// M4, M8) produce real routines. None of it is marked approved, so the
/// dermatologist badge never shows for it.
List<RoutineStep> sampleRoutine(RoutineKind kind, String language) {
  final text = _sampleText[language] ?? _sampleText['az']!;
  final rows = kind == RoutineKind.morning ? _morning : _evening;
  return [
    for (final row in rows)
      RoutineStep(
        id: row.id,
        title: text[row.id]![0],
        meta: text[row.id]![1],
        tip: text[row.id]![2],
        minutes: row.minutes,
        tile: row.tile,
      ),
  ];
}

class _Row {
  const _Row(this.id, this.minutes, this.tile);
  final String id;
  final int minutes;
  final Color tile;
}

const _morning = [
  _Row('cleanser', 1, ParlaColors.sage),
  _Row('vitamin-c', 1, ParlaColors.sky),
  _Row('moisturiser', 1, ParlaColors.lemon),
  _Row('sunscreen', 1, ParlaColors.sun),
];

const _evening = [
  _Row('makeup-off', 2, ParlaColors.sky),
  _Row('cleanser-pm', 1, ParlaColors.sage),
  _Row('night-cream', 1, ParlaColors.lemon),
  _Row('lip-balm', 1, ParlaColors.sun),
];

/// id → [title, meta, tip] per language.
const Map<String, Map<String, List<String>>> _sampleText = {
  'az': {
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
