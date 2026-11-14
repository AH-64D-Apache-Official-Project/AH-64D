// FCR RMAP B-scope picture, for the RMAP page and the MPD's FCR video underlay (fcr_video_layer.js).
// fzaFCRRmapView(canvas, overlay, opts) draws the terrain video on canvas and, with an overlay, the target symbols.
// update({halfFov, aziSteps, nearSteps, farSteps, hardClear, video, tint, targets, shots, hover, columns, zoom})
// A column is {i, near, d}: d holds one return-level digit (0-6) per range cell.
// zoom: [centreX, centreY, ratio, view half size] in MPD units, the browser covering 0.025 to 0.975, or null.
// opts.scale(): the canvas resolution over its size on the page, default 1.
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

    window.fzaFCRRmapView = function (canvas, overlay, opts) {
        var ctx  = canvas.getContext("2d");
        var octx = overlay ? overlay.getContext("2d") : null;
        // Measured on the overlay: it is never hidden, the video canvas can be
        var sizer = overlay || canvas;
        var scaleOf = (opts && opts.scale) || function () { return 1; };
        var W, H;

        // The target the MPD cursor is on, or -1
        var hover = -1;

        var nearGrid = [];   // per azimuth column: Uint8Array(nearSteps), or null while unscanned
        var farGrid  = [];
        var hasData  = false;

        var targets      = [];
        var shots        = [];
        var targetsDirty = false;

        // Full repaints only on clear/resize/geometry change/tint, else just the dirty column x-band
        var fullDirty   = true;
        var dirtyColMin = -1;
        var dirtyColMax = -1;
        var imgData     = null;  // persistent pixel buffer, reallocated only on resize

        // Each level's colour: the grey times the tint
        var palR = LEVEL_GREY.slice(), palG = LEVEL_GREY.slice(), palB = LEVEL_GREY.slice();
        var tint = [1, 1, 1];

        var params = {
            halfFov:   45,
            aziSteps:  300,
            nearSteps: 150,
            farSteps:  150,
            video:     true
        };

        // Display zoom, and the canvas mapping it gives (zoomMapFor), or null
        var zoom    = null;
        var zoomMap = null;

        function validZoom(z) {
            if (!Array.isArray(z) || z.length !== 4) { return null; }
            for (var i = 0; i < 4; i++) { if (typeof z[i] !== "number" || !isFinite(z[i])) { return null; } }
            return (z[2] > 0 && z[3] > 0) ? z : null;
        }

        // A zoomed canvas pixel x shows the picture at ax * x + bx, inside the zoomed square x0..x1, y0..y1
        function zoomMapFor() {
            if (!zoom) { return null; }
            var k = zoom[2];
            return {
                ax: 1 / k, bx: W * (zoom[0] - 0.025 - 0.475 / k) / 0.95,
                ay: 1 / k, by: H * (zoom[1] - 0.025 - 0.475 / k) / 0.95,
                x0: (0.5 - zoom[3] - 0.025) / 0.95 * W, x1: (0.5 + zoom[3] - 0.025) / 0.95 * W,
                y0: (0.5 - zoom[3] - 0.025) / 0.95 * H, y1: (0.5 + zoom[3] - 0.025) / 0.95 * H
            };
        }

        // The canvas area the radar picture covers: its B-scope, or, zoomed, the part of the square it fills
        function pictureClip() {
            var c = [RADAR_LEFT * W, RADAR_RIGHT * W, RADAR_TOP * H, RADAR_BOTTOM * H];
            var m = zoomMap;
            if (!m) { return c; }
            return [Math.max(m.x0, (c[0] - m.bx) / m.ax), Math.min(m.x1, (c[1] - m.bx) / m.ax),
                    Math.max(m.y0, (c[2] - m.by) / m.ay), Math.min(m.y1, (c[3] - m.by) / m.ay)];
        }

        function setTint(t) {
            if (!Array.isArray(t) || t.length !== 3) { return; }
            if (t[0] === tint[0] && t[1] === tint[1] && t[2] === tint[2]) { return; }
            for (var c = 0; c < 3; c++) {
                var v = +t[c];
                tint[c] = (v >= 0 && v <= 1) ? v : 1;
            }
            for (var i = 0; i < LEVEL_GREY.length; i++) {
                palR[i] = Math.round(LEVEL_GREY[i] * tint[0]);
                palG[i] = Math.round(LEVEL_GREY[i] * tint[1]);
                palB[i] = Math.round(LEVEL_GREY[i] * tint[2]);
            }
            fullDirty = true;
        }

        function markCol(i) {
            if (dirtyColMin < 0 || i < dirtyColMin) { dirtyColMin = i; }
            if (i > dirtyColMax) { dirtyColMax = i; }
        }

        function resetBuffer() {
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

        function sizeW() { return Math.round((sizer.offsetWidth  || 512) * scaleOf()) || 512; }
        function sizeH() { return Math.round((sizer.offsetHeight || 512) * scaleOf()) || 512; }

        function resize() {
            W = canvas.width  = sizeW();
            H = canvas.height = sizeH();
            if (overlay) {
                overlay.width  = W;
                overlay.height = H;
            }
            zoomMap = zoomMapFor();
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

            var clip = pictureClip();
            var m  = zoomMap;
            var ax = m ? m.ax : 1, bx = m ? m.bx : 0;
            var ay = m ? m.ay : 1, by = m ? m.by : 0;

            if (xFrom < clip[0]) { xFrom = Math.ceil(clip[0]);  }
            if (xTo   > clip[1]) { xTo   = Math.floor(clip[1]); }

            var px = imgData.data;

            for (var y = 0; y < H; y++) {
                if (y < clip[2] || y > clip[3]) { continue; }

                var rangeM   = ((rBottom - (ay * y + by)) / rH) * MAX_RANGE_M;
                var isNear   = rangeM < NEAR_MAX_M;
                var stepM    = isNear ? nearStepM : farStepM;
                var localM   = isNear ? rangeM : rangeM - NEAR_MAX_M;
                var maxSteps = isNear ? nearSteps : farSteps;

                var ri = Math.floor(localM / stepM);
                if (ri < 0)         { ri = 0; }
                if (ri >= maxSteps) { ri = maxSteps - 1; }

                var rowIdx = y * W * 4;
                for (var x = xFrom; x <= xTo; x++) {
                    var aziFrac = ((ax * x + bx) - rLeft) / rW;
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
                    var idx = rowIdx + x * 4;
                    px[idx    ] = palR[lv];
                    px[idx + 1] = palG[lv];
                    px[idx + 2] = palB[lv];
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

            var m = zoomMap;
            // The zoomed format's border, in white, its symbols inside it
            if (m) {
                octx.strokeStyle = "#fff";
                octx.lineWidth = Math.max(1, 0.006 * H);
                octx.strokeRect(m.x0, m.y0, m.x1 - m.x0, m.y1 - m.y0);
            }
            var toXY = function (item) {
                if (!(item.a >= -1 && item.a <= 1 && item.r >= 0 && item.r <= 1)) { return null; }
                var p = [ rLeft + (item.a * 0.5 + 0.5) * rW, rTop + rH - item.r * rH ];
                if (m) {
                    p = [ (p[0] - m.bx) / m.ax, (p[1] - m.by) / m.ay ];
                    if (p[0] < m.x0 || p[0] > m.x1 || p[1] < m.y0 || p[1] > m.y1) { return null; }
                }
                return p;
            };
            // The target the MPD cursor is on, over a black circle in the cursor's centre (MPD_CURSOR_POINT_CIRCLE)
            var hovered = targets[hover] ? toXY(targets[hover]) : null;
            if (hovered) {
                octx.fillStyle = "#000";
                octx.beginPath();
                octx.arc(hovered[0], hovered[1], 0.022 / 0.95 * H, 0, 2 * Math.PI);
                octx.fill();
            }
            return window.fzaFCRIconLayer.drawSymbols(octx, targets, shots, ICON_FRAC * H, toXY);
        }

        function renderLoop() {
            requestAnimationFrame(renderLoop);

            if (W !== sizeW() || H !== sizeH()) { resize(); }

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
                var sx0    = rLeft + ((azFrom + 45) / 90) * rW;
                var sx1    = rLeft + ((azTo   + 45) / 90) * rW;
                if (zoomMap) {
                    sx0 = (sx0 - zoomMap.bx) / zoomMap.ax;
                    sx1 = (sx1 - zoomMap.bx) / zoomMap.ax;
                }
                var clip = pictureClip();
                var bx0  = Math.max(0,     Math.floor(sx0) - 1);
                var bx1  = Math.min(W - 1, Math.ceil (sx1) + 1);
                var yTop = Math.max(0, Math.floor(clip[2]));
                var yH   = Math.min(H, Math.ceil(clip[3]) + 1) - yTop;
                if (bx1 >= bx0 && yH > 0) {
                    paintPixels(bx0, bx1);
                    ctx.putImageData(imgData, 0, 0, bx0, yTop, bx1 - bx0 + 1, yH);
                }
            }
            fullDirty   = false;
            dirtyColMin = -1;
            dirtyColMax = -1;

            if (targetsDirty && octx) {
                // Stay dirty until every sprite has finished its async decode
                targetsDirty = !drawTargets();
            }
        }

        resize();
        clearGrid();
        window.addEventListener("resize", resize);
        requestAnimationFrame(renderLoop);

        return {
            update: function (data) {
                if (!data) { return; }

                if (data.hover !== undefined && data.hover !== hover) {
                    hover = data.hover;
                    targetsDirty = true;
                }

                if (data.tint !== undefined) { setTint(data.tint); }

                if (data.zoom !== undefined) {
                    var z = validZoom(data.zoom);
                    if (JSON.stringify(z) !== JSON.stringify(zoom)) {
                        zoom = z;
                        zoomMap = zoomMapFor();
                        resetBuffer();
                        fullDirty    = true;
                        targetsDirty = true;
                    }
                }

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
                    canvas.style.visibility = params.video ? "" : "hidden";
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
    };
}());
