// Shared FCR icon sprite layer — decodes the build-time _fcrIconData atlas, multiply-tints (mirrors ctrlSetTextColor: dark detail like the MOVE dot survives)
(function () {
    "use strict";

    var DEFAULT_TINT = "#ffff00";           // MPD yellow
    var SHOT_TINT    = "#00ff80";           // MPD green
    var sprites = {}; // (key + "|" + tint) -> { canvas, ready, failed }

    function makeSprite(cacheKey, key, tint) {
        var entry = { canvas: null, ready: false, failed: false };
        sprites[cacheKey] = entry;
        var uri = (typeof _fcrIconData !== "undefined") ? _fcrIconData[key] : null;
        // Not in the atlas: nothing will ever decode, so don't keep the caller waiting
        if (!uri) { entry.failed = true; return entry; }
        var img = new Image();
        img.onload = function () {
            var c = document.createElement("canvas");
            c.width  = img.width;
            c.height = img.height;
            var g = c.getContext("2d");
            g.drawImage(img, 0, 0);
            // Multiply the tint, then restore the alpha the multiply flattened
            g.globalCompositeOperation = "multiply";
            g.fillStyle = tint;
            g.fillRect(0, 0, c.width, c.height);
            g.globalCompositeOperation = "destination-in";
            g.drawImage(img, 0, 0);
            entry.canvas = c;
            entry.ready  = true;
        };
        img.onerror = function () { entry.failed = true; };
        img.src = uri;
        return entry;
    }

    // Draw sprite centered at (x, y), dimmed to brightness (1 full); returns false while still decoding (caller retries).
    // Dimmed by brightness, not transparency, so a dim symbol looks the same over the page, the video or a black circle.
    function draw(ctx, key, x, y, sizePx, brightness, color) {
        if (!key) { return true; } // empty overlay key — nothing to draw
        var tint = color || DEFAULT_TINT;
        var cacheKey = key + "|" + tint;
        var s = sprites[cacheKey] || makeSprite(cacheKey, key, tint);
        if (s.failed) { return true; }
        if (!s.ready) { return false; }
        var dim = brightness !== undefined && brightness < 1;
        if (dim) { ctx.filter = "brightness(" + Math.round(brightness * 100) + "%)"; }
        ctx.drawImage(s.canvas, x - sizePx / 2, y - sizePx / 2, sizePx, sizePx);
        if (dim) { ctx.filter = "none"; }
        return true;
    }

    // One picture of targets and shot-at markers. toXY(item) returns [x, y] in canvas px, or null to skip the item.
    // Shot-at markers with o 0 draw under the targets, o 1 over them.
    function drawSymbols(ctx, targets, shots, sizePx, toXY) {
        var allDrawn = true;
        var i, p;

        function drawShots(overlayPass) {
            for (var j = 0; j < shots.length; j++) {
                var s = shots[j];
                if (!s || (s.o === 1) !== overlayPass) { continue; }
                var sp = toXY(s);
                if (!sp) { continue; }
                if (!draw(ctx, "shotat", sp[0], sp[1], sizePx, 1, SHOT_TINT)) { allDrawn = false; }
            }
        }

        drawShots(false);
        for (i = 0; i < targets.length; i++) {
            var t = targets[i];
            if (!t) { continue; }
            p = toXY(t);
            if (!p) { continue; }
            var brightness = t.stale ? 0.5 : 1;
            if (!draw(ctx, t.icon, p[0], p[1], sizePx, brightness)) { allDrawn = false; }
            if (t.ov) {
                if (!draw(ctx, t.ov, p[0], p[1], sizePx, brightness)) { allDrawn = false; }
            }
            // Merged with an RFI emitter: its type characters over the ADU symbol's apex
            if (t.ml || t.mr) {
                ctx.save();
                ctx.font = (sizePx * 0.26).toFixed(1) + "px BMKApacheFont, monospace";
                ctx.textBaseline = "middle";
                ctx.fillStyle = brightness < 1 ? "#808000" : DEFAULT_TINT;
                ctx.textAlign = "right";
                if (t.ml) { ctx.fillText(t.ml, p[0] + (0.45 - 0.5) * sizePx, p[1] + (0.28 - 0.5) * sizePx); }
                ctx.textAlign = "left";
                if (t.mr) { ctx.fillText(t.mr, p[0] + (0.55 - 0.5) * sizePx, p[1] + (0.28 - 0.5) * sizePx); }
                ctx.restore();
            }
        }
        drawShots(true);
        return allDrawn;
    }

    // RFI threat symbols as the ASE page and TSD draw them, on the icon textures' 128 px grid
    // (tools/generate_rfi_icons.py, fza_mpd_fnc_rfiIdent). Fine: the characters at the triangle's upper left and right,
    // one alone at its upper right with the triangle moved left; coarse: together in the middle; the frame fitted.
    // An item: {x, y} centre in canvas px, l and r its characters, g "" / "fine" / "solid", fm "" / "box" / "home" /
    // "dash" / "fill" (inverse video: the rest drawn black over it), c a colour key (fza_mpd_fnc_rfiSymbol)
    var RFI_COLOURS = { Y: "#ffff00", YD: "#8c8c00", K: "#000000" };
    // Frame left, top, right, bottom, homeplate sides' foot, point
    var RFI_FRAMES = {
        f2: [17, 17, 111, 103, 100, 122],
        f1: [26, 17, 106, 103, 100, 122],
        c2: [35, 44, 93, 84, 78, 98],
        c1: [47, 44, 81, 84, 78, 98]
    };
    var RFI_TRIANGLES = {
        f2: [[64, 49], [90, 96], [38, 96]],
        f1: [[58, 49], [84, 96], [32, 96]]
    };
    // [character "l" / "r", x, y, align]
    var RFI_TEXTS = {
        f2: [["l", 0.135, 0.33, "left"], ["r", 0.865, 0.33, "right"]],
        f1: [["one", 0.826, 0.33, "right"]],
        c2: [["l", 0.484, 0.5, "right"], ["r", 0.516, 0.5, "left"]],
        c1: [["one", 0.5, 0.5, "center"]]
    };

    function rfiPath(ctx, pts, x, y, size) {
        ctx.beginPath();
        for (var i = 0; i < pts.length; i++) {
            var px = x + (pts[i][0] / 128 - 0.5) * size;
            var py = y + (pts[i][1] / 128 - 0.5) * size;
            if (i) { ctx.lineTo(px, py); } else { ctx.moveTo(px, py); }
        }
        ctx.closePath();
    }

    // tune: [size, text height, characters in] (fza_mpd_fnc_threatSymbolTune)
    function drawRfi(ctx, items, size, tune) {
        tune = Array.isArray(tune) ? tune : [];
        var textScale = (+tune[1] > 0) ? +tune[1] : 1;
        var inset = isFinite(+tune[2]) ? +tune[2] : 0;
        size *= (+tune[0] > 0) ? +tune[0] : 1;
        ctx.save();
        ctx.lineWidth    = Math.max(1, size * 4 / 128);
        ctx.lineJoin     = "round";
        ctx.textBaseline = "middle";
        ctx.font         = (size * 0.26 * textScale).toFixed(1) + "px BMKApacheFont, monospace";
        for (var i = 0; i < items.length; i++) {
            var it = items[i];
            if (!it || !isFinite(it.x) || !isFinite(it.y)) { continue; }
            var colour = RFI_COLOURS[it.c] || RFI_COLOURS.Y;
            var fg = colour;
            var fine = it.g === "fine" || it.g === "solid";
            var single = !it.l || !it.r;
            var layout = (fine ? "f" : "c") + (single ? "1" : "2");
            var f = RFI_FRAMES[layout];
            var box = [[f[0], f[1]], [f[2], f[1]], [f[2], f[3]], [f[0], f[3]]];
            var home = [[f[0], f[1]], [f[2], f[1]], [f[2], f[4]], [(f[0] + f[2]) / 2, f[5]], [f[0], f[4]]];

            ctx.setLineDash([]);
            ctx.strokeStyle = colour;
            if (it.fm === "fill") {
                ctx.fillStyle = colour;
                rfiPath(ctx, home, it.x, it.y, size);
                ctx.fill();
                fg = RFI_COLOURS.K;
            } else if (it.fm === "home" || it.fm === "dash") {
                if (it.fm === "dash") { ctx.setLineDash([size * 12 / 128, size * 8 / 128]); }
                rfiPath(ctx, home, it.x, it.y, size);
                ctx.stroke();
                ctx.setLineDash([]);
            } else if (it.fm === "box") {
                rfiPath(ctx, box, it.x, it.y, size);
                ctx.stroke();
            }
            if (fine) {
                rfiPath(ctx, RFI_TRIANGLES[layout], it.x, it.y, size);
                if (it.g === "solid") {
                    ctx.fillStyle = fg;
                    ctx.fill();
                } else {
                    ctx.strokeStyle = fg;
                    ctx.stroke();
                }
            }
            ctx.fillStyle = fg;
            var texts = RFI_TEXTS[layout];
            for (var k = 0; k < texts.length; k++) {
                var t = texts[k];
                var chars = t[0] === "one" ? (it.r || it.l) : it[t[0]];
                if (!chars) { continue; }
                ctx.textAlign = t[3];
                var dx = Math.abs(t[1] - 0.5) > 0.25 ? (t[1] < 0.5 ? inset : -inset) : 0;
                ctx.fillText(chars, it.x + (t[1] + dx - 0.5) * size, it.y + (t[2] - 0.5) * size);
            }
        }
        ctx.restore();
    }

    window.fzaFCRIconLayer = { draw: draw, drawSymbols: drawSymbols, drawRfi: drawRfi };
}());
