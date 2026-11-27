"""Checks the article and recipe translations of one language against
tools/content_i18n/sources/: every slug and field is there, the Markdown
keeps its headings and list items, numbers and links are kept, recipe
ingredient and step lists keep their length, and no word calls something
harmful or toxic. Run:

    python3 -I tools/content_i18n/check_content.py <code>
"""

import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/l10n'))
from check_arb import BANNED  # noqa: E402

SRC = ROOT / 'tools/content_i18n/sources'


def shape(md):
    """Headings, list items, links and numbers of a Markdown text."""
    lines = md.split('\n')
    return (
        sum(1 for l in lines if l.lstrip().startswith('#')),
        sum(1 for l in lines if re.match(r'\s*([-*]|\d+\.)\s', l)),
        sorted(re.findall(r'\]\(([^)]+)\)', md)),
        sorted(re.findall(r'\d+', md)),
    )


def main():
    code = sys.argv[1]
    folder = ROOT / f'tools/content_i18n/{code}'
    problems = []

    def banned(text, where):
        low = text.lower()
        for w in BANNED.get(code, []):
            if re.search(r'(?<!\w)' + re.escape(w), low):
                problems.append(f'{where}: banned "{w}"')

    arts = json.loads((SRC / 'articles.json').read_text(encoding='utf-8'))
    got = {}
    for f in sorted(folder.glob('articles*.json')):
        got.update(json.loads(f.read_text(encoding='utf-8')))
    for slug, src in arts.items():
        t = got.get(slug)
        if t is None:
            problems.append(f'article {slug}: missing')
            continue
        for field, value in src.items():
            v = t.get(field)
            if not isinstance(v, str) or not v.strip():
                problems.append(f'article {slug}.{field}: missing')
                continue
            banned(v, f'article {slug}.{field}')
            if field == 'body':
                a, b = shape(value['az']), shape(v)
                for name, x, y in zip(('headings', 'list items', 'links', 'numbers'), a, b):
                    if x != y:
                        problems.append(f'article {slug}.body: {name} differ ({x if name != "numbers" else len(x)} vs {y if name != "numbers" else len(y)})')
    recs = json.loads((SRC / 'recipes.json').read_text(encoding='utf-8'))
    rp = folder / 'recipes.json'
    got = json.loads(rp.read_text(encoding='utf-8')) if rp.exists() else {}
    for slug, src in recs.items():
        t = got.get(slug)
        if t is None:
            problems.append(f'recipe {slug}: missing')
            continue
        if not isinstance(t.get('title'), str) or not t['title'].strip():
            problems.append(f'recipe {slug}.title: missing')
        ing = t.get('ingredients') or []
        if len(ing) != len(src['ingredients']):
            problems.append(f'recipe {slug}.ingredients: {len(ing)} vs {len(src["ingredients"])}')
        else:
            for i, (a, b) in enumerate(zip(src['ingredients'], ing)):
                if not b.get('name'):
                    problems.append(f'recipe {slug}.ingredients[{i}].name: missing')
                if sorted(re.findall(r'\d+', a['amount']['az'])) != sorted(re.findall(r'\d+', b.get('amount', ''))):
                    problems.append(f'recipe {slug}.ingredients[{i}].amount: numbers differ')
        steps = t.get('steps') or []
        if len(steps) != len(src['steps']):
            problems.append(f'recipe {slug}.steps: {len(steps)} vs {len(src["steps"])}')
        banned(json.dumps(t, ensure_ascii=False), f'recipe {slug}')
    for p in problems[:50]:
        print(p)
    print(f'{code}: {len(arts)} articles, {len(recs)} recipes, {len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
