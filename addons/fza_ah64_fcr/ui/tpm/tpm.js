(function () {
    "use strict";

    // TM §4.41.3 clearance levels: 0=safe/black, 1=risk/dark, 2=shadow/grey, 3=hazard/white
    var LEVEL_RGB = [
        [0,   0,   0  ],
        [85,  85,  85 ],
        [170, 170, 170],
        [255, 255, 255]
    ];


    var MIN_RANGE_M = 100;
    var MAX_RANGE_M = 2500;
    var DEG = Math.PI / 180;

    var canvas, ctx, W, H;
    var OX, OY, SCALE;

    var terrainGrid = [];
    var hasData     = false;
    var dirty       = true;   // repaint only when data/geometry changed — not every RAF tick
    var imgData     = null;   // persistent pixel buffer, reallocated only on resize

    var params = {
        halfFov:    90,
        aziSteps:   72,
        rangeSteps: 50,
        profMode:   0,
        linesOption: 4,
        clearanceFt: 50
    };

    function resetBuffer() {
        if (!ctx) { return; }
        imgData = ctx.createImageData(W, H);
        var px = imgData.data;
        for (var i = 3; i < px.length; i += 4) { px[i] = 255; } // opaque black
    }

    function clearGrid(aziSteps) {
        terrainGrid = new Array(aziSteps).fill(null);
        hasData     = false;
        resetBuffer();
        dirty       = true;
    }

    function init() {
        canvas = document.getElementById("canvas");
        ctx    = canvas.getContext("2d");
        resize();
        clearGrid(params.aziSteps);
        window.addEventListener("resize", resize);
        requestAnimationFrame(renderLoop);
    }

    function resize() {
        W = canvas.width  = canvas.offsetWidth  || 512;
        H = canvas.height = canvas.offsetHeight || 512;
        OX    = W / 2;
        OY    = H * 0.890;  // HPP ownship y=0.870 mapped to canvas
        SCALE = (H * 0.6316) / MAX_RANGE_M;
        resetBuffer();
        dirty = true;
    }


    // Polar pixel fill into the persistent buffer; unscanned wedges stay black.
    function drawTerrain() {
        var halfFov    = params.halfFov;
        var aziSteps   = params.aziSteps;
        var rangeSteps = params.rangeSteps;
        var aziStepD   = (halfFov * 2) / aziSteps;
        var rangeStepM = MAX_RANGE_M / rangeSteps;
        var minR2      = MIN_RANGE_M * SCALE;
        var maxR2      = MAX_RANGE_M * SCALE;
        minR2 *= minR2;
        maxR2 *= maxR2;

        var px = imgData.data;

        for (var y = 0; y < H; y++) {
            var dy = y - OY; // canvas Y relative to ownship (positive = down = behind)
            for (var x = 0; x < W; x++) {
                var dx  = x - OX; // canvas X relative to ownship
                var r2  = dx * dx + dy * dy;
                if (r2 < minR2 || r2 > maxR2) { continue; } // inside 100m ring or beyond max

                var bearDeg = Math.atan2(dx, -dy) / DEG;
                if (bearDeg < -halfFov || bearDeg > halfFov) { continue; } // outside FOV

                var ai = Math.floor((bearDeg + halfFov) / aziStepD);
                if (ai < 0) { ai = 0; }
                if (ai >= aziSteps) { ai = aziSteps - 1; }
                var col = terrainGrid[ai];
                if (!col) { continue; } // unscanned — leave black

                var rangeM = Math.sqrt(r2) / SCALE;
                var ri     = Math.floor(rangeM / rangeStepM);
                if (ri < 0) { ri = 0; }
                if (ri >= rangeSteps) { ri = rangeSteps - 1; }

                var aiFrac = (bearDeg + halfFov) / aziStepD - ai;
                var riFrac = rangeM / rangeStepM - ri;

                var ai1  = ai + 1 < aziSteps  ? ai + 1 : ai;
                var ri1  = ri + 1 < rangeSteps ? ri + 1 : ri;
                var col1 = terrainGrid[ai1] || col;

                var v00 = col[ri];  var v10 = col1[ri];
                var v01 = col[ri1]; var v11 = col1[ri1];

                var top = v00 + (v10 - v00) * aiFrac;
                var bot = v01 + (v11 - v01) * aiFrac;
                var val = top + (bot - top) * riFrac;

                var lv = Math.round(val);
                if (lv < 0) { lv = 0; }
                if (lv > 3) { lv = 3; }
                var c = LEVEL_RGB[lv];
                var i = (y * W + x) * 4;
                px[i    ] = c[0];
                px[i + 1] = c[1];
                px[i + 2] = c[2];
                px[i + 3] = 255;
            }
        }
    }


    function renderLoop() {
        requestAnimationFrame(renderLoop);

        var ow = canvas.offsetWidth  || 512;
        var oh = canvas.offsetHeight || 512;
        if (W !== ow || H !== oh) { resize(); }

        if (!dirty) { return; }
        dirty = false;

        if (hasData) { drawTerrain(); }
        ctx.putImageData(imgData, 0, 0);
    }

    window.fzaFCRTpm = {
        update: function (data) {
            if (data.halfFov !== undefined && data.halfFov !== params.halfFov) {
                params.halfFov = data.halfFov;
                resetBuffer(); // geometry remap — old sector pixels must not linger
                dirty = true;
            }
            if (data.aziSteps   !== undefined) { params.aziSteps   = data.aziSteps;   }
            if (data.rangeSteps !== undefined) { params.rangeSteps = data.rangeSteps; }
            if (data.profMode   !== undefined) { params.profMode   = data.profMode;   }
            if (data.linesOption !== undefined){ params.linesOption = data.linesOption;}
            if (data.clearanceFt !== undefined){ params.clearanceFt = data.clearanceFt;}

            if (data.hardClear) {
                clearGrid(params.aziSteps);
            }
            // FOV change: resize to new column count, existing data stays visible until overwritten
            if (data.fovChange) {
                while (terrainGrid.length < params.aziSteps) { terrainGrid.push(null); }
                if (terrainGrid.length > params.aziSteps) { terrainGrid.length = params.aziSteps; }
                dirty = true;
            }

            if (data.columns) {
                for (var c = 0; c < data.columns.length; c++) {
                    terrainGrid[data.columns[c].i] = data.columns[c].d;
                }
                hasData = true;
                dirty   = true;
            }
        }
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
}());
