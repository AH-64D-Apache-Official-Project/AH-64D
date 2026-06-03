// weights_perf.js -- weight metrics, ammo warnings, and fuel calculation

var weightModelBaseline = null;

function computeLoadoutWeightMetrics() {
  var rocketCount = 0;
  var hellfireCount = 0;
  var externalDryWeight = 0;
  var hasAuxTank = false;

  for (var i = 1; i <= 4; i++) {
    var modeEl = document.getElementById('pylon' + i + 'Type');
    var mode = modeEl ? modeEl.value : 'none';

    if (mode === 'hellfire') {
      externalDryWeight += EST_M299_EMPTY_LBS;
      hellfireCount += countHellfiresOnPylon(i);
    } else if (mode === 'rocket') {
      externalDryWeight += EST_M261_EMPTY_LBS;
      rocketCount += countRocketsOnPylon(i);
    } else if (mode === 'aux') {
      externalDryWeight += EST_AUX_TANK_EMPTY_LBS;
      hasAuxTank = true;
    }
  }

  var cannonRounds = parseInt(document.getElementById('cannonRds').value || '0', 10) || 0;
  var ammoWeightCalc = (rocketCount * EST_ROCKET_ROUND_LBS) + (hellfireCount * EST_HELLFIRE_LBS) + (cannonRounds * EST_30MM_ROUND_LBS);

  var fcrWeight = document.getElementById('fcrBadge').classList.contains('active') ? EST_FCR_LBS : 0;
  var centerStoreWeight = document.getElementById('robbieMode').value === 'iafs' ? EST_IAFS_LBS : EST_MAGAZINE_LBS;
  var equipmentWeightCalc = externalDryWeight + fcrWeight + centerStoreWeight;

  var auxFuelLbs = parseNumberText(document.getElementById('fuelAuxLbs').textContent);
  var jettisonWeightCalc = externalDryWeight + ammoWeightCalc + (hasAuxTank ? auxFuelLbs : 0);

  return {
    ammoWeight: Math.round(ammoWeightCalc),
    jettisonWeight: Math.round(jettisonWeightCalc),
    equipmentWeight: Math.round(equipmentWeightCalc)
  };
}


