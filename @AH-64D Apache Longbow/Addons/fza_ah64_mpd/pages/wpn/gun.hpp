class VABs_Mode_Gun {
    condition =  __EVAL(format [STRINGIFY(EQ(user%1,1)), MFD_OFFSET + MFD_IND_WPN_SELECTED_WPN]);
    #define WPN_GUN_BURST_LIMIT(className, burstIndex, posY, numChars, burstName) \
    class className {\
        MPD_TEXT_R(Name, MPD_POS_BUTTON_L_X, posY, MPD_TEXT_STATIC(burstName)) \
        class Box {\
            condition =  __EVAL(format [STRINGIFY(EQ(user%1,burstIndex)), MFD_OFFSET + MFD_IND_WPN_SELECTED_BURST_LIMIT]);\
            MPD_BOX_R(Null, MPD_POS_BUTTON_L_X, posY, numChars)\
        };\
    };
   
    WPN_GUN_BURST_LIMIT(Burst_Limit_10, 0, MPD_POS_BUTTON_LR_1_Y, 2, "10")
    WPN_GUN_BURST_LIMIT(Burst_Limit_20, 1, MPD_POS_BUTTON_LR_2_Y, 2, "20")
    WPN_GUN_BURST_LIMIT(Burst_Limit_50, 2, MPD_POS_BUTTON_LR_3_Y, 2, "50")
    WPN_GUN_BURST_LIMIT(Burst_Limit_100, 3, MPD_POS_BUTTON_LR_4_Y, 3, "100")
    WPN_GUN_BURST_LIMIT(Burst_Limit_All, 4, MPD_POS_BUTTON_LR_5_Y, 3, "ALL")

    MPD_TEXT_R(Harmonize, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("HARMONIZE"))

    MPD_TEXT_R(Burst_Limit_Label_1, 0.11, MPD_POS_BUTTON_LR_3_Y - 5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("B"))
    MPD_TEXT_R(Burst_Limit_Label_2, 0.11, MPD_POS_BUTTON_LR_3_Y - 4*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("U"))
    MPD_TEXT_R(Burst_Limit_Label_3, 0.11, MPD_POS_BUTTON_LR_3_Y - 3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("R"))
    MPD_TEXT_R(Burst_Limit_Label_4, 0.11, MPD_POS_BUTTON_LR_3_Y - 2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
    MPD_TEXT_R(Burst_Limit_Label_5, 0.11, MPD_POS_BUTTON_LR_3_Y - 1*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
    MPD_TEXT_R(Burst_Limit_Label_6, 0.11, MPD_POS_BUTTON_LR_3_Y + 1*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
    MPD_TEXT_R(Burst_Limit_Label_7, 0.11, MPD_POS_BUTTON_LR_3_Y + 2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("I"))
    MPD_TEXT_R(Burst_Limit_Label_8, 0.11, MPD_POS_BUTTON_LR_3_Y + 3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))
    MPD_TEXT_R(Burst_Limit_Label_9, 0.11, MPD_POS_BUTTON_LR_3_Y + 4*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("I"))
    MPD_TEXT_R(Burst_Limit_Label_10, 0.11, MPD_POS_BUTTON_LR_3_Y + 5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))

    class Static {
        type = line;
        width = 3;
        points[] = {
            // Burst limit box
            {{0.02,MPD_POS_BUTTON_LR_1_Y - MPD_TEXT_HEIGHT}, 1},
            {{0.11,MPD_POS_BUTTON_LR_1_Y - MPD_TEXT_HEIGHT}, 1},
            {{0.11,MPD_POS_BUTTON_LR_3_Y - 5*MPD_TEXT_HEIGHT}, 1}, {},
            {{0.11,MPD_POS_BUTTON_LR_3_Y + 6*MPD_TEXT_HEIGHT}, 1},
            {{0.11,MPD_POS_BUTTON_LR_5_Y + 2*MPD_TEXT_HEIGHT}, 1},
            {{0.02,MPD_POS_BUTTON_LR_5_Y + 2*MPD_TEXT_HEIGHT}, 1}
        };
    };

    MPD_TEXT_L(Mode_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MODE"))
    MPD_BOX_L(Mode, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 4)
    MPD_TEXT_L(Mode, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("NORM"))
};