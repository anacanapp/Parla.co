/// DRAFT CONTENT, NOT REVIEWED BY A TRAINER OR PHYSIOTHERAPIST.
///
/// Name and short how-to of every exercise in `exerciseCatalogue`
/// (parla_shared), per language: `[name, how]`.
library;

import 'exercise_sheet_texts.dart';

int _index(String language) => switch (language) {
  'ru' => 1,
  'en' => 2,
  _ => 0,
};

/// Name and how-to of [id] in [language] (Azerbaijani as fallback). Texts
/// from the content sheet win over the first draft.
(String, String) exerciseText(String id, String language) {
  final sheet = exerciseSheetTexts[id];
  if (sheet != null) {
    final i = _index(language);
    return (sheet[0][i], sheet[1][i]);
  }
  final texts = _texts[language] ?? _texts['az']!;
  final entry = texts[id] ?? _texts['az']![id];
  return entry == null ? (id, '') : (entry[0], entry[1]);
}

/// When to take care or skip the exercise, or `null`.
String? exerciseCaution(String id, String language) {
  final sheet = exerciseSheetTexts[id];
  if (sheet == null) return null;
  final text = sheet[2][_index(language)];
  return text.isEmpty ? null : text;
}

/// Every exercise id with text in [language] (for tests).
Iterable<String> exerciseTextIds(String language) => {
  ...(_texts[language] ?? const <String, List<String>>{}).keys,
  ...exerciseSheetTexts.keys,
};

