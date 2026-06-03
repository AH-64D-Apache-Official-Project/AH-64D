// sfm_perf.js -- SFM performance table loading and atmosphere/perf computation

var GAL_TO_LBS_FWD = 1043 / 155;  // ~6.729
var GAL_TO_LBS_AFT = 1474 / 220;  // ~6.700
var GAL_TO_LBS_CTR = 663  / 100;  // ~6.630
var GAL_TO_LBS_AUX = 1541 / 230;  // ~6.700

var EST_ROCKET_ROUND_LBS = 11.9;
var EST_HELLFIRE_LBS = 108;
var EST_30MM_ROUND_LBS = 1.8;
var EST_M299_EMPTY_LBS = 130;
var EST_M261_EMPTY_LBS = 160;
var EST_AUX_TANK_EMPTY_LBS = 310;
var EST_FCR_LBS = 140;
var EST_IAFS_LBS = 120;
var EST_MAGAZINE_LBS = 220;
var LBS_PER_KG = 2.20462;

// Fallback values used when environment setting cannot be resolved.
var PERF_DEFAULT_PA_FT = 0;
var PERF_DEFAULT_FAT_C = 20;
var EMPTY_MASS_FCR_LBS = 6609 * 2.20462;
var EMPTY_MASS_NON_FCR_LBS = 6314 * 2.20462;
var ENV_PROFILE_PA_FAT = {
  0: { pa: 0, fat: 15 },
  1: { pa: 800, fat: 20 },
  2: { pa: 800, fat: 0 },
  3: { pa: 1800, fat: 30 },
  4: { pa: 5000, fat: 30 },
  5: { pa: 5000, fat: -5 },
  6: { pa: 3100, fat: 25 }
};
var SFMPLUS_CONFIG_PATH = '../../fza_ah64_controls/config/cfgVehicles/sfmplus.hpp';
var SFMPLUS_CONFIG_GAME_PATH = 'fza_ah64_controls\\config\\cfgVehicles\\sfmplus.hpp';

var sfmPerfDataReady = false;
var sfmPerfDataError = '';

var PERF_TABLES = [];
var HOVER_TABLES = [];
var CRUISE_TABLES = [];
var TAS_TABLES = [];
var ENG_FF_TABLE = [];

function readTextFile(path) {
  return new Promise(function(resolve, reject) {
    if (typeof A3API !== 'undefined' && A3API && typeof A3API.RequestFile === 'function') {
      A3API.RequestFile(SFMPLUS_CONFIG_GAME_PATH)
        .then(function(content) {
          resolve(String(content || ''));
        })
        .catch(function(err) {
          reject(err || new Error('A3API.RequestFile failed'));
        });
      return;
    }

    if (typeof fetch === 'function') {
      fetch(path)
        .then(function(resp) {
          if (!resp || !resp.ok) throw new Error('Fetch failed for ' + path);
          return resp.text();
        })
        .then(resolve)
        .catch(function() {
          var xhr = new XMLHttpRequest();
          xhr.open('GET', path, true);
          xhr.onreadystatechange = function() {
            if (xhr.readyState !== 4) return;
            if (xhr.status === 200 || xhr.status === 0) {
              resolve(xhr.responseText || '');
            } else {
              reject(new Error('XHR failed for ' + path));
            }
          };
          xhr.send();
        });
      return;
    }

    try {
      var xhrOnly = new XMLHttpRequest();
      xhrOnly.open('GET', path, true);
      xhrOnly.onreadystatechange = function() {
        if (xhrOnly.readyState !== 4) return;
        if (xhrOnly.status === 200 || xhrOnly.status === 0) {
          resolve(xhrOnly.responseText || '');
        } else {
          reject(new Error('XHR failed for ' + path));
        }
      };
      xhrOnly.send();
    } catch (err) {
      reject(err);
    }
  });
}


