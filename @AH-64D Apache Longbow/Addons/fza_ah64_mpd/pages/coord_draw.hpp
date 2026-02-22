#include "\fza_ah64_mpd\headers\mfdConstants.h"

MPD_TEXT_C(TSD, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("TSD"))

MPD_TEXT_C(SRCHTEXT, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT + 0.01, MPD_TEXT_STATIC("SRCH>"))
MPD_TEXT_C(SRCHICON, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("?"))

MPD_ARROW_C(THRT, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 4)
MPD_TEXT_C(THRT,  MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("FARM"))

MPD_TEXT_C(PAGE, ((MPD_POS_BUTTON_TB_2_X + MPD_POS_BUTTON_TB_3_X)/2), MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT + 0.01, MPD_TEXT_STATIC("PAGE"))
MPD_TEXT_C(PAGE_NUMB, ((MPD_POS_BUTTON_TB_2_X + MPD_POS_BUTTON_TB_3_X)/2), MPD_POS_BUTTON_B_Y, MPD_TEXT_USER(MFD_TEXT_COORD_PAGENUM))

MPD_ARROW_C(WPTHZ, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 5)
MPD_TEXT_C(WPTHZ,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("WPTHZ"))

MPD_ARROW_C(CTRLM, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 5)
MPD_TEXT_C(CTRLM,  MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("CTRLM"))

MPD_ARROW_C(LINE, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, 5)
MPD_TEXT_C(LINE,  MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("LINE"))

MPD_ARROW_C(AREA, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 5)
MPD_TEXT_C(AREA,  MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("AREA"))

MPD_ARROW_C(COORD, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, 5)
MPD_TEXT_C(COORD,  MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("COORD"))

MPD_ARROW_C(SHOT, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 5)
MPD_TEXT_C(SHOT,  MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("SHOT"))

MPD_TEXT_C(TARGETSANDTHREATS, 0.5, 0.09, MPD_TEXT_STATIC("TARGETS AND THREATS"))

class lines {
    type = line;
    width = 3;
    points[] = {
        MPD_POINTS_BOX(Null, (0.5 - MPD_TEXT_WIDTH * 9.5), 0.09, (19.5 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT),//Title Box
        {},
        {{0.278, 0.966}, 1},//left scroll arrow
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
        {{0.502, 0.966}, 1},//right scroll arrow
        {{0.478, 0.951}, 1},
        {{0.472, 0.951}, 1},
        {{0.472, 0.959}, 1},
        {{0.454, 0.959}, 1},
        {{0.454, 0.975}, 1},
        {{0.472, 0.975}, 1},
        {{0.472, 0.983}, 1},
        {{0.478, 0.983}, 1},
        {{0.502, 0.966}, 1},
        {},
    };
};

class CoordPageTextlines {

    MPD_TEXT_C(CPTL0,  0.5, MPD_POS_BUTTON_TB_1_X - 0.04      ,   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_0))
    MPD_TEXT_C(CPTL1,  0.5, MPD_POS_BUTTON_TB_1_X             ,   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_1))
    MPD_TEXT_C(CPTL2,  0.5, MPD_POS_BUTTON_TB_1_X + 0.04      ,   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_2))
    MPD_TEXT_C(CPTL3,  0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 2),   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_3))
    MPD_TEXT_C(CPTL4,  0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 3),   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_4))
    MPD_TEXT_C(CPTL5,  0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 4),   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_5))
    MPD_TEXT_C(CPTL6,  0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 5),   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_6))
    MPD_TEXT_C(CPTL7,  0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 6),   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_7))
    MPD_TEXT_C(CPTL8,  0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 7),   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_8))
    MPD_TEXT_C(CPTL9,  0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 8),   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_9))
    MPD_TEXT_C(CPTL10, 0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 9),   MPD_TEXT_USER(MFD_TEXT_COORD_LINE_10))
    MPD_TEXT_C(CPTL11, 0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 10),  MPD_TEXT_USER(MFD_TEXT_COORD_LINE_11))
    MPD_TEXT_C(CPTL12, 0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 11),  MPD_TEXT_USER(MFD_TEXT_COORD_LINE_12))
    MPD_TEXT_C(CPTL13, 0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 12),  MPD_TEXT_USER(MFD_TEXT_COORD_LINE_13))
    MPD_TEXT_C(CPTL14, 0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 13),  MPD_TEXT_USER(MFD_TEXT_COORD_LINE_14))
    MPD_TEXT_C(CPTL15, 0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 14),  MPD_TEXT_USER(MFD_TEXT_COORD_LINE_15))
    MPD_TEXT_C(CPTL16, 0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 15),  MPD_TEXT_USER(MFD_TEXT_COORD_LINE_16))
    MPD_TEXT_C(CPTL17, 0.5, MPD_POS_BUTTON_TB_1_X + (0.04 * 16),  MPD_TEXT_USER(MFD_TEXT_COORD_LINE_17))
};

