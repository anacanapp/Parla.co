"""Adds the consent versions in every interface language (owner,
2026-11-27) to parla_shared/lib/src/consent_texts.dart: health-2026-11-draft6,
analytics-2026-11-draft2 and marketing-2026-11-draft2, with the current
az, ru and en texts unchanged and the translations from
tools/l10n/consent/<code>.json. Consent texts are append-only: run once;
a second run changes nothing. Run:

    python3 -I tools/l10n/add_consent_versions.py
"""

import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
DART = ROOT / 'parla_shared/lib/src/consent_texts.dart'
CONSENT = ROOT / 'tools/l10n/consent'
LANGS = ['az', 'tr', 'ru', 'en', 'kk', 'uz', 'tk', 'ky', 'ka']
VERSIONS = {
    'health': 'health-2026-11-draft6',
    'analytics': 'analytics-2026-11-draft2',
    'marketing': 'marketing-2026-11-draft2',
}


def dart_string(s):
    s = s.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$')
    return "'" + s + "'"


def main():
    src = DART.read_text(encoding='utf-8')
    if all(f"'{v}'" in src for v in VERSIONS.values()):
        print('already added')
        return
    texts = {l: json.loads((CONSENT / f'{l}.json').read_text(encoding='utf-8')) for l in LANGS}
    blocks = ['  // The same texts in every interface language (2026-11-27).']
    for kind, version in VERSIONS.items():
        bodies = '\n'.join(f'      {l!r}: {dart_string(texts[l][kind])},'.replace('"', "'") for l in LANGS)
        blocks.append(
            '  ConsentText(\n'
            f'    kind: ConsentKind.{kind},\n'
            f"    version: '{version}',\n"
            '    bodies: {\n'
            f'{bodies}\n'
            '    },\n'
            '  ),'
        )
    end = src.index('];\n', src.index('const List<ConsentText> consentTextHistory'))
    src = src[:end] + '\n'.join(blocks) + '\n' + src[end:]
    DART.write_text(src, encoding='utf-8')
    print('added', ', '.join(VERSIONS.values()))


if __name__ == '__main__':
    main()
