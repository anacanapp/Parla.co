"""Builds parla_server/lib/src/content/blog_seed.dart from the blog docs.

The docs are the team's Google Docs in the Drive folder "Parla Bloq",
exported as Markdown (one file per article, any file names). Run:

    python3 -I tools/blog_import/build_blog_seed.py <folder-with-md-files>

or, to apply only the wording fixes and the translations in
tools/content_i18n to the current output (no export):

    python3 -I tools/blog_import/build_blog_seed.py --apply-fixes

Each doc has a field table (id, kateqoriya, oxuma_dəq, ...), an SEO table
(title, meta description per language), the sections "mətn_az", "mətn_ru",
"mətn_en" and "Mənbələr". The output is Dart source; nothing is published:
the admin panel imports every article as a draft that needs expert review.
"""

import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/content_i18n'))
import merge  # noqa: E402
OUT = ROOT / 'parla_server/lib/src/content/blog_seed.dart'
OLD_SEED = ROOT / 'parla_server/lib/src/content/content_seed.dart'
FIXES = ROOT / 'parla_server/lib/src/content/wording_fixes.dart'

# The sheet's categories to the app's (ContentRules.articleCategories).
CATEGORIES = {
    'qulluq': 'care',
    'bədən': 'body',
    'saç': 'hair',
    'makiyaj': 'beauty',
    'dırnaq': 'beauty',
    'moda': 'fashion',
    'xəbər': 'care',
    'trend': 'care',
}

MAX_BODY = 12000
MAX_SUMMARY = 300
MAX_TITLE = 120


def unbold(s):
    s = s.strip()
    m = re.fullmatch(r'\*\*(.+)\*\*', s)
    return m.group(1).strip() if m else s


def unescape(s):
    return re.sub(r'\\([-.+!&)=~_*])', r'\1', s)


def unescape_text(line):
    """Drops Google's Markdown escapes that only matter at a line start."""
    return re.sub(r'(?<=\S)(\s*)\\([-.+!&)=~_])', r'\1\2', line)


def cells(line):
    return [unescape(c.strip()) for c in line.strip().strip('|').split('|')]


def old_titles():
    """ru/en titles of the articles already in the first seed."""
    out = {}
    text = OLD_SEED.read_text(encoding='utf-8')
    for m in re.finditer(r"SeedContent\(\s*'article',\s*'([^']+)',\s*'[^']+',\s*'(.*?)',\s*\)", text, re.S):
        raw = m.group(2).replace("\\'", "'").replace('\\$', '$').replace('\\\\', '\\')
        out[m.group(1)] = json.loads(raw)['title']
    return out


def body(lines):
    out = []
    for line in lines:
        line = line.rstrip('\n')
        hard_break = line.endswith('  ')
        line = line.rstrip()
        m = re.match(r'^(#{2,4})\s+(.*)$', line)
        if m:
            line = '## ' + re.sub(r'\\([-.+!&)=~_])', r'\1', unbold(m.group(2)))
            out += ['', line, '']
            continue
        if line.startswith('> '):
            line = line[2:]
            if line.startswith('* '):
                line = '- ' + line[2:]
        elif line.startswith('* '):
            line = '- ' + line[2:]
        out.append(unescape_text(line))
        if hard_break:
            out.append('')
    text = '\n'.join(out)
    text = re.sub(r'\n{3,}', '\n\n', text).strip()
    return text


