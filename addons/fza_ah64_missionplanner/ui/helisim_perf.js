// helisim_perf.js -- HeliSim performance/mass data and atmosphere/perf computation

var LBS_PER_KG = 2.20462;

var FUEL_GAL_FWD = 155;
var FUEL_GAL_AFT = 220;
var FUEL_GAL_CTR = 100;
var FUEL_GAL_AUX = 230;

// Fallback values, replaced by the aircraft's HeliSim config when SQF seeds it.
var GAL_TO_LBS_FWD = 1043 / FUEL_GAL_FWD;  // ~6.729
var GAL_TO_LBS_AFT = 1474 / FUEL_GAL_AFT;  // ~6.700
var GAL_TO_LBS_CTR = 663  / FUEL_GAL_CTR;  // ~6.630
var GAL_TO_LBS_AUX = 1541 / FUEL_GAL_AUX;  // ~6.700

var EST_ROCKET_ROUND_LBS = 22.9;
var EST_HELLFIRE_LBS = 103;
var EST_30MM_ROUND_LBS = 0.77;
var EST_M299_EMPTY_LBS = 143;
var EST_M261_EMPTY_LBS = 87;
var EST_AUX_TANK_EMPTY_LBS = 140;
var EST_CREW_LBS = 441;
var EMPTY_MASS_FCR_LBS = 6609 * LBS_PER_KG;
var EMPTY_MASS_NON_FCR_LBS = 6314 * LBS_PER_KG;

// Fallback values used when environment setting cannot be resolved.
var PERF_DEFAULT_PA_FT = 0;
var PERF_DEFAULT_FAT_C = 20;
var ENV_PROFILE_PA_FAT = {
  0: { pa: 0, fat: 15 },
  1: { pa: 800, fat: 20 },
  2: { pa: 800, fat: 0 },
  3: { pa: 1800, fat: 30 },
  4: { pa: 5000, fat: 30 },
  5: { pa: 5000, fat: -5 },
  6: { pa: 3100, fat: 25 }
};

var PERF_FAT_BINS = [-40, -20, 0, 20, 40];

var perfDataReady = false;

var PERF_TABLES = [];
var HOVER_TABLES = [];
var TAS_TABLES = [];
var ENG_FF_TABLE = [];

function isPerfTableSet(tables) {
  if (!tables || tables.length !== PERF_FAT_BINS.length) return false;
  for (var i = 0; i < tables.length; i++) {
    if (!tables[i] || !tables[i].length) return false;
  }
  return true;
}

function applyHelisimMassData(mass, fuel) {
  function lbs(kg, fallbackLbs) {
    return (typeof kg === 'number' && kg > 0) ? kg * LBS_PER_KG : fallbackLbs;
  }

  EMPTY_MASS_NON_FCR_LBS = lbs(mass.empty, EMPTY_MASS_NON_FCR_LBS);
  EMPTY_MASS_FCR_LBS     = lbs(mass.emptyFcr, EMPTY_MASS_FCR_LBS);
  EST_CREW_LBS           = lbs(mass.crew, EST_CREW_LBS);
  EST_M299_EMPTY_LBS     = lbs(mass.m299, EST_M299_EMPTY_LBS);
  EST_HELLFIRE_LBS       = lbs(mass.hellfire, EST_HELLFIRE_LBS);
  EST_M261_EMPTY_LBS     = lbs(mass.m261, EST_M261_EMPTY_LBS);
  EST_ROCKET_ROUND_LBS   = lbs(mass.rocket, EST_ROCKET_ROUND_LBS);
  EST_AUX_TANK_EMPTY_LBS = lbs(mass.auxTank, EST_AUX_TANK_EMPTY_LBS);
  EST_30MM_ROUND_LBS     = lbs(mass.cannonRd, EST_30MM_ROUND_LBS);

  GAL_TO_LBS_FWD = lbs(fuel.fwd, GAL_TO_LBS_FWD * FUEL_GAL_FWD) / FUEL_GAL_FWD;
  GAL_TO_LBS_AFT = lbs(fuel.aft, GAL_TO_LBS_AFT * FUEL_GAL_AFT) / FUEL_GAL_AFT;
  GAL_TO_LBS_CTR = lbs(fuel.ctr, GAL_TO_LBS_CTR * FUEL_GAL_CTR) / FUEL_GAL_CTR;
  GAL_TO_LBS_AUX = lbs(fuel.aux, GAL_TO_LBS_AUX * FUEL_GAL_AUX) / FUEL_GAL_AUX;
}

