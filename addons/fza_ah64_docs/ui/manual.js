// Navigation for the offline copy written by tools/docsSnapshot.js: one page body at a time, with the site's
// own script run again for each page, so pages look and behave as they do online.
(function () {
  'use strict';

  var S = window.FZA_SNAPSHOT;
  var current = null;
  var stack = [];
  var siteListeners = [];
  var readyTimer = null;
  var started = false;

  function send(cmd, data) {
    var msg = { cmd: cmd };
    if (data) { for (var k in data) { msg[k] = data[k]; } }
    try {
      if (typeof A3API !== 'undefined' && A3API && typeof A3API.SendAlert === 'function') {
        A3API.SendAlert('fzadocs:' + JSON.stringify(msg));
      }
    } catch (e) { /* no game */ }
  }

  function resolve(path) {
    for (var i = 0; i < 5 && path && !S.pages[path]; i++) {
      if (S.redirects[path]) { path = S.redirects[path]; }
      else if (S.pages[path + '/']) { path = path + '/'; }
      else { return null; }
    }
    return S.pages[path] ? path : null;
  }

  // The site's script adds window and document listeners on every run; they go with the page
  function runSite() {
    var targets = [window, document];
    targets.forEach(function (t) {
      t.addEventListener = function (type, fn, opt) {
        siteListeners.push([t, type, fn, opt]);
        return EventTarget.prototype.addEventListener.call(t, type, fn, opt);
      };
    });
    try { window.FZA_SITE_INIT(); } catch (e) { console.error(e); }
    targets.forEach(function (t) { delete t.addEventListener; });
  }

  function scrollToHash(hash) {
    var el = null;
    try { el = hash && hash.length > 1 ? document.getElementById(decodeURIComponent(hash.slice(1))) : null; } catch (e) { el = null; }
    if (el) { el.scrollIntoView(); } else { window.scrollTo(0, 0); }
  }

  function render(path, hash, push, scrollY) {
    var p = resolve(path);
    if (!p) { return false; }
    if (push && current) { stack.push({ path: current, y: window.scrollY }); }

    siteListeners.forEach(function (l) { l[0].removeEventListener(l[1], l[2], l[3]); });
    siteListeners = [];

    var page = S.pages[p];
    current = p;
    window.FZA_PATH = p;
    document.title = page.title;
    document.body.className = page.bodyClass;
    document.body.innerHTML = page.body.replace(/fza-img:(\d+)/g, function (m, i) { return S.images[+i] || ''; });
    runSite();

    if (typeof scrollY === 'number') { window.scrollTo(0, scrollY); } else { scrollToHash(hash); }
    send('page', { path: p });
    return true;
  }

  function back() {
    var prev = stack.pop();
    if (prev) { render(prev.path, '', false, prev.y); }
  }

  document.addEventListener('click', function (e) {
    var a = e.target && e.target.closest ? e.target.closest('a[href]') : null;
    if (!a || e.defaultPrevented) { return; }
    var href = a.getAttribute('href');
    if (href.charAt(0) === '#') {
      e.preventDefault();
      scrollToHash(href);
      return;
    }
    var u;
    try { u = new URL(href, S.base + (current || '/')); } catch (x) { return; }
    e.preventDefault();
    if (u.origin === S.base && render(u.pathname, u.hash, true)) { return; }
    send('external', { url: u.href });
  }, true);

  // Mouse back button and Alt+Left, as in a browser
  document.addEventListener('mouseup', function (e) { if (e.button === 3) { e.preventDefault(); back(); } });
  document.addEventListener('keydown', function (e) { if (e.altKey && e.key === 'ArrowLeft') { e.preventDefault(); back(); } });

  // Reports what the game's page policy blocks, for the RPT
  var reported = {};
  document.addEventListener('securitypolicyviolation', function (e) {
    var key = e.violatedDirective + ' ' + e.blockedURI;
    if (reported[key]) { return; }
    reported[key] = true;
    send('csp', { directive: e.violatedDirective, blocked: String(e.blockedURI).slice(0, 80), policy: e.originalPolicy });
  });

  function start(path, hash) {
    started = true;
    if (readyTimer) { clearInterval(readyTimer); readyTimer = null; }
    if (!render(path || '/', hash || '', false)) { render('/', '', false); }
  }

  window.fzaDocs = {
    receive: function (m) {
      if (!m || typeof m !== 'object') { return; }
      if (m.type === 'init' && !started) { start(m.path, m.hash); }
      else if (m.type === 'go') { render(m.path, m.hash || '', true); }
    },
    back: back,
    go: function (path, hash) { return render(path, hash || '', true); }
  };

  if (typeof A3API === 'undefined') {
    var h = location.hash.slice(1);
    start(h || '/', '');
  } else {
    send('ready', { date: S.date });
    readyTimer = setInterval(function () { send('ready', { date: S.date }); }, 500);
  }
}());
