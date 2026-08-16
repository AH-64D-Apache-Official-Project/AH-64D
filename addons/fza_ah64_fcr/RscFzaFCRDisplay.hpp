// FCR browser display classes — structure copied from RscFzaMinigameBase (no cross-PBO inherit for the HEMTT linter)
class RscText;

class RscFzaFCRRmap {
    idd = 23980;
    onLoad = "['onLoad', _this] call fza_fcr_fnc_displayUiInit;";
    class ControlsBackground {};
    class Controls {
        class gameBrowser : RscText {
            type = 106;
            idc = 369;
            style = 0;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};
            allowExternalURL = 0;
            text = "#(rgb,1,1,1)color(0,0,0,1,ca)";
            url = "\fza_ah64_fcr\ui\rmap\rmap.html";
            x = 0.025;
            y = 0.025;
            w = 0.95;
            h = 0.95;
        };
    };
};

class RscFzaFCRScope {
    idd = 23982;
    onLoad = "['onLoad', _this] call fza_fcr_fnc_displayUiInit;";
    class ControlsBackground {};
    class Controls {
        class gameBrowser : RscText {
            type = 106;
            idc = 369;
            style = 0;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};
            allowExternalURL = 0;
            text = "#(rgb,1,1,1)color(0,0,0,1,ca)";
            url = "\fza_ah64_fcr\ui\scope\scope.html";
            x = 0.025;
            y = 0.025;
            w = 0.95;
            h = 0.95;
        };
    };
};

class RscFzaFCRTpm {
    idd = 23981;
    onLoad = "['onLoad', _this] call fza_fcr_fnc_displayUiInit;";
    class ControlsBackground {};
    class Controls {
        class gameBrowser : RscText {
            type = 106;
            idc = 369;
            style = 0;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};
            allowExternalURL = 0;
            text = "#(rgb,1,1,1)color(0,0,0,1,ca)";
            url = "\fza_ah64_fcr\ui\tpm\tpm.html";
            x = 0.025;
            y = 0.025;
            w = 0.95;
            h = 0.95;
        };
    };
};
