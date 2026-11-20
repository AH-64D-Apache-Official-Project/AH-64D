// Pulls the online manual and writes the in-game copy:
//   addons/fza_ah64_docs/ui/manual.html  every page, the site's CSS, fonts, script, images and search index in one file
//   addons/fza_ah64_docs/CfgFzaDocs.hpp  the sidebar's sections and pages, for the ACE menu
// Arma's browser only loads one local file per page, with images as data: URIs, so everything is inlined.
// Images over 150 KB are re-encoded to WebP at the same size in Chrome through Playwright.
// Usage: node tools/docsSnapshot.js [--max-mb 10]   (Node 18+; Playwright and Chrome installed)

const fs = require('fs');
const path = require('path');

const BASE = 'https://ah-64d-apache-official-project.github.io';
const FONTS_UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36';
const ADDON = path.join(__dirname, '..', 'addons', 'fza_ah64_docs');
const RECODE_OVER = 150 * 1024;
const WEBP_QUALITY = 0.9;
const ACE_SKIP_SECTIONS = ['Developers (archive)'];
const ACE_SKIP_PAGES = ['/reference/contributing/'];
const MIME = { '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.gif': 'image/gif', '.svg': 'image/svg+xml', '.webp': 'image/webp', '.ico': 'image/x-icon', '.woff2': 'font/woff2', '.woff': 'font/woff', '.ttf': 'font/ttf' };

const args = process.argv.slice(2);
const maxMb = Number((args[args.indexOf('--max-mb') + 1]) || 10) || 10;

function fail(msg) { console.error('docsSnapshot: ' + msg); process.exit(1); }

async function get(url, binary, headers) {
    for (let attempt = 1; ; attempt++) {
        try {
            const r = await fetch(url, { headers: headers || {} });
            if (!r.ok) { throw new Error('HTTP ' + r.status); }
            return binary ? Buffer.from(await r.arrayBuffer()) : await r.text();
        } catch (e) {
            if (attempt >= 3) { fail(url + ': ' + e.message); }
        }
    }
}

// Site path of an href found on a page, or null for other sites
function sitePath(href, fromPath) {
    if (!href || /^(mailto|javascript|data):/i.test(href) || href.startsWith('#')) { return null; }
    let u;
    try { u = new URL(href, BASE + fromPath); } catch (e) { return null; }
    if (u.origin !== BASE) { return null; }
    return u.pathname;
}

function isPage(p) { return p.endsWith('/') || p.endsWith('.html'); }

function decode(s) {
    return s.replace(/&amp;/g, '&').replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&lt;/g, '<').replace(/&gt;/g, '>');
}

