// FabricTools documentation site: theme, copy buttons, PowerShell highlighting and the Command Explorer.
// All pages are rendered at build time by site/Build-DocsSite.ps1; this script only enhances them.
(() => {
  'use strict';

  const body = document.body;
  const ROOT = body.dataset.root || './';          // relative path to the site root
  const SUFFIX = body.dataset.linkSuffix || '';     // 'index.html' for file:// previews
  const CMDS = (window.FABRIC_COMMANDS || []).slice().sort((a, b) => a.name.localeCompare(b.name));
  const BY_NAME = new Map(CMDS.map(c => [c.name.toLowerCase(), c]));
  const VERB_ORDER = ['Get', 'New', 'Update', 'Remove', 'Add', 'Set', 'Invoke', 'Start', 'Stop', 'Connect', 'Disconnect', 'Export', 'Import'];
  const verbRank = v => { const i = VERB_ORDER.indexOf(v); return i < 0 ? 99 : i; };
  const cmdHref = name => `${ROOT}commands/${encodeURIComponent(name)}/${SUFFIX}`;
  const esc = s => String(s ?? '').replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]));

  // ---------- theme ----------
  const store = {
    get(k) { try { return localStorage.getItem(k); } catch { return null; } },
    set(k, v) { try { localStorage.setItem(k, v); } catch { /* storage unavailable */ } }
  };
  document.getElementById('theme')?.addEventListener('click', () => {
    const el = document.documentElement;
    const dark = el.dataset.theme ? el.dataset.theme === 'dark' : matchMedia('(prefers-color-scheme: dark)').matches;
    el.dataset.theme = dark ? 'light' : 'dark';
    store.set('ft-theme', el.dataset.theme);
  });

  // ---------- PowerShell highlighting + copy buttons ----------
  function highlightPS(code) {
    const re = /(#[^\n]*)|('(?:[^']|'')*'|"(?:[^"`]|`.)*")|(\$[\w:]+)|((?:^|\s)-[A-Za-z]\w*)|(\b[A-Z][a-z]+-[A-Za-z0-9]+\b)/gm;
    let out = '', last = 0, m;
    while ((m = re.exec(code))) {
      out += esc(code.slice(last, m.index));
      const t = esc(m[0]);
      if (m[1]) out += `<span class="tok-com">${t}</span>`;
      else if (m[2]) out += `<span class="tok-str">${t}</span>`;
      else if (m[3]) out += `<span class="tok-var">${t}</span>`;
      else if (m[4]) out += `<span class="tok-param">${t}</span>`;
      else {
        const hit = BY_NAME.get(m[0].toLowerCase());
        out += hit && hit.name !== body.dataset.command
          ? `<a class="tok-cmd" href="${cmdHref(hit.name)}">${t}</a>`
          : `<span class="tok-cmd">${t}</span>`;
      }
      last = m.index + m[0].length;
    }
    return out + esc(code.slice(last));
  }

  document.querySelectorAll('.code pre > code').forEach(code => {
    const text = code.textContent;
    code.innerHTML = highlightPS(text);
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'copy';
    btn.textContent = 'Copy';
    btn.dataset.copy = text;
    code.closest('.code').appendChild(btn);
  });

  document.addEventListener('click', e => {
    const btn = e.target.closest('[data-copy]');
    if (!btn || !navigator.clipboard) return;
    navigator.clipboard.writeText(btn.dataset.copy).then(() => {
      const label = btn.textContent;
      btn.textContent = 'Copied';
      setTimeout(() => (btn.textContent = label), 1200);
    }, () => {});
  });

  // ---------- keyboard: "/" focuses search (or goes to the explorer) ----------
  document.addEventListener('keydown', e => {
    if (e.key !== '/' || e.ctrlKey || e.metaKey || /^(INPUT|TEXTAREA|SELECT)$/.test(document.activeElement.tagName)) return;
    e.preventDefault();
    const q = document.getElementById('q');
    if (q) q.focus();
    else location.href = `${ROOT}${SUFFIX}#focus`;
  });

  // ---------- Command Explorer (home page only) ----------
  const input = document.getElementById('q');
  if (!input) return;

  const resultsEl = document.getElementById('results');
  const typesEl = document.getElementById('types');
  const verbsEl = document.getElementById('verbs');
  const countEl = document.getElementById('count');
  const count = (arr, key) => arr.reduce((m, x) => (m[x[key]] = (m[x[key]] || 0) + 1, m), {});
  const typeOrder = (a, b) => (a === 'Core' ? -1 : b === 'Core' ? 1 : a.localeCompare(b));
  const TOP_TYPES = 14;
  let showAllTypes = false;
  let activeIndex = -1;

  function readHash() {
    const qs = new URLSearchParams(location.hash.replace(/^#/, ''));
    return { q: qs.get('q') || '', type: qs.get('type') || '', verb: qs.get('verb') || '', focus: qs.has('focus') };
  }
  const state = readHash();

  function writeHash() {
    const qs = new URLSearchParams();
    if (state.q) qs.set('q', state.q);
    if (state.type) qs.set('type', state.type);
    if (state.verb) qs.set('verb', state.verb);
    const s = qs.toString();
    history.replaceState(null, '', location.pathname + location.search + (s ? '#' + s : ''));
  }

  function score(c, tokens) {
    if (!tokens.length) return 1;
    const name = c.name.toLowerCase(), noun = c.noun.toLowerCase();
    const type = c.itemType.toLowerCase().replace(/\s+/g, ''), syn = c.synopsis.toLowerCase();
    let total = 0;
    for (const t of tokens) {
      let s = 0;
      if (name === t) s = 100;
      else if (c.verb.toLowerCase() === t) s = 30;
      else if (noun.startsWith('fabric' + t) || noun.startsWith(t)) s = 40;
      else if (name.includes(t)) s = 25;
      else if (type.includes(t)) s = 15;
      else if (syn.includes(t)) s = 5;
      if (!s) return 0;
      total += s;
    }
    return total - name.length * 0.05;
  }

  function mark(text, tokens) {
    const s = esc(text);
    if (!tokens.length) return s;
    const re = new RegExp('(' + tokens.map(t => esc(t).replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('|') + ')', 'gi');
    return s.replace(re, '<mark>$1</mark>');
  }

  const chip = (kind, value, label, n, on) =>
    `<button class="chip" type="button" data-${kind}="${esc(value)}" aria-pressed="${on}">${esc(label)}${n != null ? `<span class="n">${n}</span>` : ''}</button>`;

  function update() {
    writeHash();
    const tokens = state.q.toLowerCase().split(/[\s-]+/).filter(Boolean);
    const matchQ = CMDS.map(c => ({ c, s: score(c, tokens) })).filter(x => x.s > 0);

    // Chip counts reflect the other active filter.
    const typeCounts = count(matchQ.filter(x => !state.verb || x.c.verb === state.verb).map(x => x.c), 'itemType');
    const verbCounts = count(matchQ.filter(x => !state.type || x.c.itemType === state.type).map(x => x.c), 'verb');
    const allTypes = [...new Set(CMDS.map(c => c.itemType))].sort(typeOrder);
    const allVerbs = [...new Set(CMDS.map(c => c.verb))].sort((a, b) => verbRank(a) - verbRank(b) || a.localeCompare(b));

    let types = allTypes.filter(t => typeCounts[t] || t === state.type);
    const hidden = !showAllTypes && types.length > TOP_TYPES ? types.length - TOP_TYPES : 0;
    if (hidden) {
      const pinned = types.filter(t => t === 'Core' || t === state.type);
      const rest = types.filter(t => !pinned.includes(t))
        .sort((a, b) => typeCounts[b] - typeCounts[a] || a.localeCompare(b))
        .slice(0, TOP_TYPES - pinned.length);
      types = types.filter(t => pinned.includes(t) || rest.includes(t));
    }
    typesEl.innerHTML = chip('type', '', 'All', null, !state.type) +
      types.map(t => chip('type', t, t, typeCounts[t] || 0, state.type === t)).join('') +
      (hidden ? `<button class="chip more" type="button" data-more="1">+ ${hidden} more</button>`
        : showAllTypes ? `<button class="chip more" type="button" data-more="0">Show fewer</button>` : '');
    verbsEl.innerHTML = chip('verb', '', 'All', null, !state.verb) +
      allVerbs.filter(v => verbCounts[v] || v === state.verb).map(v => chip('verb', v, v, verbCounts[v] || 0, state.verb === v)).join('');

    const hits = matchQ.filter(x => (!state.type || x.c.itemType === state.type) && (!state.verb || x.c.verb === state.verb));
    countEl.textContent = `${hits.length} of ${CMDS.length}`;
    const row = (c, showType) =>
      `<a class="row" href="${cmdHref(c.name)}"><span class="name">${mark(c.name, tokens)}</span><span class="syn">${mark(c.synopsis, tokens)}</span>${showType ? `<span class="type">${esc(c.itemType)}</span>` : '<span></span>'}</a>`;

    if (!hits.length) {
      resultsEl.innerHTML = '<div class="empty">No commands match. Try fewer words or clear the filters.</div>';
    } else if (tokens.length) {
      hits.sort((a, b) => b.s - a.s || a.c.name.localeCompare(b.c.name));
      resultsEl.innerHTML = `<div class="list">${hits.map(x => row(x.c, true)).join('')}</div>`;
    } else {
      const groups = {};
      hits.forEach(x => (groups[x.c.itemType] ||= []).push(x.c));
      resultsEl.innerHTML = Object.keys(groups).sort(typeOrder).map(t => {
        const items = groups[t].sort((a, b) => a.noun.localeCompare(b.noun) || verbRank(a.verb) - verbRank(b.verb));
        return `<section class="group"><h2>${esc(t)}<span>${items.length}</span></h2><div class="list">${items.map(c => row(c, false)).join('')}</div></section>`;
      }).join('');
    }
    activeIndex = -1;
  }

  document.getElementById('filters').addEventListener('click', e => {
    const b = e.target.closest('button');
    if (!b) return;
    if ('type' in b.dataset) state.type = state.type === b.dataset.type ? '' : b.dataset.type;
    else if ('verb' in b.dataset) state.verb = state.verb === b.dataset.verb ? '' : b.dataset.verb;
    else if ('more' in b.dataset) showAllTypes = b.dataset.more === '1';
    update();
  });

  input.addEventListener('input', () => { state.q = input.value; update(); });
  input.addEventListener('keydown', e => {
    const rows = [...resultsEl.querySelectorAll('.row')];
    if (!rows.length) return;
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault();
      activeIndex = Math.max(0, Math.min(rows.length - 1, activeIndex + (e.key === 'ArrowDown' ? 1 : -1)));
      rows.forEach((r, i) => r.classList.toggle('active', i === activeIndex));
      rows[activeIndex].scrollIntoView({ block: 'nearest' });
    } else if (e.key === 'Enter') {
      location.href = rows[Math.max(0, activeIndex)].href;
    }
  });

  window.addEventListener('hashchange', () => {
    Object.assign(state, readHash());
    input.value = state.q;
    update();
  });

  input.value = state.q;
  update();
  if (state.focus || !matchMedia('(max-width: 760px)').matches) input.focus();
})();
