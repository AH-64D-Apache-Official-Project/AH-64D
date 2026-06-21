// dom_utils.js -- DOM utilities, formatters, string helpers, and SQF bridge

function eachNode(selector, callback) {
  var nodes = document.querySelectorAll(selector);
  for (var i = 0; i < nodes.length; i++) {
    callback(nodes[i], i);
  }
}

function getData(el, key) {
  return (el && el.getAttribute) ? (el.getAttribute('data-' + key) || '') : '';
}


function setData(el, key, value) {
  if (el && el.setAttribute) {
    el.setAttribute('data-' + key, String(value));
  }
}


function parseNumberText(text) {
  var cleaned = String(text || '').replace(/[^0-9\-]/g, '');
  var value = parseInt(cleaned || '0', 10);
  if (isNaN(value)) return 0;
  return value;
}

function sanitizeSignedInput(inputEl, min, max) {
  if (!inputEl) return 0;
  var raw = String(inputEl.value || '');
  var sign = raw.trim().indexOf('-') === 0 ? '-' : '';
  var digits = raw.replace(/[^0-9]/g, '');
  var parsed = parseInt((sign + digits) || '0', 10);
  if (isNaN(parsed)) parsed = 0;
  if (parsed < min) parsed = min;
  if (parsed > max) parsed = max;
  inputEl.value = String(parsed);
  return parsed;
}

function formatWhole(value) {
  return String(Math.round(value));
}

function formatWholeComma(value) {
  var n = Math.round(value);
  return String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

function formatEnduranceFromPph(fuelLbs, pph) {
  if (!isFinite(fuelLbs) || !isFinite(pph) || pph <= 0) return '--';
  var totalMinutes = Math.round((fuelLbs / pph) * 60);
  if (totalMinutes < 0) totalMinutes = 0;
  var hours = Math.floor(totalMinutes / 60);
  var minutes = totalMinutes % 60;
  var minuteText = minutes < 10 ? ('0' + String(minutes)) : String(minutes);
  return String(hours) + '+' + minuteText;
}

function readQueryParam(name) {
  if (typeof window === 'undefined' || !window.location) return '';
  var search = String(window.location.search || '');
  if (!search || search.charAt(0) !== '?') return '';

  var pairs = search.substring(1).split('&');
  for (var i = 0; i < pairs.length; i++) {
    var pair = pairs[i].split('=');
    if (decodeURIComponent(pair[0] || '') !== name) continue;
    return decodeURIComponent(pair.slice(1).join('=') || '');
  }
  return '';
}

function trimSaveName(rawName) {
  return String(rawName || '').replace(/^\s+|\s+$/g, '').replace(/\s+/g, ' ');
}

function showAlert(message) {
  if (typeof A3API !== 'undefined' && A3API && typeof A3API.SendAlert === 'function') {
    A3API.SendAlert(String(message || ''));
    return;
  }

  alert(String(message || ''));
}

function showConfirm(message) {
  if (typeof A3API !== 'undefined' && A3API && typeof A3API.SendConfirm === 'function') {
    return !!A3API.SendConfirm(String(message || ''));
  }

  return confirm(String(message || ''));
}


function sqfQuotedString(value) {
  return '"' + String(value || '')
    .replace(/"/g, '""') + '"';
}


function normalizeSaveName(name) {
  return trimSaveName(name).toLowerCase();
}

function dismissLoadingOverlay() {
  var overlay = document.getElementById('loadingOverlay');
  if (overlay) overlay.parentNode.removeChild(overlay);
}


function sanitizeFuelInput(inputEl) {
  var cleaned = (inputEl.value || '').replace(/[^0-9]/g, '');
  var value = cleaned === '' ? 0 : parseInt(cleaned, 10);
  var max = parseInt(getData(inputEl, 'max') || inputEl.max || '0', 10);
  if (isNaN(value) || value < 0) value = 0;
  if (!isNaN(max) && max > 0 && value > max) value = max;
  inputEl.value = String(value);
}

function sanitizeZoneInput(inputEl) {
  var cleaned = (inputEl.value || '').replace(/[^0-9]/g, '');
  var value = cleaned === '' ? 0 : parseInt(cleaned, 10);
  var max = parseInt(getData(inputEl, 'max') || '0', 10);
  if (isNaN(value)) value = 0;
  if (value < 0) value = 0;
  if (!isNaN(max) && max > 0 && value > max) value = max;
  inputEl.value = String(value);
}

function callSQF(code) {
  try {
    if (typeof A3API !== 'undefined' && A3API && typeof A3API.SendAlert === 'function') {
      A3API.SendAlert('sqf:' + String(code || ''));
      return true;
    }

    if (typeof console !== 'undefined' && console.warn) {
      console.warn('Mission Planner SQF bridge unavailable.', code);
    }
  } catch (e) {
    if (typeof console !== 'undefined' && console.warn) {
      console.warn('Mission Planner SQF bridge failed.', e);
    }
  }

  return false;
}
