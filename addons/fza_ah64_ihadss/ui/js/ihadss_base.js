// Symbols common to the flight and weapon formats
(function () {
    "use strict";

    var IH = window.IH;
    var base = IH.base = {};

    var TAPE_LABELS = { 0: "N", 30: "3", 60: "6", 90: "E", 120: "12", 150: "15", 180: "S", 210: "21", 240: "24", 270: "W", 300: "30", 330: "33" };

    base.drawFlightLos = function (ctx, bold) {
        ctx.save();
        if (bold) { ctx.lineWidth = 4; }
        ctx.beginPath();
        ctx.moveTo(IH.CX, IH.CY - 10); ctx.lineTo(IH.CX, IH.CY - 28);
        ctx.moveTo(IH.CX, IH.CY + 10); ctx.lineTo(IH.CX, IH.CY + 28);
        ctx.moveTo(IH.CX - 10, IH.CY); ctx.lineTo(IH.CX - 28, IH.CY);
        ctx.moveTo(IH.CX + 10, IH.CY); ctx.lineTo(IH.CX + 28, IH.CY);
        ctx.stroke();
        ctx.restore();
    };

    base.drawTadsLos = function (ctx) {
        ctx.beginPath();
        ctx.moveTo(IH.CX, IH.CY - 27); ctx.lineTo(IH.CX, IH.CY - 10);
        ctx.moveTo(IH.CX, IH.CY + 10); ctx.lineTo(IH.CX, IH.CY + 27);
        ctx.moveTo(IH.CX - 53, IH.CY); ctx.lineTo(IH.CX - 10, IH.CY);
        ctx.moveTo(IH.CX + 10, IH.CY); ctx.lineTo(IH.CX + 53, IH.CY);
        ctx.stroke();
    };

    // A dot per quadrant needing correction, none within 4 deg
    base.drawCueingDots = function (ctx, acq, tadsReticle) {
        if (!acq) { return; }
        var az = acq[0];
        var el = acq[1];
        var dx = tadsReticle ? 58 : 33;
        var dy = 33;
        ctx.beginPath();
        if (az > 4)  { ctx.moveTo(IH.CX + dx + 3, IH.CY); ctx.arc(IH.CX + dx, IH.CY, 3, 0, 2 * Math.PI); }
        if (az < -4) { ctx.moveTo(IH.CX - dx + 3, IH.CY); ctx.arc(IH.CX - dx, IH.CY, 3, 0, 2 * Math.PI); }
        if (el > 4)  { ctx.moveTo(IH.CX + 3, IH.CY - dy); ctx.arc(IH.CX, IH.CY - dy, 3, 0, 2 * Math.PI); }
        if (el < -4) { ctx.moveTo(IH.CX + 3, IH.CY + dy); ctx.arc(IH.CX, IH.CY + dy, 3, 0, 2 * Math.PI); }
        ctx.fill();
    };

    base.drawHeadTracker = function (ctx, pos) {
        if (!pos) { return; }
        ctx.save();
        ctx.translate(pos[0], pos[1]);
        ctx.beginPath();
        for (var i = 0; i < 4; i++) {
            ctx.moveTo(-8, 18);
            ctx.lineTo(0, 26);
            ctx.lineTo(8, 18);
            ctx.rotate(0.5 * Math.PI);
        }
        ctx.stroke();
        ctx.restore();
    };

    // Dashed crosshair on the selected acquisition source
    base.drawCuedLos = function (ctx, pos) {
        if (!pos) { return; }
        ctx.save();
        ctx.translate(pos[0], pos[1]);
        ctx.beginPath();
        for (var i = 0; i < 4; i++) {
            ctx.moveTo(0, 9); ctx.lineTo(0, 15);
            ctx.moveTo(0, 21); ctx.lineTo(0, 27);
            ctx.rotate(0.5 * Math.PI);
        }
        ctx.stroke();
        ctx.restore();
    };

    base.drawHeadingTape = function (ctx, m) {
        if (!IH.isNum(m.hdg)) { return; }
        var y = IH.TAPE_Y;
        var hdg = m.hdg;

        IH.font(ctx, 15);
        ctx.beginPath();
        var first = Math.ceil((hdg - IH.TAPE_HALF_DEG) / 10) * 10;
        for (var t = first; t <= hdg + IH.TAPE_HALF_DEG; t += 10) {
            var x = IH.CX + (t - hdg) * IH.TAPE_PX_PER_DEG;
            var norm = ((t % 360) + 360) % 360;
            var major = norm % 30 === 0;
            var h = major ? 5 : 3;
            ctx.moveTo(x, y - h);
            ctx.lineTo(x, y + h);
            if (major) { IH.text(ctx, TAPE_LABELS[norm], x, y - 7, "center", "bottom"); }
        }
        ctx.stroke();

        var hdgText = String(Math.round(hdg) % 360).padStart(3, "0");
        IH.font(ctx, 18);
        var w = ctx.measureText(hdgText).width + 10;
        ctx.clearRect(IH.CX - w / 2, 40, w, 20);
        IH.text(ctx, hdgText, IH.CX, 60, "center", "bottom");

        // Lubber line
        ctx.fillRect(IH.CX - 2, 73, 4, 23);

        var cmdX = IH.isNum(m.cmdHdg) ? IH.tapeX(m.cmdHdg, true) : null;
        if (cmdX !== null) {
            ctx.beginPath();
            ctx.moveTo(cmdX - 6, 89); ctx.lineTo(cmdX, 76); ctx.lineTo(cmdX + 6, 89);
            ctx.stroke();
        }

        var altX = IH.isNum(m.altBrg) ? IH.tapeX(m.altBrg, true) : null;
        if (altX !== null) {
            ctx.beginPath();
            ctx.moveTo(altX - 4, 87); ctx.lineTo(altX, 78); ctx.lineTo(altX + 4, 87);
            ctx.closePath();
            ctx.fill();
        }

        var fcrX = IH.isNum(m.fcrBrg) ? IH.tapeX(m.fcrBrg, false) : null;
        if (fcrX !== null) {
            ctx.beginPath();
            ctx.moveTo(fcrX - 1, 73); ctx.lineTo(fcrX - 1, 79); ctx.lineTo(fcrX - 4, 79);
            ctx.lineTo(fcrX - 6, 76); ctx.lineTo(fcrX - 4, 73); ctx.closePath();
            ctx.moveTo(fcrX + 1, 73); ctx.lineTo(fcrX + 1, 79); ctx.lineTo(fcrX + 4, 79);
            ctx.lineTo(fcrX + 6, 76); ctx.lineTo(fcrX + 4, 73); ctx.closePath();
            ctx.fill();
        }
    };

    // Field of regard geometry
    var FOR_TOP = 433;
    var FOR_ZERO = 448;
    var FOR_BOTTOM = 477;
    var FOR = {
        pnvs: { halfW: 58, azMax: 90, elMax: 20, elMin: -45, azTicks: [0] },
        tads: { halfW: 62, azMax: 120, elMax: 30, elMin: -60, azTicks: [-90, 0, 90] }
    };

    function forPoint(f, az, el) {
        var x = IH.CX + IH.clamp(az, -f.azMax, f.azMax) / f.azMax * f.halfW;
        var e = IH.clamp(el, f.elMin, f.elMax);
        var y = e >= 0 ? FOR_ZERO - e / f.elMax * (FOR_ZERO - FOR_TOP) : FOR_ZERO + e / f.elMin * (FOR_BOTTOM - FOR_ZERO);
        return [x, y];
    }

    base.drawFieldOfRegard = function (ctx, m) {
        var f = FOR[m.forType] || FOR.pnvs;
        var left = IH.CX - f.halfW;
        var right = IH.CX + f.halfW;

        ctx.strokeRect(left, FOR_TOP, f.halfW * 2, FOR_BOTTOM - FOR_TOP);
        ctx.beginPath();
        ctx.moveTo(left + 1, FOR_ZERO); ctx.lineTo(left + 8, FOR_ZERO);
        ctx.moveTo(right - 1, FOR_ZERO); ctx.lineTo(right - 8, FOR_ZERO);
        f.azTicks.forEach(function (az) {
            var x = IH.CX + az / f.azMax * f.halfW;
            ctx.moveTo(x, FOR_TOP); ctx.lineTo(x, FOR_TOP + 7);
            ctx.moveTo(x, FOR_BOTTOM); ctx.lineTo(x, FOR_BOTTOM - 7);
        });
        ctx.stroke();

        ctx.save();
        ctx.beginPath();
        ctx.rect(left, FOR_TOP, f.halfW * 2, FOR_BOTTOM - FOR_TOP);
        ctx.clip();

        if (IH.isNum(m.fcrCur)) {
            var cx = forPoint(f, m.fcrCur, 0)[0];
            ctx.beginPath();
            ctx.moveTo(cx, FOR_TOP); ctx.lineTo(cx, FOR_BOTTOM);
            ctx.stroke();
        }
        if (IH.isNum(m.fcrLast)) {
            var lx = forPoint(f, m.fcrLast, 0)[0];
            ctx.beginPath();
            IH.dashTo(ctx, lx, FOR_TOP, lx, FOR_BOTTOM, 4, 3);
            ctx.stroke();
        }
        if (m.forCue) {
            var c = forPoint(f, m.forCue[0], m.forCue[1]);
            ctx.beginPath();
            ctx.arc(c[0], c[1], 2, 0, 2 * Math.PI);
            ctx.fill();
        }
        ctx.restore();

        // 40x30 deg box, edge limited to the field of regard
        if (m.forFov) {
            var w = 40 / f.azMax * f.halfW;
            var h = 15 / f.elMax * (FOR_ZERO - FOR_TOP) + 15 / -f.elMin * (FOR_BOTTOM - FOR_ZERO);
            var p = forPoint(f, m.forFov[0], m.forFov[1]);
            var bx = IH.clamp(p[0] - w / 2, left, right - w);
            var by = IH.clamp(p[1] - h / 2, FOR_TOP, FOR_BOTTOM - h);
            ctx.strokeRect(bx, by, w, h);
        }
    };

    // Seven HAD status fields along the bottom of the format
    base.drawHad = function (ctx, m) {
        var had = m.had;
        if (!had) { return; }
        var L = IH.layout;
        var left = L.hadLeft;
        var right = L.hadRight;
        var y = L.bottom;
        IH.font(ctx, 15);
        IH.text(ctx, had[0], 100 + left, 452 + y, "left");
        IH.text(ctx, had[1], 252 + left, 452 + y, "right");
        IH.text(ctx, had[2], 392 + right, 452 + y, "left");
        IH.text(ctx, had[3], 540 + right, 452 + y, "right");
        IH.text(ctx, had[4], 100 + left, 472 + y, "left");
        IH.text(ctx, had[5], 392 + right, 472 + y, "left");
        IH.text(ctx, had[6], IH.CX, 412 + y, "center");
        IH.text(ctx, had[7], IH.CX, 395 + y, "center");
    };
})();