function stripHppComments(text) {
  return String(text || '')
    .replace(/\/\*[\s\S]*?\*\//g, '')
    .replace(/\/\/.*$/gm, '');
}

function parseHppTableRows(hppText, tableName) {
  var pattern = new RegExp(tableName + '\\s*\\[\\]\\s*=\\s*\\{([\\s\\S]*?)\\};');
  var match = hppText.match(pattern);
  if (!match || !match[1]) return null;

  var rows = [];
  var rowRegex = /\{([^{}]+)\}/g;
  var rowMatch;
  while ((rowMatch = rowRegex.exec(match[1])) !== null) {
    var row = rowMatch[1]
      .split(',')
      .map(function(token) { return parseFloat(String(token).trim()); })
      .filter(function(value) { return !isNaN(value); });
    if (row.length > 0) rows.push(row);
  }

  return rows.length > 0 ? rows : null;
}

function parseConfigEmptyMassLbs(hppText) {
  var cleaned = stripHppComments(hppText);
  var fcrMatch = cleaned.match(/emptyMassFCR\s*=\s*([0-9.]+)\s*;/);
  var nonFcrMatch = cleaned.match(/emptyMassNonFCR\s*=\s*([0-9.]+)\s*;/);

  if (fcrMatch && fcrMatch[1]) {
    EMPTY_MASS_FCR_LBS = parseFloat(fcrMatch[1]) * LBS_PER_KG;
  }
  if (nonFcrMatch && nonFcrMatch[1]) {
    EMPTY_MASS_NON_FCR_LBS = parseFloat(nonFcrMatch[1]) * LBS_PER_KG;
  }
}

function loadSfmPerfTablesFromConfig() {
  return readTextFile(SFMPLUS_CONFIG_PATH)
    .then(function(rawText) {
      var hpp = stripHppComments(rawText);
      parseConfigEmptyMassLbs(rawText);

      var parsedPerf = [];
      var parsedHover = [];
      var parsedTas = [];
      var parsedCruise = [];

      var i;
      for (i = 0; i <= 4; i++) {
        var perfRows = parseHppTableRows(hpp, 'perfTable' + i);
        var hoverRows = parseHppTableRows(hpp, 'hoverTable' + i);
        var tasRows = parseHppTableRows(hpp, 'TASTable' + i);
        if (!perfRows || !hoverRows || !tasRows) {
          throw new Error('Missing perf/hover/TAS table index ' + i);
        }
        parsedPerf.push(perfRows);
        parsedHover.push(hoverRows);
        parsedTas.push(tasRows);
      }

      for (i = 0; i <= 4; i++) {
        var cruiseForFat = [];
        var j;
        for (j = 0; j <= 3; j++) {
          var cruiseName = 'cruiseTable' + String(i) + String(j);
          var cruiseRows = parseHppTableRows(hpp, cruiseName);
          if (!cruiseRows) {
            throw new Error('Missing cruise table ' + cruiseName);
          }
          cruiseForFat.push(cruiseRows);
        }
        parsedCruise.push(cruiseForFat);
      }

      var parsedEngFf = parseHppTableRows(hpp, 'engFFTable');
      if (!parsedEngFf) {
        throw new Error('Missing engFFTable');
      }

      PERF_TABLES = parsedPerf;
      HOVER_TABLES = parsedHover;
      TAS_TABLES = parsedTas;
      CRUISE_TABLES = parsedCruise;
      ENG_FF_TABLE = parsedEngFf;
      sfmPerfDataReady = true;
      sfmPerfDataError = '';
      return true;
    })
    .catch(function(err) {
      sfmPerfDataReady = false;
      sfmPerfDataError = err && err.message ? err.message : String(err);
      if (typeof console !== 'undefined' && console.warn) {
        console.warn('Unable to load live SFM perf tables.', sfmPerfDataError);
      }
      return false;
    });
}

function linearInterpRows(rows, key, extrapolateOutOfRange) {
  var upperIndex = -1;
  for (var i = 0; i < rows.length; i++) {
    if (rows[i][0] > key) {
      upperIndex = i;
      break;
    }
  }

  var lower;
  var upper;

  if (upperIndex === 0) {
    if (!extrapolateOutOfRange || rows.length < 2) return rows[0].slice(0);
    lower = rows[0];
    upper = rows[1];
  } else if (upperIndex === -1) {
    if (!extrapolateOutOfRange || rows.length < 2) return rows[rows.length - 1].slice(0);
    lower = rows[rows.length - 2];
    upper = rows[rows.length - 1];
  } else {
    lower = rows[upperIndex - 1];
    upper = rows[upperIndex];
  }

  var lowKey = lower[0];
  var highKey = upper[0];
  var out = [key];

  for (var j = 1; j < lower.length; j++) {
    var lowVal = lower[j];
    var highVal = upper[j];
    var value = lowVal + ((highVal - lowVal) / (highKey - lowKey)) * (key - lowKey);
    out.push(value);
  }

  return out;
}

function setPerfValueClass(id, state) {
  var el = document.getElementById(id);
  if (!el) return;
  el.classList.remove('warn');
  el.classList.remove('caution');
  el.classList.remove('ok');
  if (state) el.classList.add(state);
}

function computeSfmPerformance(gwtLbs, paFt, fatC) {
  if (!sfmPerfDataReady) {
    throw new Error('SFM perf data not loaded');
  }

  var gwtKg = gwtLbs / LBS_PER_KG;
  var fatBins = [-40, -20, 0, 20, 40];
  var gwtBinsKg = [6804, 7711, 8618, 9525];

  var perfRows = [];
  var hoverRows = [];
  var cruiseRowsByFat = [];
  var tasRows = [];

  var i;
  for (i = 0; i < fatBins.length; i++) {
    var perfAtPa = linearInterpRows(PERF_TABLES[i], paFt);
    perfRows.push([fatBins[i], perfAtPa[1], perfAtPa[2], perfAtPa[3], perfAtPa[4], perfAtPa[5], perfAtPa[6], perfAtPa[7], perfAtPa[8], perfAtPa[9]]);

    var hoverAtPa = linearInterpRows(HOVER_TABLES[i], paFt);
    hoverRows.push([fatBins[i], hoverAtPa[1], hoverAtPa[2], hoverAtPa[3], hoverAtPa[4], hoverAtPa[5], hoverAtPa[6], hoverAtPa[7], hoverAtPa[8]]);

    var tasAtPa = linearInterpRows(TAS_TABLES[i], paFt);
    tasRows.push([fatBins[i], tasAtPa[1], tasAtPa[2], tasAtPa[3], tasAtPa[4], tasAtPa[5], tasAtPa[6]]);

    var cruiseAtWeightRows = [];
    var j;
    for (j = 0; j < gwtBinsKg.length; j++) {
      var cruiseAtPa = linearInterpRows(CRUISE_TABLES[i][j], paFt);
      cruiseAtWeightRows.push([gwtBinsKg[j], cruiseAtPa[1], cruiseAtPa[2], cruiseAtPa[3], cruiseAtPa[4], cruiseAtPa[5], cruiseAtPa[6]]);
    }
    var cruiseAtGwt = linearInterpRows(cruiseAtWeightRows, gwtKg, true);
    cruiseRowsByFat.push([fatBins[i], cruiseAtGwt[1], cruiseAtGwt[2], cruiseAtGwt[3], cruiseAtGwt[4], cruiseAtGwt[5], cruiseAtGwt[6]]);
  }

  var intPerf = linearInterpRows(perfRows, fatC);
  var intHover = linearInterpRows(hoverRows, fatC);
  var hoverByGwt = [
    [6804, intHover[1], intHover[2]],
    [7711, intHover[3], intHover[4]],
    [8618, intHover[5], intHover[6]],
    [9525, intHover[7], intHover[8]]
  ];
  var intHover2 = linearInterpRows(hoverByGwt, gwtKg, true);

  var tas = linearInterpRows(tasRows, fatC);
  var rngFf = linearInterpRows(ENG_FF_TABLE, tas[4])[1] * 2 * 7936.64;
  var endFf = linearInterpRows(ENG_FF_TABLE, tas[6])[1] * 2 * 7936.64;
  return {
    maxTQ_DE: intPerf[2],
    maxTQ_SE: intPerf[3],
    hvrTQ_IGE: intHover2[1],
    hvrTQ_OGE: intHover2[2],
    vsseTAS: tas[2],
    rngTAS: tas[3],
    rngTQ: tas[4],
    rngFF: rngFf,
    endTAS: tas[5],
    endTQ: tas[6],
    endFF: endFf
  };
}

function parseEnvironmentSettingValue(rawValue) {
  var parsed = parseInt(String(rawValue), 10);
  if (isNaN(parsed)) return null;
  if (!ENV_PROFILE_PA_FAT.hasOwnProperty(parsed)) return null;
  return parsed;
}

function resolveEnvironmentSettingValue() {
  var candidates = [];

  if (typeof window !== 'undefined') {
    candidates.push(window.fza_ah64_sfmplusEnvironment);
    candidates.push(window.fzaSfmplusEnvironment);
    candidates.push(window.fzaEnvironmentSetting);

    if (window.fzaMissionPlannerEnv && typeof window.fzaMissionPlannerEnv.environment !== 'undefined') {
      candidates.push(window.fzaMissionPlannerEnv.environment);
    }

  }

  var bodyEl = document.body;
  if (bodyEl && bodyEl.getAttribute) {
    candidates.push(bodyEl.getAttribute('data-fza-environment'));
    candidates.push(bodyEl.getAttribute('data-sfm-environment'));
  }

  for (var i = 0; i < candidates.length; i++) {
    var parsed = parseEnvironmentSettingValue(candidates[i]);
    if (parsed !== null) return parsed;
  }

  return null;
}

function computePerfAtmosphereFromEnvironment() {
  var envSetting = resolveEnvironmentSettingValue();
  if (envSetting === null) {
    return {
      pa: PERF_DEFAULT_PA_FT,
      fat: PERF_DEFAULT_FAT_C,
      envSetting: null,
      source: 'default'
    };
  }

  var profile = ENV_PROFILE_PA_FAT[envSetting];
  if (!profile) {
    return {
      pa: PERF_DEFAULT_PA_FT,
      fat: PERF_DEFAULT_FAT_C,
      envSetting: null,
      source: 'default'
    };
  }

  return {
    pa: profile.pa,
    fat: profile.fat,
    envSetting: envSetting,
    source: 'environment'
  };
}

function getPerfAtmosphere() {
  var atmosphere = computePerfAtmosphereFromEnvironment();
  var paEl = document.getElementById('perfPA');
  var fatEl = document.getElementById('perfFAT');
  if (paEl) paEl.textContent = formatWhole(atmosphere.pa);
  if (fatEl) fatEl.textContent = formatWhole(atmosphere.fat);
  return { pa: atmosphere.pa, fat: atmosphere.fat };
}