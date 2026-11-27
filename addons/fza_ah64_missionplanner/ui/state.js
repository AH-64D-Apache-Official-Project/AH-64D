// state.js -- planner state read/write and conversion-warning

function mapPlannerRocketTypeToLegacy(typeCode) {
  var map = {
    '6PD': 'M151',
    '6FL': 'm255a1',
    '6IL': 'M257',
    '6MP': 'M261',
    '6IR': 'M278'
  };
  return map[String(typeCode || '').trim().toUpperCase()] || '';
}

function mapPlannerHellfireCodeToLegacy(code) {
  var map = {
    'K': 'AGM114k',
    'L': 'AGM114L',
    'K2A': 'AGM114K2A',
    'FA': 'AGM114FA',
    'N': 'AGM114N'
  };
  return map[String(code || '').toUpperCase()] || '';
}

function buildLegacyApplyPayload(state) {
  // Pass-through helpers â€” supply enforcement removed for now
  function tryAllocHF(code) { return code; }
  function tryAllocRkt(typeCode, count) { return !!count && !!typeCode; }

  var payload = {
    fcrInstalled: !!state.fcrActive,
    iafsInstalled: String(state.robbieMode || 'iafs') === 'iafs',
    fuel: ((state.fuel.fwd || 0) * GAL_TO_LBS_FWD + (state.fuel.aft || 0) * GAL_TO_LBS_AFT + (state.fuel.ctr || 0) * GAL_TO_LBS_CTR + (state.fuel.aux || 0) * GAL_TO_LBS_AUX) / LBS_PER_KG,
    pylon1: { type: 'none' },
    pylon2: { type: 'none' },
    pylon3: { type: 'none' },
    pylon4: { type: 'none' }
  };

  for (var i = 1; i <= 4; i++) {
    var pylon = state.pylons[i - 1] || { type: 'none' };
    var pylonKey = 'pylon' + i;
    var out = { type: pylon.type || 'none' };

    if (out.type === 'hellfire') {
      var rails = pylon.rails || [];
      out.ur = mapPlannerHellfireCodeToLegacy(rails[0] || '');
      out.ul = mapPlannerHellfireCodeToLegacy(rails[1] || '');
      out.lr = mapPlannerHellfireCodeToLegacy(rails[2] || '');
      out.ll = mapPlannerHellfireCodeToLegacy(rails[3] || '');
    }

    if (out.type === 'rocket') {
      var zones = pylon.zones || [];
      out.zoneA = (zones[0] && zones[0].type) ? mapPlannerRocketTypeToLegacy(zones[0].type) : '';
      out.zoneACount = zones[0] ? (parseInt(zones[0].count, 10) || 0) : 0;
      out.zoneB = (zones[1] && zones[1].type) ? mapPlannerRocketTypeToLegacy(zones[1].type) : '';
      out.zoneBCount = zones[1] ? (parseInt(zones[1].count, 10) || 0) : 0;
      out.zoneE = (zones[2] && zones[2].type) ? mapPlannerRocketTypeToLegacy(zones[2].type) : '';
      out.zoneECount = zones[2] ? (parseInt(zones[2].count, 10) || 0) : 0;
    }

    payload[pylonKey] = out;
  }

  return payload;
}

// The website loadout JSON the aircraft's Loadout Config attribute reads, with what the planner adds
function buildLoadoutExport(state) {
  var out = buildLegacyApplyPayload(state);
  out.cannonRds = parseInt(state.cannonRds || 0, 10) || 0;
  out.msnEquip = state.msnEquip || 'US';
  out.tailNum = state.tailNum || '';
  out.fuelGal = {
    fwd: state.fuel.fwd || 0,
    aft: state.fuel.aft || 0,
    ctr: state.fuel.ctr || 0,
    aux: state.fuel.aux || 0
  };
  return out;
}

