// FCR TPM terrain profile — SQF pushes fzaFCRTpm.update({halfFov, aziSteps, rangeSteps, hardClear, columns, obstacles})
// A column is {i, d}: d holds one clearance-level digit (0-3) per range cell.
(function () {
    "use strict";

    // Clearance levels: 0=safe/black, 1=risk/dark, 2=shadow/grey, 3=hazard/white
    var LEVEL_GREY = [0, 85, 170, 255];

    var MIN_RANGE_M = 100;
    var MAX_RANGE_M = 2500;
    var DEG = Math.PI / 180;

    var canvas, ctx, W, H;
    var overlay, octx;
    var OX, OY, SCALE;

    // Native MPD icons are 0.09 of display height; the browser covers 0.95 of it
    var ICON_FRAC = 0.09 / 0.95;

    var terrainGrid = [];     // per azimuth column: Uint8Array(rangeSteps), or null while unscanned
    var imgData     = null;   // persistent pixel buffer, reallocated only on resize

    // Per-pixel polar lookup grouped by azimuth column. The atan2/sqrt work is done once per
    // geometry, so a new column only repaints the pixels that belong to it and its neighbour.
    var geo       = null;
    var geoDirty  = true;
    var fullDirty = true;
    var dirtyMin  = -1;
    var dirtyMax  = -1;

    var obstacles      = [];
    var obstaclesDirty = false;

    var params = {
        halfFov:    90,
        aziSteps:   120,
        rangeSteps: 150
    };

    function resetBuffer() {
        if (!ctx) { return; }
        imgData = ctx.createImageData(W, H);
        var px = imgData.data;
        for (var i = 3; i < px.length; i += 4) { px[i] = 255; } // opaque black
    }

    function clearGrid() {
        terrainGrid = new Array(params.aziSteps).fill(null);
        fullDirty   = true;
    }

    // Digit string (or plain array) -> fixed-length levels, so the paint loop never reads a hole
    function decodeColumn(d, steps) {
        var out = new Uint8Array(steps);
        if (!d) { return out; }
        var isStr = (typeof d === "string");
        var n = Math.min(steps, d.length);
        for (var k = 0; k < n; k++) {
            var v = isStr ? (d.charCodeAt(k) - 48) : (d[k] | 0);
            out[k] = v < 0 ? 0 : (v > 3 ? 3 : v);
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
        W = canvas.width  = canvas.offsetWidth  || 512;
        H = canvas.height = canvas.offsetHeight || 512;
        overlay.width  = W;
        overlay.height = H;
        OX    = W / 2;
        OY    = H * 0.890;  // HPP ownship y=0.870 mapped to canvas
        SCALE = (H * 0.6316) / MAX_RANGE_M;
        geoDirty       = true;
        obstaclesDirty = true;
    }

    // Sector pixels sorted by azimuth column: start[ai]..start[ai+1] index px/ri/af/rf; box holds each column's pixel bounds
    function buildGeometry() {
        var halfFov    = params.halfFov;
        var aziSteps   = params.aziSteps;
        var rangeSteps = params.rangeSteps;
        var aziStepD   = (halfFov * 2) / aziSteps;
        var rangeStepM = MAX_RANGE_M / rangeSteps;
        var minR2      = MIN_RANGE_M * SCALE;
        var maxR       = MAX_RANGE_M * SCALE;
        var maxR2      = maxR * maxR;
        minR2 *= minR2;

        var x0 = Math.max(0, Math.floor(OX - maxR));
        var x1 = Math.min(W - 1, Math.ceil(OX + maxR));
        var y0 = Math.max(0, Math.floor(OY - maxR));
        var y1 = Math.min(H - 1, Math.ceil(OY + maxR));
        var bw = Math.max(0, x1 - x0 + 1);
        var bh = Math.max(0, y1 - y0 + 1);

        var colOf  = new Int16Array(bw * bh);
        var counts = new Int32Array(aziSteps);
        var x, y, dx, dy, r2, bearDeg, ai, n;

        for (y = y0; y <= y1; y++) {
            dy = y - OY; // canvas Y relative to ownship (positive = down = behind)
            n  = (y - y0) * bw;
            for (x = x0; x <= x1; x++, n++) {
                dx = x - OX;
                r2 = dx * dx + dy * dy;
                colOf[n] = -1;
                if (r2 < minR2 || r2 > maxR2) { continue; } // inside 100m ring or beyond max
                bearDeg = Math.atan2(dx, -dy) / DEG;
                if (bearDeg < -halfFov || bearDeg > halfFov) { continue; } // outside FOV
                ai = Math.floor((bearDeg + halfFov) / aziStepD);
                if (ai < 0) { ai = 0; }
                if (ai >= aziSteps) { ai = aziSteps - 1; }
                colOf[n] = ai;
                counts[ai]++;
            }
        }

        var start = new Int32Array(aziSteps + 1);
        for (ai = 0; ai < aziSteps; ai++) { start[ai + 1] = start[ai] + counts[ai]; }
        var total = start[aziSteps];

        var px   = new Int32Array(total);
        var ri   = new Uint16Array(total);
        var af   = new Float32Array(total);
        var rf   = new Float32Array(total);
        var box  = new Int32Array(aziSteps * 4);
        var next = new Int32Array(aziSteps);
        for (ai = 0; ai < aziSteps; ai++) {
            box[ai * 4] = W; box[ai * 4 + 1] = H; box[ai * 4 + 2] = -1; box[ai * 4 + 3] = -1;
        }

        for (y = y0; y <= y1; y++) {
            dy = y - OY;
            n  = (y - y0) * bw;
            for (x = x0; x <= x1; x++, n++) {
                ai = colOf[n];
                if (ai < 0) { continue; }
                dx = x - OX;
                bearDeg = Math.atan2(dx, -dy) / DEG;
                var rangeM = Math.sqrt(dx * dx + dy * dy) / SCALE;
                var r = Math.floor(rangeM / rangeStepM);
                if (r < 0) { r = 0; }
                if (r >= rangeSteps) { r = rangeSteps - 1; }

                var k = start[ai] + next[ai]++;
                px[k] = y * W + x;
                ri[k] = r;
                af[k] = (bearDeg + halfFov) / aziStepD - ai;
                rf[k] = rangeM / rangeStepM - r;

                var b = ai * 4;
                if (x < box[b])     { box[b]     = x; }
                if (y < box[b + 1]) { box[b + 1] = y; }
                if (x > box[b + 2]) { box[b + 2] = x; }
                if (y > box[b + 3]) { box[b + 3] = y; }
            }
        }

        geo = { aziSteps: aziSteps, rangeSteps: rangeSteps, start: start, px: px, ri: ri, af: af, rf: rf, box: box };
    }

    // Bilinear fill of the pixels owned by azimuth columns aFrom..aTo; unscanned columns paint black
    function paintColumns(aFrom, aTo) {
        var aziSteps   = geo.aziSteps;
        var rangeSteps = geo.rangeSteps;
        var data  = imgData.data;
        var start = geo.start, gpx = geo.px, gri = geo.ri, gaf = geo.af, grf = geo.rf;
        var k, end, o;

        for (var ai = aFrom; ai <= aTo; ai++) {
            var col = terrainGrid[ai];
            k   = start[ai];
            end = start[ai + 1];
            if (!col) {
                for (; k < end; k++) {
                    o = gpx[k] * 4;
                    data[o] = 0; data[o + 1] = 0; data[o + 2] = 0;
                }
                continue;
            }
            var col1 = terrainGrid[ai + 1 < aziSteps ? ai + 1 : ai] || col;
            for (; k < end; k++) {
                var r   = gri[k];
                var r1  = r + 1 < rangeSteps ? r + 1 : r;
                var a   = gaf[k];
                var top = col[r]  + (col1[r]  - col[r])  * a;
                var bot = col[r1] + (col1[r1] - col[r1]) * a;
                var lv  = Math.round(top + (bot - top) * grf[k]);
                if (lv < 0) { lv = 0; }
                if (lv > 3) { lv = 3; }
                var g = LEVEL_GREY[lv];
                o = gpx[k] * 4;
                data[o] = g; data[o + 1] = g; data[o + 2] = g;
            }
        }
    }

    // Obstacle symbols — all-at-once picture, static until the next snapshot
    function drawObstacles() {
        octx.clearRect(0, 0, W, H);
        var sizePx   = ICON_FRAC * H;
        var allDrawn = true;
        for (var i = 0; i < obstacles.length; i++) {
            var o = obstacles[i];
            if (!o || !(o.r >= 0 && o.r <= 1)) { continue; }
            var rM = o.r * MAX_RANGE_M;
            var x  = OX + Math.sin(o.a * DEG) * rM * SCALE;
            var y  = OY - Math.cos(o.a * DEG) * rM * SCALE;
            if (!window.fzaFCRIconLayer.draw(octx, "fcrobstacle", x, y, sizePx, 1)) { allDrawn = false; }
        }
        return allDrawn;
    }

    function renderLoop() {
        requestAnimationFrame(renderLoop);

        var ow = canvas.offsetWidth  || 512;
        var oh = canvas.offsetHeight || 512;
        if (W !== ow || H !== oh) { resize(); }

        if (obstaclesDirty) {
            // Stay dirty until the sprite has finished its async decode
            obstaclesDirty = !drawObstacles();
        }

        if (geoDirty) {
            buildGeometry();
            resetBuffer(); // old sector pixels must not linger outside the new geometry
            geoDirty  = false;
            fullDirty = true;
        }

        var last = geo.aziSteps - 1;
        if (fullDirty) {
            paintColumns(0, last);
            ctx.putImageData(imgData, 0, 0);
        } else if (dirtyMin >= 0) {
            // A column also feeds the interpolation of the one before it
            var a0 = Math.max(0, dirtyMin - 1);
            var a1 = Math.min(last, dirtyMax);
            if (a0 <= a1) {
                paintColumns(a0, a1);
                var bx0 = W, by0 = H, bx1 = -1, by1 = -1;
                for (var ai = a0; ai <= a1; ai++) {
                    var b = ai * 4;
                    if (geo.box[b + 2] < 0) { continue; }
                    if (geo.box[b]     < bx0) { bx0 = geo.box[b]; }
                    if (geo.box[b + 1] < by0) { by0 = geo.box[b + 1]; }
                    if (geo.box[b + 2] > bx1) { bx1 = geo.box[b + 2]; }
                    if (geo.box[b + 3] > by1) { by1 = geo.box[b + 3]; }
                }
                if (bx1 >= bx0 && by1 >= by0) {
                    ctx.putImageData(imgData, 0, 0, bx0, by0, bx1 - bx0 + 1, by1 - by0 + 1);
                }
            }
        }
        fullDirty = false;
        dirtyMin  = -1;
        dirtyMax  = -1;
    }

    window.fzaFCRTpm = {
        update: function (data) {
            if (!data || !ctx) { return; }

            var newHalf  = (data.halfFov    !== undefined) ? data.halfFov    : params.halfFov;
            var newAzi   = (data.aziSteps   !== undefined) ? data.aziSteps   : params.aziSteps;
            var newRange = (data.rangeSteps !== undefined) ? data.rangeSteps : params.rangeSteps;

            if (newHalf !== params.halfFov || newAzi !== params.aziSteps || newRange !== params.rangeSteps) {
                // Sector change: columns keep their bearing when the angular step is unchanged, so
                // the scanned picture stays put instead of sliding to the new sector's bearings
                var newGrid  = new Array(newAzi).fill(null);
                var oldStepD = (params.halfFov * 2) / params.aziSteps;
                var newStepD = (newHalf * 2) / newAzi;
                if (newRange === params.rangeSteps && Math.abs(oldStepD - newStepD) < 1e-6) {
                    var shift = Math.round((newHalf - params.halfFov) / newStepD);
                    for (var i = 0; i < terrainGrid.length; i++) {
                        var j = i + shift;
                        if (j >= 0 && j < newAzi && terrainGrid[i]) { newGrid[j] = terrainGrid[i]; }
                    }
                }
                terrainGrid       = newGrid;
                params.halfFov    = newHalf;
                params.aziSteps   = newAzi;
                params.rangeSteps = newRange;
                geoDirty          = true;
            }

            if (data.hardClear) {
                clearGrid();
                obstacles      = [];
                obstaclesDirty = true;
            }

            if (data.columns) {
                for (var c = 0; c < data.columns.length; c++) {
                    var col = data.columns[c];
                    if (!col || !(col.i >= 0 && col.i < params.aziSteps)) { continue; }
                    terrainGrid[col.i] = decodeColumn(col.d, params.rangeSteps);
                    if (dirtyMin < 0 || col.i < dirtyMin) { dirtyMin = col.i; }
                    if (col.i > dirtyMax) { dirtyMax = col.i; }
                }
            }

            // Replaces the whole picture; SQF sends it on each new snapshot and as a periodic refresh
            if (data.obstacles !== undefined) {
                obstacles      = data.obstacles || [];
                obstaclesDirty = true;
            }
        }
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
}());
