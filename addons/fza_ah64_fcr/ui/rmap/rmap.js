// FCR RMAP B-scope — SQF pushes fzaFCRRmap.update({halfFov, aziSteps, nearSteps, farSteps, hardClear, video, targets, shots, columns})
// A column is {i, near, d}: d holds one return-level digit (0-6) per range cell.
(function () {
    "use strict";

    // Level 0=shadow, 1–6 = increasing radar return strength
    var LEVEL_GREY = [0, 42, 85, 128, 170, 212, 255];

    var MAX_RANGE_M  = 8000;
    var NEAR_MAX_M   = 4000;
    var RADAR_LEFT   = 0.1632;
    var RADAR_RIGHT  = 0.8368;
    var RADAR_TOP    = 0.1316;
    var RADAR_BOTTOM = 0.8947;

    // Native MPD icons are 0.09 of display height; the browser covers 0.95 of it
    var ICON_FRAC = 0.09 / 0.95;

    var canvas, ctx, W, H;
    var overlay, octx;

    var nearGrid = [];   // per azimuth column: Uint8Array(nearSteps), or null while unscanned
    var farGrid  = [];
    var hasData  = false;

    var targets      = [];
    var shots        = [];
    var targetsDirty = false;

    // Full repaints only on clear/resize/geometry change, else just the dirty column x-band
    var fullDirty   = true;
    var dirtyColMin = -1;
    var dirtyColMax = -1;
    var imgData     = null;  // persistent pixel buffer, reallocated only on resize

    var params = {
        halfFov:   45,
        aziSteps:  300,
        nearSteps: 150,
        farSteps:  150,
        video:     true
    };

    function markCol(i) {
        if (dirtyColMin < 0 || i < dirtyColMin) { dirtyColMin = i; }
        if (i > dirtyColMax) { dirtyColMax = i; }
    }

    function resetBuffer() {
        if (!ctx) { return; }
        imgData = ctx.createImageData(W, H);
        var px = imgData.data;
        for (var i = 3; i < px.length; i += 4) { px[i] = 255; } // opaque black
    }

    function clearGrid() {
        nearGrid  = new Array(params.aziSteps).fill(null);
        farGrid   = new Array(params.aziSteps).fill(null);
        hasData   = false;
        resetBuffer();
        fullDirty = true;
    }

    // Digit string (or plain array) -> fixed-length levels, so the paint loop never reads a hole
    function decodeColumn(d, steps) {
        var out = new Uint8Array(steps);
        if (!d) { return out; }
        var isStr = (typeof d === "string");
        var n = Math.min(steps, d.length);
        for (var k = 0; k < n; k++) {
            var v = isStr ? (d.charCodeAt(k) - 48) : (d[k] | 0);
            out[k] = v < 0 ? 0 : (v > 6 ? 6 : v);
        }
        return out;
    }

    function init() {
        canvas  = document.getElementById("canvas");
        ctx     = canvas.getContext("2d");
        overlay = document.getElementById("overlay");
        octx    = overlay.getContext("2d");
        resize();
        clearGrid();
        window.addEventListener("resize", resize);
        requestAnimationFrame(renderLoop);
    }

    function resize() {
        // Measured on the overlay: it is never hidden, the video canvas can be
        W = canvas.width  = overlay.offsetWidth  || 512;
        H = canvas.height = overlay.offsetHeight || 512;
        overlay.width  = W;
        overlay.height = H;
        resetBuffer();
        fullDirty    = true;
        targetsDirty = true;
    }

    // B-scope pixel fill for x in [xFrom, xTo] — bottom = 0m, top = 8000m; unscanned stays black
    function paintPixels(xFrom, xTo) {
        var halfFov   = params.halfFov;
        var aziSteps  = params.aziSteps;
        var nearSteps = params.nearSteps;
        var farSteps  = params.farSteps;

        var rLeft   = RADAR_LEFT   * W;
        var rRight  = RADAR_RIGHT  * W;
        var rTop    = RADAR_TOP    * H;
        var rBottom = RADAR_BOTTOM * H;
        var rW      = rRight  - rLeft;
        var rH      = rBottom - rTop;

        var aziStepD  = (halfFov * 2) / aziSteps;
        var nearStepM = NEAR_MAX_M / nearSteps;
        var farStepM  = (MAX_RANGE_M - NEAR_MAX_M) / farSteps;

        if (xFrom < rLeft)  { xFrom = Math.ceil(rLeft);   }
        if (xTo   > rRight) { xTo   = Math.floor(rRight); }

        var px = imgData.data;

        for (var y = 0; y < H; y++) {
            if (y < rTop || y > rBottom) { continue; }

            var rangeM   = ((rBottom - y) / rH) * MAX_RANGE_M;
            var isNear   = rangeM < NEAR_MAX_M;
            var stepM    = isNear ? nearStepM : farStepM;
            var localM   = isNear ? rangeM : rangeM - NEAR_MAX_M;
            var maxSteps = isNear ? nearSteps : farSteps;

            var ri = Math.floor(localM / stepM);
            if (ri < 0)         { ri = 0; }
            if (ri >= maxSteps) { ri = maxSteps - 1; }

            var rowIdx = y * W * 4;
            for (var x = xFrom; x <= xTo; x++) {
                var aziFrac = (x - rLeft) / rW;
                // Display axis fixed at wide +-45: smaller scans paint a centre strip
                var aziDeg  = (aziFrac - 0.5) * 90;
                var ai      = Math.floor((aziDeg + halfFov) / aziStepD);
                if (ai < 0 || ai >= aziSteps) { continue; }

                var col = isNear ? nearGrid[ai] : farGrid[ai];
                if (!col) { continue; }

                var lv = col[ri];
                // Blend across near/far boundary to remove hard seam
                if (isNear && ri === nearSteps - 1) {
                    var farCol = farGrid[ai];
                    if (farCol) { lv = Math.round(lv * 0.5 + farCol[0] * 0.5); }
                } else if (!isNear && ri === 0) {
                    var nearCol = nearGrid[ai];
                    if (nearCol) { lv = Math.round(lv * 0.5 + nearCol[nearSteps - 1] * 0.5); }
                }
                var g   = LEVEL_GREY[lv];
                var idx = rowIdx + x * 4;
                px[idx    ] = g;
                px[idx + 1] = g;
                px[idx + 2] = g;
                px[idx + 3] = 255;
            }
        }
    }

    // Symbols on the overlay canvas above the terrain; redrawn only on new payload
    function drawTargets() {
        octx.clearRect(0, 0, W, H);

        var rLeft = RADAR_LEFT   * W;
        var rW    = (RADAR_RIGHT - RADAR_LEFT) * W;
        var rTop  = RADAR_TOP    * H;
        var rH    = (RADAR_BOTTOM - RADAR_TOP) * H;

        return window.fzaFCRIconLayer.drawSymbols(octx, targets, shots, ICON_FRAC * H, function (item) {
            if (!(item.a >= -1 && item.a <= 1 && item.r >= 0 && item.r <= 1)) { return null; }
            return [ rLeft + (item.a * 0.5 + 0.5) * rW, rTop + rH - item.r * rH ];
        });
    }

    function renderLoop() {
        requestAnimationFrame(renderLoop);

        var ow = overlay.offsetWidth  || 512;
        var oh = overlay.offsetHeight || 512;
        if (W !== ow || H !== oh) { resize(); }

        if (fullDirty) {
            if (hasData) { paintPixels(0, W - 1); }
            ctx.putImageData(imgData, 0, 0);
        } else if (dirtyColMin >= 0) {
            // Repaint only the x-band spanned by the newly received columns (±1 px margin)
            var rLeft  = RADAR_LEFT  * W;
            var rW     = (RADAR_RIGHT - RADAR_LEFT) * W;
            var stepD  = (params.halfFov * 2) / params.aziSteps;
            var azFrom = -params.halfFov + dirtyColMin * stepD;
            var azTo   = -params.halfFov + (dirtyColMax + 1) * stepD;
            var bx0    = Math.max(0,     Math.floor(rLeft + ((azFrom + 45) / 90) * rW) - 1);
            var bx1    = Math.min(W - 1, Math.ceil (rLeft + ((azTo   + 45) / 90) * rW) + 1);
            paintPixels(bx0, bx1);
            var yTop = Math.max(0, Math.floor(RADAR_TOP * H));
            var yH   = Math.min(H, Math.ceil(RADAR_BOTTOM * H) + 1) - yTop;
            ctx.putImageData(imgData, 0, 0, bx0, yTop, bx1 - bx0 + 1, yH);
        }
        fullDirty   = false;
        dirtyColMin = -1;
        dirtyColMax = -1;

        if (targetsDirty) {
            // Stay dirty until every sprite has finished its async decode
            targetsDirty = !drawTargets();
        }
    }

    window.fzaFCRRmap = {
        update: function (data) {
            if (!data || !ctx) { return; }

            // A different sector or grid size invalidates every stored column
            var regrid = false;
            if (data.halfFov   !== undefined && data.halfFov   !== params.halfFov)   { params.halfFov   = data.halfFov;   regrid = true; }
            if (data.aziSteps  !== undefined && data.aziSteps  !== params.aziSteps)  { params.aziSteps  = data.aziSteps;  regrid = true; }
            if (data.nearSteps !== undefined && data.nearSteps !== params.nearSteps) { params.nearSteps = data.nearSteps; regrid = true; }
            if (data.farSteps  !== undefined && data.farSteps  !== params.farSteps)  { params.farSteps  = data.farSteps;  regrid = true; }
            if (regrid || data.hardClear) { clearGrid(); }

            // Video underlay toggle — grid kept, only canvas visibility changes
            if (data.video !== undefined && data.video !== params.video) {
                params.video = data.video;
                canvas.style.visibility = params.video ? "visible" : "hidden";
            }

            if (data.columns) {
                for (var c = 0; c < data.columns.length; c++) {
                    var col = data.columns[c];
                    if (!col || !(col.i >= 0 && col.i < params.aziSteps)) { continue; }
                    if (col.near) {
                        nearGrid[col.i] = decodeColumn(col.d, params.nearSteps);
                    } else {
                        farGrid[col.i]  = decodeColumn(col.d, params.farSteps);
                    }
                    markCol(col.i);
                    hasData = true;
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
