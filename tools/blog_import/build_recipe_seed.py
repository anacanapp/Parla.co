"""Builds parla_server/lib/src/content/recipe_seed.dart from the recipe sheet.

The sheet is "Parla — Reseptlər (genişləndirilmiş)" in the Drive folder
"Parla Bloq", exported as CSV. Run:

    python3 -I tools/blog_import/build_recipe_seed.py <sheet.csv>

Nothing is published: the admin panel imports every recipe as a draft.
"""

import csv
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / 'parla_server/lib/src/content/recipe_seed.dart'

# Meal of the sheet to the app's (ContentRules.recipeMeals). The app has no
# dessert meal; desserts are shown with the snacks.
MEALS = {
    'səhər': 'breakfast',
    'nahar': 'lunch',
    'şam': 'dinner',
    'qəlyanaltı': 'snack',
    'desert': 'snack',
}

# Plate groups (ContentRules.plateGroups). Sweets have no plate group.
GROUPS = {
    'tərəvəz': 'vegetables',
    'meyvə': 'fruit',
    'zülal': 'protein',
    'paxlalı': 'protein',
    'balıq': 'protein',
    'tam taxıl': 'whole_grain',
    'sağlam yağ': 'healthy_fat',
    'süd məhsulu': 'dairy',
    'şirniyyat (arabir)': None,
}

# The EU's 14 allergens (ContentRules.recipeAllergens), by the sheet's word.
ALLERGENS = {
    'süd': 'milk',
    'qlüten': 'gluten',
    'yumurta': 'egg',
    'qoz': 'nuts',
    'balıq': 'fish',
    'küncüt': 'sesame',
    'yerfındığı': 'peanuts',
    'xardal': 'mustard',
    'kərəviz': 'celery',
    'xərçəngkimilər': 'crustaceans',
    'soya': 'soy',
    'sulfit': 'sulphites',
    'lupin': 'lupin',
    'molyusk': 'molluscs',
}

LANGS = ('az', 'ru', 'en')

# The app's own orders, so lists compare equal to the first sheet's.
GROUP_ORDER = ['vegetables', 'fruit', 'protein', 'whole_grain', 'healthy_fat', 'dairy']
ALLERGEN_ORDER = [
    'gluten', 'crustaceans', 'egg', 'fish', 'peanuts', 'soy', 'milk',
    'nuts', 'celery', 'mustard', 'sesame', 'sulphites', 'lupin', 'molluscs',
]


def ingredients(row):
    parts = {lang: [p.strip() for p in row['tərkib_' + lang].split(';') if p.strip()] for lang in LANGS}
    counts = {len(v) for v in parts.values()}
    if len(counts) != 1:
        raise ValueError(f'ingredient counts differ: {[len(v) for v in parts.values()]}')
    out = []
    for i in range(counts.pop()):
        name, amount = {}, {}
        for lang in LANGS:
            bits = [b.strip() for b in parts[lang][i].split('|', 1)]
            name[lang] = bits[0]
            amount[lang] = bits[1] if len(bits) > 1 else ''
        item = {'name': name}
        if any(amount.values()):
            item['amount'] = amount
        out.append(item)
    return out


def steps(row):
    split = {}
    for lang in LANGS:
        text = row['hazırlanma_' + lang].strip()
        items = [s.strip() for s in re.split(r'(?:^|\s)\d{1,2}\.\s+', text) if s.strip()]
        split[lang] = items
    counts = {len(v) for v in split.values()}
    if len(counts) != 1:
        raise ValueError(f'step counts differ: {[len(v) for v in split.values()]}')
    return [{lang: split[lang][i] for lang in LANGS} for i in range(counts.pop())]


def allergens(cell):
    cell = cell.strip()
    if cell in ('—', '-', ''):
        return []
    out = []
    for part in cell.split(','):
        word = re.sub(r'\s*\(.*\)$', '', part.strip()).lower()
        if word not in ALLERGENS:
            raise ValueError(f'unknown allergen: {part}')
        if ALLERGENS[word] not in out:
            out.append(ALLERGENS[word])
    return sorted(out, key=ALLERGEN_ORDER.index)


def groups(cell):
    out = []
    for part in cell.split(','):
        word = part.strip().lower()
        if not word:
            continue
        if word not in GROUPS:
            raise ValueError(f'unknown plate group: {part}')
        g = GROUPS[word]
        if g and g not in out:
            out.append(g)
    return sorted(out, key=GROUP_ORDER.index)


def dart_string(s):
    return "'" + s.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$') + "'"


def number(cell):
    return int(re.match(r'\d+', cell.strip()).group(0))


def main():
    rows = list(csv.DictReader(open(sys.argv[1], encoding='utf-8')))
    items, failed = [], False
    for row in rows:
        slug = row['id'].strip()
        try:
            data = {
                'title': {lang: row['ad_' + lang].strip() for lang in LANGS},
                'minutes': number(row['müddət_dəq']),
                'servings': number(row['nəfər']),
                'groups': groups(row['qida_qrupları']),
                'ingredients': ingredients(row),
                'steps': steps(row),
                'allergens': allergens(row['allergenlər']),
            }
            meal = MEALS[row['yəmək_növü'].strip()]
        except (ValueError, KeyError, AttributeError) as e:
            failed = True
            print(slug, 'PROBLEM', e)
            continue
        items.append((slug, meal, data))
    slugs = [i[0] for i in items]
    if len(set(slugs)) != len(slugs):
        sys.exit('duplicate slugs')
    if failed:
        sys.exit(1)
    items.sort(key=lambda i: i[0])
    out = [
        '// GENERATED by tools/blog_import/build_recipe_seed.py from the recipe',
        '// sheet "Parla — Reseptlər (genişləndirilmiş)". Do not edit by hand.',
        '',
        "part of 'content_seed_import.dart';",
        '',
        '/// The recipes (az, ru, en), imported as drafts. They replace the first',
        "/// sheet's recipes while those drafts are untouched.",
        'const recipeSeed = <SeedContent>[',
    ]
    for slug, meal, data in items:
        out += [
            '  SeedContent(',
            "    'recipe',",
            f"    '{slug}',",
            f"    '{meal}',",
            '    ' + dart_string(json.dumps(data, ensure_ascii=False)) + ',',
            '  ),',
        ]
    out.append('];')
    OUT.write_text('\n'.join(out) + '\n', encoding='utf-8')
    print(f'{len(items)} recipes written to {OUT.relative_to(ROOT)}')


if __name__ == '__main__':
    main()
