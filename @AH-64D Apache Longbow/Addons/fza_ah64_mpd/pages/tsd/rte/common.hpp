#include "..\common.hpp"

class rteCommon {
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
        class routePoints {
            //R2
            MPD_TEXT_L(WP_INDEX_04, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_POINT_R2))
            //R3
            MPD_TEXT_L(WP_INDEX_03, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_POINT_R3))
            //R4
            MPD_TEXT_L(WP_INDEX_02, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_POINT_R4))
            //R5
            MPD_TEXT_L(WP_INDEX_01, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_POINT_R5))
        };
        //B5
        MPD_BOX_TALL_C(THRT, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 3)
    };
    class routeNames {
        class routeDefault {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_TEXT_POINTS), -1));
            MPD_TEXT_L(SELRTE_03, 0.87, 0.5, MPD_TEXT_STATIC("?"))
            class lines {
                type  = line;
                width = 3;
                points[] = {
                    {{0.97, 0.270},1},
                    {{0.87, 0.270},1},
                    {{0.87, (0.52 - (MPD_TEXT_HEIGHT * 0.5))},1}, {},
                    {{0.87, (0.52 + (MPD_TEXT_HEIGHT * 0.5))},1},
                    {{0.87, 0.750},1},
                    {{0.97, 0.750},1}
                };
            };
        };
        class twoCharacter {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_TEXT_POINTS), 5));
            MPD_TEXT_L(SELRTE_01, 0.87, 0.5                       , MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T1))
            class lines {
                type  = line;
                width = 3;
                points[] = {
                    {{0.97, 0.270},1},
                    {{0.87, 0.270},1},
                    {{0.87, (0.52 - (MPD_TEXT_HEIGHT * 1))},1}, {},
                    {{0.87, (0.52 + (MPD_TEXT_HEIGHT * 1))},1},
                    {{0.87, 0.750},1},
                    {{0.97, 0.750},1}
                };
            };
        };
        class twoCharacter {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_TEXT_POINTS), 5));
            MPD_TEXT_L(SELRTE_01, 0.87, 0.5 - 0.505*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T1))
            MPD_TEXT_L(SELRTE_02, 0.87, 0.5 + 0.505*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T2))
            class lines {
                type  = line;
                width = 3;
                points[] = {
                    {{0.97, 0.270},1},
                    {{0.87, 0.270},1},
                    {{0.87, (0.52 - (MPD_TEXT_HEIGHT * 1))},1}, {},
                    {{0.87, (0.52 + (MPD_TEXT_HEIGHT * 1))},1},
                    {{0.87, 0.750},1},
                    {{0.97, 0.750},1}
                };
            };
        };
        class threeCharacter {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_TEXT_POINTS), 5));
            MPD_TEXT_L(SELRTE_01, 0.87, 0.5 - 1.01*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T1))
            MPD_TEXT_L(SELRTE_02, 0.87, 0.5                       , MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T2))
            MPD_TEXT_L(SELRTE_03, 0.87, 0.5 + 1.01*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T3))
            class lines {
                type  = line;
                width = 3;
                points[] = {
                    {{0.97, 0.270},1},
                    {{0.87, 0.270},1},
                    {{0.87, (0.52 - (MPD_TEXT_HEIGHT * 1.5))},1}, {},
                    {{0.87, (0.52 + (MPD_TEXT_HEIGHT * 1.5))},1},
                    {{0.87, 0.750},1},
                    {{0.97, 0.750},1}
                };
            };
        };
        class fourCharacter {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_TEXT_POINTS), 5));
            MPD_TEXT_L(SELRTE_01, 0.87, 0.5 - 1.515*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T1))
            MPD_TEXT_L(SELRTE_02, 0.87, 0.5 - 0.505*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T2))
            MPD_TEXT_L(SELRTE_03, 0.87, 0.5 + 0.505*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T3))
            MPD_TEXT_L(SELRTE_04, 0.87, 0.5 + 1.515*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T4))
            class lines {
                type  = line;
                width = 3;
                points[] = {
                    {{0.97, 0.270},1},
                    {{0.87, 0.270},1},
                    {{0.87, (0.52 - (MPD_TEXT_HEIGHT * 2))},1}, {},
                    {{0.87, (0.52 + (MPD_TEXT_HEIGHT * 2))},1},
                    {{0.87, 0.750},1},
                    {{0.97, 0.750},1}
                };
            };
        };
        class fiveCharacter {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_TEXT_POINTS), 5));
            MPD_TEXT_L(SELRTE_01, 0.87, 0.5 - 2.02*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T1))
            MPD_TEXT_L(SELRTE_02, 0.87, 0.5 - 1.01*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T2))
            MPD_TEXT_L(SELRTE_03, 0.87, 0.5                       , MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T3))
            MPD_TEXT_L(SELRTE_04, 0.87, 0.5 + 1.01*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T4))
            MPD_TEXT_L(SELRTE_05, 0.87, 0.5 + 2.02*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_NAME_T5))
            class lines {
                type  = line;
                width = 3;
                points[] = {
                    {{0.97, 0.270},1},
                    {{0.87, 0.270},1},
                    {{0.87, (0.52 - (MPD_TEXT_HEIGHT * 2.5))},1}, {},
                    {{0.87, (0.52 + (MPD_TEXT_HEIGHT * 2.5))},1},
                    {{0.87, 0.750},1},
                    {{0.97, 0.750},1}
                };
            };
        };
    };
    class routeEnd {
        class index1 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_END_INDEX), 0));
            MPD_TEXT_L(END_TEXT_01, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("END "))
            MPD_BOX_BAR_L(END_BAR_01, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y)
        };
        class index2 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_END_INDEX), 1));
            MPD_TEXT_L(END_TEXT_02, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("END "))
            MPD_BOX_BAR_L(END_BAR_02, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
        };
        class index3 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_END_INDEX), 2));
            MPD_TEXT_L(END_TEXT_03, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("END "))
            MPD_BOX_BAR_L(END_BAR_03, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y)
        };
        class index4 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_END_INDEX), 3));
            MPD_TEXT_L(END_TEXT_04, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("END "))
            MPD_BOX_BAR_L(CAQ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y)
        };
    class routeSelected {
        class index1 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_POINT), 0));
            MPD_BOX_BAR_B(Selected_Point_1, MPD_POS_BUTTON_R_X - (MPD_TEXT_WIDTH * 2.5), MPD_POS_BUTTON_LR_5_Y)
        };
        class index2 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_POINT), 1));
            MPD_BOX_BAR_B(Selected_Point_2, MPD_POS_BUTTON_R_X - (MPD_TEXT_WIDTH * 2.4), MPD_POS_BUTTON_LR_4_Y)
        };
        class index3 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_POINT), 2));
            MPD_BOX_BAR_B(Selected_Point_3, MPD_POS_BUTTON_R_X - (MPD_TEXT_WIDTH * 2.3), MPD_POS_BUTTON_LR_3_Y)
        };
        class index4 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTE_POINT), 3));
            MPD_BOX_BAR_B(Selected_Point_4, MPD_POS_BUTTON_R_X - (MPD_TEXT_WIDTH * 2.2), MPD_POS_BUTTON_LR_2_Y)
        };
    };
    };
};