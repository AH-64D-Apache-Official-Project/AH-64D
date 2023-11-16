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
        //L2
        MPD_TEXT_R(ADD,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("ADD"))
    };    
};