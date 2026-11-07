class znAsn {
    class vabs {
        #include "slots.hpp"
        //T4
        MPD_TEXT_C(ASN, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ASN"))
        MPD_BOX_C(ASN,  MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 3)
        //B6, the chosen PF zone to the ownship
        MPD_TEXT_C(OWN, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("OWN"))
        class OwnBarrier {
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_TSD_ZN_ANY)));
            MPD_BOX_BAR_B(OWN, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y)
        };
    };
};
