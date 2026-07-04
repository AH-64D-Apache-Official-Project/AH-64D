(function () {
    "use strict";

    // Level 0=shadow, 1–4 = increasing radar return strength
    var LEVEL_RGB = [
        [0,   0,   0  ],
        [85,  85,  85 ],
        [148, 148, 148],
        [200, 200, 200],
        [255, 255, 255]
    ];

    var MAX_RANGE_M  = 8000;
    var NEAR_MAX_M   = 4000;
    var RADAR_LEFT   = 0.1632;
    var RADAR_RIGHT  = 0.8368;
    var RADAR_TOP    = 0.1316;
    var RADAR_BOTTOM = 0.8947;

    var canvas, ctx, W, H;

    var nearGrid = [];
    var farGrid  = [];
    var hasData  = false;

    var params = {
        halfFov:   45,
        aziSteps:  120,
        nearSteps: 80,
        farSteps:  80
    };

    function clearGrid(aziSteps) {
        nearGrid = new Array(aziSteps).fill(null);
        farGrid  = new Array(aziSteps).fill(null);
        hasData  = false;
    }

    function init() {
        canvas = document.getElementById("canvas");
        ctx    = canvas.getContext("2d");
        clearGrid(params.aziSteps);
        resize();
        window.addEventListener("resize", resize);
        requestAnimationFrame(renderLoop);
    }

    function resize() {
        W = canvas.width  = canvas.offsetWidth  || 512;
        H = canvas.height = canvas.offsetHeight || 512;
    }

    // B-scope pixel fill — bottom=near (0m), top=far (8000m)
    function drawTerrain() {
        if (!hasData) { return; }

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

        var imgData = ctx.createImageData(W, H);
        var px      = imgData.data;

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

            for (var x = 0; x < W; x++) {
                if (x < rLeft || x > rRight) { continue; }

                var aziFrac = (x - rLeft) / rW;
                var aziDeg  = (aziFrac - 0.5) * halfFov * 2;
                var ai      = Math.floor((aziDeg + halfFov) / aziStepD);
                if (ai < 0)         { ai = 0; }
                if (ai >= aziSteps) { ai = aziSteps - 1; }

                var col = isNear ? nearGrid[ai] : farGrid[ai];
                if (!col) { continue; }

                var lv  = col[ri];
                if (lv < 0) { lv = 0; }
                if (lv > 4) { lv = 4; }
                var c   = LEVEL_RGB[lv];
                var idx = (y * W + x) * 4;
                px[idx    ] = c[0];
                px[idx + 1] = c[1];
                px[idx + 2] = c[2];
                px[idx + 3] = 255;
            }
        }

        ctx.putImageData(imgData, 0, 0);
    }

    function renderLoop() {
        requestAnimationFrame(renderLoop);

        var ow = canvas.offsetWidth  || 512;
        var oh = canvas.offsetHeight || 512;
        if (W !== ow || H !== oh) { resize(); }

        ctx.clearRect(0, 0, W, H);
        ctx.fillStyle = "#000000";
        ctx.fillRect(0, 0, W, H);

        if (hasData) { drawTerrain(); }
    }

    window.fzaFCRRmap = {
        update: function (data) {
            if (data.halfFov    !== undefined) { params.halfFov    = data.halfFov;    }
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
                }
                hasData = true;
            }
        }
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
}());