// A website loadout, a planner export or a planner save, as a planner state; null if it is none of them
function loadoutImportToPlannerState(data) {
  if (!data || typeof data !== 'object' || Array.isArray(data)) return null;
  if (Array.isArray(data.pylons)) return data;
  if (data.pylon1 === undefined && data.fcrInstalled === undefined) return null;

  var rocketCodes = { M151: '6PD', M255: '6FL', M255A1: '6FL', M257: '6IL', M261: '6MP', M278: '6IR' };
  var zoneKeys = ['zoneA', 'zoneB', 'zoneE'];
  var zoneFull = [12, 4, 3];
  var iafs = data.iafsInstalled !== false;
  var state = {
    fcrActive: !!data.fcrInstalled,
    robbieMode: iafs ? 'iafs' : 'magazine',
    pylons: []
  };

  for (var i = 1; i <= 4; i++) {
    var p = data['pylon' + i];
    var type = (p && typeof p === 'object') ? String(p.type || 'none').toLowerCase() : 'none';
    if (type === 'hellfire') {
      state.pylons.push({ type: 'hellfire', rails: [p.ur, p.ul, p.lr, p.ll].map(normalizeHellfireCode) });
    } else if (type === 'rocket') {
      state.pylons.push({ type: 'rocket', zones: zoneKeys.map(function(key, zi) {
        var code = rocketCodes[String(p[key] || '').toUpperCase()] || '';
        if (!code) return { count: 0, type: '' };
        var count = Number(p[key + 'Count']);
        count = (isFinite(count) && count >= 0) ? Math.min(Math.round(count), zoneFull[zi]) : zoneFull[zi];
        return { count: count, type: code };
      }) });
    } else if (type === 'aux') {
      state.pylons.push({ type: 'aux' });
    } else {
      state.pylons.push({ type: 'none' });
    }
  }

  var auxMax = FUEL_GAL_AUX * state.pylons.filter(function(p) { return p.type === 'aux'; }).length;
  var gal = data.fuelGal;
  if (gal && typeof gal === 'object') {
    state.fuel = {
      fwd: Math.max(0, Math.min(FUEL_GAL_FWD, Number(gal.fwd) || 0)),
      aft: Math.max(0, Math.min(FUEL_GAL_AFT, Number(gal.aft) || 0)),
      ctr: iafs ? Math.max(0, Math.min(FUEL_GAL_CTR, Number(gal.ctr) || 0)) : 0,
      aux: Math.max(0, Math.min(auxMax, Number(gal.aux) || 0))
    };
  } else if (typeof data.fuel === 'number') {
    // Only a total: as the aircraft fills, internal tanks by share first, then the aux tanks
    var lbs = Math.max(0, data.fuel * LBS_PER_KG);
    var intLbs = FUEL_GAL_FWD * GAL_TO_LBS_FWD + FUEL_GAL_AFT * GAL_TO_LBS_AFT + (iafs ? FUEL_GAL_CTR * GAL_TO_LBS_CTR : 0);
    var share = Math.min(1, lbs / intLbs);
    state.fuel = {
      fwd: Math.round(FUEL_GAL_FWD * share),
      aft: Math.round(FUEL_GAL_AFT * share),
      ctr: iafs ? Math.round(FUEL_GAL_CTR * share) : 0,
      aux: Math.min(auxMax, Math.round(Math.max(0, lbs - intLbs) / GAL_TO_LBS_AUX))
    };
  }

  if (typeof data.cannonRds === 'number') state.cannonRds = Math.max(0, Math.min(iafs ? 300 : 1200, Math.round(data.cannonRds)));
  if (data.msnEquip === 'US' || data.msnEquip === 'UK') state.msnEquip = data.msnEquip;
  if (typeof data.tailNum === 'string') state.tailNum = data.tailNum;
  return state;
}

