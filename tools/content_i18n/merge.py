"""Adds the article and recipe translations in tools/content_i18n/<lang>/
to seed items (used by tools/blog_import/build_blog_seed.py and
build_recipe_seed.py). Only the languages Parla does not write itself;
az, ru and en are never touched. A missing translation is left out (the
app then shows the closest of az/ru/en)."""

import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
LANGUAGES = ['tr', 'kk', 'uz', 'tk', 'ky', 'ka']


def _load(lang, pattern):
    out = {}
    for f in sorted((ROOT / 'tools/content_i18n' / lang).glob(pattern)):
        out.update(json.loads(f.read_text(encoding='utf-8')))
    return out


_cache = {}


def _tables(kind):
    if kind not in _cache:
        pattern = 'articles*.json' if kind == 'article' else 'recipes.json'
        _cache[kind] = {lang: _load(lang, pattern) for lang in LANGUAGES}
    return _cache[kind]


def article(slug, data):
    """[data] of article [slug] with its translations added."""
    for lang, table in _tables('article').items():
        t = table.get(slug)
        if not t:
            continue
        for field in ('title', 'summary', 'body'):
            if isinstance(data.get(field), dict) and t.get(field):
                data[field][lang] = t[field]
    return data


def recipe(slug, data):
    """[data] of recipe [slug] with its translations added (only when the
    ingredient and step lists line up with the source)."""
    for lang, table in _tables('recipe').items():
        t = table.get(slug)
        if not t:
            continue
        if t.get('title'):
            data['title'][lang] = t['title']
        ing = t.get('ingredients') or []
        if len(ing) == len(data.get('ingredients', [])):
            for src, tr in zip(data['ingredients'], ing):
                if tr.get('name'):
                    src['name'][lang] = tr['name']
                if tr.get('amount'):
                    src['amount'][lang] = tr['amount']
        steps = t.get('steps') or []
        if len(steps) == len(data.get('steps', [])):
            for src, tr in zip(data['steps'], steps):
                if tr:
                    src[lang] = tr
    return data
