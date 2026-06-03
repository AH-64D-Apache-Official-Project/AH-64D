// weapons.js -- hellfire/rocket/pylon/silhouette management and cannon/robbie sync

var hellfireCodeMap = {
  '': 'None',
  'K': 'AGM-114K',
  'K2A': 'AGM-114K2A',
  'L': 'AGM-114L',
  'FA': 'AGM-114FA',
  'N': 'AGM-114N'
};
var hellfireCycleOrder = ['', 'K', 'L', 'K2A', 'FA', 'N'];


function normalizeHellfireCode(rawValue) {
  var value = String(rawValue || '').toUpperCase();
  if (value === '' || value === 'NONE') return '';
  if (value.indexOf('K2A') !== -1) return 'K2A';
  if (value.indexOf('FA') !== -1) return 'FA';
  if (value.indexOf('114N') !== -1 || value === 'N') return 'N';
  if (value.indexOf('114L') !== -1 || value === 'L') return 'L';
  if (value.indexOf('114K') !== -1 || value === 'K') return 'K';
  return '';
}

function initHellfireCyclers() {
  eachNode('.rail-ammo', function(selectEl) {
    var selectedCode = normalizeHellfireCode(selectEl.value);

    selectEl.innerHTML = '';
    hellfireCycleOrder.forEach(function(code) {
      var option = document.createElement('option');
      option.value = hellfireCodeMap[code];
      option.textContent = code === '' ? 'None' : code;
      selectEl.appendChild(option);
    });
    selectEl.value = hellfireCodeMap[selectedCode];

    var cycleBtn = document.createElement('button');
    cycleBtn.type = 'button';
    cycleBtn.className = 'rail-cycle';
    setData(cycleBtn, 'rail', selectEl.id);
    setData(cycleBtn, 'index', hellfireCycleOrder.indexOf(selectedCode));
    cycleBtn.textContent = selectedCode === '' ? '-' : selectedCode;

    cycleBtn.addEventListener('click', function() {
      var nextIndex = (parseInt(getData(cycleBtn, 'index') || '0', 10) + 1) % hellfireCycleOrder.length;
      var nextCode = hellfireCycleOrder[nextIndex];
      var pm = /^p([1-4])_/.exec(selectEl.id || '');
      if (pm) { g_pylonOrder['p' + pm[1]] = ++g_pylonChangeSeq; g_itemOrder[selectEl.id] = g_pylonChangeSeq; }
      setData(cycleBtn, 'index', nextIndex);
      cycleBtn.textContent = nextCode === '' ? '-' : nextCode;
      selectEl.value = hellfireCodeMap[nextCode];
      syncSilhouette();
      updateWeightsAndPerformance();
    });

    selectEl.classList.add('hidden');
    selectEl.parentNode.appendChild(cycleBtn);
  });
}

function getZoneIdsForPylon(pylonIndex) {
  if (pylonIndex === 1 || pylonIndex === 4) {
    return [['za', 'A'], ['zb', 'B'], ['ze', 'E']];
  }
  return [['zc', 'C'], ['zd', 'D'], ['ze', 'E']];
}

function getPylonSummary(pylonIndex, mode) {
  var summary = [];
  if (mode === 'hellfire') {
    var railIds = ['tr', 'tl', 'br', 'bl'];
    for (var i = 0; i < railIds.length; i++) {
      var railEl = document.getElementById('p' + pylonIndex + '_' + railIds[i]);
      var code = normalizeHellfireCode(railEl ? railEl.value : '');
      summary.push(code === '' ? '-' : code);
    }
    return summary.join(' ');
  }

  if (mode === 'rocket') {
    var zoneIds = getZoneIdsForPylon(pylonIndex);
    for (var j = 0; j < zoneIds.length; j++) {
      var zoneKey = zoneIds[j][0];
      var zoneLabel = zoneIds[j][1];
      var countEl = document.getElementById('p' + pylonIndex + '_' + zoneKey + '_count');
      var typeEl = document.getElementById('p' + pylonIndex + '_' + zoneKey + '_type');
      var count = countEl ? countEl.value : '0';
      var type = typeEl ? typeEl.value : '';
      summary.push(zoneLabel + ':' + count + 'x' + (type || 'None'));
    }
    return summary.join(' | ');
  }

  if (mode === 'aux') {
    return '230 GAL TANK';
  }

  return 'EMPTY';
}