function getPlannerState() {
  var state = {
    version: 1,
    timestamp: Date.now(),
    tailNum: String(document.getElementById('tailNum').value).replace(/[^0-9 ]/g, '').slice(0, 5),
    fcrActive: document.getElementById('fcrBadge').classList.contains('active'),
    robbieMode: document.getElementById('robbieMode').value,
    cannonRds: parseNumberText(document.getElementById('cannonRds').value),
    fuelPct: parseNumberText(document.getElementById('fuelPct').value),
    msnEquip: document.getElementById('msnEquip').value,
    fuel: {
      fwd: parseNumberText(document.getElementById('fuelFwd').value),
      aft: parseNumberText(document.getElementById('fuelAft').value),
      ctr: parseNumberText(document.getElementById('fuelCtr').value),
      aux: parseNumberText(document.getElementById('fuelAux').value)
    },
    pylons: []
  };

  for (var i = 1; i <= 4; i++) {
    var pylonTypeEl = document.getElementById('pylon' + i + 'Type');
    var pylon = { type: pylonTypeEl ? pylonTypeEl.value : 'none' };
    if (pylon.type === 'hellfire') {
      pylon.rails = [];
      ['tr', 'tl', 'br', 'bl'].forEach(function(railKey) {
        var railEl = document.getElementById('p' + i + '_' + railKey);
        pylon.rails.push(railEl ? normalizeHellfireCode(railEl.value) : '');
      });
    } else if (pylon.type === 'rocket') {
      pylon.zones = [];
      getZoneIdsForPylon(i).forEach(function(zonePair) {
        var zoneKey = zonePair[0];
        var countEl = document.getElementById('p' + i + '_' + zoneKey + '_count');
        var typeEl = document.getElementById('p' + i + '_' + zoneKey + '_type');
        pylon.zones.push({
          count: parseNumberText(countEl ? countEl.value : '0'),
          type: typeEl ? typeEl.value : ''
        });
      });
    }
    state.pylons.push(pylon);
  }

  return state;
}

function applyPlannerState(state) {
  if (!state) return;

  var fcrBadge = document.getElementById('fcrBadge');
  if (fcrBadge) {
    if (state.fcrActive) fcrBadge.classList.add('active');
    else fcrBadge.classList.remove('active');
  }

  var robbieMode = document.getElementById('robbieMode');
  if (robbieMode && state.robbieMode) {
    // 'robbie' is a legacy SQF value for non-IAFS mode â€” map to 'magazine'
    var rmVal = String(state.robbieMode);
    if (rmVal === 'robbie') rmVal = 'magazine';
    robbieMode.value = rmVal;
  }

  if (state.fuel) {
    if (state.fuel.fwd !== undefined) document.getElementById('fuelFwd').value = String(state.fuel.fwd);
    if (state.fuel.aft !== undefined) document.getElementById('fuelAft').value = String(state.fuel.aft);
    if (state.fuel.ctr !== undefined) document.getElementById('fuelCtr').value = String(state.fuel.ctr);
    if (state.fuel.aux !== undefined) document.getElementById('fuelAux').value = String(state.fuel.aux);
  }

  if (state.cannonRds !== undefined) {
    document.getElementById('cannonRds').value = String(state.cannonRds);
  }

  if (state.tailNum !== undefined) {
    var tn = String(state.tailNum !== undefined ? state.tailNum : '').replace(/[^0-9 ]/g, '').slice(0, 5);
    document.getElementById('tailNum').value = tn;
  }

  if (state.msnEquip !== undefined) {
    var meEl = document.getElementById('msnEquip');
    if (meEl) meEl.value = state.msnEquip;
  }

  if (state.fuelPct !== undefined) {
    document.getElementById('fuelPct').value = String(state.fuelPct);
  }

  for (var i = 1; i <= 4; i++) {
    var pylon = state.pylons && state.pylons[i - 1] ? state.pylons[i - 1] : null;
    if (!pylon) continue;

    var pylonTypeEl = document.getElementById('pylon' + i + 'Type');
    if (pylonTypeEl && pylon.type) {
      pylonTypeEl.value = pylon.type;
      setPylonMode(i, pylon.type);
    }

    if (pylon.type === 'hellfire' && pylon.rails) {
      ['tr', 'tl', 'br', 'bl'].forEach(function(railKey, railIndex) {
        var railEl = document.getElementById('p' + i + '_' + railKey);
        if (!railEl) return;
        var code = normalizeHellfireCode(pylon.rails[railIndex] || '');
        railEl.value = hellfireCodeMap[code] || 'None';
      });
    }

    if (pylon.type === 'rocket' && pylon.zones) {
      getZoneIdsForPylon(i).forEach(function(zonePair, zoneIndex) {
        var zoneKey = zonePair[0];
        var countEl = document.getElementById('p' + i + '_' + zoneKey + '_count');
        var typeEl = document.getElementById('p' + i + '_' + zoneKey + '_type');
        var zoneState = pylon.zones[zoneIndex] || {};
        if (countEl && zoneState.count !== undefined) countEl.value = String(zoneState.count);
        if (typeEl && zoneState.type !== undefined) typeEl.value = zoneState.type;
      });
    }
  }

  syncAuxFuelAvailability();
  syncRobbieState();
  syncSilhouette();
  calcFuel();
  syncCannonDisplay();
  updateWeightsAndPerformance();
}

