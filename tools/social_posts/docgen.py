import json, re, sys
d=json.load(open('posts.json')); ph=json.load(open('photos.json'))
NAME={'P1':'Foto başlıq','P2':'Şüşə siyahı','P3':'Belə / Belə yox','P4':'Yarı foto','P5':'Kollaj','P6':'Məsləhət kartı','P7':'Plitələr','P8':'İşıq dairəsi','P9':'Qövs','P10':'Şüşə sətirlər','T3v':'Mif','T5':'Gecə sitatı','T2':'Kart','T6':'Tətbiq ekranı','T7':'Son slayd','POLL':'Sorğu'}
SCREEN={'15_quiz':'test ekranı','01_home':'ana ekran','10_check':'yoxlama ekranı','03_discover':'kəşf ekranı'}
def t(x): 
    x=re.sub(r'_(.+?)_', r'*\1*', x or '')
    return x.replace('\n',' ').strip()
def ttx(x): return ' '.join(('*'+l[1:-1]+'*') if l.startswith('_') else l for l in (x or '').split('\n')).strip()
def desc(s):
    k=s['t']
    if k=='P1': return ' · '.join(filter(None,[ttx(s['tt']), t(s.get('lead')), ' / '.join(p.lstrip('!') for p in s.get('pills',[]))]))
    if k=='P2': return f"{ttx(s.get('tt',''))} — panel “{s['head']}”: " + '; '.join(('✓ ' if r[0]=='+' else '✗ ')+r[1:] for r in s['rows'])
    if k=='P3': return ttx(s['tt'])+' — '+'; '.join(f"✗ {a} → ✓ {b}" for a,b in s['items'])
    if k=='P4': return ttx(s['tt'])+(' · '+' / '.join(p.lstrip('!') for p in s.get('pills',[])) if s.get('pills') else '')
    if k=='P5':
        parts=[]
        for l in s['lines']:
            for p in l['p']:
                if 'cap' in p: parts.append(p['cap'])
                if 'ser' in p: parts.append('*'+p['ser']+'*')
                if 'pill' in p: parts.append('('+p['pill']+')')
                if 'small' in p: parts.append('— '+p['small'])
        return ' '.join(parts)+(' · '+' / '.join(p.lstrip('!') for p in s.get('pills',[])) if s.get('pills') else '')
    if k=='P6':
        q=t(s.get('q')); q=q if q[-1:] in '.?!' else q+'.'
        return f"“{s['head']}” — **{q}** {t(s.get('p'))}".strip()
    if k=='P7': return ttx(s['tt'])+' — '+'; '.join(f"{b} ({sp})" for b,sp in s['tiles'])
    if k=='P8': return t(s.get('quote') or s.get('word'))+(' · künclərdə: '+', '.join(c.replace('\n',' ') for c in s.get('corners',[])) if s.get('corners') else '')
    if k=='P9': return ttx(s['tt'])+' — '+'; '.join(f"{i+1}. {b} ({sp})" for i,(b,sp) in enumerate(s['steps']))
    if k=='P10': return ttx(s['tt'])+' — '+'; '.join(f"{b}: {t(sp)}" for b,sp in s['rows'])
    if k=='T3v': return f"MİF — {s['myth']} HƏQİQƏT — {t(s['truth'])}"
    if k=='T5': return t(s['quote'])+(' — '+t(s['sub']) if s.get('sub') else '')
    if k=='T2':
        h=t(s.get('h')); h=h if not h or h[-1] in '.?!:' else h+'.'
        b=' '.join(filter(None,[f"**{s['num']}** —" if s.get('num') else '', h, t(s.get('p'))]))
        if s.get('list'): b+=' '+'; '.join(s['list'])
        if s.get('tags'): b+=' '+' · '.join(s['tags'])
        return b
    if k=='T6': return f"{s['verb']} — {s['desc']} (real {SCREEN.get(s['screen'],s['screen'])})"
    if k=='T7': return f"{s.get('h','')} — {s.get('p','')} · düymələr: Saxla / Paylaş / Parla-nı yüklə"
    if k=='POLL': return f"{t(s['q'])} — 1 {s['left']['label']} / 2 {s['right']['label']}"
def photos(p):
    seen=[]
    for s in p['slides']:
        for k in ('photo',):
            if s.get(k) and s[k] not in seen: seen.append(s[k])
        if s['t']=='POLL':
            for side in ('left','right'):
                if s[side]['photo'] not in seen: seen.append(s[side]['photo'])
        if s['t']=='P5':
            for l in s['lines']:
                for q in l['p']:
                    if 'img' in q and q['img'] not in seen: seen.append(q['img'])
    return seen
def md(p):
    out=[]
    if len(p['slides'])==1:
        s=p['slides'][0]; out.append(f"**Vizual ({NAME[s['t']]}):** {desc(s)}")
    else:
        out.append('**Slaydlar:**\n\n'+'\n'.join(f"{i+1}. ({NAME[s['t']]}) {desc(s)}" for i,s in enumerate(p['slides'])))
    pp=photos(p)
    if pp:
        for x in pp: out.append('> '+ph[x]['p'].split(', editorial lifestyle')[0])
    else:
        out.append('**Foto:** yoxdur — fon kodla çəkilir' + (' (real tətbiq ekranları)' if any(s['t']=='T6' for s in p['slides']) else '') + '.')
    return '\n\n'.join(out)
ids=sys.argv[1:]
for p in d:
    if p['id'] in ids: print('=====',p['id']); print(md(p))
