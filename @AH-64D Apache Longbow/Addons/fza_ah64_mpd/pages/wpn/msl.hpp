class VABs_Mode_Msl {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN), 3));
    MPD_TEXT_L(Mode_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MODE"))
    MPD_BOX_L(Mode, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 3)
    MPD_TEXT_L(Mode, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MAN"))
};

class VABs_Mode_Msl_SAL {
    condition = C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN), 3), C_NOT(C_MPD_USER(MFD_IND_WPN_MSL_SELECTED_TYPE))));

    class NoChannelMenuPage {
        condition = C_COND(C_NOT(C_OR(C_EQ(C_MPD_USER(MFD_IND_WPN_MSL_MENU), 1), C_EQ(C_MPD_USER(MFD_IND_WPN_MSL_MENU), 2)))));

        MPD_TEXT_R(Pri_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PRI"))
        class Pri_Sel {
            condition = C_COND(C_NOT(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_PRI_CH), 0)));
            MPD_BOX_R(Pri, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 1)
            MPD_TEXT_R(Pri, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_MSL_PRI_CODE))
        };
        class Pri_None {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_PRI_CH), 0));
            MPD_BOX_R(Pri, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 4)
            MPD_TEXT_R(Pri, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(NONE))
            
            // If Pri is doesn't have a code then alt is barred out
            MPD_BOX_BAR_R(AltBar, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y)
        }

        MPD_TEXT_R(ALT_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ALT"))
        class Alt_Sel {
            condition = C_COND(C_NOT(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_ALT_CH), 0)));
            MPD_BOX_R(ALT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 1)
            MPD_TEXT_R(ALT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_MSL_ALT_CODE))
        };
        class Alt_None {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_ALT_CH), 0));
            MPD_BOX_R(ALT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 4)
            MPD_TEXT_R(ALT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(NONE))
        };

        MPD_TEXT_R(SAL_SEL_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SAL SEL"))
        MPD_BOX_R(SAL_SEL, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT, 4)
        MPD_TEXT_R(SAL_SEL, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_MSL_SAL_SEL))

        MPD_TEXT_R(DEICE, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("DEICE"))
    };

    #define CHAN_SELECT(posY,codeStrIndex,chanNum,selectIndex) \
        class Chan##chanNum { \
            class Selected { \
                condition = C_COND(C_EQ(C_MPD_USER(selectIndex), chanNum)); \
                class Box { \
                    type = line; \
                    width = 3; \
                    points[] = { \
                        {{MPD_POS_BUTTON_L_X - 0.01, posY - 0.5 * MPD_TEXT_HEIGHT}, 1},\
                        {{MPD_POS_BUTTON_L_X + 0.01 + 3 * MPD_TEXT_WIDTH, posY - 0.5 * MPD_TEXT_HEIGHT}, 1},\
                        {{MPD_POS_BUTTON_L_X + 0.01 + 3 * MPD_TEXT_WIDTH, posY + 1.5 * MPD_TEXT_HEIGHT}, 1},\
                        {{MPD_POS_BUTTON_L_X - 0.01, posY + 1.5 * MPD_TEXT_HEIGHT}, 1},\
                        {{MPD_POS_BUTTON_L_X - 0.01, posY - 0.5 * MPD_TEXT_HEIGHT}, 1}\
                    }; \
                }; \
            }; \
            class PriTag { \
                condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_PRI_CH), chanNum)); \
                MPD_TEXT_R(Pri, MPD_POS_BUTTON_L_X, posY - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PRI")) \
            }; \
            class AltTag { \
                condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_ALT_CH), chanNum)); \
                MPD_TEXT_R(Alt, MPD_POS_BUTTON_L_X, posY - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ALT")) \
            }; \
            class UnSelTag { \
                condition = C_COND(C_NOT(C_OR(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_PRI_CH), chanNum),C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_ALT_CH), chanNum)))); \
                MPD_TEXT_R(Alt, MPD_POS_BUTTON_L_X, posY - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(__EVAL(format["CHAN %1" COMMA chanNum]))) \
            }; \
            MPD_TEXT_R(Chan, MPD_POS_BUTTON_L_X, posY + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_USER(codeStrIndex)) \
        }; 
    #define NONE_SELECT(posY,selectIndex) \
        class ChanNone { \
            class Selected { \
                condition = C_COND(C_EQ(C_MPD_USER(selectIndex), 0)); \
                MPD_BOX_R(Selected, MPD_POS_BUTTON_L_X, posY + 0.5 * MPD_TEXT_HEIGHT, 4) \
            }; \
            MPD_TEXT_R(Chan, MPD_POS_BUTTON_L_X, posY + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("NONE")) \
        } 
    class PriChanSelect {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_MSL_MENU), 1));
        
        class Box {
            type = line;
            width = 3;
            points[] =
                { {{0.02, 0.15}, 1}
                , {{0.16, 0.15}, 1}
                , {{0.16, 0.445-4*MPD_TEXT_HEIGHT}, 1}
                , {}
                , {{0.16, 0.445+4*MPD_TEXT_HEIGHT}, 1}
                , {{0.16, 0.745}, 1}
                , {{0.02, 0.745}, 1}
                };
        };

        MPD_TEXT_R(Label_1, 0.16, 0.445-4*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("P"))
        MPD_TEXT_R(Label_2, 0.16, 0.445-3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("R"))
        MPD_TEXT_R(Label_3, 0.16, 0.445-2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("I"))
        MPD_TEXT_R(Label_4, 0.16, 0.445-1*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_R(Label_5, 0.16, 0.445-0*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("R"))
        MPD_TEXT_R(Label_6, 0.16, 0.445+1*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("I"))
        MPD_TEXT_R(Label_7, 0.16, 0.445+2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(Label_8, 0.16, 0.445+3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Y"))

        CHAN_SELECT(MPD_POS_BUTTON_LR_1_Y, MFD_TEXT_IND_WPN_MSL_CHAN_1_CODE,1,MFD_IND_WPN_SELECTED_PRI_CH)
        CHAN_SELECT(MPD_POS_BUTTON_LR_2_Y, MFD_TEXT_IND_WPN_MSL_CHAN_2_CODE,2,MFD_IND_WPN_SELECTED_PRI_CH)
        CHAN_SELECT(MPD_POS_BUTTON_LR_3_Y, MFD_TEXT_IND_WPN_MSL_CHAN_3_CODE,3,MFD_IND_WPN_SELECTED_PRI_CH)
        CHAN_SELECT(MPD_POS_BUTTON_LR_4_Y, MFD_TEXT_IND_WPN_MSL_CHAN_4_CODE,4,MFD_IND_WPN_SELECTED_PRI_CH)
        NONE_SELECT(MPD_POS_BUTTON_LR_5_Y, MFD_IND_WPN_SELECTED_PRI_CH)
    };
    class AltChanSelect {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_MSL_MENU), 2));
        
        class Box {
            type = line;
            width = 3;
            points[] =
                { {{0.02, 0.15}, 1}
                , {{0.16, 0.15}, 1}
                , {{0.16, 0.445-4.5*MPD_TEXT_HEIGHT}, 1}
                , {}
                , {{0.16, 0.445+4.5*MPD_TEXT_HEIGHT}, 1}
                , {{0.16, 0.745}, 1}
                , {{0.02, 0.745}, 1}
                };
        };

        MPD_TEXT_R(Label_1, 0.16, 0.445-4.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(Label_2, 0.16, 0.445-3.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
        MPD_TEXT_R(Label_3, 0.16, 0.445-2.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(Label_4, 0.16, 0.445-1.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
        MPD_TEXT_R(Label_5, 0.16, 0.445-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("R"))
        MPD_TEXT_R(Label_6, 0.16, 0.445+0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("N"))
        MPD_TEXT_R(Label_7, 0.16, 0.445+1.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(Label_8, 0.16, 0.445+2.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(Label_9, 0.16, 0.445+3.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))

        CHAN_SELECT(MPD_POS_BUTTON_LR_1_Y, MFD_TEXT_IND_WPN_MSL_CHAN_1_CODE,1,MFD_IND_WPN_SELECTED_ALT_CH)
        CHAN_SELECT(MPD_POS_BUTTON_LR_2_Y, MFD_TEXT_IND_WPN_MSL_CHAN_2_CODE,2,MFD_IND_WPN_SELECTED_ALT_CH)
        CHAN_SELECT(MPD_POS_BUTTON_LR_3_Y, MFD_TEXT_IND_WPN_MSL_CHAN_3_CODE,3,MFD_IND_WPN_SELECTED_ALT_CH)
        CHAN_SELECT(MPD_POS_BUTTON_LR_4_Y, MFD_TEXT_IND_WPN_MSL_CHAN_4_CODE,4,MFD_IND_WPN_SELECTED_ALT_CH)
        NONE_SELECT(MPD_POS_BUTTON_LR_5_Y, MFD_IND_WPN_SELECTED_ALT_CH)
    };

    MPD_TEXT_R(MSL_CCM, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC(" MSL CCM"))

    class MSL_CCM_Circle {
        type = line;
        width = 3;
        points[] = {
            MPD_POINTS_CURVED_CORNER(Null, MPD_POS_BUTTON_L_X + 0.35*MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, 0.35*MPD_TEXT_WIDTH, 0.35*MPD_TEXT_WIDTH), {},
            MPD_POINTS_CURVED_CORNER(Null, MPD_POS_BUTTON_L_X + 0.35*MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, 0.35*MPD_TEXT_WIDTH, -0.35*MPD_TEXT_WIDTH), {},
            MPD_POINTS_CURVED_CORNER(Null, MPD_POS_BUTTON_L_X + 0.35*MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, -0.35*MPD_TEXT_WIDTH, 0.35*MPD_TEXT_WIDTH), {},
            MPD_POINTS_CURVED_CORNER(Null, MPD_POS_BUTTON_L_X + 0.35*MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, -0.35*MPD_TEXT_WIDTH, -0.35*MPD_TEXT_WIDTH), {},
        };
    };

    MPD_TEXT_L(Type_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TYPE"))
    MPD_BOX_L(Type, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 3)
    MPD_TEXT_L(Type, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SAL"))

    MPD_TEXT_L(Traj_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TRAJ"))
    MPD_BOX_L(Traj, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT, 3)
    MPD_TEXT_L(Traj, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_MSL_TRAJ))

    MPD_TEXT_C(HFMSN, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("HFMSN"))

    // Missile Channels
    class Static {
        type = line;
        width = 3;
        points[] = {
            MPD_POINTS_BOX_PAD_EXTERNAL(Null, 0.275, 0.76, 0.45, 0.15, 0.02)
        };
    };

    MPD_TEXT_C(Channels, 0.5, 0.76, MPD_TEXT_STATIC("CHANNELS"))

    #define WPN_MISSILE_CHANNEL(className, posX, channelNum, textSourceInd) \
    class className {\
        class Pri {\
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_PRI_CH), channelNum));\
            color[] = {1,1,1,1};\
            MPD_TEXT_C(Label, posX, 0.77+MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PRI"))\
            MPD_TEXT_C(Value, posX, 0.77+2*MPD_TEXT_HEIGHT, MPD_TEXT_USER(textSourceInd))\
            class Box {\
                type = line;\
                width = 3;\
                points[] = {\
                    {{posX - 1.5 * MPD_TEXT_WIDTH - 0.01, 0.77+MPD_TEXT_HEIGHT}, 1},\
                    {{posX + 1.5 * MPD_TEXT_WIDTH + 0.01, 0.77+MPD_TEXT_HEIGHT}, 1},\
                    {{posX + 1.5 * MPD_TEXT_WIDTH + 0.01, 0.77+3*MPD_TEXT_HEIGHT}, 1},\
                    {{posX - 1.5 * MPD_TEXT_WIDTH - 0.01, 0.77+3*MPD_TEXT_HEIGHT}, 1},\
                    {{posX - 1.5 * MPD_TEXT_WIDTH - 0.01, 0.77+MPD_TEXT_HEIGHT}, 1}\
                };\
            };\
        };\
        class Alt {\
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_ALT_CH), channelNum));\
            MPD_TEXT_C(Label, posX, 0.77+MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ALT"))\
            MPD_TEXT_C(Value, posX, 0.77+2*MPD_TEXT_HEIGHT, MPD_TEXT_USER(textSourceInd))\
            class Box {\
            type = line;\
            width = 3;\
            points[] = {\
                    {{posX - 1.5 * MPD_TEXT_WIDTH - 0.01, 0.77+MPD_TEXT_HEIGHT}, 1},\
                    {{posX + 1.5 * MPD_TEXT_WIDTH + 0.01, 0.77+MPD_TEXT_HEIGHT}, 1},\
                    {{posX + 1.5 * MPD_TEXT_WIDTH + 0.01, 0.77+3*MPD_TEXT_HEIGHT}, 1},\
                    {{posX - 1.5 * MPD_TEXT_WIDTH - 0.01, 0.77+3*MPD_TEXT_HEIGHT}, 1},\
                    {{posX - 1.5 * MPD_TEXT_WIDTH - 0.01, 0.77+MPD_TEXT_HEIGHT}, 1}\
                };\
            };\
        };\
        class Unused {\
            condition = C_COND(C_NOT(C_OR(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_ALT_CH), channelNum), C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_PRI_CH), channelNum))));\
            MPD_TEXT_C(Label, posX, 0.77+MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(channelNum))\
            MPD_TEXT_C(Value, posX, 0.77+2*MPD_TEXT_HEIGHT, MPD_TEXT_USER(textSourceInd))\
        };\
    };

    WPN_MISSILE_CHANNEL(Channel_1, 0.335, 1, MFD_TEXT_IND_WPN_MSL_CHAN_1_CODE)
    WPN_MISSILE_CHANNEL(Channel_2, 0.445, 2, MFD_TEXT_IND_WPN_MSL_CHAN_2_CODE)
    WPN_MISSILE_CHANNEL(Channel_3, 0.555, 3, MFD_TEXT_IND_WPN_MSL_CHAN_3_CODE)
    WPN_MISSILE_CHANNEL(Channel_4, 0.665, 4, MFD_TEXT_IND_WPN_MSL_CHAN_4_CODE)
};

