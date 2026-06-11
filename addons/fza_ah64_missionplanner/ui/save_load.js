// save_load.js -- save/load persistence, save-seed handling, and save/load dialog

var fzaMplanner_fuelRateLS = 1; // ACE ace_refuel_rate default; updated from SQF seed
var g_rearmData = null;
var g_rearmMode = 1;               // 0=Instant, 1=30 Seconds, 2=ACE Settings (CBA default=1)
var g_noAmmoSourceRequired = true; // updated from SQF seed; default true matches CBA default
var g_noFuelSourceRequired = true;
var g_farpFuelSources = [];        // [{name,liters},...] from SQF seed; liters=-1 means unlimited

var saveLoadState = {
  open: false,
  mode: 'save',
  scope: 'own',
  selectedName: '',
  currentPlayerUid: '',
  currentPlayerName: '',
  seedReceived: false
};

var SAVE_STORE_RAM = {
  own: [],
  mission: []
};

// Built-in preset loadouts â€” always present, cannot be deleted.
var BUILTIN_PRESETS = (function() {
  // Correct rocket zone counts from CfgMagazines ROCKET_MAGAZINE_CONFIG: zoneA=12, zoneB=4, zoneE=3
  var rktCmbtSprt = [
    {count:12, type:'6PD'},  // zoneA = M151
    {count:4,  type:'6MP'},  // zoneB = M261
    {count:3,  type:'6MP'}   // zoneE = M261
  ];
  var rktCOIN = [
    {count:12, type:'6PD'},  // zoneA = M151
    {count:4,  type:'6FL'},  // zoneB = M255A1
    {count:3,  type:'6IL'}   // zoneE = M257
  ];
  // HF rails format: [tr, tl, br, bl]
  var hfKKLL = ['K','K','L','L'];  // K top rails, L bottom rails (FCR loadout)
  var hfKKKK = ['K','K','K','K'];  // all K (standard loadout)
  var fullFuel = {fwd:155, aft:220, ctr:100, aux:0};

  function preset(name, state) {
    return {
      name: name,
      locked: true,
      ownerUid: '',
      ownerName: 'FZA Default',
      timestamp: 0,
      state: Object.assign({version:1, timestamp:0}, state)
    };
  }

  return [
    // Combat Support (FCR) â€” cmbt_sprt_fcr: rockets outer, K/L hellfires inner, FCR on
    preset('Combat Support (FCR)', {
      fcrActive: true, robbieMode: 'iafs', cannonRds: 1200, fuel: fullFuel,
      pylons: [
        {type:'rocket',   zones: rktCmbtSprt},
        {type:'hellfire', rails: hfKKLL},
        {type:'hellfire', rails: hfKKLL},
        {type:'rocket',   zones: rktCmbtSprt}
      ]
    }),
    // Combat Support â€” cmbt_sprt: rockets outer, all-K hellfires inner, FCR off
    preset('Combat Support', {
      fcrActive: false, robbieMode: 'iafs', cannonRds: 1200, fuel: fullFuel,
      pylons: [
        {type:'rocket',   zones: rktCmbtSprt},
        {type:'hellfire', rails: hfKKKK},
        {type:'hellfire', rails: hfKKKK},
        {type:'rocket',   zones: rktCmbtSprt}
      ]
    }),
    // Heavy Attack (FCR) â€” hvy_atk_fcr: all hellfires K/L, FCR on
    preset('Heavy Attack (FCR)', {
      fcrActive: true, robbieMode: 'iafs', cannonRds: 1200, fuel: fullFuel,
      pylons: [
        {type:'hellfire', rails: hfKKLL},
        {type:'hellfire', rails: hfKKLL},
        {type:'hellfire', rails: hfKKLL},
        {type:'hellfire', rails: hfKKLL}
      ]
    }),
    // Heavy Attack â€” hvy_atk: all hellfires all-K, FCR off
    preset('Heavy Attack', {
      fcrActive: false, robbieMode: 'iafs', cannonRds: 1200, fuel: fullFuel,
      pylons: [
        {type:'hellfire', rails: hfKKKK},
        {type:'hellfire', rails: hfKKKK},
        {type:'hellfire', rails: hfKKKK},
        {type:'hellfire', rails: hfKKKK}
      ]
    }),
    // COIN â€” coin: mixed rockets left outer, mixed hellfires right outer
    preset('COIN', {
      fcrActive: false, robbieMode: 'iafs', cannonRds: 300, fuel: fullFuel,
      pylons: [
        {type:'hellfire', rails: ['','K','N','']},  // UI P1: tl=K, br=N
        {type:'none'},
        {type:'none'},
        {type:'rocket',   zones: rktCOIN}           // UI P4: M151/M255A1/M257
      ]
    }),
    // Cold Aircraft â€” empty, no fuel
    preset('Cold Aircraft', {
      fcrActive: false, robbieMode: 'iafs', cannonRds: 0, fuel: {fwd:0,aft:0,ctr:0,aux:0},
      pylons: [{type:'none'},{type:'none'},{type:'none'},{type:'none'}]
    })
  ];
}());

