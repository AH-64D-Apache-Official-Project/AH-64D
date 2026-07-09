// Shared FCR icon sprite layer — decodes the build-time _fcrIconData atlas, multiply-tints (mirrors ctrlSetTextColor: dark detail like the MOVE dot survives)
(function () {
    "use strict";

    var DEFAULT_TINT = "#ffff00";           // MPD yellow
    var sprites = {}; // (key + "|" + tint) -> { canvas, ready }

    function makeSprite(cacheKey, key, tint) {
        var entry = { canvas: null, ready: false };
        sprites[cacheKey] = entry;
        var uri = (typeof _fcrIconData !== "undefined") ? _fcrIconData[key] : null;
        if (!uri) { return entry; }
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
        img.src = uri;
        return entry;
    }

    window.fzaFCRIconLayer = {
        // Draw sprite centered at (x, y); returns false while still decoding (caller retries)
        draw: function (ctx, key, x, y, sizePx, alpha, color) {
            if (!key) { return true; } // empty overlay key — nothing to draw
            var tint = color || DEFAULT_TINT;
            var cacheKey = key + "|" + tint;
            var s = sprites[cacheKey] || makeSprite(cacheKey, key, tint);
            if (!s.ready) { return false; }
            var prev = ctx.globalAlpha;
            ctx.globalAlpha = (alpha === undefined) ? 1 : alpha;
            ctx.drawImage(s.canvas, x - sizePx / 2, y - sizePx / 2, sizePx, sizePx);
            ctx.globalAlpha = prev;
            return true;
        }
    };
}());
