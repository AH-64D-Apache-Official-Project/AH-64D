class delPointSel {
    class Occluders {
        color[] = {0,0,0,1};

        class Polygons {
            type = polygon;
            points[] = {
                {   //should be equal to 8 characters tall with no padding 
                    {{0.0,   0.505 - 2.8*MPD_TEXT_HEIGHT}, 1},
                    {{0.107, 0.505 - 2.8*MPD_TEXT_HEIGHT}, 1},
                    {{0.107, 0.505 + 2.8*MPD_TEXT_HEIGHT}, 1},
                    {{0.0,   0.505 + 2.8*MPD_TEXT_HEIGHT}, 1}
                },
                {
                    {{0.107,                0.505 - 2.4*MPD_TEXT_HEIGHT},1},
                    {{0.115+MPD_TEXT_WIDTH, 0.505 - 2.4*MPD_TEXT_HEIGHT},1},
                    {{0.115+MPD_TEXT_WIDTH, 0.505 + 2.4*MPD_TEXT_HEIGHT},1},
                    {{0.107,                0.505 + 2.4*MPD_TEXT_HEIGHT},1},
                }
            };
        };
    };
    
    class Outline  {
        type  = line;
        width = 3;
        points[] = {
            {{0.0,   0.505 - 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.505 - 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.505 - 2.4*MPD_TEXT_HEIGHT}, 1}, {},
            {{0.0,   0.505 + 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.505 + 2.8*MPD_TEXT_HEIGHT}, 1},
            {{0.107, 0.505 + 2.4*MPD_TEXT_HEIGHT}, 1}
        };
    };
    
    class vabs {
        #include "..\components\vabs_top.hpp"
        #include "..\components\vabs_right.hpp"
        
        //L1
        MPD_TEXT_R(POINT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("POINT>"))
        MPD_TEXT_R(POINT,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("W01"))
        //L3
        MPD_TEXT_R(WP, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("YES"))
        //L3 to L4
        MPD_TEXT_R(DEL_1, 0.107, 0.505 - 2.4 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("D"))
        MPD_TEXT_R(DEL_2, 0.107, 0.505 - 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        MPD_TEXT_R(DEL_3, 0.107, 0.505 - 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
        MPD_TEXT_R(DEL_4, 0.107, 0.505 + 0.0 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        MPD_TEXT_R(DEL_5, 0.107, 0.505 + 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(DEL_6, 0.107, 0.505 + 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        //L4
        MPD_TEXT_R(HZ, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("NO"))
    };
};