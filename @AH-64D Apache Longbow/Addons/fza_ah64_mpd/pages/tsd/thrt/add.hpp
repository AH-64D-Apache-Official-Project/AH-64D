class thrtAdd{
    class vabs {
        #include "..\components\vabs_top.hpp"
        #include "..\components\vabs_right.hpp"

        //L1
        MPD_TEXT_R(POINT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("IDENT>"))
        MPD_TEXT_R(POINT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TG"))
        //L2
        MPD_BOX_R(ADD,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, 3)
        MPD_TEXT_R(ADD, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("ADD"))

        /*
        //L1
        class TypeWp {
            condition = __EVAL(format [STRINGIFY(EQ(user%1, POINT_TYPE_WP)), MFD_OFFSET + MFD_IND_TSD_WPT_ADD_TYPE]);
            MPD_TEXT_R(POINT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("WP"))
        };
        //L1
        class TypeTg {
            condition = __EVAL(format [STRINGIFY(EQ(user%1, POINT_TYPE_TG)), MFD_OFFSET + MFD_IND_TSD_WPT_ADD_TYPE]);
            MPD_TEXT_R(POINT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TG"))
        };*/
    };
};