// Fuel is left as the aircraft has it unless a tank was changed, as gallons don't round-trip exactly
function fuelPlanChanged(plan, acft) {
  if (!plan || !acft) return true;
  return ['fwd', 'aft', 'ctr', 'aux'].some(function(k) { return (plan[k] || 0) !== (acft[k] || 0); });
}

function fuelPlanKg(f) {
  f = f || {};
  return ((f.fwd || 0) * GAL_TO_LBS_FWD + (f.aft || 0) * GAL_TO_LBS_AFT + (f.ctr || 0) * GAL_TO_LBS_CTR + (f.aux || 0) * GAL_TO_LBS_AUX) / LBS_PER_KG;
}

// A pylon's four stations as fza_mplanner_fnc_applyRun orders them (UL or zone A, UR or zone B, LL or zone E, LR),
// each [kind, type, rounds]. An empty launcher keeps an empty pod or rail on its first station.
function pylonStations(p, fromAircraft) {
  var none = ['', '', 0];
  p = p || { type: 'none' };
  if (p.type === 'aux') return [['aux', '', 1], none, none, none];
  if (p.type === 'rocket') {
    var zones = p.zones || [];
    var out = [0, 1, 2].map(function(i) {
      var z = zones[i] || {};
      var type = String(z.type || '').trim().toUpperCase();
      if (!type) return i === 0 ? ['pod', '', 0] : none;
      return ['rocket', type, Math.max(0, parseInt(z.count, 10) || 0)];
    });
    out.push(none);
    return out;
  }
  if (p.type === 'hellfire') {
    var rails = p.rails || [];  // UR, UL, LR, LL
    var ammos = p.ammos || [];
    return [1, 0, 3, 2].map(function(ri, s) {
      var code = String(rails[ri] || '').toUpperCase();
      if (!code) return s === 0 ? ['rail', '', 0] : none;
      return ['hellfire', code, (fromAircraft && typeof ammos[ri] === 'number') ? ammos[ri] : 1];
    });
  }
  return [none, none, none, none];
}