var SAVE_STORAGE_KEYS = {
  own: 'fza_mplanner_saves_own',
  mission: 'fza_mplanner_saves_mission'
};

function getSaveKey(scope) {
  return SAVE_STORAGE_KEYS[scope] || SAVE_STORAGE_KEYS.own;
}

// Delete tombstones: track locally-deleted save names so that stale SQF seeds
// (which read profileNamespace before fn_deleteConfig ran) cannot re-add them.
// Persisted in localStorage so the filter survives a planner relaunch within
// the same ArmA 3 session.  Cleared once the seed confirms the name is gone.
function hydrateSavesFromSqfSeed() {
  var seed = readQueryParam('sqfseed');
  if (!seed) return;

  try {
    if (typeof atob !== 'function') return;
    var sqfArrayText = atob(seed);
    if (!sqfArrayText) return;

    // SQF str escapes embedded quotes as doubled quotes; convert to JSON-safe strings.
    var jsonLike = sqfArrayText.replace(/""/g, '\\"');
    var parsed = JSON.parse(jsonLike);
    if (!parsed || parsed.length < 2) return;

    function normalizeSqfEntries(rawEntries) {
      if (!rawEntries || !rawEntries.length) return [];
      var out = [];
      for (var i = 0; i < rawEntries.length; i++) {
        var entry = rawEntries[i];
        if (!entry || entry.length < 2) continue;
        var name = String(entry[0] || '').trim();
        if (!name) continue;
        var stateRaw = String(entry[1] || '');
        if (!stateRaw) continue;

        var stateObj = null;
        try {
          stateObj = JSON.parse(stateRaw);
        } catch (e) {
          continue;
        }

        if (entry.length > 2 && (stateObj.timestamp === undefined || stateObj.timestamp === null)) {
          stateObj.timestamp = Number(entry[2]) || Date.now();
        }

        out.push({
          name: name,
          state: stateObj,
          timestamp: entry.length > 2 ? Number(entry[2]) || Date.now() : Date.now(),
          ownerUid: entry.length > 3 ? String(entry[3] || '') : '',
          ownerName: entry.length > 4 ? String(entry[4] || '') : ''
        });
      }
      return out;
    }

    var ownEntries = normalizeSqfEntries(parsed[0]);
    var msnEntries = normalizeSqfEntries(parsed[1]);

    writeSaveStore('own',     mergeSaveEntries(readSaveStoreRaw('own'),     ownEntries));
    writeSaveStore('mission', mergeSaveEntries(readSaveStoreRaw('mission'), msnEntries));
  } catch (err) {
    if (typeof console !== 'undefined' && console.warn) {
      console.warn('Mission Planner SQF save seed import failed.', err);
    }
  }
}

