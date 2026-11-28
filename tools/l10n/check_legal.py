"""Checks the translated legal texts of one language against the
Azerbaijani ones (the governing text): the privacy policy and the terms
(parla_flutter/assets/legal/<doc>.<code>.md) and the consent texts
(tools/l10n/consent/<code>.json). Run:

    python3 -I tools/l10n/check_legal.py <code>

Checked: the same headings and list items, the same {{placeholders}},
version codes in backticks and numbers, the translation note under the
title, the consent texts quoted in the privacy policy equal to the
consent file, and no word that calls something harmful or toxic.
Prints the problems and exits 1 when there are any.
"""

import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
LEGAL = ROOT / 'parla_flutter/assets/legal'
CONSENT = ROOT / 'tools/l10n/consent'
sys.path.insert(0, str(ROOT / 'tools/l10n'))
from check_arb import BANNED  # noqa: E402

KINDS = ['health', 'analytics', 'marketing']


def shape(text):
    lines = text.splitlines()
    return {
        'headings': sum(1 for l in lines if re.match(r'^#{1,6} ', l)),
        'items': sum(1 for l in lines if re.match(r'^\s*([-*]|\d+\.) ', l)),
        'placeholders': sorted(re.findall(r'\{\{\w+\}\}', text)),
        'codes': sorted(re.sub(r'<[^>]*>', '<>', c) for c in re.findall(r'`[^`]+`', text)),
        'digits': sorted(re.findall(r'\d+', re.sub(
            r'(?<=\d)[\s,.\u00a0\u202f](?=\d{3}\b)', '',
            re.sub(r'`[^`]+`|\{\{\w+\}\}', '', text)))),
    }


def main():
    code = sys.argv[1]
    problems = []
    consent_file = CONSENT / f'{code}.json'
    consent = {}
    if not consent_file.exists():
        problems.append(f'missing {consent_file.relative_to(ROOT)}')
    else:
        consent = json.loads(consent_file.read_text(encoding='utf-8'))
        src = json.loads((CONSENT / 'sources.json').read_text(encoding='utf-8'))
        for k in KINDS:
            t = consent.get(k)
            if not isinstance(t, str) or not t.strip():
                problems.append(f'consent {k}: missing')
                continue
            if re.findall(r'\d+', t) != re.findall(r'\d+', src[k]['az']):
                problems.append(f'consent {k}: numbers differ')
    for doc in ('privacy', 'terms'):
        f = LEGAL / f'{doc}.{code}.md'
        if not f.exists():
            problems.append(f'missing {f.relative_to(ROOT)}')
            continue
        text = f.read_text(encoding='utf-8')
        a, b = shape((LEGAL / f'{doc}.az.md').read_text(encoding='utf-8')), shape(text)
        for key in a:
            if a[key] != b[key]:
                if key == 'digits':
                    missing = sorted(set(a[key]) ^ set(b[key]))
                    problems.append(f'{doc}: digits differ {missing[:12]}')
                else:
                    problems.append(f'{doc}: {key} {a[key] if key != "digits" else ""} != {b[key]}')
        head = '\n'.join(text.splitlines()[:8])
        if code != 'az' and not re.search(r'^\*[^*]+\*$', head, re.M):
            problems.append(f'{doc}: translation note (*…*) missing under the title')
        if doc == 'privacy':
            def norm(v):
                v = re.sub(r'^\s*>\s?', '', v, flags=re.M)
                v = re.sub(r'[“”„«»"‘’‚‹›]', '', v)
                return re.sub(r'\s+', ' ', v).strip()
            flat = norm(text)
            for k in KINDS:
                t = consent.get(k)
                if isinstance(t, str) and norm(t) not in flat:
                    problems.append(f'privacy: consent {k} text not quoted exactly')
    # The documents may name the word itself (the terms forbid it; the
    # firewall blocks malicious addresses); the consent texts never do.
    low = ' '.join(v for v in consent.values() if isinstance(v, str)).lower()
    for w in BANNED.get(code, []):
        if re.search(r'(?<!\w)' + re.escape(w), low):
            problems.append(f'consent: banned word "{w}"')
    for p in problems:
        print(p)
    print(f'{code}: {len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
