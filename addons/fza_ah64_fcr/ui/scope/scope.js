// FCR GTM/ATM scope symbols — SQF pushes fzaFCRScope.update({mode, zoom, hover, targets, shots, zones}); zones [{c: 0 PF or 1 NF, p: [x, y, ...] in display units}]; a = degrees, r = range/8000, mode 1 = GTM wedge / 2 = ATM circle; zoom [x, y, ratio, half] or null; hover a target index or -1
(function () {
    "use strict";

    var DEG = Math.PI / 180;

    // Native page geometry: ownship centre and 8km radius in display units; browser covers 0.025..0.975
    var GEOM = {
        1: { cx: 0.5, cy: 0.87, r8k: 0.65  },
        2: { cx: 0.5, cy: 0.5,  r8k: 0.325 }
    };

    // Native MPD icons are 0.09 of display height; the browser covers 0.95 of it
    var ICON_FRAC = 0.09 / 0.95;

    var canvas, ctx, W, H;
    var mode         = 1;
    // Display zoom: [centreX, centreY, ratio, view half size] in display units, or null
    var zoom         = null;
    // The target the MPD cursor is on, drawn over a black circle in the cursor's centre, or -1
    var hover        = -1;
    // The circle's radius in display units, as the TSD's (headers\cursor.h MPD_CURSOR_POINT_CIRCLE)
    var HOVER_RADIUS = 0.022;
    var targets      = [];
    var shots        = [];
    var targetsDirty = false;
    // The active PF zone, white, and active NF zones, yellow with dashes that march, under the symbols
    var zcanvas, zctx;
    var zones        = [];
    var zonesKey     = "[]";
    var zonesDirty   = false;
    var zonesDrawnAt = 0;

    function init() {
        canvas = document.getElementById("overlay");
        ctx    = canvas.getContext("2d");
        zcanvas = document.getElementById("zones");
        zctx    = zcanvas.getContext("2d");
        resize();
        window.addEventListener("resize", resize);
        requestAnimationFrame(renderLoop);
    }

    function resize() {
        W = canvas.width  = canvas.offsetWidth  || 512;
        H = canvas.height = canvas.offsetHeight || 512;
        zcanvas.width  = W;
        zcanvas.height = H;
        targetsDirty = true;
        zonesDirty   = true;
    }

    function drawSymbols() {
        ctx.clearRect(0, 0, W, H);

        var g = GEOM[mode] || GEOM[1];
        var toPx = function (dx, dy) { return [ (dx - 0.025) / 0.95 * W, (dy - 0.025) / 0.95 * H ]; };
        // The zoomed format's border, in white, its symbols inside it
        if (zoom) {
            var a = toPx(0.5 - zoom[3], 0.5 - zoom[3]), b = toPx(0.5 + zoom[3], 0.5 + zoom[3]);
            ctx.strokeStyle = "#fff";
            ctx.lineWidth = Math.max(1, 0.006 * H);
            ctx.strokeRect(a[0], a[1], b[0] - a[0], b[1] - a[1]);
        }
        // Polar (aziDeg, rangeNorm) -> canvas px via the display-space geometry
        var toXY = function (item) {
            if (!(item.r >= 0 && item.r <= 1)) { return null; }
            var dx = g.cx + Math.sin(item.a * DEG) * item.r * g.r8k;
            var dy = g.cy - Math.cos(item.a * DEG) * item.r * g.r8k;
            if (zoom) {
                dx = 0.5 + (dx - zoom[0]) * zoom[2];
                dy = 0.5 + (dy - zoom[1]) * zoom[2];
                if (Math.abs(dx - 0.5) > zoom[3] || Math.abs(dy - 0.5) > zoom[3]) { return null; }
            }
            return toPx(dx, dy);
        };
        var hovered = targets[hover] ? toXY(targets[hover]) : null;
        if (hovered) {
            ctx.fillStyle = "#000";
            ctx.beginPath();
            ctx.arc(hovered[0], hovered[1], HOVER_RADIUS / 0.95 * H, 0, 2 * Math.PI);
            ctx.fill();
        }
        return window.fzaFCRIconLayer.drawSymbols(ctx, targets, shots, ICON_FRAC * H, toXY);
    }

    function toPx(dx, dy) { return [ (dx - 0.025) / 0.95 * W, (dy - 0.025) / 0.95 * H ]; }

    function zoomed(dx, dy) {
        if (zoom) {
            dx = 0.5 + (dx - zoom[0]) * zoom[2];
            dy = 0.5 + (dy - zoom[1]) * zoom[2];
        }
        return toPx(dx, dy);
    }

    function drawZones(t) {
        zctx.clearRect(0, 0, W, H);
        if (!zones.length) { return; }
        var g = GEOM[mode] || GEOM[1];
        var i, p, a;
        zctx.save();
        // The format's area: the GTM wedge or the ATM circle, and the zoomed square
        zctx.beginPath();
        if (mode === 2) {
            for (i = 0; i <= 64; i++) {
                a = i / 64 * 2 * Math.PI;
                p = zoomed(g.cx + Math.sin(a) * g.r8k, g.cy - Math.cos(a) * g.r8k);
                if (i) { zctx.lineTo(p[0], p[1]); } else { zctx.moveTo(p[0], p[1]); }
            }
        } else {
            p = zoomed(g.cx, g.cy);
            zctx.moveTo(p[0], p[1]);
            for (i = 0; i <= 32; i++) {
                a = (-45 + 90 * i / 32) * DEG;
                p = zoomed(g.cx + Math.sin(a) * g.r8k, g.cy - Math.cos(a) * g.r8k);
                zctx.lineTo(p[0], p[1]);
            }
        }
        zctx.closePath();
        zctx.clip();
        if (zoom) {
            var tl = toPx(0.5 - zoom[3], 0.5 - zoom[3]), br = toPx(0.5 + zoom[3], 0.5 + zoom[3]);
            zctx.beginPath();
            zctx.rect(tl[0], tl[1], br[0] - tl[0], br[1] - tl[1]);
            zctx.clip();
        }
        zctx.lineWidth = Math.max(1, 0.005 * H);
        zones.forEach(function (z) {
            zctx.beginPath();
            for (var k = 0; k + 1 < z.p.length; k += 2) {
                var q = zoomed(z.p[k], z.p[k + 1]);
                if (k) { zctx.lineTo(q[0], q[1]); } else { zctx.moveTo(q[0], q[1]); }
            }
            zctx.closePath();
            zctx.strokeStyle = z.c ? "#ff0" : "#fff";
            zctx.setLineDash(z.c ? [0.02 * H, 0.012 * H] : []);
            zctx.lineDashOffset = z.c ? -(t * 0.03 * H / 1000) : 0;
            zctx.stroke();
        });
        zctx.restore();
    }

    function renderLoop(t) {
        requestAnimationFrame(renderLoop);

        var ow = canvas.offsetWidth  || 512;
        var oh = canvas.offsetHeight || 512;
        if (W !== ow || H !== oh) { resize(); }

        if (targetsDirty) {
            // Stay dirty until every sprite has finished its async decode
            targetsDirty = !drawSymbols();
        }
        // The NF zones' dashes march at 30 frames a second
        var marquee = zones.some(function (z) { return z.c; });
        if (zonesDirty || (marquee && t - zonesDrawnAt > 33)) {
            drawZones(t || 0);
            zonesDrawnAt = t || 0;
            zonesDirty = false;
        }
    }

    window.fzaFCRScope = {
        update: function (data) {
            if (!data) { return; }
            if (data.mode !== undefined && data.mode !== mode) {
                mode = data.mode;
                targetsDirty = true;
                zonesDirty   = true;
            }
            if (data.hover !== undefined && data.hover !== hover) {
                hover = data.hover;
                targetsDirty = true;
            }
            if (data.zoom !== undefined && JSON.stringify(data.zoom) !== JSON.stringify(zoom)) {
                zoom = data.zoom;
                targetsDirty = true;
                zonesDirty   = true;
            }
            if (data.zones !== undefined) {
                var key = JSON.stringify(data.zones || []);
                if (key !== zonesKey) {
                    zonesKey   = key;
                    zones      = data.zones || [];
                    zonesDirty = true;
                }
            }
            if (data.targets !== undefined) {
                targets      = data.targets || [];
                shots        = data.shots || [];
                targetsDirty = true;
            }
        }
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
}());
