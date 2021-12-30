#include "..\common.hpp"

class rteRoot {
    class lines {
        type  = line;
        width = 3;
        points[] = {
            {{0.97, 0.270},1},
            {{0.87, 0.270},1},
            {{0.87, 0.405},1}, {},
            {{0.87, 0.635},1},
            {{0.87, 0.750},1},
            {{0.97, 0.750},1}
        };
    };

    class occluders {
        color[] = {0,0,0,1};
        class polygons {
            type = polygon;
            points[] = {
                {
                    {{0.99, 0.27}, 1},
                    {{0.87, 0.27}, 1},
                    {{0.87, 0.75}, 1},
                    {{0.99, 0.75}, 1}
                }
            };
        };
    };
    
    class vabs {
        #include "..\components\vabs_top.hpp"
        #include "..\components\vabs_bottom.hpp"
        
        //R2
        MPD_TEXT_L(WP_INDEX_04, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("END"))
        //R3
        MPD_TEXT_L(WP_INDEX_03, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("W03"))
        
        //R3 & R4
        MPD_TEXT_L(SELRTE_01, 0.87, 0.5 - 2.02*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))   //B - D - H - I
        MPD_TEXT_L(SELRTE_02, 0.87, 0.5 - 1.01*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))   //R - E - O - N
        MPD_TEXT_L(SELRTE_03, 0.87, 0.5                       , MPD_TEXT_STATIC("P"))   //A - L - T - D
        MPD_TEXT_L(SELRTE_04, 0.87, 0.5 + 1.01*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("H"))   //V - T - E - I
        MPD_TEXT_L(SELRTE_05, 0.87, 0.5 + 2.02*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))   //O - A - L - A
        
        //R4
        MPD_TEXT_L(WP_INDEX_02, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("C55"))
        //R5
        MPD_TEXT_L(WP_INDEX_01, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("W01"))

        //B5
        MPD_BOX_TALL_C(THRT, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 3)

        //L2
        MPD_BOX_BAR_R(ADD,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y)
        MPD_TEXT_R(ADD,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("ADD"))
        //L3
        MPD_BOX_BAR_R(DEL,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y)
        MPD_TEXT_R(DEL,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("DEL"))
        //L4
        MPD_TEXT_R(DIR,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("DIR"))
        //L5
        MPD_BOX_BAR_R(RVW,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y)
        MPD_TEXT_R(RVW,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("RVW"))
        //L6
        MPD_BOX_BAR_R(RTM,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y)
        MPD_ARROW_R(RTM,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 3)
        MPD_TEXT_R(RTRM,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("RTM"))
    };
};