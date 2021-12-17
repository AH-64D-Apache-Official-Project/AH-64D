class xmit {
    class vabs {
        #include "..\components\vabs_top_xmit.hpp"

        //T5
        MPD_BOX_C(L01, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(L01, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("L01"))
        //T6
        MPD_BOX_C(L02,  MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(L02, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("L02"))

        //R1
        MPD_BOX_L(L03,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y, 3)
        MPD_TEXT_L(L03, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_STATIC("L03"))
        //R2
        MPD_BOX_L(L04,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, 3)
        MPD_TEXT_L(L04, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("L04"))
        //R3
        MPD_BOX_L(L05,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, 3)
        MPD_TEXT_L(L05, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("L05"))
        //R4
        MPD_BOX_L(L06,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, 3)
        MPD_TEXT_L(L06, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("L06"))
        //R5
        MPD_BOX_L(L07,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, 3)
        MPD_TEXT_L(L07, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("L07"))
        //R6
        MPD_TEXT_L(SEND, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("SEND"))
        
        //L6
        MPD_BOX_R(XMIT,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 4)
        MPD_TEXT_R(XMIT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("XMIT"))
    };
};

/***
class name
|
--vabs (vabs_core/??)
  |
  --l1 (for different color text)
--lines (outlines/??)
--polygons (boxes/occluders)
--

***/