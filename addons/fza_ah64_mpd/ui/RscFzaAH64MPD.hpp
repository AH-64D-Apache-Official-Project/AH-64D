class RscFzaAH64MPD {
    idd = -1;
    onLoad = "['onLoad', _this, 'RscFzaAH64MPD'] call (missionNamespace getVariable 'fza_mpd_fnc_uiInit');";
    class ControlsBackground {
        // The VIDEO page's underlay, under every native page (fza_mpd_fnc_update)
        class video : fza_mpd_videoGroup {};
    };
    class Controls {
        // The FCR imagery as the underlay (fza_mpd_fnc_videoFcr), the page transparent without it
        class fcrVideo : RscText {
            type = 106;
            idc = 386;
            style = 0;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};
            allowExternalURL = 0;
            text = "#(argb,8,8,3)color(0,0,0,0)";
            url = "\fza_ah64_mpd\ui\fcrvideo\fcrvideo_built.html";
            x = 0;
            y = 0;
            w = 1;
            h = 1;
        };
    };
};