// The steps fza_mplanner_fnc_applyRun will take, with its Per Item seconds, so the page's time is the game's.
// fuelShort: a refuel that the nearest fuel source, when one is required, can't fully make.
function planApplySteps() {
  var result = { steps: [], ammoDropped: false, fuelShort: false };
  var acft = lastSeededAircraftState || initialAircraftState;
  if (!acft) return result;
  var plan = getPlannerState();
  var ammoOk = g_noAmmoSourceRequired || !!(g_rearmData && g_rearmData.trucks && g_rearmData.trucks.length);
  function add(label, seconds, needsAmmo) {
    if (needsAmmo && !ammoOk) { result.ammoDropped = true; return; }
    result.steps.push({ label: label, seconds: seconds });
  }

  var fcrHave = !!acft.fcrActive;
  var fcrWant = !!plan.fcrActive;
  var iafsHave = (acft.robbieMode || 'iafs') === 'iafs';
  var iafsWant = (plan.robbieMode || 'iafs') === 'iafs';
  var gunHave = Math.max(0, acft.cannonRds || 0);
  var gunWant = Math.max(0, Math.min(iafsWant ? 300 : 1200, Math.round(plan.cannonRds || 0)));
  var gunFrom = iafsHave !== iafsWant ? 0 : gunHave;

  if (fcrHave && !fcrWant) add('Removing the FCR', 300);
  if (iafsHave !== iafsWant) {
    if (iafsWant && gunHave > 0) add('Unloading the gun', gunHave / 10, true);
    add(iafsWant ? 'Fitting the IAFS' : 'Removing the IAFS', 300, true);
  }
  if (gunWant !== gunFrom) add('Gun to ' + gunWant + ' rounds', Math.abs(gunWant - gunFrom) / 10, true);

  var loaded = function(st) { return st[0] !== '' && st[0] !== 'pod' && st[0] !== 'rail'; };
  var rocket = function(st) { return st[0] === 'rocket' || st[0] === 'pod'; };
  for (var p = 0; p < 4; p++) {
    var have = pylonStations(acft.pylons && acft.pylons[p], true);
    var want = pylonStations(plan.pylons && plan.pylons[p], false);
    for (var s = 0; s < 4; s++) {
      var h = have[s];
      var w = want[s];
      var same = h[0] === w[0] && h[1] === w[1];
      if (same && !(loaded(w) && h[2] === 0 && w[2] > 0) && !(w[0] === 'rocket' && h[2] !== w[2])) continue;
      var seconds = 5;
      if (rocket(h) || rocket(w)) seconds = Math.max(1, same ? Math.abs(w[2] - h[2]) : h[2] + w[2]);
      add('Pylon ' + (p + 1), seconds, true);
    }
  }

  if (fuelPlanChanged(plan.fuel, acft.fuel)) {
    var kgWant = fuelPlanKg(plan.fuel);
    var kgHave = fuelPlanKg(acft.fuel);
    var litres = Math.abs(kgWant - kgHave) / 0.8;
    var refuel = kgWant > kgHave;
    if (refuel && !g_noFuelSourceRequired) {
      var src = (g_farpFuelSources || [])[0];
      if (!src) {
        result.fuelShort = true;
        litres = 0;
      } else if (src.liters >= 0 && src.liters < litres) {
        result.fuelShort = true;
        litres = src.liters;
      }
    }
    if (litres > 1.25) add(refuel ? 'Refuelling' : 'Defuelling', litres / (fzaMplanner_fuelRateLS || 8));
  }
  if (!fcrHave && fcrWant) add('Fitting the FCR', 300);
  if ((plan.msnEquip || 'US') !== (acft.msnEquip || 'US')) add('Fitting mission equipment', 30);
  if (plan.tailNum && plan.tailNum !== (acft.tailNum || '')) add('Painting the tail number', 10);
  return result;
}

function formatRearmTime(secs) {
  if (secs < 60) return secs + 's';
  var s = secs % 60;
  return Math.floor(secs / 60) + 'm ' + (s < 10 ? '0' : '') + s + 's';
}

function updateConversionWarning() {
  var warningEl = document.getElementById('conversionWarning');
  if (!warningEl || !initialAircraftState) return;
  var fcrAlertEl = document.getElementById('fcrChangeAlert');
  var iafsAlertEl = document.getElementById('iafsChangeAlert');

  var curState = getPlannerState();
  var acft = lastSeededAircraftState || initialAircraftState;
  var fcrChanged = !!curState.fcrActive !== !!acft.fcrActive;
  var iafsChanged = (curState.robbieMode || 'iafs') !== (acft.robbieMode || 'iafs');
  var applyPlan = planApplySteps();
  var steps = applyPlan.steps;
  var rearmMode = (typeof g_rearmMode !== 'undefined') ? g_rearmMode : 1;

  if (steps.length) {
    var warnText, warnTitle, urgent;

    if (rearmMode === 0) {
      warnText  = '\u26A0 Instant REARM';
      warnTitle = 'Changes will be applied instantly';
      urgent    = false;
    } else if (rearmMode === 1) {
      warnText  = '\u26A0 ~30s REARM';
      warnTitle = steps.length + ' steps of ~' + Math.max(1, Math.round(30 / steps.length)) + 's each';
      urgent    = false;
    } else {
      var totalSecs = Math.round(steps.reduce(function(t, st) { return t + st.seconds; }, 0));
      warnText  = '\u26A0 ~' + formatRearmTime(totalSecs) + ' REARM';
      warnTitle = 'Estimated total time for ' + steps.length + ' steps';
      urgent    = totalSecs > 120;
    }

    warningEl.textContent = warnText;
    warningEl.title = warnTitle;
    warningEl.classList.remove('hidden');
    if (urgent) warningEl.classList.add('rearm-urgent');
    else warningEl.classList.remove('rearm-urgent');
  } else {
    warningEl.classList.add('hidden');
    warningEl.classList.remove('rearm-urgent');
  }

  // 300s FCR/IAFS alerts only apply in Per Item mode; suppressed in Instant and 30 Seconds
  var showStructuralAlerts = rearmMode === 2;
  if (fcrAlertEl) {
    if (fcrChanged && showStructuralAlerts) fcrAlertEl.classList.remove('hidden');
    else fcrAlertEl.classList.add('hidden');
  }
  if (iafsAlertEl) {
    if (iafsChanged && showStructuralAlerts) iafsAlertEl.classList.remove('hidden');
    else iafsAlertEl.classList.add('hidden');
  }

  // Red fuel inputs: a refuel the nearest required fuel source can't fully make
  var fuelWarnActive = applyPlan.fuelShort;
  var fuelWarnClass = 'fuel-src-warn';
  ['fuelFwd','fuelAft','fuelCtr','fuelAux','fuelPct'].forEach(function(fid) {
    var fel = document.getElementById(fid);
    if (!fel) return;
    if (fuelWarnActive) fel.classList.add(fuelWarnClass);
    else fel.classList.remove(fuelWarnClass);
  });
}

