// The TSD's map symbols over the MPD's video underlay, the page transparent; the TSD's labels are drawn natively
class RscFzaMPDTsd {
    idd = 23991;
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
            url = "\fza_ah64_mpd\ui\tsd\tsd_built.html";
            x = 0.025;
            y = 0.025;
            w = 0.95;
            h = 0.95;
        };
    };
};
