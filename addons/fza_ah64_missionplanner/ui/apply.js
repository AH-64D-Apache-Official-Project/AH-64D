// apply.js -- the Apply to ACFT panel: progress, messages and cancel, fed by fza_mplanner_fnc_applyRun

var g_apply = {
  busy: false,
  answered: false,
  noAnswer: 0,
  raf: 0,
  index: 0,
  count: 0,
  stepStart: 0,
  stepDur: 0,
  stepLabel: ''
};

function applyEl(id) {
  return document.getElementById(id);
}

function applyPanelVisible() {
  var m = applyEl('applyModal');
  return !!(m && m.classList.contains('visible'));
}

function applyLog(level, text) {
  var log = applyEl('applyLog');
  if (!log || !text) return;
  var row = document.createElement('div');
  row.className = 'apply-log-row apply-' + (level || 'info');
  row.textContent = String(text);
  log.appendChild(row);
  log.scrollTop = log.scrollHeight;
}

function applySetBar(frac) {
  var fill = applyEl('applyBarFill');
  if (fill) fill.style.width = (Math.max(0, Math.min(1, frac)) * 100).toFixed(1) + '%';
}

function applySetButtons(running) {
  var cancel = applyEl('btnApplyCancel');
  var close = applyEl('btnApplyClose');
  if (cancel) {
    cancel.style.display = running ? '' : 'none';
    cancel.disabled = false;
  }
  if (close) close.style.display = running ? 'none' : '';
}

// The bar runs on the page between the game's step messages
function applyTick() {
  g_apply.raf = 0;
  if (!g_apply.busy || !g_apply.count) return;
  var elapsed = (Date.now() - g_apply.stepStart) / 1000;
  var stepFrac = g_apply.stepDur > 0 ? Math.min(1, elapsed / g_apply.stepDur) : 1;
  applySetBar((g_apply.index - 1 + stepFrac) / g_apply.count);
  var step = applyEl('applyStep');
  if (step) {
    var left = Math.max(0, Math.ceil(g_apply.stepDur - elapsed));
    step.textContent = 'Step ' + g_apply.index + ' of ' + g_apply.count + ': ' + g_apply.stepLabel + (left > 0 ? ' (' + left + ' s)' : '');
  }
  if (stepFrac < 1) g_apply.raf = requestAnimationFrame(applyTick);
}

function applyStopTick() {
  if (g_apply.raf) cancelAnimationFrame(g_apply.raf);
  g_apply.raf = 0;
}

function openApplyPanel() {
  var m = applyEl('applyModal');
  if (!m) return;
  m.classList.add('visible');
  m.setAttribute('aria-hidden', 'false');
}

function closeApplyPanel() {
  if (g_apply.busy) return;
  var m = applyEl('applyModal');
  if (!m) return;
  m.classList.remove('visible');
  m.setAttribute('aria-hidden', 'true');
}

function startApplyToAircraft(code) {
  if (g_apply.busy) return;
  g_apply.busy = true;
  g_apply.answered = false;
  g_apply.index = 0;
  g_apply.count = 0;
  applyStopTick();
  var log = applyEl('applyLog');
  if (log) log.innerHTML = '';
  applyEl('applyTitle').textContent = 'Applying to Aircraft';
  applyEl('applyStep').textContent = 'Starting...';
  applySetBar(0);
  applySetButtons(true);
  openApplyPanel();
  clearTimeout(g_apply.noAnswer);
  g_apply.noAnswer = setTimeout(function() {
    if (g_apply.busy && !g_apply.answered) finishApply('failed', 'No answer from the game yet. If it answers, the apply carries on here.');
  }, 5000);
  if (!callSQF(code)) finishApply('failed', 'The planner cannot reach the game. Nothing was changed.');
}

function finishApply(status, text) {
  g_apply.busy = false;
  clearTimeout(g_apply.noAnswer);
  applyStopTick();
  var titles = {
    complete: 'Apply Complete',
    cancelled: 'Apply Stopped',
    refused: 'Apply Refused',
    failed: 'Apply Failed'
  };
  applyEl('applyTitle').textContent = titles[status] || 'Apply Finished';
  applyEl('applyStep').textContent = '';
  if (status === 'complete') applySetBar(1);
  applyLog(status === 'complete' ? 'ok' : (status === 'cancelled' ? 'warn' : 'error'), text);
  applySetButtons(false);
  openApplyPanel();
}

function cancelApply() {
  if (!g_apply.busy) return;
  var cancel = applyEl('btnApplyCancel');
  if (cancel) cancel.disabled = true;
  applyEl('applyStep').textContent = 'Stopping...';
  callSQF('uiNamespace setVariable ["fza_mplanner_applyCancel", true];');
}

// ESC: stops a running apply, or closes the finished panel
function applyPanelEscape() {
  if (!applyPanelVisible()) return false;
  if (g_apply.busy) cancelApply();
  else closeApplyPanel();
  return true;
}

function showPlannerNotice(text, level) {
  var el = applyEl('saveLoadNotice');
  if (!el) return;
  el.textContent = String(text || '');
  el.className = 'modal-hint modal-notice' + (level === 'warn' ? ' notice-warn' : '');
}

// Events from fza_mplanner_fnc_pageEvent
window.fza_mplanner_event = function(ev) {
  if (!ev || typeof ev !== 'object') return;
  switch (ev.type) {
    case 'notice':
      showPlannerNotice(ev.text, ev.level);
      break;
    case 'refused':
      g_apply.answered = true;
      finishApply('refused', ev.text);
      break;
    case 'start':
      g_apply.answered = true;
      // A late answer, after the panel gave up waiting
      if (!g_apply.busy) {
        g_apply.busy = true;
        applyEl('applyTitle').textContent = 'Applying to Aircraft';
        applyLog('info', 'The game answered; applying now.');
        applySetButtons(true);
        openApplyPanel();
      }
      g_apply.count = Number(ev.count) || 0;
      applyEl('applyStep').textContent = g_apply.count ? '' : 'Nothing needs changing.';
      break;
    case 'step':
      g_apply.index = Number(ev.index) || 0;
      g_apply.count = Number(ev.count) || g_apply.count;
      g_apply.stepStart = Date.now();
      g_apply.stepDur = Number(ev.duration) || 0;
      g_apply.stepLabel = String(ev.label || '');
      applyLog('step', g_apply.stepLabel);
      applyStopTick();
      applyTick();
      break;
    case 'log':
      applyLog(ev.level, ev.text);
      break;
    case 'done':
      finishApply(String(ev.status || 'complete'), ev.text);
      break;
  }
};