function readSaveStore(scope) {
  var scopeKey = scope === 'mission' ? 'mission' : 'own';
  var presets = (scope === 'own') ? BUILTIN_PRESETS : [];

  if (saveLoadState.seedReceived) {
    var seeded = SAVE_STORE_RAM[scopeKey] || [];
    return presets.concat(seeded.slice());
  }

  var key = getSaveKey(scope);
  var raw = '';
  try {
    raw = window.localStorage ? (window.localStorage.getItem(key) || '') : '';
  } catch (e) {
    raw = '';
  }
  if (!raw) {
    var mem = SAVE_STORE_RAM[scopeKey] || [];
    return presets.concat(mem.slice());
  }

  try {
    var parsed = JSON.parse(raw);
    if (!parsed || !parsed.length) {
      var memFallback = SAVE_STORE_RAM[scopeKey] || [];
      return presets.concat(memFallback.slice());
    }
    SAVE_STORE_RAM[scopeKey] = parsed.slice();
    return presets.concat(parsed);
  } catch (err) {
    var memRecover = SAVE_STORE_RAM[scopeKey] || [];
    return presets.concat(memRecover.slice());
  }
}

function readSaveStoreRaw(scope) {
  var scopeKey = scope === 'mission' ? 'mission' : 'own';
  var key = getSaveKey(scope);
  var raw = '';

  try {
    raw = window.localStorage ? (window.localStorage.getItem(key) || '') : '';
  } catch (e) {
    raw = '';
  }

  if (raw) {
    try {
      var parsed = JSON.parse(raw);
      if (parsed && parsed.length) {
        return parsed.slice();
      }
    } catch (err) {}
  }

  return (SAVE_STORE_RAM[scopeKey] || []).slice();
}

function mergeSaveEntries(existingEntries, incomingEntries) {
  var merged = [];
  var indexByName = {};

  function upsert(entry) {
    var normalized = normalizeSaveEntry(entry, entry ? entry.timestamp : undefined);
    if (!normalized) return;

    var key = String(normalized.name || '').toLowerCase();
    if (Object.prototype.hasOwnProperty.call(indexByName, key)) {
      merged[indexByName[key]] = normalized;
    } else {
      indexByName[key] = merged.length;
      merged.push(normalized);
    }
  }

  (existingEntries || []).forEach(upsert);
  (incomingEntries || []).forEach(upsert);

  return merged;
}

function writeSaveStore(scope, entries) {
  var scopeKey = scope === 'mission' ? 'mission' : 'own';
  var key = getSaveKey(scope);
  var cleanEntries = (entries || []).slice();
  SAVE_STORE_RAM[scopeKey] = cleanEntries;
  try {
    if (window.localStorage) {
      window.localStorage.setItem(key, JSON.stringify(cleanEntries));
    }
  } catch (e) {}
}

function normalizeSaveEntry(entry, fallbackTimestamp) {
  if (!entry || typeof entry !== 'object') return null;

  var name = trimSaveName(entry.name);
  if (!name) return null;

  var state = entry.state && typeof entry.state === 'object' ? entry.state : {};
  if (state.timestamp === undefined && fallbackTimestamp !== undefined) {
    state.timestamp = fallbackTimestamp;
  }

  return {
    name: name,
    state: state,
    timestamp: entry.timestamp !== undefined ? entry.timestamp : fallbackTimestamp,
    ownerUid: String(entry.ownerUid || ''),
    ownerName: String(entry.ownerName || '')
  };
}

function syncSaveToSqf(scope, name, stateObj) {
  var payload = JSON.stringify(stateObj || {});
  var code = '[' + sqfQuotedString(scope) + ',' + sqfQuotedString(name) + ',' + sqfQuotedString(payload) + '] call fza_mplanner_fnc_saveConfig';
  callSQF(code);
}

function syncDeleteToSqf(scope, name) {
  var code = '[' + sqfQuotedString(scope) + ',' + sqfQuotedString(name) + '] call fza_mplanner_fnc_deleteConfig';
  callSQF(code);
}

function syncSetLastLoadedConfig(name) {
  var code = 'missionNamespace setVariable ["fza_mplanner_last_loaded_config",' + sqfQuotedString(name) + '];';
  callSQF(code);
}

