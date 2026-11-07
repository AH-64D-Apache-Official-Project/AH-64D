class znDel {
    class Occluders {
        color[] = {0,0,0,1};

        class Polygons {
            type = "polygon";
            points[] = {
                {
                    {{0.0,   0.39 - 2.8*MPD_TEXT_HEIGHT}, 1},
                    {{0.107, 0.39 - 2.8*MPD_TEXT_HEIGHT}, 1},
                    {{0.107, 0.39 + 2.8*MPD_TEXT_HEIGHT}, 1},
                    {{0.0,   0.39 + 2.8*MPD_TEXT_HEIGHT}, 1}
                },
                {
                    {{0.107,                0.39 - 2.4*MPD_TEXT_HEIGHT},1},
                    {{0.115+MPD_TEXT_WIDTH, 0.39 - 2.4*MPD_TEXT_HEIGHT},1},
                    {{0.115+MPD_TEXT_WIDTH, 0.39 + 2.4*MPD_TEXT_HEIGHT},1},
                    {{0.107,                0.39 + 2.4*MPD_TEXT_HEIGHT},1},
                }
            };
        };
    };

    class outline  {
        type  = "line";
        width = 3;
        points[] = {
            {{0.0,   0.39 - 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.39 - 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.39 - 2.4*MPD_TEXT_HEIGHT}, 1}, {},
            {{0.0,   0.39 + 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.39 + 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.39 + 2.4*MPD_TEXT_HEIGHT}, 1}
        };
    };

    class vabs {
        //L1, what is deleted
        MPD_TEXT_R(WHAT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_ZN_DEL))
        //L2
        MPD_TEXT_R(YES, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("YES"))
        //L2 to L3
        MPD_MASK_V_R(ZnDelete, 0.107, 0.39 - 2.4 * MPD_TEXT_HEIGHT, 0.39 + 1.6 * MPD_TEXT_HEIGHT)
        MPD_TEXT_R(DEL_1, 0.107, 0.39 - 2.4 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("D"))
        MPD_TEXT_R(DEL_2, 0.107, 0.39 - 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        MPD_TEXT_R(DEL_3, 0.107, 0.39 - 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
        MPD_TEXT_R(DEL_4, 0.107, 0.39 + 0.0 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        MPD_TEXT_R(DEL_5, 0.107, 0.39 + 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(DEL_6, 0.107, 0.39 + 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        //L3
        MPD_TEXT_R(NO, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("NO"))
    };
};
