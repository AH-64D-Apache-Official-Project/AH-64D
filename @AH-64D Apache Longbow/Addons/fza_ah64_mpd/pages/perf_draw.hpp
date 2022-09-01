    class perf_draw {

    class lines {
        type = line;
        width = 3;
        points[] = {
            //Left side, vertical
            {{0.270, 0.985}, 1}, 
            {{0.270, 0.925}, 1}, {},
            //Left side, top horizontal
            {{0.270, 0.925}, 1}, 
            {{0.355, 0.925}, 1}, {},
            {{0.270, 0.925}, 1}, 
            {{0.355, 0.925}, 1}, {},
            //Right side, top horizontal
            {{0.550, 0.925}, 1}, 
            {{0.635, 0.925}, 1}, {},
            //Right side, vertical
            {{0.635, 0.925}, 1}, 
            {{0.635, 0.985}, 1}, {},
        };
    };

    class hover_q_box {
        class hover_q_box_outline {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, (10*MPD_TEXT_WIDTH) - 0.005, (2.5*MPD_TEXT_HEIGHT), 16.2*MPD_TEXT_WIDTH, 6.2*MPD_TEXT_HEIGHT), {},
            };
        };

        class hover_q_text {
             MPD_TEXT_R(HOV_Q,   MPD_TEXT_WIDTH * 10,  MPD_TEXT_HEIGHT * 2.5, MPD_TEXT_STATIC("HOVER Q"))
             MPD_TEXT_R(IGE_OGE, MPD_TEXT_WIDTH * 10,  MPD_TEXT_HEIGHT * 3.8, MPD_TEXT_STATIC("         IGE OGE"))
             MPD_TEXT_R(REQ,     MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 5.1, MPD_TEXT_STATIC( "REQUIRED 067 083"))
             MPD_TEXT_R(GO_NOGO, MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 6.4, MPD_TEXT_STATIC( "GO-NO/GO 100 082"))
             MPD_TEXT_R(IND,     MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 7.7, MPD_TEXT_STATIC( "INDICATED  019"))
        };
    };

    class cruise_box {
        class cruise_box_outline {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, (32*MPD_TEXT_WIDTH) - 0.005, (2.5*MPD_TEXT_HEIGHT), 12.2*MPD_TEXT_WIDTH, 5.2*MPD_TEXT_HEIGHT), {},
            };
        };

        class cruise_box_text {
             MPD_TEXT_R(CRU,     MPD_TEXT_WIDTH * 32,  MPD_TEXT_HEIGHT * 2.5, MPD_TEXT_STATIC("CRUISE"))
             MPD_TEXT_R(RNG_END, MPD_TEXT_WIDTH * 32,  MPD_TEXT_HEIGHT * 3.8, MPD_TEXT_STATIC("    RNG  END"))
             MPD_TEXT_R(Q,       MPD_TEXT_WIDTH * 32, MPD_TEXT_HEIGHT  * 5.1, MPD_TEXT_STATIC(" Q  065  043"))
             MPD_TEXT_R(FF,      MPD_TEXT_WIDTH * 32, MPD_TEXT_HEIGHT  * 6.4, MPD_TEXT_STATIC("FF  990  770"))
        };
    };

    class vabs {
        ///////////////// T ///////////////
        MPD_ARROW_C(ENG, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(ENG,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ENG"))

        MPD_ARROW_C(FLT, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(FLT,  MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FLT"))

        MPD_ARROW_C(FUEL, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, 4)
        MPD_TEXT_C(FUEL,  MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FUEL"))

        //MPD_ARROW_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 5)
        MPD_BOX_BAR_T(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        MPD_TEXT_C(UTIL,  MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))

        ///////////////// L ///////////////
        MPD_BOX_BAR_R(PA, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y)
        MPD_TEXT_R(PA,    MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PA>"))
        MPD_TEXT_R(PA_IN, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_PERF_PA))

        MPD_BOX_BAR_R(FAT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y)
        MPD_TEXT_R(FAT,    MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("FAT>"))
        MPD_TEXT_R(FAT_IN, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_PERF_FAT))

        MPD_BOX_BAR_R(GWT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y)
        MPD_TEXT_R(GWT,    MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("GWT>"))
        MPD_TEXT_R(GWT_IN, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_PERF_GWT))

        ///////////////// B ///////////////
        MPD_TEXT_C(PERF, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("PERF"))

        MPD_BOX_C(PERF,  MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y, 3)
        MPD_TEXT_C(CUR,  MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("CUR"))
        
        MPD_BOX_BAR_B(MAX, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_B_Y)
        MPD_TEXT_C(MAX,  MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("MAX"))
        
        MPD_BOX_BAR_B(PLAN, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y)
        MPD_TEXT_C(PLAN, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("PLAN"))

        MPD_TEXT_C(MODE, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_B_Y - 1.1*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PERF MODE"))

        MPD_ARROW_C(HIT, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 3)
        MPD_BOX_BAR_B(HIT, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y)
        MPD_TEXT_C(HIT,  MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("HIT"))

        MPD_BOX_BAR_B(WT, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y)
        MPD_TEXT_C(WT,   MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("WT"))
    };
};