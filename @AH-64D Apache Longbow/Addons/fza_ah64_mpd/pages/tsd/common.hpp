class Occluders {
    color[] = {0,0,0,1};
    class Polygons {
        type = polygon;
        points[] = {
            {
                {{0.0, 0.0}, 1},
                {{1.0, 0.0}, 1},
                {{1.0, 0.1}, 1},
                {{0.0, 0.1}, 1}
            },
            {
                {{0.0, 0.9}, 1},
                {{1.0, 0.9}, 1},
                {{1.0, 1.0}, 1},
                {{0.0, 1.0}, 1}
            },
            {
                {{0.0, 0.1}, 1},
                {{0.1, 0.1}, 1},
                {{0.1, 0.9}, 1},
                {{0.0, 0.9}, 1}
            },
            {
                {{0.9, 0.1}, 1},
                {{1.0, 0.1}, 1},
                {{1.0, 0.9}, 1},
                {{0.9, 0.9}, 1}
            }
        };
    };
};

#define MPD_TSD_SCALE_BOX(posX, posY, bone)\
    {{posX, posY}, 1},\
    {bone, {posX + MPD_TEXT_WIDTH + 0.01, posY}, 1},\
    {bone, {posX + MPD_TEXT_WIDTH + 0.01, posY + MPD_TEXT_HEIGHT}, 1},\
    {{posX, posY +MPD_TEXT_HEIGHT}, 1},\
    {{posX, posY}, 1}

class Outline {
    type = line;
    width = 3;
    points[] = {
        {{0.1, 0.1}, 1}, {{0.9, 0.1}, 1}, {{0.9, 0.9}, 1}, {{0.1, 0.9}, 1}, {{0.1, 0.1}, 1}, {}, //outside box
        
        {{0.1, 0.115}, 1}, {{0.085, 0.115}, 1}, {}, //Left 10km indicator
        {{0.1, 0.24}, 1}, {{0.085, 0.24}, 1}, {}, //Left 8km indicator
        {{0.1, 0.365}, 1}, {{0.085, 0.365}, 1}, {}, //Left 6km indicator
        {{0.1, 0.49}, 1}, {{0.085, 0.49}, 1}, {}, //Left 4km indicator
        {{0.1, 0.615}, 1}, {{0.085, 0.615}, 1}, {}, //Left 2km indicator
        {{0.1, 0.74}, 1}, {{0.085, 0.74}, 1}, {}, //Left 0km indicator
        {{0.1, 0.865}, 1}, {{0.085, 0.865}, 1}, {}, //Left -2km indicator

        MPD_TSD_SCALE_BOX(0.1, 0.865-0.5*MPD_TEXT_HEIGHT, Tsd_DigitSize3), {},
        MPD_TSD_SCALE_BOX(0.1, 0.615-0.5*MPD_TEXT_HEIGHT, Tsd_DigitSize3), {},
        MPD_TSD_SCALE_BOX(0.1, 0.365-0.5*MPD_TEXT_HEIGHT, Tsd_DigitSize2), {},
        MPD_TSD_SCALE_BOX(0.1, 0.1, Tsd_DigitSize1), {},

        {{0.125, 0.9}, 1}, {{0.125, 0.885}, 1}, {}, //Bottom -6km indicator
        {{0.25, 0.9}, 1}, {{0.25, 0.885}, 1}, {}, //Bottom -4km indicator
        {{0.375, 0.9}, 1}, {{0.375, 0.885}, 1}, {}, //Bottom -2km indicator
        {{0.5, 0.9}, 1}, {{0.5, 0.885}, 1}, {}, //Bottom 0km indicator
        {{0.625, 0.9}, 1}, {{0.625, 0.885}, 1}, {}, //Bottom 2km indicator
        {{0.75, 0.9}, 1}, {{0.75, 0.885}, 1}, {}, //Bottom 4km indicator
        {{0.875, 0.9}, 1}, {{0.875, 0.885}, 1}, //Bottom 6km indicator
    };
};

MPD_TEXT_R(ScaleBox1, 0.105, 0.865-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("2"))

MPD_TEXT_R(ScaleBox2, 0.105, 0.615-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("2"))

MPD_TEXT_R(ScaleBox3, 0.105, 0.365-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("6"))

MPD_TEXT_R(ScaleBox4, 0.105, 0.1, MPD_TEXT_STATIC("10"))

//Ownship Icon
class Ownship {
    color[] = {0,1,1,1};
    class Lines {
        type = line;
        width = 3;
        points[] = {
            //Ownship rotor
            {"Tsd_Ownship", { 0.020,  0.000}, 1},
            {"Tsd_Ownship", { 0.014, -0.014}, 1},
            {"Tsd_Ownship", { 0.000, -0.020}, 1},
            {"Tsd_Ownship", {-0.014, -0.014}, 1},
            {"Tsd_Ownship", {-0.020,  0.000}, 1},
            {"Tsd_Ownship", {-0.014,  0.014}, 1},
            {"Tsd_Ownship", { 0.000,  0.020}, 1},
            {"Tsd_Ownship", { 0.014,  0.014}, 1},
            {"Tsd_Ownship", { 0.020,  0.000}, 1},
            {},
            //Tail boom line
            {"Tsd_Ownship", { 0.000, 0.020}, 1},
            {"Tsd_Ownship", { 0.000, 0.040}, 1},
            {},
            //Tail rotor axle line
            {"Tsd_Ownship", { 0.000, 0.040}, 1},
            {"Tsd_Ownship", {-0.0125, 0.040}, 1},
            {},
            //Tail rotor line
            {"Tsd_Ownship", {-0.0125, 0.030}, 1},
            {"Tsd_Ownship", {-0.0125, 0.05}, 1},
            {},
            //Ownship center dot
            {"Tsd_Ownship", { 0.000,  0.0025}, 1},
            {"Tsd_Ownship", { 0.000, -0.0025}, 1},
        };
    };
};

//B2
MPD_TEXT_C(PHASE_Label, MPD_POS_BUTTON_TB_2_X-0.005, MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT+0.005, MPD_TEXT_STATIC("PHASE"))
MPD_BOX_C(PHASE,  MPD_POS_BUTTON_TB_2_X-0.005, MPD_POS_BUTTON_B_Y, 3)
//B1 or M
MPD_BOX_C(TSD,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, 3)
MPD_TEXT_C(TSD, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("TSD"))

class AtkOnly {
    condition = __EVAL(format["user%1", MFD_IND_TSD_PHASE + MFD_OFFSET]);
    MPD_TEXT_C(PHASE, MPD_POS_BUTTON_TB_2_X-0.005, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ATK"))
};

class NavOnly {
    condition = __EVAL(format["1-user%1", MFD_IND_TSD_PHASE + MFD_OFFSET]);
    MPD_TEXT_C(PHASE, MPD_POS_BUTTON_TB_2_X-0.005, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("NAV"))
};

// Hdg info
MPD_TEXT_C(HeadingLow, 0.5, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("360"))
MPD_TEXT_C(HeadingHigh, 0.5, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("360"))

class Boxes {
    type = line;
    width = 3;
    points[] = {
        MPD_POINTS_BOX(Null, 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_B_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {}, //Heading
        MPD_POINTS_BOX(Null, 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_T_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {}, //Heading
    };
};
