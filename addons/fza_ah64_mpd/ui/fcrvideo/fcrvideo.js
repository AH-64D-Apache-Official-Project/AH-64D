// The FCR video underlay under the native MPD pages (fza_mpd_fnc_videoFcr); the page is shared/fcr_video_layer.js
(function () {
    "use strict";
    // Asks for the data sent while the page was loading, which was lost (fza_mpd_fnc_htmlReady)
    try {
        if (typeof A3API !== "undefined" && A3API && typeof A3API.SendAlert === "function") { A3API.SendAlert("fza:ready"); }
    } catch (e) {}
})();
