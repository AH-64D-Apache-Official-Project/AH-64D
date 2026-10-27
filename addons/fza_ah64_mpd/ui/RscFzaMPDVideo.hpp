// The VIDEO page: the sensor video, and over it the page, transparent, drawing the video symbology and G/S
class RscFzaMPDVideo {
    idd = 23990;
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
        // Loads the line texture with the display, as a texture first drawn by drawRectangle in a ui() display fails to load
        class lineGreenPreload : RscPicture {
            idc = -1;
            text = "\fza_ah64_mpd\tex\canvas\line_green_ca.paa";
            colorText[] = {1, 1, 1, 0.01};
            x = 0;
            y = 0;
            w = 0.001;
            h = 0.001;
        };
        class video : fza_mpd_videoGroup {};
        // The world referenced symbology (fza_mpd_fnc_videoSymbols), native so it is drawn in the same frame as the video:
        // the TPM lines on a map canvas, the icons in a group, both showing through the page
        class lines : fza_ah64_mapControl {
            idc = 384;
            x = 0;
            y = 0;
            w = 1;
            h = 1;
            onLoad = "(_this # 0) ctrlMapAnimAdd [0, 0.001, [-99999, -99999]]; ctrlMapAnimCommit (_this # 0);";
            onDraw = "_this call fza_mpd_fnc_videoLinesDraw";
        };
        class icons : RscControlsGroupNoScrollbars {
            idc = 385;
            x = 0;
            y = 0;
            w = 1;
            h = 1;
            class Controls {};
        };
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
            url = "\fza_ah64_mpd\ui\video\video_built.html";
            x = 0;
            y = 0;
            w = 1;
            h = 1;
        };
    };
};