class VABs_Mode_Msl_Rf {
    condition = C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN), 3), C_MPD_USER(MFD_IND_WPN_MSL_SELECTED_TYPE)));
    MPD_TEXT_R(Msl_Pwr_All, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_STATIC("ALL"))
    MPD_TEXT_R(Msl_Pwr_Auto, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("AUTO"))
    MPD_BOX_R(Msl_Pwr_Auto, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, 4)
    MPD_TEXT_R(Msl_Pwr_None, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("NONE"))

    MPD_TEXT_R(Msl_Pwr_Label_1, 0.11, MPD_POS_BUTTON_LR_2_Y - 3 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))
    MPD_TEXT_R(Msl_Pwr_Label_2, 0.11, MPD_POS_BUTTON_LR_2_Y - 2 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
    MPD_TEXT_R(Msl_Pwr_Label_3, 0.11, MPD_POS_BUTTON_LR_2_Y - 1 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
    MPD_TEXT_R(Msl_Pwr_Label_4, 0.11, MPD_POS_BUTTON_LR_2_Y + 1 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("P"))
    MPD_TEXT_R(Msl_Pwr_Label_5, 0.11, MPD_POS_BUTTON_LR_2_Y + 2 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("W"))
    MPD_TEXT_R(Msl_Pwr_Label_6, 0.11, MPD_POS_BUTTON_LR_2_Y + 3 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("R"))

    class Static {
        type = line;
        width = 3;
        points[] = {
            {{0.02,MPD_POS_BUTTON_LR_1_Y - MPD_TEXT_HEIGHT}, 1},
            {{0.11,MPD_POS_BUTTON_LR_1_Y - MPD_TEXT_HEIGHT}, 1},
            {{0.11,MPD_POS_BUTTON_LR_2_Y - 3*MPD_TEXT_HEIGHT}, 1}, {},
            {{0.11,MPD_POS_BUTTON_LR_2_Y + 4*MPD_TEXT_HEIGHT}, 1},
            {{0.11,MPD_POS_BUTTON_LR_3_Y + 2*MPD_TEXT_HEIGHT}, 1},
            {{0.02,MPD_POS_BUTTON_LR_3_Y + 2*MPD_TEXT_HEIGHT}, 1}
        };
    };

    MPD_TEXT_R(LOBL_INHIBIT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("LOBL INHIBIT"))
    MPD_TEXT_R(SECOND_TARGET_INHIBIT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("2ND TARGET INHIBIT"))

    MPD_TEXT_L(Type_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TYPE"))
    MPD_BOX_L(Type, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 2)
    MPD_TEXT_L(Type, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("RF"))
};