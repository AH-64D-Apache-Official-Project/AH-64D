class thrtAdd{
    class vabs {
        #include "..\components\vabs_top.hpp"
        #include "..\scale\scale.hpp"

        //L1
        MPD_TEXT_R(POINT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("IDENT>"))
        MPD_TEXT_R(POINT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TG"))
        //L2
        MPD_BOX_R(ADD,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, 3)
        MPD_TEXT_R(ADD, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("ADD"))
    };
};