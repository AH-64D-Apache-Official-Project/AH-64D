// The DTC, as fza_dms_fnc_dtcFromJson takes it: world metres, fixed slots, 0 for an empty one
var DTC_VERSION = 1;
var DTC_COUNTS = { lines: 15, areas: 12, pfz: 8, nfz: 8, wp: 50, cm: 49, tt: 50 };
var DTC_POINT_KINDS = ['wp', 'cm', 'tt'];
var DTC_ROUTES = 10;
var DTC_ROUTE_NAMES = ['ALPHA', 'BRAVO', 'DELTA', 'ECHO', 'HOTEL', 'INDIA', 'KILO', 'LIMA', 'MIKE', 'OSCAR'];

// A route name: up to 5 letters or numbers, else the slot's default
function dtcRouteName(name, r) {
  var n = String(name || '').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 5);
  return n || DTC_ROUTE_NAMES[r];
}

function dtcSlots(n) {
  var out = [];
  for (var i = 0; i < n; i++) out.push(null);
  return out;
}

function dtcEmpty() {
  return {
    name: '',
    lines: dtcSlots(DTC_COUNTS.lines),
    areas: dtcSlots(DTC_COUNTS.areas),
    pfz: dtcSlots(DTC_COUNTS.pfz),
    nfz: dtcSlots(DTC_COUNTS.nfz),
    activePf: -1,
    nfActive: [false, false, false, false, false, false, false, false],
    nfSingle: false,
    wp: dtcSlots(DTC_COUNTS.wp),
    cm: dtcSlots(DTC_COUNTS.cm),
    tt: dtcSlots(DTC_COUNTS.tt),
    routes: [[], [], [], [], [], [], [], [], [], []],
    routeNames: DTC_ROUTE_NAMES.slice()
  };
}

// A point's ID by its file and slot: W01-W50, C51-C99, T01-T50
function dtcPointId(kind, slot) {
  if (kind === 'cm') return 'C' + (slot + 51);
  return (kind === 'tt' ? 'T' : 'W') + dtcPad2(slot + 1);
}

function dtcPointSlot(id) {
  var m = /^([WCT])(\d{2})$/.exec(String(id || ''));
  if (!m) return null;
  var n = parseInt(m[2], 10);
  if (m[1] === 'C') return { kind: 'cm', slot: n - 51 };
  return { kind: m[1] === 'T' ? 'tt' : 'wp', slot: n - 1 };
}

function dtcPointAt(d, id) {
  var at = dtcPointSlot(id);
  return at && d[at.kind] ? d[at.kind][at.slot] || null : null;
}

function dtcIdent(value, fallback) {
  var id = String(value || '').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 5);
  return id || fallback;
}

function dtcPad2(n) {
  return (n < 10 ? '0' : '') + n;
}

function dtcDefaultIdent(kind, slot) {
  return kind === 'areas' ? 'EA' + dtcPad2(slot + 1) : 'PL' + (slot < 9 ? '00' : '0') + (slot + 1);
}

// A line's kind by its ident: phase line PL..., boundary BL..., FLOT, FLET, FSCL; its ident's own characters follow
var DTC_LINE_KINDS = ['PL', 'BL', 'FLOT', 'FLET', 'FSCL'];
function dtcLineKind(id) {
  id = String(id || '');
  if (id.indexOf('FLOT') === 0) return 'FLOT';
  if (id.indexOf('FLET') === 0) return 'FLET';
  if (id.indexOf('FSCL') === 0) return 'FSCL';
  if (id.indexOf('BL') === 0) return 'BL';
  return 'PL';
}
function dtcLineSuffix(id) {
  id = String(id || '');
  var kind = dtcLineKind(id);
  return id.indexOf(kind) === 0 ? id.slice(kind.length) : id.slice(0, 5 - kind.length);
}

function dtcPoints(raw, min, max) {
  if (!raw || !raw.length || raw.length < min || raw.length > max) return null;
  var pts = [];
  for (var i = 0; i < raw.length; i++) {
    var p = raw[i];
    if (!p || typeof p[0] !== 'number' || typeof p[1] !== 'number') return null;
    pts.push([p[0], p[1], typeof p[2] === 'number' ? p[2] : 0]);
  }
  return pts;
}

