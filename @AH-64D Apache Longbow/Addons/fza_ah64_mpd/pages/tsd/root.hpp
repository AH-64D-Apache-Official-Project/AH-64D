


class root {
    #include "components\info_boxes.hpp"

    class vabs {
        #include "components\vabs_top.hpp"
        #include "components\vabs_right.hpp"
        #include "components\vabs_bottom.hpp"
        //T4
        MPD_TEXT_C(PP, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC(" PP"))
        
        //R4
        MPD_TEXT_L(CAQ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("CAQ"))
        //R6
        MPD_TEXT_L(ACQ_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ACQ"))
        MPD_BOX_L(ACQ,        MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5 * MPD_TEXT_HEIGHT, 3)
        MPD_TEXT_L(ACQ,       MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("FXD"))
        //L6
        MPD_ARROW_R(SHOW, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 4)
        MPD_TEXT_R(SHOW,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("SHOW"))
        //L4 <-- when a digital message is recieved, this will display in white, future us!
        //MPD_TEXT_L(SHOW, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("SHOW"))
        //L1
        MPD_ARROW_R(ADF, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, 3)
        MPD_TEXT_R(ADF,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_STATIC("ADF"))
    };
};


