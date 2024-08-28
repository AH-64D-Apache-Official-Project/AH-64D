class RouteReview {
    MPD_BOX_R(ADD,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, 3)
    MPD_TEXT_R(RVW, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("RVW"))
    
    class visible {
        condition = C_COND(C_MORE(C_MPD_USER(MFD_IND_TSD_RTE_RVW_INDEX), -1));

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
        class WaypointInfoBoxText {
            MPD_TEXT_C(WIBT01, 0.49, 0.9-3*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_RVW_DETAILS_1))
            MPD_TEXT_C(WIBT02, 0.49, 0.9-2*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_RVW_DETAILS_2))
            MPD_TEXT_C(WIBT03, 0.49, 0.9-MPD_TEXT_HEIGHT,   MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_RVW_DETAILS_3))
        };
    };
};