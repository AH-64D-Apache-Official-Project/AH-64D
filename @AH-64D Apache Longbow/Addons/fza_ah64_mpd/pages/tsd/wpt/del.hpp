class del {
    class Occluders {
        color[] = {0,0,0,1};

        class Polygons {
            type = polygon;
            points[] = {
                {   //should be equal to 8 characters tall with no padding 
                    {{0.0, 0.38 - 2.8*MPD_TEXT_HEIGHT}, 1},
                    {{0.107, 0.38 - 2.8*MPD_TEXT_HEIGHT}, 1},
                    {{0.107, 0.38 + 2.8*MPD_TEXT_HEIGHT}, 1},
                    {{0.0, 0.38 + 2.8*MPD_TEXT_HEIGHT}, 1}
                },
                {
                    {{0.107,  0.38 - 2.4*MPD_TEXT_HEIGHT},1},
                    {{0.115+MPD_TEXT_WIDTH, 0.38 - 2.4*MPD_TEXT_HEIGHT},1},
                    {{0.115+MPD_TEXT_WIDTH, 0.38 + 2.4*MPD_TEXT_HEIGHT},1},
                    {{0.107, 0.38 + 2.4*MPD_TEXT_HEIGHT},1},
                }
            };
        };
    };
    
    class Outline  {
        type  = line;
        width = 3;
        points[] = {
            {{0.0, 0.38 - 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.38 - 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.38 - 2.4*MPD_TEXT_HEIGHT}, 1}, {},
            {{0.0, 0.38 + 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.38 + 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.38 + 2.4*MPD_TEXT_HEIGHT}, 1}
        };
    };
    
    class VABS {
        //L2 to L3
        MPD_TEXT_R(DEL_1, 0.107, 0.38 - 2.4 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("D"))
        MPD_TEXT_R(DEL_2, 0.107, 0.38 - 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        MPD_TEXT_R(DEL_3, 0.107, 0.38 - 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
        MPD_TEXT_R(DEL_4, 0.107, 0.38 + 0.0 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        MPD_TEXT_R(DEL_5, 0.107, 0.38 + 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(DEL_6, 0.107, 0.38 + 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        //L3
        MPD_TEXT_R(HZ, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("NO"))
        //L2
        MPD_TEXT_R(WP, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("YES"))
    };
};