window.fza_mplanner_receiveHelisimData = function(payloadText) {
  try {
    var data = JSON.parse(String(payloadText || '{}'));
    if (!data || typeof data !== 'object') return;

    applyHelisimMassData(data.mass || {}, data.fuel || {});

    perfDataReady = isPerfTableSet(data.perf) && isPerfTableSet(data.hover) && isPerfTableSet(data.tas) && !!(data.engFF && data.engFF.length);
    if (perfDataReady) {
      PERF_TABLES = data.perf;
      HOVER_TABLES = data.hover;
      TAS_TABLES = data.tas;
      ENG_FF_TABLE = data.engFF;
    } else if (typeof console !== 'undefined' && console.warn) {
      console.warn('Mission Planner HeliSim perf tables missing or incomplete.');
    }

    weightModelBaseline = null;
    calcFuel();
  } catch (err) {
    if (typeof console !== 'undefined' && console.warn) {
      console.warn('Mission Planner receiveHelisimData failed.', err);
    }
  }
};

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

function computePerformance(gwtLbs, paFt, fatC) {
  if (!perfDataReady) {
    throw new Error('HeliSim perf data not loaded');
  }

  var gwtKg = gwtLbs / LBS_PER_KG;

  var perfRows = [];
  var hoverRows = [];
  var tasRows = [];

  for (var i = 0; i < PERF_FAT_BINS.length; i++) {
    var perfAtPa = linearInterpRows(PERF_TABLES[i], paFt);
    perfRows.push([PERF_FAT_BINS[i], perfAtPa[1], perfAtPa[2], perfAtPa[3], perfAtPa[4], perfAtPa[5], perfAtPa[6], perfAtPa[7], perfAtPa[8], perfAtPa[9]]);

    var hoverAtPa = linearInterpRows(HOVER_TABLES[i], paFt);
    hoverRows.push([PERF_FAT_BINS[i], hoverAtPa[1], hoverAtPa[2], hoverAtPa[3], hoverAtPa[4], hoverAtPa[5], hoverAtPa[6], hoverAtPa[7], hoverAtPa[8]]);

    var tasAtPa = linearInterpRows(TAS_TABLES[i], paFt);
    tasRows.push([PERF_FAT_BINS[i], tasAtPa[1], tasAtPa[2], tasAtPa[3], tasAtPa[4], tasAtPa[5], tasAtPa[6]]);
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
    candidates.push(window.bmkhs_helisimEnvironment);
    candidates.push(window.fzaEnvironmentSetting);

    if (window.fzaMissionPlannerEnv && typeof window.fzaMissionPlannerEnv.environment !== 'undefined') {
      candidates.push(window.fzaMissionPlannerEnv.environment);
    }

  }

  var bodyEl = document.body;
  if (bodyEl && bodyEl.getAttribute) {
    candidates.push(bodyEl.getAttribute('data-fza-environment'));
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

  var planPAEl  = document.getElementById('planPA');
  var planFATEl = document.getElementById('planFAT');
  if (planPAEl)  planPAEl.placeholder  = String(atmosphere.pa);
  if (planFATEl) planFATEl.placeholder = String(atmosphere.fat);

  var planPAVal  = planPAEl  ? parseInt(String(planPAEl.value  || '').trim(), 10) : NaN;
  var planFATVal = planFATEl ? parseInt(String(planFATEl.value || '').trim(), 10) : NaN;

  return {
    pa:  !isNaN(planPAVal)  ? planPAVal  : atmosphere.pa,
    fat: !isNaN(planFATVal) ? planFATVal : atmosphere.fat
  };
}
