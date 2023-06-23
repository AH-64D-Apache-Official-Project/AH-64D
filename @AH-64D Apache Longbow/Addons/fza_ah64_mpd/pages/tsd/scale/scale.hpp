class ScaleShow {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_SCALE), 1));
    MPD_TEXT_L(FRZ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("FRZ"))
    class ScaleCommon {
        class occluder {
            color[] = {0,0,0,1};
            class polygons {
                type = polygon;
                points[] = {
                    {
                        {{0.90, 0.278}, 1},
                        {{0.96, 0.278   }, 1},
                        {{0.96, 0.58}, 1},
                        {{0.90, 0.58}, 1}
                    }
                };
            };
        };
        class lines {
            type  = line;
            width = 3;
            points[] = {
                {{0.985, 0.65},1},
                {{0.915, 0.65},1},
                {{0.915, 0.59},1}, {},
                {{0.915, 0.27},1},
                {{0.915, 0.18},1},
                {{0.985, 0.18},1}
            };
        };

        class vabs {
            //SCALE KM
            MPD_TEXT_L(SCALETEXT_01, 0.91, 0.5 - 4.80*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
            MPD_TEXT_L(SCALETEXT_02, 0.91, 0.5 - 4.00*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("C"))
            MPD_TEXT_L(SCALETEXT_03, 0.91, 0.5 - 3.20*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
            MPD_TEXT_L(SCALETEXT_04, 0.91, 0.5 - 2.40*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
            MPD_TEXT_L(SCALETEXT_05, 0.91, 0.5 - 1.60*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
            MPD_TEXT_L(SCALETEXT_06, 0.91, 0.5                       , MPD_TEXT_STATIC("K"))
            MPD_TEXT_L(SCALETEXT_07, 0.91, 0.5 + 0.80*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))
            //5km
            MPD_TEXT_L(SCALEKM_5,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y + 0.023, MPD_TEXT_STATIC("5"))
            //10km
            MPD_TEXT_L(SCALEKM_10, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y + 0.023, MPD_TEXT_STATIC("10"))
            //25km
            MPD_TEXT_L(SCALEKM_25, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.023, MPD_TEXT_STATIC("25"))
            //50km
            MPD_TEXT_L(SCALEKM_50, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.023, MPD_TEXT_STATIC("50"))

            //Selected Scale
            class Scale_Boxes_5km {
                condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 5000));
                MPD_BOX_L(Scale_select_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y + 0.5 * MPD_TEXT_HEIGHT, 1)
            };
            class Scale_Boxes_10km {
                condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 10000));
                MPD_BOX_L(Scale_select_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y + 0.5 * MPD_TEXT_HEIGHT, 2)
            };
            class Scale_Boxes_25km {
                condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 25000));
                MPD_BOX_L(Scale_select_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5 * MPD_TEXT_HEIGHT, 2)
            };
            class Scale_Boxes_50km {
                condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 50000));
                MPD_BOX_L(Scale_select_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5 * MPD_TEXT_HEIGHT, 2)
            };
        };
    };
};
class Vabs_right_show {
    condition = C_COND(C_NOT(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_SCALE), 1)));
    #include "..\components\vabs_right.hpp"
    //R4
    MPD_BOX_BAR_L(CAQ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
    MPD_TEXT_L(CAQ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("CAQ"))
    MPD_TEXT_L(FRZ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("FRZ"))
};