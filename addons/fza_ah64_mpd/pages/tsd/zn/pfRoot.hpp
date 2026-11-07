class znPfRoot {
    class vabs {
        //T4, with PF zones
        class Asn {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_ZN_ANY));
            MPD_TEXT_C(ASN, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ASN"))
        };
        //L1
        MPD_TEXT_R(TYPE_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TYPE"))
        MPD_TEXT_R(TYPE,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PF"))
        MPD_BOX_R(TYPE,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 2)
        //L2
        MPD_TEXT_R(OPT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("OPT"))
        class OptAuto {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_ZN_OPT), 0));
            MPD_TEXT_R(OPT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("AUTO"))
            MPD_BOX_R(OPT,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 4)
        };
        class OptMan {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_ZN_OPT), 1));
            MPD_TEXT_R(OPT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MAN"))
            MPD_BOX_R(OPT,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 3)
        };
        class OptTrp {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_ZN_OPT), 2));
            MPD_TEXT_R(OPT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TRP"))
            MPD_BOX_R(OPT,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 3)
        };
        class Zones {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_ZN_ANY));
            //L3, the active PF zone
            MPD_TEXT_R(ACT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ACT"))
            MPD_TEXT_R(ACT,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_ZN_SEL))
            MPD_BOX_R(ACT,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT, 3)
            //L4
            MPD_TEXT_R(DEL, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("DEL"))
        };
        //L5, #Z, or KM for TRP
        class Count {
            condition = C_COND(C_LESS(C_MPD_USER(MFD_IND_TSD_ZN_OPT), 1.5));
            MPD_TEXT_R(COUNT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("#Z"))
        };
        class Km {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_ZN_OPT), 2));
            MPD_TEXT_R(KM_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("KM"))
        };
        MPD_TEXT_R(COUNT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_ZN_COUNT))
        MPD_BOX_R(COUNT,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5*MPD_TEXT_HEIGHT, 1)
        //L6, not for TRP
        class Draw {
            condition = C_COND(C_LESS(C_MPD_USER(MFD_IND_TSD_ZN_OPT), 1.5));
            #include "drawButton.hpp"
        };
        //B6, from ASN
        MPD_TEXT_C(OWN, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("OWN"))
        MPD_BOX_BAR_B(OWN, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y)
    };
};
