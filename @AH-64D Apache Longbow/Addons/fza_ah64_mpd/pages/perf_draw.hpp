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
                MPD_POINTS_BOX(Null, (21*MPD_TEXT_WIDTH) - 0.005, (7.72*MPD_TEXT_HEIGHT), 2.95*MPD_TEXT_WIDTH, 0.78*MPD_TEXT_HEIGHT), {},
            };
        };

        class hover_q_text {
             MPD_TEXT_R(HOV_Q,   MPD_TEXT_WIDTH * 10,  MPD_TEXT_HEIGHT * 2.5, MPD_TEXT_STATIC("HOVER Q"))
             MPD_TEXT_R(IGE_OGE, MPD_TEXT_WIDTH * 10,  MPD_TEXT_HEIGHT * 3.8, MPD_TEXT_STATIC("         IGE OGE"))
             MPD_TEXT_R(REQ,     MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 5.1,  MPD_TEXT_USER(MFD_TEXT_IND_PERF_HVR_TQ_IGE_OGE))//MPD_TEXT_STATIC( "REQUIRED 067 083"))
             MPD_TEXT_R(GO_NOGO, MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 6.4,  MPD_TEXT_USER(MFD_TEXT_IND_PERF_GO_NOGO_TQ_IGE_OGE))//MPD_TEXT_STATIC( "GO-NO/GO 100 082"))
             MPD_TEXT_R(IND,     MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 7.7,  MPD_TEXT_USER(MFD_TEXT_IND_PERF_IND_TQ))//MPD_TEXT_STATIC( "INDICATED  019"))
        };
    };

    class cruise_box {
        class cruise_box_outline {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, (32*MPD_TEXT_WIDTH) - 0.005, (2.5*MPD_TEXT_HEIGHT), 12.2*MPD_TEXT_WIDTH, 4.8*MPD_TEXT_HEIGHT), {},
            };
        };

        class cruise_box_text {
             MPD_TEXT_R(CRU,     MPD_TEXT_WIDTH * 32,  MPD_TEXT_HEIGHT * 2.5, MPD_TEXT_STATIC("CRUISE"))
             MPD_TEXT_R(RNG_END, MPD_TEXT_WIDTH * 32,  MPD_TEXT_HEIGHT * 3.8, MPD_TEXT_STATIC("    RNG  END"))
             MPD_TEXT_R(Q,       MPD_TEXT_WIDTH * 32, MPD_TEXT_HEIGHT  * 5.1, MPD_TEXT_USER(MFD_TEXT_IND_PERF_MAX_RNG_END_TQ))//MPD_TEXT_STATIC(" Q  065  043"))
             MPD_TEXT_R(FF,      MPD_TEXT_WIDTH * 32, MPD_TEXT_HEIGHT  * 6.4, MPD_TEXT_USER(MFD_TEXT_IND_PERF_MAX_RNG_END_FF))//MPD_TEXT_STATIC("FF 1990 1770"))
        };
    };

    class max_gwt_box {
        class max_gwt_box_outline {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, (10*MPD_TEXT_WIDTH) - 0.005, (9.7*MPD_TEXT_HEIGHT), 16.2*MPD_TEXT_WIDTH, 4.8*MPD_TEXT_HEIGHT), {},
            };
        };

        class max_gwt_text {
            MPD_TEXT_R(GWT,         MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT *  9.7, MPD_TEXT_STATIC("MAX GWT"))
            MPD_TEXT_R(GWT_IGE_OGE, MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 11.0, MPD_TEXT_STATIC("    IGE     OGE"))
            MPD_TEXT_R(GWT_DE_TEXT, MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 12.3, MPD_TEXT_STATIC("DE"))
            MPD_TEXT_R(GWT_DE,      MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 12.3, MPD_TEXT_USER(MFD_TEXT_IND_PERF_MAXGWT_DE_IGE_OGE))//MPD_TEXT_STATIC("DE 21440   18410"))
            MPD_TEXT_R(GWT_SE_TEXT, MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 13.6, MPD_TEXT_STATIC("SE"))
        };

        class max_gwt_caut_ind {
            color[] = {1,1,0,1};
            class max_gwt_caut_text {
                MPD_TEXT_R(GWT_SE,   MPD_TEXT_WIDTH * 10, MPD_TEXT_HEIGHT * 13.6, MPD_TEXT_USER(MFD_TEXT_IND_PERF_MAXGWT_SE_IGE_OGE))//MPD_TEXT_STATIC("SE 14200   12400"))
            };
        };
    };

    class tas_box {
        class tas_box_outline {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, (35*MPD_TEXT_WIDTH) - 0.005, (8.4*MPD_TEXT_HEIGHT), 8.2*MPD_TEXT_WIDTH, 6.1*MPD_TEXT_HEIGHT), {},
            };
        };

        class tas_text {
             MPD_TEXT_R(TAS,         MPD_TEXT_WIDTH * 35, MPD_TEXT_HEIGHT *  8.4, MPD_TEXT_STATIC("TAS"))
             MPD_TEXT_R(TAS_VNE,     MPD_TEXT_WIDTH * 35, MPD_TEXT_HEIGHT *  9.9, MPD_TEXT_USER(MFD_TEXT_IND_PERF_VNE))//MPD_TEXT_STATIC(" VNE 192"))
             MPD_TEXT_R(TAS_VSSE_DE, MPD_TEXT_WIDTH * 35, MPD_TEXT_HEIGHT * 11.0, MPD_TEXT_USER(MFD_TEXT_IND_PERF_VSSE))//MPD_TEXT_STATIC("VSSE 034"))
             MPD_TEXT_R(TAS_RNG,     MPD_TEXT_WIDTH * 35, MPD_TEXT_HEIGHT * 12.3, MPD_TEXT_USER(MFD_TEXT_IND_PERF_RNG_SPD))//MPD_TEXT_STATIC(" RNG 120"))
             MPD_TEXT_R(TAS_END,     MPD_TEXT_WIDTH * 35, MPD_TEXT_HEIGHT * 13.6, MPD_TEXT_USER(MFD_TEXT_IND_PERF_END_SPD))//MPD_TEXT_STATIC(" END 073"))
        };
    };

    class wind_box {
        class wind_box_outline {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, (33.5*MPD_TEXT_WIDTH) - 0.005, (15.6*MPD_TEXT_HEIGHT), 11.2*MPD_TEXT_WIDTH, 0.9*MPD_TEXT_HEIGHT), {},
            };
        };

        class wind_text {
             MPD_TEXT_R(WND, MPD_TEXT_WIDTH * 33.5, MPD_TEXT_HEIGHT * 15.6, MPD_TEXT_USER(MFD_TEXT_IND_WIND))//MPD_TEXT_STATIC("WIND 067/15"))
        };
    };

    class max_q_box {
        class max_q_box_outline {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, (6.5*MPD_TEXT_WIDTH) - 0.005, (16.1*MPD_TEXT_HEIGHT), 6.2*MPD_TEXT_WIDTH, 3.4*MPD_TEXT_HEIGHT), {},
            };
        };

        class max_q_box_text {
            MPD_TEXT_R(MAX_Q,    MPD_TEXT_WIDTH * 6.5, MPD_TEXT_HEIGHT * 16.1, MPD_TEXT_STATIC("MAX Q"))
            MPD_TEXT_R(MAX_Q_DE, MPD_TEXT_WIDTH * 6.5, MPD_TEXT_HEIGHT * 17.4, MPD_TEXT_STATIC("DE"))
            MPD_TEXT_R(MAX_Q_SE, MPD_TEXT_WIDTH * 6.5, MPD_TEXT_HEIGHT * 18.6, MPD_TEXT_STATIC("SE"))
        };

        class max_q_de_caut_ind {
            color[] = {1,1,0,1};
            class max_q_de_caut_box_outline {
                
                type = line;
                width = 3;
                points[] = {
                    MPD_POINTS_BOX(Null, (9.6*MPD_TEXT_WIDTH) - 0.005, (17.5*MPD_TEXT_HEIGHT), 2.8*MPD_TEXT_WIDTH, 0.7*MPD_TEXT_HEIGHT), {},
                };
            };

            class max_q_de_caut_text {
                MPD_TEXT_R(MAX_Q_DE, MPD_TEXT_WIDTH * 6.5, MPD_TEXT_HEIGHT * 17.4, MPD_TEXT_USER(MFD_TEXT_IND_PERF_MAX_TQ_DE))//MPD_TEXT_STATIC("DE 115"))
            };
        };

        class max_q_se_caut_ind {
            color[] = {1,1,0,1};
            class max_q_se_caut_box_outline {
                type = line;
                width = 3;
                points[] = {
                    MPD_POINTS_BOX(Null, (9.6*MPD_TEXT_WIDTH) - 0.005, (18.7*MPD_TEXT_HEIGHT), 2.8*MPD_TEXT_WIDTH, 0.7*MPD_TEXT_HEIGHT), {},
                };
            };

            class max_q_se_caut_text {
                MPD_TEXT_R(MAX_Q_SE, MPD_TEXT_WIDTH * 6.5, MPD_TEXT_HEIGHT * 18.6, MPD_TEXT_USER(MFD_TEXT_IND_PERF_MAX_TQ_SE))//MPD_TEXT_STATIC("SE 122"))
            };
        };
    };

    class cg_display {
        class cg_lines {
            type = line;
            width = 6;
            points[] = {
                //Horizontal line
                {{0.290, 0.880}, 1}, 
                {{0.910, 0.880}, 1}, {},
                //Vertical line
                {{0.520, 0.880}, 1},
                {{0.520, 0.850}, 1}, {},
                //Left triangle
                {{0.315, 0.875}, 1},
                {{0.335, 0.863}, 1},
                {{0.315, 0.850}, 1},
                {{0.315, 0.875}, 1}, {},
                //Right triangle
                {{0.875, 0.875}, 1},
                {{0.855, 0.863}, 1},
                {{0.875, 0.850}, 1},
                {{0.875, 0.875}, 1}, {},
            };
        };

        class cg_text {
            MPD_TEXT_R(TOP , MPD_TEXT_WIDTH * 15.2, MPD_TEXT_HEIGHT * 16.9, MPD_TEXT_STATIC("FWD          CG          AFT"))
            MPD_TEXT_R(BOT , MPD_TEXT_WIDTH * 15.2, MPD_TEXT_HEIGHT * 17.8, MPD_TEXT_STATIC("201.0       203.1      207.0"))
        };
    };

    class vabs {
        ///////////////// T ///////////////
        MPD_ARROW_C(FLT, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(FLT,  MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FLT"))

        MPD_ARROW_C(FUEL, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, 4)
        MPD_TEXT_C(FUEL,  MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FUEL"))

        MPD_ARROW_C(PERF, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 4)
        MPD_BOX_TALL_C(PERF,   MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 4)
        MPD_TEXT_C(PERF,  MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("PERF"))

        MPD_ARROW_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
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
        MPD_TEXT_C(ENG, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ENG"))

        MPD_BOX_C(CUR,  MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y, 3)
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