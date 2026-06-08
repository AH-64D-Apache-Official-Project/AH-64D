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
      out.zoneA = (zones[0] && zones[0].count > 0 && zones[0].type) ? mapPlannerRocketTypeToLegacy(zones[0].type) : '';
      out.zoneACount = zones[0] ? (parseInt(zones[0].count, 10) || 0) : 0;
      out.zoneB = (zones[1] && zones[1].count > 0 && zones[1].type) ? mapPlannerRocketTypeToLegacy(zones[1].type) : '';
      out.zoneBCount = zones[1] ? (parseInt(zones[1].count, 10) || 0) : 0;
      out.zoneE = (zones[2] && zones[2].count > 0 && zones[2].type) ? mapPlannerRocketTypeToLegacy(zones[2].type) : '';
      out.zoneECount = zones[2] ? (parseInt(zones[2].count, 10) || 0) : 0;
    }

    payload[pylonKey] = out;
  }

  return payload;
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

function updateConversionWarning() {
  var warningEl = document.getElementById('conversionWarning');
  if (!warningEl || !initialAircraftState) return;
  var fcrAlertEl = document.getElementById('fcrChangeAlert');
  var iafsAlertEl = document.getElementById('iafsChangeAlert');

  var curState = getPlannerState();
  var fcrChanged = curState.fcrActive !== initialAircraftState.fcrActive;
  var iafsChanged = curState.robbieMode !== initialAircraftState.robbieMode;
  var tailChanged = curState.tailNum !== initialAircraftState.tailNum;
  var msnEquipChanged = curState.msnEquip !== initialAircraftState.msnEquip;

  // Track rocket and non-rocket pylon seconds separately so mode-1 can show accurate estimates.
  // Rockets: 1s per rocket loaded or unloaded per zone.
  // Non-rocket: flat 5s per hellfire rail change, 20s per type swap.
  var rocketChangedSecs = 0;
  var nonRocketChangedSecs = 0;
  var hasNonRocketPylonChanges = false;

  if (initialAircraftState.pylons && curState.pylons) {
    for (var pi = 0; pi < 4; pi++) {
      var initP = initialAircraftState.pylons[pi] || { type: 'none' };
      var curP = curState.pylons[pi] || { type: 'none' };
      if (JSON.stringify(initP) === JSON.stringify(curP)) continue;
      if (initP.type !== curP.type) {
        nonRocketChangedSecs += 20;
        hasNonRocketPylonChanges = true;
      } else if (initP.type === 'hellfire') {
        var initRails = initP.rails || ['', '', '', ''];
        var curRails = curP.rails || ['', '', '', ''];
        for (var ri = 0; ri < 4; ri++) {
          if ((initRails[ri] || '') !== (curRails[ri] || '')) {
            nonRocketChangedSecs += 5;
            hasNonRocketPylonChanges = true;
          }
        }
      } else if (initP.type === 'rocket') {
        var initZones = initP.zones || [];
        var curZones  = curP.zones  || [];
        var numZones  = Math.max(initZones.length, curZones.length, 3);
        for (var zi = 0; zi < numZones; zi++) {
          var iz = initZones[zi] || { count: 0, type: '' };
          var cz = curZones[zi]  || { count: 0, type: '' };
          var initCount = iz.count || 0;
          var planCount = cz.count || 0;
          var initType = (iz.type || '').trim().toUpperCase();
          var planType = (cz.type || '').trim().toUpperCase();
          var delta = (initType === planType)
            ? Math.abs(planCount - initCount)
            : (initCount + planCount);
          rocketChangedSecs += delta;
        }
      } else {
        nonRocketChangedSecs += 20;
        hasNonRocketPylonChanges = true;
      }
    }
  }

  // Fuel change detection (for anyChange and mode-1 op count)
  var hasFuelChange = false;
  var fuelTimeSecs = 0;
  var noFuelReq = (typeof g_noFuelSourceRequired !== 'undefined') ? g_noFuelSourceRequired : true;
  if (initialAircraftState && initialAircraftState.fuel && curState.fuel) {
    var initFuelGal = (initialAircraftState.fuel.fwd||0) + (initialAircraftState.fuel.aft||0) + (initialAircraftState.fuel.ctr||0);
    var curFuelGal = (curState.fuel.fwd||0) + (curState.fuel.aft||0) + (curState.fuel.ctr||0);
    var fuelDeltaGal = Math.abs(curFuelGal - initFuelGal);
    if (fuelDeltaGal > 5) {
      hasFuelChange = true;
      if (!noFuelReq) {
        fuelTimeSecs = Math.round(fuelDeltaGal * 3.785 / fzaMplanner_fuelRateLS);
      }
    }
  }

  // Cannon time: ~1s per 50 rounds delta
  var cannonTimeSecs = 0;
  if (typeof initialAircraftState.cannonRds === 'number') {
    var cannonDelta = Math.abs((curState.cannonRds || 0) - initialAircraftState.cannonRds);
    if (cannonDelta > 0) { cannonTimeSecs = Math.round(cannonDelta / 10); }
  }

  var pylonChangedSecs = nonRocketChangedSecs + rocketChangedSecs;
  var anyChange = fcrChanged || iafsChanged || tailChanged || msnEquipChanged || pylonChangedSecs > 0 || hasFuelChange || cannonTimeSecs > 0;
  var rearmMode = (typeof g_rearmMode !== 'undefined') ? g_rearmMode : 2;

  if (anyChange) {
    var warnText, warnTitle, urgent;

    if (rearmMode === 0) {
      warnText  = '\u26A0 Instant REARM';
      warnTitle = 'Changes will be applied instantly';
      urgent    = false;
    } else if (rearmMode === 1) {
      warnText  = '\u26A0 ~30s REARM';
      warnTitle = 'Each change takes 30s \u00F7 total operations (~' + Math.max(1, Math.round(30 / Math.max(1, (fcrChanged ? 1 : 0) + (iafsChanged ? 1 : 0) + (tailChanged ? 1 : 0) + (msnEquipChanged ? 1 : 0) + (cannonTimeSecs > 0 ? 1 : 0) + (hasFuelChange ? 1 : 0) + Math.ceil(nonRocketChangedSecs / 5) + Math.ceil(rocketChangedSecs)))) + 's each)';
      urgent    = false;
    } else {
      var totalSecs = 0;
      if (fcrChanged)      totalSecs += 300;
      if (iafsChanged)     totalSecs += 300;
      if (msnEquipChanged) totalSecs += 30;
      if (tailChanged)     totalSecs += 10;
      totalSecs += pylonChangedSecs + fuelTimeSecs + cannonTimeSecs;
      warnText  = '\u26A0 ~' + totalSecs + 's REARM';
      warnTitle = 'Estimated total time for this config change';
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

  // 300s FCR/IAFS alerts only apply in ACE Settings mode; suppressed in Instant and 30 Seconds
  var showStructuralAlerts = rearmMode === 2;
  if (fcrAlertEl) {
    if (fcrChanged && showStructuralAlerts) fcrAlertEl.classList.remove('hidden');
    else fcrAlertEl.classList.add('hidden');
  }
  if (iafsAlertEl) {
    if (iafsChanged && showStructuralAlerts) iafsAlertEl.classList.remove('hidden');
    else iafsAlertEl.classList.add('hidden');
  }

  // Fuel source availability warning — red on fuel inputs when a refuel is planned
  // but no sources are available and one is required
  var fuelWarnActive = false;
  var noFuelReqNow = (typeof g_noFuelSourceRequired !== 'undefined') ? g_noFuelSourceRequired : true;
  if (!noFuelReqNow && initialAircraftState && initialAircraftState.fuel && curState.fuel) {
    var initFuelGalW = (initialAircraftState.fuel.fwd||0) + (initialAircraftState.fuel.aft||0) + (initialAircraftState.fuel.ctr||0);
    var curFuelGalW  = (curState.fuel.fwd||0) + (curState.fuel.aft||0) + (curState.fuel.ctr||0);
    if (curFuelGalW > initFuelGalW + 1) {
      var farpSources = (typeof g_farpFuelSources !== 'undefined') ? g_farpFuelSources : [];
      var availL = 0; var unlimFuel = false;
      for (var fsi = 0; fsi < farpSources.length; fsi++) {
        if ((farpSources[fsi].liters || 0) < 0) { unlimFuel = true; break; }
        availL += (farpSources[fsi].liters || 0);
      }
      var neededL = (curFuelGalW - initFuelGalW) * 3.785;
      fuelWarnActive = !unlimFuel && (farpSources.length === 0 || availL < neededL);
    }
  }
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

function markConfigClean() {
  var cur = getPlannerState();
  lastAppliedOrLoadedState = {
    fcrActive:  cur.fcrActive,
    robbieMode: cur.robbieMode,
    tailNum:    cur.tailNum    || '',
    msnEquip:   cur.msnEquip   || 'US',
    cannonRds:  cur.cannonRds  || 0,
    fuel:   JSON.parse(JSON.stringify(cur.fuel   || {})),
    pylons: JSON.parse(JSON.stringify(cur.pylons || []))
  };
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