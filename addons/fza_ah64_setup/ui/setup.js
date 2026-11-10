(function () {
  'use strict';

  var C = window.FZA_SETUP_CATALOGUE;
  var ACT = {};
  C.actions.forEach(function (a) { ACT[a.id] = a; });

  var PAGES = [
    { id: 'welcome', title: 'Welcome' },
    { id: 'equipment', title: 'Your equipment' },
    { id: 'flight', title: 'Flight model' },
    { id: 'helpers', title: 'Helpers and trim' },
    { id: 'bindFlight', title: 'Flying controls', sec: 'flight' },
    { id: 'bindCockpit', title: 'Cockpit switches', sec: 'cockpit' },
    { id: 'bindWeapons', title: 'Weapons and sensors', sec: 'weapons' },
    { id: 'test', title: 'Test your controls' },
    { id: 'extras', title: 'Other options' },
    { id: 'review', title: 'Review and apply' },
    { id: 'done', title: 'Finished' }
  ];

  var STICKY = ['bmkhs_keyboardStickyPitch', 'bmkhs_keyboardStickyRoll', 'bmkhs_keyboardStickyYaw'];
  var MODES = {
    pitch: { auto: 'bmkhs_autoPitch', sticky: 'bmkhs_keyboardStickyPitch', label: 'Pitch (nose up and down)' },
    roll: { auto: 'bmkhs_autoRoll', sticky: 'bmkhs_keyboardStickyRoll', label: 'Roll (banking)' },
    yaw: { auto: 'bmkhs_autoPedal', sticky: 'bmkhs_keyboardStickyYaw', label: 'Yaw (turning the nose)' }
  };

  var S = { page: 'welcome', visited: { welcome: true }, answers: {}, touched: {}, exclude: {} };
  var G = null;
  var applyResults = null;
  var modalAction = null;

  // ---------- bridge ----------

  function send(cmd, data) {
    var msg = { cmd: cmd };
    if (data) { for (var k in data) { msg[k] = data[k]; } }
    try {
      if (typeof A3API !== 'undefined' && A3API && typeof A3API.SendAlert === 'function') {
        A3API.SendAlert('fzasetup:' + JSON.stringify(msg));
      }
    } catch (e) { /* no game */ }
  }

  function persisted() {
    return { v: 1, page: S.page, visited: S.visited, answers: S.answers, touched: S.touched, exclude: S.exclude };
  }

  var saveTimer = null;
  function saveNow() {
    if (saveTimer) { clearTimeout(saveTimer); saveTimer = null; }
    send('save', { state: JSON.stringify(persisted()) });
  }
  function saveSoon() {
    if (saveTimer) { clearTimeout(saveTimer); }
    saveTimer = setTimeout(saveNow, 300);
  }

  function restore(str, keepPage) {
    if (!str) { return false; }
    var o;
    try { o = JSON.parse(str); } catch (e) { return false; }
    if (!o || o.v !== 1) { return false; }
    S.answers = o.answers || {};
    if (!keepPage) { return true; }
    S.touched = o.touched || {};
    S.exclude = o.exclude || {};
    if (pageIndex(o.page) >= 0) {
      S.page = o.page;
      S.visited = o.visited || { welcome: true };
    }
    return true;
  }

  var readyTimer = null;
  function requestState() {
    var acts = C.actions.map(function (a) { return a.id; }).concat(C.extra);
    send('ready', { actions: acts, settings: Object.keys(C.settings) });
  }

  window.fzaSetup = {
    receive: function (m) {
      if (!m || typeof m !== 'object') { return; }
      if (m.type === 'state') {
        var first = G === null;
        G = m;
        if (readyTimer) { clearInterval(readyTimer); readyTimer = null; }
        if (first) {
          if (!restore(m.resume, true)) { restore(m.saved, false); }
          if (m.resume) { toast('Welcome back. Your bindings have been read again.'); }
        }
        document.getElementById('loading').classList.add('hidden');
        render();
      } else if (m.type === 'applied') {
        applyResults = m.results || {};
        render();
      }
    }
  };

  // ---------- answers, recommendations, settings ----------

  function profile() {
    var a = S.answers;
    var p = { device: a.device || 'kbm', seat: a.seat || 'both' };
    if (p.device === 'joystick') {
      p.cyclic = 'axis';
      p.collective = a.collective === 'axis' ? 'axis' : 'keys';
      p.pedalHow = a.pedals;
      p.pedals = (a.pedals === 'rudder' || a.pedals === 'twist') ? 'axis' : (a.pedals === 'auto' ? 'auto' : 'keys');
    } else if (p.device === 'gamepad') {
      p.cyclic = 'pad'; p.collective = 'keys'; p.pedals = 'pad';
    } else {
      p.cyclic = a.steer === 'mouse' ? 'mouse' : 'keys'; p.collective = 'keys'; p.pedals = 'keys';
    }
    p.sticky = STICKY.some(function (id) { return chosen(id) === true; });
    return p;
  }

  function recommend() {
    var a = S.answers, r = {};
    if (!a.device) { return r; }
    var joy = a.device === 'joystick';
    var mouse = a.device === 'kbm' && a.steer === 'mouse';
    var keys = a.device === 'kbm' && a.steer !== 'mouse';
    var pedAxis = joy && (a.pedals === 'rudder' || a.pedals === 'twist');
    var pedSpringless = joy && a.pedals === 'rudder' && a.pedalSpring === 'springless';
    r.bmkhs_helisimRealismSetting = (joy && a.collective === 'axis' && a.experience === 'yes') ? C.REALISTIC : C.CASUAL;
    r.bmkhs_mouseAsJoystick = mouse;
    r.bmkhs_autoPedal = !pedAxis;
    r.bmkhs_autoPitch = keys;
    r.bmkhs_autoRoll = keys;
    STICKY.forEach(function (id) { r[id] = false; });
    r.bmkhs_springlessCyclic = joy && a.stickSpring === 'springless';
    r.bmkhs_springlessPedals = pedSpringless;
    r.bmkhs_cyclicCenterTrimMode = joy && a.stickSpring === 'sprung';
    r.bmkhs_pedalCenterTrimMode = pedAxis && !pedSpringless;
    if (a.head) { r.hct_interaction_trackIR_interaction_cursor = a.head === 'yes'; }
    if (a.experience === 'no') { r.bmkhs_vrsWarning = true; }
    return r;
  }

  function gs(id) { return G && G.settings ? G.settings[id] : undefined; }
  function exists(id) { return !!gs(id); }
  function current(id) { var s = gs(id); return s ? s.value : undefined; }
  function locked(id) { var s = gs(id); return !!s && s.source !== 'client'; }

  function chosen(id) {
    if (!exists(id)) { return undefined; }
    if (locked(id)) { return current(id); }
    if (Object.prototype.hasOwnProperty.call(S.touched, id)) { return S.touched[id]; }
    var r = recommend();
    if (Object.prototype.hasOwnProperty.call(r, id)) { return r[id]; }
    return current(id);
  }

  function same(a, b) {
    if (typeof a === 'number' && typeof b === 'number') { return Math.abs(a - b) < 1e-4; }
    return a === b;
  }

  function changes() {
    return Object.keys(C.settings).filter(function (id) {
      return exists(id) && !locked(id) && !same(chosen(id), current(id));
    });
  }

  function fmt(id, v) {
    var m = C.settings[id];
    if (v === undefined || v === null) { return '-'; }
    if (m.type === 'bool') { return v ? 'On' : 'Off'; }
    if (m.type === 'list') {
      for (var i = 0; i < m.options.length; i++) { if (same(m.options[i][0], v)) { return m.options[i][1]; } }
      return String(v);
    }
    var n = Number(v);
    return (Math.round(n * 100) / 100) + (m.unit || '');
  }

  // ---------- bindings ----------

  function clean(name) { return String(name || '').replace(/^"+|"+$/g, '').replace(/""/g, '"'); }

  function kindOf(device, name) {
    var d = String(device || '').toUpperCase();
    if (d === 'JOYSTICK_AXIS') { return 'axis'; }
    if (d === 'MOUSE_AXIS') { return 'mouseAxis'; }
    if (d === 'KEYBOARD') { return 'key'; }
    if (d === 'XINPUT') { return /thumb|trigger|axis|stick/i.test(name) ? 'axis' : 'button'; }
    if (d === 'TRACKER') { return 'tracker'; }
    if (d) { return 'button'; }
    if (/mouse/i.test(name)) { return /(up|down|left|right)$/i.test(name) ? 'mouseAxis' : 'button'; }
    if (/(^|\s)(x|y|z)\s*(rot)?\s*[+-]$|slider|axis/i.test(name)) { return 'axis'; }
    return 'key';
  }

  var keyCache = {};
  function keysOf(id) {
    if (keyCache[id]) { return keyCache[id]; }
    var b = G && G.bindings ? G.bindings[id] : null;
    var out = [];
    if (b && b.codes) {
      var aligned = b.devices && b.devices.length === b.codes.length;
      for (var i = 0; i < b.codes.length; i++) {
        var name = clean(b.keys ? b.keys[i] : '');
        out.push({ code: b.codes[i], name: name || String(b.codes[i]), kind: kindOf(aligned ? b.devices[i] : '', name) });
      }
    }
    keyCache[id] = out;
    return out;
  }

  function bound(id) { return keysOf(id).length > 0; }
  function inGame(id) { return !!(G && G.bindings && G.bindings[id]); }
  function gameName(id) { var b = G && G.bindings ? G.bindings[id] : null; return b && b.name ? b.name : (ACT[id] ? ACT[id].title : id); }
  function gameGroup(id) { var b = G && G.bindings ? G.bindings[id] : null; return b ? b.group : ''; }

  var codeMap = null;
  function conflictsOf(id) {
    if (!codeMap) {
      codeMap = {};
      Object.keys((G && G.bindings) || {}).forEach(function (aid) {
        keysOf(aid).forEach(function (k) { (codeMap[k.code] = codeMap[k.code] || []).push(aid); });
      });
    }
    var out = [];
    keysOf(id).forEach(function (k) {
      (codeMap[k.code] || []).forEach(function (other) {
        if (other !== id && !/^Heli/.test(other)) { out.push({ key: k, other: other }); }
      });
    });
    return out;
  }

  function status(a, p) {
    if (!inGame(a.id)) { return { st: 'absent', notes: [] }; }
    var keys = keysOf(a.id), need = a.need(p), want = a.want(p), notes = [], st;
    var hasAxis = keys.some(function (k) { return k.kind === 'axis'; });
    if (!keys.length) {
      var sibling = a.anyOf && C.actions.some(function (o) { return o.anyOf === a.anyOf && o.id !== a.id && bound(o.id); });
      st = sibling ? 'covered' : (need === 'required' ? 'missing' : 'unbound');
    } else if (want === 'axis' && !hasAxis) {
      st = 'wrong';
      notes.push(['warn', 'This needs an axis: moving the stick, throttle or pedals. A key or button only gives all or nothing.']);
    } else if (want === 'mouseAxis' && !keys.some(function (k) { return k.kind === 'mouseAxis'; })) {
      st = 'wrong';
      notes.push(['warn', 'With the mouse as the joystick, bind the mouse movement here (Mouse Up, Mouse Down, Mouse Left, Mouse Right).']);
    } else {
      st = 'ok';
    }
    if (a.pair && want === 'axis' && hasAxis && inGame(a.pair)) {
      var other = keysOf(a.pair);
      if (!other.some(function (k) { return k.kind === 'axis'; })) {
        notes.push(['warn', ACT[a.pair].title + ' has no axis, so half of this control\'s travel does nothing.']);
      }
      keys.forEach(function (k) {
        if (k.kind === 'axis' && other.some(function (o) { return o.code === k.code; })) {
          notes.push(['bad', k.name + ' is bound to both ' + a.title + ' and ' + ACT[a.pair].title + '. One of them should be the other direction.']);
        }
      });
    }
    if (st !== 'ok' && st !== 'covered' && a.vanilla) {
      a.vanilla.forEach(function (vid) {
        var vk = keysOf(vid).filter(function (k) { return want !== 'axis' || k.kind === 'axis'; });
        if (vk.length && inGame(vid)) {
          notes.push(['info', vk.map(function (k) { return k.name; }).join(', ') + ' is bound to Arma\'s own "' + gameName(vid) + '"' + (gameGroup(vid) ? ' (' + gameGroup(vid) + ')' : '') + ', which HeliSim does not read. Bind it to this one as well.']);
        }
      });
    }
    if (st === 'ok' && notes.some(function (n) { return n[0] === 'bad'; })) { st = 'wrong'; }
    var seen = {};
    conflictsOf(a.id).forEach(function (c) {
      var tag = c.key.code + '|' + c.other;
      if (seen[tag] || c.other === a.pair) { return; }
      seen[tag] = true;
      var look = /^(Aim|Look)/.test(c.other);
      var sev = (look && c.key.kind === 'axis' && a.sec === 'flight') ? 'warn' : 'info';
      var why = look && a.sec === 'flight' ? ' It will also move your view or your aim.' : '';
      notes.push([sev, c.key.name + ' is also bound to "' + gameName(c.other) + '".' + why]);
    });
    return { st: st, notes: notes, need: need, want: want };
  }

  function sectionStats(sec, p) {
    var req = 0, ready = 0, warn = 0, groups = {};
    C.actions.forEach(function (a) {
      if (sec && a.sec !== sec) { return; }
      var s = status(a, p);
      if (s.st === 'absent' || s.need === 'hidden') { return; }
      if (s.need === 'required' && a.anyOf) {
        if (!groups[a.anyOf]) { groups[a.anyOf] = true; req++; }
        if (s.st === 'ok') { ready++; }
      } else if (s.need === 'required') {
        req++;
        if (s.st === 'ok') { ready++; }
      }
      if (s.st === 'wrong' || s.notes.some(function (n) { return n[0] === 'bad' || n[0] === 'warn'; })) { warn++; }
    });
    return { req: req, ready: ready, warn: warn };
  }

  function howText(a, p) {
    var h = a.how || {}, k = 'keys';
    if (a.id.indexOf('bmkhs_cyclic') === 0) { k = { axis: 'axis', pad: 'pad', mouse: 'mouse' }[p.cyclic] || 'keys'; }
    else if (a.id.indexOf('bmkhs_pedal') === 0) { k = p.pedals === 'axis' ? p.pedalHow : (p.pedals === 'pad' ? 'pad' : 'keys'); }
    else if (a.id.indexOf('bmkhs_collective') === 0) { k = 'axis'; }
    else if (a.id.indexOf('bmkhs_kbCollective') === 0) { k = p.device === 'gamepad' ? 'pad' : 'keys'; }
    return h[k] || h.any || 'Press the key or button you want to use.';
  }

  // ---------- rendering helpers ----------

  function esc(s) {
    return String(s === undefined || s === null ? '' : s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', '\'': '&#39;' }[c];
    });
  }
  function pageIndex(id) { for (var i = 0; i < PAGES.length; i++) { if (PAGES[i].id === id) { return i; } } return -1; }

  var ICONS = {
    kbm: '<svg width="46" height="34" viewBox="0 0 46 34"><rect x="1" y="9" width="32" height="16" rx="2" fill="none" stroke="#4cc94c"/><path d="M5 13h3M10 13h3M15 13h3M20 13h3M25 13h3M7 17h20M9 21h16" stroke="#4cc94c"/><rect x="36" y="9" width="9" height="16" rx="4.5" fill="none" stroke="#4cc94c"/></svg>',
    gamepad: '<svg width="46" height="34" viewBox="0 0 46 34"><path d="M9 9h28c5 0 8 6 8 13 0 6-5 7-8 3l-4-4H13l-4 4c-3 4-8 3-8-3 0-7 3-13 8-13z" fill="none" stroke="#4cc94c"/><circle cx="14" cy="16" r="3" fill="none" stroke="#4cc94c"/><circle cx="31" cy="18" r="3" fill="none" stroke="#4cc94c"/></svg>',
    joystick: '<svg width="46" height="34" viewBox="0 0 46 34"><rect x="9" y="27" width="28" height="6" rx="1" fill="none" stroke="#4cc94c"/><path d="M23 27V10" stroke="#4cc94c" stroke-width="3"/><rect x="18" y="2" width="10" height="10" rx="3" fill="none" stroke="#4cc94c"/></svg>'
  };

  function badge(cls, text) { return '<span class="badge ' + cls + '">' + esc(text) + '</span>'; }

  function seg(id, options, value, disabled) {
    return '<div class="seg">' + options.map(function (o) {
      return '<button ' + (disabled ? 'disabled ' : '') + 'class="' + (same(o[0], value) ? 'on' : '') + '" data-act="set" data-id="' + esc(id) + '" data-val="' + esc(JSON.stringify(o[0])) + '">' + esc(o[1]) + '</button>';
    }).join('') + '</div>';
  }

  function settingControl(id) {
    var m = C.settings[id], v = chosen(id), dis = locked(id);
    if (m.type === 'bool') { return seg(id, [[true, 'On'], [false, 'Off']], v, dis); }
    if (m.type === 'list' && m.options.length <= 3) { return seg(id, m.options, v, dis); }
    if (m.type === 'list') {
      return '<select data-act="setsel" data-id="' + esc(id) + '"' + (dis ? ' disabled' : '') + '>' + m.options.map(function (o) {
        return '<option value="' + esc(JSON.stringify(o[0])) + '"' + (same(o[0], v) ? ' selected' : '') + '>' + esc(o[1]) + '</option>';
      }).join('') + '</select>';
    }
    return '<div><input type="range" data-act="setrange" data-id="' + esc(id) + '" min="' + m.min + '" max="' + m.max + '" step="' + m.step + '" value="' + esc(v) + '"' + (dis ? ' disabled' : '') + '> <span class="mono" id="rv_' + esc(id) + '">' + esc(fmt(id, v)) + '</span></div>';
  }

  function settingRow(id, extraHelp) {
    if (!exists(id)) { return ''; }
    var m = C.settings[id], r = recommend(), meta = [];
    var hasRec = Object.prototype.hasOwnProperty.call(r, id);
    var head = esc(m.label);
    if (locked(id)) {
      head += badge('b-lock', 'Set by the ' + (gs(id).source === 'server' ? 'server' : 'mission'));
      meta.push('The ' + esc(gs(id).source) + ' decides this one, so it stays ' + esc(fmt(id, current(id))) + '.');
    } else if (hasRec) {
      head += badge('b-rec', 'Suggested: ' + fmt(id, r[id]));
    }
    if (!locked(id)) {
      meta.push('Now: ' + esc(fmt(id, current(id))) + (same(current(id), gs(id).default) ? ' (default)' : '') + '.');
      if (!same(chosen(id), current(id))) { meta.push('<b>Will change to ' + esc(fmt(id, chosen(id))) + '.</b>'); }
    }
    if (m.casualOnly && chosen('bmkhs_helisimRealismSetting') === C.REALISTIC) {
      meta.push('<span style="color:var(--warn)">Only works with the Casual flight model.</span>');
    }
    return '<div class="setting"><div class="sl"><div class="sn">' + head + '</div>' +
      (m.help ? '<div class="sh">' + esc(m.help) + '</div>' : '') +
      (extraHelp ? '<div class="sh">' + extraHelp + '</div>' : '') +
      '<div class="sm">' + meta.join(' ') + '</div></div><div class="sc">' + settingControl(id) + '</div></div>';
  }

  // ---------- pages ----------

  var QUESTIONS = [
    { key: 'device', title: 'What will you fly with?', help: 'The thing you hold to fly. The keyboard still does everything else.',
      opts: [['kbm', 'Keyboard and mouse', 'No joystick. Fine for learning: the helpers make it manageable.'],
        ['gamepad', 'Gamepad', 'An Xbox-style controller with two thumbsticks.'],
        ['joystick', 'Joystick or HOTAS', 'A flight stick, with or without a throttle and pedals.']] },
    { key: 'steer', when: function (a) { return a.device === 'kbm'; }, title: 'Fly with the keys or the mouse?',
      opts: [['keys', 'Keys', 'W A S D tilt the aircraft. Easiest to start with.'],
        ['mouse', 'Mouse', 'The mouse moves the stick like a joystick. Smoother, but it takes practice.']] },
    { key: 'collective', when: function (a) { return a.device === 'joystick'; }, title: 'Do you have a throttle, or a lever or slider for the collective?',
      help: 'The collective is the lever that makes the aircraft climb and descend. Like a throttle, it stays where you leave it.',
      opts: [['axis', 'Yes', 'A throttle, a lever on the stick\'s base, or a slider.'],
        ['keys', 'No', 'I will use two buttons or keys: one for up, one for down.']] },
    { key: 'pedals', when: function (a) { return a.device === 'joystick'; }, title: 'How will you turn the nose left and right?',
      opts: [['rudder', 'Rudder pedals', 'Pedals under your feet.'], ['twist', 'Twist the stick', 'A stick that twists.'],
        ['keys', 'Buttons or keys', 'Two buttons or keys.'], ['auto', 'Let the computer do it', 'Auto pedal works the pedals. Keys still turn the nose.']] },
    { key: 'stickSpring', when: function (a) { return a.device === 'joystick'; }, title: 'Does your stick spring back to the middle when you let go?',
      opts: [['sprung', 'Yes, it springs back', 'Almost every joystick.'], ['springless', 'No', 'No spring fitted, or force feedback.']] },
    { key: 'pedalSpring', when: function (a) { return a.device === 'joystick' && a.pedals === 'rudder'; }, title: 'Do your pedals spring back to the middle?',
      opts: [['sprung', 'Yes', 'They centre themselves.'], ['springless', 'No', 'They stay where you leave them.']] },
    { key: 'experience', title: 'Have you flown a realistic helicopter simulator before?', help: 'This decides which flight model is suggested.',
      opts: [['no', 'No, or not much', 'Start gentle.'], ['yes', 'Yes', 'Torque, trim and a real collective are familiar.']] },
    { key: 'head', title: 'Do you use head tracking?', help: 'TrackIR, OpenTrack, Tobii or similar.',
      opts: [['no', 'No', 'I look around with the mouse or keys.'], ['yes', 'Yes', 'My view follows my head.']] },
    { key: 'seat', title: 'Which seat will you fly in?', help: 'Decides which weapon and sensor controls are listed.',
      opts: [['pilot', 'Pilot', 'The back seat: flying the aircraft.'], ['cpg', 'Gunner (CPG)', 'The front seat: TADS camera, laser and weapons.'],
        ['both', 'Both', 'Show everything.']] }
  ];

  function visibleQuestions() { return QUESTIONS.filter(function (q) { return !q.when || q.when(S.answers); }); }
  function equipmentDone() { return visibleQuestions().every(function (q) { return !!S.answers[q.key]; }); }

  function pageWelcome() {
    var h = '<h1>Set up your Apache</h1>' +
      '<p class="lead">This walks you through everything you need to fly: what to set, what to bind, and a test to check it all works. It takes about five minutes.</p>' +
      '<div class="callout"><ol>' +
      '<li><b>Tell it what you fly with.</b> It suggests settings to match, and explains each one.</li>' +
      '<li><b>Check your bindings.</b> It reads your Arma controls and shows what is missing or wrong. Bind takes you to Arma\'s Controls menu in the right place, and this setup comes back when you close it.</li>' +
      '<li><b>Test.</b> Move your stick, collective and pedals and watch them on screen.</li>' +
      '<li><b>Apply.</b> Nothing changes until you press Apply on the Review page.</li></ol></div>';
    if (G && G.context && G.context.multiplayer) {
      h += '<p class="dim small">In multiplayer the game keeps running behind this screen. Find somewhere safe first.</p>';
    }
    if (G && G.context && G.context.done) {
      h += '<h2>Been here before?</h2><div class="big-actions">' +
        '<button data-act="goto" data-page="bindFlight">Check my bindings</button><button data-act="goto" data-page="test">Test my controls</button><button data-act="goto" data-page="review">Review settings</button></div>';
    }
    h += '<div class="big-actions"><button class="primary" data-act="next">Start</button><button data-act="close">Not now</button>' +
      '<button class="ghost" data-act="finish">Don\'t show this again</button></div>' +
      '<p class="dim small">Open it again any time from the ACE self-interaction menu while in the Apache: <b>Controls Setup</b>.</p>';
    return h;
  }

  function pageEquipment() {
    var h = '<h1>Your equipment</h1><p class="lead">Answer what you can. Everything after this is based on these answers.</p>';
    visibleQuestions().forEach(function (q) {
      h += '<div class="q"><div class="qt">' + esc(q.title) + '</div>' + (q.help ? '<div class="qh">' + esc(q.help) + '</div>' : '') + '<div class="cards">';
      q.opts.forEach(function (o) {
        h += '<div class="card' + (S.answers[q.key] === o[0] ? ' sel' : '') + '" data-act="answer" data-key="' + q.key + '" data-val="' + o[0] + '">' +
          (q.key === 'device' ? ICONS[o[0]] : '') + '<div class="ct">' + esc(o[1]) + '</div><div class="cd">' + esc(o[2]) + '</div></div>';
      });
      h += '</div></div>';
    });
    return h;
  }

  function pageFlight() {
    var id = 'bmkhs_helisimRealismSetting';
    var h = '<h1>Flight model</h1><p class="lead">HeliSim has two flight models. Both fly like a helicopter; Realistic adds the things that make a real one hard work.</p>';
    if (!exists(id)) { return h + '<div class="callout warn">HeliSim\'s flight model setting was not found. Is HeliSim Core loaded?</div>'; }
    var r = recommend()[id], v = chosen(id), lock = locked(id);
    var card = function (val, title, lines) {
      return '<div class="card' + (same(v, val) ? ' sel' : '') + '"' + (lock ? '' : ' data-act="set" data-id="' + id + '" data-val="' + val + '"') + ' style="max-width:460px">' +
        '<div class="ct">' + title + (same(r, val) ? badge('b-rec', 'Suggested for you') : '') + '</div><div class="cd"><ul style="margin-left:18px">' +
        lines.map(function (l) { return '<li>' + l + '</li>'; }).join('') + '</ul></div></div>';
    };
    h += '<div class="cards">' +
      card(C.CASUAL, 'Casual', ['The rotor does not tilt back as you speed up.', 'The tail rotor only turns the nose: pedals do not pitch or roll you.', 'A simpler centre of gravity.', 'No control mixing.', 'The keyboard helpers (auto pitch, auto roll) work.']) +
      card(C.REALISTIC, 'Realistic', ['All of the above is modelled.', 'You correct for it yourself, with the stick and pedals.', 'The keyboard helpers auto pitch and auto roll do nothing.', 'Best with a joystick, a throttle and pedals.']) +
      '</div>';
    if (lock) {
      h += '<div class="callout warn">The ' + esc(gs(id).source) + ' sets the flight model to <b>' + esc(fmt(id, current(id))) + '</b>, so it cannot be changed here.</div>';
    } else {
      h += '<p class="dim">Now: <b>' + esc(fmt(id, current(id))) + '</b>. You can change this any time in Addon Options. A server can also decide it for everyone.</p>';
    }
    return h;
  }

  function modeOf(axis) {
    var m = MODES[axis];
    if (chosen(m.auto) === true) { return 'auto'; }
    if (chosen(m.sticky) === true) { return 'sticky'; }
    return 'none';
  }

  function pageHelpers() {
    var p = profile(), a = S.answers;
    var h = '<h1>Helpers and trim</h1><p class="lead">These depend on what you fly with. The suggestions are already selected; change anything you like.</p>';
    if (!a.device) { return h + '<div class="callout warn">Answer the questions on <b>Your equipment</b> first.</div>'; }

    if (p.device === 'kbm' && a.steer !== 'mouse') {
      h += '<h2>How each axis behaves on the keyboard</h2><p class="dim">A key is all or nothing, so each axis gets some help.</p>';
      ['pitch', 'roll', 'yaw'].forEach(function (axis) {
        var m = MODES[axis], mode = modeOf(axis), rec = recommend();
        var recMode = rec[m.auto] ? 'auto' : 'none';
        var lockAny = locked(m.auto) || locked(m.sticky);
        var opt = function (val, title, desc) {
          return '<div class="card' + (mode === val ? ' sel' : '') + '"' + (lockAny ? '' : ' data-act="mode" data-axis="' + axis + '" data-val="' + val + '"') + '>' +
            '<div class="ct">' + title + (recMode === val ? badge('b-rec', 'Suggested') : '') + '</div><div class="cd">' + desc + '</div></div>';
        };
        h += '<div class="q"><div class="qt">' + m.label + '</div><div class="cards">' +
          opt('auto', axis === 'yaw' ? 'Auto pedal' : 'Auto ' + axis, esc(C.settings[m.auto].help)) +
          opt('sticky', 'Sticky', 'The control stays where it is when you let go of the key, like a stick you have moved. Hold Sticky Control Interrupt (Space) to take direct control again.') +
          opt('none', 'Plain', 'The control only moves while you hold the key, and goes back to the middle when you let go.') + '</div>' +
          (lockAny ? '<div class="qh">Set by the server or mission.</div>' : '') +
          ((axis !== 'yaw' && mode === 'auto' && chosen('bmkhs_helisimRealismSetting') === C.REALISTIC) ? '<div class="qh" style="color:var(--warn)">Auto ' + axis + ' only works with the Casual flight model.</div>' : '') +
          '</div>';
      });
    }
    if (p.device === 'kbm' && a.steer === 'mouse') {
      h += '<h2>Mouse</h2>' + settingRow('bmkhs_mouseAsJoystick') + settingRow('bmkhs_mouseSense') +
        '<div class="callout">On <b>Flying controls</b>, bind the cyclic to the mouse movement: Mouse Up for Cyclic forward, and so on. Hold free look (Alt by default) to look around without flying.</div>' +
        settingRow('bmkhs_autoPedal');
    }
    if (p.device === 'gamepad') {
      h += '<h2>Gamepad</h2><div class="callout">Suggested layout: the <b>right thumbstick</b> is the cyclic, the <b>left thumbstick</b> left and right turns the nose, and two <b>bumpers or triggers</b> raise and lower the collective. A thumbstick springs back to the middle, so it cannot hold the collective where you leave it; buttons can.</div>' +
        settingRow('bmkhs_autoPedal');
    }
    if (p.device === 'joystick') {
      h += '<h2>Stick</h2>' + settingRow('bmkhs_springlessCyclic') + settingRow('bmkhs_cyclicCenterTrimMode');
      h += '<h2>Pedals</h2>' + settingRow('bmkhs_autoPedal');
      if (a.pedals === 'rudder') { h += settingRow('bmkhs_springlessPedals'); }
      if (a.pedals === 'rudder' || a.pedals === 'twist') { h += settingRow('bmkhs_pedalCenterTrimMode'); }
      h += '<div class="callout">Force trim is how you take the load off a sprung stick: fly where you want, press and release Force Trim, then let the stick go back to the middle. Bind it on the next page.</div>';
    }
    if (a.head === 'yes') {
      h += '<h2>Head tracking</h2>' + settingRow('hct_interaction_trackIR_interaction_cursor') + settingRow('hct_interaction_trackIR_interaction_cursorSensitivity');
      if (p.seat !== 'pilot') { h += settingRow('fza_ah64_tadsIgnoreHatchetCursor'); }
    }
    h += '<h2>While you learn</h2>' + settingRow('bmkhs_vrsWarning');
    return h;
  }

  function bindRow(a, p) {
    var s = status(a, p);
    var keys = keysOf(a.id);
    var label = { ok: 'Ready', missing: 'Not bound', wrong: 'Check', unbound: 'Not bound', covered: 'Not needed' }[s.st];
    var cls = { ok: 'ok', missing: 'missing', wrong: 'wrong', unbound: 'unbound', covered: 'ok' }[s.st];
    var chips = keys.length ? keys.map(function (k) {
      return '<span class="chip' + (k.kind === 'axis' || k.kind === 'mouseAxis' ? ' axis' : '') + '">' + esc(k.name) + '</span>';
    }).join('') : '<span class="dim small">nothing</span>';
    var notes = s.notes.map(function (n) { return '<div class="note ' + n[0] + '">' + esc(n[1]) + '</div>'; }).join('');
    if (s.st === 'covered') { notes = '<div class="note info">You bound the other mouse cursor key, which is enough.</div>' + notes; }
    var how = (a.how && s.need !== 'optional' && s.st !== 'ok' && s.st !== 'covered') ?'<div class="note">' + esc(howText(a, p)) + '</div>' : '';
    return '<tr class="' + cls + '"><td style="width:34%"><div class="an">' + esc(a.title) + '</div><div class="ag">In Arma: "' + esc(gameName(a.id)) + '"' +
      (gameGroup(a.id) ? ' under ' + esc(gameGroup(a.id)) : '') + '</div></td>' +
      '<td><div class="ad">' + esc(a.does) + '</div>' + how + notes + '</td>' +
      '<td style="width:20%">' + chips + '</td>' +
      '<td style="width:120px;text-align:right"><div class="st ' + cls + '">' + label + '</div>' +
      '<button class="small' + (s.st === 'missing' || s.st === 'wrong' ? ' primary' : '') + '" style="margin-top:4px" data-act="bind" data-id="' + esc(a.id) + '">Bind</button></td></tr>';
  }

  function bindTable(list, p) {
    if (!list.length) { return ''; }
    return '<table class="binds"><tr><th>Control</th><th>What it does</th><th>Bound to</th><th></th></tr>' +
      list.map(function (a) { return bindRow(a, p); }).join('') + '</table>';
  }

  function pageBind(sec) {
    var p = profile();
    var intro = {
      flight: '<h1>Flying controls</h1><p class="lead">The controls that fly the aircraft. These come from HeliSim, under <b>HeliSim Flight Controls</b> in Arma\'s Controls menu, not Arma\'s own helicopter controls.</p>',
      cockpit: '<h1>Cockpit switches</h1><p class="lead">You work the cockpit by pointing at a switch and pressing Interact. Look at it, or hold the mouse cursor key and point with the mouse.</p>',
      weapons: '<h1>Weapons and sensors</h1><p class="lead">The Apache\'s own weapon and sensor controls, plus the Arma keys it takes over (Fire, Zoom, Night Vision, Lights, Countermeasures and the radar key).</p>'
    }[sec];
    var h = intro;
    if (!S.answers.device) { h += '<div class="callout warn">Answer the questions on <b>Your equipment</b> first, so the right controls are listed.</div>'; }
    var acts = C.actions.filter(function (a) { return a.sec === sec && inGame(a.id); });
    var by = { required: [], recommended: [], optional: [] };
    acts.forEach(function (a) { var n = a.need(p); if (by[n]) { by[n].push(a); } });
    var st = sectionStats(sec, p);
    if (st.req && st.ready === st.req && !st.warn) {
      h += '<div class="callout good">Everything you need here is bound.</div>';
    } else if (st.req) {
      h += '<div class="callout ' + (st.ready === st.req ? 'warn' : 'bad') + '">' + st.ready + ' of ' + st.req + ' must-have controls are ready' + (st.warn ? ', and ' + st.warn + ' need a look' : '') + '. Press <b>Bind</b> next to each one.</div>';
    }
    if (sec === 'flight' && (p.cyclic === 'axis' || p.collective === 'axis' || p.pedals === 'axis')) {
      h += '<div class="callout"><b>Binding an axis:</b> each direction is its own control. Bind Cyclic forward by pushing the stick forward, and Cyclic backward by pulling it back. Do the same for the collective (throttle forward and back) and the pedals. Missing one direction leaves half the travel dead.</div>';
    }
    h += '<h2>Must have</h2>' + (by.required.length ? bindTable(by.required, p) : '<p class="dim">Nothing here for your setup.</p>');
    if (by.recommended.length) { h += '<h2>Recommended</h2>' + bindTable(by.recommended, p); }
    if (by.optional.length) { h += '<details><summary>Optional (' + by.optional.length + ')</summary>' + bindTable(by.optional, p) + '</details>'; }
    h += '<div class="big-actions"><button data-act="refresh">Read my bindings again</button><button data-act="controls">Open Arma\'s Controls menu</button></div>';
    return h;
  }

  function pageTest() {
    var p = profile();
    var h = '<h1>Test your controls</h1><p class="lead">Start the test, then move everything. This screen closes and a panel shows your inputs live. Press <b>Esc</b> to come back here.</p>';
    if (G && G.context && G.context.engineOn) {
      h += '<div class="callout bad"><b>Your engines are running.</b> Your inputs will fly the aircraft during the test. Shut down, or be ready to fly.</div>';
    }
    h += '<div class="callout"><b>Check:</b><ul>' +
      '<li>Stick fully forward: the dot goes to the <b>top</b>. Back: the <b>bottom</b>. Left and right: the sides. If a direction is the wrong way round, swap the two bindings.</li>' +
      (p.collective === 'axis' ? '<li>Throttle fully back: the collective bar is <b>empty</b>. Fully forward: <b>full</b>. If it only goes from half to full, bind Collective down too.</li>' : '<li>Your collective up and down keys light up while held.</li>') +
      '<li>Pedals (or twist, or keys): the marker moves left and right, and sits in the middle when you let go.</li>' +
      '<li>Force Trim, Interact and Mouse Cursor light up while held.</li></ul></div>' +
      '<div class="big-actions"><button class="primary" data-act="test">Start the test</button></div>' +
      '<p class="dim">In flight, the Control Input Visualiser (' + esc(keysOf('bmkhs_ctrlVisToggle').map(function (k) { return k.name; }).join(' or ') || 'not bound') + ') shows the same thing.</p>';
    return h;
  }

  function pageExtras() {
    var groups = [
      ['Cockpit', ['hct_interaction_showLabels', 'fza_ah64_animControls', 'fza_ah64_showPopupv2_3', 'fza_ah64_vanillaTargetingEnable']],
      ['Radial menu', ['fza_ah64_radialDwellTime', 'fza_ah64_radialKeepOpen']],
      ['TADS (gunner)', ['fza_ah64_tadsCycleIncludeDTV', 'fza_ah64_tadsCycleIncludeDVO', 'fza_ah64_LMCSensitivity']],
      ['Sound', ['fza_ah64_volumeMaster', 'fza_ah64_volumeRlwr']],
      ['Display', ['bmkhs_ctrlVisColor']]
    ];
    var h = '<h1>Other options</h1><p class="lead">Nothing here is needed to fly. Leave it alone, or make it yours.</p>';
    groups.forEach(function (g) {
      var rows = g[1].map(function (id) { return settingRow(id); }).join('');
      if (rows) { h += '<h2>' + esc(g[0]) + '</h2>' + rows; }
    });
    h += '<div class="callout">Everything else, for this mod, HeliSim and your other mods, is in CBA\'s Addon Options.<div class="big-actions" style="margin:8px 0 0"><button data-act="addons">Open Addon Options</button></div></div>';
    return h;
  }

  function pageReview() {
    var list = changes();
    var h = '<h1>Review and apply</h1>';
    if (applyResults) {
      var ids = Object.keys(applyResults);
      h += '<div class="callout good"><b>Applied.</b> Settings are saved to your profile.</div><table class="diff"><tr><th>Setting</th><th>Result</th></tr>';
      ids.forEach(function (id) {
        var r = applyResults[id];
        var txt = { ok: ['res-ok', 'Changed'], unchanged: ['res-ok', 'Already set'], locked: ['res-locked', 'Set by the server or mission'], invalid: ['res-bad', 'Not a valid value'], missing: ['res-bad', 'Setting not found'] }[r] || ['res-bad', r];
        h += '<tr><td>' + esc(C.settings[id] ? C.settings[id].label : id) + '</td><td class="' + txt[0] + '">' + esc(txt[1]) + '</td></tr>';
      });
      h += '</table>';
    }
    if (!list.length) {
      h += '<p class="lead">' + (applyResults ? 'Nothing left to change.' : 'Your settings already match your choices. Nothing to change.') + '</p>';
      return h;
    }
    h += '<p class="lead">These settings will change. Untick any you want to keep as they are.</p><table class="diff"><tr><th></th><th>Setting</th><th>Now</th><th>New</th></tr>';
    list.forEach(function (id) {
      h += '<tr><td><input type="checkbox" data-act="include" data-id="' + esc(id) + '"' + (S.exclude[id] ? '' : ' checked') + '></td><td>' + esc(C.settings[id].label) +
        '</td><td class="from">' + esc(fmt(id, current(id))) + '</td><td class="to">' + esc(fmt(id, chosen(id))) + '</td></tr>';
    });
    h += '</table><div class="big-actions"><button class="primary" data-act="apply">Apply ' + list.filter(function (id) { return !S.exclude[id]; }).length + ' changes</button></div>';
    return h;
  }

  function pageDone() {
    var p = profile();
    var st = sectionStats(null, p);
    var h = '<h1>You are set up</h1>';
    if (changes().filter(function (id) { return !S.exclude[id]; }).length) {
      h += '<div class="callout warn">Some settings you chose are not applied yet. <button class="small" data-act="goto" data-page="review">Review and apply</button></div>';
    }
    if (st.ready < st.req) {
      h += '<div class="callout bad">' + (st.req - st.ready) + ' must-have controls are still not ready. Go back to the binding pages to finish them.</div>';
    }
    h += '<h2>Your key controls</h2><div class="cheat">';
    C.actions.forEach(function (a) {
      if (!inGame(a.id) || a.need(p) !== 'required' || status(a, p).st === 'covered') { return; }
      var k = keysOf(a.id).slice(0, 2).map(function (x) { return x.name; }).join(', ');
      h += '<div><span>' + esc(a.title) + '</span><span class="mono" style="color:' + (k ? 'var(--bright)' : 'var(--bad)') + '">' + esc(k || 'not bound') + '</span></div>';
    });
    h += '</div><h2>Next</h2><p>Open this again any time: <b>ACE self-interaction</b> in the Apache, then <b>Controls Setup</b>.</p>' +
      '<p>The documentation covers starting up, flying, the sensors and the weapons: <span class="mono">ah-64d-apache-official-project.github.io</span>.</p>' +
      '<div class="big-actions"><button class="primary" data-act="finish">Finish</button><button data-act="addons">Open Addon Options</button></div>';
    return h;
  }

  // ---------- frame ----------

  function render() {
    keyCache = {};
    codeMap = null;
    var p = profile();
    var nav = '';
    PAGES.forEach(function (pg, i) {
      var flag = '';
      if (pg.sec && G) {
        var st = sectionStats(pg.sec, p);
        flag = st.ready < st.req ? '<span class="flag" style="color:var(--bad)">' + (st.req - st.ready) + '</span>' : (st.warn ? '<span class="flag" style="color:var(--warn)">!</span>' : '<span class="flag" style="color:var(--ok)">&#10003;</span>');
      }
      if (pg.id === 'review' && G) {
        var n = changes().filter(function (id) { return !S.exclude[id]; }).length;
        if (n) { flag = '<span class="flag" style="color:var(--warn)">' + n + '</span>'; }
      }
      nav += '<div class="step' + (pg.id === S.page ? ' active' : '') + (S.visited[pg.id] ? ' visited' : '') + '" data-act="goto" data-page="' + pg.id + '"><span class="num">' + (i + 1) + '</span>' + esc(pg.title) + flag + '</div>';
    });
    document.getElementById('steps').innerHTML = nav;

    var html = '';
    if (G) {
      switch (S.page) {
        case 'welcome': html = pageWelcome(); break;
        case 'equipment': html = pageEquipment(); break;
        case 'flight': html = pageFlight(); break;
        case 'helpers': html = pageHelpers(); break;
        case 'bindFlight': html = pageBind('flight'); break;
        case 'bindCockpit': html = pageBind('cockpit'); break;
        case 'bindWeapons': html = pageBind('weapons'); break;
        case 'test': html = pageTest(); break;
        case 'extras': html = pageExtras(); break;
        case 'review': html = pageReview(); break;
        case 'done': html = pageDone(); break;
      }
    }
    var pageEl = document.getElementById('page');
    var scroll = pageEl.getAttribute('data-page') === S.page ? pageEl.scrollTop : 0;
    pageEl.innerHTML = html;
    pageEl.setAttribute('data-page', S.page);
    pageEl.scrollTop = scroll;

    if (G) {
      var all = sectionStats(null, p);
      document.getElementById('topStatus').textContent = S.answers.device ? 'Must-have controls ready: ' + all.ready + ' of ' + all.req : '';
    }
    var idx = pageIndex(S.page);
    document.getElementById('btnBack').disabled = idx <= 0;
    var next = document.getElementById('btnNext');
    next.classList.toggle('hidden', idx >= PAGES.length - 1);
    var blocked = S.page === 'equipment' && !equipmentDone();
    next.disabled = blocked;
    document.getElementById('footMsg').textContent = blocked ? 'Answer every question to carry on.' : '';
  }

  function go(id) {
    if (pageIndex(id) < 0) { return; }
    S.page = id;
    S.visited[id] = true;
    if (id === 'review') { applyResults = null; }
    render();
    saveSoon();
  }

  var toastTimer = null;
  function toast(text) {
    var t = document.getElementById('toast');
    t.textContent = text;
    t.classList.remove('hidden');
    if (toastTimer) { clearTimeout(toastTimer); }
    toastTimer = setTimeout(function () { t.classList.add('hidden'); }, 3500);
  }

  function showBindModal(id) {
    var a = ACT[id];
    if (!a) { return; }
    var p = profile(), s = status(a, p);
    modalAction = id;
    var group = gameGroup(id), name = gameName(id);
    var axis = s.want === 'axis' || s.want === 'mouseAxis';
    var h = '<div class="mbox"><h2>Bind: ' + esc(a.title) + '</h2><p>' + esc(a.does) + '</p><ol>' +
      '<li>Press <b>Open Controls menu</b>. If the screen asks you to, press <b>Esc</b>. This setup comes back when you leave the Controls menu.</li>' +
      (group ? '<li>At the top, set <b>Show</b> to <b>' + esc(group) + '</b>. The setup tries to do this for you.</li>' : '') +
      '<li>Find <b>' + esc(name) + '</b> in the list and double-click it.</li>' +
      '<li>' + esc(howText(a, p)) + '</li>' +
      '<li>Press <b>OK</b> in the small window, then <b>OK</b> at the bottom of the Controls menu.</li></ol>';
    if (keysOf(id).length) {
      h += '<p class="small">Already bound: ' + keysOf(id).map(function (k) { return '<span class="chip">' + esc(k.name) + '</span>'; }).join('') +
        '. To remove one, select it in the small window and press <b>Delete</b>.</p>';
    }
    if (axis) {
      h += '<div class="callout small">Move only the axis you mean, all the way. If moving it shows nothing, Arma is not reading your device: in the Controls menu press <b>Controllers</b> and make sure it is enabled.</div>';
    }
    h += '<div class="mb"><button data-act="modalClose">Cancel</button><button class="primary" data-act="bindGo">Open Controls menu</button></div></div>';
    var m = document.getElementById('modal');
    m.innerHTML = h;
    m.classList.remove('hidden');
  }

  function closeModal() {
    modalAction = null;
    document.getElementById('modal').classList.add('hidden');
  }

  function parseVal(s) { try { return JSON.parse(s); } catch (e) { return s; } }

  function onAct(el, evType) {
    var act = el.getAttribute('data-act');
    var id = el.getAttribute('data-id');
    switch (act) {
      case 'next': go(PAGES[Math.min(pageIndex(S.page) + 1, PAGES.length - 1)].id); break;
      case 'back': go(PAGES[Math.max(pageIndex(S.page) - 1, 0)].id); break;
      case 'goto': go(el.getAttribute('data-page')); break;
      case 'answer':
        S.answers[el.getAttribute('data-key')] = el.getAttribute('data-val');
        render(); saveSoon(); break;
      case 'set':
        if (locked(id)) { return; }
        S.touched[id] = parseVal(el.getAttribute('data-val'));
        render(); saveSoon(); break;
      case 'setsel':
        if (evType !== 'change') { return; }
        S.touched[id] = parseVal(el.value);
        render(); saveSoon(); break;
      case 'setrange':
        S.touched[id] = Number(el.value);
        var lab = document.getElementById('rv_' + id);
        if (lab) { lab.textContent = fmt(id, Number(el.value)); }
        if (evType === 'change') { render(); }
        saveSoon(); break;
      case 'mode': {
        var m = MODES[el.getAttribute('data-axis')], val = el.getAttribute('data-val');
        S.touched[m.auto] = val === 'auto';
        S.touched[m.sticky] = val === 'sticky';
        render(); saveSoon(); break;
      }
      case 'include':
        if (evType !== 'change') { return; }
        if (el.checked) { delete S.exclude[id]; } else { S.exclude[id] = true; }
        render(); saveSoon(); break;
      case 'bind': showBindModal(id); break;
      case 'modalClose': closeModal(); break;
      case 'bindGo':
        if (!modalAction) { return; }
        saveNow(); send('bind', { action: modalAction }); closeModal(); break;
      case 'controls': saveNow(); send('controls'); break;
      case 'addons': saveNow(); send('addons'); break;      case 'refresh': send('refresh'); toast('Bindings read again.'); break;
      case 'test': saveNow(); send('test'); break;
      case 'apply': {
        var values = {};
        changes().forEach(function (sid) { if (!S.exclude[sid]) { values[sid] = chosen(sid); } });
        if (!Object.keys(values).length) { return; }
        send('apply', { values: values });
        break;
      }
      case 'finish': saveNow(); send('finish'); break;
      case 'close': saveNow(); send('close'); break;
    }
  }

  document.addEventListener('click', function (e) {
    var el = e.target.closest ? e.target.closest('[data-act]') : null;
    if (!el || el.disabled) { return; }
    var tag = el.tagName;
    if (tag === 'SELECT' || (tag === 'INPUT' && el.type !== 'button')) { return; }
    onAct(el, 'click');
  });
  document.addEventListener('input', function (e) {
    if (e.target.getAttribute && e.target.getAttribute('data-act') === 'setrange') { onAct(e.target, 'input'); }
  });
  document.addEventListener('change', function (e) {
    if (e.target.getAttribute && e.target.getAttribute('data-act')) { onAct(e.target, 'change'); }
  });

  window.fzaSetup.debug = { S: S, profile: profile, recommend: recommend, changes: changes, status: status, render: render, go: go, onAct: onAct };

  render();
  requestState();
  readyTimer = setInterval(requestState, 1000);
})();