function q(s) { return '"' + s.replace(/"/g, '""') + '"'; }

function className(s) {
    return s.replace(/[^A-Za-z0-9]+/g, ' ').trim().split(' ').map(w => w[0].toUpperCase() + w.slice(1)).join('') || 'Page';
}

(async () => {
    // ---------- pages: everything the sidebar links to, plus pages those link to ----------
    const pages = new Map();
    const queue = ['/'];
    while (queue.length) {
        const p = queue.shift();
        if (pages.has(p)) { continue; }
        const html = await get(BASE + p);
        pages.set(p, html);
        for (const m of html.matchAll(/<a\b[^>]*\bhref="([^"]+)"/g)) {
            const t = sitePath(decode(m[1]), p);
            if (t && isPage(t) && !pages.has(t) && !queue.includes(t)) { queue.push(t); }
        }
    }
    console.log('pages', pages.size);

    // ---------- the ACE menu, from the sidebar ----------
    const home = pages.get('/');
    const sidebar = (home.match(/<nav class="sidebar"[\s\S]*?<\/nav>/) || [])[0];
    if (!sidebar) { fail('no sidebar on the home page'); }
    const sections = [];
    for (const m of sidebar.matchAll(/<summary>([\s\S]*?)<\/summary>\s*<ul>([\s\S]*?)<\/ul>/g)) {
        const title = decode(m[1].replace(/<[^>]+>/g, '').trim());
        const items = [...m[2].matchAll(/<a href="([^"]+)"[^>]*>([\s\S]*?)<\/a>/g)].map(a => [decode(a[2].replace(/<[^>]+>/g, '').trim()), decode(a[1])]);
        sections.push([title, items]);
    }
    if (!sections.length) { fail('no sections in the sidebar'); }
    let cfg = '// Written by tools/docsSnapshot.js from the online manual\'s sidebar\n';
    cfg += 'class CfgFzaDocs {\n    class Sections {\n';
    for (const [title, items] of sections) {
        if (ACE_SKIP_SECTIONS.includes(title)) { continue; }
        const used = new Set();
        cfg += '        class ' + className(title) + ' {\n            title = ' + q(title) + ';\n            class Pages {\n';
        for (const [t, p] of items) {
            if (ACE_SKIP_PAGES.includes(p)) { continue; }
            let c = className(t);
            while (used.has(c)) { c += '_'; }
            used.add(c);
            cfg += '                class ' + c + ' { title = ' + q(t) + '; path = ' + q(p) + '; };\n';
        }
        cfg += '            };\n        };\n';
    }
    cfg += '    };\n};\n';

    // ---------- shared head: site CSS and fonts ----------
    const head = home.match(/<head>([\s\S]*?)<\/head>/)[1];
    const cssHref = (head.match(/<link rel="stylesheet" href="([^"]*site\.css[^"]*)"/) || [])[1];
    const fontsHref = (head.match(/<link href="(https:\/\/fonts\.googleapis\.com[^"]+)"/) || [])[1];
    const themeScript = (head.match(/<script>([\s\S]*?)<\/script>/) || [])[1] || '';
    if (!cssHref) { fail('no site.css'); }
    const assets = new Map();
    async function dataUri(url) {
        if (assets.has(url)) { return assets.get(url); }
        const ext = path.extname(new URL(url).pathname).toLowerCase();
        const buf = await get(url, true);
        const uri = 'data:' + (MIME[ext] || 'application/octet-stream') + ';base64,' + buf.toString('base64');
        assets.set(url, uri);
        return uri;
    }
    async function inlineCssUrls(css, from) {
        const urls = [...new Set([...css.matchAll(/url\(\s*['"]?([^'")]+)['"]?\s*\)/g)].map(m => m[1]).filter(u => !u.startsWith('data:')))];
        for (const u of urls) {
            const abs = new URL(u, from).href;
            css = css.split(u).join(await dataUri(abs));
        }
        return css;
    }
    const cssUrl = new URL(decode(cssHref), BASE + '/').href;
    let css = await inlineCssUrls(await get(cssUrl), cssUrl);
    let fontCss = '';
    if (fontsHref) {
        const raw = await get(decode(fontsHref), false, { 'User-Agent': FONTS_UA });
        // Latin only: the manual is English
        const blocks = raw.split('/* ').filter(b => b.startsWith('latin */'));
        fontCss = await inlineCssUrls(blocks.map(b => b.slice(b.indexOf('*/') + 2)).join('\n'), decode(fontsHref));
    }

    // ---------- the site script, made re-runnable per page ----------
    const jsHref = (home.match(/<script src="([^"]*site\.js[^"]*)"/) || [])[1];
    if (!jsHref) { fail('no site.js'); }
    let js = await get(new URL(decode(jsHref), BASE + '/').href);
    const patches = [
        [/^\s*\(function \(\) \{/, 'window.FZA_SITE_INIT = function () {'],
        [/\}\)\(\);\s*$/, '};'],
        ['fetch(base + "/search.json")', 'Promise.resolve({ json: function () { return window.FZA_SNAPSHOT.search; } })'],
        ['location.href = target.href', 'target.click()'],
        ['location.pathname', 'window.FZA_PATH']
    ];
    for (const [from, to] of patches) {
        const before = js;
        js = js.replace(from, to);
        if (js === before) { fail('site.js no longer contains ' + from + '; update the patches'); }
    }

    // ---------- per page: body, with images referenced by index ----------
    const images = [];
    const imageIndex = new Map();
    const out = {};
    const redirects = {};
    for (const [p, html] of pages) {
        const refresh = html.match(/<meta http-equiv="refresh" content="\d+;\s*url=([^"]+)"/i);
        if (refresh || !/<body[\s>]/.test(html)) {
            const t = refresh && sitePath(decode(refresh[1]), p);
            if (t) { redirects[p] = t; }
            continue;
        }
        const title = decode((html.match(/<title>([\s\S]*?)<\/title>/) || [, ''])[1].trim());
        const bodyTag = html.match(/<body([^>]*)>/);
        const bodyClass = decode(((bodyTag && bodyTag[1].match(/class="([^"]*)"/)) || [, ''])[1]);
        let body = html.slice(html.indexOf(bodyTag[0]) + bodyTag[0].length, html.lastIndexOf('</body>'));
        body = body.replace(/<script\b[\s\S]*?<\/script>/g, '');
        const refs = new Set();
        for (const m of body.matchAll(/\b(?:src|href|xlink:href|poster)="([^"]+)"/g)) {
            const t = sitePath(decode(m[1]), p);
            if (t && !isPage(t) && MIME[path.extname(t).toLowerCase()]) { refs.add(m[1]); }
        }
        for (const m of body.matchAll(/\bsrcset="([^"]+)"/g)) { fail(p + ' uses srcset, which is not handled'); }
        for (const r of refs) {
            const abs = BASE + sitePath(decode(r), p);
            if (!imageIndex.has(abs)) {
                imageIndex.set(abs, images.length);
                images.push(await dataUri(abs));
            }
            body = body.split('"' + r + '"').join('"fza-img:' + imageIndex.get(abs) + '"');
        }
        out[p] = { title: title, bodyClass: bodyClass, body: body };
    }

    // ---------- large images to WebP at the same size, in Chrome ----------
    const big = images.map((s, i) => [s.length, i]).filter(([n]) => n > RECODE_OVER).map(([, i]) => i);
    if (big.length) {
        let playwright;
        try { playwright = require('playwright'); } catch (e) { fail('Playwright is needed to re-encode large images (npm i -g playwright, set NODE_PATH)'); }
        const browser = await playwright.chromium.launch({ channel: 'chrome' });
        const page = await browser.newPage();
        for (const i of big) {
            const webp = await page.evaluate(async ([src, quality]) => {
                const img = new Image();
                img.src = src;
                await img.decode();
                const c = document.createElement('canvas');
                c.width = img.naturalWidth;
                c.height = img.naturalHeight;
                c.getContext('2d').drawImage(img, 0, 0);
                return c.toDataURL('image/webp', quality);
            }, [images[i], WEBP_QUALITY]);
            if (webp.startsWith('data:image/webp') && webp.length < images[i].length) {
                console.log('webp ' + (images[i].length / 1024).toFixed(0) + ' -> ' + (webp.length / 1024).toFixed(0) + ' KB');
                images[i] = webp;
            }
        }
        await browser.close();
    }

    // ---------- search index, bundled pages only ----------
    let search = [];
    try { search = JSON.parse(await get(BASE + '/search.json')).filter(d => pages.has(d.url)); } catch (e) { console.warn('no search index'); }

    const snapshot = { base: BASE, date: new Date().toISOString().slice(0, 10), pages: out, redirects: redirects, images: images, search: search };
    const json = JSON.stringify(snapshot).replace(/<\//g, '<\\/');
    const manual = [
        '<!doctype html>',
        '<html lang="en" data-theme="dark">',
        '<head>',
        '<meta charset="utf-8">',
        '<title>AH-64D Field Manual</title>',
        '<script>' + themeScript + '</script>',
        '<style>' + fontCss + '</style>',
        '<style>' + css + '</style>',
        '</head>',
        '<body></body>',
        '<script>window.FM_BASE = "";</script>',
        '<script>window.FZA_SNAPSHOT = ' + json + ';</script>',
        '<script>' + js.replace(/<\//g, '<\\/') + '</script>',
        '<script src="manual.js"></script>',
        '</html>',
        ''
    ].join('\n');

    const mb = Buffer.byteLength(manual) / 1048576;
    const imgMb = images.reduce((a, s) => a + s.length, 0) / 1048576;
    console.log('images', images.length, imgMb.toFixed(2) + ' MB as base64; fonts+css ' + ((fontCss.length + css.length) / 1048576).toFixed(2) + ' MB; total ' + mb.toFixed(2) + ' MB');
    if (mb > maxMb) {
        const big = [...imageIndex].map(([u, i]) => [images[i].length, u]).sort((a, b) => b[0] - a[0]).slice(0, 15);
        big.forEach(([n, u]) => console.log((n / 1024).toFixed(0).padStart(6) + ' KB  ' + u));
        fail('the copy is ' + mb.toFixed(2) + ' MB, over the ' + maxMb + ' MB limit');
    }
    fs.writeFileSync(path.join(ADDON, 'ui', 'manual.html'), manual);
    fs.writeFileSync(path.join(ADDON, 'CfgFzaDocs.hpp'), cfg);
    console.log('wrote manual.html and CfgFzaDocs.hpp (' + snapshot.date + ')');
})();
