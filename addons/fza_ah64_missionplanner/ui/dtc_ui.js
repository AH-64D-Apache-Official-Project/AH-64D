// The DTC tabs (points, routes, areas/zones, lines): lists, the Arma map laid over the page
// (fza_mplanner_fnc_dtcMap), points and shapes dragged from their lists onto the map and about it, the map's
// right-click menu, and the DTC box and its dialog: upload to the aircraft, saves, download from it, text
(function () {
  'use strict';

  // The shapes a list row or the menu puts on the map at a spot, and their tabs: a line 2 km long east to west, an
  // area or zone a box 1 km square
  var SHAPE_TABS = { lines: 'lines', areas: 'az', pfz: 'az', nfz: 'az' };
  var LINE_HALF = 1000, BOX_HALF = 500;
  // The line kinds' colours: the map's (fza_mplanner_fnc_dtcMapDraw's indices) and the menu's swatches, as the TSD
  // draws them, FLOT blue, FLET red, FSCL white, the others green
  var LINE_COLOURS = { PL: 0, BL: 0, FLOT: 6, FLET: 5, FSCL: 7 };
  var LINE_SWATCHES = { PL: '#00ff00', BL: '#00ff00', FLOT: '#6699ff', FLET: '#ff0000', FSCL: '#ffffff' };
  var MAP_TABS = { lines: true, az: true, wp: true, cm: true, tt: true, routes: true };
  // The seed's ident lists each point file takes, and a new point's ident
  var IDENT_LISTS = { wp: ['wp', 'hz'], cm: ['cm'], tt: ['tt', 'th'] };
  var POINT_DEFAULT = { wp: 'WP', cm: 'CP', tt: 'TG' };

  var state = {
    dtc: dtcEmpty(),
    world: '',
    seeded: false,
    tab: 'config',
    tool: null,
    // The one item selected, {kind, slot}: a point, line, area or zone, or an entry of the current route ('route')
    sel: null,
    route: 0,
    uploaded: '',
    idents: null,
    icons: null,
    saves: { own: [], mission: [] },
    // The DTC manager: its scope and the save chosen in it; pick while it is only there to open a DTC from
    modal: { scope: 'own', selected: '', pick: false },
    mapShown: false,
    mapRect: ''
  };
  // A point's or shape's row being dragged {kind, slot, x, y, moved}, or a press in the map area {map: true}
  var drag = null;
  // The click a drag ends with is not a click on the row
  var dragged = false;
  // The right-click menu: {px, py, point: id or null, shape: {kind, slot, seg} or null, at: [x, y, z, grid] or null,
  // stack: [level, ...]}
  var menu = null;

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
    fetchTerrain();
    render();
    sync();
  }

  function isSel(kind, slot) {
    return !!state.sel && state.sel.kind === kind && state.sel.slot === slot;
  }

  // An item selected: its row on its tab, highlighted on the map
  function selectItem(kind, slot) {
    var list = kind === 'route' ? state.dtc.routes[state.route] : state.dtc[kind];
    if (!list || !list[slot]) return;
    state.sel = { kind: kind, slot: slot };
    showTab(kind === 'route' ? 'routes' : IDENT_LISTS[kind] ? kind : SHAPE_TABS[kind]);
    render();
    sync();
    var row = document.querySelector('.dtc-row.sel[data-kind="' + kind + '"]');
    if (row && row.scrollIntoView) row.scrollIntoView({ block: 'nearest' });
  }

  // An item deleted: a point leaves any route it is on, a zone its active state
  function deleteItem(kind, slot) {
    if (kind === 'route') {
      state.dtc.routes[state.route].splice(slot, 1);
    } else if (IDENT_LISTS[kind]) {
      deletePoint(kind, slot);
    } else if (SHAPE_TABS[kind]) {
      state.dtc[kind][slot] = null;
      if (kind === 'pfz' && state.dtc.activePf === slot) state.dtc.activePf = -1;
      if (kind === 'nfz') state.dtc.nfActive[slot] = false;
    } else {
      return;
    }
    if (isSel(kind, slot)) state.sel = null;
    changed();
  }

  // The upload button yellow while the DTC differs from what was last uploaded to or downloaded from the aircraft
  function markUpload() {
    var b = el('btnLoadDTC');
    if (b) b.classList.toggle('pending', dtcJson() !== state.uploaded);
  }

  function uploaded() {
    state.uploaded = dtcJson();
    markUpload();
  }

  // The ground height under points that arrived with an MSL height but no ground (the aircraft, a save, text),
  // asked of the map, which answers with onTerrain in the same order
  var terrain = { wanted: [], askedAt: 0 };
  function fetchTerrain() {
    if (terrain.wanted.length && Date.now() - terrain.askedAt < 1000) return;
    var wanted = [], at = [];
    DTC_POINT_KINDS.forEach(function (kind) {
      state.dtc[kind].forEach(function (p, i) {
        if (p && p.t === undefined) { wanted.push([kind, i, p.pt[0], p.pt[1]]); at.push([p.pt[0], p.pt[1]]); }
      });
    });
    terrain.wanted = wanted;
    terrain.askedAt = Date.now();
    if (at.length) callSQF('["terrain",' + sqfQuotedString(JSON.stringify(at)) + '] call fza_mplanner_fnc_dtcMap;');
  }

  function identList(key) {
    return (state.idents || {})[key] || [];
  }

  // The idents a point file takes, with the one it has first when it isn't among them
  function identNames(kind, current) {
    var names = [];
    IDENT_LISTS[kind].forEach(function (key) { names = names.concat(identList(key)); });
    if (current && names.indexOf(current) < 0) names = [current].concat(names);
    return names;
  }

  // ── TSD icons: the ident's textures (tsd_icon_data.js) as images, tinted on a canvas to the colour the aircraft
  // draws them in once loaded, white as they are until then ──
  var iconImages = {}, iconTinted = {};
  function loadIcons() {
    if (typeof _tsdIconData === 'undefined') return;
    Object.keys(_tsdIconData).forEach(function (key) {
      if (iconImages[key]) return;
      var img = new Image();
      img.src = _tsdIconData[key];
      iconImages[key] = img;
    });
  }

  function tintedIcon(key, colour) {
    var id = key + '|' + colour;
    if (iconTinted[id]) return iconTinted[id];
    var img = iconImages[key];
    if (!img || !img.complete || !img.naturalWidth) return _tsdIconData[key];
    try {
      var c = document.createElement('canvas');
      c.width = img.naturalWidth;
      c.height = img.naturalHeight;
      var ctx = c.getContext('2d');
      ctx.drawImage(img, 0, 0);
      ctx.globalCompositeOperation = 'source-in';
      ctx.fillStyle = colour;
      ctx.fillRect(0, 0, c.width, c.height);
      iconTinted[id] = c.toDataURL();
    } catch (e) {
      iconTinted[id] = _tsdIconData[key];
    }
    return iconTinted[id];
  }

  function iconHtml(ident) {
    var ic = (state.icons || {})[ident];
    if (!ic || typeof _tsdIconData === 'undefined') return '';
    var c = ic[2] && ic[2].length >= 3 ? ic[2] : [0, 1, 0, 1];
    var colour = 'rgba(' + Math.round(c[0] * 255) + ',' + Math.round(c[1] * 255) + ',' + Math.round(c[2] * 255) + ',' + (c.length > 3 ? c[3] : 1) + ')';
    var layers = '';
    [ic[0], ic[1]].forEach(function (key) {
      if (key && _tsdIconData[key]) layers += '<img src="' + tintedIcon(key, colour) + '" alt="">';
    });
    return layers ? '<span class="dtc-icon">' + layers + '</span>' : '';
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

  // What the map draws: shapes [points, closed, colour, label, label at the ends, kind:slot for its vertex handles,
  // style 0 solid / 1 dashed / 2 alternating, handles at the segment middles to insert a vertex by, selected], points
  // [position, label, ident, free text, selected], the current route
  function sync() {
    if (!state.mapShown) return;
    var d = state.dtc, draw = [], points = [], route = [];
    // Only a phase line has its ident, at both ends; a line short of four points takes more
    d.lines.forEach(function (e, i) {
      if (!e) return;
      var kind = dtcLineKind(e.id);
      draw.push([e.pts, false, LINE_COLOURS[kind] || 0, kind === 'PL' ? e.id : '', true, 'lines:' + i, 0, e.pts.length < 4, isSel('lines', i)]);
    });
    // An area is labelled by its number, as the TSD does
    d.areas.forEach(function (e, i) { if (e) draw.push([e.pts, true, 1, 'EA' + dtcPad2(i + 1), false, 'areas:' + i, 0, false, isSel('areas', i)]); });
    // An active zone alternates its dashes, an inactive one is dashed
    d.pfz.forEach(function (e, i) { if (e) draw.push([e.pts, true, 2, 'PF' + (i + 1) + (d.activePf === i ? ' ACT' : ''), false, 'pfz:' + i, d.activePf === i ? 2 : 1, false, isSel('pfz', i)]); });
    d.nfz.forEach(function (e, i) { if (e) draw.push([e.pts, true, 3, 'NF' + (i + 1) + (d.nfActive[i] ? ' ACT' : ''), false, 'nfz:' + i, d.nfActive[i] ? 2 : 1, false, isSel('nfz', i)]); });
    DTC_POINT_KINDS.forEach(function (kind) {
      d[kind].forEach(function (p, i) { if (p) points.push([[p.pt[0], p.pt[1]], dtcPointId(kind, i), p.ident, p.free, isSel(kind, i)]); });
    });
    d.routes[state.route].forEach(function (id) {
      var p = dtcPointAt(d, id);
      if (p) route.push([p.pt[0], p.pt[1]]);
    });
    callSQF('["sync",' + sqfQuotedString(JSON.stringify({ d: draw, p: points, r: route })) + '] call fza_mplanner_fnc_dtcMap;');
  }

  // A map press as fractions of the active map area, or null without one
  function mapFraction(ev) {
    var area = activeMapArea();
    if (!area) return null;
    var r = rectOf(area);
    if (!(r[2] > 0 && r[3] > 0)) return null;
    return { x: (ev.pageX - r[0]) / r[2], y: (ev.pageY - r[1]) / r[3] };
  }

  function overMap(f) {
    return !!f && f.x >= 0 && f.x <= 1 && f.y >= 0 && f.y <= 1;
  }

  function mapCall(mode, f, extra) {
    callSQF('["' + mode + '",' + f.x.toFixed(4) + ',' + f.y.toFixed(4) + (extra || '') + '] call fza_mplanner_fnc_dtcMap;');
  }

  function showTab(name) {
    var tab = document.querySelector('.tab[data-tab="' + name + '"]');
    if (tab && state.tab !== name) tab.click();
  }

  // ── Placing ──────────────────────────────────────────────────────────────
  // The selected empty slot, else the first empty one
  function freeSlot(kind) {
    var sel = state.sel;
    var list = state.dtc[kind];
    if (sel && sel.kind === kind && !list[sel.slot]) return sel.slot;
    return list.indexOf(null);
  }

  // The route tool: points clicked on the map join the route
  function startRouteTool() {
    state.tool = { name: 'route', kind: 'wp' };
    setStatus('Click points on the map to add them to route ' + (state.route + 1) + '.');
    changed();
  }

  function cancelTool() {
    if (!state.tool) return false;
    state.tool = null;
    setStatus('');
    changed();
    return true;
  }

  // A new shape centred on a spot: a line of fixed length, else a box of fixed size
  function fixedShape(kind, x, y, z) {
    if (kind === 'lines') return [[x - LINE_HALF, y, z], [x + LINE_HALF, y, z]];
    return dtcBox([x - BOX_HALF, y - BOX_HALF, z], [x + BOX_HALF, y + BOX_HALF, z]);
  }

  // A new line's ident by its kind: PL and BL numbered by the slot, the others their kind alone
  function newLineId(lineKind, slot) {
    if (lineKind === 'PL' || lineKind === 'BL') return lineKind + dtcDefaultIdent('lines', slot).slice(2);
    return lineKind;
  }

  // A slot's shape put on the map: the one there moves whole, its centre to the spot; an empty slot gets a new shape
  // there
  function placeShape(kind, slot, x, y, z) {
    var list = state.dtc[kind];
    if (!list || slot < 0 || slot >= list.length) return;
    var e = list[slot];
    if (e) {
      var cx = 0, cy = 0;
      e.pts.forEach(function (p) { cx += p[0] / e.pts.length; cy += p[1] / e.pts.length; });
      e.pts = e.pts.map(function (p) { return [p[0] + x - cx, p[1] + y - cy, p[2]]; });
    } else if (kind === 'pfz' || kind === 'nfz') {
      list[slot] = { pts: fixedShape(kind, x, y, z) };
    } else {
      list[slot] = { id: dtcDefaultIdent(kind, slot), pts: fixedShape(kind, x, y, z) };
    }
    state.sel = { kind: kind, slot: slot };
    setStatus('');
    changed();
  }

  // A new shape in the file's chosen empty slot, else its first; a line of the kind chosen
  function addShape(kind, x, y, z, lineKind) {
    showTab(SHAPE_TABS[kind]);
    var slot = freeSlot(kind);
    if (slot < 0) { setStatus('That file is full.', true); return; }
    placeShape(kind, slot, x, y, z);
    if (kind === 'lines' && lineKind) {
      state.dtc.lines[slot].id = newLineId(lineKind, slot);
      changed();
    }
  }

  // A vertex put into a line after the one its segment starts at, while it has fewer than four
  function insertVertex(slot, seg, x, y, z) {
    var e = state.dtc.lines[slot];
    if (!e || e.pts.length >= 4 || seg < 0 || seg >= e.pts.length - 1) return;
    e.pts.splice(seg + 1, 0, [x, y, z]);
    state.sel = { kind: 'lines', slot: slot };
    setStatus('');
    changed();
  }

  // The nearest point a route takes: targets and threats never
  function nearestPoint(x, y, reach) {
    var best = null, bestD = reach;
    DTC_POINT_KINDS.forEach(function (kind) {
      if (kind === 'tt') return;
      state.dtc[kind].forEach(function (p, i) {
        if (!p) return;
        var dd = Math.sqrt(Math.pow(p.pt[0] - x, 2) + Math.pow(p.pt[1] - y, 2));
        if (dd <= bestD) { bestD = dd; best = dtcPointId(kind, i); }
      });
    });
    return best;
  }

  // A click on the map: with the route tool the point there joins the route; else the point or shape there (a point
  // id, or kind:slot) is selected, and empty map clears the selection
  function onMapClick(x, y, z, grid, reach, hit) {
    var t = state.tool;
    if (t && t.name === 'route') {
      var id = nearestPoint(x, y, Math.max(reach || 0, 50));
      if (!id) { setStatus('No point there.', true); return; }
      var route = state.dtc.routes[state.route];
      if (route.length >= 50) { setStatus('That route is full.', true); return; }
      route.push(id);
      setStatus('Added ' + id + ' to route ' + (state.route + 1) + '.');
      changed();
      return;
    }
    if (!hit) {
      if (state.sel) { state.sel = null; changed(); }
      return;
    }
    var at = dtcPointSlot(hit);
    if (at) { selectItem(at.kind, at.slot); return; }
    var parts = String(hit).split(':');
    if (SHAPE_TABS[parts[0]]) selectItem(parts[0], parseInt(parts[1], 10));
  }

  // A slot's point put on the map, z the ground there: the one there moves, keeping its height above the ground; an
  // empty slot gets a new point on the ground
  function placePoint(kind, slot, x, y, z, grid) {
    var list = state.dtc[kind];
    if (!list || slot < 0 || slot >= list.length) return;
    var p = list[slot];
    if (p) {
      var agl = p.t === undefined ? 0 : Math.max(0, p.pt[2] - p.t);
      p.pt = [x, y, z + agl];
      p.g = grid || '';
      p.t = z;
    } else {
      list[slot] = { ident: POINT_DEFAULT[kind], free: '', pt: [x, y, z], g: grid || '', t: z };
    }
    state.sel = { kind: kind, slot: slot };
    setStatus('');
    changed();
  }

  // A new point with that ident, in the file's chosen empty slot, else its first
  function addPoint(kind, ident, x, y, z, grid) {
    showTab(kind);
    var slot = freeSlot(kind);
    if (slot < 0) { setStatus('That file is full.', true); return; }
    state.dtc[kind][slot] = { ident: ident, free: '', pt: [x, y, z], g: grid || '', t: z };
    state.sel = { kind: kind, slot: slot };
    setStatus('');
    changed();
  }

  function movePoint(id, x, y, z, grid) {
    var at = dtcPointSlot(id);
    if (at && state.dtc[at.kind][at.slot]) placePoint(at.kind, at.slot, x, y, z, grid);
  }

  // A line's, area's or zone's vertex dragged; a four-cornered shape must still have uncrossed sides
  function moveVertex(kind, slot, index, x, y, z) {
    var e = state.dtc[kind] && state.dtc[kind][slot];
    if (!e || !e.pts[index]) return;
    var pts = e.pts.slice();
    pts[index] = [x, y, z];
    if (kind !== 'lines' && pts.length === 4) {
      pts = dtcValidQuad(pts);
      if (!pts) { setStatus('Its sides would cross or it would have no area: that corner stays.', true); return; }
    }
    e.pts = pts;
    state.sel = { kind: kind, slot: slot };
    setStatus('');
    changed();
  }

  // A point swaps slots with its neighbour; routes follow it
  function shiftPoint(kind, slot, dir) {
    var list = state.dtc[kind], j = slot + dir;
    if (!list[slot] || j < 0 || j >= list.length) return;
    var a = dtcPointId(kind, slot), b = dtcPointId(kind, j);
    var t = list[slot];
    list[slot] = list[j];
    list[j] = t;
    state.dtc.routes = state.dtc.routes.map(function (r) {
      return r.map(function (id) { return id === a ? b : id === b ? a : id; });
    });
    state.sel = { kind: kind, slot: j };
    changed();
    var row = document.querySelector('.dtc-row.sel[data-kind="' + kind + '"]');
    if (row && row.scrollIntoView) row.scrollIntoView({ block: 'nearest' });
  }

  function deletePoint(kind, slot) {
    var id = dtcPointId(kind, slot);
    state.dtc[kind][slot] = null;
    state.dtc.routes = state.dtc.routes.map(function (r) { return r.filter(function (x) { return x !== id; }); });
  }

  // ── The row being dragged ────────────────────────────────────────────────
  // What a shape's row is called: its ident, a zone's number
  function shapeName(kind, slot, e) {
    if (kind === 'pfz' || kind === 'nfz') return (kind === 'pfz' ? 'PF' : 'NF') + (slot + 1);
    return e ? e.id : dtcDefaultIdent(kind, slot);
  }

  function ghost(ev) {
    var g = el('dtcDragGhost');
    if (!g) return;
    if (!ev) { g.classList.remove('on'); document.body.classList.remove('dtc-dragging'); return; }
    if (!g.classList.contains('on')) {
      var p = state.dtc[drag.kind][drag.slot];
      g.innerHTML = IDENT_LISTS[drag.kind] ? (p ? iconHtml(p.ident) : '') + dtcPointId(drag.kind, drag.slot) : escapeHtml(shapeName(drag.kind, drag.slot, p));
      g.classList.add('on');
      document.body.classList.add('dtc-dragging');
    }
    g.style.left = ev.pageX + 'px';
    g.style.top = ev.pageY + 'px';
  }

  // ── The map's right-click menu ───────────────────────────────────────────
  function identLevel(title, kind, keys, current) {
    var names = [];
    keys.forEach(function (key) { names = names.concat(identList(key)); });
    if (current && names.indexOf(current) < 0) names = [current].concat(names);
    return { title: title, wide: true, items: names.map(function (n) { return { label: n, icon: n, ident: n, kind: kind, on: n === current }; }) };
  }

  // A point's menu: its ident, the route to add it to (a route with points is starred; targets and threats take no
  // route), and its deletion
  function pointLevel(id, kind, current) {
    var items = [{ label: 'IDENT', sub: identLevel('IDENT', kind, IDENT_LISTS[kind], current) }];
    if (kind !== 'tt') {
      var routes = state.dtc.routes.map(function (r, i) {
        return { label: 'ROUTE ' + (i + 1) + (r.length ? '*' : ''), route: i, on: r.indexOf(id) >= 0 };
      });
      items.push({ label: 'ADD TO ROUTE', sub: { title: 'ADD TO ROUTE', items: routes } });
    }
    items.push({ label: 'DELETE', del: true });
    return { title: id, items: items };
  }

  // The line kinds, each with its colour; the line's own kind marked
  function lineKindLevel(current) {
    return { title: 'LINE', items: DTC_LINE_KINDS.map(function (k) {
      return { label: k, swatch: LINE_SWATCHES[k], lineKind: k, shape: 'lines', on: k === current };
    }) };
  }

  // A shape's menu: a line's kind, and a point inserted where it was clicked while it has fewer than four; any
  // shape's deletion
  function shapeLevel(kind, slot) {
    var e = state.dtc[kind][slot];
    var items = [];
    if (kind === 'lines') {
      items.push({ label: 'LINE', sub: lineKindLevel(dtcLineKind(e.id)) });
      if (e.pts.length < 4) items.push({ label: 'INSERT POINT', insert: true });
    }
    items.push({ label: 'DELETE', del: true });
    return { title: shapeName(kind, slot, e), items: items };
  }

  // What to add at the spot right-clicked, in the aircraft's terms
  function drawLevel() {
    return { title: 'ADD', items: [
      { label: 'WAYPOINT', sub: identLevel('WAYPOINT', 'wp', ['wp']) },
      { label: 'HAZARD', sub: identLevel('HAZARD', 'wp', ['hz']) },
      { label: 'CONTROL MEASURE', sub: identLevel('CONTROL MEASURE', 'cm', ['cm']) },
      { label: 'TARGET', sub: identLevel('TARGET', 'tt', ['tt']) },
      { label: 'THREAT', sub: identLevel('THREAT', 'tt', ['th']) },
      { label: 'LINE', sub: lineKindLevel('') },
      { label: 'AREA', sub: { title: 'AREA', items: [
        { label: 'AREA', shape: 'areas' },
        { label: 'PFZ', shape: 'pfz' },
        { label: 'NFZ', shape: 'nfz' }
      ] } }
    ] };
  }

  function openMenu(px, py, point, at, level, shape) {
    menu = { px: px, py: py, point: point, shape: shape || null, at: at, stack: [level] };
    renderMenu();
  }

  function renderMenu() {
    var m = el('dtcMenu');
    if (!m || !menu) return;
    var level = menu.stack[menu.stack.length - 1];
    var back = menu.stack.length > 1;
    var html = '<div class="dtc-menu-title' + (back ? ' back' : '') + '" data-menu-back="' + (back ? '1' : '') + '">' +
      (back ? '&#8249; ' : '') + escapeHtml(level.title) + '</div>';
    level.items.forEach(function (item, i) {
      html += '<div class="dtc-menu-item' + (item.on ? ' on' : '') + (item.sub ? ' sub' : '') + '" data-menu-item="' + i + '">' +
        (item.icon ? iconHtml(item.icon) : '') + (item.swatch ? '<span class="dtc-swatch" style="background:' + item.swatch + '"></span>' : '') +
        escapeHtml(item.label) + '</div>';
    });
    m.innerHTML = html;
    m.className = 'dtc-menu on' + (level.wide ? ' wide' : '');
    var x = Math.round(menu.px * window.innerWidth), y = Math.round(menu.py * window.innerHeight);
    x = Math.max(0, Math.min(x, window.innerWidth - m.offsetWidth - 4));
    y = Math.max(0, Math.min(y, window.innerHeight - m.offsetHeight - 4));
    m.style.left = x + 'px';
    m.style.top = y + 'px';
  }

  function closeMenu() {
    if (!menu) return false;
    menu = null;
    var m = el('dtcMenu');
    if (m) m.className = 'dtc-menu';
    return true;
  }

  function chooseMenuItem(i) {
    var level = menu.stack[menu.stack.length - 1];
    var item = level.items[i];
    if (!item) return;
    if (item.sub) { menu.stack.push(item.sub); renderMenu(); return; }
    var point = menu.point, at = menu.at, shape = menu.shape;
    closeMenu();
    if (item.del) {
      var target = point ? dtcPointSlot(point) : shape;
      if (target) deleteItem(target.kind, target.slot);
    } else if (item.ident && point) {
      var slot = dtcPointSlot(point);
      var p = slot && state.dtc[slot.kind][slot.slot];
      if (p) { p.ident = item.ident; changed(); }
    } else if (typeof item.route === 'number' && point) {
      var route = state.dtc.routes[item.route];
      if (route.length >= 50) { setStatus('Route ' + (item.route + 1) + ' is full.', true); return; }
      route.push(point);
      setStatus('Added ' + point + ' to route ' + (item.route + 1) + '.');
      changed();
    } else if (item.ident && at) {
      addPoint(item.kind, item.ident, at[0], at[1], at[2], at[3]);
    } else if (item.lineKind && shape) {
      // The line's kind changes, its own characters kept as far as they fit
      var e = state.dtc.lines[shape.slot];
      if (e) { e.id = item.lineKind + dtcLineSuffix(e.id).slice(0, 5 - item.lineKind.length); changed(); }
    } else if (item.insert && shape && at) {
      insertVertex(shape.slot, shape.seg, at[0], at[1], at[2]);
    } else if (item.shape && at) {
      addShape(item.shape, at[0], at[1], at[2], item.lineKind);
    }
  }

  // ── Lists ────────────────────────────────────────────────────────────────
  function shapeRow(kind, i, e) {
    var d = state.dtc;
    var cls = 'dtc-row' + (isSel(kind, i) ? ' sel' : '') + (e ? '' : ' empty');
    var name = '';
    if (kind === 'lines') {
      if (e) {
        var lk = dtcLineKind(e.id);
        name = '<select class="dtc-lkind" data-slot="' + i + '">' + DTC_LINE_KINDS.map(function (k) {
          return '<option value="' + k + '"' + (k === lk ? ' selected' : '') + '>' + k + '</option>';
        }).join('') + '</select><input class="dtc-lsuffix" data-slot="' + i + '" maxlength="' + (5 - lk.length) + '" value="' + escapeHtml(dtcLineSuffix(e.id)) + '">';
      } else {
        name = '<span class="dtc-none">--</span>';
      }
    } else if (kind === 'areas') {
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
    return identNames(kind, current).map(function (n) {
      return '<option value="' + escapeHtml(n) + '"' + (n === current ? ' selected' : '') + '>' + escapeHtml(n) + '</option>';
    }).join('');
  }

  var FEET = 3.28084;

  // A point's height above the ground in feet, once the ground under it is known
  function pointAgl(p) {
    return p.t === undefined ? '' : String(Math.max(0, Math.round((p.pt[2] - p.t) * FEET)));
  }

  function pointHead() {
    return '<div class="dtc-row dtc-head"><span class="dtc-pid">#</span><span class="dtc-w-ident">IDENT</span>' +
      '<span class="dtc-w-free">FREE</span><span class="dtc-grid">GRID</span><span class="dtc-w-alt">ALT</span></div>';
  }

  function pointRow(kind, i, p) {
    var cls = 'dtc-row' + (isSel(kind, i) ? ' sel' : '') + (p ? '' : ' empty');
    var id = '<span class="dtc-pid">' + dtcPointId(kind, i) + '</span>';
    if (!p) return '<div class="' + cls + '" data-kind="' + kind + '" data-slot="' + i + '">' + id + '<span class="dtc-info">EMPTY</span></div>';
    var at = ' data-kind="' + kind + '" data-slot="' + i + '"';
    return '<div class="' + cls + '"' + at + '>' + id +
      '<select class="dtc-pident"' + at + '>' + identOptions(kind, p.ident) + '</select>' +
      '<input class="dtc-free"' + at + ' maxlength="3" value="' + escapeHtml(p.free) + '">' +
      '<span class="dtc-grid">' + escapeHtml(p.g ? p.g.slice(0, 4) + ' ' + p.g.slice(4, 8) : '') + '</span>' +
      '<span class="dtc-w-alt"><input class="dtc-alt"' + at + ' maxlength="5" value="' + pointAgl(p) + '"><span class="dtc-unit">A</span></span>' +
      '<button class="dtc-shift" data-shift="-1"' + at + ' title="Up">&#9650;</button>' +
      '<button class="dtc-shift" data-shift="1"' + at + ' title="Down">&#9660;</button>' +
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
        return '<div class="dtc-row' + (isSel('route', i) ? ' sel' : '') + '" data-kind="route" data-slot="' + i + '"><span class="dtc-num">' + dtcPad2(i + 1) + '</span><span class="dtc-pid">' + id + '</span>' +
          '<span class="dtc-info">' + (p ? escapeHtml(p.ident) : 'NOT IN DTC') + '</span>' +
          '<button class="dtc-del" data-del="route" data-slot="' + i + '">DEL</button></div>';
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
      if (e) e.innerHTML = pointHead() + state.dtc[kind].map(function (x, i) { return pointRow(kind, i, x); }).join('');
    });
    renderRoutes();
    eachNode('[data-dtc-tool]', function (b) { b.classList.toggle('on', !!state.tool && getData(b, 'dtc-tool') === state.tool.name); });
    eachNode('[data-dtc-action="single"]', function (b) { b.textContent = 'NF ACTIVE: ' + (state.dtc.nfSingle ? 'SINGLE' : 'MULTI'); });
    var name = el('dtcName');
    if (name && document.activeElement !== name) name.value = state.dtc.name;
    markUpload();
    renderModal();
  }

  // ── The DTC dialog: saves by scope, and the DTC as text ──────────────────
  function modalOpen() {
    var m = el('dtcModal');
    return !!m && m.classList.contains('visible');
  }

  // The DTC manager, or with pick the same lists only, to open one from
  function openModal(pick) {
    var m = el('dtcModal');
    if (!m) return;
    state.modal.selected = '';
    state.modal.pick = !!pick;
    var n = el('dtcModalName');
    if (n) n.value = state.dtc.name;
    var t = el('dtcText');
    if (t) t.value = '';
    m.classList.add('visible');
    m.classList.toggle('pick', state.modal.pick);
    callSQF('["saves"] call fza_mplanner_fnc_dtcSeed;');
    renderModal();
  }

  // A saved DTC opened into the planner
  function openSave(s) {
    var parsed = null;
    try { parsed = JSON.parse(s.json); } catch (e) { parsed = null; }
    if (!parsed) { setStatus('That DTC could not be read.', true); return; }
    if (!parsed.name) parsed.name = s.name;
    openDtcObject(parsed, 'Opened ' + s.name + '. Upload to Acft puts it in the aircraft.');
    closeModal();
  }

  function closeModal() {
    var m = el('dtcModal');
    if (m) m.classList.remove('visible');
  }

  function renderModal() {
    eachNode('[data-dtc-scope]', function (b) { b.classList.toggle('active', getData(b, 'dtc-scope') === state.modal.scope); });
    var title = el('dtcModalTitle');
    if (title) title.textContent = state.modal.pick ? 'OPEN DTC' : 'DTC MANAGER';
    var hint = el('dtcModalHint');
    if (hint) {
      hint.textContent = state.modal.pick ? 'Click a DTC to open it in the planner; Upload to Acft then puts it in the aircraft, for the crew to load with DTU MASTER LOAD.' :
        'Push to Mission shares the named DTC with everyone in the mission; Delete removes the selected one.';
    }
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
  // A left press: a point's or shape's row picked up, or a press in the map area handed to the map
  document.addEventListener('mousedown', function (ev) {
    var target = ev.target;
    var find = function (sel) { return target.closest ? target.closest(sel) : null; };
    if (ev.button !== 0 || find('#dtcMenu')) return;
    closeMenu();
    var row = find('.dtc-row');
    var rowKind = row ? getData(row, 'kind') : '';
    if (row && (IDENT_LISTS[rowKind] || SHAPE_TABS[rowKind]) && ['INPUT', 'SELECT', 'OPTION', 'BUTTON'].indexOf(target.tagName) < 0) {
      drag = { kind: getData(row, 'kind'), slot: parseInt(getData(row, 'slot'), 10), x: ev.pageX, y: ev.pageY, moved: false };
      ev.preventDefault();
      return;
    }
    if (find('[data-dtc-map]')) {
      var f = mapFraction(ev);
      if (f) { drag = { map: true }; mapCall('down', f); }
    }
  });

  document.addEventListener('mousemove', function (ev) {
    if (!drag || drag.map) return;
    if (!drag.moved && Math.abs(ev.pageX - drag.x) + Math.abs(ev.pageY - drag.y) < 4) return;
    drag.moved = true;
    ghost(ev);
  });

  document.addEventListener('mouseup', function (ev) {
    if (!drag || ev.button !== 0) return;
    var d = drag;
    drag = null;
    var f = mapFraction(ev);
    if (d.map) { if (f) mapCall('up', f); return; }
    ghost(null);
    // The click this release raises, if any, comes before the timeout
    dragged = d.moved;
    setTimeout(function () { dragged = false; }, 0);
    if (d.moved && overMap(f)) mapCall('drop', f, ',' + sqfQuotedString(d.kind) + ',' + d.slot);
  });

  // A right click in the map area: the map's menu; the browser's own menu nowhere
  document.addEventListener('contextmenu', function (ev) {
    var tag = (ev.target && ev.target.tagName) || '';
    if (tag === 'INPUT' || tag === 'TEXTAREA') return;
    ev.preventDefault();
    closeMenu();
    if (ev.target.closest && ev.target.closest('[data-dtc-map]')) {
      var f = mapFraction(ev);
      if (f) mapCall('menu', f);
    }
  });

  // The wheel over the map area zooms it about the mouse
  document.addEventListener('wheel', function (ev) {
    if (!(ev.target.closest && ev.target.closest('[data-dtc-map]'))) return;
    ev.preventDefault();
    var f = mapFraction(ev);
    if (f && ev.deltaY) mapCall('zoom', f, ',' + (ev.deltaY < 0));
  }, { passive: false });

  document.addEventListener('click', function (ev) {
    var target = ev.target;
    var find = function (sel) { return target.closest ? target.closest(sel) : null; };
    if (dragged) { dragged = false; return; }
    var item = find('[data-menu-item]');
    if (item && menu) { chooseMenuItem(parseInt(getData(item, 'menu-item'), 10)); return; }
    var back = find('[data-menu-back]');
    if (back && menu) {
      if (getData(back, 'menu-back')) { menu.stack.pop(); renderMenu(); }
      return;
    }
    var tool = find('[data-dtc-tool]');
    if (tool) {
      if (state.tool) cancelTool(); else startRouteTool();
      return;
    }
    var action = find('[data-dtc-action]');
    if (action) {
      switch (getData(action, 'dtc-action')) {
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
      if (state.tool && state.tool.name === 'route') startRouteTool(); else changed();
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
    var shift = getData(target, 'shift');
    if (shift) {
      shiftPoint(getData(target, 'kind'), parseInt(getData(target, 'slot'), 10), parseInt(shift, 10));
      return;
    }
    var del = getData(target, 'del');
    if (del) {
      deleteItem(del, parseInt(getData(target, 'slot'), 10));
      return;
    }
    var save = find('[data-dtc-save]');
    if (save) {
      state.modal.selected = getData(save, 'dtc-save');
      if (state.modal.pick) {
        var s = chosenSave();
        if (s) openSave(s);
        return;
      }
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
      state.sel = isSel(k, i) ? null : { kind: k, slot: i };
      render();
      sync();
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
    } else if (t.classList && (t.classList.contains('dtc-lkind') || t.classList.contains('dtc-lsuffix'))) {
      var line = state.dtc.lines[slot];
      var row = t.closest ? t.closest('.dtc-row') : null;
      if (line && row) {
        var lkind = row.querySelector('.dtc-lkind').value;
        var suffix = String(row.querySelector('.dtc-lsuffix').value || '').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 5 - lkind.length);
        line.id = lkind + suffix;
      }
      changed();
    } else if (t.classList && t.classList.contains('dtc-pident')) {
      var p = state.dtc[kind][slot];
      if (p) p.ident = String(t.value || '').toUpperCase();
      changed();
    } else if (t.classList && t.classList.contains('dtc-free')) {
      var q = state.dtc[kind][slot];
      if (q) q.free = String(t.value || '').toUpperCase().replace(/[^A-Z0-9 ]/g, '').slice(0, 3);
      changed();
    } else if (t.classList && t.classList.contains('dtc-alt')) {
      // Feet above the ground, kept as the MSL height the aircraft takes
      var a = state.dtc[kind][slot];
      var ft = parseInt(String(t.value || '').replace(/[^0-9]/g, ''), 10);
      if (a && a.t !== undefined && !isNaN(ft)) a.pt[2] = Math.round((a.t + ft / FEET) * 10) / 10;
      changed();
    } else if (t.id === 'dtcName') {
      state.dtc.name = String(t.value || '').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 8);
      t.value = state.dtc.name;
      markUpload();
    }
  });

  function typing() {
    var tag = (document.activeElement && document.activeElement.tagName) || '';
    return tag === 'INPUT' || tag === 'SELECT' || tag === 'TEXTAREA';
  }

  // Delete removes the selected item, Backspace takes the last point off the route being built, W A S D move the map
  // north, south, west, east
  document.addEventListener('keydown', function (ev) {
    if (typing() || !state.mapShown) return;
    var key = ev.key || '';
    if (key === 'Delete' || ev.keyCode === 46) {
      ev.preventDefault();
      if (state.sel) deleteItem(state.sel.kind, state.sel.slot);
      return;
    }
    if (ev.keyCode === 8) {
      if (!state.tool) return;
      ev.preventDefault();
      state.dtc.routes[state.route].pop();
      changed();
      return;
    }
    var step = { w: [0, 1], s: [0, -1], a: [-1, 0], d: [1, 0] }[key.toLowerCase()];
    if (step) {
      ev.preventDefault();
      callSQF('["nudge",' + step[0] * 0.1 + ',' + step[1] * 0.1 + '] call fza_mplanner_fnc_dtcMap;');
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
    on('btnLoadDTC', function () {
      setStatus('Loading...');
      callSQF('[' + sqfQuotedString(dtcJson()) + '] call fza_mplanner_fnc_dtcStage;');
    });
    on('btnOpenDTCs', function () { openModal(false); });
    on('btnOpenDTC', function () { openModal(true); });
    // Saved to OWN under the box's name
    on('btnSaveDTC', function () {
      var name = state.dtc.name;
      if (!name) { setStatus('Name the DTC first.', true); return; }
      callSQF('["own",' + sqfQuotedString(name) + ',' + sqfQuotedString(dtcJson()) + '] call fza_mplanner_fnc_dtcSave;');
      setStatus('Saved ' + name + ' (OWN).');
    });
    on('btnReadDTC', function () {
      setStatus('Reading the aircraft...');
      callSQF('["readback"] call fza_mplanner_fnc_dtcSeed;');
    });
    on('btnNewDTC', function () {
      state.dtc = dtcEmpty();
      state.tool = null;
      setStatus('New DTC.');
      changed();
    });
    on('btnDtcModalClose', closeModal);
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
        closeMenu();
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

  window.fzaDtc = {
    onMapClick: function (x, y, z, grid, reach, hit) { onMapClick(x, y, z, grid, reach, hit); },
    onPointMoved: function (id, x, y, z, grid) { movePoint(id, x, y, z, grid); },
    onVertexMoved: function (kind, slot, index, x, y, z) { moveVertex(kind, slot, index, x, y, z); },
    onTerrain: function (heights) {
      if (!Array.isArray(heights)) heights = [];
      // Only to a point still where it was asked about
      terrain.wanted.forEach(function (w, i) {
        var p = state.dtc[w[0]][w[1]];
        if (p && p.pt[0] === w[2] && p.pt[1] === w[3] && typeof heights[i] === 'number') p.t = heights[i];
      });
      terrain.wanted = [];
      render();
    },
    onMapDrop: function (x, y, z, grid, kind, slot) {
      if (IDENT_LISTS[kind]) placePoint(kind, slot, x, y, z, grid);
      else if (SHAPE_TABS[kind]) placeShape(kind, slot, x, y, z);
    },
    // A segment's middle handle picked up: the new vertex it becomes, which the map goes on dragging
    onVertexInsert: function (slot, seg, x, y, z) { insertVertex(slot, seg, x, y, z); },
    // A right click: the menu for the point there, the shape there, or for that spot
    onPointMenu: function (id, px, py) {
      var at = dtcPointSlot(id);
      var p = at && state.dtc[at.kind][at.slot];
      if (p) openMenu(px, py, id, null, pointLevel(id, at.kind, p.ident));
    },
    onShapeMenu: function (kind, slot, seg, px, py, x, y, z, grid) {
      if (SHAPE_TABS[kind] && state.dtc[kind][slot]) openMenu(px, py, null, [x, y, z, grid], shapeLevel(kind, slot), { kind: kind, slot: slot, seg: seg });
    },
    onMapMenu: function (px, py, x, y, z, grid) {
      openMenu(px, py, null, [x, y, z, grid], drawLevel());
    },
    onStaged: function (ok, message) {
      setStatus(message, !ok);
      if (ok) uploaded();
    },
    receiveSeed: function (payload) {
      if (!payload) return;
      state.world = payload.world || state.world;
      if (Array.isArray(payload.own)) state.saves = { own: payload.own, mission: payload.mission || [] };
      if (payload.idents) state.idents = payload.idents;
      if (payload.icons) { state.icons = payload.icons; loadIcons(); }
      var mode = payload.mode || 'open';
      if (mode === 'open' && !state.seeded) {
        state.seeded = true;
        state.dtc = dtcFromObject(payload.dtc);
        if (!state.dtc.name && payload.loaded) state.dtc.name = String(payload.loaded);
        state.uploaded = dtcJson();
      } else if (mode === 'readback' && payload.dtc) {
        openDtcObject(payload.dtc, 'Downloaded what the aircraft holds.');
        uploaded();
        return;
      }
      changed();
    },
    // ESC: the DTC dialog, then the map's menu, a row being dragged, a drawing in progress, go before anything else
    escape: function () {
      if (modalOpen()) { closeModal(); return true; }
      if (closeMenu()) return true;
      if (drag && !drag.map) { drag = null; ghost(null); return true; }
      return cancelTool();
    }
  };

  bindButtons();
  bindTabs();
  render();
}());