function syncSilhouette() {
  var svg = document.getElementById('apache-svg');
  if (!svg) return;

  svg.setAttribute('data-fcr', document.getElementById('fcrBadge').classList.contains('active') ? 'on' : 'off');
  svg.setAttribute('data-gun', document.getElementById('robbieMode').value === 'iafs' ? 'on' : 'off');

  var loadoutParts = [];
  for (var i = 1; i <= 4; i++) {
    var modeSelect = document.getElementById('pylon' + i + 'Type');
    var mode = modeSelect ? modeSelect.value : 'none';
    svg.setAttribute('data-p' + i + '-mode', mode);

    var summaryEl = document.getElementById('sil-p' + i + '-label');
    if (summaryEl) {
      summaryEl.textContent = mode === 'hellfire' ? 'HF' : (mode === 'rocket' ? 'RKT' : (mode === 'aux' ? 'AUX' : 'EMPTY'));
    }
    loadoutParts.push('P' + i + ' ' + getPylonSummary(i, mode));
  }

  var loadoutEl = document.getElementById('sil-loadout');
  if (loadoutEl) {
    loadoutEl.textContent = loadoutParts.join('   ');
  }
}

function initRocketTypeOptions() {
  var rocketCodes = ['None', '6PD', '6FL', '6MP', '6IL', '6IR'];
  eachNode('.zone-type select', function(selectEl) {
    var current = selectEl.value;
    selectEl.innerHTML = '';
    rocketCodes.forEach(function(code) {
      var option = document.createElement('option');
      option.value = code === 'None' ? '' : code;
      option.textContent = code;
      selectEl.appendChild(option);
    });
    selectEl.value = rocketCodes.indexOf(current) !== -1 ? current : '';
  });
}

function syncMatchingRocketZoneTypes(changedSelect) {
  var changedId = changedSelect && changedSelect.id ? changedSelect.id : '';
  var changedMatch = /^p[1-4]_z([a-z])_type$/i.exec(changedId);
  if (!changedMatch) return;

  var zoneLetter = changedMatch[1].toLowerCase();
  var selectedType = changedSelect.value;

  // Do not propagate an empty/none selection â€” the user is clearing only this pylon's zone.
  if (!selectedType || String(selectedType).trim() === '') return;

  eachNode('.zone-type select', function(selectEl) {
    if (selectEl === changedSelect) return;

    var otherMatch = /^p[1-4]_z([a-z])_type$/i.exec(selectEl.id || '');
    if (!otherMatch) return;

    if (otherMatch[1].toLowerCase() === zoneLetter) {
      selectEl.value = selectedType;
    }
  });
}

function clearMatchingRocketZoneCounts(zoneLetter) {
  var letter = String(zoneLetter || '').toLowerCase();
  eachNode('[id$="_count"]', function(inputEl) {
    var match = /^p[1-4]_z([a-z])_count$/i.exec(inputEl.id || '');
    if (!match) return;
    if (match[1].toLowerCase() !== letter) return;
    inputEl.value = '0';
  });
}


function clearPylonAmmoOnTypeChange(pylonIndex, mode) {
  if (mode === 'hellfire') {
    ['tr', 'tl', 'br', 'bl'].forEach(function(railKey) {
      var railEl = document.getElementById('p' + pylonIndex + '_' + railKey);
      if (!railEl) return;
      railEl.value = hellfireCodeMap[''];  // 'None'
      var parent = railEl.parentNode;
      var parentSelects = parent.querySelectorAll('.rail-ammo');
      var parentCycleBtns = parent.querySelectorAll('button.rail-cycle');
      var selIdx = Array.prototype.indexOf.call(parentSelects, railEl);
      var cycleBtn = selIdx >= 0 ? parentCycleBtns[selIdx] : null;
      if (cycleBtn) {
        setData(cycleBtn, 'index', 0);
        cycleBtn.textContent = '-';
      }
    });
  }
  if (mode === 'rocket') {
    getZoneIdsForPylon(pylonIndex).forEach(function(zonePair) {
      var zoneKey = zonePair[0];
      var countEl = document.getElementById('p' + pylonIndex + '_' + zoneKey + '_count');
      var typeEl  = document.getElementById('p' + pylonIndex + '_' + zoneKey + '_type');
      if (countEl) countEl.value = '0';
      if (typeEl)  typeEl.value  = '';
    });
  }
}