function syncPushMissionToSqf(name, stateObj) {
  var payload = JSON.stringify(stateObj || {});
  var code = '[' + sqfQuotedString(name) + ',' + sqfQuotedString(payload) + '] call fza_mplanner_fnc_pushMissionConfig';
  callSQF(code);
}

function requestSaveSeed() {
  // Wrap in spawn so fn_seedSaves runs in scheduled context where ExecJS works.
  return callSQF('[] spawn { disableSerialization; [] call fza_mplanner_fnc_seedSaves; }');
}


var saveSeedRetryHandle = 0;

function scheduleSaveSeedRefresh() {
  if (saveSeedRetryHandle) {
    clearTimeout(saveSeedRetryHandle);
    saveSeedRetryHandle = 0;
  }

  var attempts = 0;
  function tick() {
    attempts += 1;
    requestSaveSeed();

    if ((saveLoadState.currentPlayerUid && saveLoadState.currentPlayerName) || attempts >= 10) {
      saveSeedRetryHandle = 0;
      return;
    }

    saveSeedRetryHandle = setTimeout(tick, 250);
  }

  tick();
}

function receiveSqfSaveSeed(payloadText) {
  if (!payloadText) return;

  try {
    var parsed = JSON.parse(String(payloadText));
    if (!parsed || typeof parsed !== 'object') return;

    saveLoadState.currentPlayerUid = parsed.player && parsed.player.uid ? String(parsed.player.uid) : '';
    saveLoadState.currentPlayerName = parsed.player && parsed.player.name ? String(parsed.player.name) : '';

    if (parsed.environment !== undefined && parsed.environment !== null) {
      window.fza_ah64_sfmplusEnvironment = parsed.environment;
    }

    if (typeof parsed.fuelRateLS === 'number' && parsed.fuelRateLS > 0) {
      fzaMplanner_fuelRateLS = parsed.fuelRateLS;
    }

    if (typeof parsed.rearmMode === 'number') {
      g_rearmMode = Math.max(0, Math.min(2, parsed.rearmMode));
    }
    if (typeof parsed.noAmmoSourceRequired === 'boolean') {
      g_noAmmoSourceRequired = parsed.noAmmoSourceRequired;
    }
    if (typeof parsed.noFuelSourceRequired === 'boolean') {
      g_noFuelSourceRequired = parsed.noFuelSourceRequired;
    }
    if (Array.isArray(parsed.farpFuel)) {
      g_farpFuelSources = parsed.farpFuel;
    }

    if (parsed.currentConfig !== undefined) {
      var cfgName = trimSaveName(parsed.currentConfig);
      document.getElementById('currentConfigName').value = cfgName;
    }

    function normalizeSeedList(rawEntries) {
      var out = [];
      if (!rawEntries || !rawEntries.length) return out;
      for (var i = 0; i < rawEntries.length; i++) {
        var normalized = normalizeSaveEntry(rawEntries[i], rawEntries[i] ? rawEntries[i].timestamp : undefined);
        if (normalized) out.push(normalized);
      }
      return out;
    }

    var _ownCount = parsed.own ? parsed.own.length : 0;
    var _missionCount = parsed.mission ? parsed.mission.length : 0;
    var _ownSeed = normalizeSeedList(parsed.own);
    var _msnSeed = normalizeSeedList(parsed.mission);
    writeSaveStore('own',     mergeSaveEntries(readSaveStoreRaw('own'), _ownSeed));
    writeSaveStore('mission', mergeSaveEntries(readSaveStoreRaw('mission'), _msnSeed));
    saveLoadState.seedReceived = true;

    // Update FARP list
    var farpEl = document.getElementById('farpList');
    if (farpEl) {
      var farpHtml = '';

      // â”€â”€ FUEL section â”€â”€
      farpHtml += '<div class="farp-section">';
      if (parsed.farpFuel && parsed.farpFuel.length) {
        var totalLiters = 0;
        var hasInfFuel = false;
        for (var fi = 0; fi < parsed.farpFuel.length; fi++) {
          if (parsed.farpFuel[fi].liters < 0) hasInfFuel = true;
          else totalLiters += Number(parsed.farpFuel[fi].liters);
        }
        var fuelTotalStr = hasInfFuel ? 'Unlimited' : '~' + Math.round(totalLiters * 0.264172) + ' gal';
        farpHtml += '<div class="farp-sec-hdr">FUEL <span class="farp-sec-total">' + fuelTotalStr + '</span></div>';
        for (var fi2 = 0; fi2 < parsed.farpFuel.length; fi2++) {
          var fs = parsed.farpFuel[fi2];
          var fsVal = fs.liters < 0 ? 'Unlimited' : '~' + Math.round(fs.liters * 0.264172) + ' gal';
          farpHtml += '<div class="farp-src-row"><span class="farp-src-name">' + String(fs.name || 'Fuel Source') + '</span><span class="farp-src-val">' + fsVal + '</span></div>';
        }
      } else if (g_noFuelSourceRequired) {
        farpHtml += '<div class="farp-sec-hdr">FUEL</div>';
        farpHtml += '<div class="farp-none farp-not-req">Not Required</div>';
      } else {
        farpHtml += '<div class="farp-sec-hdr">FUEL</div>';
        farpHtml += '<div class="farp-none">No sources nearby</div>';
      }
      farpHtml += '</div>';

      // â”€â”€ AMMO section â”€â”€
      var _rearm = parsed.farpRearm;
      g_rearmData = (_rearm && typeof _rearm === 'object' && !Array.isArray(_rearm)) ? _rearm : null;
      farpHtml += '<div class="farp-section">';
      if (g_rearmData && g_rearmData.trucks && g_rearmData.trucks.length) {
        var modeLabels = {0: 'Unlimited', 1: 'Caliber Pool', 2: 'Magazine'};
        var modeLabel = modeLabels[g_rearmData.mode] || 'Unknown';
        var ammoTotalStr = g_rearmData.unlimited ? 'Unlimited' : (g_rearmData.totalSupply + ' pts');
        farpHtml += '<div class="farp-sec-hdr">AMMO <span class="farp-sec-total">' + ammoTotalStr + ' \xB7 ' + modeLabel + '</span></div>';
        for (var ri = 0; ri < g_rearmData.trucks.length; ri++) {
          var rs = g_rearmData.trucks[ri];
          var rsVal = rs.unlimited ? 'Unlimited' : (rs.supply + ' pts');
          farpHtml += '<div class="farp-src-row"><span class="farp-src-name">' + String(rs.name || 'Rearm Source') + '</span><span class="farp-src-val">' + rsVal + '</span></div>';
        }
      } else if (g_noAmmoSourceRequired) {
        farpHtml += '<div class="farp-sec-hdr">AMMO</div>';
        farpHtml += '<div class="farp-none farp-not-req">Not Required</div>';
      } else {
        farpHtml += '<div class="farp-sec-hdr">AMMO</div>';
        farpHtml += '<div class="farp-none">No sources nearby</div>';
      }
      farpHtml += '</div>';

      // â”€â”€ AMMO TYPES â€” placeholder div updated live by updateAmmoTypes() â”€â”€
      farpHtml += '<div id="ammoTypesSection"></div>';

      farpEl.innerHTML = farpHtml;
      updateAmmoTypes(null); // initial render with full pool (no newCost yet)
    }

    updateWeightsAndPerformance();
    updateAmmoWarnings();
    renderSaveLoadList();
  } catch (err) {
    if (typeof console !== 'undefined' && console.warn) {
      console.warn('Mission Planner live save seed failed.', err);
    }
  }
}


