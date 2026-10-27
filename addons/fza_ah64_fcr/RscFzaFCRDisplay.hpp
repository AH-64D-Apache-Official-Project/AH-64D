// FCR browser display classes. The *_built.html pages exist only in the PBO (inline_fcr_display_js.rhai), so file patching cannot swap in the un-inlined sources
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
            url = "\fza_ah64_fcr\ui\rmap\rmap_built.html";
            x = 0.025;
            y = 0.025;
            w = 0.95;
            h = 0.95;
        };
    };
};

// The scope over the MPD's video underlay (fza_mpd_fnc_videoApply), the page transparent
class fza_mpd_videoGroup;
class RscFzaFCRScope {
    idd = 23982;
    onLoad = "['onLoad', _this] call fza_fcr_fnc_displayUiInit;";
    class ControlsBackground {
        class background : RscText {
            idc = -1;
            x = 0;
            y = 0;
            w = 1;
            h = 1;
            colorBackground[] = {0, 0, 0, 1};
        };
        class video : fza_mpd_videoGroup {};
    };
    class Controls {
        class gameBrowser : RscText {
            type = 106;
            idc = 369;
            style = 0;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};
            allowExternalURL = 0;
            text = "#(argb,8,8,3)color(0,0,0,0)";
            url = "\fza_ah64_fcr\ui\scope\scope_built.html";
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
            url = "\fza_ah64_fcr\ui\tpm\tpm_built.html";
            x = 0.025;
            y = 0.025;
            w = 0.95;
            h = 0.95;
        };
    };
};
