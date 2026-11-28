"""Parla store screenshots (App Store 6.9", Google Play phone, Play feature
graphic) from the app's real screens. Layout follows the ASO skill
(adamlyttleapps/claude-skill-aso-appstore-screenshots, MIT): one benefit
per shot, big verb + smaller descriptor on top, phone high and bleeding
off the bottom, one solid brand colour. Text is Espresso on Parla Sun
(brand rule: never white on yellow). No AI retouching: the screens are
exactly what the app shows.

Run (after rendering the screens):

    python3 -I tools/store_screenshots/compose.py [codes...]

Output: tools/store_screenshots/out/<code>/{appstore-6.9,googleplay}/ (not
committed). The headlines (texts.json) need a native speaker's check."""
import json
import os
import pathlib
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

HERE = pathlib.Path(__file__).parent
ROOT = HERE.parents[1]
FONTS = ROOT / 'parla_flutter/assets/fonts'
# The app's screens at 3x, per language: <SCREENS>/<code>/<name>.png, made
# by parla_flutter/test/screens_preview_test.dart with PREVIEW_SCALE=3.
SCREENS = pathlib.Path(os.environ.get('STORE_SCREENS', '/tmp/store'))
SUN = (255, 206, 0)
INK = (22, 19, 15)
SHOTS = ['01_home', '15_quiz', '10_check', '05_sport_2', '03_discover', '08_privacy']
TEXTS = json.loads((HERE / 'texts.json').read_text(encoding='utf-8'))


def font(lang, weight, size):
    if lang == 'ka':
        name = {'black': 'NotoSansGeorgian-Bold.ttf', 'bold': 'NotoSansGeorgian-SemiBold.ttf'}[weight]
    else:
        name = {'black': 'Onest-ExtraBold.ttf', 'bold': 'Onest-SemiBold.ttf'}[weight]
    return ImageFont.truetype(str(FONTS / name), size)


def wrap(draw, text, f, max_w):
    words, lines, cur = text.split(), [], ''
    for w in words:
        t = (cur + ' ' + w).strip()
        if draw.textlength(t, font=f) <= max_w or not cur:
            cur = t
        else:
            lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)
    return lines


def rounded(img, r):
    m = Image.new('L', img.size, 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, img.width - 1, img.height - 1), r, fill=255)
    out = Image.new('RGBA', img.size, (0, 0, 0, 0))
    out.paste(img, (0, 0), m)
    return out


def with_status_bar(screen):
    """The screen with an iPhone status bar on top (9:41, signal, battery),
    on the colour of the screen's top edge, so the island hides nothing."""
    s = screen.convert('RGB')
    band = int(s.width * 0.135)
    top = s.crop((0, 0, s.width, 6)).resize((1, 1), Image.BOX).getpixel((0, 0))
    out = Image.new('RGB', (s.width, s.height + band), top)
    out.paste(s, (0, band))
    d = ImageDraw.Draw(out)
    u = s.width / 390
    f = ImageFont.truetype(str(FONTS / 'Onest-SemiBold.ttf'), int(17 * u))
    cy = int(band * 0.52)
    d.text((int(52 * u), cy), '9:41', font=f, fill=INK, anchor='mm')
    x = s.width - int(36 * u)
    d.rounded_rectangle((x - int(25 * u), cy - int(6 * u), x, cy + int(6 * u)), int(3 * u), outline=INK, width=max(2, int(1.2 * u)))
    d.rounded_rectangle((x - int(23 * u), cy - int(4 * u), x - int(4 * u), cy + int(4 * u)), int(2 * u), fill=INK)
    for k in range(4):
        bx = x - int(60 * u) + k * int(5 * u)
        d.rectangle((bx, cy + int(5 * u) - int((k + 1) * 2.6 * u), bx + int(3 * u), cy + int(5 * u)), fill=INK)
    return out.crop((0, 0, s.width, s.height))


