// Flight symbology format and the FLT page symbols
(function () {
    "use strict";

    var IH = window.IH;
    var flight = IH.flight = {};

    var VEL_MIN_KTS = 0.1;
    var ACC_FULL_SCALE_MPS2 = 12;
    var ACC_FROM_TIP_KTS = 6;
    var SCALE_TOP = 104;
    var SCALE_BOTTOM = 347;
    var SCALE_MID = (SCALE_TOP + SCALE_BOTTOM) / 2;
    var RADALT_SCALE_FT = 200;
    var VSI_HALF_FPM = 1000;
    var TRANS_PX_PER_DEG = 4;
    var CRUISE_PX_PER_DEG = 8;
    var DEG = Math.PI / 180;

    var HOLD_DROP_MS = 3000;
    var G_MIN_SHOW_MS = 2000;

    var holds = { att: { on: false, dropped: -Infinity }, alt: { on: false, dropped: -Infinity } };
    var gShownUntil = -Infinity;

    // A hold symbol that drops out flashes for 3 seconds, then is removed
    function holdVisible(state, active) {
        var now = performance.now();
        if (state.on && !active) { state.dropped = now; }
        state.on = !!active;
        if (state.on) { return true; }
        return now - state.dropped < HOLD_DROP_MS && IH.flashOn();
    }

    flight.draw = function (ctx, m) {
        var mode = m.mode;
        var nav = mode === "trans" || mode === "cruise";
        var hover = mode === "hover" || mode === "bobup";

        var L = IH.layout;
        IH.shifted(ctx, L.topLeft[0], L.topLeft[1], function () { drawTopLeft(ctx, m); });
        IH.shifted(ctx, L.airspeed, 0, function () {
            drawAirspeed(ctx, m);
            if (holdVisible(holds.att, m.attHold)) { drawAttHold(ctx); }
        });
        IH.shifted(ctx, L.right, 0, function () {
            drawRightColumn(ctx, m);
            drawVsi(ctx, m);
            drawRadAltScale(ctx, m);
            if (holdVisible(holds.alt, m.altHold)) { drawAltHold(ctx); }
        });
        IH.shifted(ctx, L.waypoint[0], L.waypoint[1], function () { drawWaypoint(ctx, m, nav); });
        IH.shifted(ctx, 0, L.bottom, function () { drawTrimBall(ctx, m); });
        // The velocity vector and acceleration cue reach up to the top of the lubber line, the other moving symbols are
        // cut off just below the heading tape
        clipTop(ctx, IH.lubberTop(), function () {
            if (hover || mode === "trans") { drawVelocityAndAccel(ctx, m); }
        });
        ctx.save();
        ctx.beginPath();
        ctx.rect(-IH.MARGIN, IH.edgeTop(), IH.W + 2 * IH.MARGIN, IH.H + IH.MARGIN - IH.edgeTop());
        ctx.clip();
        if (mode === "bobup") { drawBobUpBox(ctx, m); }
        if (mode === "trans") { drawHorizonLine(ctx, m); }
        if (mode === "cruise") { drawPitchLadder(ctx, m); }
        ctx.restore();
        if (mode === "cruise") { drawBankTriangle(ctx, m); }
    };

    function clipTop(ctx, top, draw) {
        ctx.save();
        ctx.beginPath();
        ctx.rect(-IH.MARGIN, top, IH.W + 2 * IH.MARGIN, IH.H + IH.MARGIN - top);
        ctx.clip();
        draw();
        ctx.restore();
    }

    // Velocity vector full scale: from the LOS reticle to the top of the lubber line
    function velMax() {
        return IH.CY - IH.lubberTop();
    }

    function drawTopLeft(ctx, m) {
        IH.font(ctx, 15);

        if (IH.isNum(m.tq) && (!m.tqSplit || IH.flashOn())) {
            var tq = m.tq.toFixed(0) + "%";
            IH.text(ctx, tq, 129, 115, "left");
            if (m.tq >= 98) {
                ctx.strokeRect(125, 99, ctx.measureText(tq).width + 8, 18);
            }
        }

        if (m.nvsSensor) { IH.text(ctx, m.nvsSensor, 129, 95, "left"); }

        if (IH.isNum(m.tgt)) { IH.text(ctx, m.tgt.toFixed(0) + "C", 174, 132, "right"); }
    }

    function drawAirspeed(ctx, m) {
        IH.font(ctx, 15);
        if (IH.isNum(m.tas)) {
            IH.text(ctx, m.tas.toFixed(0), 129, 232, "right");
            // Boxed with square corners at VNE
            if (IH.isNum(m.vne) && m.vne > 0 && m.tas >= m.vne) { ctx.strokeRect(88, 211, 49, 28); }
        }

        // Shown within 1/4 G of the limit or above 2 G, for at least 2 seconds
        if (IH.isNum(m.g)) {
            var gNear = m.g > 2 || (IH.isNum(m.gLimit) && m.gLimit > 0 && m.g >= m.gLimit - 0.25);
            if (gNear) { gShownUntil = performance.now() + G_MIN_SHOW_MS; }
            if (performance.now() < gShownUntil) {
                IH.requestTick();
                IH.text(ctx, m.g.toFixed(1) + "G", 135, 254, "right");
            }
        }
    }

    function drawRightColumn(ctx, m) {
        IH.font(ctx, 15);
        if (IH.isNum(m.radAlt)) {
            IH.text(ctx, m.radAlt.toFixed(0), 505, 232, "right");
            // A threshold of 0 or less is not presented
            if (IH.isNum(m.radAltHi) && m.radAltHi > 0 && m.radAlt > m.radAltHi) { IH.text(ctx, "HI", 505, 208, "right", "middle"); }
            if (IH.isNum(m.radAltLo) && m.radAltLo > 0 && m.radAlt < m.radAltLo) { IH.text(ctx, "LO", 505, 253, "right", "middle"); }
        }

        if (m.mode === "cruise" && IH.isNum(m.baroAlt)) {
            IH.text(ctx, m.baroAlt.toFixed(0), 513, 108, "right", "middle");
        }

        // Only the descent readout is shown on the HMD
        if (IH.isNum(m.vsi) && m.vsi <= -VSI_HALF_FPM) {
            IH.text(ctx, (Math.round(m.vsi / 100) * 100).toFixed(0), 513, 354, "right", "middle");
        }
    }

    function drawWaypoint(ctx, m, nav) {
        IH.font(ctx, 15);
        if (nav && m.wpt) {
            IH.text(ctx, m.wpt[0], 86, 365, "left");
            if (m.wpt[2] !== "") { IH.text(ctx, m.wpt[2] + "KM", 222, 365, "right"); }
            IH.text(ctx, m.wpt[1], 134, 389, "right");
            IH.text(ctx, m.wpt[3], 215, 389, "right");
        }
    }

    function drawTrimBall(ctx, m) {
        if (!IH.isNum(m.slip)) { return; }
        var left = 257;
        var right = 383;
        var r = 9;
        ctx.beginPath();
        ctx.moveTo(311, 415); ctx.lineTo(311, 433);
        ctx.moveTo(329, 415); ctx.lineTo(329, 433);
        ctx.moveTo(left, 433); ctx.lineTo(right, 433);
        ctx.stroke();
        var x = IH.interp(IH.clamp(m.slip, -1, 1), -1, 1, left + r, right - r);
        ctx.beginPath();
        ctx.arc(x, 424, r, 0, 2 * Math.PI);
        ctx.fill();
    }

    function drawVsi(ctx, m) {
        var x = 533;
        var step = (SCALE_BOTTOM - SCALE_TOP) / 20;
        ctx.beginPath();
        for (var i = 0; i <= 20; i++) {
            var y = SCALE_TOP + i * step;
            if (i % 5 === 0) {
                ctx.moveTo(x - 5, y); ctx.lineTo(x + 5, y);
            } else if (i > 5 && i < 15) {
                ctx.moveTo(x, y); ctx.lineTo(x + 5, y);
            }
        }
        ctx.stroke();

        if (!IH.isNum(m.vsi)) { return; }
        var py = SCALE_MID - IH.clamp(m.vsi, -VSI_HALF_FPM, VSI_HALF_FPM) * (SCALE_MID - SCALE_TOP) / VSI_HALF_FPM;
        var px = 523;
        ctx.beginPath();
        ctx.moveTo(px - 7, py - 8);
        ctx.lineTo(px - 5, py - 8);
        ctx.lineTo(px + 5, py - 1);
        ctx.lineTo(px + 5, py + 1);
        ctx.lineTo(px - 5, py + 8);
        ctx.lineTo(px - 7, py + 8);
        ctx.closePath();
        ctx.fill();
    }

    // Shown below 200 ft
    function drawRadAltScale(ctx, m) {
        if (!IH.isNum(m.radAlt) || m.radAlt >= RADALT_SCALE_FT) { return; }

        var x = 551;
        var step = (SCALE_BOTTOM - SCALE_TOP) / 20;
        var pxPerFt = (SCALE_BOTTOM - SCALE_TOP) / RADALT_SCALE_FT;
        var alt = IH.clamp(m.radAlt, 0, RADALT_SCALE_FT);
        ctx.fillRect(539, SCALE_BOTTOM - alt * pxPerFt, 6, alt * pxPerFt);
        ctx.beginPath();
        for (var i = 0; i <= 20; i++) {
            var y = SCALE_TOP + i * step;
            if (i % 5 === 0) {
                ctx.moveTo(x - 5, y); ctx.lineTo(x + 5, y);
            } else if (i > 15) {
                ctx.moveTo(x - 5, y); ctx.lineTo(x, y);
            }
        }
        ctx.stroke();
    }

    function drawAttHold(ctx) {
        ctx.beginPath();
        ctx.moveTo(94, 214); ctx.lineTo(131, 214); ctx.lineTo(133, 216);
        ctx.lineTo(133, 234); ctx.lineTo(131, 236); ctx.lineTo(94, 236);
        ctx.lineTo(92, 234); ctx.lineTo(92, 216); ctx.closePath();
        ctx.stroke();
    }

    function drawAltHold(ctx) {
        var x = 523;
        var y = SCALE_MID;
        ctx.beginPath();
        ctx.moveTo(x - 10, y - 9); ctx.lineTo(x - 3, y - 9); ctx.lineTo(x + 6, y - 2);
        ctx.lineTo(x + 6, y + 2); ctx.lineTo(x - 3, y + 9); ctx.lineTo(x - 10, y + 9);
        ctx.closePath();
        ctx.stroke();
    }

    // Vector full scale is 6 kt in hover/bob-up and 60 kt in transition
    function drawVelocityAndAccel(ctx, m) {
        if (!m.vel) { return; }
        var fullKts = m.mode === "trans" ? 60 : 6;
        var maxPx = velMax();
        var speed = Math.sqrt(m.vel[0] * m.vel[0] + m.vel[1] * m.vel[1]);
        var still = speed < VEL_MIN_KTS;
        var vx = still ? 0 : m.vel[0] / fullKts * maxPx;
        var vy = still ? 0 : m.vel[1] / fullKts * maxPx;
        var len = Math.sqrt(vx * vx + vy * vy);
        var saturated = len >= maxPx;
        if (saturated) {
            vx *= maxPx / len;
            vy *= maxPx / len;
        }
        var tipX = IH.CX + vx;
        var tipY = IH.CY - vy;

        if (!still) {
            ctx.beginPath();
            ctx.moveTo(IH.CX, IH.CY);
            ctx.lineTo(tipX, tipY);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(tipX, tipY, 2, 0, 2 * Math.PI);
            ctx.fill();
        }

        // From the vector tip in transition; in hover and bob-up from the tip up to 6 kt, from the LOS reticle above that
        if (!m.acc) { return; }
        var fromTip = m.mode === "trans" || speed <= ACC_FROM_TIP_KTS;
        var ox = fromTip ? tipX : IH.CX;
        var oy = fromTip ? tipY : IH.CY;
        var ax = IH.clamp(m.acc[0] / ACC_FULL_SCALE_MPS2, -1, 1) * maxPx;
        var ay = IH.clamp(m.acc[1] / ACC_FULL_SCALE_MPS2, -1, 1) * maxPx;
        ctx.beginPath();
        ctx.arc(ox + ax, oy - ay, 7, 0, 2 * Math.PI);
        ctx.stroke();
    }

    // 12 ft octagon, format edge is 40 ft
    function drawBobUpBox(ctx, m) {
        if (!m.bob) { return; }
        var maxPx = velMax();
        var pxPerFt = maxPx / 40;
        var x = m.bob[0] * pxPerFt;
        var y = m.bob[1] * pxPerFt;
        var len = Math.sqrt(x * x + y * y);
        if (len > maxPx) {
            x *= maxPx / len;
            y *= maxPx / len;
        }
        var cx = IH.CX + x;
        var cy = IH.CY - y;
        var h = 6 * pxPerFt;
        var c = h * 0.414;
        ctx.beginPath();
        ctx.moveTo(cx - c, cy - h); ctx.lineTo(cx + c, cy - h);
        ctx.lineTo(cx + h, cy - c); ctx.lineTo(cx + h, cy + c);
        ctx.lineTo(cx + c, cy + h); ctx.lineTo(cx - c, cy + h);
        ctx.lineTo(cx - h, cy + c); ctx.lineTo(cx - h, cy - c);
        ctx.closePath();
        ctx.stroke();
    }

    function attitude(m) {
        return [(IH.isNum(m.pitch) ? m.pitch : 0) + (IH.isNum(m.pitchBias) ? m.pitchBias : 0), IH.isNum(m.roll) ? m.roll : 0];
    }

    // 4:1 movement, hangs at +-30 deg
    function drawHorizonLine(ctx, m) {
        if (!IH.isNum(m.pitch)) { return; }
        var att = attitude(m);
        var y = IH.clamp(att[0], -30, 30) * TRANS_PX_PER_DEG;
        var outer = 142;
        var seg = 110 / 8;
        ctx.save();
        ctx.translate(IH.CX, IH.CY);
        ctx.rotate(-att[1] * DEG);
        ctx.translate(0, y);
        ctx.beginPath();
        for (var i = 0; i < 8; i += 2) {
            ctx.moveTo(-outer + seg * i, 0); ctx.lineTo(-outer + seg * (i + 1), 0);
            ctx.moveTo(outer - seg * i, 0); ctx.lineTo(outer - seg * (i + 1), 0);
        }
        ctx.stroke();
        ctx.restore();
    }

    // No 5 deg rungs, 2:1 movement
    function drawPitchLadder(ctx, m) {
        if (!IH.isNum(m.pitch)) { return; }
        var att = attitude(m);
        ctx.save();
        ctx.beginPath();
        ctx.rect(IH.CX - 150, IH.edgeTop() - 5, 300, 420 - IH.edgeTop());
        ctx.clip();
        ctx.translate(IH.CX, IH.CY);
        ctx.rotate(-att[1] * DEG);
        ctx.translate(0, IH.clamp(att[0], -90, 90) * CRUISE_PX_PER_DEG);

        IH.font(ctx, 15);
        ctx.beginPath();
        ctx.moveTo(-142, 0); ctx.lineTo(142, 0);
        [10, 20, 30, 45, 60].forEach(function (p, i) {
            var outer = 59 + i * 12;
            ladderRung(ctx, -p, outer, outer - 44, true);
            ladderRung(ctx, p, outer, outer - 44, false);
        });
        ctx.stroke();
        zenithNadir(ctx, -90, "CLIMB");
        zenithNadir(ctx, 90, "DIVE");
        ctx.restore();
    }

    function ladderRung(ctx, pitch, outer, inner, solid) {
        var y = pitch * CRUISE_PX_PER_DEG;
        var tick = solid ? 7 : -7;
        var label = String(Math.abs(pitch));
        if (solid) {
            ctx.moveTo(-outer, y); ctx.lineTo(-inner, y);
            ctx.moveTo(outer, y); ctx.lineTo(inner, y);
        } else {
            IH.dashTo(ctx, -outer, y, -inner, y, 6, 4);
            IH.dashTo(ctx, outer, y, inner, y, 6, 4);
        }
        ctx.moveTo(-outer, y); ctx.lineTo(-outer, y + tick);
        ctx.moveTo(outer, y); ctx.lineTo(outer, y + tick);
        IH.text(ctx, label, -outer - 3, y, "right", "middle");
        IH.text(ctx, label, outer + 3, y, "left", "middle");
    }

    function zenithNadir(ctx, pitch, label) {
        var y = pitch * CRUISE_PX_PER_DEG;
        ctx.beginPath();
        ctx.arc(0, y, 4, 0, 2 * Math.PI);
        ctx.fill();
        ctx.beginPath();
        ctx.moveTo(32, y - 24); ctx.lineTo(32, y + 24);
        ctx.moveTo(-32, y - 24); ctx.lineTo(-32, y + 24);
        ctx.stroke();
        IH.text(ctx, label, 0, y - 31, "center", "bottom");
        ctx.save();
        ctx.translate(0, y);
        ctx.rotate(Math.PI);
        IH.text(ctx, label, 0, -31, "center", "bottom");
        ctx.restore();
    }

    // Bank triangle only, referenced to the lubber line: level, its tip is just below the lubber line's bottom (y 96)
    function drawBankTriangle(ctx, m) {
        if (!IH.isNum(m.roll)) { return; }
        var r = IH.CY - (98 + IH.layout.tape);
        ctx.save();
        ctx.translate(IH.CX, IH.CY);
        ctx.rotate(-m.roll * DEG);
        ctx.beginPath();
        ctx.moveTo(0, -r); ctx.lineTo(-6, 10 - r); ctx.lineTo(6, 10 - r);
        ctx.closePath();
        ctx.fill();
        ctx.restore();
    }

    // Virtual symbols are drawn about the origin into textures by tools/ihadss/generate_icons.ps1 and moved natively in game
    flight.drawFlightPathVector = function (ctx) {
        ctx.save();
        ctx.beginPath();
        ctx.arc(0, 0, 9, 0, 2 * Math.PI);
        for (var i = 0; i < 3; i++) {
            ctx.moveTo(9, 0);
            ctx.lineTo(18, 0);
            ctx.rotate(-0.5 * Math.PI);
        }
        ctx.stroke();
        ctx.restore();
    };

    flight.drawFlyToCue = function (ctx) {
        ctx.beginPath();
        ctx.moveTo(-27, 5); ctx.lineTo(-27, -3); ctx.lineTo(-2, -29); ctx.lineTo(2, -29);
        ctx.lineTo(27, -3); ctx.lineTo(27, 4); ctx.lineTo(17, 13); ctx.lineTo(-17, 13);
        ctx.closePath();
        ctx.stroke();
        ctx.beginPath();
        ctx.arc(0, 0, 2, 0, 2 * Math.PI);
        ctx.fill();
    };
})();
