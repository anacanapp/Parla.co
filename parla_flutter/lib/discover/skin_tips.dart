/// SAMPLE CONTENT, NOT EXPERT-APPROVED.
///
/// Daily skin tips for the nutrition tool, one per day in turn, `[az, ru,
/// en]`. General information only; no promises about results.
const skinTips = <List<String>>[
  [
    'C vitamini ilə zəngin qidalar (bibər, kivi, sitrus) dərinin kollagen istehsalında rol oynayır.',
    'Продукты, богатые витамином C (перец, киви, цитрусовые), участвуют в выработке коллагена в коже.',
    'Foods rich in vitamin C (peppers, kiwi, citrus) play a part in the skin making collagen.',
  ],
  [
    'Omeqa-3 yağ turşuları (balıq, qoz, kətan toxumu) dərinin qoruyucu təbəqəsi üçün vacibdir.',
    'Омега-3 жирные кислоты (рыба, грецкие орехи, льняное семя) важны для защитного барьера кожи.',
    'Omega-3 fatty acids (fish, walnuts, flaxseed) matter for the skin barrier.',
  ],
  [
    'Rəngli tərəvəzlər müxtəlif antioksidantlar verir. Boşqabda nə qədər çox rəng, o qədər yaxşı.',
    'Яркие овощи дают разные антиоксиданты. Чем больше цветов на тарелке, тем лучше.',
    'Colourful vegetables bring different antioxidants. The more colours on your plate, the better.',
  ],
  [
    'Gün ərzində suyu az-az, amma tez-tez içmək dəri üçün tək bir böyük stəkandan daha faydalıdır.',
    'Пить воду понемногу, но часто полезнее для кожи, чем один большой стакан.',
    'Sipping water little and often through the day helps more than one big glass.',
  ],
  [
    'Sink (qabaqgiller, toxumlar, yumurta) dərinin bərpasında iştirak edir.',
    'Цинк (бобовые, семечки, яйца) участвует в восстановлении кожи.',
    'Zinc (legumes, seeds, eggs) is involved in skin repair.',
  ],
];

/// The tip for [day] in [language].
String skinTipFor(DateTime day, String language) {
  final index = DateTime.utc(
    day.year,
    day.month,
    day.day,
  ).difference(DateTime.utc(2026)).inDays;
  final tip = skinTips[index % skinTips.length];
  return switch (language) {
    'ru' => tip[1],
    'en' => tip[2],
    _ => tip[0],
  };
}