def device(screen, width):
    """A plain modern phone: black bezel, rounded screen, dynamic island."""
    screen = with_status_bar(screen)
    sw = int(width * 0.94)
    scr = screen.convert('RGB').resize((sw, int(screen.height * sw / screen.width)), Image.LANCZOS)
    bez = (width - sw) // 2
    h = scr.height + 2 * bez
    body = Image.new('RGBA', (width, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(body)
    d.rounded_rectangle((0, 0, width - 1, h - 1), int(width * 0.135), fill=(12, 11, 10, 255))
    d.rounded_rectangle((3, 3, width - 4, h - 4), int(width * 0.13), outline=(70, 66, 62, 255), width=3)
    body.alpha_composite(rounded(scr.convert('RGBA'), int(sw * 0.115)), (bez, bez))
    iw, ih = int(width * 0.27), int(width * 0.078)
    d.rounded_rectangle(((width - iw) // 2, bez + int(width * 0.03), (width + iw) // 2, bez + int(width * 0.03) + ih), ih // 2, fill=(0, 0, 0, 255))
    return body


def smile(width, thick, color=INK):
    """The brand's smile curve: thick in the middle, sharp ends."""
    W, H = width * 4, int(width * 0.32) * 4
    im = Image.new('L', (W, H), 0)
    d = ImageDraw.Draw(im)
    d.ellipse((0, -H, W, H), fill=255)
    d.ellipse((int(W * 0.04), -H - thick * 4, W - int(W * 0.04), H - thick * 4), fill=0)
    im = im.resize((width, H // 4), Image.LANCZOS)
    out = Image.new('RGBA', im.size, color + (0,))
    out.putalpha(im)
    return out


def shot(lang, i, W, H):
    t = TEXTS[lang]['shots'][i]
    canvas = Image.new('RGB', (W, H), SUN)
    d = ImageDraw.Draw(canvas)
    pad = int(W * 0.09)
    max_w = W - 2 * pad
    size = int(W * 0.135)
    while True:
        fv = font(lang, 'black', size)
        if d.textlength(t['verb'], font=fv) <= max_w or size < 40:
            break
        size -= 4
    fd = font(lang, 'bold', int(W * 0.056))
    y = int(H * 0.055)
    d.text((W / 2, y), t['verb'], font=fv, fill=INK, anchor='mt')
    vb = d.textbbox((W / 2, y), t['verb'], font=fv, anchor='mt')
    sm = smile(int(min(vb[2] - vb[0], W * 0.42) * 0.62), max(6, int(W * 0.011)))
    canvas.paste(sm, (int(W / 2 - sm.width / 2), vb[3] + int(W * 0.012)), sm)
    y = vb[3] + int(W * 0.012) + sm.height + int(W * 0.025)
    for line in wrap(d, t['desc'], fd, max_w):
        d.text((W / 2, y), line, font=fd, fill=INK, anchor='mt')
        y = d.textbbox((W / 2, y), line, font=fd, anchor='mt')[3] + int(W * 0.012)
    screen = Image.open(SCREENS / lang / f'{SHOTS[i]}.png')
    dev = device(screen, int(W * 0.84))
    # The same place on every shot (descriptors take at most two lines).
    top = int(W * 0.60)
    shadow = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(((W - dev.width) // 2 + 10, top + 30, (W + dev.width) // 2 - 10, top + dev.height), int(dev.width * 0.13), fill=(120, 80, 0, 90))
    shadow = shadow.filter(ImageFilter.GaussianBlur(40))
    canvas = Image.alpha_composite(canvas.convert('RGBA'), shadow)
    canvas.alpha_composite(dev, ((W - dev.width) // 2, top))
    return canvas.convert('RGB')


def feature(lang):
    W, H = 1024, 500
    c = Image.new('RGB', (W, H), SUN)
    wm = Image.open(HERE / 'wordmark_espresso.png')
    wm = wm.resize((360, int(wm.height * 360 / wm.width)), Image.LANCZOS)
    c.paste(wm, (70, 120), wm)
    d = ImageDraw.Draw(c)
    slogan = TEXTS[lang]['slogan']
    f = ImageFont.truetype(str(FONTS / ('NotoSansGeorgian-Medium.ttf' if lang == 'ka' else 'PlayfairDisplay-MediumItalic.ttf')), 44)
    while d.textlength(slogan, font=f) > 420:
        f = ImageFont.truetype(f.path, f.size - 2)
    d.text((72, 120 + wm.height + 34), slogan, font=f, fill=INK)
    dev = device(Image.open(SCREENS / lang / '01_home.png'), 300)
    c = c.convert('RGBA')
    c.alpha_composite(dev, (640, 60))
    return c.convert('RGB')


def main():
    langs = sys.argv[1:] or list(TEXTS)
    out = HERE / 'out'
    for lang in langs:
        for i in range(len(SHOTS)):
            for name, (W, H) in {'appstore-6.9': (1320, 2868), 'googleplay': (1080, 1920)}.items():
                p = out / lang / name / f'{i + 1:02d}.png'
                p.parent.mkdir(parents=True, exist_ok=True)
                shot(lang, i, W, H).save(p, optimize=True)
        p = out / lang / 'googleplay' / 'feature-graphic.png'
        feature(lang).save(p, optimize=True)
        print(lang, 'done')


if __name__ == '__main__':
    main()
