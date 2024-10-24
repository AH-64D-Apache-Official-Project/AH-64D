class RscFzaAH64MPD {
    idd = -1;
    onLoad = "['onLoad', _this, 'RscFzaAH64MPD'] call (missionNamespace getVariable 'fza_mpd_fnc_uiInit');";
    class ControlsBackground {
    };
    class Controls {
        class canvas : fza_ah64_mapControl {
            idc = 367;
            x = 0;
            y = 0;
            w = 0;
            h = 0;
            onDraw = "_this call fza_mpd_fnc_canvasDraw";
        };
    };
};