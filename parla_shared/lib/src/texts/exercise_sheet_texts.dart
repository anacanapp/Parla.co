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
  // Face yoga, from the document "Üz yoqası: tətbiq məzmunu" (2026-11-22).
  'fy_forehead_smooth': [
    ["Alın hamarlama", "Разглаживание лба", "Forehead smoothing"],
    [
      "Barmaq uclarını alnın ortasına qoyun. Yüngül toxunuşla gicgahlara doğru sürüşdürün. Qaşları qaldırmayın, alın rahat qalsın.",
      "Положите кончики пальцев на середину лба. Лёгким касанием ведите к вискам. Не поднимайте брови, лоб расслаблен.",
      "Place your fingertips in the middle of your forehead. Glide them lightly towards your temples. Keep your brows down and your forehead relaxed.",
    ],
    ["Dərini dartmayın.", "Не растягивайте кожу.", "Don't pull the skin."],
    ["fy-forehead-smooth-1.png", "fy-forehead-smooth-2.png"],
  ],
  'fy_brow_lift': [
    ["Qaş qaldırma", "Подъём бровей", "Brow lift"],
    [
      "Şəhadət barmaqlarını qaşların altına qoyun. Qaşları barmaqlara qədər yuxarı qaldırın, barmaqlar yüngül müqavimət göstərsin. 10 san saxlayın, rahatlaşın.",
      "Положите указательные пальцы под брови. Поднимайте брови к пальцам, пальцы слегка сопротивляются. Держите 10 секунд и расслабьтесь.",
      "Rest your index fingers under your brows. Lift your brows against your fingers, which push back gently. Hold for 10 seconds, then relax.",
    ],
    ["Alını qırışdırmayın.", "Не морщите лоб.", "Don't wrinkle your forehead."],
    ["fy-brow-lift-1.png", "fy-brow-lift-2.png"],
  ],
  'fy_eye_v': [
    ["V hərəkəti", "Упражнение «V»", "The V"],
    [
      "Orta barmaqları qaşların daxili ucuna, şəhadət barmaqlarını gözlərin xarici küncünə qoyun (V şəkli). Yuxarı baxın və aşağı göz qapaqlarını yüngül sıxın.",
      "Средние пальцы — у внутренних краёв бровей, указательные — у внешних уголков глаз (буква V). Смотрите вверх и слегка напрягайте нижние веки.",
      "Middle fingers at the inner ends of your brows, index fingers at the outer corners of your eyes (a V shape). Look up and gently squeeze your lower lids.",
    ],
    [
      "Göz almasına toxunmayın.",
      "Не касайтесь глазного яблока.",
      "Don't touch the eyeball.",
    ],
    ["fy-eye-v-1.png", "fy-eye-v-2.png"],
  ],
  'fy_cheek_lift': [
    ["Yanaq qaldırma", "Подъём щёк", "Cheek lift"],
    [
      "Dodaqlar bağlı geniş gülümsəyin. Barmaq uclarını yanaqların qabarıq yerinə qoyub yanaqları yüngül yuxarı qaldırın.",
      "Широко улыбнитесь с сомкнутыми губами. Положите кончики пальцев на скулы и слегка поднимайте щёки вверх.",
      "Smile widely with your lips closed. Place your fingertips on the high points of your cheeks and lift them gently.",
    ],
    ["", "", ""],
    ["fy-cheek-lift-1.png", "fy-cheek-lift-2.png"],
  ],
  'fy_fish_face': [
    ["Balıq üzü", "Рыбье лицо", "Fish face"],
    [
      "Yanaqları içəri çəkin, dodaqlar irəli çıxsın. Bu vəziyyətdə gülümsəməyə çalışın.",
      "Втяните щёки, губы вытянуты вперёд. В этом положении попробуйте улыбнуться.",
      "Suck your cheeks in so your lips push forward. Try to smile in this position.",
    ],
    ["", "", ""],
    ["fy-fish-face-1.png", "fy-fish-face-2.png"],
  ],
  'fy_air_puff': [
    ["Hava ötürmə", "Перекатывание воздуха", "Air puff"],
    [
      "Ağzı havayla doldurun. Havanı yavaşca sağ yanağa, sol yanağa, üst dodağın üstünə və alt dodağın altına ötürün.",
      "Наберите воздух в рот. Медленно перекатывайте его в правую щёку, в левую, над верхней губой и под нижней.",
      "Fill your mouth with air. Slowly move it to your right cheek, left cheek, above your upper lip and below your lower lip.",
    ],
    ["", "", ""],
    ["fy-air-puff-1.png", "fy-air-puff-2.png"],
  ],
  'fy_jaw_release': [
    ["Çənə rahatlatma", "Расслабление челюсти", "Jaw release"],
    [
      "Barmaq uclarını qulaqların önündə, çənə oynağına qoyun. Ağzı yavaşca açıb bağlayın və kiçik dairələrlə masaj edin.",
      "Положите кончики пальцев перед ушами, на челюстной сустав. Медленно открывайте и закрывайте рот, массируя маленькими кругами.",
      "Place your fingertips in front of your ears, on the jaw joint. Slowly open and close your mouth while massaging in small circles.",
    ],
    ["Ağrı olarsa dayandırın.", "При боли остановитесь.", "Stop if it hurts."],
    ["fy-jaw-release-1.png", "fy-jaw-release-2.png"],
  ],
  'fy_neck_kiss': [
    ["Tavana öpüş", "Поцелуй потолку", "Kiss the ceiling"],
    [
      "Dik oturun, başı yavaşca geri əyib tavana baxın. Dodaqları öpüş kimi irəli uzadın, sonra başı yavaşca düzəldin.",
      "Сядьте прямо, медленно отклоните голову назад и посмотрите в потолок. Вытяните губы вперёд, как для поцелуя, затем медленно вернитесь.",
      "Sit tall, slowly tilt your head back and look at the ceiling. Push your lips forward as if for a kiss, then slowly bring your head back.",
    ],
    [
      "Boyun problemi varsa, başı çox geri əyməyin.",
      "При проблемах с шеей не отклоняйте голову сильно назад.",
      "If you have neck problems, don't tilt your head far back.",
    ],
    ["fy-neck-kiss-1.png", "fy-neck-kiss-2.png"],
  ],
  'fy_vowels': [
    ["Saitlər", "Гласные", "Vowels"],
    [
      "A, E, İ, O, U saitlərini səssiz və şişirdilmiş şəkildə tələffüz edin. Hər birində 2 san dayanın.",
      "Беззвучно и преувеличенно проговаривайте гласные А, Э, И, О, У. На каждой задержитесь на 2 секунды.",
      "Silently mouth the vowels A, E, I, O, U, exaggerating each one. Hold each for 2 seconds.",
    ],
    ["", "", ""],
    ["fy-vowels-1.png", "fy-vowels-2.png"],
  ],
  'fy_lion_face': [
    ["Aslan üzü", "Лицо льва", "Lion face"],
    [
      "Dərin nəfəs alın. Nəfəs verərkən ağzı geniş açın, dili çənəyə doğru çıxarın, gözləri geniş açıb yuxarı baxın.",
      "Глубоко вдохните. На выдохе широко откройте рот, вытяните язык к подбородку, широко откройте глаза и посмотрите вверх.",
      "Take a deep breath. As you breathe out, open your mouth wide, stretch your tongue towards your chin, open your eyes wide and look up.",
    ],
    ["", "", ""],
    ["fy-lion-face-1.png", "fy-lion-face-2.png"],
  ],
  'fy_temple_circles': [
    ["Gicgah masajı", "Массаж висков", "Temple circles"],
    [
      "Barmaq uclarını gicgahlara qoyun və yavaş dairələrlə masaj edin. Gözləri yumun, çiyinləri boşaldın.",
      "Положите кончики пальцев на виски и массируйте медленными кругами. Закройте глаза, расслабьте плечи.",
      "Place your fingertips on your temples and massage in slow circles. Close your eyes and relax your shoulders.",
    ],
    ["", "", ""],
    ["fy-temple-circles-1.png", "fy-temple-circles-2.png"],
  ],
  'fy_smile_lines': [
    ["Ağız ətrafı xətləri", "Линии вокруг рта", "Smile lines"],
    [
      "Şəhadət barmaqlarını ağzın künclərinə qoyun. Dodaqlar bağlı, ağzın künclərini yuxarı və yana qaldırın, barmaqlar yüngül müqavimət versin.",
      "Положите указательные пальцы на уголки рта. С сомкнутыми губами поднимайте уголки вверх и в стороны, пальцы слегка сопротивляются.",
      "Place your index fingers at the corners of your mouth. With your lips closed, lift the corners up and out while your fingers push back gently.",
    ],
    ["", "", ""],
    ["fy-smile-lines-1.png", "fy-smile-lines-2.png"],
  ],
  // Yoga poses (2026-11-23). DRAFT, not reviewed by a yoga teacher.
  'yoga_mountain': [
    ["Dağ duruşu", "Поза горы", "Mountain pose"],
    [
      "Ayaqları omba genişliyində qoyub dik dayan. Ağırlığı hər iki ayağa bərabər payla, çiyinləri boşalt, başın tacını yuxarı uzat. Sakit nəfəs al.",
      "Встань прямо, стопы на ширине бёдер. Распредели вес на обе стопы, расслабь плечи, тянись макушкой вверх. Дыши спокойно.",
      "Stand tall with feet hip-width apart. Spread your weight evenly, relax your shoulders and lengthen through the crown of your head. Breathe calmly.",
    ],
    ["", "", ""],
    ["yoga-mountain-1.png", "yoga-mountain-2.png"],
  ],
  'yoga_arms_up': [
    ["Əllər yuxarı", "Руки вверх", "Arms up"],
    [
      "Nəfəs alarkən qolları yanlardan yuxarı qaldır, nəfəs verərkən endir. Hərəkəti nəfəslə birləşdir, çiyinləri qulaqlardan uzaq saxla.",
      "На вдохе поднимай руки через стороны вверх, на выдохе опускай. Соединяй движение с дыханием, плечи держи подальше от ушей.",
      "Breathing in, sweep your arms up through the sides; breathing out, lower them. Move with your breath and keep your shoulders away from your ears.",
    ],
    [
      "Çiyin ağrısında qolları yalnız ağrısız hündürlüyə qədər qaldır.",
      "При боли в плече поднимай руки только до безболезненной высоты.",
      "With shoulder pain, lift only as high as is pain-free.",
    ],
    ["yoga-arms-up-1.png", "yoga-arms-up-2.png"],
  ],
  'yoga_forward_fold': [
    ["Ayaq üstə önə əyilmə", "Наклон вперёд стоя", "Standing forward fold"],
    [
      "Dizləri yüngül bük, ombadan önə əyil. Baş və boyun boş sallansın, əllər baldırlara və ya yerə toxunsun. Nəfəs verərkən bir az da rahatlaş.",
      "Слегка согни колени и наклонись вперёд от тазобедренных суставов. Голова и шея свободно свисают, руки на голенях или на полу. На выдохе расслабляйся чуть больше.",
      "Bend your knees softly and fold forward from your hips. Let your head and neck hang, hands on your shins or the floor. Relax a little more as you breathe out.",
    ],
    [
      "Bel ağrısında və ya başgicəllənmədə dizləri daha çox bük və yavaş qalx.",
      "При боли в пояснице или головокружении сильнее сгибай колени и поднимайся медленно.",
      "With back pain or dizziness, bend your knees more and come up slowly.",
    ],
    ["yoga-forward-fold-1.png", "yoga-forward-fold-2.png"],
  ],
  'yoga_low_lunge': [
    ["Alçaq hamla", "Низкий выпад", "Low lunge"],
    [
      "Bir ayağı önə at, arxa dizi döşəkçəyə qoy. Ön diz topuğun üstündə olsun. Ombanı yüngül önə ver, qolları yuxarı və ya ön budun üstünə qoy. Hər tərəfdə et.",
      "Шагни одной ногой вперёд, заднее колено опусти на коврик. Переднее колено над пяткой. Слегка подай таз вперёд, руки вверх или на переднее бедро. Сделай на каждую сторону.",
      "Step one foot forward and lower your back knee to the mat. Keep the front knee over the ankle. Ease your hips forward, arms up or on your front thigh. Do both sides.",
    ],
    [
      "Diz ağrısında arxa dizin altına qatlanmış dəsmal qoy.",
      "При боли в колене подложи под заднее колено сложенное полотенце.",
      "If your knee hurts, put a folded towel under the back knee.",
    ],
    ["yoga-low-lunge-1.png", "yoga-low-lunge-2.png"],
  ],
  'yoga_down_dog': [
    ["Aşağı baxan it", "Собака мордой вниз", "Downward dog"],
    [
      "Dörd ayaq üstündən ombanı yuxarı və geri qaldır, bədən tərs V olsun. Dizlər yüngül bükülü ola bilər, dabanlar yerə doğru uzansın. Əlləri yerə bərabər bas.",
      "Из положения на четвереньках подними таз вверх и назад, тело в форме перевёрнутой V. Колени можно слегка согнуть, пятки тянутся к полу. Равномерно дави ладонями в пол.",
      "From hands and knees, lift your hips up and back into an upside-down V. Knees may stay a little bent, heels reaching towards the floor. Press evenly through your hands.",
    ],
    [
      "Bilək və ya çiyin ağrısında, yüksək qan təzyiqində və ya hamiləlikdə etmə; uşaq duruşu ilə əvəz et.",
      "При боли в запястьях или плечах, высоком давлении или беременности не делай; замени позой ребёнка.",
      "Skip with wrist or shoulder pain, high blood pressure or pregnancy; use child's pose instead.",
    ],
    ["yoga-down-dog-1.png", "yoga-down-dog-2.png"],
  ],
  'yoga_cobra': [
    ["Kobra", "Кобра", "Cobra"],
    [
      "Qarnı üstə uzan, əllər çiyinlərin altında. Nəfəs alarkən sinəni bir az qaldır, dirsəklər bükülü və bədənə yaxın qalsın. Belini sıxma, nəfəs verərkən en.",
      "Ляг на живот, ладони под плечами. На вдохе слегка приподними грудь, локти согнуты и прижаты к телу. Не зажимай поясницу, на выдохе опустись.",
      "Lie on your front with hands under your shoulders. Breathing in, lift your chest a little, elbows bent and close to your body. Don't squeeze your lower back; lower as you breathe out.",
    ],
    [
      "Hamiləlikdə və bel ağrısında etmə.",
      "Не делай при беременности и боли в пояснице.",
      "Skip during pregnancy or with lower back pain.",
    ],
    ["yoga-cobra-1.png", "yoga-cobra-2.png"],
  ],
  'yoga_warrior2': [
    ["Döyüşçü II", "Воин II", "Warrior II"],
    [
      "Ayaqları geniş aç, ön ayaq önə, arxa ayaq bir az içəri. Ön dizi topuğun üstündə bük, qolları yerə paralel yanlara aç, ön əlin üzərindən bax. Hər tərəfdə et.",
      "Широко расставь ноги, передняя стопа вперёд, задняя чуть внутрь. Согни переднее колено над пяткой, руки разведи в стороны параллельно полу, смотри поверх передней руки. Сделай на каждую сторону.",
      "Step your feet wide, front foot forward, back foot turned slightly in. Bend the front knee over the ankle, stretch your arms out parallel to the floor and look past your front hand. Do both sides.",
    ],
    [
      "Ön diz ayaq barmaqlarından önə keçməsin.",
      "Переднее колено не выходит за носок.",
      "Don't let the front knee go past your toes.",
    ],
    ["yoga-warrior2-1.png", "yoga-warrior2-2.png"],
  ],
  'yoga_tree': [
    ["Ağac duruşu", "Поза дерева", "Tree pose"],
    [
      "Bir ayağın üstündə dur, digər ayağın tabanını baldıra və ya buda qoy (dizə yox). Əlləri sinə önündə birləşdir, gözü bir nöqtəyə dik. Hər tərəfdə et.",
      "Встань на одну ногу, стопу другой поставь на голень или бедро (не на колено). Ладони сложи перед грудью, взгляд на одну точку. Сделай на каждую сторону.",
      "Stand on one leg and place the other foot on your calf or thigh (not the knee). Bring your palms together in front of your chest and fix your gaze on one point. Do both sides.",
    ],
    [
      "Tarazlıq çətin olarsa, divara və ya stula toxun.",
      "Если трудно держать равновесие, держись за стену или стул.",
      "Hold a wall or chair if balancing is hard.",
    ],
    ["yoga-tree-1.png", "yoga-tree-2.png"],
  ],
  'yoga_triangle': [
    ["Üçbucaq", "Треугольник", "Triangle"],
    [
      "Ayaqları geniş aç, ön ayaq önə. Qolları yanlara aç, ön ombadan yana əyil, ön əli baldıra və ya dizə, arxa əli yuxarı qaldır. Hər iki böyrü uzun saxla. Hər tərəfdə et.",
      "Широко расставь ноги, передняя стопа вперёд. Разведи руки, наклонись в сторону от переднего бедра, передняя рука на голень или колено, задняя вверх. Держи оба бока длинными. Сделай на каждую сторону.",
      "Step your feet wide, front foot forward. Open your arms, hinge sideways from the front hip, front hand on your shin or knee, other arm up. Keep both sides of your waist long. Do both sides.",
    ],
    [
      "Diz kilidlənməsin; boyun narahatdırsa, aşağı bax.",
      "Не блокируй колено; если неудобно шее, смотри вниз.",
      "Don't lock your knee; look down if your neck feels strained.",
    ],
    ["yoga-triangle-1.png", "yoga-triangle-2.png"],
  ],
  'yoga_seated_twist': [
    ["Oturaraq burulma", "Скрутка сидя", "Seated twist"],
    [
      "Ayaqları çarpaz otur, onurğanı uzat. Nəfəs verərkən gövdəni yavaşca sağa burax, sol əl sağ dizə, sağ əl arxaya. Nəfəs alarkən uzan, sonra digər tərəfə.",
      "Сядь со скрещёнными ногами, вытяни позвоночник. На выдохе мягко повернись вправо: левая рука на правое колено, правая сзади. На вдохе вытягивайся, затем в другую сторону.",
      "Sit cross-legged and lengthen your spine. Breathing out, gently turn to the right, left hand on your right knee, right hand behind you. Lengthen as you breathe in, then switch sides.",
    ],
    [
      "Hamiləlikdə yalnız yüngül, açıq burulma et; bel ağrısında dərin burulma etmə.",
      "При беременности только лёгкая открытая скрутка; при боли в пояснице без глубоких скруток.",
      "During pregnancy keep the twist light and open; with back pain, avoid deep twists.",
    ],
    ["yoga-seated-twist-1.png", "yoga-seated-twist-2.png"],
  ],
  'yoga_reclined_twist': [
    ["Uzanaraq burulma", "Скрутка лёжа", "Reclined twist"],
    [
      "Arxası üstə uzan, dizləri sinəyə çək. Qolları yanlara aç, dizləri yavaşca bir tərəfə endir, başı əks tərəfə çevir. Çiyinlər yerdə qalsın. Hər tərəfdə et.",
      "Ляг на спину, подтяни колени к груди. Разведи руки, медленно опусти колени в одну сторону, голову поверни в другую. Плечи остаются на полу. Сделай на каждую сторону.",
      "Lie on your back and draw your knees in. Open your arms, slowly lower your knees to one side and turn your head the other way. Keep your shoulders down. Do both sides.",
    ],
    [
      "Hamiləlikdə arxası üstə uzun qalma; həkimlə məsləhətləş.",
      "При беременности не лежи долго на спине; посоветуйся с врачом.",
      "During pregnancy, don't stay long on your back; ask your doctor.",
    ],
    ["yoga-reclined-twist-1.png", "yoga-reclined-twist-2.png"],
  ],
  'yoga_savasana': [
    ["Dincəlmə", "Шавасана", "Rest (savasana)"],
    [
      "Arxası üstə uzan, qollar yanda, ovuclar yuxarı. Gözləri yum, bədəni yerə burax və nəfəsi izlə. Hərəkət etmə, sadəcə dincəl.",
      "Ляг на спину, руки вдоль тела ладонями вверх. Закрой глаза, отпусти тело на пол и наблюдай за дыханием. Не двигайся, просто отдыхай.",
      "Lie on your back, arms by your sides, palms up. Close your eyes, let your body sink into the floor and watch your breath. Stay still and rest.",
    ],
    [
      "Hamiləlikdə sol yanı üstə uzan.",
      "При беременности ложись на левый бок.",
      "During pregnancy, lie on your left side.",
    ],
    ["yoga-savasana-1.png", "yoga-savasana-2.png"],
  ],
};