function updateAmmoWarnings() {
  // Clear all supply warnings
  eachNode('.rail-cycle', function(btn) { btn.classList.remove('ammo-warn'); });
  eachNode('.zone-count input', function(inp) { inp.classList.remove('ammo-warn'); });
  eachNode('.zone-type select', function(sel) { sel.classList.remove('ammo-warn'); });
  var cannonEl = document.getElementById('cannonRds');
  if (cannonEl) cannonEl.classList.remove('ammo-warn');
  var supplyEl = document.getElementById('supplyTally');
  if (supplyEl) { supplyEl.textContent = ''; supplyEl.className = 'supply-tally'; }
  var debugEl = document.getElementById('rearmDebug');
  if (debugEl) debugEl.style.display = 'none';

  // Only enforce in mode 1 (caliber pool) or mode 2 (magazine inventory)
  if (!g_rearmData || !g_rearmData.costs) {
    updateAmmoTypes(null);
    if (debugEl) { debugEl.textContent = 'DBG rearm: g_rearmData=' + JSON.stringify(g_rearmData); debugEl.style.display = ''; }
    return;
  }
  if (g_rearmData.unlimited || g_rearmData.mode === 0) {
    updateAmmoTypes(null);
    if (debugEl) { debugEl.textContent = 'DBG rearm: mode=' + g_rearmData.mode + ' unlimited=' + g_rearmData.unlimited + ' (no enforcement)'; debugEl.style.display = ''; }
    return;
  }
  if (!g_rearmData.rearmNewPylons) {
    updateAmmoTypes(null);
    if (debugEl) { debugEl.textContent = 'DBG rearm: rearmNewPylons=false (ACE handles supply at rearm time)'; debugEl.style.display = ''; }
    return;
  }

  var baseSupply = g_rearmData.totalSupply;
  var costs = g_rearmData.costs;
  var state = getPlannerState();
  var initPylons = (initialAircraftState && initialAircraftState.pylons) ? initialAircraftState.pylons : [];
  var railKeys = ['tr', 'tl', 'br', 'bl'];
  var plannedCannon = state.cannonRds || 0;
  var initCannon = (initialAircraftState && typeof initialAircraftState.cannonRds === 'number') ? initialAircraftState.cannonRds : plannedCannon;

  // Recycled credit: items removed/reduced from the initial loadout return supply value,
  // making ammo freely redistributable across pylons rather than pylon-specific.
  var recyclableCredit = 0;
  var cannonReducedRds = Math.max(0, initCannon - plannedCannon);
  if (cannonReducedRds > 0) recyclableCredit += Math.floor(cannonReducedRds / 50) * (costs.cannon || 30);
  for (var rci = 1; rci <= 4; rci++) {
    var rcPylon = state.pylons[rci - 1] || { type: 'none' };
    var rcInit  = initPylons[rci - 1] || { type: 'none' };
    if (rcInit.type === 'hellfire') {
      var rcInitRails = rcInit.rails || [];
      var rcPlanRails = (rcPylon.type === 'hellfire') ? (rcPylon.rails || []) : [];
      for (var rk = 0; rk < 4; rk++) {
        if (!!(rcInitRails[rk] && rcInitRails[rk] !== '') && !(rcPlanRails[rk] && rcPlanRails[rk] !== '')) {
          recyclableCredit += (costs.hellfire || 50);
        }
      }
    } else if (rcInit.type === 'rocket') {
      var rcInitZones = rcInit.zones || [];
      var rcPlanZones = (rcPylon.type === 'rocket') ? (rcPylon.zones || []) : [];
      for (var rz = 0; rz < rcInitZones.length; rz++) {
        var rcReduced = Math.max(0, ((rcInitZones[rz] || {}).count || 0) - ((rcPlanZones[rz] || {}).count || 0));
        if (rcReduced > 0) recyclableCredit += rcReduced * (costs.rocket || 5);
      }
    } else if (rcInit.type === 'aux' && rcPylon.type !== 'aux') {
      recyclableCredit += (costs.aux || 50);
    }
  }
  var avail = baseSupply + recyclableCredit;

  // â”€â”€ 1. Cannon reserve (computed first to match SQF's budget priority) â”€â”€
  var cannonNewRds = Math.max(0, plannedCannon - initCannon);
  var cannonCost = cannonNewRds > 0 ? Math.ceil(cannonNewRds / 50) * (costs.cannon || 30) : 0;
  var pylonBudget = avail - cannonCost;
  if (cannonCost > 0 && pylonBudget < 0) {
    if (cannonEl) cannonEl.classList.add('ammo-warn');
  }

  // â”€â”€ 2. Build flat item list; sort oldest-modification-first so last-changed gets bumped â”€â”€
  var costItems = [];
  for (var pii = 1; pii <= 4; pii++) {
    var pylon = state.pylons[pii - 1] || { type: 'none' };
    var initP = initPylons[pii - 1] || { type: 'none' };
    if (pylon.type === 'hellfire') {
      var rails = pylon.rails || [];
      var initRails = (initP.type === 'hellfire') ? (initP.rails || []) : [];
      for (var ri = 0; ri < railKeys.length; ri++) {
        var wasLoaded = !!(initRails[ri] && initRails[ri] !== '');
        var isLoaded  = !!(rails[ri]     && rails[ri]     !== '');
        if (isLoaded && !wasLoaded) {
          var hfKey = 'p' + pii + '_' + railKeys[ri];
          costItems.push({ type: 'hellfire', pylonIdx: pii, railIdx: ri,
            cost: costs.hellfire || 50, seq: g_itemOrder[hfKey] || 0, key: hfKey });
        }
      }
    } else if (pylon.type === 'rocket') {
      var zones = pylon.zones || [];
      var initZones = (initP.type === 'rocket') ? (initP.zones || []) : [];
      var zoneIds = getZoneIdsForPylon(pii);
      for (var zi = 0; zi < zones.length; zi++) {
        var zone = zones[zi];
        var initZone = initZones[zi] || { count: 0, type: '' };
        var plannedCount = (zone && zone.count > 0) ? zone.count : 0;
        var initCount = initZone.count || 0;
        var newCount = Math.max(0, plannedCount - initCount);
        if (newCount > 0) {
          var zkPair = zoneIds[zi];
          var rkKey = 'p' + pii + '_' + zkPair[0];
          costItems.push({ type: 'rocket', pylonIdx: pii, zoneIdx: zi,
            cost: newCount * (costs.rocket || 5), seq: g_itemOrder[rkKey] || 0,
            key: rkKey, zkPair: zkPair });
        }
      }
    } else if (pylon.type === 'aux' && initP.type !== 'aux') {
      costItems.push({ type: 'aux', pylonIdx: pii,
        cost: costs.aux || 50, seq: g_pylonOrder['p' + pii] || 0, key: 'p' + pii + '_aux' });
    }
  }
  // Oldest modification = highest priority; most recently changed gets bumped first
  costItems.sort(function(a, b) { return (a.seq - b.seq) || (a.key < b.key ? -1 : 1); });
  var pylonCost = 0;
  for (var ci = 0; ci < costItems.length; ci++) {
    var item = costItems[ci];
    var willFit = item.cost <= (pylonBudget - pylonCost);
    pylonCost += item.cost;
    if (!willFit) {
      if (item.type === 'hellfire') {
        var railBtn = document.querySelector('button.rail-cycle[data-rail="' + item.key + '"]');
        if (railBtn) railBtn.classList.add('ammo-warn');
      } else if (item.type === 'rocket') {
        var cntEl = document.getElementById('p' + item.pylonIdx + '_' + item.zkPair[0] + '_count');
        var typEl = document.getElementById('p' + item.pylonIdx + '_' + item.zkPair[0] + '_type');
        if (cntEl) cntEl.classList.add('ammo-warn');
        if (typEl) typEl.classList.add('ammo-warn');
      }
    }
  }

  var newCost = cannonCost + pylonCost;
  if (supplyEl) {
    if (baseSupply <= 0 && recyclableCredit <= 0) {
      supplyEl.textContent = 'Supply: no sources nearby' + (newCost > 0 ? ' (' + newCost + ' pts needed for new items)' : '');
      supplyEl.className = 'supply-tally' + (newCost > 0 ? ' supply-over' : '');
    } else {
      var tallyStr = 'Supply: ' + newCost + ' / ' + baseSupply;
      if (recyclableCredit > 0) tallyStr += ' (+' + recyclableCredit + ' recycled)';
      supplyEl.textContent = tallyStr + ' pts (new items only)';
      supplyEl.className = 'supply-tally ' + (newCost > avail ? 'supply-over' : 'supply-ok');
    }
  }
  updateAmmoTypes(Math.max(0, avail - newCost));
}

