// An MPD's sensor video (fza_mpd_fnc_videoApply): the picture, and a white layer over it for the VID knob to lift
// its dark areas
class fza_mpd_videoGroup : RscControlsGroupNoScrollbars {
    idc = 380;
    x = 0;
    y = 0;
    w = 1;
    h = 1;
    class Controls {
        class picture : RscPicture {
            idc = 381;
            x = 0;
            y = 0;
            w = 1;
            h = 1;
            text = "";
            colorText[] = {1, 1, 1, 1};
        };
        class lift : RscPicture {
            idc = 382;
            x = 0;
            y = 0;
            w = 1;
            h = 1;
            text = "\fza_ah64_mpd\tex\canvas\line_white_ca.paa";
            colorText[] = {1, 1, 1, 0};
        };
    };
};
