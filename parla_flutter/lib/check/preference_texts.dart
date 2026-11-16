/// DRAFT CONTENT from the content sheet ("yoxla_secimleri"), NOT REVIEWED
/// by a cosmetic chemist yet. Name and explanation of every product
/// preference, `[[az, ru, en], [az, ru, en]]`.
library;

const preferenceTexts = <String, List<List<String>>>{
  'fragrance_free': [
    ["Ətirsiz", "Без отдушек", "Fragrance-free"],
    [
      "Tərkibdə əlavə edilmiş ətir olmasın. “Qoxusuz” (unscented) yazısı ətirsiz demək deyil: qoxunu gizlədən maddə ola bilər.",
      "В составе нет добавленных отдушек. «Без запаха» (unscented) не значит «без отдушек»: может быть маскирующий аромат.",
      "No added fragrance. 'Unscented' isn't the same: it may contain a masking scent.",
    ],
  ],
  'essential_oil_free': [
    ["Efir yağısız", "Без эфирных масел", "Essential-oil-free"],
    [
      "Tərkibdə aromatik bitki yağları olmasın. Həssas dəri üçün seçilə bilər.",
      "В составе нет ароматических растительных масел.",
      "No aromatic plant oils in the formula.",
    ],
  ],
  'alcohol_free': [
    ["Spirtsiz", "Без спирта", "Alcohol-free"],
    [
      "Tərkibdə dərini quruda bilən sadə spirtlər (etanol) olmasın. Setil, stearil kimi “yağlı spirtlər” fərqlidir və bu seçimə düşmür.",
      "Без простых спиртов (этанола), которые могут сушить кожу. Жирные спирты (цетиловый, стеариловый) — другое, они сюда не относятся.",
      "No simple alcohols (ethanol) that can dry skin. Fatty alcohols like cetyl or stearyl are different and aren't included.",
    ],
  ],
  'vegan': [
    ["Vegan", "Веган", "Vegan"],
    [
      "Heyvan mənşəli tərkib olmasın. INCI siyahısı bəzi maddələrin mənşəyini göstərmir, ona görə bu yoxlama təxminidir.",
      "Без компонентов животного происхождения. По INCI не всегда можно понять происхождение, проверка приблизительная.",
      "No animal-derived ingredients. INCI names don't always reveal origin, so this check is approximate.",
    ],
  ],
  'silicone_free': [
    ["Silikonsuz", "Без силиконов", "Silicone-free"],
    [
      "Silikon əsaslı tərkiblər olmasın. Bu, şəxsi seçimdir; silikonlar saç və dəri məhsullarında geniş istifadə olunur.",
      "Без силиконов. Это личный выбор: силиконы широко используются в средствах для кожи и волос.",
      "No silicones. This is a personal preference; silicones are widely used in skin and hair care.",
    ],
  ],
  'sulfate_free': [
    ["Sulfatsız", "Без сульфатов", "Sulfate-free"],
    [
      "Güclü köpüklənən sulfatlı təmizləyicilər olmasın. Quru dəri və boyanmış saç üçün tez-tez seçilir.",
      "Без сильно пенящихся сульфатных ПАВ. Часто выбирают при сухой коже и окрашенных волосах.",
      "No strong-lathering sulfate cleansers. Often chosen for dry skin and coloured hair.",
    ],
  ],
  'retinoid_free': [
    ["Retinoidsiz", "Без ретиноидов", "Retinoid-free"],
    [
      "A vitamini törəmələri olmasın. Hamiləlik, əmizdirmə və hamiləlik planlaşdırılan dövrdə bu seçim avtomatik aktivləşir.",
      "Без производных витамина A. Автоматически включается при беременности, грудном вскармливании и планировании.",
      "No vitamin A derivatives. Turns on automatically when pregnant, breastfeeding or trying to conceive.",
    ],
  ],
  'preservative_alert': [
    [
      "Allergiya ilə əlaqələndirilən konservantlar",
      "Консерванты, связанные с аллергией",
      "Allergy-linked preservatives",
    ],
    [
      "Kontakt allergiya ilə daha tez-tez əlaqələndirilən konservantları işarələyir. Konservantlar məhsulun təhlükəsiz qalması üçün lazımdır; allergiyan varsa, bu seçim sənin üçündür.",
      "Отмечает консерванты, чаще других связанные с контактной аллергией. Консерванты нужны для безопасности средства; фильтр пригодится, если у тебя аллергия.",
      "Flags preservatives most often linked to contact allergy. Preservatives keep products safe; this filter is for people with allergies.",
    ],
  ],
  'lanolin_free': [
    ["Lanolinsiz", "Без ланолина", "Lanolin-free"],
    [
      "Lanolin və onun törəmələri olmasın. Lanolinə həssaslığın varsa, bunu seç.",
      "Без ланолина и его производных. Выбери, если у тебя чувствительность к ланолину.",
      "No lanolin or its derivatives. For people sensitive to lanolin.",
    ],
  ],
  'paraben_free': [
    ['Parabensiz', 'Без парабенов', 'Paraben-free'],
    [
      'Tərkibdə parabenlər (metil-, propilparaben və s.) olmasın.',
      'В составе нет парабенов (метил-, пропилпарабен и др.).',
      'No parabens (methylparaben, propylparaben and others).',
    ],
  ],
};