function updateAmmoTypes(remaining) {
  var el = document.getElementById('ammoTypesSection');
  if (!el) return;
  if (!g_rearmData || !g_rearmData.costs) { el.innerHTML = ''; return; }
  var rc = g_rearmData.costs;
  var isUnlim = g_rearmData.unlimited || g_rearmData.mode === 0;
  var hasTrucks = !!(g_rearmData.trucks && g_rearmData.trucks.length);
  if (!isUnlim && !(g_rearmData.mode === 1 && hasTrucks)) { el.innerHTML = ''; return; }
  var html = '<div class="farp-section">';
  html += '<div class="farp-sec-hdr">AMMO TYPES</div>';
  if (isUnlim) {
    html += '<div class="farp-src-row"><span class="farp-src-name">Hellfire</span><span class="farp-src-val">INF</span></div>';
    html += '<div class="farp-src-row"><span class="farp-src-name">Rockets</span><span class="farp-src-val">INF</span></div>';
    html += '<div class="farp-src-row"><span class="farp-src-name">Cannon</span><span class="farp-src-val">INF</span></div>';
    html += '<div class="farp-src-row"><span class="farp-src-name">Aux Tank</span><span class="farp-src-val">INF</span></div>';
  } else {
    var pts = (remaining !== null && remaining !== undefined) ? remaining : g_rearmData.totalSupply;
    var hfc = rc.hellfire || 100, rkc = rc.rocket || 20, cnc = rc.cannon || 30, axc = rc.aux || 50;
    html += '<div class="farp-src-row"><span class="farp-src-name">Hellfire (' + hfc + ' pts ea)</span><span class="farp-src-val">' + Math.floor(pts / hfc) + ' msls</span></div>';
    html += '<div class="farp-src-row"><span class="farp-src-name">Rockets (' + rkc + ' pts/pod)</span><span class="farp-src-val">' + Math.floor(pts / rkc) + ' pods</span></div>';
    html += '<div class="farp-src-row"><span class="farp-src-name">Cannon (' + cnc + ' pts/50rds)</span><span class="farp-src-val">' + (Math.floor(pts / cnc) * 50) + ' rds</span></div>';
    html += '<div class="farp-src-row"><span class="farp-src-name">Aux Tank (' + axc + ' pts ea)</span><span class="farp-src-val">' + Math.floor(pts / axc) + ' tanks</span></div>';
  }
  html += '</div>';
  el.innerHTML = html;
}