// A DTC object as the aircraft sends it, or any older or broken one, as a whole DTC
function dtcFromObject(o) {
  var d = dtcEmpty();
  if (!o || typeof o !== 'object') return d;
  d.name = String(o.name || '').toUpperCase().slice(0, 8);
  ['lines', 'areas', 'pfz', 'nfz'].forEach(function (kind) {
    var list = o[kind] || [];
    var zone = kind === 'pfz' || kind === 'nfz';
    for (var i = 0; i < DTC_COUNTS[kind]; i++) {
      var e = list[i];
      if (!e || typeof e !== 'object') continue;
      var pts = dtcPoints(e.pts, kind === 'lines' ? 2 : zone ? 3 : 4, kind === 'lines' ? 4 : zone ? 12 : 4);
      if (!pts) continue;
      d[kind][i] = zone ? { pts: pts } : { id: dtcIdent(e.id, dtcDefaultIdent(kind, i)), pts: pts };
    }
  });
  var z = o.zones || {};
  if (typeof z.activePf === 'number' && d.pfz[z.activePf]) d.activePf = z.activePf;
  for (var k = 0; k < 8; k++) d.nfActive[k] = !!(z.nfActive && z.nfActive[k] === true && d.nfz[k]);
  d.nfSingle = z.nfSingle === true;
  DTC_POINT_KINDS.forEach(function (kind) {
    var list = o[kind] || [];
    for (var i = 0; i < DTC_COUNTS[kind]; i++) {
      var e = list[i];
      if (!e || typeof e !== 'object' || !e.pt || typeof e.pt[0] !== 'number' || typeof e.pt[1] !== 'number') continue;
      d[kind][i] = {
        ident: String(e.ident || '').toUpperCase().slice(0, 3),
        free: String(e.free || '').toUpperCase().replace(/[^A-Z0-9 ]/g, '').slice(0, 3),
        pt: [e.pt[0], e.pt[1], typeof e.pt[2] === 'number' ? e.pt[2] : 0],
        g: String(e.g || '')
      };
    }
  });
  // A route holds waypoints, hazards and control measures, never targets or threats
  var routes = o.routes || [];
  for (var r = 0; r < DTC_ROUTES; r++) {
    d.routes[r] = (routes[r] || []).filter(function (id) { var at = dtcPointSlot(id); return at !== null && at.kind !== 'tt'; }).slice(0, 50);
    d.routeNames[r] = dtcRouteName((o.routeNames || [])[r], r);
  }
  return d;
}

function dtcToJson(d, world) {
  function round(p) { return p.map(function (v) { return Math.round(v * 10) / 10; }); }
  function withId(e) { return e ? { id: e.id, pts: e.pts.map(round) } : 0; }
  function zone(e) { return e ? { pts: e.pts.map(function (p) { return round([p[0], p[1]]); }) } : 0; }
  function point(e) { return e ? { ident: e.ident, free: e.free, pt: round(e.pt), g: e.g } : 0; }
  return JSON.stringify({
    version: DTC_VERSION,
    name: d.name,
    world: world,
    lines: d.lines.map(withId),
    areas: d.areas.map(withId),
    pfz: d.pfz.map(zone),
    nfz: d.nfz.map(zone),
    zones: { activePf: d.activePf, nfActive: d.nfActive, nfSingle: d.nfSingle },
    wp: d.wp.map(point),
    cm: d.cm.map(point),
    tt: d.tt.map(point),
    routes: d.routes,
    routeNames: d.routeNames
  });
}

// A quadrilateral's corners in an order whose edges don't cross, with an area of 100 m2 or more; null if there is none
function dtcValidQuad(pts) {
  function orient(a, b, c) { return (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0]); }
  function crosses(p1, p2, p3, p4) {
    return orient(p3, p4, p1) * orient(p3, p4, p2) < 0 && orient(p1, p2, p3) * orient(p1, p2, p4) < 0;
  }
  function area(q) {
    var s = 0;
    for (var i = 0; i < 4; i++) { var n = q[(i + 1) % 4]; s += q[i][0] * n[1] - n[0] * q[i][1]; }
    return Math.abs(s) / 2;
  }
  var orders = [[0, 1, 2, 3], [0, 1, 3, 2], [0, 2, 1, 3]];
  for (var k = 0; k < orders.length; k++) {
    var q = orders[k].map(function (i) { return pts[i]; });
    if (!crosses(q[0], q[1], q[2], q[3]) && !crosses(q[1], q[2], q[3], q[0])) {
      return area(q) >= 100 ? q : null;
    }
  }
  return null;
}

// A north-up box from two opposite corners: lower left, upper left, upper right, lower right
function dtcBox(a, b) {
  var x0 = Math.min(a[0], b[0]), x1 = Math.max(a[0], b[0]);
  var y0 = Math.min(a[1], b[1]), y1 = Math.max(a[1], b[1]);
  var z = (a[2] + b[2]) / 2;
  return [[x0, y0, z], [x0, y1, z], [x1, y1, z], [x1, y0, z]];
}
