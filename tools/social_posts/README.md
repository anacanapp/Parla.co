# Parla — sosial media post şablonları

30 Instagram/Threads postunun (1080×1350) şablonları, mətnləri və fotoları.

## Quruluş

| Fayl | Nədir |
| --- | --- |
| `posts.json` | 30 postun bütün slaydları: kompozisiya (`t`), mətn, foto |
| `render.js` | HTML şablonları → PNG (Playwright + Chromium) |
| `assets/post.css` | Bütün kompozisiyaların dizaynı (rənglər, şriftlər, şüşə panellər) |
| `assets/` | Söz loqosu, Smile nişan, işıq fonu, 4 tətbiq ekranı. Şriftlər `parla_flutter/assets/fonts`-dan oxunur |
| `photos/` | Süni intellektlə yaradılmış fotolar (Runware) |
| `photos.json` | Hər fotonun promptu və ölçüsü |
| `gen.py` | Yeni foto yaratmaq: `python3 gen.py photos.json <id>` (`RunWare_API_Key` mühit dəyişəni lazımdır) |
| `facecheck.py` | Mətnin insan üzünü örtmədiyini yoxlayır |
| `docgen.py` | `posts.json`-dan slayd təsvirlərini mətn kimi çıxarır |

## İşə salmaq

```bash
cd tools/social_posts
npm i playwright && npx playwright install chromium
node render.js posts.json            # bütün postlar → out/<id>/<nn>.png
node render.js posts.json 05 12      # yalnız 05 və 12
CHECK=1 node render.js posts.json && pip install "opencv-python-headless<5" && python3 facecheck.py
```

## Kompozisiyalar (`t`)

| Kod | Ad | Əsas sahələr |
| --- | --- | --- |
| P1 | Foto başlıq | `photo`, `tt`, `lead`, `pills`, `bottom`, `serSize` |
| P2 | Şüşə siyahı | `photo`, `tt`, `head`, `rows` (`+` = edilən, `-` = edilməyən), `panelTop` |
| P3 | Belə / Belə yox | `photo`, `tt`, `items` [[yox, belə], …] |
| P4 | Yarı foto | `photo`, `tt`, `pills` |
| P5 | Kollaj | `lines` [{p:[{cap},{ser},{pill},{img},{small}]}], `pills` |
| P6 | Məsləhət kartı | `photo`, `head`, `q`, `p`, `cardTop`, `dark` |
| P7 | Plitələr | `photo`, `tt`, `tiles` [[söz, izah]], `cols2` |
| P8 | İşıq dairəsi | `quote` və ya `word`, `corners` |
| P9 | Qövs | `photo`, `tt`, `steps` [[ad, izah]] |
| P10 | Şüşə sətirlər | `photo`, `tt`, `rows` [[ad, izah]] |
| T3v | Mif | `photo`, `myth`, `truth` |
| T5 | Gecə sitatı | `photo`, `quote`, `sub`, `qTop`, `shade` |
| T2 | Kart | `num`, `h`, `p`, `list`, `tags` |
| T6 | Tətbiq ekranı | `verb`, `desc`, `screen` (assets-də PNG adı) |
| T7 | Son slayd | `h`, `p` |
| POLL | Sorğu | `q`, `left`/`right` {photo, label} |

`tt` sətirləri: adi sətir Onest böyük hərflə, `_sətir_` Playfair italik. Mətndə `*söz*` Playfair + Smile, `**söz**` qalın.
Postun işığı `kick`-dən gəlir: Rutin → Gül, Tərkib → Yasəmən, Bədən/Qidalanma → Səma, Brend → dörd işıq (`theme` ilə dəyişmək olar).

## Qaydalar

- Mətn və panel insan üzünü örtmür (`facecheck.py` + göz yoxlaması).
- Sarı yalnız vurğudur; sarı üzərində mətn tünd.
- Fotolar süni intellektlədir: Instagram-da “AI info” etiketi. Post 20-nin örtük fotosu ekspertin real fotosu ilə əvəz olunmalıdır.
- Şriftlər SIL Open Font License altındadır (`parla_flutter/assets/fonts/OFL-*.txt`).
- Hazır şəkillər (`out/`) repoya düşmür: `node render.js posts.json` onları eyni çıxarır.