class PageSelect {
    class WPTHZ {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_TYPE), 1));
        MPD_BOX_TALL_C(WPTHZBOX, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 5)
    };
    class CTRLM {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_TYPE), 2));
        MPD_BOX_TALL_C(WPTHZBOX, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 5)
    };
    class line {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_TYPE), 3));
        MPD_BOX_TALL_C(LINEBOX, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, 5)
    };
    class area {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_TYPE), 4));
        MPD_BOX_TALL_C(AREABOX, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 5)
    };
    class coord {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_TYPE), 5));
        MPD_BOX_TALL_C(COORD, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, 5)
    };
    class shotat {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_TYPE), 6));
        MPD_BOX_TALL_C(SHOT, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
    };
};

class pointSelect {
    class point1 {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_POINT), 1));
            class box {
            type=line;
            width=3;
            points[] = {
                MPD_POINTS_BOX(Null, (0.5 - (35 * MPD_TEXT_WIDTH / 2)), (MPD_POS_BUTTON_TB_1_X - MPD_TEXT_HEIGHT), (35 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT * 3)
            };
        };
    };
    class point2 {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_POINT), 2));
            class box {
            type=line;
            width=3;
            points[] = {
                MPD_POINTS_BOX(Null, (0.5 - (35 * MPD_TEXT_WIDTH / 2)), (MPD_POS_BUTTON_TB_2_X - MPD_TEXT_HEIGHT), (35 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT * 3)
            };
        };
    };
    class point3 {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_POINT), 3));
            class box {
            type=line;
            width=3;
            points[] = {
                MPD_POINTS_BOX(Null, (0.5 - (35 * MPD_TEXT_WIDTH / 2)), (MPD_POS_BUTTON_TB_3_X - MPD_TEXT_HEIGHT), (35 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT * 3)
            };
        };
    };
    class point4 {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_POINT), 4));
            class box {
            type=line;
            width=3;
            points[] = {
                MPD_POINTS_BOX(Null, (0.5 - (35 * MPD_TEXT_WIDTH / 2)), (MPD_POS_BUTTON_TB_4_X - MPD_TEXT_HEIGHT), (35 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT * 3)
            };
        };
    };
    class point5 {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_POINT), 5));
            class box {
            type=line;
            width=3;
            points[] = {
                MPD_POINTS_BOX(Null, (0.5 - (35 * MPD_TEXT_WIDTH / 2)), (MPD_POS_BUTTON_TB_5_X - MPD_TEXT_HEIGHT), (35 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT * 3)
            };
        };
    };
    class point6 {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_COORD_PAGE_POINT), 6));
            class box {
            type=line;
            width=3;
            points[] = {
                MPD_POINTS_BOX(Null, (0.5 - (35 * MPD_TEXT_WIDTH / 2)), (MPD_POS_BUTTON_TB_6_X - MPD_TEXT_HEIGHT), (35 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT * 3)
            };
        };
    };
};