// The route menu: five routes a page under T1-T5, each window its first six points
#define RTM_ROW_Y(row) (0.14 + (row) * 0.05)
#define RTM_WINDOW(posX) MPD_POINTS_BOX_PAD("Null", (posX) - 0.04, 0.14, 0.08, 0.30, 0.012)
#define RTM_POINT(name, posX, row, slot) MPD_TEXT_C(name, posX, RTM_ROW_Y(row), MPD_TEXT_USER(slot))
#define RTM_CURRENT(name, column, posX) class name { \
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_RTM_CURRENT), column)); \
    MPD_BOX_C(name, posX, MPD_POS_BUTTON_T_Y, 5) \
    MPD_TEXT_C(name, posX, 0.072, MPD_TEXT_STATIC("CURRENT")) \
};

class rtm {
    class windows {
        type = "line";
        width = 3;
        points[] = {
            RTM_WINDOW(MPD_POS_BUTTON_TB_1_X), {},
            RTM_WINDOW(MPD_POS_BUTTON_TB_2_X), {},
            RTM_WINDOW(MPD_POS_BUTTON_TB_3_X), {},
            RTM_WINDOW(MPD_POS_BUTTON_TB_4_X), {},
            RTM_WINDOW(MPD_POS_BUTTON_TB_5_X), {},
            // L4-L5 RTE bracket
            {{0.0, 0.525}, 1}, {{0.17, 0.525}, 1}, {{0.17, 0.565}, 1}, {},
            {{0.17, 0.69}, 1}, {{0.17, 0.74}, 1}, {{0.0, 0.74}, 1}, {},
            // B2, B3 page arrows
            {{0.278, 0.966}, 1},
            {{0.302, 0.951}, 1},
            {{0.308, 0.951}, 1},
            {{0.308, 0.959}, 1},
            {{0.326, 0.959}, 1},
            {{0.326, 0.975}, 1},
            {{0.308, 0.975}, 1},
            {{0.308, 0.983}, 1},
            {{0.302, 0.983}, 1},
            {{0.278, 0.966}, 1},
            {},
            {{0.502, 0.966}, 1},
            {{0.478, 0.951}, 1},
            {{0.472, 0.951}, 1},
            {{0.472, 0.959}, 1},
            {{0.454, 0.959}, 1},
            {{0.454, 0.975}, 1},
            {{0.472, 0.975}, 1},
            {{0.472, 0.983}, 1},
            {{0.478, 0.983}, 1},
            {{0.502, 0.966}, 1}
        };
    };

