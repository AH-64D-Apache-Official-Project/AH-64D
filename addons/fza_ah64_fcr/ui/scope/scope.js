// FCR GTM/ATM scope symbols — SQF pushes fzaFCRScope.update({mode, targets, shots}); a = degrees, r = range/8000, mode 1 = GTM wedge / 2 = ATM circle
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
    var targets      = [];
    var shots        = [];
    var targetsDirty = false;

    function init() {
        canvas = document.getElementById("overlay");
        ctx    = canvas.getContext("2d");
        resize();
        window.addEventListener("resize", resize);
        requestAnimationFrame(renderLoop);
    }

    function resize() {
        W = canvas.width  = canvas.offsetWidth  || 512;
        H = canvas.height = canvas.offsetHeight || 512;
        targetsDirty = true;
    }

    // Polar (aziDeg, rangeNorm) -> canvas px via the display-space geometry
    function toCanvas(g, aDeg, rNorm) {
        var dx = g.cx + Math.sin(aDeg * DEG) * rNorm * g.r8k;
        var dy = g.cy - Math.cos(aDeg * DEG) * rNorm * g.r8k;
        return [ (dx - 0.025) / 0.95 * W, (dy - 0.025) / 0.95 * H ];
    }

    function drawSymbols() {
        ctx.clearRect(0, 0, W, H);

        var g = GEOM[mode] || GEOM[1];
        var sizePx   = ICON_FRAC * H;
        var allDrawn = true;

        // Shot-at markers MPD green; TM 4.44.6: o 0 = under targets, 1 = over
        function drawShots(overlayPass) {
            for (var i = 0; i < shots.length; i++) {
                var s = shots[i];
                if ((s.o === 1) !== overlayPass) { continue; }
                if (s.r < 0 || s.r > 1) { continue; }
                var p = toCanvas(g, s.a, s.r);
                if (!window.fzaFCRIconLayer.draw(ctx, "shotat", p[0], p[1], sizePx, 1, "#00ff80")) { allDrawn = false; }
            }
        }

        drawShots(false);
        for (var i = 0; i < targets.length; i++) {
            var t = targets[i];
            if (t.r < 0 || t.r > 1) { continue; }
            var p = toCanvas(g, t.a, t.r);
            var alpha = t.stale ? 0.5 : 1;
            if (!window.fzaFCRIconLayer.draw(ctx, t.icon, p[0], p[1], sizePx, alpha)) { allDrawn = false; }
            if (t.ov) {
                if (!window.fzaFCRIconLayer.draw(ctx, t.ov, p[0], p[1], sizePx, alpha)) { allDrawn = false; }
            }
        }
        drawShots(true);
        return allDrawn;
    }

    function renderLoop() {
        requestAnimationFrame(renderLoop);

        var ow = canvas.offsetWidth  || 512;
        var oh = canvas.offsetHeight || 512;
        if (W !== ow || H !== oh) { resize(); }

        if (targetsDirty) {
            // Stay dirty until every sprite has finished its async decode
            targetsDirty = !drawSymbols();
        }
    }

    window.fzaFCRScope = {
        update: function (data) {
            if (data.mode !== undefined && data.mode !== mode) {
                mode = data.mode;
                targetsDirty = true;
            }
            if (data.targets !== undefined) {
                targets      = data.targets;
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