function updateWeightsAndPerformance() {
  var fuelTotalLbs = parseNumberText(document.getElementById('fuelTotalLbs').textContent);
  var maxGwt = parseNumberText(document.getElementById('maxGWT').textContent);
  var metrics = computeLoadoutWeightMetrics();

  if (!weightModelBaseline) {
    weightModelBaseline = {
      emptyDisplay: Math.round(EMPTY_MASS_NON_FCR_LBS)
    };
  }

  var ammoDisplay = Math.max(0, metrics.ammoWeight);
  var jettDisplay = Math.max(0, metrics.jettisonWeight);
  var emptyDisplay = Math.max(0, weightModelBaseline.emptyDisplay);
  var currentDisplay = emptyDisplay + metrics.equipmentWeight + fuelTotalLbs + ammoDisplay;

  document.getElementById('ammoWeight').textContent = formatWhole(ammoDisplay);
  document.getElementById('jettisonWeight').textContent = formatWhole(jettDisplay);
  document.getElementById('emptyGWT').textContent = formatWholeComma(emptyDisplay);
  document.getElementById('currentGWT').textContent = formatWhole(currentDisplay);

  var currentGwtEl = document.getElementById('currentGWT');
  if (currentGwtEl) {
    currentGwtEl.classList.remove('caution');
    currentGwtEl.classList.remove('warn');
    if (currentDisplay > maxGwt) {
      currentGwtEl.classList.add('warn');
    } else if ((maxGwt - currentDisplay) <= 1000) {
      currentGwtEl.classList.add('caution');
    }
  }

  document.getElementById('jettisonPct').textContent = '0 %';

  if (!sfmPerfDataReady) {
    document.getElementById('maxEnd').textContent = '--';
    document.getElementById('maxEndPph').textContent = '--';
    document.getElementById('maxRange').textContent = '--';
    document.getElementById('maxRangePph').textContent = '--';
    document.getElementById('vsse').textContent = '--';
    document.getElementById('vsseAfterJett').textContent = '--';
    document.getElementById('maxTqDE').textContent = '--';
    document.getElementById('maxTqSE').textContent = '--';
    document.getElementById('hvrTqIGE').textContent = '--';
    document.getElementById('hvrTqOGE').textContent = '--';
    document.getElementById('powerMarginDE').textContent = '--';
    document.getElementById('maxRodOGE').textContent = '--';
    document.getElementById('maxRodOGEUnit').textContent = 'fpm';
    document.getElementById('endurance').textContent = '--';
    setPerfValueClass('maxEnd', '');
    setPerfValueClass('maxEndPph', '');
    setPerfValueClass('maxRange', '');
    setPerfValueClass('maxRangePph', '');
    setPerfValueClass('vsse', '');
    setPerfValueClass('vsseAfterJett', '');
    setPerfValueClass('maxTqDE', '');
    setPerfValueClass('maxTqSE', '');
    setPerfValueClass('hvrTqIGE', '');
    setPerfValueClass('hvrTqOGE', '');
    setPerfValueClass('powerMarginDE', '');
    setPerfValueClass('maxRodOGE', '');
    updateConversionWarning();
    return;
  }

  var atmosphere = getPerfAtmosphere();
  var perf = computeSfmPerformance(currentDisplay, atmosphere.pa, atmosphere.fat);
  var jettisonStep = Math.round(jettDisplay / 200);
  var maxEnd = Math.round(perf.endTAS);
  var maxEndPph = Math.round(perf.endFF / 10) * 10;
  var maxRange = Math.round(perf.rngTAS);
  var maxRangePph = Math.round(perf.rngFF / 10) * 10;
  var endurance = formatEnduranceFromPph(fuelTotalLbs, perf.rngFF);
  var vsse = Math.round(perf.vsseTAS);
  var vsseAfterJett = Math.max(0, vsse - jettisonStep);

  var maxTqDePct = Math.round(perf.maxTQ_DE * 100);
  var maxTqSePct = Math.round(perf.maxTQ_SE * 100);

  var hvrIgeDePct = Math.round(perf.hvrTQ_IGE * 100);
  var hvrOgeDePct = Math.round(perf.hvrTQ_OGE * 100);
  var powerMarginDePct = Math.min(maxTqDePct, 100) - hvrOgeDePct;
  var maxRodOgeFpm = powerMarginDePct >= 0 ? Math.round((powerMarginDePct / 2) * 100) : null;

  // User rule: each 200 lbs jettisonable mass = 1% torque reduction.
  var torqueDiffPct = jettisonStep > 0 ? -jettisonStep : 0;
  document.getElementById('jettisonPct').textContent = String(torqueDiffPct) + ' %';

  document.getElementById('maxEnd').textContent = formatWhole(maxEnd);
  document.getElementById('maxEndPph').textContent = formatWhole(maxEndPph);
  document.getElementById('maxRange').textContent = formatWhole(maxRange);
  document.getElementById('maxRangePph').textContent = formatWhole(maxRangePph);
  document.getElementById('endurance').textContent = endurance;
  document.getElementById('vsse').textContent = formatWhole(vsse);
  document.getElementById('vsseAfterJett').textContent = formatWhole(vsseAfterJett);

  document.getElementById('maxTqDE').textContent = formatWhole(maxTqDePct);
  document.getElementById('maxTqSE').textContent = formatWhole(maxTqSePct);
  document.getElementById('hvrTqIGE').textContent = formatWhole(hvrIgeDePct);
  document.getElementById('hvrTqOGE').textContent = formatWhole(hvrOgeDePct);
  document.getElementById('powerMarginDE').textContent = formatWhole(powerMarginDePct);
  document.getElementById('maxRodOGE').textContent = maxRodOgeFpm === null ? 'OGE N/A' : formatWhole(maxRodOgeFpm);
  document.getElementById('maxRodOGEUnit').textContent = maxRodOgeFpm === null ? '' : 'fpm';

  setPerfValueClass('maxEnd', '');
  setPerfValueClass('maxEndPph', '');
  setPerfValueClass('maxRange', '');
  setPerfValueClass('maxRangePph', '');
  setPerfValueClass('vsse', '');
  setPerfValueClass('vsseAfterJett', '');

  setPerfValueClass('maxTqDE', 'ok');
  setPerfValueClass('maxTqSE', 'ok');
  setPerfValueClass('hvrTqIGE', hvrIgeDePct > 100 ? 'warn' : (hvrIgeDePct >= 80 ? 'caution' : ''));
  setPerfValueClass('hvrTqOGE', hvrOgeDePct > 100 ? 'warn' : (hvrOgeDePct >= 80 ? 'caution' : ''));
  setPerfValueClass('powerMarginDE', powerMarginDePct <= 0 ? 'warn' : (powerMarginDePct <= 20 ? 'caution' : ''));
  setPerfValueClass('maxRodOGE', maxRodOgeFpm === null ? 'warn' : (powerMarginDePct <= 0 ? 'warn' : (powerMarginDePct <= 20 ? 'caution' : '')));
  updateAmmoWarnings();
  updateConversionWarning();
}

