#include "\fza_ah64_mpd\headers\mfdConstants.h"

MPD_TEXT_C(RPT, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("RPT"))
MPD_ARROW_C(RPT, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 3)

MPD_TEXT_C(ASE, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ASE"))
MPD_ARROW_C(ASE, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)

MPD_TEXT_C(ABR, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ABR"))
MPD_ARROW_C(ABR, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 3)
MPD_BOX_TALL_C(ABR, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 3)

MPD_TEXT_C(COORD, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("COORD"))
MPD_ARROW_C(COORD, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_T_Y, 5)

MPD_TEXT_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))
MPD_ARROW_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)

MPD_TEXT_C(THRT, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("THRT"))
MPD_ARROW_C(THRT, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, 4)

MPD_TEXT_C(RTE, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("RTE"))
MPD_ARROW_C(RTE, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 3)

MPD_TEXT_C(WPT, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("WPT"))
MPD_ARROW_C(WPT, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y, 3)

MPD_TEXT_C(PAGE, ((MPD_POS_BUTTON_TB_2_X + MPD_POS_BUTTON_TB_3_X)/2), MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT + 0.01, MPD_TEXT_STATIC("PAGE"))
MPD_TEXT_C(PAGE_NUMB, ((MPD_POS_BUTTON_TB_2_X + MPD_POS_BUTTON_TB_3_X)/2), MPD_POS_BUTTON_B_Y, MPD_TEXT_USER(MFD_IND_ABR_PAGENUM))

MPD_TEXT_C(TSD, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("TSD"))

MPD_TEXT_C(ABBREVIATIONS, 0.5, 0.09, MPD_TEXT_STATIC("ABBREVIATIONS"))

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

#define NUM_ROWS 17

#define START_X(lineId) (floor(lineId / NUM_ROWS)/2)

#define START_Y(lineId) (MPD_TEXT_HEIGHT * (lineId mod NUM_ROWS))

#define TEXT_DEF(lineId,lText,rText,classId) \
    MPD_TEXT_BONE_R(CONCAT_2(classId,L), ABR_Paging, (0.05+START_X(lineId))                      , (0.15+START_Y(lineId)), MPD_TEXT_STATIC(lText)) \
    MPD_TEXT_BONE_L(CONCAT_2(classId,R), ABR_Paging, (0.05+START_X(lineId)) + MPD_TEXT_WIDTH * 20, (0.15+START_Y(lineId)), MPD_TEXT_STATIC(rText))

#define HEADING_DEF(lineId, sectionName) \
    TEXT_DEF(lineId, sectionName, "",ABR_HEADING) \
    class Lines { type=line; width=3; points[] = \
        { {ABR_Paging,{0.05+START_X(lineId),0.15+START_Y(lineId)+MPD_TEXT_HEIGHT}, 1} \
        , {ABR_Paging,{0.05+START_X(lineId)+20*MPD_TEXT_WIDTH,0.15+START_Y(lineId)+MPD_TEXT_HEIGHT}, 1} \
        };};

#define START_SECTION(sectionId, sectionName, sectionColour) class Section##sectionId {\
    color[] = sectionColour; \
    HEADING_DEF(__COUNTER__, sectionName)

#define END_SECTION() };

#define ABBREVIATION(abbreviationName, abbreviationId) \
    TEXT_DEF(__COUNTER__, abbreviationName, #abbreviationId,abbreviationId)
    
#define BLANK_SPACE() class Blank##__COUNTER__ {};

__COUNTER_RESET__
#include "abr\definitions.hpp"