window.fza_mplanner_receiveSeed = receiveSqfSaveSeed;

function getSelectedSaveEntry(scope, nameOverride) {
  var actualScope = scope === 'mission' ? 'mission' : 'own';
  var name = trimSaveName(nameOverride || document.getElementById('saveLoadName').value || saveLoadState.selectedName);
  if (!name) return null;

  var entries = readSaveStore(actualScope);
  var idx = findSaveIndex(entries, name);
  if (idx === -1) return null;
  return entries[idx];
}

function canDeleteEntry(scope, entry) {
  if (!entry) return false;
  if (entry.locked) return false;
  if (scope !== 'mission') return true;
  if (!entry.ownerUid) return true;
  return entry.ownerUid === saveLoadState.currentPlayerUid;
}

function updateSaveLoadControls() {
  var scope = saveLoadState.scope === 'mission' ? 'mission' : 'own';
  var entry = getSelectedSaveEntry(scope);
  var deleteButton = document.getElementById('btnModalDelete');
  var pushButton = document.getElementById('btnModalPushMission');
  var hintEl = document.getElementById('saveLoadHint');

  if (deleteButton) {
    var canDel = entry && canDeleteEntry(scope, entry);
    deleteButton.style.display = canDel ? '' : 'none';
  }
  if (pushButton) {
    var isPreset = !!(entry && entry.locked);
    pushButton.style.display = (scope !== 'own' || isPreset) ? 'none' : '';
    pushButton.disabled = scope !== 'own' || !entry || isPreset;
  }

  if (!hintEl) return;
  if (scope === 'mission' && entry && !canDeleteEntry(scope, entry)) {
    hintEl.textContent = 'Mission saves display their owner. Only the owner can delete a mission save.';
  } else if (scope === 'own') {
    hintEl.textContent = 'Select an OWN save to load it, overwrite it, or push it into missionNamespace for the current mission.';
  } else {
    hintEl.textContent = 'Select a save to load it into the planner, or type a name to create/overwrite a save in the active scope.';
  }
}

