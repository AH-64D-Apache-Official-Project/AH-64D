#include "..\common.hpp"

class thrtCommon {
    class vabs {//B4
        #include "..\components\vabs_bottom.hpp"

        //T4
        MPD_ARROW_C(ABR, MPD_POS_BUTTON_TB_4_X+0.015, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(ABR,  MPD_POS_BUTTON_TB_4_X+0.015, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ABR"))

        //B6
        MPD_BOX_TALL_C(THRT, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, 4)
    };

    class WAYPOINTINFOBOX {
        color[] = {0,0,0,1};

        class Polygons {
            type = polygon;
            points[] = {
                {
                    {{0.1, 0.9-3*MPD_TEXT_HEIGHT}, 1},
                    {{0.9, 0.9-3*MPD_TEXT_HEIGHT}, 1},
                    {{0.9, 0.90}, 1},
                    {{0.1, 0.90}, 1}
                }
            };
        };
    };

    class lines {
        type  = line;
        width = 3;
        points[] = {
            {{0.1, 0.9-3*MPD_TEXT_HEIGHT},1},
            {{0.9, 0.9-3*MPD_TEXT_HEIGHT},1},
            {{0.9, 0.9},1},
            {{0.1, 0.9},1},
            {{0.1, 0.9-3*MPD_TEXT_HEIGHT},1}
        };
    };

    /*
    class WaypointInfoBoxText {
        MPD_TEXT_C(WIBT01, 0.49, 0.9-3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("W02 WP P02 ETE 00:00:18 ETA 14:12:21Z"))
        MPD_TEXT_C(WIBT02, 0.49, 0.9-2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CL6 25 14R PK 1712 4594  360*  0.5 KM"))
        MPD_TEXT_C(WIBT03, 0.49, 0.9-MPD_TEXT_HEIGHT,   MPD_TEXT_STATIC("N31 08.60 W097 46.29   280 FT  0.3 NM"))
    };*/


    class WaypointInfoBoxText {
        MPD_TEXT_C(WIBT01, 0.49, 0.9-3*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_WPT_DETAILS_1))
        MPD_TEXT_C(WIBT02, 0.49, 0.9-2*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_WPT_DETAILS_2))
        MPD_TEXT_C(WIBT03, 0.49, 0.9-MPD_TEXT_HEIGHT,   MPD_TEXT_USER(MFD_TEXT_IND_TSD_WPT_DETAILS_3))
    };
};

/*
    Index  Type  Free
    ?01    WP    AAA   ETE 00:00:00 ETA 00:00:00L
    W84    47    13S   FU  XXXX XXXX XXX  XX.X KM
    NXX XX.XX WXXX XX.XX   XXXX FT        XX.X NM

    _heli setVariable ["fza_dms_waypointsHazards", [POINT_COUNT_WP_HZ] call _newPointsArray, true];
    _heli setVariable ["fza_dms_controlMeasures", [POINT_COUNT_CM] call _newPointsArray, true];
    _heli setVariable ["fza_dms_targetsThreats", [POINT_COUNT_TG_TH] call _newPointsArray, true];
*/