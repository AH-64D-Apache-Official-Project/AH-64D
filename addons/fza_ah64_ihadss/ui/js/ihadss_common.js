// Shared constants and drawing helpers. The format is 640x480 canvas units spanning the 40x30 deg HDU field.
(function () {
    "use strict";

    var IH = window.IH = {};

    IH.W = 640;
    IH.H = 480;
    IH.CX = 320;
    IH.CY = 240;
    IH.PX_PER_DEG = 16;

    // The page extends this far past the format on every side, so groups can be spread outward; IHADSS_PAGE_MARGIN in headers\hdu.h
    IH.MARGIN = 100;

    // Heads up, symbology is clipped to the HDU glass ellipse, inset slightly; HDU_CLIP_* in headers\hdu.h
    IH.HDU_CLIP = { a: 343, b: 362, rot: 60.4 * Math.PI / 180 };
    // ...and to the HDU display field (format units from the format centre); HDU_FIELD_* in headers\hdu.h
    IH.HDU_FIELD = { left: -358, right: 358, top: -274, bottom: 324 };

    // Heads up, groups are spread out to fill the HDU lens (format units); heads down they keep the TADS layout
    IH.SPREAD = { tape: -60, topLeft: [-44, -48], airspeed: -44, right: 66, waypoint: [-30, 20], bottom: 26, hadLeft: -22, hadRight: 14 };
    IH.NO_SPREAD = { tape: 0, topLeft: [0, 0], airspeed: 0, right: 0, waypoint: [0, 0], bottom: 0, hadLeft: 0, hadRight: 0 };
    IH.layout = IH.NO_SPREAD;

    IH.shifted = function (ctx, dx, dy, draw) {
        ctx.save();
        ctx.translate(dx, dy);
        draw();
        ctx.restore();
    };

    // Edges the dynamic symbols are limited to
    IH.EDGE = { left: 170, right: 495, top: 100, bottom: 400 };

    IH.GREEN = "#1AFF00";
    IH.WHITE = "#FFFFFF";

    IH.clamp = function (x, min, max) {
        return Math.min(max, Math.max(min, x));
    };

    IH.interp = function (x, fromMin, fromMax, toMin, toMax) {
        return toMin + ((x - fromMin) / (fromMax - fromMin)) * (toMax - toMin);
    };

    IH.isNum = function (x) {
        return typeof x === "number" && isFinite(x);
    };

    // Set while something flashes or times out, so the page redraws without waiting for a changed model
    IH.tickRequested = false;
    IH.requestTick = function () {
        IH.tickRequested = true;
    };

    // Flash and alternating-text rates
    IH.flashOn = function () {
        IH.requestTick();
        return Math.floor(performance.now() / 250) % 2 === 0;
    };
    IH.altPhase = function () {
        return Math.floor(performance.now() / 1000) % 2;
    };

    IH.font = function (ctx, size) {
        ctx.font = size + "px BMKApacheFont, monospace";
    };

    IH.text = function (ctx, str, x, y, align, baseline) {
        if (str === undefined || str === null || str === "") { return; }
        ctx.textAlign = align || "left";
        ctx.textBaseline = baseline || "bottom";
        ctx.fillText(String(str), x, y);
    };

    // Adds a dashed segment to the current path, starting and ending on a dash
    IH.dashTo = function (ctx, x1, y1, x2, y2, dash, gap) {
        var dx = x2 - x1;
        var dy = y2 - y1;
        var len = Math.sqrt(dx * dx + dy * dy);
        if (len === 0) { return; }
        var ux = dx / len;
        var uy = dy / len;
        for (var d = 0; d < len; d += dash + gap) {
            var e = Math.min(d + dash, len);
            ctx.moveTo(x1 + ux * d, y1 + uy * d);
            ctx.lineTo(x1 + ux * e, y1 + uy * e);
        }
    };

    // Heading tape: 210 deg shown across 360 format units
    IH.TAPE_HALF_DEG = 105;
    IH.TAPE_PX_PER_DEG = 180 / IH.TAPE_HALF_DEG;
    IH.TAPE_Y = 66;

    IH.wrap180 = function (a) {
        a = ((a + 180) % 360 + 360) % 360 - 180;
        return a;
    };

    IH.tapeX = function (relDeg, clampToTape) {
        var r = IH.wrap180(relDeg);
        if (Math.abs(r) > IH.TAPE_HALF_DEG) {
            if (!clampToTape) { return null; }
            r = IH.clamp(r, -IH.TAPE_HALF_DEG, IH.TAPE_HALF_DEG);
        }
        return IH.CX + r * IH.TAPE_PX_PER_DEG;
    };

    // Limits a canvas point to the symbol edges, returning [x, y, wasLimited]
    IH.edgeLimit = function (x, y) {
        var cx = IH.clamp(x, IH.EDGE.left, IH.EDGE.right);
        var cy = IH.clamp(y, IH.EDGE.top, IH.EDGE.bottom);
        return [cx, cy, cx !== x || cy !== y];
    };

    // Angular offset from the LOS reticle (deg, +right/+up) to canvas units at the format scale
    IH.angleToCanvas = function (az, el) {
        return [IH.CX + az * IH.PX_PER_DEG, IH.CY - el * IH.PX_PER_DEG];
    };
})();
