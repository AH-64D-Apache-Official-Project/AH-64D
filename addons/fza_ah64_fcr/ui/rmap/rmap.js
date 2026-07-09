(function () {
    "use strict";

    // Level 0=shadow, 1–6 = increasing radar return strength
    var LEVEL_RGB = [
        [0,   0,   0  ],
        [42,  42,  42 ],
        [85,  85,  85 ],
        [128, 128, 128],
        [170, 170, 170],
        [212, 212, 212],
        [255, 255, 255]
    ];

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

    var nearGrid = [];
    var farGrid  = [];
    var hasData  = false;

    var targets      = [];
    var shots        = [];
    var targetsDirty = false;

    // Full repaints only on clear/resize/FOV change, else just the dirty column x-band
    var fullDirty   = true;
    var dirtyColMin = -1;
    var dirtyColMax = -1;
    var imgData     = null;  // persistent pixel buffer, reallocated only on resize

    var params = {
        halfFov:   45,
        aziSteps:  120,
        nearSteps: 80,
        farSteps:  80,
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

    function clearGrid(aziSteps) {
        nearGrid  = new Array(aziSteps).fill(null);
        farGrid   = new Array(aziSteps).fill(null);
        hasData   = false;
        resetBuffer();
        fullDirty = true;
    }

    function init() {
        canvas  = document.getElementById("canvas");
        ctx     = canvas.getContext("2d");
        overlay = document.getElementById("overlay");
        octx    = overlay.getContext("2d");
        resize();
        clearGrid(params.aziSteps);
        window.addEventListener("resize", resize);
        requestAnimationFrame(renderLoop);
    }

    function resize() {
        W = canvas.width  = canvas.offsetWidth  || 512;
        H = canvas.height = canvas.offsetHeight || 512;
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
                var aziDeg  = (aziFrac - 0.5) * halfFov * 2;
                var ai      = Math.floor((aziDeg + halfFov) / aziStepD);
                if (ai < 0)         { ai = 0; }
                if (ai >= aziSteps) { ai = aziSteps - 1; }

                var col = isNear ? nearGrid[ai] : farGrid[ai];
                if (!col) { continue; }

                var lv = col[ri];
                // Blend across near/far boundary to remove hard seam
                if (isNear && ri === nearSteps - 1) {
                    var farCol = farGrid[ai];
                    if (farCol) { lv = lv * 0.5 + farCol[0] * 0.5; }
                } else if (!isNear && ri === 0) {
                    var nearCol = nearGrid[ai];
                    if (nearCol) { lv = lv * 0.5 + nearCol[nearSteps - 1] * 0.5; }
                }
                lv = Math.round(lv);
                if (lv < 0) { lv = 0; }
                if (lv > 6) { lv = 6; }
                var c   = LEVEL_RGB[lv];
                var idx = rowIdx + x * 4;
                px[idx    ] = c[0];
                px[idx + 1] = c[1];
                px[idx + 2] = c[2];
                px[idx + 3] = 255;
            }
        }
    }

    // Symbols on the overlay canvas above the terrain; redrawn only on new payload
    function drawTargets() {
        octx.clearRect(0, 0, W, H);

        var rLeft   = RADAR_LEFT   * W;
        var rW      = (RADAR_RIGHT - RADAR_LEFT) * W;
        var rTop    = RADAR_TOP    * H;
        var rH      = (RADAR_BOTTOM - RADAR_TOP) * H;
        var sizePx  = ICON_FRAC * H;
        var allDrawn = true;

        // Shot-at markers MPD green; TM 4.44.6: o 0 = under targets, 1 = over
        function drawShots(overlayPass) {
            for (var i = 0; i < shots.length; i++) {
                var s = shots[i];
                if ((s.o === 1) !== overlayPass) { continue; }
                if (s.a < -1 || s.a > 1 || s.r < 0 || s.r > 1) { continue; }
                var sx = rLeft + (s.a * 0.5 + 0.5) * rW;
                var sy = rTop + rH - s.r * rH;
                if (!window.fzaFCRIconLayer.draw(octx, "shotat", sx, sy, sizePx, 1, "#00ff80")) { allDrawn = false; }
            }
        }

        drawShots(false);
        for (var i = 0; i < targets.length; i++) {
            var t = targets[i];
            if (t.a < -1 || t.a > 1 || t.r < 0 || t.r > 1) { continue; }
            var x = rLeft + (t.a * 0.5 + 0.5) * rW;
            var y = rTop + rH - t.r * rH;
            var alpha = t.stale ? 0.5 : 1;
            if (!window.fzaFCRIconLayer.draw(octx, t.icon, x, y, sizePx, alpha)) { allDrawn = false; }
            if (t.ov) {
                if (!window.fzaFCRIconLayer.draw(octx, t.ov, x, y, sizePx, alpha)) { allDrawn = false; }
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

        if (fullDirty) {
            if (hasData) { paintPixels(0, W - 1); }
            ctx.putImageData(imgData, 0, 0);
        } else if (dirtyColMin >= 0) {
            // Repaint only the x-band spanned by the newly received columns (±1 px margin)
            var rLeft = RADAR_LEFT  * W;
            var rW    = (RADAR_RIGHT - RADAR_LEFT) * W;
            var bx0   = Math.max(0,     Math.floor(rLeft + (dirtyColMin       / params.aziSteps) * rW) - 1);
            var bx1   = Math.min(W - 1, Math.ceil (rLeft + ((dirtyColMax + 1) / params.aziSteps) * rW) + 1);
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
            if (data.halfFov !== undefined && data.halfFov !== params.halfFov) {
                params.halfFov = data.halfFov;
                fullDirty = true; // azimuth mapping changed — remap everything
            }
            // Video underlay toggle — grid kept, only canvas visibility changes
            if (data.video !== undefined && data.video !== params.video) {
                params.video = data.video;
                canvas.style.display = params.video ? "block" : "none";
            }
            if (data.aziSteps   !== undefined) { params.aziSteps   = data.aziSteps;   }
            if (data.nearSteps  !== undefined) { params.nearSteps  = data.nearSteps;  }
            if (data.farSteps   !== undefined) { params.farSteps   = data.farSteps;   }

            if (data.hardClear) { clearGrid(params.aziSteps); }

            if (data.columns) {
                for (var c = 0; c < data.columns.length; c++) {
                    var col = data.columns[c];
                    if (col.near) {
                        nearGrid[col.i] = col.d;
                    } else {
                        farGrid[col.i]  = col.d;
                    }
                    markCol(col.i);
                }
                hasData = true;
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
