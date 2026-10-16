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

    function drawSymbols() {
        ctx.clearRect(0, 0, W, H);

        var g = GEOM[mode] || GEOM[1];
        // Polar (aziDeg, rangeNorm) -> canvas px via the display-space geometry
        return window.fzaFCRIconLayer.drawSymbols(ctx, targets, shots, ICON_FRAC * H, function (item) {
            if (!(item.r >= 0 && item.r <= 1)) { return null; }
            var dx = g.cx + Math.sin(item.a * DEG) * item.r * g.r8k;
            var dy = g.cy - Math.cos(item.a * DEG) * item.r * g.r8k;
            return [ (dx - 0.025) / 0.95 * W, (dy - 0.025) / 0.95 * H ];
        });
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
            if (!data) { return; }
            if (data.mode !== undefined && data.mode !== mode) {
                mode = data.mode;
                targetsDirty = true;
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
