class thrtRoot {
    class vabs {
        #include "..\components\vabs_top.hpp"
        #include "..\scale\ScaleConditions.hpp"
        
        //L1
        MPD_TEXT_R(POINT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("POINT>"))
        MPD_TEXT_R(POINT,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_WPT_CURRENT_POINT))
        //L2
        MPD_TEXT_R(ADD,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("ADD"))
        //L3
        MPD_TEXT_R(DEL,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("DEL"))
        //L4
        MPD_TEXT_R(EDT,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("EDT"))
        //L5
        MPD_TEXT_R(STO,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("STO"))
        //L6
        MPD_BOX_BAR_R(XMIT,     MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y)
        MPD_TEXT_R(XMIT,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("XMIT"))
    };
};