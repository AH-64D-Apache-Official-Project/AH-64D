class loadStatus_draw {
    class vabs {
        //T1
        MPD_BOX_TALL_C(DTU, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_ARROW_C(DTU, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(DTU,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("DTU"))
        
        //B1
        MPD_TEXT_C(DMS,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("DMS"))

        //L1
        MPD_BOX_R(SHOW, MPD_POS_BUTTON_L_X,  MPD_POS_BUTTON_LR_1_Y, 3)
        MPD_TEXT_R(LOAD,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_STATIC("MTL"))
    };

    class dtuLoading_draw {
        condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_DTU_LOAD_STATUS)));

        class outlines {
            type = line;
            width = 3;
            points[] = {
                //Curved box
                MPD_POINTS_BOX(Null, (0.5 - MPD_TEXT_WIDTH * 5.5), 0.1, (11.2 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT), {},
                {{0.12, 0.19 + MPD_TEXT_HEIGHT}, 1}, 
                {{0.12 + MPD_TEXT_WIDTH * 12, 0.19 + MPD_TEXT_HEIGHT}, 1}, {},
            };
        };

        MPD_TEXT_C(MSTR_LOAD, 0.5, 0.1, MPD_TEXT_STATIC("MASTER LOAD"))
        //Non-inverse text
        MPD_TEXT_R(LOAD_STATUS_1, 0.12, 0.19, MPD_TEXT_STATIC("LOAD STATUS:"))
        
        class inverseText {
            //Inverse text
            MPD_BOX_INV_R(OIP_BOX, 0.12 + MPD_TEXT_WIDTH * 13, 0.19, 16)
            color[] = {0,0,0,1};
            class text_color {
                MPD_TEXT_R(LOAD_STATUS_2, 0.12 + (MPD_TEXT_WIDTH * 13), 0.19, MPD_TEXT_STATIC("LOAD IN PROGRESS"))
            };
        };
    };

    class dtuLoadComplete_draw {
        condition = C_COND(C_MPD_USER(MFD_IND_DTU_LOAD_STATUS));

        class outlines {
            type = line;
            width = 3;
            points[] = {
                //Curved box
                MPD_POINTS_BOX(Null, (0.5 - MPD_TEXT_WIDTH * 5.5), 0.1, (11.2 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT), {},
                {{0.12, 0.19 + MPD_TEXT_HEIGHT}, 1}, 
                {{0.12 + MPD_TEXT_WIDTH * 12, 0.19 + MPD_TEXT_HEIGHT}, 1}, {},
            };
        };

        MPD_TEXT_C(MSTR_LOAD, 0.5, 0.1, MPD_TEXT_STATIC("MASTER LOAD"))

        MPD_TEXT_R(LOAD_STATUS, 0.12, 0.19, MPD_TEXT_STATIC("LOAD STATUS: LOAD COMPLETED"))
    };
};