function findSaveIndex(entries, name) {
  var target = normalizeSaveName(name);
  for (var i = 0; i < entries.length; i++) {
    if (normalizeSaveName(entries[i].name) === target) return i;
  }
  return -1;
}

function renderSaveLoadList() {
  var scope = saveLoadState.scope;
  var entries = readSaveStore(scope);
  var listEl = document.getElementById(scope === 'mission' ? 'saveListMission' : 'saveListOwn');
  if (!listEl) return;
  listEl.innerHTML = '';

  if (entries.length === 0) {
    var emptyEl = document.createElement('div');
    emptyEl.className = 'modal-hint';
    emptyEl.textContent = 'No saves yet in this scope.';
    listEl.appendChild(emptyEl);
    updateSaveLoadControls();
    return;
  }

  for (var i = 0; i < entries.length; i++) {
    (function(entry) {
      var row = document.createElement('div');
      row.className = 'save-entry' + (normalizeSaveName(entry.name) === normalizeSaveName(saveLoadState.selectedName) ? ' selected' : '') + (entry.locked ? ' preset-entry' : '');

      var nameEl = document.createElement('div');
      nameEl.className = 'name';
      nameEl.textContent = entry.name;

      var scopeEl = document.createElement('div');
      scopeEl.className = 'scope-badge';
      scopeEl.textContent = entry.locked ? 'PRESET' : scope.toUpperCase();

      var metaEl = document.createElement('div');
      metaEl.className = 'meta';
      var stamp = entry.state && entry.state.timestamp ? entry.state.timestamp : entry.timestamp;
      var metaParts = [];
      if (stamp && !entry.locked) metaParts.push(new Date(stamp).toLocaleString());
      if (entry.locked) {
        metaParts.push('Built-in preset');
      } else if (scope === 'mission') {
        metaParts.push('Owner: ' + (entry.ownerName || saveLoadState.currentPlayerName || 'Unknown'));
        if (!canDeleteEntry(scope, entry)) metaEl.classList.add('owner-lock');
      }
      metaEl.textContent = metaParts.join(' â€¢ ');

      row.appendChild(nameEl);
      row.appendChild(scopeEl);
      row.appendChild(metaEl);

      row.addEventListener('click', function() {
        saveLoadState.selectedName = entry.name;
        document.getElementById('saveLoadName').value = entry.name;
        renderSaveLoadList();
      });

      listEl.appendChild(row);
    })(entries[i]);
  }

  updateSaveLoadControls();
}

