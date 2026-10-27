// VIDEO page entry point: SQF pushes fzaMpdVideo.update({gs, video, sym}) (fza_mpd_fnc_pageVIDDraw). The video is under
// the page; the page draws the symbology that goes with it (the IHADSS formats) and G/S.
(function () {
    "use strict";

    window.IH.weight = 1.75;

    var canvas = document.getElementById("gs");
    var ctx = canvas.getContext("2d");
    var state = { gs: false, video: false };

    // G/S bars over the top and bottom of the page, as deep as the blank bands of WIDE (fza_mpd_fnc_videoApply)
    var WIDE_HEIGHT = 1 / (4 / 3 * 0.95);
    var STEPS = 8;

    function grey(i) {
        var v = Math.round(255 * i / (STEPS - 1));
        return "rgb(" + v + "," + v + "," + v + ")";
    }

    function draw() {
        var w = window.innerWidth;
        var h = window.innerHeight;
        if (canvas.width !== w || canvas.height !== h) {
            canvas.width = w;
            canvas.height = h;
        }
        ctx.clearRect(0, 0, w, h);
        if (!state.gs) { return; }

        // Grey scale bars over the top and bottom, dark to light and light to dark, whatever the view
        var band = h * (1 - WIDE_HEIGHT) / 2;
        for (var i = 0; i < STEPS; i++) {
            var x = w * i / STEPS;
            var step = w / STEPS + 1;
            ctx.fillStyle = grey(i);
            ctx.fillRect(x, 0, step, band);
            ctx.fillStyle = grey(STEPS - 1 - i);
            ctx.fillRect(x, h - band, step, band);
        }
        // With no video, a pattern in the centre as well
        if (!state.video) {
            for (var j = 0; j < STEPS; j++) {
                ctx.fillStyle = grey(j);
                ctx.fillRect(0, band + (h - 2 * band) * j / STEPS, w, (h - 2 * band) / STEPS + 1);
            }
        }
    }

    window.fzaMpdVideo = {
        update: function (m) {
            if (!m || typeof m !== "object") { return; }
            state.gs = m.gs === true;
            state.video = m.video === true;
            // Each layer on its own, so a failure in one cannot hold the others on their last frame
            try { draw(); } catch (e) { if (window.console) { console.error("VIDEO G/S draw failed", e); } }
            try {
                if (m.sym && typeof m.sym === "object") {
                    window.fzaIhadss.update(m.sym);
                } else {
                    window.fzaIhadss.clear();
                }
            } catch (e) { if (window.console) { console.error("VIDEO symbology failed", e); } }
        }
    };

    window.addEventListener("resize", draw);
})();