const _texts = <String, Map<String, List<String>>>{
  'az': {
    'squat': [
      'Squat',
      'Ayaqlar çiyin genişliyində. Ombanı arxaya ver, dizlər ayaq barmaqları istiqamətində. Dabanlardan itələyib qalx.',
    ],
    'sumo_squat': [
      'Sumo squat',
      'Ayaqları geniş aç, barmaqlar bir az çölə. Kürək düz, aşağı en və ombanı sıxaraq qalx.',
    ],
    'reverse_lunge': [
      'Geriyə hamla',
      'Bir ayaqla geri addım at, hər iki diz təxminən 90°. Öndəki dabandan itələyib qayıt. Ayaqları növbələ.',
    ],
    'glute_bridge': [
      'Körpü',
      'Arxası üstə uzan, dizlər bükülü. Ombanı sıxaraq qaldır, çiyindən dizə düz xətt. Yavaşca en.',
    ],
    'donkey_kick': [
      'Geriyə ayaq vurma',
      'Dörd ayaq üstə dur. Bükülü ayağı tavana doğru qaldır, ombanı sıx. Belini əymə.',
    ],
    'calf_raise': [
      'Baldır qaldırma',
      'Düz dur, lazım olsa divardan tut. Barmaqların üstünə qalx, bir an saxla, yavaş en.',
    ],
    'knee_pushup': [
      'Diz üstə şınav',
      'Dizlər yerdə, əllər çiyin altında. Bədəni düz saxlayıb sinəni yerə endir və itələ.',
    ],
    'pushup': [
      'Şınav',
      'Planka vəziyyəti, əllər çiyin altında. Dirsəkləri bir az geri bükərək en, bədəni düz saxlayıb qalx.',
    ],
    'chair_dip': [
      'Stulda dirsək bükmə',
      'Möhkəm stulun kənarından tut, ombanı irəli çıxar. Dirsəkləri geri bükərək en və qalx.',
    ],
    'db_row': [
      'Hantel çəkmə',
      'Bir az əyil, kürək düz. Hantelləri dirsəkləri geri çəkərək belə doğru qaldır, kürək sümüklərini sıx.',
    ],
    'db_press': [
      'Hantel yuxarı itələmə',
      'Hantellər çiyin hündürlüyündə. Qarnı sıxıb yuxarı itələ, yavaşca qaytar.',
    ],
    'db_curl': [
      'Hantel bükmə',
      'Dirsəklər bədənə yaxın. Hantelləri çiyinlərə doğru bük, yavaşca endir.',
    ],
    'db_deadlift': [
      'Romaniya dartması',
      'Hantellər önündə, dizlər bir az bükülü. Ombanı geri verib əyil, kürək düz. Ombanı sıxaraq qalx.',
    ],
    'plank': [
      'Planka',
      'Dirsəklər çiyin altında, bədən başdan dabana düz xətt. Qarnı və ombanı sıx, nəfəsini saxlama.',
    ],
    'side_plank': [
      'Yan planka',
      'Yan uzan, dirsək çiyin altında. Ombanı qaldır, bədən düz xətt. Hər iki tərəfi et.',
    ],
    'dead_bug': [
      'Dead bug',
      'Arxası üstə, qollar yuxarı, dizlər 90°. Belini yerə sıxaraq əks qol və ayağı yavaşca uzat, qaytar.',
    ],
    'superman': [
      'Supermen',
      'Üzü üstə uzan. Qolları və ayaqları bir az yerdən qaldır, boynu uzun saxla. Yavaşca en.',
    ],
    'pil_hundred': [
      'Yüzlük',
      'Arxası üstə, baş və çiyinlər bir az qalxıq. Qolları kiçik hərəkətlə yuxarı-aşağı vur, 5 say nəfəs al, 5 say ver.',
    ],
    'pil_single_leg_stretch': [
      'Tək ayaq uzatma',
      'Baş qalxıq, bir diz sinəyə, o biri ayaq irəli uzanır. Ayaqları ritmlə dəyiş, belini yerə sıx.',
    ],
    'pil_criss_cross': [
      'Çarpaz burulma',
      'Əllər başın arxasında. Çiyni əks dizə doğru çevir, o biri ayaq uzanır. Növbələ.',
    ],
    'pil_leg_circles': [
      'Ayaqla dairə',
      'Arxası üstə, bir ayaq yuxarı. Ayaqla kiçik dairələr çək, çanaq sabit. Hər istiqamətə et.',
    ],
    'pil_swimming': [
      'Üzgüçülük',
      'Üzü üstə, qollar irəli. Əks qol və ayağı kiçik hərəkətlə növbə ilə qaldır, nəfəsi sabit saxla.',
    ],
    'pil_side_kick': [
      'Yan ayaq hərəkəti',
      'Yan uzan, başı əlinə qoy. Üstdəki ayağı irəli və geri yellə, gövdə tərpənməsin.',
    ],
    'pil_clam': [
      'İstiridyə',
      'Yan uzan, dizlər bükülü. Dabanlar bir yerdə, üstdəki dizi aç və bağla. Çanaq geri yatmasın.',
    ],
    'pil_roll_down': [
      'Ayaq üstə əyilmə',
      'Düz dur. Çənəni sinəyə endirib onurğanı fəqərə-fəqərə aşağı yuvarla, eyni yolla qalx.',
    ],
    'pil_bird_dog': [
      'Quş-it',
      'Dörd ayaq üstə. Əks qol və ayağı uzat, bədən sabit. Qaytar, tərəfi dəyiş.',
    ],
    'wall_sit': [
      'Divarda oturma',
      'Kürəyini divara söykə, dizlər təxminən 90° olana qədər aşağı sürüş. Saxla, nəfəs al.',
    ],
    'wall_bridge': [
      'Divarda körpü',
      'Arxası üstə uzan, ayaqları divara qoy, dizlər 90°. Ombanı qaldır və yavaşca endir.',
    ],
    'wall_pushup': [
      'Divarda şınav',
      'Divara üzü dur, əllər çiyin hündürlüyündə. Sinəni divara yaxınlaşdır və itələ.',
    ],
    'wall_angel': [
      'Divar mələyi',
      'Kürək və baş divarda. Qolları "W" şəklində divar boyu yuxarı-aşağı sürüşdür.',
    ],
    'wall_side_leg_lift': [
      'Divarda yan ayaq qaldırma',
      'Bir əllə divardan tut. Kənardakı ayağı yana qaldır, gövdə düz. Hər iki tərəfi et.',
    ],
    'wall_calf_raise': [
      'Divarda baldır qaldırma',
      'Əllər divarda. Barmaqların üstünə qalx, bir an saxla, yavaşca en.',
    ],
    'wall_roll_down': [
      'Divarda əyilmə',
      'Kürəyini divara söykə. Başdan başlayaraq onurğanı divardan ayırıb aşağı yuvarla, geri qalx.',
    ],
    'cat_cow': [
      'Pişik-inək',
      'Dörd ayaq üstə. Nəfəs alarkən sinəni aç, verərkən kürəyini yuvarlaqlaşdır. Yavaş tempdə.',
    ],
    'child_pose': [
      'Uşaq pozası',
      'Dizlər üstə otur, gövdəni irəli endir, qollar uzanır. Rahat nəfəs al.',
    ],
    'hamstring_stretch': [
      'Bud arxası dartma',
      'Otur, bir ayaq uzanır. Kürəyi düz saxlayıb ayağa doğru əyil. Ağrı yox, yüngül dartılma.',
    ],
    'hip_flexor_stretch': [
      'Bud önü dartma',
      'Bir diz yerdə, o biri ayaq önündə. Ombanı yüngülcə irəli ver, kürək düz.',
    ],
    'chest_opener': [
      'Sinə açma',
      'Əlləri arxada birləşdir, çiyinləri geri və aşağı çək, sinəni aç.',
    ],
    'figure_four': [
      'Dördlük dartma',
      'Arxası üstə, bir topuğu o biri dizin üstünə qoy. Altdakı budu sinəyə doğru çək.',
    ],
    'side_stretch': [
      'Yan dartma',
      'Düz dur, bir qolu başın üstündən əks tərəfə uzat. Hər iki tərəfi et.',
    ],
    'march': [
      'Yerində addım',
      'Yerində addımla, dizləri rahat qaldır, qollar ritmlə hərəkət edir.',
    ],
    'step_jack': [
      'Addımlı jak',
      'Tullanmadan: bir ayağı yana at, qolları yuxarı qaldır, qayıt. Tərəfləri növbələ.',
    ],
    'knee_drive': [
      'Diz qaldırma',
      'Qolları yuxarı uzat. Bir dizi qaldırarkən qolları dizə doğru endir. Tərəfləri növbələ.',
    ],
    'boxer_step': [
      'Boksçu addımı',
      'Yüngül yan addımlarla irəli yumruq vur, qarnı sıx. Çiyinləri gərginləşdirmə.',
    ],
    'skater_step': [
      'Konkisürən addımı',
      'Yana geniş addım at, arxa ayağı çarpaz arxaya apar. Yumşaq və tullanmadan.',
    ],
  },
  'ru': {
    'squat': [
      'Приседание',
      'Стопы на ширине плеч. Отводи таз назад, колени по направлению носков. Поднимайся, отталкиваясь пятками.',
    ],
    'sumo_squat': [
      'Сумо-приседание',
      'Широкая постановка, носки чуть наружу. Спина прямая, опустись и поднимись, сжимая ягодицы.',
    ],
    'reverse_lunge': [
      'Обратный выпад',
      'Шагни назад, оба колена примерно 90°. Вернись, отталкиваясь передней пяткой. Чередуй ноги.',
    ],
    'glute_bridge': [
      'Ягодичный мост',
      'Лёжа на спине, колени согнуты. Подними таз, сжимая ягодицы, линия от плеч до колен. Плавно опусти.',
    ],
    'donkey_kick': [
      'Отведение ноги назад',
      'На четвереньках. Подними согнутую ногу к потолку, сжимая ягодицу. Не прогибай поясницу.',
    ],
    'calf_raise': [
      'Подъём на носки',
      'Стоя прямо, при необходимости держись за стену. Поднимись на носки, задержись, медленно опустись.',
    ],
    'knee_pushup': [
      'Отжимание с колен',
      'Колени на полу, ладони под плечами. Опусти грудь, сохраняя прямое тело, и выжми себя.',
    ],
    'pushup': [
      'Отжимание',
      'Планка, ладони под плечами. Опустись, локти чуть назад, тело прямое, поднимись.',
    ],
    'chair_dip': [
      'Обратные отжимания от стула',
      'Держись за край устойчивого стула, таз вперёд. Сгибай локти назад, опускаясь, и поднимайся.',
    ],
    'db_row': [
      'Тяга гантелей',
      'Наклонись, спина прямая. Тяни гантели к поясу, отводя локти назад, своди лопатки.',
    ],
    'db_press': [
      'Жим гантелей вверх',
      'Гантели на уровне плеч. Напряги пресс, выжми вверх, плавно верни.',
    ],
    'db_curl': [
      'Сгибание рук с гантелями',
      'Локти у корпуса. Согни руки к плечам, медленно опусти.',
    ],
    'db_deadlift': [
      'Румынская тяга',
      'Гантели перед собой, колени слегка согнуты. Наклонись, отводя таз назад, спина прямая. Поднимись, сжимая ягодицы.',
    ],
    'plank': [
      'Планка',
      'Локти под плечами, тело прямой линией от головы до пяток. Напряги пресс и ягодицы, дыши.',
    ],
    'side_plank': [
      'Боковая планка',
      'Лёжа на боку, локоть под плечом. Подними таз, тело прямое. Сделай обе стороны.',
    ],
    'dead_bug': [
      'Мёртвый жук',
      'На спине, руки вверх, колени 90°. Прижимая поясницу, медленно вытягивай противоположные руку и ногу.',
    ],
    'superman': [
      'Супермен',
      'Лёжа на животе. Слегка подними руки и ноги, шея длинная. Плавно опусти.',
    ],
    'pil_hundred': [
      'Сотня',
      'На спине, голова и плечи приподняты. Пружинь руками вверх-вниз: 5 счётов вдох, 5 выдох.',
    ],
    'pil_single_leg_stretch': [
      'Вытяжение одной ноги',
      'Голова приподнята, одно колено к груди, другая нога вытянута. Меняй ноги в ритме, поясница прижата.',
    ],
    'pil_criss_cross': [
      'Перекрёстные скручивания',
      'Руки за головой. Поворачивай плечо к противоположному колену, другая нога вытянута. Чередуй.',
    ],
    'pil_leg_circles': [
      'Круги ногой',
      'На спине, одна нога вверх. Рисуй ногой небольшие круги, таз неподвижен. В обе стороны.',
    ],
    'pil_swimming': [
      'Плавание',
      'На животе, руки вперёд. Поочерёдно приподнимай противоположные руку и ногу, дыхание ровное.',
    ],
    'pil_side_kick': [
      'Махи лёжа на боку',
      'Лёжа на боку, голова на руке. Махи верхней ногой вперёд и назад, корпус неподвижен.',
    ],
    'pil_clam': [
      'Ракушка',
      'На боку, колени согнуты. Пятки вместе, раскрывай и закрывай верхнее колено. Таз не заваливается назад.',
    ],
    'pil_roll_down': [
      'Скручивание вниз стоя',
      'Стоя прямо. Опусти подбородок и скручивай позвоночник вниз позвонок за позвонком, так же вернись.',
    ],
    'pil_bird_dog': [
      'Птица-собака',
      'На четвереньках. Вытяни противоположные руку и ногу, корпус неподвижен. Верни, смени сторону.',
    ],
    'wall_sit': [
      'Стульчик у стены',
      'Спиной к стене, опустись, пока колени не будут примерно 90°. Держи и дыши.',
    ],
    'wall_bridge': [
      'Мост со стопами на стене',
      'Лёжа на спине, стопы на стене, колени 90°. Поднимай и плавно опускай таз.',
    ],
    'wall_pushup': [
      'Отжимание от стены',
      'Лицом к стене, ладони на уровне плеч. Приблизь грудь к стене и оттолкнись.',
    ],
    'wall_angel': [
      'Ангел у стены',
      'Спина и голова у стены. Скользи руками буквой «W» вверх и вниз по стене.',
    ],
    'wall_side_leg_lift': [
      'Отведение ноги в сторону у стены',
      'Держись рукой за стену. Отведи дальнюю ногу в сторону, корпус прямой. Обе стороны.',
    ],
    'wall_calf_raise': [
      'Подъём на носки у стены',
      'Руки на стене. Поднимись на носки, задержись, медленно опустись.',
    ],
    'wall_roll_down': [
      'Скручивание у стены',
      'Спиной к стене. Начиная с головы, отделяй позвоночник от стены и скручивайся вниз, вернись.',
    ],
    'cat_cow': [
      'Кошка-корова',
      'На четвереньках. На вдохе раскрой грудь, на выдохе округли спину. В медленном темпе.',
    ],
    'child_pose': [
      'Поза ребёнка',
      'Сядь на пятки, опусти корпус вперёд, руки вытянуты. Дыши спокойно.',
    ],
    'hamstring_stretch': [
      'Растяжка задней поверхности бедра',
      'Сидя, одна нога вытянута. С прямой спиной наклонись к ноге. Лёгкое натяжение, без боли.',
    ],
    'hip_flexor_stretch': [
      'Растяжка передней поверхности бедра',
      'Одно колено на полу, другая нога впереди. Мягко подай таз вперёд, спина прямая.',
    ],
    'chest_opener': [
      'Раскрытие груди',
      'Сцепи руки за спиной, отведи плечи назад и вниз, раскрой грудь.',
    ],
    'figure_four': [
      'Растяжка «четвёрка»',
      'На спине, положи лодыжку на колено другой ноги. Подтяни нижнее бедро к груди.',
    ],
    'side_stretch': [
      'Боковое вытяжение',
      'Стоя, тянись одной рукой над головой в сторону. Сделай обе стороны.',
    ],
    'march': [
      'Шаг на месте',
      'Шагай на месте, свободно поднимая колени, руки работают в ритм.',
    ],
    'step_jack': [
      'Джек с шагом',
      'Без прыжков: шаг в сторону с подъёмом рук, вернись. Чередуй стороны.',
    ],
    'knee_drive': [
      'Подъём колена',
      'Руки вверх. Поднимая колено, опускай руки к нему. Чередуй стороны.',
    ],
    'boxer_step': [
      'Шаг боксёра',
      'Лёгкие шаги в стороны и удары вперёд, пресс напряжён. Не зажимай плечи.',
    ],
    'skater_step': [
      'Шаг конькобежца',
      'Широкий шаг в сторону, заднюю ногу уводи крест-накрест назад. Мягко, без прыжков.',
    ],
  },
  'en': {
    'squat': [
      'Squat',
      'Feet shoulder-width apart. Push your hips back, knees in line with your toes. Drive up through your heels.',
    ],
    'sumo_squat': [
      'Sumo squat',
      'Wide stance, toes turned out a little. Back straight, lower down and come up squeezing your glutes.',
    ],
    'reverse_lunge': [
      'Reverse lunge',
      'Step back with one leg, both knees about 90°. Push through the front heel to return. Alternate legs.',
    ],
    'glute_bridge': [
      'Glute bridge',
      'Lie on your back, knees bent. Lift your hips by squeezing your glutes, shoulders to knees in a line. Lower slowly.',
    ],
    'donkey_kick': [
      'Donkey kick',
      'On all fours. Lift one bent leg towards the ceiling, squeezing the glute. Do not arch your lower back.',
    ],
    'calf_raise': [
      'Calf raise',
      'Stand tall, hold a wall if needed. Rise onto your toes, pause, lower slowly.',
    ],
    'knee_pushup': [
      'Knee push-up',
      'Knees down, hands under shoulders. Lower your chest keeping your body straight, then press up.',
    ],
    'pushup': [
      'Push-up',
      'Plank position, hands under shoulders. Lower with elbows angled back, body straight, and press up.',
    ],
    'chair_dip': [
      'Chair dip',
      'Hold the edge of a sturdy chair, hips forward. Bend your elbows back to lower, then press up.',
    ],
    'db_row': [
      'Dumbbell row',
      'Hinge forward, back flat. Pull the dumbbells to your waist with elbows back, squeeze your shoulder blades.',
    ],
    'db_press': [
      'Dumbbell press',
      'Dumbbells at shoulder height. Brace your core, press up, lower with control.',
    ],
    'db_curl': [
      'Dumbbell curl',
      'Elbows close to your body. Curl the dumbbells to your shoulders, lower slowly.',
    ],
    'db_deadlift': [
      'Romanian deadlift',
      'Dumbbells in front, knees soft. Hinge at the hips with a flat back. Stand up squeezing your glutes.',
    ],
    'plank': [
      'Plank',
      'Elbows under shoulders, body in a straight line from head to heels. Brace your core and glutes, keep breathing.',
    ],
    'side_plank': [
      'Side plank',
      'Lie on your side, elbow under shoulder. Lift your hips into a straight line. Do both sides.',
    ],
    'dead_bug': [
      'Dead bug',
      'On your back, arms up, knees at 90°. Keep your lower back down and slowly extend the opposite arm and leg.',
    ],
    'superman': [
      'Superman',
      'Lie face down. Lift arms and legs slightly, neck long. Lower slowly.',
    ],
    'pil_hundred': [
      'The hundred',
      'On your back, head and shoulders lifted. Pump your arms: breathe in for 5 counts, out for 5.',
    ],
    'pil_single_leg_stretch': [
      'Single leg stretch',
      'Head lifted, one knee to the chest, the other leg long. Switch in rhythm, lower back down.',
    ],
    'pil_criss_cross': [
      'Criss-cross',
      'Hands behind your head. Turn a shoulder towards the opposite knee, other leg long. Alternate.',
    ],
    'pil_leg_circles': [
      'Leg circles',
      'On your back, one leg up. Draw small circles with it, pelvis still. Both directions.',
    ],
    'pil_swimming': [
      'Swimming',
      'Face down, arms forward. Lift the opposite arm and leg in small alternating moves, breathing evenly.',
    ],
    'pil_side_kick': [
      'Side kick',
      'Lie on your side, head on your hand. Swing the top leg forward and back, torso still.',
    ],
    'pil_clam': [
      'Clam',
      'On your side, knees bent. Heels together, open and close the top knee. Keep the pelvis from rolling back.',
    ],
    'pil_roll_down': [
      'Standing roll down',
      'Stand tall. Drop your chin and roll the spine down one vertebra at a time, then roll back up.',
    ],
    'pil_bird_dog': [
      'Bird dog',
      'On all fours. Reach the opposite arm and leg long, body steady. Return and switch sides.',
    ],
    'wall_sit': [
      'Wall sit',
      'Back against the wall, slide down until your knees are about 90°. Hold and breathe.',
    ],
    'wall_bridge': [
      'Wall bridge',
      'Lie on your back with feet on the wall, knees at 90°. Lift and slowly lower your hips.',
    ],
    'wall_pushup': [
      'Wall push-up',
      'Face the wall, hands at shoulder height. Bring your chest towards the wall and push away.',
    ],
    'wall_angel': [
      'Wall angel',
      'Back and head on the wall. Slide your arms up and down the wall in a "W" shape.',
    ],
    'wall_side_leg_lift': [
      'Wall side leg lift',
      'Hold the wall with one hand. Lift the outer leg to the side, torso tall. Both sides.',
    ],
    'wall_calf_raise': [
      'Wall calf raise',
      'Hands on the wall. Rise onto your toes, pause, lower slowly.',
    ],
    'wall_roll_down': [
      'Wall roll down',
      'Back against the wall. Starting with your head, peel the spine off the wall and roll down, then back up.',
    ],
    'cat_cow': [
      'Cat-cow',
      'On all fours. Open the chest as you breathe in, round the back as you breathe out. Slowly.',
    ],
    'child_pose': [
      "Child's pose",
      'Sit back on your heels, lower your torso forward, arms long. Breathe easily.',
    ],
    'hamstring_stretch': [
      'Hamstring stretch',
      'Sit with one leg long. Keep your back straight and lean towards it. A gentle pull, no pain.',
    ],
    'hip_flexor_stretch': [
      'Hip flexor stretch',
      'One knee down, the other foot in front. Ease your hips forward, back straight.',
    ],
    'chest_opener': [
      'Chest opener',
      'Clasp your hands behind you, draw your shoulders back and down, open the chest.',
    ],
    'figure_four': [
      'Figure four stretch',
      'On your back, cross one ankle over the other knee. Pull the lower thigh towards your chest.',
    ],
    'side_stretch': [
      'Side stretch',
      'Stand tall and reach one arm over your head to the side. Do both sides.',
    ],
    'march': [
      'March in place',
      'March on the spot, lifting your knees easily, arms moving in rhythm.',
    ],
    'step_jack': [
      'Step jack',
      'No jumping: step one foot out as your arms go up, step back. Alternate sides.',
    ],
    'knee_drive': [
      'Knee drive',
      'Arms up. Bring them down towards your knee as you lift it. Alternate sides.',
    ],
    'boxer_step': [
      'Boxer step',
      'Light side steps with punches forward, core braced. Keep your shoulders relaxed.',
    ],
    'skater_step': [
      'Skater step',
      'Take a wide step to the side and sweep the back leg behind. Soft, no jumping.',
    ],
  },
};