function setFuelFromPercentage() {
  var pctEl = document.getElementById('fuelPct');
  sanitizeFuelInput(pctEl);

  var totalCapacity = 0;
  var internalIds = getInternalFuelIds();
  for (var i = 0; i < internalIds.length; i++) {
    totalCapacity += getFuelMax(internalIds[i]);
  }
  totalCapacity += getFuelMax('fuelAux');

  var pct = parseInt(pctEl.value || '0', 10);
  if (isNaN(pct) || pct < 0) pct = 0;
  if (pct > 100) pct = 100;

  var gallonsToAllocate = Math.round((totalCapacity * pct) / 100);

  // Fill FWD + AFT evenly first.
  var fwdMax = getFuelMax('fuelFwd');
  var aftMax = getFuelMax('fuelAft');
  var pairCapacity = fwdMax + aftMax;
  var pairToAllocate = gallonsToAllocate > pairCapacity ? pairCapacity : gallonsToAllocate;
  var fwd = 0;
  var aft = 0;
  var turn = 0;

  while (pairToAllocate > 0) {
    var canFwd = fwd < fwdMax;
    var canAft = aft < aftMax;
    if (!canFwd && !canAft) break;

    if ((turn % 2 === 0 && canFwd) || !canAft) {
      fwd += 1;
    } else {
      aft += 1;
    }

    pairToAllocate -= 1;
    turn += 1;
  }

  document.getElementById('fuelFwd').value = String(fwd);
  document.getElementById('fuelAft').value = String(aft);
  gallonsToAllocate -= (fwd + aft);

  // Fill center next (if installed/visible).
  var centerFuelRow = document.getElementById('fuelCtrRow');
  if (centerFuelRow && !centerFuelRow.classList.contains('hidden')) {
    var ctrMax = getFuelMax('fuelCtr');
    var ctrValue = gallonsToAllocate > ctrMax ? ctrMax : gallonsToAllocate;
    if (ctrValue < 0) ctrValue = 0;
    document.getElementById('fuelCtr').value = String(ctrValue);
    gallonsToAllocate -= ctrValue;
  } else {
    document.getElementById('fuelCtr').value = '0';
  }

  if (document.getElementById('fuelCtrRow').classList.contains('hidden')) {
    document.getElementById('fuelCtr').value = '0';
  }

  // Fill AUX last.
  var auxMax = getFuelMax('fuelAux');
  var auxValue = gallonsToAllocate > auxMax ? auxMax : gallonsToAllocate;
  if (auxValue < 0) auxValue = 0;
  document.getElementById('fuelAux').value = String(auxValue);

  calcFuel();
}

