// The FCR imagery as an MPD's video underlay: with the sight FCR in RMAP or TPM, under the pages other than the FCR's
// (fza_mpd_fnc_videoFcr). Drawn in #fcrvideo, which the page places over the FCR page's picture.
// SQF pushes fzaFCRVideo.update({mode, view, tint, lift, data}): mode "rmap", "tpm" or "" for none; view
// MPD_VIDEO_VIEW_*; tint the video's colour and gain; lift the VID knob's white layer; data the RMAP or TPM page's
// payload without symbols.
(function () {
    "use strict";

    var root = document.getElementById("fcrvideo");
    if (!root) { return; }

    // WIDE, NORM, ZOOM: NORM as the FCR page, WIDE and ZOOM in the ratios they have for sensor video
    var VIEW_SCALE = [0.75 / 0.95, 1, 1.5 / 0.95];

    // About the FCR page's resolution, whatever the size of the display the page is in
    var opts = { scale: function () { return Math.min(1, 1024 / Math.max(1, window.innerWidth)); } };

    var factories = { rmap: "fzaFCRRmapView", tpm: "fzaFCRTpmView" };
    var views = {};
    var lift = document.createElement("div");
    lift.style.cssText = "position:absolute;left:0;top:0;width:100%;height:100%;background:#fff;opacity:0;";
    root.appendChild(lift);

    var shown = null;
    var view = -1;
    root.style.visibility = "hidden";

    function viewOf(mode) {
        if (views[mode]) { return views[mode]; }
        var make = window[factories[mode]];
        if (typeof make !== "function") { return null; }
        var canvas = document.createElement("canvas");
        canvas.style.cssText = "position:absolute;left:0;top:0;width:100%;height:100%;display:block;";
        root.insertBefore(canvas, lift);
        views[mode] = { canvas: canvas, view: make(canvas, null, opts) };
        return views[mode];
    }

    function show(mode) {
        if (mode === shown) { return; }
        shown = mode;
        for (var m in views) {
            if (Object.prototype.hasOwnProperty.call(views, m)) {
                views[m].canvas.style.display = (m === mode) ? "block" : "none";
            }
        }
        root.style.visibility = mode ? "visible" : "hidden";
    }

    window.fzaFCRVideo = {
        update: function (m) {
            if (!m || typeof m !== "object") { return; }
            var mode = (m.mode === "rmap" || m.mode === "tpm") ? m.mode : "";
            if (mode) {
                var v = viewOf(mode);
                if (!v) { mode = ""; } else {
                    var data = (m.data && typeof m.data === "object") ? m.data : {};
                    data.tint = m.tint;
                    try { v.view.update(data); } catch (e) { if (window.console) { console.error("FCR video failed", e); } }
                }
            }
            show(mode);
            if (m.view !== view && VIEW_SCALE[m.view] !== undefined) {
                view = m.view;
                root.style.transform = "scale(" + VIEW_SCALE[view] + ")";
            }
            var a = +m.lift;
            lift.style.opacity = (a > 0 && a <= 1) ? String(a) : "0";
        }
    };
}());
