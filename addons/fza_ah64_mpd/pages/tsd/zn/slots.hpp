// The eight zones as buttons: number 2 at T1, 1 at T2, 3-8 at L1-L6. White while empty, boxed while chosen.
#define ZN_SLOT_L(name, num, posY, valueIdx, textIdx) class name { \
    class Empty { \
        condition = C_COND(C_LESS(C_MPD_USER(valueIdx), 0.5)); \
        color[] = MPD_COLOUR_WHITE; \
        MPD_TEXT_R(name, MPD_POS_BUTTON_L_X, posY, MPD_TEXT_USER(textIdx)) \
    }; \
    class Drawn { \
        condition = C_COND(C_MORE(C_MPD_USER(valueIdx), 0.5)); \
        MPD_TEXT_R(name, MPD_POS_BUTTON_L_X, posY, MPD_TEXT_USER(textIdx)) \
    }; \
    class Chosen { \
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_ZN_SEL), num)); \
        MPD_BOX_R(name, MPD_POS_BUTTON_L_X, posY, 4) \
    }; \
};
#define ZN_SLOT_T(name, num, posX, valueIdx, textIdx) class name { \
    class Empty { \
        condition = C_COND(C_LESS(C_MPD_USER(valueIdx), 0.5)); \
        color[] = MPD_COLOUR_WHITE; \
        MPD_TEXT_C(name, posX, MPD_POS_BUTTON_T_Y, MPD_TEXT_USER(textIdx)) \
    }; \
    class Drawn { \
        condition = C_COND(C_MORE(C_MPD_USER(valueIdx), 0.5)); \
        MPD_TEXT_C(name, posX, MPD_POS_BUTTON_T_Y, MPD_TEXT_USER(textIdx)) \
    }; \
    class Chosen { \
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_ZN_SEL), num)); \
        MPD_BOX_C(name, posX, MPD_POS_BUTTON_T_Y, 4) \
    }; \
};

ZN_SLOT_T(Slot1, 1, MPD_POS_BUTTON_TB_2_X, MFD_IND_TSD_ZN_SLOT_1, 0)
ZN_SLOT_T(Slot2, 2, MPD_POS_BUTTON_TB_1_X, MFD_IND_TSD_ZN_SLOT_2, 1)
ZN_SLOT_L(Slot3, 3, MPD_POS_BUTTON_LR_1_Y, MFD_IND_TSD_ZN_SLOT_3, 2)
ZN_SLOT_L(Slot4, 4, MPD_POS_BUTTON_LR_2_Y, MFD_IND_TSD_ZN_SLOT_4, 3)
ZN_SLOT_L(Slot5, 5, MPD_POS_BUTTON_LR_3_Y, MFD_IND_TSD_ZN_SLOT_5, 4)
ZN_SLOT_L(Slot6, 6, MPD_POS_BUTTON_LR_4_Y, MFD_IND_TSD_ZN_SLOT_6, 5)
ZN_SLOT_L(Slot7, 7, MPD_POS_BUTTON_LR_5_Y, MFD_IND_TSD_ZN_SLOT_7, 6)
ZN_SLOT_L(Slot8, 8, MPD_POS_BUTTON_LR_6_Y, MFD_IND_TSD_ZN_SLOT_8, 7)

#undef ZN_SLOT_L
#undef ZN_SLOT_T
