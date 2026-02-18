#include "\fza_ah64_mpd\headers\mfdConstants.h"

MPD_TEXT_C(COORD, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("COORD"))
MPD_ARROW_C(COORD, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, 5)
MPD_BOX_TALL_C(COORD, MPD_POS_BUTTON_TB_T_X, MPD_POS_BUTTON_T_Y, 5)

MPD_TEXT_C(TSD, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("TSD"))

MPD_TEXT_C(PAGE, ((MPD_POS_BUTTON_TB_2_X + MPD_POS_BUTTON_TB_3_X)/2), MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT + 0.01, MPD_TEXT_STATIC("PAGE"))
MPD_TEXT_C(PAGE_NUMB, ((MPD_POS_BUTTON_TB_2_X + MPD_POS_BUTTON_TB_3_X)/2), MPD_POS_BUTTON_B_Y, MPD_TEXT_USER(MFD_IND_COORD_PAGE))

class lines {
    type = line;
    width = 3;
    points[] = {
        MPD_POINTS_BOX(Null, (0.5 - MPD_TEXT_WIDTH * 6.5), 0.09, (13 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT),//Title Box
        {},
        {{0.495, 0.15}, 1},//left Vert line
        {{0.495, 0.90}, 1},
        {},
        {{0.505, 0.15}, 1},//Right vert line
        {{0.505, 0.90}, 1},
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