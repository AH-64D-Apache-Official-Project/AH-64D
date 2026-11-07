class znNfRoot {
    class vabs {
        //T1, barriered while the FCR is powered
        MPD_TEXT_C(ACTIVE_Label, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ACTIVE"))
        class Multi {
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_TSD_ZN_NF_SINGLE)));
            MPD_TEXT_C(ACTIVE, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MULTI"))
        };
        class Single {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_ZN_NF_SINGLE));
            MPD_TEXT_C(ACTIVE, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SINGLE"))
        };
        class ActiveBarrier {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_ZN_FCR_POWER));
            MPD_BOX_BAR_T(ACTIVE, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y)
        };
        //L1
        MPD_TEXT_R(TYPE_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TYPE"))
        MPD_TEXT_R(TYPE,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("NF"))
        MPD_BOX_R(TYPE,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 2)
        //L2, the NF zone drawn and changed
        MPD_TEXT_R(SEL_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SEL"))
        MPD_TEXT_R(SEL,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_ZN_SEL))
        MPD_BOX_R(SEL,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 3)
        //L3, L4, with the selected NF zone drawn; ACT boxed while it is active
        class Zones {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_ZN_ANY));
            MPD_TEXT_R(ACT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("ACT"))
            class ActBox {
                condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_ZN_SEL), 2));
                MPD_BOX_R(ACT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, 3)
            };
            MPD_TEXT_R(DEL, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("DEL"))
        };
        //L6
        #include "drawButton.hpp"
        //B6, stores the NF zone drawn
        MPD_TEXT_C(OWN, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("OWN"))
        class OwnBarrier {
            condition = C_COND(C_LESS(C_MPD_USER(MFD_IND_TSD_ZN_EDIT), 1.5));
            MPD_BOX_BAR_B(OWN, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y)
        };
    };
};
