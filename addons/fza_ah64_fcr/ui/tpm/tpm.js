// FCR TPM terrain profile page — SQF pushes fzaFCRTpm.update(...) (shared/fcr_tpm_view.js)
(function () {
    "use strict";

    function init() {
        window.fzaFCRTpm = window.fzaFCRTpmView(document.getElementById("canvas"), document.getElementById("overlay"));
        // Asks for the data sent while the page was loading, which was lost (fza_fcr_fnc_displayUiInit)
        try {
            if (typeof A3API !== "undefined" && A3API && typeof A3API.SendAlert === "function") { A3API.SendAlert("fza:ready"); }
        } catch (e) {}
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
}());