// ── Unsaved-changes tracking ──────────────────────────────────────────────────
var lastAppliedOrLoadedState = null;

function plannerSnapshot() {
  var cur = getPlannerState();
  return {
    fcrActive:  cur.fcrActive,
    robbieMode: cur.robbieMode,
    tailNum:    cur.tailNum    || '',
    msnEquip:   cur.msnEquip   || 'US',
    cannonRds:  cur.cannonRds  || 0,
    fuel:   JSON.parse(JSON.stringify(cur.fuel   || {})),
    pylons: JSON.parse(JSON.stringify(cur.pylons || []))
  };
}

function markConfigClean() {
  lastAppliedOrLoadedState = plannerSnapshot();
}

// What the aircraft holds: Apply to ACFT is lit while the planner differs from it
var acftAppliedState = null;

function markAircraftState() {
  acftAppliedState = JSON.stringify(plannerSnapshot());
  syncApplyPending();
}

function syncApplyPending() {
  var b = document.getElementById('btnApplyConfig');
  if (b) b.classList.toggle('pending', acftAppliedState !== null && JSON.stringify(plannerSnapshot()) !== acftAppliedState);
}

function hasPlannerChanges() {
  var base = lastAppliedOrLoadedState;
  if (!base) return false;
  var cur = getPlannerState();
  if (cur.fcrActive !== base.fcrActive) return true;
  if ((cur.robbieMode || 'iafs') !== (base.robbieMode || 'iafs')) return true;
  if ((cur.tailNum    || '')    !== (base.tailNum    || ''))    return true;
  if ((cur.msnEquip   || 'US')  !== (base.msnEquip   || 'US'))  return true;
  if ((cur.cannonRds  || 0)     !== (base.cannonRds  || 0))     return true;
  if (JSON.stringify(cur.fuel   || {}) !== JSON.stringify(base.fuel   || {})) return true;
  if (JSON.stringify(cur.pylons || []) !== JSON.stringify(base.pylons || [])) return true;
  return false;
}

function openCloseConfirmDialog() {
  var modal = document.getElementById('closeConfirmModal');
  if (modal) { modal.classList.add('visible'); modal.setAttribute('aria-hidden', 'false'); }
}

function closeCloseConfirmDialog() {
  var modal = document.getElementById('closeConfirmModal');
  if (modal) { modal.classList.remove('visible'); modal.setAttribute('aria-hidden', 'true'); }
}

