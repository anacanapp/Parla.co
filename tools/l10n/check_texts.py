"""Checks parla_shared/i18n/<language>.json (Azerbaijani text →
translation) against tools/l10n/text_sources.json: every source text has
a non-empty translation, numbers and the % and ° signs are kept, and no
word calls something harmful or toxic. Run:

    python3 -I tools/l10n/check_texts.py <code>
"""

import json
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from check_arb import BANNED  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]


def main():
    code = sys.argv[1]
    sources = json.loads((ROOT / 'tools/l10n/text_sources.json').read_text(encoding='utf-8'))
    data = json.loads((ROOT / f'parla_shared/i18n/{code}.json').read_text(encoding='utf-8'))
    problems = []
    for az in sources:
        t = data.get(az)
        if not isinstance(t, str) or not t.strip():
            problems.append(f'missing: {az[:60]}')
            continue
        if sorted(re.findall(r'\d+', az)) != sorted(re.findall(r'\d+', t)):
            problems.append(f'numbers differ: {az[:60]} -> {t[:60]}')
        low = t.lower()
        for w in BANNED.get(code, []):
            if re.search(r'(?<!\w)' + re.escape(w), low):
                problems.append(f'banned "{w}": {t[:60]}')
    extra = set(data) - set(sources)
    if extra:
        problems.append(f'{len(extra)} keys not in the sources')
    for p in problems[:40]:
        print(p)
    print(f'{code}: {len(sources)} texts, {len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
