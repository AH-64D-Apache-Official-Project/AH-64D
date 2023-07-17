class VABSRight {
    class vabs_Scale {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_OPEN_POPOUT), 1));
        #include "..\scale\scale.hpp"
    };
    class vabs_default {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_OPEN_POPOUT), 0));
        //R1
        MPD_TEXT_L(ZOOM_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 2.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Z"))
        MPD_TEXT_L(ZOOM_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 1.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_L(ZOOM_3, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_L(ZOOM_4, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))
        //R2
        MPD_TEXT_L(SC_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SC"))
        MPD_BOX_L(SC,        MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5 * MPD_TEXT_HEIGHT, 2)
        
        class Scale_Boxes_5km {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 5000));
            MPD_TEXT_L(SC,       MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("5"))
        };
        class Scale_Boxes_10km {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 10000));
            MPD_TEXT_L(SC,       MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("10"))
        };
        class Scale_Boxes_25km {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 25000));
            MPD_TEXT_L(SC,       MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("25"))
        };
        class Scale_Boxes_50km {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 50000));
            MPD_TEXT_L(SC,       MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("50"))
        };
        
        //R3
        MPD_TEXT_L(CTR, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("CTR"))
        class CTR_Box {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_CTR));
            MPD_BOX_L(CTR, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, 3)
        };
    };
    //R5    
    MPD_BOX_BAR_L(FRZ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y)
    MPD_TEXT_L(FRZ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("FRZ"))
};