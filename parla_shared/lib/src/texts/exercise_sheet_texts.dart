/// DRAFT CONTENT from the content sheet ("hereketler"), NOT REVIEWED by a
/// trainer or physiotherapist yet. For each exercise: name, how-to and
/// caution `[az, ru, en]`, and the start and end image file names (the
/// licensed images arrive later). These replace the first draft texts in
/// `exercise_text.dart` where both exist.
library;

const exerciseSheetTexts = <String, List<List<String>>>{
  'bicycle_crunch': [
    ["Velosiped", "«Велосипед»", "Bicycle crunch"],
    [
      "Arxası üstə uzan, əllərin başının yanında olsun. Çiyinlərini qaldırıb sağ dirsəyini sol dizinə doğru çevir, sonra əksinə. Boynunu əllə dartma.",
      "Ляг на спину, руки у головы. Приподними плечи и тяни правый локоть к левому колену, затем наоборот. Не тяни шею руками.",
      "On your back, hands by your head. Lift your shoulders and rotate right elbow toward left knee, then switch. Don't pull on your neck.",
    ],
    [
      "Hamiləlikdə və doğuşdan sonra qarın əzələlərinin aralanması (diastaz) varsa, etmə; boyun ağrısında dayan.",
      "Не делай при беременности и диастазе после родов; при боли в шее остановись.",
      "Skip during pregnancy or with abdominal separation after birth; stop if your neck hurts.",
    ],
    ["bicycle-crunch-1.png", "bicycle-crunch-2.png"],
  ],
  'calf_raise': [
    ["Barmaq ucunda qalxma", "Подъёмы на носки", "Calf raise"],
    [
      "Düz dayan, dabanlarını qaldırıb barmaq uclarına qalx, 1 saniyə saxla və yavaş endir.",
      "Встань ровно, поднимись на носки, задержись на секунду и медленно опустись.",
      "Stand tall, rise onto your toes, hold for a second and lower slowly.",
    ],
    [
      "Axilles vətərində zədə varsa, həkimlə məsləhətləş.",
      "При травме ахиллова сухожилия посоветуйся с врачом.",
      "Check with a doctor if you have an Achilles injury.",
    ],
    ["calf-raise-1.png", "calf-raise-2.png"],
  ],
  'cat_cow': [
    ["Pişik-inək", "«Кошка-корова»", "Cat-cow"],
    [
      "Əllərin və dizlərin üstündə dur. Nəfəs alarkən belini aşağı əy, nəfəs verərkən kürəyini yuvarlaqlaşdır. Yavaş və rahat et.",
      "Встань на четвереньки. На вдохе прогнись вниз, на выдохе округли спину. Медленно и плавно.",
      "On hands and knees, arch your back as you breathe in and round it as you breathe out. Slow and easy.",
    ],
    [
      "Kəskin bel ağrısında amplitudu kiçilt.",
      "При острой боли в спине уменьши амплитуду.",
      "Reduce the range with acute back pain.",
    ],
    ["cat-cow-1.png", "cat-cow-2.png"],
  ],
  'chair_dip': [
    ["Stulda triseps", "Обратные отжимания от стула", "Chair dip"],
    [
      "Sabit stulun kənarından tut, ayaqların irəlidə olsun. Dirsəklərini geriyə büküb bədənini endir və yuxarı itələ.",
      "Держись за край устойчивого стула, ноги впереди. Сгибая локти назад, опустись и вытолкни себя вверх.",
      "Hold the edge of a sturdy chair with feet forward. Bend your elbows back to lower, then press up.",
    ],
    [
      "Çiyninin önündə ağrı olarsa, dayan; təkərli stul istifadə etmə.",
      "При боли в передней части плеча остановись; не используй стул на колёсиках.",
      "Stop if the front of your shoulder hurts; never use a chair on wheels.",
    ],
    ["chair-dip-1.png", "chair-dip-2.png"],
  ],
  'child_pose': [
    ["Uşaq duruşu", "Поза ребёнка", "Child's pose"],
    [
      "Diz üstə oturub ombanı dabanlarına endir, qollarını irəli uzat, alnını yerə qoy. Dərindən nəfəs al.",
      "Сядь на пятки, вытяни руки вперёд и опусти лоб на пол. Дыши глубоко.",
      "Kneel, sit back on your heels, stretch your arms forward and rest your forehead down. Breathe deeply.",
    ],
    [
      "Hamiləlikdə dizlərini geniş aç; diz zədəsində altına yastıq qoy.",
      "При беременности разведи колени шире; при травме колена подложи подушку.",
      "Widen your knees during pregnancy; use a cushion with a knee injury.",
    ],
    ["child-pose-1.png", "child-pose-2.png"],
  ],
  'db_curl': [
    ["Hantel ilə biseps", "Сгибание рук с гантелями", "Dumbbell biceps curl"],
    [
      "Dirsəklərini bədəninə yapışdır, hantelləri çiyinlərinə doğru qaldır və yavaş endir.",
      "Прижми локти к корпусу; подними гантели к плечам и медленно опусти.",
      "Elbows tucked in, curl the weights toward your shoulders and lower slowly.",
    ],
    [
      "Dirsək ağrısında yükü azalt.",
      "При боли в локте уменьши вес.",
      "Reduce the weight if your elbow hurts.",
    ],
    ["db-bicep-curl-1.png", "db-bicep-curl-2.png"],
  ],
  'db_press': [
    ["Hantel ilə çiyin press", "Жим гантелей вверх", "Dumbbell shoulder press"],
    [
      "Hantellər çiyin hündürlüyündə olsun. Qollarını yuxarı itələ, belini əymə, yavaş endir.",
      "Гантели на уровне плеч. Выжми вверх, не прогибая поясницу, медленно опусти.",
      "Dumbbells at shoulder height. Press overhead without arching your back; lower slowly.",
    ],
    [
      "Çiyin zədən varsa, həkim icazəsi olmadan etmə.",
      "При травме плеча — только с разрешения врача.",
      "With a shoulder injury, only with your doctor's approval.",
    ],
    ["db-shoulder-press-1.png", "db-shoulder-press-2.png"],
  ],
  'dead_bug': [
    ["Dead bug", "«Мёртвый жук»", "Dead bug"],
    [
      "Arxası üstə uzan, qolların yuxarıda, dizlərin 90° bükülü olsun. Belini yerə basılı saxlayaraq əks qolu və ayağı yavaş uzat, qayıt, növbələ.",
      "Ляг на спину, руки вверх, колени под 90°. Прижимая поясницу к полу, медленно выпрямляй противоположные руку и ногу, чередуя.",
      "On your back, arms up, knees at 90°. Keeping your lower back pressed down, slowly extend opposite arm and leg; alternate.",
    ],
    [
      "Hamiləliyin 1-ci trimestrindən sonra arxası üstə hərəkətləri bird-dog ilə əvəz et.",
      "После первого триместра замени на «птицу-собаку».",
      "After the first trimester of pregnancy, swap for bird-dog.",
    ],
    ["dead-bug-1.png", "dead-bug-2.png"],
  ],
  'donkey_kick': [
    [
      "Dörd əllə ayaq qaldırma",
      "Отведение ноги на четвереньках",
      "Donkey kick",
    ],
    [
      "Əllərin və dizlərin üstündə dur, kürəyin düz olsun. Bükülü ayağını dabanı tavana doğru qaldır, belini əymə.",
      "Встань на четвереньки, спина ровная. Подними согнутую ногу пяткой к потолку, не прогибая поясницу.",
      "On hands and knees with a flat back, lift one bent leg heel-up toward the ceiling without arching your lower back.",
    ],
    [
      "Bilək ağrısında yumruqlarına dayan.",
      "При боли в запястье опирайся на кулаки.",
      "If your wrists hurt, rest on your fists.",
    ],
    ["donkey-kick-1.png", "donkey-kick-2.png"],
  ],
  'glute_bridge': [
    ["Omba körpüsü", "Ягодичный мостик", "Glute bridge"],
    [
      "Arxası üstə uzan, dizlərini bük, ayaqların yerdə olsun. Ombanı sıxaraq qaldır ki, çiyinlərdən dizlərə qədər düz xətt alınsın; yavaş endir.",
      "Ляг на спину, колени согнуты, стопы на полу. Сжимая ягодицы, подними таз до прямой линии от плеч до коленей, медленно опусти.",
      "Lie on your back, knees bent, feet flat. Squeeze your glutes to lift your hips into a straight line from shoulders to knees; lower slowly.",
    ],
    [
      "Hamiləliyin 1-ci trimestrindən sonra arxası üstə uzun müddət uzanma.",
      "После первого триместра беременности не лежи долго на спине.",
      "After the first trimester of pregnancy, avoid lying on your back for long.",
    ],
    ["glute-bridge-1.png", "glute-bridge-2.png"],
  ],
  'high_knees': [
    ["Diz qaldırma", "Бег с высоким подниманием колен", "High knees"],
    [
      "Yerində qaçırmış kimi dizlərini omba hündürlüyünə qaldır, qollarını ritmik hərəkət etdir.",
      "Беги на месте, поднимая колени до уровня бёдер, руки работают ритмично.",
      "Run in place, lifting knees to hip height with arms pumping.",
    ],
    [
      "Hamiləlikdə və diz ağrısında yerində yerişlə əvəz et.",
      "При беременности и боли в коленях замени шагом на месте.",
      "Swap for marching in place during pregnancy or with knee pain.",
    ],
    ["high-knees-1.png", "high-knees-2.png"],
  ],
  'jumping_jack': [
    ["Jumping jack (sıçrayışlı açılma)", "Прыжки «джек»", "Jumping jack"],
    [
      "Sıçrayaraq ayaqlarını aç və qollarını başının üstünə qaldır, sonra başlanğıc vəziyyətə qayıt.",
      "Прыжком расставь ноги и подними руки над головой, затем вернись в исходное положение.",
      "Jump your feet apart while raising your arms overhead, then return.",
    ],
    [
      "Hamiləlikdə, çanaq dibi əzələləri zəif olanda və diz ağrısında sıçrayışsız versiyanı (step-jack) seç.",
      "При беременности, слабости тазового дна и боли в коленях выбирай вариант без прыжка.",
      "In pregnancy, with pelvic floor weakness or knee pain, choose the no-jump version (step-jack).",
    ],
    ["jumping-jack-1.png", "jumping-jack-2.png"],
  ],
  'knee_pushup': [
    ["Diz üstə şnur", "Отжимания с колен", "Knee push-up"],
    [
      "Dizlərin yerdə, əllərin çiyinlərdən bir az geniş olsun. Başdan dizlərə qədər düz xətt saxlayaraq sinəni endir və qaldır.",
      "Колени на полу, ладони чуть шире плеч. Сохраняя прямую линию от головы до коленей, опусти и подними грудь.",
      "Knees down, hands slightly wider than shoulders. Keep a straight line from head to knees as you lower and lift.",
    ],
    [
      "Bilək ağrısında şınavı divara qarşı et.",
      "При боли в запястьях отжимайся от стены.",
      "If your wrists hurt, do push-ups against a wall.",
    ],
    ["knee-push-up-1.png", "knee-push-up-2.png"],
  ],
  'march': [
    ["Yerində yəriş", "Шаг на месте", "March in place"],
    [
      "Yerində canlı tempdə yeri, dizlərini qaldır, qollarını hərəkət etdir. İsinmə və soyuma üçündür.",
      "Шагай на месте бодрым темпом, поднимая колени и работая руками. Для разминки и заминки.",
      "March briskly in place, lifting knees and swinging arms. For warm-up and cool-down.",
    ],
    [
      "Başın gicəllənərsə və ya sinəndə ağrı olarsa, dərhal dayan.",
      "При головокружении или боли в груди сразу остановись.",
      "Stop right away if you feel dizzy or have chest pain.",
    ],
    ["march-in-place-1.png", "march-in-place-2.png"],
  ],
  'mountain_climber': [
    ["Dağa dırmanma", "«Скалолаз»", "Mountain climber"],
    [
      "Düz qollar üzərində planka dur. Dizlərini növbə ilə sinənə çək; ombanı sabit saxla.",
      "Встань в планку на прямых руках. Поочерёдно подтягивай колени к груди, таз держи стабильно.",
      "High plank on your hands. Drive knees toward your chest one at a time, keeping hips steady.",
    ],
    [
      "Bilək və ya çiyin ağrısında yavaş templə et.",
      "При боли в запястьях или плечах делай в медленном темпе.",
      "Go slowly if your wrists or shoulders hurt.",
    ],
    ["mountain-climber-1.png", "mountain-climber-2.png"],
  ],
  'pil_bird_dog': [
    ["Bird-dog", "«Птица-собака»", "Bird-dog"],
    [
      "Əllərin və dizlərin üstündə dur, kürəyin düz olsun. Sağ qolunu və sol ayağını eyni vaxtda uzat, 2 saniyə saxla, tərəfi dəyiş.",
      "Встань на четвереньки, спина ровная. Вытяни правую руку и левую ногу, задержись на 2 секунды, смени сторону.",
      "On hands and knees with a flat back, extend right arm and left leg, hold 2 seconds, then switch.",
    ],
    [
      "Bilək ağrısında yumruqlarına dayan.",
      "При боли в запястье опирайся на кулаки.",
      "If your wrists hurt, rest on your fists.",
    ],
    ["bird-dog-1.png", "bird-dog-2.png"],
  ],
  'pil_clam': [
    ["Clamshell (yanda diz açma)", "«Ракушка»", "Clamshell"],
    [
      "Yan üstə uzan, dizlərini bük, ayaqların bir yerdə olsun. Ayaqları ayırmadan yuxarıdakı dizi aç və yavaş bağla.",
      "Ляг на бок, колени согнуты, стопы вместе. Не разъединяя стоп, открой верхнее колено и медленно закрой.",
      "Lie on your side, knees bent, feet together. Keeping feet touching, open the top knee and close it slowly.",
    ],
    [
      "Bud-çanaq oynağında əməliyyat keçirmisənsə, yalnız həkim icazəsi ilə et.",
      "Если ты перенесла операцию на тазобедренном суставе — только с разрешения врача.",
      "After hip surgery, only with your doctor's approval.",
    ],
    ["clamshell-1.png", "clamshell-2.png"],
  ],
  'plank': [
    ["Planka", "Планка", "Plank"],
    [
      "Dirsəklər çiyinlərin altında, bədənin başdan dabanlara qədər düz xəttdə olsun. Qarnını və ombanı sıxıb saxla, nəfəs al.",
      "Локти под плечами, тело прямое от головы до пяток. Напряги пресс и ягодицы, дыши.",
      "Elbows under shoulders, body straight from head to heels. Brace your core and glutes and keep breathing.",
    ],
    [
      "Bel ağrın varsa, dizlərin yerdə et; doğuşdan sonra həkim icazəsi ilə başla.",
      "При боли в пояснице делай с колен; после родов — с разрешения врача.",
      "Drop to your knees if your back hurts; after giving birth, only with your doctor's approval.",
    ],
    ["plank-1.png", "plank-2.png"],
  ],
  'pushup': [
    ["Şnur", "Отжимания", "Push-up"],
    [
      "Planka vəziyyətində bədənini düz xəttdə saxla. Dirsəklərini bədənə təxminən 45° tutaraq sinəni endir və qaldır.",
      "Встань в планку, тело прямое. Держи локти под 45° к корпусу, опусти и подними грудь.",
      "From a plank with a straight body, lower and lift your chest with elbows at about 45°.",
    ],
    [
      "Bel ağrısında belini əymə; çətin olsa, diz üstə versiyaya keç.",
      "При боли в пояснице не прогибайся; если тяжело — отжимайся с колен.",
      "Don't let your hips sag if your lower back hurts; switch to knees if needed.",
    ],
    ["push-up-1.png", "push-up-2.png"],
  ],
  'reverse_lunge': [
    ["Geriyə adım (lunge)", "Выпад назад", "Reverse lunge"],
    [
      "Bir ayağını geriyə at, hər iki diz təxminən 90° bükülsün; öndəki ayağın dabanından itələyərək qayıt. Ayaqları növbələ.",
      "Шагни одной ногой назад, оба колена согнуты примерно на 90°; вернись, отталкиваясь пяткой передней ноги. Чередуй ноги.",
      "Step one foot back, bending both knees to about 90°; push through the front heel to return. Alternate legs.",
    ],
    [
      "Tarazlıqda çətinlik çəkirsənsə, divardan və ya stuldan tut.",
      "При проблемах с равновесием держись за стену или стул.",
      "Hold a wall or chair if balance is an issue.",
    ],
    ["reverse-lunge-1.png", "reverse-lunge-2.png"],
  ],
  'side_lunge': [
    ["Yana adım", "Боковой выпад", "Side lunge"],
    [
      "Geniş addımla yana çıx, həmin dizi büküb ombanı geri apar, digər ayaq düz qalsın. Mərkəzə qayıt.",
      "Сделай широкий шаг в сторону, согни это колено, отведи таз назад, другая нога прямая. Вернись в центр.",
      "Take a wide step to the side, bend that knee and sit the hips back with the other leg straight. Return to centre.",
    ],
    [
      "Qasıq və ya diz ağrısında hərəkətin amplitudunu azalt.",
      "При боли в паху или колене уменьши амплитуду.",
      "Reduce the range if your groin or knee hurts.",
    ],
    ["side-lunge-1.png", "side-lunge-2.png"],
  ],
  'side_plank': [
    ["Yan planka", "Боковая планка", "Side plank"],
    [
      "Yan üstə uzan, dirsəyin çiyninin altında olsun. Ombanı qaldırıb bədənini düz xəttdə saxla. Başlanğıcda aşağıdakı dizin yerdə qala bilər.",
      "Ляг на бок, локоть под плечом. Подними таз и держи тело прямо. Для начала можно опираться на нижнее колено.",
      "On your side, elbow under shoulder. Lift your hips and hold a straight line. Beginners can keep the lower knee down.",
    ],
    [
      "Çiyin ağrısında bu hərəkəti etmə.",
      "Не делай при боли в плече.",
      "Skip if your shoulder hurts.",
    ],
    ["side-plank-1.png", "side-plank-2.png"],
  ],
  'squat': [
    ["Squat (oturub-durma)", "Приседания", "Squat"],
    [
      "Ayaqların çiyin genişliyində, dizlərin barmaqlarla bir istiqamətdə, kürəyin düz olsun. Ombanı stula oturan kimi geri apar, dabanlarından itələyərək qalx.",
      "Ноги на ширине плеч, колени смотрят туда же, куда носки, спина ровная. Отводи таз назад, будто садишься на стул, и вставай, отталкиваясь пятками.",
      "Feet shoulder-width, knees in line with toes, back straight. Sit your hips back as if onto a chair, then push through your heels to stand.",
    ],
    [
      "Diz zədən varsa, həkimlə məsləhətləş; ağrı olarsa, dərinliyi azalt.",
      "При травме колена посоветуйся с врачом; при боли уменьши глубину.",
      "If you have a knee injury, check with a doctor; reduce depth if it hurts.",
    ],
    ["squat-1.png", "squat-2.png"],
  ],
  'step_jack': [
    ["Sıçrayışsız jack", "«Джек» без прыжка", "Step jack"],
    [
      "Bir ayağını yana atıb qollarını yuxarı qaldır, qayıt, digər tərəfə təkrarla.",
      "Шагни ногой в сторону, поднимая руки, вернись и повтори в другую сторону.",
      "Step one foot out as you raise your arms, return, then repeat on the other side.",
    ],
    [
      "Başın gicəllənərsə, dayan.",
      "При головокружении остановись.",
      "Stop if you feel dizzy.",
    ],
    ["step-jack-1.png", "step-jack-2.png"],
  ],
  'step_up': [
    ["Pilləkənə çıxma", "Зашагивания на ступеньку", "Step-up"],
    [
      "Sabit pilləyə bir ayağını qoyub üstünə qalx, sonra nəzarətlə en. Ayaqları növbələ.",
      "Поставь ногу на устойчивую ступеньку, поднимись и под контролем спустись. Чередуй ноги.",
      "Place one foot on a sturdy step, stand up onto it, then lower with control. Alternate legs.",
    ],
    [
      "Sürüşkən səthdən istifadə etmə; tarazlıq üçün divardan tut.",
      "Не используй скользкую поверхность; держись за стену.",
      "Don't use a slippery surface; hold a wall for balance.",
    ],
    ["step-up-1.png", "step-up-2.png"],
  ],
  'sumo_squat': [
    ["Sumo squat", "Приседания сумо", "Sumo squat"],
    [
      "Ayaqlarını geniş qoy, barmaqlar bir az çölə baxsın. Kürəyini düz saxlayaraq çömbəl və qalx.",
      "Поставь ноги широко, носки слегка наружу. С ровной спиной присядь и встань.",
      "Wide stance, toes turned slightly out. Keep your back straight as you squat and stand.",
    ],
    [
      "Diz və ya qasıq ağrısında dərinliyi azalt.",
      "При боли в колене или паху уменьши глубину.",
      "Reduce depth if your knee or groin hurts.",
    ],
    ["sumo-squat-1.png", "sumo-squat-2.png"],
  ],
  'superman': [
    ["Superman", "«Супермен»", "Superman"],
    [
      "Üzüstə uzan, qolların irəlidə olsun. Qollarını, sinəni və ayaqlarını bir az qaldırıb 2–3 saniyə saxla, endir.",
      "Ляг на живот, руки впереди. Приподними руки, грудь и ноги на 2–3 секунды и опусти.",
      "Lie face down, arms forward. Lift arms, chest and legs slightly for 2–3 seconds, then lower.",
    ],
    [
      "Hamiləlikdə üzüstə uzanmaq uyğun deyil; bel yırtığın (disk yırtığı) varsa, həkimlə məsləhətləş.",
      "При беременности лежать на животе нельзя; при грыже диска посоветуйся с врачом.",
      "Not suitable in pregnancy (lying face down); check with a doctor if you have a disc herniation.",
    ],
    ["superman-1.png", "superman-2.png"],
  ],
  'wall_pushup': [
    ["Divara şnur", "Отжимания от стены", "Wall push-up"],
    [
      "Divardan bir qol uzunluğunda dayan, əllərin çiyin hündürlüyündə olsun. Sinəni divara yaxınlaşdır və geri itələ.",
      "Встань на расстоянии вытянутой руки от стены, ладони на уровне плеч. Приблизь грудь к стене и оттолкнись.",
      "Stand an arm's length from a wall, hands at shoulder height. Bring your chest toward the wall and push back.",
    ],
    [
      "Çiyin zədəsində ağrısız amplitudda et.",
      "При травме плеча работай в безболезненной амплитуде.",
      "With a shoulder injury, stay within a pain-free range.",
    ],
    ["wall-push-up-1.png", "wall-push-up-2.png"],
  ],
  'wall_sit': [
    ["Divar önündə oturuş", "Стульчик у стены", "Wall sit"],
    [
      "Kürəyini divara söykəyib aşağı sürüş ki, dizlər təxminən 90° olsun. Bu vəziyyətdə qal, normal nəfəs al.",
      "Прижмись спиной к стене и опустись до угла в коленях около 90°. Удерживай положение, дыши спокойно.",
      "Lean your back against a wall and slide down until knees are about 90°. Hold and breathe normally.",
    ],
    [
      "Nəfəsini saxlama; yüksək qan təzyiqin varsa, qısa müddət et.",
      "Не задерживай дыхание; при гипертонии делай коротко.",
      "Don't hold your breath; keep it short if you have high blood pressure.",
    ],
    ["wall-sit-1.png", "wall-sit-2.png"],
  ],
};
