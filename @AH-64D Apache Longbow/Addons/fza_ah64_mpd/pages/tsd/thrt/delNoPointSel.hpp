class thrtDelNoPointSel {
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
        
        class l1Button {
            color[] = {1,1,1,1};

            //L1
            MPD_TEXT_R(POINT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("POINT>"))
            MPD_TEXT_R(POINT,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("?01"))
        };
        //L3
        MPD_BOX_R(WP,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, 3)
        MPD_TEXT_R(WP, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("DEL"))
    };
};