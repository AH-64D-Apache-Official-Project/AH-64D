// The DTC tabs (points, routes, areas/zones, lines): lists, drawing on the Arma map laid over the page
// (fza_mplanner_fnc_dtcMap), and the DTC box and its dialog: load into the aircraft, saves, read back, Eden, text
(function () {
  'use strict';

  var TOOLS = {
    line: { kind: 'lines', need: 4, min: 2, closed: false, colour: 0, shape: false, label: 'line' },
    area: { kind: 'areas', need: 4, min: 4, closed: true, colour: 1, shape: true, label: 'area' },
    pfz:  { kind: 'pfz',   need: 4, min: 4, closed: true, colour: 2, shape: true, label: 'PF zone' },
    nfz:  { kind: 'nfz',   need: 4, min: 4, closed: true, colour: 3, shape: true, label: 'NF zone' }
  };
  var POINT_DEFAULT = { wp: 'WP', cm: 'CP', tt: 'TG' };
  var MAP_TABS = { lines: true, az: true, wp: true, cm: true, tt: true, routes: true };

  var state = {
    dtc: dtcEmpty(),
    world: '',
    seeded: false,
    tab: 'config',
    tool: null,
    box: true,
    sel: { lines: -1, areas: -1, pfz: -1, nfz: -1, wp: -1, cm: -1, tt: -1 },
    route: 0,
    idents: null,
    saves: { own: [], mission: [] },
    modal: { scope: 'own', selected: '' },
    mapShown: false,
    mapRect: ''
  };

  function el(id) { return document.getElementById(id); }

  function setStatus(text, bad) {
    var s = el('dtcStatus');
    if (!s) return;
    s.textContent = text || '';
    s.className = 'dtc-status' + (bad ? ' bad' : '');
  }

  function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function changed() {
    render();
    sync();
  }

  // ── The Arma map over the page ───────────────────────────────────────────
  function anyModalOpen() {
    var open = false;
    eachNode('.modal-backdrop', function (m) { if (m.classList.contains('visible')) open = true; });
    return open;
  }

  function activeMapArea() {
    var panel = document.querySelector('.tab-panel.active');
    return panel ? panel.querySelector('[data-dtc-map]') : null;
  }

  function rectOf(e) {
    var x = 0, y = 0, n = e;
    while (n) { x += n.offsetLeft; y += n.offsetTop; n = n.offsetParent; }
    return [x, y, e.offsetWidth, e.offsetHeight];
  }

  function placeMap(tries) {
    var area = activeMapArea();
    if (!MAP_TABS[state.tab] || !area || anyModalOpen()) {
      if (state.mapShown) callSQF('["hide"] call fza_mplanner_fnc_dtcMap;');
      state.mapShown = false;
      state.mapRect = '';
      return;
    }
    var r = rectOf(area);
    var W = window.innerWidth, H = window.innerHeight;
    if (!(r[2] > 0 && r[3] > 0 && W > 0 && H > 0)) {
      if ((tries || 0) < 20) setTimeout(function () { placeMap((tries || 0) + 1); }, 100);
      return;
    }
    // Only when the map area moves, or the map was hidden
    var rect = [r[0] / W, r[1] / H, r[2] / W, r[3] / H].map(function (v) { return v.toFixed(4); }).join(',');
    if (state.mapShown && rect === state.mapRect) return;
    callSQF('["show",' + rect + '] call fza_mplanner_fnc_dtcMap;');
    state.mapShown = true;
    state.mapRect = rect;
    sync();
  }

  // What the map draws: shapes [points, closed, colour, label], points [position, label, ident], the chosen route, the
  // shape being drawn
  function sync() {
    if (!state.mapShown) return;
    var d = state.dtc, draw = [], points = [], route = [];
    d.lines.forEach(function (e) { if (e) draw.push([e.pts, false, 0, e.id]); });
    d.areas.forEach(function (e) { if (e) draw.push([e.pts, true, 1, e.id]); });
    d.pfz.forEach(function (e, i) { if (e) draw.push([e.pts, true, 2, 'PF' + (i + 1) + (d.activePf === i ? ' ACT' : '')]); });
    d.nfz.forEach(function (e, i) { if (e) draw.push([e.pts, true, 3, 'NF' + (i + 1) + (d.nfActive[i] ? ' ACT' : '')]); });
    DTC_POINT_KINDS.forEach(function (kind) {
      d[kind].forEach(function (p, i) { if (p) points.push([[p.pt[0], p.pt[1]], dtcPointId(kind, i), p.ident]); });
    });
    if (state.tab === 'routes') {
      d.routes[state.route].forEach(function (id) {
        var p = dtcPointAt(d, id);
        if (p) route.push([p.pt[0], p.pt[1]]);
      });
    }
    var t = state.tool;
    var draft = t && t.verts ? { pts: t.verts, c: t.colour, closed: t.closed, box: t.box } : 0;
    callSQF('["sync",' + sqfQuotedString(JSON.stringify({ d: draw, p: points, r: route, t: draft })) + '] call fza_mplanner_fnc_dtcMap;');
  }

  // ── Drawing and placing ──────────────────────────────────────────────────
  function freeSlot(kind, mayReplace) {
    var sel = state.sel[kind];
    var list = state.dtc[kind];
    if (sel >= 0 && (mayReplace || !list[sel])) return sel;
    return list.indexOf(null);
  }

  function startTool(name) {
    var def = TOOLS[name];
    var box = def.shape && state.box;
    state.tool = { name: name, kind: def.kind, need: box ? 2 : def.need, min: box ? 2 : def.min, closed: def.closed,
      colour: def.colour, box: box, verts: [] };
    var slot = freeSlot(def.kind, true);
    setStatus(slot < 0 ? 'No free slot: choose one to replace.' : 'Click the map: ' + (box ? 'two corners of the ' : state.tool.need + ' points of the ') + def.label + '.');
    changed();
  }

  function startPointTool(name, kind) {
    if (name === 'move' && (state.sel[kind] < 0 || !state.dtc[kind][state.sel[kind]])) {
      setStatus('Choose a point to move first.', true);
      return;
    }
    state.tool = { name: name, kind: kind };
    setStatus(name === 'move' ? 'Click the map where ' + dtcPointId(kind, state.sel[kind]) + ' goes.' :
      name === 'route' ? 'Click points on the map to add them to route ' + (state.route + 1) + '.' : 'Click the map to place a point.');
    changed();
  }

  function cancelTool() {
    if (!state.tool) return false;
    state.tool = null;
    setStatus('');
    changed();
    return true;
  }

  function undoPoint() {
    if (!state.tool || !state.tool.verts || !state.tool.verts.length) return false;
    state.tool.verts.pop();
    changed();
    return true;
  }

  function finishTool() {
    var t = state.tool;
    if (!t || !t.verts || t.verts.length < t.min) return;
    var pts = t.box ? dtcBox(t.verts[0], t.verts[1]) : t.verts.slice();
    if (t.closed) {
      pts = dtcValidQuad(pts);
      if (!pts) {
        t.verts.pop();
        setStatus('Its sides cross or it has no area: choose that point again.', true);
        changed();
        return;
      }
    }
    var slot = freeSlot(t.kind, true);
    if (slot < 0) {
      setStatus('No free slot: choose one to replace.', true);
      return;
    }
    var list = state.dtc[t.kind];
    var old = list[slot];
    if (t.kind === 'lines' || t.kind === 'areas') {
      list[slot] = { id: old ? old.id : dtcDefaultIdent(t.kind, slot), pts: pts };
    } else {
      list[slot] = { pts: pts };
    }
    state.sel[t.kind] = slot;
    state.tool = null;
    setStatus('');
    changed();
  }

  function nearestPoint(x, y, reach) {
    var best = null, bestD = reach;
    DTC_POINT_KINDS.forEach(function (kind) {
      state.dtc[kind].forEach(function (p, i) {
        if (!p) return;
        var dd = Math.sqrt(Math.pow(p.pt[0] - x, 2) + Math.pow(p.pt[1] - y, 2));
        if (dd <= bestD) { bestD = dd; best = dtcPointId(kind, i); }
      });
    });
    return best;
  }

  function onMapClick(x, y, z, grid, reach) {
    var t = state.tool;
    if (!t) return;
    if (t.name === 'point' || t.name === 'move') {
      var list = state.dtc[t.kind];
      var slot = t.name === 'move' ? state.sel[t.kind] : freeSlot(t.kind, false);
      if (slot < 0) { setStatus('That file is full.', true); return; }
      var old = list[slot];
      list[slot] = { ident: old ? old.ident : POINT_DEFAULT[t.kind], free: old ? old.free : '', pt: [x, y, z], g: grid || '' };
      state.sel[t.kind] = slot;
      if (t.name === 'move') { state.tool = null; setStatus(''); }
      changed();
      return;
    }
    if (t.name === 'route') {
      var id = nearestPoint(x, y, Math.max(reach || 0, 50));
      if (!id) { setStatus('No point there.', true); return; }
      var route = state.dtc.routes[state.route];
      if (route.length >= 50) { setStatus('That route is full.', true); return; }
      route.push(id);
      setStatus('Added ' + id + ' to route ' + (state.route + 1) + '.');
      changed();
      return;
    }
    t.verts.push([x, y, z]);
    if (t.verts.length >= t.need) finishTool(); else changed();
  }

  function deletePoint(kind, slot) {
    var id = dtcPointId(kind, slot);
    state.dtc[kind][slot] = null;
    state.dtc.routes = state.dtc.routes.map(function (r) { return r.filter(function (x) { return x !== id; }); });
  }

  // ── Lists ────────────────────────────────────────────────────────────────
  function shapeRow(kind, i, e) {
    var d = state.dtc;
    var cls = 'dtc-row' + (state.sel[kind] === i ? ' sel' : '') + (e ? '' : ' empty');
    var name = '';
    if (kind === 'lines' || kind === 'areas') {
      name = e ? '<input class="dtc-ident" data-kind="' + kind + '" data-slot="' + i + '" maxlength="5" value="' + escapeHtml(e.id) + '">' : '<span class="dtc-none">--</span>';
    } else {
      name = '<span class="dtc-zone-name">' + (kind === 'pfz' ? 'PF' : 'NF') + (i + 1) + '</span>';
    }
    var info = e ? e.pts.length + ' PTS' : 'EMPTY';
    var act = '';
    if (kind === 'pfz' && e) act = '<button class="dtc-act' + (d.activePf === i ? ' on' : '') + '" data-act="pfz" data-slot="' + i + '">ACT</button>';
    if (kind === 'nfz' && e) act = '<button class="dtc-act' + (d.nfActive[i] ? ' on' : '') + '" data-act="nfz" data-slot="' + i + '">ACT</button>';
    var del = e ? '<button class="dtc-del" data-del="' + kind + '" data-slot="' + i + '">DEL</button>' : '';
    return '<div class="' + cls + '" data-kind="' + kind + '" data-slot="' + i + '"><span class="dtc-num">' + dtcPad2(i + 1) + '</span>' +
      name + '<span class="dtc-info">' + info + '</span>' + act + del + '</div>';
  }

  function identOptions(kind, current) {
    var lists = state.idents || {};
    var names = kind === 'wp' ? (lists.wp || []).concat(lists.hz || []) : (lists[kind] || []);
    if (names.indexOf(current) < 0) names = [current].concat(names);
    return names.map(function (n) {
      return '<option value="' + escapeHtml(n) + '"' + (n === current ? ' selected' : '') + '>' + escapeHtml(n) + '</option>';
    }).join('');
  }

  function pointRow(kind, i, p) {
    var cls = 'dtc-row' + (state.sel[kind] === i ? ' sel' : '') + (p ? '' : ' empty');
    var id = '<span class="dtc-pid">' + dtcPointId(kind, i) + '</span>';
    if (!p) return '<div class="' + cls + '" data-kind="' + kind + '" data-slot="' + i + '">' + id + '<span class="dtc-info">EMPTY</span></div>';
    return '<div class="' + cls + '" data-kind="' + kind + '" data-slot="' + i + '">' + id +
      '<select class="dtc-pident" data-kind="' + kind + '" data-slot="' + i + '">' + identOptions(kind, p.ident) + '</select>' +
      '<input class="dtc-free" data-kind="' + kind + '" data-slot="' + i + '" maxlength="3" value="' + escapeHtml(p.free) + '">' +
      '<span class="dtc-info">' + escapeHtml(p.g ? p.g.slice(0, 4) + ' ' + p.g.slice(4, 8) : '') + '</span>' +
      '<button class="dtc-del" data-del="' + kind + '" data-slot="' + i + '">DEL</button></div>';
  }

  function renderRoutes() {
    var picker = el('dtcRoutePicker');
    if (picker) {
      var html = '';
      for (var r = 0; r < DTC_ROUTES; r++) {
        html += '<button type="button" class="dtc-route' + (r === state.route ? ' on' : '') + '" data-route="' + r + '">' +
          (r + 1) + (state.dtc.routes[r].length ? '*' : '') + '</button>';
      }
      picker.innerHTML = html;
    }
    var list = el('dtcRouteList');
    if (list) {
      var route = state.dtc.routes[state.route];
      list.innerHTML = route.length ? route.map(function (id, i) {
        var p = dtcPointAt(state.dtc, id);
        return '<div class="dtc-row"><span class="dtc-num">' + dtcPad2(i + 1) + '</span><span class="dtc-pid">' + id + '</span>' +
          '<span class="dtc-info">' + (p ? escapeHtml(p.ident) : 'NOT IN DTC') + '</span>' +
          '<button class="dtc-del" data-route-del="' + i + '">DEL</button></div>';
      }).join('') : '<div class="dtc-row empty"><span class="dtc-info">EMPTY</span></div>';
    }
  }

  function render() {
    var shapeLists = { dtcListLines: 'lines', dtcListAreas: 'areas', dtcListPf: 'pfz', dtcListNf: 'nfz' };
    Object.keys(shapeLists).forEach(function (id) {
      var e = el(id), kind = shapeLists[id];
      if (e) e.innerHTML = state.dtc[kind].map(function (x, i) { return shapeRow(kind, i, x); }).join('');
    });
    var pointLists = { dtcListWp: 'wp', dtcListCm: 'cm', dtcListTt: 'tt' };
    Object.keys(pointLists).forEach(function (id) {
      var e = el(id), kind = pointLists[id];
      if (e) e.innerHTML = state.dtc[kind].map(function (x, i) { return pointRow(kind, i, x); }).join('');
    });
    renderRoutes();
    var t = state.tool;
    eachNode('[data-dtc-tool]', function (b) {
      var on = !!t && getData(b, 'dtc-tool') === t.name && (!getData(b, 'kind') || getData(b, 'kind') === t.kind);
      b.classList.toggle('on', on);
    });
    eachNode('[data-dtc-action="finish"]', function (b) { b.disabled = !t || !t.verts || t.verts.length < t.min || t.box; });
    eachNode('[data-dtc-action="undo"]', function (b) { b.disabled = !t || !t.verts || !t.verts.length; });
    eachNode('[data-dtc-action="cancel"]', function (b) { b.disabled = !t; });
    eachNode('[data-dtc-action="shape"]', function (b) { b.textContent = 'SHAPE ' + (state.box ? 'BOX' : 'QUAD'); });
    eachNode('[data-dtc-action="single"]', function (b) { b.textContent = 'NF ACTIVE: ' + (state.dtc.nfSingle ? 'SINGLE' : 'MULTI'); });
    var name = el('dtcName');
    if (name && document.activeElement !== name) name.value = state.dtc.name;
    renderModal();
  }

  // ── The DTC dialog: saves by scope, and the DTC as text ──────────────────
  function modalOpen() {
    var m = el('dtcModal');
    return !!m && m.classList.contains('visible');
  }

  function openModal() {
    var m = el('dtcModal');
    if (!m) return;
    state.modal.selected = '';
    var n = el('dtcModalName');
    if (n) n.value = state.dtc.name;
    var t = el('dtcText');
    if (t) t.value = '';
    m.classList.add('visible');
    callSQF('["saves"] call fza_mplanner_fnc_dtcSeed;');
    renderModal();
  }

  function closeModal() {
    var m = el('dtcModal');
    if (m) m.classList.remove('visible');
  }

  function renderModal() {
    eachNode('[data-dtc-scope]', function (b) { b.classList.toggle('active', getData(b, 'dtc-scope') === state.modal.scope); });
    var list = el('dtcSaveList');
    if (!list) return;
    var saves = state.saves[state.modal.scope] || [];
    if (!saves.length) {
      list.innerHTML = '<div class="modal-hint">No DTCs saved here on this map.</div>';
      return;
    }
    list.innerHTML = saves.map(function (s) {
      return '<div class="save-entry' + (s.name === state.modal.selected ? ' selected' : '') + '" data-dtc-save="' + escapeHtml(s.name) + '">' +
        '<div class="name">' + escapeHtml(s.name) + '</div><div class="scope-badge">' + state.modal.scope.toUpperCase() + '</div>' +
        '<div class="meta">' + (s.by ? 'By ' + escapeHtml(s.by) : '') + '</div></div>';
    }).join('');
  }

  function modalName() {
    var n = el('dtcModalName');
    var name = String((n && n.value) || state.modal.selected || state.dtc.name || '').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 8);
    if (n) n.value = name;
    return name;
  }

  function chosenSave() {
    var name = state.modal.selected;
    var list = state.saves[state.modal.scope] || [];
    for (var i = 0; i < list.length; i++) if (list[i].name === name) return list[i];
    return null;
  }

  function openDtcObject(o, label) {
    state.dtc = dtcFromObject(o);
    state.tool = null;
    setStatus(label);
    changed();
  }

  // ── Events ───────────────────────────────────────────────────────────────
  document.addEventListener('click', function (ev) {
    var target = ev.target;
    var find = function (sel) { return target.closest ? target.closest(sel) : null; };
    var tool = find('[data-dtc-tool]');
    if (tool) {
      var name = getData(tool, 'dtc-tool'), kind = getData(tool, 'kind');
      if (state.tool && state.tool.name === name && (!kind || state.tool.kind === kind)) { cancelTool(); return; }
      if (TOOLS[name]) startTool(name); else startPointTool(name, kind || 'wp');
      return;
    }
    var action = find('[data-dtc-action]');
    if (action) {
      switch (getData(action, 'dtc-action')) {
        case 'finish': finishTool(); break;
        case 'undo': undoPoint(); break;
        case 'cancel': cancelTool(); break;
        case 'shape':
          state.box = !state.box;
          if (state.tool && TOOLS[state.tool.name] && TOOLS[state.tool.name].shape) startTool(state.tool.name); else render();
          break;
        case 'single':
          state.dtc.nfSingle = !state.dtc.nfSingle;
          if (state.dtc.nfSingle) {
            var first = state.dtc.nfActive.indexOf(true);
            state.dtc.nfActive = state.dtc.nfActive.map(function (a, i) { return i === first; });
          }
          changed();
          break;
        case 'route-undo':
          state.dtc.routes[state.route].pop();
          changed();
          break;
        case 'route-clear':
          state.dtc.routes[state.route] = [];
          changed();
          break;
      }
      return;
    }
    var routeBtn = find('[data-route]');
    if (routeBtn) {
      state.route = parseInt(getData(routeBtn, 'route'), 10) || 0;
      if (state.tool && state.tool.name === 'route') startPointTool('route', 'wp'); else changed();
      return;
    }
    if (target.hasAttribute && target.hasAttribute('data-route-del')) {
      state.dtc.routes[state.route].splice(parseInt(getData(target, 'route-del'), 10), 1);
      changed();
      return;
    }
    var act = getData(target, 'act');
    if (act) {
      var slot = parseInt(getData(target, 'slot'), 10);
      var d = state.dtc;
      if (act === 'pfz') {
        d.activePf = d.activePf === slot ? -1 : slot;
      } else {
        var on = !d.nfActive[slot];
        if (on && d.nfSingle) d.nfActive = d.nfActive.map(function () { return false; });
        d.nfActive[slot] = on;
      }
      changed();
      return;
    }
    var del = getData(target, 'del');
    if (del) {
      var s = parseInt(getData(target, 'slot'), 10);
      if (DTC_POINT_KINDS.indexOf(del) >= 0) {
        deletePoint(del, s);
      } else {
        state.dtc[del][s] = null;
        if (del === 'pfz' && state.dtc.activePf === s) state.dtc.activePf = -1;
        if (del === 'nfz') state.dtc.nfActive[s] = false;
      }
      changed();
      return;
    }
    var save = find('[data-dtc-save]');
    if (save) {
      state.modal.selected = getData(save, 'dtc-save');
      var n = el('dtcModalName');
      if (n) n.value = state.modal.selected;
      renderModal();
      return;
    }
    var scope = find('[data-dtc-scope]');
    if (scope) {
      state.modal.scope = getData(scope, 'dtc-scope');
      state.modal.selected = '';
      renderModal();
      return;
    }
    var row = find('.dtc-row');
    if (row && ['INPUT', 'SELECT', 'OPTION', 'BUTTON'].indexOf(target.tagName) < 0 && getData(row, 'kind')) {
      var k = getData(row, 'kind');
      var i = parseInt(getData(row, 'slot'), 10);
      state.sel[k] = state.sel[k] === i ? -1 : i;
      render();
    }
  });

  document.addEventListener('change', function (ev) {
    var t = ev.target;
    var kind = getData(t, 'kind');
    var slot = parseInt(getData(t, 'slot'), 10);
    if (t.classList && t.classList.contains('dtc-ident')) {
      var e = state.dtc[kind][slot];
      if (e) e.id = dtcIdent(t.value, dtcDefaultIdent(kind, slot));
      changed();
    } else if (t.classList && t.classList.contains('dtc-pident')) {
      var p = state.dtc[kind][slot];
      if (p) p.ident = String(t.value || '').toUpperCase();
      changed();
    } else if (t.classList && t.classList.contains('dtc-free')) {
      var q = state.dtc[kind][slot];
      if (q) q.free = String(t.value || '').toUpperCase().replace(/[^A-Z0-9 ]/g, '').slice(0, 3);
      render();
    } else if (t.id === 'dtcName') {
      state.dtc.name = String(t.value || '').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 8);
      t.value = state.dtc.name;
    }
  });

  document.addEventListener('keydown', function (ev) {
    if (!state.tool || ev.keyCode !== 8) return;
    var tag = (document.activeElement && document.activeElement.tagName) || '';
    if (tag === 'INPUT' || tag === 'SELECT' || tag === 'TEXTAREA') return;
    ev.preventDefault();
    if (state.tool.name === 'route') {
      state.dtc.routes[state.route].pop();
      changed();
    } else {
      undoPoint();
    }
  });

  function on(id, fn) {
    var e = el(id);
    if (e) e.addEventListener('click', fn);
  }

  function dtcJson() {
    return dtcToJson(state.dtc, state.world);
  }

  function bindButtons() {
    eachNode('[data-dtc-map]', function (area) {
      area.addEventListener('click', function (ev) {
        var r = rectOf(area);
        if (!(r[2] > 0 && r[3] > 0)) return;
        callSQF('["click",' + ((ev.pageX - r[0]) / r[2]) + ',' + ((ev.pageY - r[1]) / r[3]) + '] call fza_mplanner_fnc_dtcMap;');
      });
    });
    on('btnLoadDTC', function () {
      setStatus('Loading...');
      callSQF('[' + sqfQuotedString(dtcJson()) + '] call fza_mplanner_fnc_dtcStage;');
    });
    on('btnOpenDTCs', openModal);
    on('btnReadDTC', function () {
      setStatus('Reading the aircraft...');
      callSQF('["readback"] call fza_mplanner_fnc_dtcSeed;');
    });
    on('btnEdenDTC', function () {
      setStatus('Reading the mission...');
      callSQF('["eden"] call fza_mplanner_fnc_dtcSeed;');
    });
    on('btnNewDTC', function () {
      state.dtc = dtcEmpty();
      state.tool = null;
      setStatus('New DTC.');
      changed();
    });
    on('btnDtcModalClose', closeModal);
    on('btnDtcSave', function () {
      var name = modalName();
      if (!name) { setStatus('Name the DTC first.', true); return; }
      state.dtc.name = name;
      callSQF('[' + sqfQuotedString(state.modal.scope) + ',' + sqfQuotedString(name) + ',' + sqfQuotedString(dtcJson()) + '] call fza_mplanner_fnc_dtcSave;');
      state.modal.selected = name;
      setStatus('Saved ' + name + ' (' + state.modal.scope.toUpperCase() + ').');
      render();
    });
    on('btnDtcLoad', function () {
      var s = chosenSave();
      if (!s) return;
      var parsed = null;
      try { parsed = JSON.parse(s.json); } catch (e) { parsed = null; }
      if (!parsed) { setStatus('That DTC could not be read.', true); return; }
      if (!parsed.name) parsed.name = s.name;
      openDtcObject(parsed, 'Opened ' + s.name + '. Load DTC puts it in the aircraft.');
      closeModal();
    });
    on('btnDtcPush', function () {
      var name = modalName();
      if (!name) { setStatus('Name the DTC first.', true); return; }
      state.dtc.name = name;
      callSQF('["mission",' + sqfQuotedString(name) + ',' + sqfQuotedString(dtcJson()) + '] call fza_mplanner_fnc_dtcSave;');
      setStatus('Pushed ' + name + ' to the mission.');
      render();
    });
    on('btnDtcDelete', function () {
      var s = chosenSave();
      if (!s) return;
      callSQF('[' + sqfQuotedString(state.modal.scope) + ',' + sqfQuotedString(s.name) + '] call fza_mplanner_fnc_dtcDelete;');
      state.modal.selected = '';
      setStatus('Deleted ' + s.name + '.');
    });
    on('btnDtcExport', function () {
      var t = el('dtcText');
      if (!t) return;
      t.value = dtcJson();
      t.focus();
      t.select();
      var copied = false;
      try { copied = document.execCommand('copy'); } catch (e) { copied = false; }
      setStatus(copied ? 'The DTC is on the clipboard.' : 'Select the text and copy it.');
    });
    on('btnDtcImport', function () {
      var t = el('dtcText');
      var parsed = null;
      try { parsed = JSON.parse((t && t.value) || ''); } catch (e) { parsed = null; }
      if (!parsed || typeof parsed !== 'object') { setStatus('That text is not a DTC.', true); return; }
      openDtcObject(parsed, 'Imported ' + (parsed.name || 'a DTC') + '.');
      closeModal();
    });
  }

  function bindTabs() {
    eachNode('.tab', function (tab) {
      tab.addEventListener('click', function () {
        state.tab = getData(tab, 'tab');
        cancelTool();
        // After the page's own handler has shown the tab's panel
        setTimeout(function () { placeMap(0); sync(); }, 0);
      });
    });
    window.addEventListener('resize', function () { placeMap(0); });
    // The map is drawn over the page, so it goes while a dialog is open
    if (typeof MutationObserver !== 'undefined') {
      var observer = new MutationObserver(function () { placeMap(0); });
      eachNode('.modal-backdrop', function (m) { observer.observe(m, { attributes: true, attributeFilter: ['class'] }); });
    }
  }

  // Eden's points into the empty slots: its own number, else the first free one; ones already there are left
  function mergeEden(o) {
    var eden = dtcFromObject(o);
    var added = 0, skipped = 0;
    DTC_POINT_KINDS.forEach(function (kind) {
      var list = state.dtc[kind];
      eden[kind].forEach(function (p, i) {
        if (!p) return;
        var dupe = list.some(function (q) { return q && q.ident === p.ident && Math.abs(q.pt[0] - p.pt[0]) < 1 && Math.abs(q.pt[1] - p.pt[1]) < 1; });
        if (dupe) return;
        var slot = list[i] ? list.indexOf(null) : i;
        if (slot < 0) { skipped++; return; }
        list[slot] = p;
        added++;
      });
    });
    setStatus('Eden: ' + added + ' points added' + (skipped ? ', ' + skipped + ' with no free slot' : '') + '.', skipped > 0);
    changed();
  }

  window.fzaDtc = {
    onMapClick: function (x, y, z, grid, reach) { onMapClick(x, y, z, grid, reach); },
    onStaged: function (ok, message) { setStatus(message, !ok); },
    receiveSeed: function (payload) {
      if (!payload) return;
      state.world = payload.world || state.world;
      if (Array.isArray(payload.own)) state.saves = { own: payload.own, mission: payload.mission || [] };
      if (payload.idents) state.idents = payload.idents;
      var mode = payload.mode || 'open';
      if (mode === 'open' && !state.seeded) {
        state.seeded = true;
        state.dtc = dtcFromObject(payload.dtc);
        if (!state.dtc.name && payload.loaded) state.dtc.name = String(payload.loaded);
      } else if (mode === 'readback' && payload.dtc) {
        openDtcObject(payload.dtc, 'Read back what the aircraft holds.');
        return;
      } else if (mode === 'eden' && payload.dtc) {
        mergeEden(payload.dtc);
        return;
      }
      changed();
    },
    // ESC: the DTC dialog, then a drawing in progress, go before anything else
    escape: function () {
      if (modalOpen()) { closeModal(); return true; }
      return cancelTool();
    }
  };

  bindButtons();
  bindTabs();
  render();
}());
