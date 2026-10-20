class RscFzaAH64MPD {
    idd = -1;
    onLoad = "['onLoad', _this, 'RscFzaAH64MPD'] call (missionNamespace getVariable 'fza_mpd_fnc_uiInit');";
    class ControlsBackground {
        // Loads the canvas line textures with the display: drawn first by drawRectangle inside a ui() display, a texture
        // whose mipmaps are not yet loaded fails with "Cannot load mipmap"
        class lineGreenPreload : RscPicture {
            idc = -1;
            text = "\fza_ah64_mpd\tex\canvas\line_green_ca.paa";
            colorText[] = {1, 1, 1, 0.01};
            x = 0;
            y = 0;
            w = 0.001;
            h = 0.001;
        };
        class lineWhitePreload : lineGreenPreload {
            text = "\fza_ah64_mpd\tex\canvas\line_white_ca.paa";
        };
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
