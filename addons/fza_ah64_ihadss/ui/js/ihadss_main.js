// Page entry point: SQF pushes the model with fzaIhadss.update(model) once per frame
(function () {
    "use strict";

    var IH = window.IH;
    var canvas = document.getElementById("ihadss");
    var ctx = canvas.getContext("2d");
    var model = null;

    // Fixed backing size stretched by CSS, so a jittering window size cannot move the layout; covers the format plus IH.MARGIN
    var BACKING_SCALE = 2;

    function fitCanvas() {
        var w = (IH.W + 2 * IH.MARGIN) * BACKING_SCALE;
        var h = (IH.H + 2 * IH.MARGIN) * BACKING_SCALE;
        if (canvas.width !== w || canvas.height !== h) {
            canvas.width = w;
            canvas.height = h;
        }
        ctx.setTransform(BACKING_SCALE, 0, 0, BACKING_SCALE, IH.MARGIN * BACKING_SCALE, IH.MARGIN * BACKING_SCALE);
    }

    var tickTimer = null;

    function draw() {
        if (tickTimer !== null) {
            clearTimeout(tickTimer);
            tickTimer = null;
        }
        IH.tickRequested = false;
        ctx.save();
        try {
            drawModel();
        } catch (e) {
            if (window.console) { console.error("IHADSS draw failed", e); }
        }
        ctx.restore();
        if (IH.tickRequested && model) {
            tickTimer = setTimeout(draw, 125);
        }
    }

    function drawModel() {
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        if (!model) { return; }
        fitCanvas();

        var m = model;
        var colour = m.white ? IH.WHITE : IH.GREEN;
        ctx.strokeStyle = colour;
        ctx.fillStyle = colour;
        ctx.lineWidth = 2;
        ctx.lineJoin = "round";
        ctx.globalAlpha = 1;

        var weaponFormat = m.fmt === "wpn";
        var tadsReticle = weaponFormat && (m.hd || m.tv);

        IH.layout = m.hd ? IH.NO_SPREAD : IH.SPREAD;
        if (!m.hd) {
            ctx.beginPath();
            ctx.ellipse(IH.CX, IH.CY, IH.HDU_CLIP.a, IH.HDU_CLIP.b, IH.HDU_CLIP.rot, 0, 2 * Math.PI);
            ctx.clip();
            ctx.beginPath();
            ctx.rect(IH.CX + IH.HDU_FIELD.left, IH.CY + IH.HDU_FIELD.top, IH.HDU_FIELD.right - IH.HDU_FIELD.left, IH.HDU_FIELD.bottom - IH.HDU_FIELD.top);
            ctx.clip();
        }

        // The reticle flashes at a sight limit or with the gun failed
        if (!m.losFlash || IH.flashOn()) {
            if (tadsReticle) {
                IH.base.drawTadsLos(ctx);
            } else {
                IH.base.drawFlightLos(ctx, !weaponFormat && m.mode === "cruise");
            }
        }
        IH.base.drawCueingDots(ctx, m.acq, tadsReticle);
        IH.shifted(ctx, 0, IH.layout.tape, function () { IH.base.drawHeadingTape(ctx, m); });
        IH.shifted(ctx, 0, IH.layout.bottom, function () { IH.base.drawFieldOfRegard(ctx, m); });
        if (weaponFormat) {
            IH.weapon.drawFormat(ctx, m);
        } else {
            IH.flight.draw(ctx, m);
        }
        IH.weapon.drawSymbols(ctx, m);
        IH.base.drawHad(ctx, m);
    }

    var ARRAY_KEYS = ["vel", "acc", "bob", "wpt", "acq", "forFov", "forCue", "msl", "had"];

    window.fzaIhadss = {
        update: function (m) {
            if (!m || typeof m !== "object") { m = null; }
            ARRAY_KEYS.forEach(function (k) {
                if (m && m[k] !== undefined && !Array.isArray(m[k])) { delete m[k]; }
            });
            model = m;
            draw();
        },
        clear: function () {
            model = null;
            draw();
        }
    };

    if (document.fonts && document.fonts.load) {
        document.fonts.load("15px BMKApacheFont").then(draw, function () {});
    }
})();
