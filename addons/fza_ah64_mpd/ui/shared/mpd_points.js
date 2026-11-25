// Points on the HTML MPD pages (TSD, ASE) as fza_mpd_fnc_uiDrawPoint draws them natively: textures from the icon atlas
// tinted as ctrlSetTextColor does, their text in the MPD font, from fza_mpd_fnc_htmlPoints.
//   var layer = fzaMpdPoints.create({ctx, X, Y, L, pxPerUnit, atlas, onLoad}), X/Y/L mapping MPD units to canvas
//     pixels, pxPerUnit() the canvas pixels across one MPD unit, onLoad called as a texture finishes loading
//   layer.draw(p, def, pos, chosen, cur): false while a texture is still loading
//   layer.resetFont(): after the canvas is resized, which resets its font
// A point is [ident, 1 world or 0 MPD position, x, y, text A, text B, ID type, ID number, bold 1/0], its def
// [texture, texture 2, size, colour, place A, place B] with a place [x, y, "left|center|right", "top|center|bottom",
// text height multiplier] or 0, pos its place on the MPD, cur the cursor's [x, y] while chosen.
(function () {
    "use strict";

    // A point's text height is this over its icon size (fza_mpd_fnc_uiDrawPoint)
    var TEXT_SCALE = 0.00208;
    // BMKApacheFont's ascent and ascent plus descent over its em: the game's text cell is the ascent plus descent high
    var FONT_ASC = 0.754, FONT_CELL = 0.924;
    // Round the point the cursor is on: a black circle (MPD_CURSOR_POINT_CIRCLE) and the cursor's spokes
    var HL_RADIUS = 0.022, SPOKES_SIZE = 0.125, SPOKES_COLOUR = [0.6, 1, 0, 1];
    var STAND_IN_WIDTH = 0.004;
    // Bold: the texture drawn again this many pixels to each side, the text outlined by this much of its pixel height
    var BOLD_PX = 1, BOLD_TEXT = 0.1;

    function arr(v) { return Array.isArray(v) ? v : []; }
    function rgba(c) {
        c = arr(c);
        var ch = function (v) { return Math.round(Math.max(0, Math.min(1, +v || 0)) * 255); };
        return "rgba(" + ch(c[0]) + "," + ch(c[1]) + "," + ch(c[2]) + "," + (c.length > 3 ? Math.max(0, Math.min(1, +c[3])) : 1) + ")";
    }

    function create(o) {
        var ctx = o.ctx, X = o.X, Y = o.Y, L = o.L, atlas = o.atlas, onLoad = o.onLoad || function () {};
        var sprites = {};
        var lastFont = "";

        // A texture tinted as ctrlSetTextColor does: multiplied, its alpha kept
        function sprite(key, colour) {
            var tint = rgba([colour[0], colour[1], colour[2], 1]);
            var id = key + "|" + tint;
            var s = sprites[id];
            if (s) { return s; }
            s = sprites[id] = {canvas: null, ready: false, missing: false};
            var uri = atlas ? atlas[key] : null;
            if (!uri) { s.missing = true; return s; }
            var img = new Image();
            img.onload = function () {
                var c = document.createElement("canvas");
                c.width = img.width;
                c.height = img.height;
                var g = c.getContext("2d");
                g.drawImage(img, 0, 0);
                g.globalCompositeOperation = "multiply";
                g.fillStyle = tint;
                g.fillRect(0, 0, c.width, c.height);
                g.globalCompositeOperation = "destination-in";
                g.drawImage(img, 0, 0);
                s.canvas = c;
                s.ready = true;
                onLoad();
            };
            img.onerror = function () { s.missing = true; onLoad(); };
            img.src = uri;
            return s;
        }

        // Draws a texture over [left, top, size], bold drawn again to each side; false while it is still loading
        function drawTexture(key, colour, left, top, size, bold) {
            if (!key) { return true; }
            var s = sprite(key, colour);
            if (s.missing) { return true; }
            if (!s.ready) { return false; }
            ctx.globalAlpha = colour.length > 3 ? Math.max(0, Math.min(1, +colour[3])) : 1;
            if (bold) {
                [[-BOLD_PX, 0], [BOLD_PX, 0], [0, -BOLD_PX], [0, BOLD_PX]].forEach(function (d) {
                    ctx.drawImage(s.canvas, X(left) + d[0], Y(top) + d[1], L(size), L(size));
                });
            }
            ctx.drawImage(s.canvas, X(left), Y(top), L(size), L(size));
            ctx.globalAlpha = 1;
            return true;
        }

        // A texture the page has no copy of (a mission's own icon): a diamond in its colour
        function drawStandIn(colour, x, y, size) {
            var r = L(size) * 0.25;
            ctx.beginPath();
            ctx.moveTo(X(x), Y(y) - r);
            ctx.lineTo(X(x) + r, Y(y));
            ctx.lineTo(X(x), Y(y) + r);
            ctx.lineTo(X(x) - r, Y(y));
            ctx.closePath();
            ctx.strokeStyle = rgba(colour);
            ctx.lineWidth = Math.max(1, L(STAND_IN_WIDTH));
            ctx.setLineDash([]);
            ctx.stroke();
        }

        // Setting the font parses it, so only when it changes
        function setFont(px) {
            var font = px.toFixed(2) + "px BMKApacheFont";
            if (font !== lastFont) {
                ctx.font = font;
                lastFont = font;
            }
        }

        // A text's place: anchored at its offset in the icon, by its alignment, the cell's middle at the anchor. Its width
        // is only measured for the black under the chosen point's text.
        function textLayout(text, place, left, top, size, measure) {
            if (!Array.isArray(place) || (typeof text !== "string" && typeof text !== "number") || text === "") { return null; }
            text = String(text);
            // A threat symbol's place carries its text's tuned height (fza_mpd_fnc_threatSymbolTune)
            var h = TEXT_SCALE / size * ((+place[4] > 0) ? +place[4] : 1);
            var yOffset = place[3] === "top" ? h * 0.5 : place[3] === "bottom" ? -h * 0.5 : 0;
            var x = left + (+place[0] || 0) * size;
            var mid = top + (+place[1] || 0) * size + yOffset;
            var align = place[2] === "right" || place[2] === "center" ? place[2] : "left";
            var px = L(h) / FONT_CELL;
            if (!(px > 0) || !isFinite(px)) { return null; }
            var width = 0;
            if (measure) {
                setFont(px);
                width = ctx.measureText(text).width / o.pxPerUnit();
            }
            var textLeft = x - width * (align === "right" ? 1 : align === "center" ? 0.5 : 0);
            return {text: text, x: x, mid: mid, h: h, px: px, align: align, left: textLeft, width: width};
        }

        function drawText(t, colour, bold) {
            setFont(t.px);
            ctx.textAlign = t.align;
            ctx.textBaseline = "alphabetic";
            ctx.fillStyle = rgba(colour);
            var x = X(t.x), y = Y(t.mid - t.h * 0.5) + t.px * FONT_ASC;
            if (bold) {
                ctx.strokeStyle = ctx.fillStyle;
                ctx.lineWidth = t.px * BOLD_TEXT;
                ctx.lineJoin = "round";
                ctx.setLineDash([]);
                ctx.strokeText(t.text, x, y);
            }
            ctx.fillText(t.text, x, y);
        }

        function draw(p, d, pos, chosen, cur) {
            if (!Array.isArray(d)) { return true; }
            var size = +d[2];
            if (!(size > 0) || !isFinite(size)) { return true; }
            var colour = d[3];
            if (!Array.isArray(colour) || colour.length < 3 || !colour.every(function (v) { return isFinite(+v); })) { return true; }
            if (!pos) { return true; }
            var bold = +p[8] === 1;
            var left = pos[0] - size * 0.5, top = pos[1] - size * 0.5;
            var tA = textLayout(p[4], d[4], left, top, size, chosen);
            var tB = textLayout(p[5], d[5], left, top, size, chosen);
            var ready = true;

            // Over the cursor: its spokes where it is, a black circle under the point, black under its text
            if (chosen) {
                cur = arr(cur);
                var cx = cur.length > 1 ? +cur[0] : pos[0], cy = cur.length > 1 ? +cur[1] : pos[1];
                ready = drawTexture("spokes", SPOKES_COLOUR, cx - SPOKES_SIZE * 0.5, cy - SPOKES_SIZE * 0.5, SPOKES_SIZE, false) && ready;
                ctx.fillStyle = "#000";
                ctx.beginPath();
                ctx.arc(X(pos[0]), Y(pos[1]), L(HL_RADIUS), 0, 2 * Math.PI);
                ctx.fill();
                [tA, tB].forEach(function (t) {
                    if (!t || t.width <= 0) { return; }
                    ctx.fillRect(X(t.left - 0.002), Y(t.mid - 0.6 * t.h), L(t.width + 0.004), L(1.2 * t.h));
                });
            }

            var key = String(d[0] || "");
            if (key && atlas && !atlas[key]) {
                drawStandIn(colour, pos[0], pos[1], size);
            } else {
                ready = drawTexture(key, colour, left, top, size, bold) && ready;
            }
            ready = drawTexture(String(d[1] || ""), colour, left, top, size, bold) && ready;
            if (tA) { drawText(tA, colour, bold); }
            if (tB) { drawText(tB, colour, bold); }
            return ready;
        }

        return {
            draw: draw,
            resetFont: function () { lastFont = ""; }
        };
    }

    window.fzaMpdPoints = {create: create, rgba: rgba};
}());