function setPylonMode(pylonIndex, mode) {
  ['hellfire', 'rocket', 'aux', 'none'].forEach(function(name) {
    var panel = document.getElementById('p' + pylonIndex + '_' + name);
    if (panel) {
      if (name !== mode) {
        panel.classList.add('hidden');
      } else {
        panel.classList.remove('hidden');
      }
    }
  });
}

function countHellfiresOnPylon(pylonIndex) {
  var rails = ['tr', 'tl', 'br', 'bl'];
  var count = 0;
  for (var i = 0; i < rails.length; i++) {
    var railEl = document.getElementById('p' + pylonIndex + '_' + rails[i]);
    var code = normalizeHellfireCode(railEl ? railEl.value : '');
    if (code !== '') count += 1;
  }
  return count;
}

function countRocketsOnPylon(pylonIndex) {
  var zones = getZoneIdsForPylon(pylonIndex);
  var total = 0;
  for (var i = 0; i < zones.length; i++) {
    var zoneKey = zones[i][0];
    var countEl = document.getElementById('p' + pylonIndex + '_' + zoneKey + '_count');
    var typeEl = document.getElementById('p' + pylonIndex + '_' + zoneKey + '_type');
    var typeValue = typeEl ? String(typeEl.value || '').trim() : '';
    if (typeValue === '') continue;
    total += parseInt(countEl ? countEl.value : '0', 10) || 0;
  }
  return total;
}

function syncCannonDisplay() {
  var cannonInput = document.getElementById('cannonRds');
  var cleaned = (cannonInput.value || '').replace(/[^0-9]/g, '');
  var current = cleaned === '' ? 0 : parseInt(cleaned, 10);
  if (isNaN(current) || current < 0) current = 0;

  var max = parseInt(cannonInput.max || '1200', 10);
  if (current > max) current = max;
  cannonInput.value = String(current);
  updateWeightsAndPerformance();
}

function syncRobbieState() {
  var robbieMode = document.getElementById('robbieMode');
  var robbieInstalled = robbieMode && robbieMode.value === 'iafs';
  var cannonInput = document.getElementById('cannonRds');
  var centerFuelRow = document.getElementById('fuelCtrRow');
  var centerFuelInput = document.getElementById('fuelCtr');

  var maxRds = robbieInstalled ? 300 : 1200;
  cannonInput.max = String(maxRds);
  document.getElementById('cannonMaxRds').textContent = String(maxRds);

  if (robbieInstalled) {
    centerFuelRow.classList.remove('hidden');
    if (centerFuelInput.value === '0' && getData(centerFuelInput, 'prevValue')) {
      centerFuelInput.value = getData(centerFuelInput, 'prevValue');
    }
  } else {
    setData(centerFuelInput, 'prevValue', centerFuelInput.value);
    centerFuelInput.value = '0';
    centerFuelRow.classList.add('hidden');
  }

  syncCannonDisplay();
  calcFuel();
  syncSilhouette();
}

function getFuelMax(id) {
  var el = document.getElementById(id);
  return parseInt(getData(el, 'max') || el.max || '0', 10) || 0;
}

function getInternalFuelIds() {
  var ids = ['fuelFwd', 'fuelAft'];
  var centerFuelRow = document.getElementById('fuelCtrRow');
  if (centerFuelRow && !centerFuelRow.classList.contains('hidden')) {
    ids.push('fuelCtr');
  }
  return ids;
}

function getLoadedAuxTankCount() {
  var count = 0;
  for (var i = 1; i <= 4; i++) {
    var modeEl = document.getElementById('pylon' + i + 'Type');
    if (modeEl && modeEl.value === 'aux') count += 1;
  }
  return count;
}

function syncAuxFuelAvailability() {
  var auxRow = document.getElementById('fuelAuxRow');
  var auxInput = document.getElementById('fuelAux');
  var auxMaxLabel = document.getElementById('fuelAuxMax');
  if (!auxRow || !auxInput) return;

  var tankCount = getLoadedAuxTankCount();
  var auxMax = tankCount * 230;

  setData(auxInput, 'max', String(auxMax));
  auxInput.max = String(auxMax);
  if (auxMaxLabel) auxMaxLabel.textContent = String(auxMax);

  if (tankCount <= 0) {
    auxInput.value = '0';
    auxRow.classList.add('hidden');
  } else {
    auxRow.classList.remove('hidden');
    sanitizeFuelInput(auxInput);
  }
}