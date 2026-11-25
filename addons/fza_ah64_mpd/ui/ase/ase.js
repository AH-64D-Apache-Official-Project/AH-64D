// The HTML ASE page's threat symbols and tracking lines, from fza_mpd_fnc_aseHtmlDraw. The footprint, rings, ownship
// and labels are drawn natively, over this.
//   fzaASE.defs({ident: [texture, texture 2, size, colour, place A, place B]})
//   fzaASE.frame({pts, lines}): pts as ui\shared\mpd_points.js draws them, at their MPD position; lines [bearing deg,
//     end radius] out from the ownship. Places are in MPD units, 0 to 1 across and down the MPD.
(function () {
    "use strict";

    var DEG = Math.PI / 180;
    // The browser covers 0.025 to 0.975 of the MPD (RscFzaMPDAse)
    var INSET = 0.025, SPAN = 0.95;
    // Tracking lines: yellow, dashed out from just clear of the ownship
    var CX = 0.5, CY = 0.5;
    var LINE_START = 0.018, LINE_DASH = [0.0179, 0.0179], LINE_WIDTH = 0.0027, LINE_COLOUR = [1, 1, 0, 1];

    var canvas, ctx, layer, W = 0, H = 0;
    var defs = {};
    var frame = {pts: [], lines: []};
    var dirty = true, failed = false;

    function arr(v) { return Array.isArray(v) ? v : []; }
    function X(d) { return (d - INSET) / SPAN * W; }
    function Y(d) { return (d - INSET) / SPAN * H; }
    function L(d) { return d / SPAN * H; }

    function drawLines() {
        ctx.save();
        try {
            ctx.strokeStyle = window.fzaMpdPoints.rgba(LINE_COLOUR);
            ctx.lineWidth = Math.max(1, L(LINE_WIDTH));
            ctx.lineCap = "butt";
            ctx.setLineDash(LINE_DASH.map(L));
            for (var i = 0; i < frame.lines.length; i++) {
                var l = arr(frame.lines[i]);
                var b = +l[0] * DEG, end = +l[1];
                if (!isFinite(b) || !(end > LINE_START) || !isFinite(end)) { continue; }
                var s = Math.sin(b), c = Math.cos(b);
                ctx.beginPath();
                ctx.moveTo(X(CX + LINE_START * s), Y(CY - LINE_START * c));
                ctx.lineTo(X(CX + end * s), Y(CY - end * c));
                ctx.stroke();
            }
        } finally {
            ctx.restore();
        }
    }

    // One picture; false while a texture is still loading
    function draw() {
        ctx.clearRect(0, 0, W, H);
        drawLines();
        // In order, so the selected emitter's fill is under its symbol
        var ready = true;
        for (var i = 0; i < frame.pts.length; i++) {
            var p = frame.pts[i];
            if (!Array.isArray(p)) { continue; }
            var pos = [+p[2], +p[3]];
            ready = layer.draw(p, defs[p[0]], isFinite(pos[0]) && isFinite(pos[1]) ? pos : null, false, []) && ready;
        }
        return ready;
    }

    function resize() {
        W = canvas.width = canvas.offsetWidth || 1024;
        H = canvas.height = canvas.offsetHeight || 1024;
        // Resizing resets the context, its font with it
        layer.resetFont();
        dirty = true;
    }

    function loop() {
        requestAnimationFrame(loop);
        if (W !== (canvas.offsetWidth || 1024) || H !== (canvas.offsetHeight || 1024)) { resize(); }
        if (!dirty) { return; }
        try {
            dirty = !draw();
        } catch (e) {
            // Waits for the next payload rather than failing every frame; the context is left clean for it
            dirty = false;
            ctx.globalAlpha = 1;
            ctx.setLineDash([]);
            if (!failed) {
                failed = true;
                console.error("fzaASE draw: " + (e && e.stack ? e.stack : e));
            }
        }
    }

    function init() {
        canvas = document.getElementById("threats");
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

    window.fzaASE = {
        defs: function (d) {
            if (!d || typeof d !== "object") { return; }
            defs = d;
            dirty = true;
        },
        frame: function (fr) {
            if (!fr) { return; }
            frame = {pts: arr(fr.pts), lines: arr(fr.lines)};
            dirty = true;
        }
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
}());
