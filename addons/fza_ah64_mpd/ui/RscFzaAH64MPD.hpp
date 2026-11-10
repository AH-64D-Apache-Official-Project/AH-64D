class RscFzaAH64MPD {
    idd = -1;
    onLoad = "['onLoad', _this, 'RscFzaAH64MPD'] call (missionNamespace getVariable 'fza_mpd_fnc_uiInit');";
    class ControlsBackground {
        // The VIDEO page's underlay, under every native page (fza_mpd_fnc_update)
        class video : fza_mpd_videoGroup {};
    };
    class Controls {};
};