// Highlight rail selects yellow when a rail has a missile classname but ammo=0 (fired)
// and the current plan still has a missile on that rail (i.e. it will be rearmed by Apply).
function syncFiredRailHighlights() {
  eachNode('.rail-ammo', function(sel) { sel.classList.remove('rail-fired'); });
  if (!initialAircraftState || !initialAircraftState.pylons) return;
  var curPylons = getPlannerState().pylons || [];
  var railKeys = ['tr', 'tl', 'br', 'bl'];
  for (var pi = 0; pi < 4; pi++) {
    var initP = initialAircraftState.pylons[pi];
    if (!initP || initP.type !== 'hellfire') continue;
    var ammos = initP.ammos || [];
    var initRails = initP.rails || [];
    var curP = curPylons[pi] || {};
    var curRails = (curP.type === 'hellfire') ? (curP.rails || []) : [];
    for (var ri = 0; ri < railKeys.length; ri++) {
      var wasFired = !!(initRails[ri] && initRails[ri] !== '') &&
                     (typeof ammos[ri] !== 'undefined' && ammos[ri] === 0);
      if (!wasFired) continue;
      if (!(curRails[ri] && curRails[ri] !== '')) continue;
      if ((curRails[ri] || '') !== (initRails[ri] || '')) continue;
      var railEl = document.getElementById('p' + (pi + 1) + '_' + railKeys[ri]);
      if (railEl) railEl.classList.add('rail-fired');
    }
  }
}

// Returns a copy of the current planner state with ammo-warn (red) items stripped so SQF
// never rearms what the planner flagged as unaffordable.
// Hellfire rails: reverted to '' — SQF assigns fza_agm114_rail (cost=0, model visible).
// Rocket zones: reverted to initial zone (pod stays loaded, no new rockets charged).
// Cannon: reverted to initial round count (no pylon slot involved).
function getAffordableApplyState() {
  var state = getPlannerState();
  // Use the most recently seeded heli state for reverts so fired ammo is not re-charged.
  // initialAircraftState is only set once (on first open) and may be stale.
  var seedState = lastSeededAircraftState || initialAircraftState;
  var initPylons = (seedState && seedState.pylons) ? seedState.pylons : [];
  var railKeyOrder = ['tr', 'tl', 'br', 'bl'];

  // Cannon
  var cannonEl = document.getElementById('cannonRds');
  if (cannonEl && cannonEl.classList.contains('ammo-warn')) {
    state.cannonRds = (seedState && typeof seedState.cannonRds === 'number')
      ? seedState.cannonRds
      : (state.cannonRds || 0);
  }

  // Hellfire rails — send '' so SQF loads the empty-rail placeholder (fza_agm114_rail, cost=0).
  // This ensures the pod model stays visible even when a rail is unaffordable.
  eachNode('.rail-ammo.ammo-warn', function(sel) {
    var m = /^p([1-4])_(tr|tl|br|bl)$/.exec(sel.id || '');
    if (!m) return;
    var pylonIdx = parseInt(m[1], 10) - 1;
    var ri = railKeyOrder.indexOf(m[2]);
    if (ri < 0 || !state.pylons[pylonIdx] || !state.pylons[pylonIdx].rails) return;
    state.pylons[pylonIdx].rails[ri] = '';
  });

  // Rocket zones — revert to initial zone so the pod stays loaded at its original count.
  eachNode('.zone-count input.ammo-warn', function(inp) {
    var m = /^p([1-4])_(z[a-z]+)_count$/.exec(inp.id || '');
    if (!m) return;
    var pylonIdx = parseInt(m[1], 10) - 1;
    var zoneKey = m[2];
    var zoneIds = getZoneIdsForPylon(parseInt(m[1], 10));
    var zi = -1;
    for (var k = 0; k < zoneIds.length; k++) {
      if (zoneIds[k][0] === zoneKey) { zi = k; break; }
    }
    if (zi < 0 || !state.pylons[pylonIdx] || !state.pylons[pylonIdx].zones) return;
    var initP = initPylons[pylonIdx] || {};
    var initZones = (initP.type === 'rocket') ? (initP.zones || []) : [];
    var initZone = initZones[zi] || { count: 0, type: '' };
    state.pylons[pylonIdx].zones[zi] = { count: initZone.count || 0, type: initZone.type || '' };
  });

  return state;
}