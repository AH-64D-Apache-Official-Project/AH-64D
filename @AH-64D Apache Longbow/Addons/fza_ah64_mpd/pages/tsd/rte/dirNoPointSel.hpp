class rteDirNoPointSel {
    class vabs {
        #include "..\components\vabs_top.hpp"
        #include "..\components\vabs_bottom.hpp"
        
        class l1Button {
            color[] = {1,1,1,1};

            //L1
            MPD_TEXT_R(POINT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("POINT>"))
            MPD_TEXT_R(POINT,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTE_CURPNT))
        };
        //L4
        MPD_BOX_R(DIR,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 3)
        MPD_TEXT_R(DIR, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("DIR"))
    };    
};