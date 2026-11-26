// The HTML TSD's map: the points and lines the native TSD draws as controls and canvas lines, from fza_mpd_fnc_tsdHtmlDraw.
//   fzaTSD.defs({ident: [texture, texture 2, size, colour, place A, place B]}), a place [x, y, "left|center|right",
//     "top|center|bottom"] or 0
//   fzaTSD.world({pts, segs, polys}): what stays put in the world
//   fzaTSD.frame({f, hl, cur, pts, segs, draft}): the map's frame and what moves with the aircraft
// A point is [ident, 1 world or 0 MPD position, x, y, text A, text B, ID type, ID number, bold 1/0], drawn by
// ui\shared\mpd_points.js, a seg [x1, y1, x2, y2, colour], a poly [closed, 0 solid / 1 dashed / 2 alternating, colour,
// [x, y, ...]], a draft [closed, colour, [x, y, ...]], f [x, y, heading, scale, centre x, centre y] as
// fza_mpd_fnc_tsdWorldToScreen, hl the chosen point's [ID type, ID number], cur the cursor while it is on a point.
// Places are in MPD units, 0 to 1 across and down the MPD.
(function () {
    "use strict";

    var DEG = Math.PI / 180;
    // The browser covers 0.025 to 0.975 of the MPD (RscFzaMPDTsd)
    var INSET = 0.025, SPAN = 0.95;
    // TSD_MAP_CLIP: lines are cut to it, points centred outside it are left out
    var CLIP = [0.095, 0.095, 0.905, 0.905];
    var LINE_WIDTH = 0.004;
    // The zones' dashes, the active ones alternating every half second; the FCR scope's are the same (scope.js)
    var DASHES = [[0.006, 0.006], [0.02, 0.012]];

    var canvas, ctx, layer, W = 0, H = 0;
    var defs = {};
    var world = {pts: [], segs: [], polys: []};
    var frame = null;
    var dirty = true, lastPhase = -1, hasAlternating = false, failed = false;

    function arr(v) { return Array.isArray(v) ? v : []; }
    function X(d) { return (d - INSET) / SPAN * W; }
    function Y(d) { return (d - INSET) / SPAN * H; }
    function L(d) { return d / SPAN * H; }
    var rgba = window.fzaMpdPoints.rgba;

    function project(f, x, y) {
        var dx = x - f[0], dy = y - f[1];
        var h = f[2] * DEG, c = Math.cos(h), s = Math.sin(h);
        return [f[4] + (dx * c - dy * s) * f[3], f[5] - (dx * s + dy * c) * f[3]];
    }

    function path(f, flat, closed) {
        ctx.beginPath();
        for (var i = 0; i + 1 < flat.length; i += 2) {
            var p = project(f, +flat[i], +flat[i + 1]);
            if (i) { ctx.lineTo(X(p[0]), Y(p[1])); } else { ctx.moveTo(X(p[0]), Y(p[1])); }
        }
        if (closed) { ctx.closePath(); }
    }

    function strokePoly(f, flat, closed, colour, dash) {
        flat = arr(flat);
        if (flat.length < 4) { return; }
        path(f, flat, closed);
        ctx.strokeStyle = rgba(colour);
        ctx.setLineDash(dash ? dash.map(L) : []);
        ctx.stroke();
    }

    function strokeSegs(f, segs) {
        for (var i = 0; i < segs.length; i++) {
            var s = arr(segs[i]);
            if (s.length < 5) { continue; }
            strokePoly(f, [s[0], s[1], s[2], s[3]], false, s[4], null);
        }
    }

    function drawLines(f, phase) {
        ctx.save();
        // Restored however the drawing ends, so a bad item cannot leave its clip on every later picture
        try {
            ctx.beginPath();
            ctx.rect(X(CLIP[0]), Y(CLIP[1]), X(CLIP[2]) - X(CLIP[0]), Y(CLIP[3]) - Y(CLIP[1]));
            ctx.clip();
            ctx.lineWidth = Math.max(1, L(LINE_WIDTH));
            ctx.lineCap = "butt";
            ctx.lineJoin = "miter";
            hasAlternating = false;
            for (var i = 0; i < world.polys.length; i++) {
                var z = arr(world.polys[i]);
                var style = z[1] | 0;
                if (style === 2) { hasAlternating = true; }
                strokePoly(f, z[3], !!z[0], z[2], style === 1 ? DASHES[0] : style === 2 ? DASHES[phase] : null);
            }
            strokeSegs(f, world.segs);
            strokeSegs(f, frame.segs);
            for (var j = 0; j < frame.draft.length; j++) {
                var d = arr(frame.draft[j]);
                strokePoly(f, d[2], !!d[0], d[1], null);
            }
        } finally {
            ctx.restore();
        }
    }

    function pointPlace(f, p) {
        var pos = p[1] ? project(f, +p[2], +p[3]) : [+p[2], +p[3]];
        if (!isFinite(pos[0]) || !isFinite(pos[1])) { return null; }
        if (pos[0] < CLIP[0] || pos[0] > CLIP[2] || pos[1] < CLIP[1] || pos[1] > CLIP[3]) { return null; }
        return pos;
    }

    // Draws a point; false while a texture is still loading
    function drawPoint(f, p, chosen) {
        return layer.draw(p, defs[p[0]], pointPlace(f, p), chosen, frame.cur);
    }

    // One picture of the map; false while a texture is still loading
    function draw(phase) {
        ctx.clearRect(0, 0, W, H);
        if (!frame || !frame.f) { hasAlternating = false; return true; }
        var f = frame.f;
        drawLines(f, phase);

        // The chosen point is drawn last, over the others
        var hl = frame.hl;
        var chosen = null;
        var ready = true;
        [world.pts, frame.pts].forEach(function (list) {
            for (var i = 0; i < list.length; i++) {
                var q = list[i];
                if (!Array.isArray(q)) { continue; }
                if (!chosen && hl.length > 1 && q[6] === hl[0] && q[7] === hl[1]) { chosen = q; continue; }
                ready = drawPoint(f, q, false) && ready;
            }
        });
        if (chosen) { ready = drawPoint(f, chosen, true) && ready; }
        return ready;
    }

    function resize() {
        W = canvas.width = canvas.offsetWidth || 1024;
        H = canvas.height = canvas.offsetHeight || 1024;
        // Resizing resets the context, its font with it
        layer.resetFont();
        dirty = true;
    }

    function loop(t) {
        requestAnimationFrame(loop);
        if (W !== (canvas.offsetWidth || 1024) || H !== (canvas.offsetHeight || 1024)) { resize(); }
        var phase = Math.floor((t || 0) / 500) % 2;
        if (!dirty && !(hasAlternating && phase !== lastPhase)) { return; }
        lastPhase = phase;
        try {
            dirty = !draw(phase);
        } catch (e) {
            // Waits for the next payload rather than failing every frame; the context is left clean for it
            dirty = false;
            ctx.globalAlpha = 1;
            ctx.setLineDash([]);
            if (!failed) {
                failed = true;
                console.error("fzaTSD draw: " + (e && e.stack ? e.stack : e));
            }
        }
    }

    function init() {
        canvas = document.getElementById("map");
        ctx = canvas.getContext("2d");
        layer = window.fzaMpdPoints.create({
            ctx: ctx, X: X, Y: Y, L: L,
            pxPerUnit: function () { return W / SPAN; },
            atlas: typeof _tsdIconData !== "undefined" ? _tsdIconData : null,
            onLoad: function () { dirty = true; }
        });
        resize();
        window.addEventListener("resize", resize);
        // The font is the page's own data, which may load after the first picture
        if (document.fonts && document.fonts.load) {
            document.fonts.load("20px BMKApacheFont").then(function () { dirty = true; }, function () { dirty = true; });
        }
        requestAnimationFrame(loop);
        // Asks for the data sent while the page was loading, which was lost (fza_fcr_fnc_displayUiInit)
        try {
            if (typeof A3API !== "undefined" && A3API && typeof A3API.SendAlert === "function") { A3API.SendAlert("fza:ready"); }
        } catch (e) {}
    }

    window.fzaTSD = {
        defs: function (d) {
            if (!d || typeof d !== "object") { return; }
            defs = d;
            dirty = true;
        },
        world: function (w) {
            if (!w) { return; }
            world = {pts: arr(w.pts), segs: arr(w.segs), polys: arr(w.polys)};
            dirty = true;
        },
        frame: function (fr) {
            if (!fr) { return; }
            var f = arr(fr.f);
            frame = {
                f: f.length >= 6 && f.every(function (v) { return isFinite(+v); }) ? f.map(Number) : null,
                hl: arr(fr.hl), cur: arr(fr.cur), pts: arr(fr.pts), segs: arr(fr.segs), draft: arr(fr.draft)
            };
            dirty = true;
        }
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
}());
