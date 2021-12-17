class edtPointSel {
    class vabs {
        #include "..\components\vabs_top.hpp"
        #include "..\components\vabs_right.hpp"
        
        //L1
        MPD_TEXT_R(POINT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("POINT>"))
        MPD_TEXT_R(POINT,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("W01"))
        //L4
        MPD_BOX_R(WP,          MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 3)
        MPD_TEXT_R(WP,         MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("EDT"))
        //L5 <-- needs barrier graphic
        MPD_TEXT_R(TYPE_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TYPE"))
        MPD_BOX_R(TYPE,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, 2)
        MPD_TEXT_R(TYPE,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("WP"))
    };
};