function syncFuelPctFromTanks() {
  var totalCapacity = 0;
  var totalGallons = 0;
  var fuelIds = ['fuelFwd', 'fuelAft', 'fuelAux'];
  var internalIds = getInternalFuelIds();
  for (var i = 0; i < internalIds.length; i++) {
    if (fuelIds.indexOf(internalIds[i]) === -1) fuelIds.push(internalIds[i]);
  }
  for (var j = 0; j < fuelIds.length; j++) {
    totalCapacity += getFuelMax(fuelIds[j]);
    totalGallons += parseInt(document.getElementById(fuelIds[j]).value || '0', 10) || 0;
  }
  document.getElementById('fuelPct').value = totalCapacity > 0 ? String(Math.round((totalGallons / totalCapacity) * 100)) : '0';
}

function calcFuel() {
  function readClampedFuel(id) {
    var el = document.getElementById(id);
    var raw = (el.value || '').replace(/[^0-9]/g, '');
    var value = raw === '' ? 0 : parseInt(raw, 10);
    var max = parseInt(getData(el, 'max') || el.max || '0', 10);
    if (isNaN(value) || value < 0) value = 0;
    if (!isNaN(max) && max > 0 && value > max) value = max;
    el.value = String(value);
    return value;
  }

  var fwd = readClampedFuel('fuelFwd');
  var aft = readClampedFuel('fuelAft');
  var ctr = readClampedFuel('fuelCtr');
  var aux = readClampedFuel('fuelAux');

  var fwdLbs = Math.round(fwd * GAL_TO_LBS_FWD);
  var aftLbs = Math.round(aft * GAL_TO_LBS_AFT);
  var ctrLbs = Math.round(ctr * GAL_TO_LBS_CTR);
  var auxLbs = Math.round(aux * GAL_TO_LBS_AUX);
  var total  = fwdLbs + aftLbs + ctrLbs + auxLbs;

  document.getElementById('fuelFwdLbs').textContent = fwdLbs;
  document.getElementById('fuelAftLbs').textContent = aftLbs;
  document.getElementById('fuelCtrLbs').textContent = ctrLbs;
  document.getElementById('fuelAuxLbs').textContent = auxLbs;
  document.getElementById('fuelTotalLbs').textContent = total;
  syncFuelPctFromTanks();
  updateWeightsAndPerformance();
}

['fuelFwd','fuelAft','fuelCtr','fuelAux'].forEach(function(id) {
  document.getElementById(id).addEventListener('input', function() {
    sanitizeFuelInput(document.getElementById(id));
    calcFuel();
  });
});