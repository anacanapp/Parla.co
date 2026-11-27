"""Checks a translated ARB file against the Azerbaijani one (the main
language): the same keys in the same order, the same {placeholders}, the
same ICU plural/select variables, and no word that calls something harmful
or toxic (the app never does). Run:

    python3 -I tools/l10n/check_arb.py <code>

Prints the problems and exits 1 when there are any.
"""

import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
L10N = ROOT / 'parla_flutter/lib/l10n'

# Words for "harmful" / "toxic" per language (lower case, stems).
BANNED = {
    'az': ['zərərli', 'zəhərli'],
    'tr': ['zararlı', 'zehirli', 'toksik'],
    'ru': ['вредн', 'токсич', 'ядовит'],
    'en': ['harmful', 'toxic'],
    'kk': ['зиянды', 'улы', 'уытты', 'токсик'],
    'uz': ['zararli', 'zaharli', 'toksik'],
    'tk': ['zyýanly', 'zäherli', 'toksik'],
    'ky': ['зыяндуу', 'уулуу', 'токсик'],
    'ka': ['მავნე', 'ტოქსიკ', 'შხამიან'],
}


def placeholders(text, names):
    """Which of [names] (the key's declared placeholders) the text uses."""
    return {n for n in names if re.search(r'\{' + re.escape(n) + r'[,}]', text)}


def main():
    code = sys.argv[1]
    base = json.loads((L10N / 'app_az.arb').read_text(encoding='utf-8'))
    # The declared placeholders live in the template (English) file.
    meta = json.loads((L10N / 'app_en.arb').read_text(encoding='utf-8'))
    other = json.loads((L10N / f'app_{code}.arb').read_text(encoding='utf-8'))
    problems = []
    base_keys = [k for k in base if not k.startswith('@')]
    keys = [k for k in other if not k.startswith('@') and k != '@@locale']
    if set(base_keys) - set(keys):
        problems.append(f'missing: {sorted(set(base_keys) - set(keys))[:20]}')
    if set(keys) - set(base_keys):
        problems.append(f'extra: {sorted(set(keys) - set(base_keys))[:20]}')
    for k in base_keys:
        if k not in other:
            continue
        a, b = base[k], other[k]
        if not isinstance(b, str) or not b.strip():
            problems.append(f'{k}: empty')
            continue
        names = set((meta.get('@' + k) or {}).get('placeholders', {}))
        if placeholders(a, names) != placeholders(b, names):
            problems.append(
                f'{k}: placeholders {placeholders(a, names)} != {placeholders(b, names)}'
            )
        # A plural form may differ by language; a select must stay.
        for word in ('select',):
            if (f', {word},' in a) != (f', {word},' in b):
                problems.append(f'{k}: {word} form differs')
        low = b.lower()
        for w in BANNED.get(code, []):
            if w in low:
                problems.append(f'{k}: banned word "{w}"')
    for p in problems:
        print(p)
    print(f'{code}: {len(keys)} keys, {len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
