// Renders Parla social posts: node render.js posts.json [postIds...] -> out/<id>/<nn>.png (1080x1350)
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const HERE = __dirname;
const ASSETS = path.join(HERE, 'assets');
const PHOTOS = path.join(HERE, 'photos');
const posts = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const only = process.argv.slice(3);

const esc = s => String(s ?? '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
const SMILE = '<svg class="sm" viewBox="0 0 100 22" preserveAspectRatio="none"><path d="M0 2 Q50 30 100 2 Q50 15 0 2Z" fill="currentColor"/></svg>';
// *word* -> accent (Playfair + one smile), **b** -> bold
const rich = (s, smile = true) => {
  let used = !smile;
  return esc(s)
    .replace(/\*\*(.+?)\*\*/g, '<b>$1</b>')
    .replace(/\*(.+?)\*/g, (_, w) => { const out = `<em>${w}${used ? '' : SMILE}</em>`; used = true; return out; })
    .replace(/\n/g, '<br>');
};
const photo = id => 'file://' + path.join(PHOTOS, id + '.jpg');
const wm = (c = 'espresso', style = '') => `<img class="wm" src="wordmark_${c}.png" style="${style}">`;

const THEME = {Rutin:'rose','Saç':'rose','Tərkib':'lilac','Bədən':'mist',Qidalanma:'mist',Brend:'all',Parla:'all','Məxfilik':'all','İcma':'rose',Ekspert:'lilac'};

const tt = (t, cls = '') => (t || '').split('\n').map(l => {
  const m = l.match(/^_(.+)_$/);
  return m ? `<div class="ser">${esc(m[1])}</div>` : `<div class="cap">${esc(l.toLocaleUpperCase('az'))}</div>`;
}).join('');
const pills = a => a ? `<div class="pills">${a.map(x => x.startsWith('!') ? `<span class="pill f">${esc(x.slice(1))}</span>` : `<span class="pill">${esc(x)}</span>`).join('')}</div>` : '';
const chrome = (kick, pg, dark = true) => `<div class="bar ${dark ? 'on-dark' : ''}"><span>${esc(kick === 'Parla' ? 'Parla' : 'Parla · ' + kick)}</span><span>${pg || 'Yeni post'}</span></div>
  <div class="foot ${dark ? 'on-dark' : ''}"><img src="wordmark_${dark ? 'cream' : 'espresso'}.png"><span>parla.anacan.az</span></div>`;
const ORB = {all:'conic-gradient(from 300deg,#FFCE00,#F6B4CF,#C9B8F2,#BFD8F2,#FFE97A,#FFCE00)',rose:'radial-gradient(circle,#F6B4CF 0,#FFE97A 45%,#F7F3F1 70%)',lilac:'radial-gradient(circle,#C9B8F2 0,#BFD8F2 45%,#F7F3F1 70%)',mist:'radial-gradient(circle,#BFD8F2 0,#FFE97A 50%,#F7F3F1 70%)'};
function slide(p, s, i, n) {
  const th = s.theme || p.theme || THEME[s.kick ?? p.kick] || 'all';
  const L = s.sun ? '' : '<div class="lights"></div>';
  const pg = n > 1 ? `<div class="pg">${i + 1} / ${n}</div>` : '';
  const swipe = n > 1 && i === 0 ? '<div class="swipe">sürüşdür <b>→</b></div>' : '';
  const kick = s.kick ?? p.kick;
  switch (s.t) {
    case 'T1': return `<div class="s t1 ${s.sun ? '' : 'light'} th-${th}">${L}${s.sun ? '' : '<img class="orb" src="mark.png">'}
      ${s.art ? `<img class="art" src="${photo(s.art)}" style="${s.artStyle || ''}">` : ''}
      <div class="kick"><i></i>${esc(kick)}</div>${pg}
      <h1>${rich(s.title)}</h1>
      ${s.sub ? `<div class="sub" style="top:${s.subTop || 760}px">${rich(s.sub, false)}</div>` : ''}
      ${s.langs ? `<div class="langs" style="top:${s.langsTop || 720}px">${s.langs.map(l => `<span${l === 'ქართული' ? ' style="font-family:Geo"' : ''}>${esc(l)}</span>`).join('')}</div>` : ''}
      ${wm()}${swipe}</div>`;
    case 'T2': {
      const steps = n > 2 ? `<div class="steps">${Array.from({ length: n - 2 }, (_, k) => `<i class="${k <= i - 1 ? 'on' : ''}"></i>`).join('')}</div>` : '';
      let inner = '';
      if (s.num) inner += `<div class="num">${esc(s.num)}</div>`;
      if (s.h) inner += `<h2>${rich(s.h)}</h2>`;
      if (s.p) inner += `<p>${rich(s.p, false)}</p>`;
      if (s.list) inner += `<ul>${s.list.map((l, k) => `<li><span>${k + 1}</span><div>${rich(l, false)}</div></li>`).join('')}</ul>`;
      if (s.tags) inner += `<div class="tags">${s.tags.map(x => `<span>${esc(x)}</span>`).join('')}</div>`;
      return `<div class="s t2 lit th-${th}"><div class="lights"></div><div class="kick"><i></i>${esc(kick)}</div>${pg}
        <div class="card">${inner}${s.noSteps ? '' : steps}</div>${wm('espresso', 'bottom:70px;width:130px')}</div>`;
    }
    case 'T3': return `<div class="s t3 lit th-${th}"><div class="lights" style="top:600px"></div>
      <div class="top"><div class="kick"><i></i>MİF</div><div class="myth">${rich(s.myth, false)}</div></div>
      <div class="bot"><div class="kick"><i></i>HƏQİQƏT</div><div class="truth">${rich(s.truth, false)}</div></div>
      ${wm()}</div>`;
    case 'T4': return `<div class="s t4">
      <svg width="0" height="0" style="position:absolute"><clipPath id="smilecrop" clipPathUnits="objectBoundingBox"><path d="M0,0 H1 V0.9 Q0.5,1.08 0,0.9 Z"/></clipPath></svg>
      <img class="ph" src="${photo(s.photo)}" style="object-position:${s.pos || 'center'};height:${820 - (s.lift || 0)}px">
      ${pg}<div class="kick" style="top:${840 - (s.lift || 0)}px"><i></i>${esc(kick)}</div>
      <h1 style="top:${900 - (s.lift || 0)}px">${rich(s.title)}</h1>
      ${s.sub ? `<div class="sub" style="top:${s.subTop || 1110}px">${rich(s.sub, false)}</div>` : ''}
      ${wm()}${swipe}</div>`;
    case 'T5': return `<div class="s t5">
      ${s.photo ? `<img class="bgph" src="${photo(s.photo)}">${s.shade === 0 ? "" : `<div style="position:absolute;inset:0;background:linear-gradient(180deg,#17120Ee6 0%,#17120E99 ${s.shade || 45}%,#17120E00 75%)"></div>`}` : ''}
      <div class="kick"><i></i>${esc(kick)}</div>
      <blockquote style="top:${s.qTop || 360}px">${rich(s.quote)}</blockquote>
      ${s.sub ? `<div class="sub" style="top:${s.subTop || 900}px">${rich(s.sub, false)}</div>` : ''}
      ${wm('sun')}<div class="url">parla.anacan.az</div></div>`;
    case 'T6': return `<div class="s t6 light th-${th}"><div class="lights"></div>${pg}
      <div class="verb">${esc(s.verb)}</div><div class="desc">${esc(s.desc)}</div>
      <div class="phone"><img src="${s.screen}.png"><div class="island"></div></div></div>`;
    case 'T7': return `<div class="s t7 lit th-${th}"><div class="lights"></div>${pg}<div class="in">
      <img class="mark" src="mark.png"><h2>${rich(s.h || 'Saxla, sonra lazım olacaq', false)}</h2>
      ${s.p ? `<p>${rich(s.p, false)}</p>` : ''}
      <div class="acts"><span>Saxla</span><span>Paylaş</span><span class="main">Parla-nı yüklə</span></div></div>
      ${wm('espresso', 'bottom:66px')}</div>`;

    case 'P1': return `<div class="s p1 on-dark"><img class="bg" src="${photo(s.photo)}" style="object-position:${s.pos || 'center'}"><div class="shade"></div>
      ${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '')}
      <div class="tt" style="bottom:${s.bottom || 190}px;${s.serSize ? `--ser:${s.serSize}px` : ''}">${tt(s.tt)}${s.lead ? `<div class="lead">${rich(s.lead, false)}</div>` : ''}${pills(s.pills)}</div></div>`;
    case 'P2': return `<div class="s p2 on-dark"><img class="bg" src="${photo(s.photo)}" style="object-position:${s.pos || 'center'}"><div class="shade"></div>
      ${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '')}
      ${s.tt ? `<div class="tt" style="top:${s.ttTop || 150}px">${tt(s.tt)}</div>` : ''}
      <div class="panel glass" style="top:${s.panelTop || 380}px"><h3>${esc(s.head)}</h3>${s.rows.map(x => `<div class="row"><span>${esc(x.replace(/^[+-]/, ''))}</span><i class="tg ${x.startsWith('+') ? 'on' : ''}"></i></div>`).join('')}</div></div>`;
    case 'P3': return `<div class="s p3 on-dark"><img class="bg" src="${photo(s.photo)}" style="object-position:${s.pos || 'center'}"><div class="shade"></div>
      ${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '')}
      <div class="tt">${tt(s.tt)}</div>
      <div class="cols"><div class="colh">${esc(s.noH || 'Belə yox')}</div><div class="colh">${esc(s.okH || 'Belə')}</div>
      ${s.items.map(([a, b]) => `<div class="it no"><b>×</b>${esc(a)}</div><div class="it ok"><b>✓</b>${esc(b)}</div>`).join('')}</div>${n > 1 && i === 0 ? '' : ''}</div>`;
    case 'P4': return `<div class="s p4 th-${th}"><div class="lights" style="height:640px"></div>
      <div class="top">${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '', false).replace(/<div class="foot[\s\S]*$/, '')}<div class="tt">${tt(s.tt)}</div>${pills(s.pills)}</div>
      <div class="phw"><img src="${photo(s.photo)}" style="object-position:${s.pos || 'center'}"></div>
      <img src="wordmark_cream.png" style="position:absolute;left:64px;bottom:52px;width:120px"></div>`;
    case 'P5': return `<div class="s p5 th-${th}"><div class="lights"></div>${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '', false)}
      <div class="lines" style="top:${s.top || 260}px">${s.lines.map(l => `<div class="ln" style="justify-content:${l.j || 'flex-start'}">${l.p.map(x =>
        x.cap ? `<span class="cap">${esc(x.cap.toLocaleUpperCase('az'))}</span>` : x.ser ? `<span class="ser">${esc(x.ser)}</span>` : x.pill ? `<span class="pill">${esc(x.pill)}</span>` :
        x.img ? `<img class="inset" src="${photo(x.img)}">` : x.small ? `<span class="small">${esc(x.small)}</span>` : '').join('')}</div>`).join('')}</div>
      ${s.pills ? `<div style="position:absolute;left:64px;right:64px;top:${s.pillsTop || 940}px">${pills(s.pills)}</div>` : ''}</div>`;
    case 'P6': return `<div class="s p6"><img class="bg" src="${photo(s.photo)}" style="object-position:${s.pos || 'center'}"><div class="shade"></div>
      ${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '')}
      <div class="card glass ${s.dark ? 'on-dark' : 'light'}" style="top:${s.cardTop || 430}px"><h4><i></i>${esc(s.head)}</h4>${s.q ? `<div class="q">${rich(s.q, false)}</div>` : ''}${s.p ? `<p>${rich(s.p, false)}</p>` : ''}</div></div>`;
    case 'P7': return `<div class="s p7 on-dark"><img class="bg" src="${photo(s.photo)}" style="object-position:${s.pos || 'center'}"><div class="shade"></div>
      ${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '')}<div class="tt">${tt(s.tt)}</div>
      <div class="grid ${s.cols2 ? 'c2' : ''}" style="top:${s.gridTop || 420}px">${s.tiles.map(([b, sp]) => `<div class="tile glass"><b>${esc(b)}</b>${sp ? `<span>${esc(sp)}</span>` : ''}</div>`).join('')}</div></div>`;
    case 'P8': return `<div class="s p8"><div class="orbg" style="background:${ORB[th] || ORB.all}"></div><div class="disc"></div>
      ${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '', false)}
      <div class="word">${s.word ? `<div class="cap" style="font-size:${s.size || 120}px;letter-spacing:.32em;padding-left:.32em">${esc(s.word)}</div>` : ''}${s.quote ? `<div class="ser" style="font-size:${s.size || 104}px;line-height:1.1">${rich(s.quote)}</div>` : ''}</div>
      ${(s.corners || []).map((c, k) => `<div class="corner" style="${['left:64px;top:130px', 'right:64px;top:130px;text-align:right', 'left:64px;bottom:130px', 'right:64px;bottom:130px;text-align:right'][k]}">${esc(c).replace(/\n/g, '<br>')}</div>`).join('')}</div>`;
    case 'P9': {
      const cx = 1400, cy = 660, R = 800, N = s.steps.length;
      const pts = s.steps.map((_, k) => { const a = Math.PI * (0.8 + 0.4 * (k / (N - 1))); return [cx + R * Math.cos(a), cy - R * Math.sin(a)]; });
      return `<div class="s p9 on-dark"><img class="bg" src="${photo(s.photo)}" style="object-position:${s.pos || 'center'}"><div class="shade"></div>
      ${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '')}
      <svg class="arc" width="1080" height="1350"><circle cx="${cx}" cy="${cy}" r="${R}" fill="none" stroke="rgba(255,255,255,.55)" stroke-width="2"/></svg>
      <div class="tt">${tt(s.tt)}</div>
      ${pts.map(([x, y], k) => `<div class="dot" style="left:${x - 20}px;top:${y - 20}px">${k + 1}</div><div class="st" style="left:${x + 36}px;top:${y - 22}px;width:${1010 - x - 36}px"><b>${esc(s.steps[k][0])}</b><span>${esc(s.steps[k][1] || '')}</span></div>`).join('')}</div>`;
    }
    case 'P10': return `<div class="s p10 on-dark"><img class="bg" src="${photo(s.photo)}" style="object-position:${s.pos || 'center'}"><div class="shade"></div>
      ${chrome(kick, n > 1 ? `${i + 1} / ${n}` : '')}<div class="tt">${tt(s.tt)}</div>
      <div class="rows" style="top:${s.rowsTop || 430}px">${s.rows.map(([b, sp]) => `<div class="r glass"><b>${esc(b)}</b><span>${rich(sp || '', false)}</span></div>`).join('')}</div></div>`;
    case 'T3v': return `<div class="s t3v th-${th}"><div class="lights" style="top:640px"></div>
      <div class="top"><img src="${photo(s.photo)}" style="object-position:${s.pos || 'center'}"><div class="shade"></div>
      <div class="bar on-dark" style="top:56px"><span>Parla · Mif və həqiqət</span><span>Yeni post</span></div>
      <div class="in"><span class="stamp">MİF</span><div class="myth">${esc(s.myth)}</div></div></div>
      <div class="bot"><span class="stamp">HƏQİQƏT</span><div class="truth">${rich(s.truth, false)}</div></div>
      <img class="wm" src="wordmark_espresso.png" style="width:120px;bottom:52px;left:64px"></div>`;
    case 'POLL': return `<div class="s"><div class="split">
      <div><img src="${photo(s.left.photo)}"><div class="lab">${esc(s.left.label)}</div><div class="n">1</div></div>
      <div><img src="${photo(s.right.photo)}"><div class="lab">${esc(s.right.label)}</div><div class="n">2</div></div></div>
      <div class="pollq">${rich(s.q)}</div>${wm()}</div>`;
  }
  throw new Error('unknown template ' + s.t);
}

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1080, height: 1350 }, deviceScaleFactor: 1 });
  const css = fs.readFileSync(path.join(ASSETS, 'post.css'), 'utf8');
  for (const p of posts) {
    if (only.length && !only.includes(p.id)) continue;
    const dir = path.join(HERE, 'out', p.id);
    fs.mkdirSync(dir, { recursive: true });
    for (let i = 0; i < p.slides.length; i++) {
      const html = `<!doctype html><html lang="az"><head><meta charset="utf-8"><base href="file://${ASSETS}/"><style>${css}</style></head><body>${slide(p, p.slides[i], i, p.slides.length)}</body></html>`;
      const file = path.join(HERE, 'tmp.html');
      fs.writeFileSync(file, html);
      await page.goto('file://' + file);
      await page.evaluate(() => document.fonts.ready);
      await page.waitForTimeout(80);
      const nm = String(i + 1).padStart(2, '0');
      await page.screenshot({ path: path.join(dir, nm + '.png') });
      if (process.env.CHECK) {
        const chk = path.join(HERE, 'chk'); fs.mkdirSync(chk, { recursive: true });
        const boxes = await page.evaluate(() => {
          const sel = '.tt,.panel,.card,.cols,.grid,.rows,.st,.dot,.word,.lines,.pills,.lead,.myth,.in,blockquote,.sub,h1,.verb,.desc,.pollq,.lab';
          return [...document.querySelectorAll(sel)].map(e => { const r = e.getBoundingClientRect(); return [e.className || e.tagName, r.x, r.y, r.width, r.height]; }).filter(b => b[3] > 2 && b[4] > 2);
        });
        fs.writeFileSync(path.join(chk, `${p.id}_${nm}.json`), JSON.stringify(boxes));
        await page.addStyleTag({ content: 'body *{visibility:hidden!important} .bg,.ph,.bgph,.phw,.phw img,.split,.split img,.inset,.top img{visibility:visible!important} .shade{display:none!important}' });
        await page.screenshot({ path: path.join(chk, `${p.id}_${nm}.png`) });
      }
    }
    console.log(p.id, p.slides.length);
  }
  await browser.close();
})();