function setSaveLoadMode(mode) {
  saveLoadState.mode = mode === 'load' ? 'load' : 'save';
  document.getElementById('saveLoadTitle').textContent = saveLoadState.mode === 'save' ? 'Save Loadout' : 'Load Loadout';
  document.getElementById('btnModalSave').textContent = saveLoadState.mode === 'save' ? 'Save' : 'Save As';
  document.getElementById('btnModalLoad').style.display = saveLoadState.mode === 'load' ? '' : 'none';
  updateSaveLoadControls();
}

function setSaveLoadScope(scope) {
  saveLoadState.scope = scope === 'mission' ? 'mission' : 'own';
  var tabs = document.querySelectorAll('.scope-tab');
  for (var i = 0; i < tabs.length; i++) {
    tabs[i].classList.remove('active');
    if (getData(tabs[i], 'scope') === saveLoadState.scope) tabs[i].classList.add('active');
  }

  var panels = document.querySelectorAll('.modal-panel');
  for (var j = 0; j < panels.length; j++) {
    panels[j].classList.remove('active');
    if (String(panels[j].getAttribute('data-scope-panel') || '') === saveLoadState.scope) panels[j].classList.add('active');
  }

  renderSaveLoadList();
}

function openSaveLoadDialog(mode) {
  setSaveLoadMode(mode);
  saveLoadState.open = true;
  saveLoadState.selectedName = '';
  document.getElementById('saveLoadName').value = '';
  document.getElementById('saveLoadModal').classList.add('visible');
  document.getElementById('saveLoadModal').setAttribute('aria-hidden', 'false');
  setSaveLoadScope(saveLoadState.scope);
  scheduleSaveSeedRefresh();
}

function closeSaveLoadDialog() {
  saveLoadState.open = false;
  document.getElementById('saveLoadModal').classList.remove('visible');
  document.getElementById('saveLoadModal').setAttribute('aria-hidden', 'true');
}

function saveCurrentPlannerState() {
  var name = trimSaveName(document.getElementById('saveLoadName').value);
  if (!name) {
    showAlert('Enter a save name first.');
    return;
  }

  var scope = saveLoadState.scope;
  var entries = readSaveStore(scope);
  var idx = findSaveIndex(entries, name);
  if (idx !== -1 && entries[idx].locked) {
    showAlert('Cannot overwrite a built-in preset. Choose a different name.');
    return;
  }
  if (idx !== -1 && !showConfirm('Overwrite existing save "' + entries[idx].name + '"?')) {
    return;
  }

  var state = getPlannerState();
  var entry = normalizeSaveEntry({
    name: name,
    state: state,
    timestamp: state.timestamp,
    ownerUid: saveLoadState.currentPlayerUid,
    ownerName: saveLoadState.currentPlayerName
  }, state.timestamp);
  // Strip locked presets before writing â€” they are always prepended from BUILTIN_PRESETS
  var userEntries = entries.filter(function(e) { return !e.locked; });
  var userIdx = findSaveIndex(userEntries, name);
  if (userIdx === -1) userEntries.push(entry);
  else userEntries[userIdx] = entry;
  writeSaveStore(scope, userEntries);
  syncSaveToSqf(scope, name, state);
  saveLoadState.selectedName = name;
  renderSaveLoadList();
}

function loadSelectedPlannerState() {
  var name = trimSaveName(document.getElementById('saveLoadName').value || saveLoadState.selectedName);
  if (!name) {
    showAlert('Select a save to load.');
    return;
  }

  var entries = readSaveStore(saveLoadState.scope);
  var idx = findSaveIndex(entries, name);
  if (idx === -1) {
    showAlert('That save no longer exists. Refreshing the list.');
    renderSaveLoadList();
    return;
  }

  applyPlannerState(entries[idx].state);
  markConfigClean();
  saveLoadState.selectedName = entries[idx].name;
  document.getElementById('currentConfigName').value = entries[idx].name;
  syncSetLastLoadedConfig(entries[idx].name);
  closeSaveLoadDialog();
}

var deleteConfirmState = {
  onConfirm: null
};

