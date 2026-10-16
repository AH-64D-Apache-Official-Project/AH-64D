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

    // Draw sprite centered at (x, y); returns false while still decoding (caller retries)
    function draw(ctx, key, x, y, sizePx, alpha, color) {
        if (!key) { return true; } // empty overlay key — nothing to draw
        var tint = color || DEFAULT_TINT;
        var cacheKey = key + "|" + tint;
        var s = sprites[cacheKey] || makeSprite(cacheKey, key, tint);
        if (s.failed) { return true; }
        if (!s.ready) { return false; }
        var prev = ctx.globalAlpha;
        ctx.globalAlpha = (alpha === undefined) ? 1 : alpha;
        ctx.drawImage(s.canvas, x - sizePx / 2, y - sizePx / 2, sizePx, sizePx);
        ctx.globalAlpha = prev;
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
            var alpha = t.stale ? 0.5 : 1;
            if (!draw(ctx, t.icon, p[0], p[1], sizePx, alpha)) { allDrawn = false; }
            if (t.ov) {
                if (!draw(ctx, t.ov, p[0], p[1], sizePx, alpha)) { allDrawn = false; }
            }
        }
        drawShots(true);
        return allDrawn;
    }

    window.fzaFCRIconLayer = { draw: draw, drawSymbols: drawSymbols };
}());
