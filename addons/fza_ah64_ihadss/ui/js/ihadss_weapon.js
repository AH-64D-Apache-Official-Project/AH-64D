// Weapon symbology format, weapon symbols and C-scope
(function () {
    "use strict";

    var IH = window.IH;
    var weapon = IH.weapon = {};

    weapon.drawFormat = function (ctx, m) {
        IH.font(ctx, 15);
        var L = IH.layout;
        if (m.sensor) { IH.text(ctx, m.sensor, 116 + L.topLeft[0], 115 + L.topLeft[1], "left"); }
        if (IH.isNum(m.tas)) { IH.text(ctx, m.tas.toFixed(0), 250, 432 + L.bottom, "right"); }
        if (IH.isNum(m.radAlt)) { IH.text(ctx, m.radAlt.toFixed(0), 433, 432 + L.bottom, "right"); }
        if (m.hd) {
            drawFovBrackets(ctx, m.fovNext);
            if (m.lmc) { drawLmc(ctx); }
            if (m.laser) { drawLaser(ctx); }
        }
    };

    // Corner marks around the area the next narrower FOV will show
    function drawFovBrackets(ctx, frac) {
        if (!IH.isNum(frac) || frac <= 0 || frac >= 1) { return; }
        var hw = IH.W * frac / 2;
        var hh = IH.H * frac / 2;
        var len = Math.min(17, hh);
        ctx.beginPath();
        [[-1, -1], [1, -1], [1, 1], [-1, 1]].forEach(function (s) {
            var x = IH.CX + s[0] * hw;
            var y = IH.CY + s[1] * hh;
            ctx.moveTo(x - s[0] * len, y); ctx.lineTo(x, y); ctx.lineTo(x, y - s[1] * len);
        });
        ctx.stroke();
    }

    // LMC marks
    function drawLmc(ctx) {
        ctx.beginPath();
        ctx.moveTo(IH.CX - 53, IH.CY - 5); ctx.lineTo(IH.CX - 53, IH.CY + 5);
        ctx.moveTo(IH.CX + 53, IH.CY - 5); ctx.lineTo(IH.CX + 53, IH.CY + 5);
        ctx.moveTo(IH.CX - 5, IH.CY - 27); ctx.lineTo(IH.CX + 5, IH.CY - 27);
        ctx.moveTo(IH.CX - 5, IH.CY + 27); ctx.lineTo(IH.CX + 5, IH.CY + 27);
        ctx.stroke();
    }

    function drawLaser(ctx) {
        ctx.beginPath();
        [[-1, -1], [1, -1], [1, 1], [-1, 1]].forEach(function (s) {
            ctx.moveTo(IH.CX + s[0] * 14, IH.CY + s[1] * 14);
            ctx.lineTo(IH.CX + s[0] * 42, IH.CY + s[1] * 42);
        });
        ctx.stroke();
    }

    weapon.drawSymbols = function (ctx, m) {
        if (m.msl) { drawConstraintsBox(ctx, m.msl); }
    };

    // Dashed when inhibited, centre gap when stowed; bars 100 units apart; drawn about the origin into textures
    weapon.drawRocketCursor = function (ctx, inhibited, stowed) {
        var half = 45;
        ctx.beginPath();
        [-half - 5, half + 5].forEach(function (y) {
            if (inhibited) {
                IH.dashTo(ctx, -23, y, -5, y, 6, 6);
                IH.dashTo(ctx, 23, y, 5, y, 6, 6);
            } else {
                ctx.moveTo(-23, y); ctx.lineTo(-5, y);
                ctx.moveTo(23, y); ctx.lineTo(5, y);
            }
        });
        var gap = stowed ? 12 : 0;
        if (inhibited) {
            IH.dashTo(ctx, 0, -half, 0, -gap, 14, 5);
            IH.dashTo(ctx, 0, half, 0, gap, 14, 5);
        } else {
            ctx.moveTo(0, -half); ctx.lineTo(0, -gap);
            ctx.moveTo(0, half); ctx.lineTo(0, gap);
        }
        ctx.stroke();
    };

    // Offset scaled so the LOS reticle is inside the box exactly when in constraints
    function drawConstraintsBox(ctx, msl) {
        var h = msl[2] ? 50 : 13;
        var allow = msl[4] > 0 ? msl[4] : 7.5;
        var p = IH.edgeLimit(IH.CX + msl[0] / allow * h, IH.CY - msl[1] / allow * h);
        ctx.beginPath();
        var corners = [[-h, -h], [h, -h], [h, h], [-h, h], [-h, -h]];
        for (var i = 0; i < 4; i++) {
            var a = corners[i];
            var b = corners[i + 1];
            if (msl[3]) {
                ctx.moveTo(p[0] + a[0], p[1] + a[1]);
                ctx.lineTo(p[0] + b[0], p[1] + b[1]);
            } else {
                IH.dashTo(ctx, p[0] + a[0], p[1] + a[1], p[0] + b[0], p[1] + b[1], msl[2] ? 16 : 5, 4);
            }
        }
        ctx.stroke();
    }
})();
