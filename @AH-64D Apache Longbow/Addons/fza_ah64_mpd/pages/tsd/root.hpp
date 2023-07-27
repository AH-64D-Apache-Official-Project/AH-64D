class tsdRoot {
    #include "..\tsd\common.hpp"
    #include "components\info_boxes.hpp"

    class vabs {
        #include "components\vabs_top.hpp"
        #include "components\vabs_right.hpp"
        #include "components\vabs_bottom.hpp"
        //T4
        MPD_TEXT_C(PP, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC(" PP"))
        
        //R6
        MPD_ACQ_SRC(Acq, MFD_IND_TSD_ACQ_BOX, MFD_TEXT_IND_TSD_ACQ_SRC, Tsd_Acq)

        //L1
        MPD_ARROW_R(ADF, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, 3)
        MPD_BOX_BAR_R(ADF, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y)
        MPD_TEXT_R(ADF,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_STATIC("ADF"))
        //L4 <-- when a digital message is recieved, this will display in white, future us!
        //MPD_TEXT_L(SHOW, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("SHOW"))
        //L6
        MPD_ARROW_R(SHOW, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 4)
        MPD_TEXT_R(SHOW,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("SHOW"))
        
        class vabs_ScaleHide_CAQ {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_OPEN_POPOUT), 0));
            //R4
            MPD_BOX_BAR_L(CAQ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
            MPD_TEXT_L(CAQ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("CAQ"))
        };
    };
};


