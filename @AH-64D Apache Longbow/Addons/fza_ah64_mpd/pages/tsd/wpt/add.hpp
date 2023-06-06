class wptAdd{
    class lines {
        type  = line;
        width = 3;
        points[] = {
            {{0.010, 0.500},1},
            {{0.085, 0.500},1},
            {{0.085, 0.600},1}, {},
            {{0.085, 0.700},1},
            {{0.085, 0.850},1},
            {{0.010, 0.850},1}
        };
    };

    class occluders {
        color[] = {0,0,0,1};
        class polygons {
            type = polygon;
            points[] = {
                {
                    {{0.085, 0.50}, 1},
                    {{0.000, 0.50}, 1},
                    {{0.000, 0.85}, 1},
                    {{0.085, 0.85}, 1}
                },
                {
                    {{0.085 + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_5_Y - 1.50*MPD_TEXT_HEIGHT}, 1},
                    {{0.085,                  MPD_POS_BUTTON_LR_5_Y - 1.50*MPD_TEXT_HEIGHT}, 1},
                    {{0.085,                  MPD_POS_BUTTON_LR_5_Y + 2.50*MPD_TEXT_HEIGHT}, 1},
                    {{0.085 + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_5_Y + 2.50*MPD_TEXT_HEIGHT}, 1}
                }
            };
        };
    };
    
    class vabs {
        #include "..\components\vabs_top.hpp"
        #include "..\scale\ScaleConditions.hpp"

        //L1
        MPD_TEXT_R(POINT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("IDENT>"))
        //L2
        MPD_BOX_R(ADD,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, 3)
        MPD_TEXT_R(ADD, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("ADD"))
        //L3 - Default
        class TypeWp {
            condition = C_COND(C_EQ(POINT_TYPE_WP, C_MPD_USER(MFD_IND_TSD_WPT_ADD_TYPE)));
            MPD_BOX_R(WP,     MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 2)
            MPD_TEXT_R(POINT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("WP"))
        };
        MPD_TEXT_R(WP, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("WP"))
        //L4
        class TypeHz {
            condition = C_COND(C_EQ(POINT_TYPE_HZ, C_MPD_USER(MFD_IND_TSD_WPT_ADD_TYPE)));
            MPD_BOX_R(HZ,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, 2)
            MPD_TEXT_R(POINT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("HZ"))
        };
        MPD_TEXT_R(HZ, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("HZ"))
        
        MPD_TEXT_R(TYPE_01, 0.085, MPD_POS_BUTTON_LR_5_Y - 1.50*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(TYPE_02, 0.085, MPD_POS_BUTTON_LR_5_Y - 0.50*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Y"))
        MPD_TEXT_R(TYPE_03, 0.085, MPD_POS_BUTTON_LR_5_Y + 0.50*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("P"))
        MPD_TEXT_R(TYPE_04, 0.085, MPD_POS_BUTTON_LR_5_Y + 1.50*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        
        //L5
        class TypeCm {
            condition = C_COND(C_EQ(POINT_TYPE_CM, C_MPD_USER(MFD_IND_TSD_WPT_ADD_TYPE)));
            MPD_BOX_R(CM,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 2)
            MPD_TEXT_R(POINT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CM"))
        };
        MPD_TEXT_R(CM, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("CM"))
    };
};