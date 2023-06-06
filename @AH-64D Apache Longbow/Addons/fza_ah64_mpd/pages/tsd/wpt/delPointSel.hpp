class wptDelPointSel {
    class Occluders {
        color[] = {0,0,0,1};

        class Polygons {
            type = polygon;
            points[] = {
                {   //should be equal to 8 characters tall with no padding 
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
    
    class Outline  {
        type  = line;
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
        #include "..\components\vabs_top.hpp"
        class Vabs_right_show {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_SCALE), -1));
            #include "..\components\vabs_right.hpp"
            //R4
            MPD_BOX_BAR_L(CAQ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
            MPD_TEXT_L(CAQ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("CAQ"))
        };
        class ScaleShow {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_SCALE), 1));
            #include"..\components\scale.hpp"
            MPD_TEXT_L(FRZ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("FRZ"))
        };
        
        //L1
        MPD_TEXT_R(POINT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("POINT>"))
        MPD_TEXT_R(POINT,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("W01"))
        //L2
        MPD_TEXT_R(WP, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("YES"))
        //L2 to L3
        MPD_TEXT_R(DEL_1, 0.107, 0.39 - 2.4 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("D"))
        MPD_TEXT_R(DEL_2, 0.107, 0.39 - 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        MPD_TEXT_R(DEL_3, 0.107, 0.39 - 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
        MPD_TEXT_R(DEL_4, 0.107, 0.39 + 0.0 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        MPD_TEXT_R(DEL_5, 0.107, 0.39 + 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(DEL_6, 0.107, 0.39 + 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        //L3
        MPD_TEXT_R(HZ, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("NO"))
    };
};