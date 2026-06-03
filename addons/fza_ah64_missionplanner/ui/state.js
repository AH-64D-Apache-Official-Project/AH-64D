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
      out.zoneB = (zones[1] && zones[1].count > 0 && zones[1].type) ? mapPlannerRocketTypeToLegacy(zones[1].type) : '';
      out.zoneE = (zones[2] && zones[2].count > 0 && zones[2].type) ? mapPlannerRocketTypeToLegacy(zones[2].type) : '';
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
        var code = pylon.rails[railIndex] || '';
        railEl.value = hellfireCodeMap[code] || 'None';
        // Sync the cycle button by matching select index within its parent
        var parent = railEl.parentNode;
        var parentSelects = parent.querySelectorAll('.rail-ammo');
        var parentCycleBtns = parent.querySelectorAll('button.rail-cycle');
        var selIdx = Array.prototype.indexOf.call(parentSelects, railEl);
        var cycleBtn = selIdx >= 0 ? parentCycleBtns[selIdx] : null;
        if (cycleBtn) {
          var idx = hellfireCycleOrder.indexOf(code);
          if (idx < 0) idx = 0;
          setData(cycleBtn, 'index', idx);
          cycleBtn.textContent = code === '' ? '-' : code;
        }
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

  // Count pylon differences: hellfire at 5s/changed rail; type change or non-HF content change = 20s flat
  var pylonChangedSecs = 0;
  if (initialAircraftState.pylons && curState.pylons) {
    for (var pi = 0; pi < 4; pi++) {
      var initP = initialAircraftState.pylons[pi] || { type: 'none' };
      var curP = curState.pylons[pi] || { type: 'none' };
      if (JSON.stringify(initP) === JSON.stringify(curP)) continue;
      if (initP.type !== curP.type) {
        // Pylon type changed â€” always requires physical unload/reload
        pylonChangedSecs += 20;
      } else if (initP.type === 'hellfire') {
        // Both are hellfire: 5s per individually changed rail
        var initRails = initP.rails || ['', '', '', ''];
        var curRails = curP.rails || ['', '', '', ''];
        for (var ri = 0; ri < 4; ri++) {
          if ((initRails[ri] || '') !== (curRails[ri] || '')) { pylonChangedSecs += 5; }
        }
      } else {
        // Same non-hellfire type (e.g. rocket zone count/type changed)
        pylonChangedSecs += 20;
      }
    }
  }

  // Fuel time estimate: delta gallons * 3.785 L/gal / ACE rate
  var fuelTimeSecs = 0;
  if (initialAircraftState.fuel && curState.fuel) {
    var initFuelGal = (initialAircraftState.fuel.fwd||0) + (initialAircraftState.fuel.aft||0) + (initialAircraftState.fuel.ctr||0);
    var curFuelGal = (curState.fuel.fwd||0) + (curState.fuel.aft||0) + (curState.fuel.ctr||0);
    var fuelDeltaGal = Math.abs(curFuelGal - initFuelGal);
    if (fuelDeltaGal > 5) {
      fuelTimeSecs = Math.round(fuelDeltaGal * 3.785 / fzaMplanner_fuelRateLS);
    }
  }

  // Cannon time estimate: ~1s per 50 rounds delta
  var cannonTimeSecs = 0;
  if (typeof initialAircraftState.cannonRds === 'number') {
    var cannonDelta = Math.abs((curState.cannonRds || 0) - initialAircraftState.cannonRds);
    if (cannonDelta > 0) { cannonTimeSecs = Math.round(cannonDelta / 10); }
  }

  var totalSecs = 0;
  if (fcrChanged) totalSecs += 300;
  if (iafsChanged) totalSecs += 300;
  if (msnEquipChanged) totalSecs += 30;
  if (tailChanged) totalSecs += 10;
  totalSecs += pylonChangedSecs;
  totalSecs += fuelTimeSecs;
  totalSecs += cannonTimeSecs;

  var anyChange = fcrChanged || iafsChanged || tailChanged || msnEquipChanged || pylonChangedSecs > 0 || fuelTimeSecs > 0 || cannonTimeSecs > 0;

  if (anyChange) {
    warningEl.textContent = '\u26A0 ~' + totalSecs + 's REARM';
    warningEl.title = 'Estimated total time for this config change';
    warningEl.classList.remove('hidden');
    if (totalSecs > 120) warningEl.classList.add('rearm-urgent');
    else warningEl.classList.remove('rearm-urgent');
  } else {
    warningEl.classList.add('hidden');
    warningEl.classList.remove('rearm-urgent');
  }

  if (fcrAlertEl) {
    if (fcrChanged) fcrAlertEl.classList.remove('hidden');
    else fcrAlertEl.classList.add('hidden');
  }
  if (iafsAlertEl) {
    if (iafsChanged) iafsAlertEl.classList.remove('hidden');
    else iafsAlertEl.classList.add('hidden');
  }
}