    class vabs {
        //T1-T5
        MPD_TEXT_C(RtmName1, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTM_NAME_1))
        MPD_TEXT_C(RtmName2, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTM_NAME_1 + 1))
        MPD_TEXT_C(RtmName3, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTM_NAME_1 + 2))
        MPD_TEXT_C(RtmName4, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTM_NAME_1 + 3))
        MPD_TEXT_C(RtmName5, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTM_NAME_1 + 4))
        //T6
        MPD_BOX_BAR_T(RtmUtil, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        MPD_TEXT_C(RtmUtil, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))

        //L4, L5
        class NewBox {
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_TSD_RTM_DELETE)));
            MPD_BOX_R(RtmNew, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 3)
        };
        class DeleteBox {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_RTM_DELETE));
            MPD_BOX_R(RtmDelete, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, 6)
        };
        MPD_TEXT_R(RtmNew, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("NEW"))
        MPD_TEXT_R(RtmDelete, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("DELETE"))
        MPD_TEXT_C(RtmBracket1, 0.17, 0.570, MPD_TEXT_STATIC("R"))
        MPD_TEXT_C(RtmBracket2, 0.17, 0.606, MPD_TEXT_STATIC("T"))
        MPD_TEXT_C(RtmBracket3, 0.17, 0.642, MPD_TEXT_STATIC("E"))
        //L6
        MPD_BOX_TALL_R(RtmMenu, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 10)
        MPD_ARROW_R(RtmMenu, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 10)
        MPD_TEXT_R(RtmMenu, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("ROUTE MENU"))
        //R5
        MPD_TEXT_L(RtmReverse, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("REVERSE"))
        MPD_TEXT_L(RtmReverseRoute, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ROUTE"))

        //B1
        MPD_TEXT_C(RtmTsd, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("TSD"))
        //B2, B3
        MPD_TEXT_C(RtmPage, ((MPD_POS_BUTTON_TB_2_X + MPD_POS_BUTTON_TB_3_X) / 2), MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT + 0.01, MPD_TEXT_STATIC("PAGE"))
        MPD_TEXT_C(RtmPageNum, ((MPD_POS_BUTTON_TB_2_X + MPD_POS_BUTTON_TB_3_X) / 2), MPD_POS_BUTTON_B_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTM_PAGE))
        MPD_BOLD_PAGE_SCROLL
        //B4
        MPD_ARROW_C(RtmWpt, MPD_POS_BUTTON_TB_4_X + 0.015, MPD_POS_BUTTON_B_Y, 3)
        MPD_TEXT_C(RtmWpt, MPD_POS_BUTTON_TB_4_X + 0.015, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("WPT"))
        //B5
        MPD_BOX_TALL_C(RtmRte, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 3)
        MPD_ARROW_C(RtmRte, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 3)
        MPD_TEXT_C(RtmRte, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("RTE"))
        //B6
        MPD_ARROW_C(RtmThrt, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, 4)
        MPD_TEXT_C(RtmThrt, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("THRT"))
    };

    RTM_CURRENT(RtmCurrent1, 0, MPD_POS_BUTTON_TB_1_X)
    RTM_CURRENT(RtmCurrent2, 1, MPD_POS_BUTTON_TB_2_X)
    RTM_CURRENT(RtmCurrent3, 2, MPD_POS_BUTTON_TB_3_X)
    RTM_CURRENT(RtmCurrent4, 3, MPD_POS_BUTTON_TB_4_X)
    RTM_CURRENT(RtmCurrent5, 4, MPD_POS_BUTTON_TB_5_X)

    class points {
        RTM_POINT(RtmP10, MPD_POS_BUTTON_TB_1_X, 0, MFD_TEXT_IND_TSD_RTM_COL_1)
        RTM_POINT(RtmP11, MPD_POS_BUTTON_TB_1_X, 1, MFD_TEXT_IND_TSD_RTM_COL_1 + 1)
        RTM_POINT(RtmP12, MPD_POS_BUTTON_TB_1_X, 2, MFD_TEXT_IND_TSD_RTM_COL_1 + 2)
        RTM_POINT(RtmP13, MPD_POS_BUTTON_TB_1_X, 3, MFD_TEXT_IND_TSD_RTM_COL_1 + 3)
        RTM_POINT(RtmP14, MPD_POS_BUTTON_TB_1_X, 4, MFD_TEXT_IND_TSD_RTM_COL_1 + 4)
        RTM_POINT(RtmP15, MPD_POS_BUTTON_TB_1_X, 5, MFD_TEXT_IND_TSD_RTM_COL_1 + 5)

        RTM_POINT(RtmP20, MPD_POS_BUTTON_TB_2_X, 0, MFD_TEXT_IND_TSD_RTM_COL_2)
        RTM_POINT(RtmP21, MPD_POS_BUTTON_TB_2_X, 1, MFD_TEXT_IND_TSD_RTM_COL_2 + 1)
        RTM_POINT(RtmP22, MPD_POS_BUTTON_TB_2_X, 2, MFD_TEXT_IND_TSD_RTM_COL_2 + 2)
        RTM_POINT(RtmP23, MPD_POS_BUTTON_TB_2_X, 3, MFD_TEXT_IND_TSD_RTM_COL_2 + 3)
        RTM_POINT(RtmP24, MPD_POS_BUTTON_TB_2_X, 4, MFD_TEXT_IND_TSD_RTM_COL_2 + 4)
        RTM_POINT(RtmP25, MPD_POS_BUTTON_TB_2_X, 5, MFD_TEXT_IND_TSD_RTM_COL_2 + 5)

        RTM_POINT(RtmP30, MPD_POS_BUTTON_TB_3_X, 0, MFD_TEXT_IND_TSD_RTM_COL_3)
        RTM_POINT(RtmP31, MPD_POS_BUTTON_TB_3_X, 1, MFD_TEXT_IND_TSD_RTM_COL_3 + 1)
        RTM_POINT(RtmP32, MPD_POS_BUTTON_TB_3_X, 2, MFD_TEXT_IND_TSD_RTM_COL_3 + 2)
        RTM_POINT(RtmP33, MPD_POS_BUTTON_TB_3_X, 3, MFD_TEXT_IND_TSD_RTM_COL_3 + 3)
        RTM_POINT(RtmP34, MPD_POS_BUTTON_TB_3_X, 4, MFD_TEXT_IND_TSD_RTM_COL_3 + 4)
        RTM_POINT(RtmP35, MPD_POS_BUTTON_TB_3_X, 5, MFD_TEXT_IND_TSD_RTM_COL_3 + 5)

        RTM_POINT(RtmP40, MPD_POS_BUTTON_TB_4_X, 0, MFD_TEXT_IND_TSD_RTM_COL_4)
        RTM_POINT(RtmP41, MPD_POS_BUTTON_TB_4_X, 1, MFD_TEXT_IND_TSD_RTM_COL_4 + 1)
        RTM_POINT(RtmP42, MPD_POS_BUTTON_TB_4_X, 2, MFD_TEXT_IND_TSD_RTM_COL_4 + 2)
        RTM_POINT(RtmP43, MPD_POS_BUTTON_TB_4_X, 3, MFD_TEXT_IND_TSD_RTM_COL_4 + 3)
        RTM_POINT(RtmP44, MPD_POS_BUTTON_TB_4_X, 4, MFD_TEXT_IND_TSD_RTM_COL_4 + 4)
        RTM_POINT(RtmP45, MPD_POS_BUTTON_TB_4_X, 5, MFD_TEXT_IND_TSD_RTM_COL_4 + 5)

        RTM_POINT(RtmP50, MPD_POS_BUTTON_TB_5_X, 0, MFD_TEXT_IND_TSD_RTM_COL_5)
        RTM_POINT(RtmP51, MPD_POS_BUTTON_TB_5_X, 1, MFD_TEXT_IND_TSD_RTM_COL_5 + 1)
        RTM_POINT(RtmP52, MPD_POS_BUTTON_TB_5_X, 2, MFD_TEXT_IND_TSD_RTM_COL_5 + 2)
        RTM_POINT(RtmP53, MPD_POS_BUTTON_TB_5_X, 3, MFD_TEXT_IND_TSD_RTM_COL_5 + 3)
        RTM_POINT(RtmP54, MPD_POS_BUTTON_TB_5_X, 4, MFD_TEXT_IND_TSD_RTM_COL_5 + 4)
        RTM_POINT(RtmP55, MPD_POS_BUTTON_TB_5_X, 5, MFD_TEXT_IND_TSD_RTM_COL_5 + 5)
    };

    // A route to delete: its name at L1, YES at L2, NO at L3
    class Confirm {
        condition = C_COND(C_MPD_USER(MFD_IND_TSD_RTM_CONFIRM));
        class outline {
            type  = "line";
            width = 3;
            points[] = {
                {{0.0,   0.38 - 2.8*MPD_TEXT_HEIGHT}, 1},
                {{0.107, 0.38 - 2.8*MPD_TEXT_HEIGHT}, 1},
                {{0.107, 0.38 - 2.4*MPD_TEXT_HEIGHT}, 1}, {},
                {{0.0,   0.38 + 2.8*MPD_TEXT_HEIGHT}, 1},
                {{0.107, 0.38 + 2.8*MPD_TEXT_HEIGHT}, 1},
                {{0.107, 0.38 + 2.4*MPD_TEXT_HEIGHT}, 1}
            };
        };
        class vabs {
            //L1
            MPD_TEXT_R(RtmConfirmName, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_USER(MFD_TEXT_IND_TSD_RTM_CONFIRM))
            //L2
            MPD_TEXT_R(RtmYes, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("YES"))
            MPD_TEXT_R(RtmDel1, 0.107, 0.38 - 2.4 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("D"))
            MPD_TEXT_R(RtmDel2, 0.107, 0.38 - 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
            MPD_TEXT_R(RtmDel3, 0.107, 0.38 - 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
            MPD_TEXT_R(RtmDel4, 0.107, 0.38 + 0.0 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
            MPD_TEXT_R(RtmDel5, 0.107, 0.38 + 0.8 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
            MPD_TEXT_R(RtmDel6, 0.107, 0.38 + 1.6 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
            //L3
            MPD_TEXT_R(RtmNo, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("NO"))
        };
    };
};

#undef RTM_ROW_Y
#undef RTM_WINDOW
#undef RTM_POINT
#undef RTM_CURRENT