def parse(path, titles):
    lines = path.read_text(encoding='utf-8').splitlines()
    fields, seo, sections, current = {}, {}, {}, None
    h1 = None
    for line in lines:
        if line.startswith('# '):
            name = unescape(unbold(line[2:])).strip().lower()
            if h1 is None:
                h1 = unescape(unbold(line[2:]))
                continue
            current = name
            sections[current] = []
            continue
        if current is None:
            if line.startswith('|'):
                c = cells(line)
                if len(c) >= 2 and c[0] not in ('Sahə', 'Dil') and not set(c[0]) <= set(':- '):
                    if c[0] in ('AZ', 'RU', 'EN') and len(c) >= 4:
                        seo[c[0].lower()] = {'title': c[1], 'description': c[2]}
                    else:
                        fields[c[0]] = c[1]
            continue
        sections[current].append(line)

    slug = fields['id']
    title_az = re.sub(r'\s*\(' + re.escape(slug) + r'\)\s*$', '', h1).strip()
    old = titles.get(slug, {})
    title = {
        'az': title_az,
        'ru': old.get('ru') or seo['ru']['title'],
        'en': old.get('en') or seo['en']['title'],
    }
    summary = {lang: seo[lang]['description'] for lang in ('az', 'ru', 'en')}
    bodies = {lang: body(sections['mətn_' + lang]) for lang in ('az', 'ru', 'en')}
    links = re.findall(r'\]\((https://[^)\s]+)\)', '\n'.join(sections.get('mənbələr', [])))
    sources = list(dict.fromkeys(links))[:10]
    category = CATEGORIES[fields['kateqoriya'].strip().lower()]
    data = {
        'title': title,
        'summary': summary,
        'body': bodies,
        'minutes': int(re.sub(r'\D', '', fields['oxuma_dəq'])),
        'sources': sources,
    }
    problems = []
    for lang in ('az', 'ru', 'en'):
        if len(title[lang]) > MAX_TITLE:
            problems.append(f'title.{lang} {len(title[lang])}')
        if len(summary[lang]) > MAX_SUMMARY:
            problems.append(f'summary.{lang} {len(summary[lang])}')
        if len(bodies[lang]) > MAX_BODY:
            problems.append(f'body.{lang} {len(bodies[lang])}')
    return slug, category, data, problems


def wording_fixes():
    """The (slug, lang, from, to) entries of `wordingFixes` in wording_fixes.dart."""
    src = FIXES.read_text(encoding='utf-8')
    body = src[src.index('const wordingFixes'):]
    body = body[:body.index('];')]
    q = r"'([^'\\]*)'"
    return re.findall(r'\(\s*' + r',\s*'.join([q] * 4) + r',?\s*\)', body)


def apply_fixes(slug, data, fixes):
    """[data] with the wording fixes of [slug] applied to its texts."""
    mine = [f for f in fixes if f[0] == slug]

    def fix(value):
        if isinstance(value, list):
            return [fix(v) for v in value]
        if not isinstance(value, dict):
            return value
        out = {}
        for key, v in value.items():
            if isinstance(v, str):
                for _, lang, old, new in mine:
                    if lang == key:
                        v = v.replace(old, new)
                out[key] = v
            else:
                out[key] = fix(v)
        return out

    return {k: fix(v) for k, v in data.items()}


def dart_string(s):
    return "'" + s.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$') + "'"


def write(items):
    out = [
        '// GENERATED by tools/blog_import/build_blog_seed.py from the blog docs',
        '// (Drive folder "Parla Bloq"). Do not edit by hand; regenerate instead.',
        '',
        "part of 'content_seed_import.dart';",
        '',
        '/// The full blog articles (az, ru, en), imported as drafts. They replace',
        "/// the writing plans of the first sheet's articles while those are untouched.",
        'const blogSeed = <SeedContent>[',
    ]
    fixes = wording_fixes()
    for slug, category, data in items:
        data = merge.article(slug, apply_fixes(slug, data, fixes))
        out += [
            '  SeedContent(',
            "    'article',",
            f"    '{slug}',",
            f"    '{category}',",
            '    ' + dart_string(json.dumps(data, ensure_ascii=False)) + ',',
            '  ),',
        ]
    out.append('];')
    OUT.write_text('\n'.join(out) + '\n', encoding='utf-8')
    print(f'{len(items)} articles written to {OUT.relative_to(ROOT)}')


def current_items():
    """The articles in the current blog_seed.dart."""
    src = OUT.read_text(encoding='utf-8')
    found = re.findall(
        r"SeedContent\(\s*'article',\s*'([^']+)',\s*'([^']+)',\s*'((?:[^'\\]|\\.)*)',",
        src,
    )
    items = []
    for slug, category, raw in found:
        text = re.sub(r'\\(.)', r'\1', raw)
        items.append((slug, category, json.loads(text)))
    return items


def main():
    if sys.argv[1:] == ['--apply-fixes']:
        write(current_items())
        return
    folder = pathlib.Path(sys.argv[1])
    titles = old_titles()
    items, failed = [], False
    for path in sorted(folder.glob('*.md')):
        slug, category, data, problems = parse(path, titles)
        if problems:
            failed = True
            print(slug, 'PROBLEMS', problems)
        items.append((slug, category, data))
    items.sort(key=lambda i: i[0])
    slugs = [i[0] for i in items]
    if len(set(slugs)) != len(slugs):
        sys.exit('duplicate slugs: ' + ', '.join(s for s in slugs if slugs.count(s) > 1))
    if failed:
        sys.exit(1)
    write(items)


if __name__ == '__main__':
    main()
