// The TSD frame, its range marks, scale boxes and heading boxes. mpd.hpp draws it in its own Draw class before the
// TSD's, so a label's black backing (MPD_TEXT_BACKING_R) on the page hides the frame behind the label.
#define MPD_TSD_SCALE_BOX(posX, posY, bone)\
    {"Tsd_Ownship", 1, {posX, posY}, 1},\
    {"Tsd_Ownship", 1, bone, {posX + MPD_TEXT_WIDTH + 0.01, posY}, 1},\
    {"Tsd_Ownship", 1, bone, {posX + MPD_TEXT_WIDTH + 0.01, posY + MPD_TEXT_HEIGHT}, 1},\
    {"Tsd_Ownship", 1, {posX, posY +MPD_TEXT_HEIGHT}, 1},\
    {"Tsd_Ownship", 1, {posX, posY}, 1}

class lines {
    type = "line";
    width = 3;
    points[] = {
        {{0.095, 0.095}, 1}, {{0.905, 0.095}, 1}, {{0.905, 0.905}, 1}, {{0.095, 0.905}, 1}, {{0.095, 0.095}, 1}, {}, //outside box

        {{0.095, 0.115}, 1}, {{0.08, 0.115}, 1}, {}, //Left 5km indicator
        {{0.095, 0.24}, 1}, {{0.08, 0.24}, 1}, {},   //Left 4km indicator
        {{0.095, 0.365}, 1}, {{0.08, 0.365}, 1}, {}, //Left 3km indicator
        {{0.095, 0.49}, 1}, {{0.08, 0.49}, 1}, {},   //Left 2km indicator
        {{0.095, 0.615}, 1}, {{0.08, 0.615}, 1}, {}, //Left 1km indicator
        {{0.095, 0.74}, 1}, {{0.08, 0.74}, 1}, {},   //Left 0km indicator
        {{0.095, 0.865}, 1}, {{0.08, 0.865}, 1}, {}, //Left -1km indicator

        MPD_TSD_SCALE_BOX(0.095,  0.8675-0.5*MPD_TEXT_HEIGHT, Tsd_DigitSize2), {},
        MPD_TSD_SCALE_BOX(0.095,  0.6175-0.5*MPD_TEXT_HEIGHT, Tsd_DigitSize3), {},
        MPD_TSD_SCALE_BOX(0.095,  0.3675-0.5*MPD_TEXT_HEIGHT, Tsd_DigitSize3), {},
        MPD_TSD_SCALE_BOX(0.095,  0.1175-0.5*MPD_TEXT_HEIGHT, Tsd_DigitSize2), {},
        MPD_TSD_SCALE_BOX(0.095, -0.1325-0.5*MPD_TEXT_HEIGHT, Tsd_DigitSize1), {},

        {{0.125, 0.905}, 1}, {{0.125, 0.89}, 1}, {}, //Bottom -6km indicator
        {{0.25, 0.905}, 1}, {{0.25, 0.89}, 1}, {},   //Bottom -4km indicator
        {{0.375, 0.905}, 1}, {{0.375, 0.89}, 1}, {}, //Bottom -2km indicator
        {{0.5, 0.905}, 1}, {{0.5, 0.89}, 1}, {},     //Bottom 0km indicator
        {{0.625, 0.905}, 1}, {{0.625, 0.89}, 1}, {}, //Bottom 2km indicator
        {{0.75, 0.905}, 1}, {{0.75, 0.89}, 1}, {},   //Bottom 4km indicator
        {{0.875, 0.905}, 1}, {{0.875, 0.89}, 1}, {}, //Bottom 6km indicator

        MPD_POINTS_BOX("Null", 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_B_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {}, //Heading
        MPD_POINTS_BOX("Null", 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_T_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01),     //Heading
    };
};