function closeDeleteConfirmDialog() {
  deleteConfirmState.onConfirm = null;
  document.getElementById('deleteConfirmModal').classList.remove('visible');
  document.getElementById('deleteConfirmModal').setAttribute('aria-hidden', 'true');
}

function showDeleteConfirm(message, onConfirm) {
  deleteConfirmState.onConfirm = typeof onConfirm === 'function' ? onConfirm : null;
  document.getElementById('deleteConfirmMessage').textContent = String(message || 'Are you sure?');
  document.getElementById('deleteConfirmModal').classList.add('visible');
  document.getElementById('deleteConfirmModal').setAttribute('aria-hidden', 'false');
}

function performDeleteSelectedPlannerState(name) {
  var targetName = trimSaveName(name || document.getElementById('saveLoadName').value || saveLoadState.selectedName);
  if (!targetName) return;

  var entries = readSaveStore(saveLoadState.scope);
  var idx = findSaveIndex(entries, targetName);
  if (idx === -1) {
    showAlert('That save no longer exists. Refreshing the list.');
    renderSaveLoadList();
    return;
  }

  if (!canDeleteEntry(saveLoadState.scope, entries[idx])) {
    showAlert('Only the owner can delete that mission save.');
    updateSaveLoadControls();
    return;
  }

  entries.splice(idx, 1);
  // Strip locked presets before writing back
  writeSaveStore(saveLoadState.scope, entries.filter(function(e) { return !e.locked; }));
  syncDeleteToSqf(saveLoadState.scope, targetName);
  saveLoadState.selectedName = '';
  document.getElementById('saveLoadName').value = '';
  renderSaveLoadList();
}

function deleteSelectedPlannerState() {
  var name = trimSaveName(document.getElementById('saveLoadName').value || saveLoadState.selectedName);
  if (!name) {
    showAlert('Select a save to delete.');
    return;
  }

  var entries = readSaveStore(saveLoadState.scope);
  var idx = findSaveIndex(entries, name);
  if (idx === -1) {
    showAlert('That save no longer exists. Refreshing the list.');
    renderSaveLoadList();
    return;
  }

  if (!canDeleteEntry(saveLoadState.scope, entries[idx])) {
    showAlert('Only the owner can delete that mission save.');
    updateSaveLoadControls();
    return;
  }

  showDeleteConfirm('Delete save "' + entries[idx].name + '"?\nThis cannot be undone.', function() {
    performDeleteSelectedPlannerState(entries[idx].name);
  });
}

function pushSelectedPlannerStateToMission() {
  if (saveLoadState.scope !== 'own') {
    showAlert('Push to Mission works from the OWN save list.');
    return;
  }

  var entry = getSelectedSaveEntry('own');
  if (!entry) {
    showAlert('Select an OWN save to push into missionNamespace.');
    return;
  }

  var missionEntries = readSaveStore('mission');
  var idx = findSaveIndex(missionEntries, entry.name);
  if (idx !== -1 && !showConfirm('Overwrite mission save "' + missionEntries[idx].name + '"?')) {
    return;
  }

  var pushedEntry = normalizeSaveEntry({
    name: entry.name,
    state: entry.state,
    timestamp: entry.state && entry.state.timestamp ? entry.state.timestamp : Date.now(),
    ownerUid: saveLoadState.currentPlayerUid,
    ownerName: saveLoadState.currentPlayerName
  }, entry.state && entry.state.timestamp ? entry.state.timestamp : Date.now());

  if (idx === -1) missionEntries.push(pushedEntry);
  else missionEntries[idx] = pushedEntry;

  writeSaveStore('mission', missionEntries.filter(function(e) { return !e.locked; }));
  syncPushMissionToSqf(pushedEntry.name, pushedEntry.state);
  showAlert('Mission save pushed. Owner: ' + (pushedEntry.ownerName || saveLoadState.currentPlayerName || 'Unknown'));
  setSaveLoadScope('mission');
  saveLoadState.selectedName = pushedEntry.name;
  document.getElementById('saveLoadName').value = pushedEntry.name;
  renderSaveLoadList();
}