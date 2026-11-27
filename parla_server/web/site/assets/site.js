// Reports button clicks and reading depth as daily totals: no cookie, no
// identifier, nothing from other sites (see the privacy page).
(() => {
  const send = (kind, key) => {
    try {
      navigator.sendBeacon('/site/e', kind + '|' + key + '|' + location.pathname);
    } catch (_) {}
  };
  document.addEventListener('click', (e) => {
    const el = e.target.closest && e.target.closest('[data-track]');
    if (el) send('click', el.getAttribute('data-track'));
  });
  let reached = 0;
  const marks = [25, 50, 75, 100];
  const onScroll = () => {
    const h = document.documentElement;
    const seen = Math.round(((h.scrollTop + innerHeight) / h.scrollHeight) * 100);
    for (const m of marks) {
      if (seen >= m && reached < m) {
        reached = m;
        send('depth', String(m));
      }
    }
  };
  addEventListener('scroll', onScroll, { passive: true });
})();
