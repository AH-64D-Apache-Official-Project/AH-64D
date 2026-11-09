// The HTML TSD's map: the points and lines the native TSD draws as controls and on its canvas, from fza_mpd_fnc_tsdHtmlDraw.
//   fzaTSD.defs({ident: [texture, texture 2, size, colour, place A, place B]}), a place [x, y, "left|center|right",
//     "top|center|bottom"] or 0
//   fzaTSD.world({pts, segs, polys}): what stays put in the world
//   fzaTSD.frame({f, hl, cur, pts, segs, draft}): the map's frame and what moves with the aircraft
// A point is [ident, 1 world or 0 MPD position, x, y, text A, text B, ID type, ID number], a seg [x1, y1, x2, y2, colour],
// a poly [closed, 0 solid / 1 dashed / 2 alternating, colour, [x, y, ...]], a draft [closed, colour, [x, y, ...]],
// f [x, y, heading, scale, centre x, centre y] as fza_mpd_fnc_tsdWorldToScreen, hl the chosen point's [ID type, ID number],
// cur the cursor while it is on a point. Places are in MPD units, 0 to 1 across and down the MPD.
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
    // A point's text height is this over its icon size (fza_mpd_fnc_uiDrawPoint)
    var TEXT_SCALE = 0.00208;
    // BMKApacheFont's ascent and ascent plus descent over its em: the game's text cell is the ascent plus descent high
    var FONT_ASC = 0.754, FONT_CELL = 0.924;
    // Round the point the cursor is on: a black circle (MPD_CURSOR_POINT_CIRCLE) and the cursor's spokes
    var HL_RADIUS = 0.022, SPOKES_SIZE = 0.125, SPOKES_COLOUR = [0.6, 1, 0, 1];

    var canvas, ctx, W = 0, H = 0;
    var defs = {};
    var world = {pts: [], segs: [], polys: []};
    var frame = null;
    var dirty = true, lastPhase = -1, hasAlternating = false, failed = false;
    var sprites = {};

    function arr(v) { return Array.isArray(v) ? v : []; }
    function X(d) { return (d - INSET) / SPAN * W; }
    function Y(d) { return (d - INSET) / SPAN * H; }
    function L(d) { return d / SPAN * H; }
    function rgba(c) {
        c = arr(c);
        var ch = function (v) { return Math.round(Math.max(0, Math.min(1, +v || 0)) * 255); };
        return "rgba(" + ch(c[0]) + "," + ch(c[1]) + "," + ch(c[2]) + "," + (c.length > 3 ? Math.max(0, Math.min(1, +c[3])) : 1) + ")";
    }

    // A texture tinted as ctrlSetTextColor does: multiplied, its alpha kept
    function sprite(key, colour) {
        var tint = rgba([colour[0], colour[1], colour[2], 1]);
        var id = key + "|" + tint;
        var s = sprites[id];
        if (s) { return s; }
        s = sprites[id] = {canvas: null, ready: false, missing: false};
        var uri = typeof _tsdIconData !== "undefined" ? _tsdIconData[key] : null;
        if (!uri) { s.missing = true; return s; }
        var img = new Image();
        img.onload = function () {
            var c = document.createElement("canvas");
            c.width = img.width;
            c.height = img.height;
            var g = c.getContext("2d");
            g.drawImage(img, 0, 0);
            g.globalCompositeOperation = "multiply";
            g.fillStyle = tint;
            g.fillRect(0, 0, c.width, c.height);
            g.globalCompositeOperation = "destination-in";
            g.drawImage(img, 0, 0);
            s.canvas = c;
            s.ready = true;
            dirty = true;
        };
        img.onerror = function () { s.missing = true; dirty = true; };
        img.src = uri;
        return s;
    }

    // Draws a texture over [left, top, size]; false while it is still loading
    function drawTexture(key, colour, left, top, size) {
        if (!key) { return true; }
        var s = sprite(key, colour);
        if (s.missing) { return true; }
        if (!s.ready) { return false; }
        ctx.globalAlpha = colour.length > 3 ? Math.max(0, Math.min(1, +colour[3])) : 1;
        ctx.drawImage(s.canvas, X(left), Y(top), L(size), L(size));
        ctx.globalAlpha = 1;
        return true;
    }

    // A texture the page has no copy of (a mission's own icon): a diamond in its colour
    function drawStandIn(colour, x, y, size) {
        var r = L(size) * 0.25;
        ctx.beginPath();
        ctx.moveTo(X(x), Y(y) - r);
        ctx.lineTo(X(x) + r, Y(y));
        ctx.lineTo(X(x), Y(y) + r);
        ctx.lineTo(X(x) - r, Y(y));
        ctx.closePath();
        ctx.strokeStyle = rgba(colour);
        ctx.lineWidth = Math.max(1, L(LINE_WIDTH));
        ctx.setLineDash([]);
        ctx.stroke();
    }

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

    // Setting the font parses it, so only when it changes
    var lastFont = "";
    function setFont(px) {
        var font = px.toFixed(2) + "px BMKApacheFont";
        if (font !== lastFont) {
            ctx.font = font;
            lastFont = font;
        }
    }

    // A text's place: anchored at its offset in the icon, by its alignment, the cell's middle at the anchor. Its width is
    // only measured for the black under the chosen point's text.
    function textLayout(text, place, left, top, size, measure) {
        if (!Array.isArray(place) || (typeof text !== "string" && typeof text !== "number") || text === "") { return null; }
        text = String(text);
        var h = TEXT_SCALE / size;
        var yOffset = place[3] === "top" ? h * 0.5 : place[3] === "bottom" ? -h * 0.5 : 0;
        var x = left + (+place[0] || 0) * size;
        var mid = top + (+place[1] || 0) * size + yOffset;
        var align = place[2] === "right" || place[2] === "center" ? place[2] : "left";
        var px = L(h) / FONT_CELL;
        if (!(px > 0) || !isFinite(px)) { return null; }
        var width = 0;
        if (measure) {
            setFont(px);
            width = ctx.measureText(text).width / (W / SPAN);
        }
        var textLeft = x - width * (align === "right" ? 1 : align === "center" ? 0.5 : 0);
        return {text: text, x: x, mid: mid, h: h, px: px, align: align, left: textLeft, width: width};
    }

    function drawText(t, colour) {
        setFont(t.px);
        ctx.textAlign = t.align;
        ctx.textBaseline = "alphabetic";
        ctx.fillStyle = rgba(colour);
        ctx.fillText(t.text, X(t.x), Y(t.mid - t.h * 0.5) + t.px * FONT_ASC);
    }

    function pointPlace(f, p) {
        var pos = p[1] ? project(f, +p[2], +p[3]) : [+p[2], +p[3]];
        if (!isFinite(pos[0]) || !isFinite(pos[1])) { return null; }
        if (pos[0] < CLIP[0] || pos[0] > CLIP[2] || pos[1] < CLIP[1] || pos[1] > CLIP[3]) { return null; }
        return pos;
    }

    // Draws a point; false while a texture is still loading
    function drawPoint(f, p, chosen) {
        var d = defs[p[0]];
        if (!Array.isArray(d)) { return true; }
        var size = +d[2];
        if (!(size > 0) || !isFinite(size)) { return true; }
        var colour = d[3];
        if (!Array.isArray(colour) || colour.length < 3 || !colour.every(function (v) { return isFinite(+v); })) { return true; }
        var pos = pointPlace(f, p);
        if (!pos) { return true; }
        var left = pos[0] - size * 0.5, top = pos[1] - size * 0.5;
        var tA = textLayout(p[4], d[4], left, top, size, chosen);
        var tB = textLayout(p[5], d[5], left, top, size, chosen);
        var ready = true;

        // Over the cursor: its spokes where it is, a black circle under the point, black under its text
        if (chosen) {
            var cur = frame.cur;
            var cx = cur.length > 1 ? +cur[0] : pos[0], cy = cur.length > 1 ? +cur[1] : pos[1];
            ready = drawTexture("spokes", SPOKES_COLOUR, cx - SPOKES_SIZE * 0.5, cy - SPOKES_SIZE * 0.5, SPOKES_SIZE) && ready;
            ctx.fillStyle = "#000";
            ctx.beginPath();
            ctx.arc(X(pos[0]), Y(pos[1]), L(HL_RADIUS), 0, 2 * Math.PI);
            ctx.fill();
            [tA, tB].forEach(function (t) {
                if (!t || t.width <= 0) { return; }
                ctx.fillRect(X(t.left - 0.002), Y(t.mid - 0.6 * t.h), L(t.width + 0.004), L(1.2 * t.h));
            });
        }

        var key = String(d[0] || "");
        if (key && typeof _tsdIconData !== "undefined" && !_tsdIconData[key]) {
            drawStandIn(colour, pos[0], pos[1], size);
        } else {
            ready = drawTexture(key, colour, left, top, size) && ready;
        }
        ready = drawTexture(String(d[1] || ""), colour, left, top, size) && ready;
        if (tA) { drawText(tA, colour); }
        if (tB) { drawText(tB, colour); }
        return ready;
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
        lastFont = "";
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
