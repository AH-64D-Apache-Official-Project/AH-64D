MPD_ARROW_C(FLT, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
MPD_TEXT_C(FLT, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FLT"))


MPD_ARROW_C(FUEL, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, 4)
MPD_BOX_TALL_C(FUEL, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, 4)
MPD_TEXT_C(FUEL, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FUEL"))


MPD_ARROW_C(PERF, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 4)
MPD_TEXT_C(PERF, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("PERF"))

MPD_ARROW_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
MPD_TEXT_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))

MPD_TEXT_C(ENG, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ENG"))

MPD_TEXT_C(CHECK, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("CHECK"))

// Fuel XFER
MPD_TEXT_R(XFER, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y - (MPD_TEXT_HEIGHT / 2), MPD_TEXT_STATIC("XFER"))
MPD_BOX_R(XFERAUTO, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y + (MPD_TEXT_HEIGHT / 2), 4)
MPD_TEXT_R(XFERAUTO, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y + (MPD_TEXT_HEIGHT / 2), MPD_TEXT_STATIC("AUTO"))

// Fuel quantity
MPD_TEXT_SMALL_R(FTANKSINT, 0.09, 0.80 + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("INT"))
MPD_TEXT_R(FTANKSINTQTY, 0.09 + (MPD_TEXT_SMALL_WIDTH * 4), 0.80, MPD_TEXT_USER(MFD_TEXT_IND_FUEL_INT))
MPD_TEXT_SMALL_R(FTANKSINTLB, 0.09 + (MPD_TEXT_SMALL_WIDTH * 5) + (MPD_TEXT_WIDTH * 4), 0.80 + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("LB"))

// Fuel flow
#define PAGE_MPD_FUELFLOW_X (0.5 - (((MPD_TEXT_SMALL_WIDTH * 5) + (MPD_TEXT_WIDTH * 3) + (MPD_TEXT_SMALL_WIDTH * 5)) / 2))
MPD_TEXT_SMALL_C(FFLOW_HEAD, 0.5, 0.96 - (MPD_TEXT_HEIGHT * 4), MPD_TEXT_STATIC("CALC FLOW"))

MPD_TEXT_SMALL_L(FFLOW_1, PAGE_MPD_FUELFLOW_X + (MPD_TEXT_SMALL_WIDTH * 3), 0.96 - (MPD_TEXT_HEIGHT * 3) + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("1"))
MPD_TEXT_L(FFLOW_1_QTY, 0.5 + (1.2 * MPD_TEXT_WIDTH), 0.96 - (MPD_TEXT_HEIGHT * 3), MPD_TEXT_USER(MFD_TEXT_IND_FUEL_FLOW_1))
MPD_TEXT_SMALL_R(FFLOW_1_LBHR, 0.5 + (1.5 * MPD_TEXT_WIDTH), 0.96 - (MPD_TEXT_HEIGHT * 3) + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("LB/HR"))

MPD_TEXT_SMALL_L(FFLOW_2, PAGE_MPD_FUELFLOW_X + (MPD_TEXT_SMALL_WIDTH * 3), 0.96 - (MPD_TEXT_HEIGHT * 2) + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("2"))
MPD_TEXT_L(FFLOW_2_QTY, 0.5 + (1.2 * MPD_TEXT_WIDTH), 0.96 - (MPD_TEXT_HEIGHT * 2), MPD_TEXT_USER(MFD_TEXT_IND_FUEL_FLOW_2))
MPD_TEXT_SMALL_R(FFLOW_2_LBHR, 0.5 + (1.5 * MPD_TEXT_WIDTH), 0.96 - (MPD_TEXT_HEIGHT * 2) + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("LB/HR"))

MPD_TEXT_SMALL_L(FFLOW_TOT, PAGE_MPD_FUELFLOW_X + (MPD_TEXT_SMALL_WIDTH * 3), 0.96 - (MPD_TEXT_HEIGHT * 1) + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("TOT"))
MPD_TEXT_L(FFLOW_TOT_QTY, 0.5 + (1.2 * MPD_TEXT_WIDTH), 0.96 - (MPD_TEXT_HEIGHT * 1), MPD_TEXT_USER(MFD_TEXT_IND_FUEL_FLOW_TOT))
MPD_TEXT_SMALL_R(FFLOW_TOT_LBHR, 0.5 + (1.5 * MPD_TEXT_WIDTH), 0.96 - (MPD_TEXT_HEIGHT * 1) + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("LB/HR"))


// Specific fuel range
MPD_TEXT_SMALL_L(SFR_TEXT, 0.5, 0.96 - (MPD_TEXT_HEIGHT * 5.5), MPD_TEXT_STATIC("SFR"))
MPD_TEXT_SMALL_R(SFR_QTY, 0.5 + MPD_TEXT_SMALL_WIDTH, 0.96 - (MPD_TEXT_HEIGHT * 5.5), MPD_TEXT_STATIC(".16"))


// Fuel endurance
MPD_TEXT_SMALL_C(FENDR_HEAD, 0.69 + (((MPD_TEXT_SMALL_WIDTH * 5) + (MPD_TEXT_WIDTH * 3.5)) / 2), 0.77, MPD_TEXT_STATIC("ENDR"))

MPD_TEXT_SMALL_R(FENDR_INT_TEXT, 0.69, 0.78 + MPD_TEXT_SMALL_HEIGHT + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("INT"))
MPD_TEXT_L(FENDR_INT_TIME, 0.69 + (MPD_TEXT_SMALL_WIDTH * 5) + (MPD_TEXT_WIDTH * 3.5), 0.78 + MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FUEL_ENDR_INT))

// Fuel type
MPD_TEXT_L(FTYPE_TYPE, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y - (MPD_TEXT_HEIGHT / 2), MPD_TEXT_STATIC("TYPE"))
MPD_BOX_L(FTYPE_JP4, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + (MPD_TEXT_HEIGHT / 2), 3)
MPD_TEXT_L(FTYPE_JP4, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + (MPD_TEXT_HEIGHT / 2), MPD_TEXT_STATIC("JP8"))


// CROSSFEED
MPD_TEXT_L(CFEED_FWD, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("FWD"))
MPD_BOX_L(CFEED_NORM, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, 4)
MPD_TEXT_L(CFEED_NORM, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("NORM"))
MPD_TEXT_L(CFEED_AFT, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("AFT"))

#define PAGE_MPD_CROSSFEED_X MPD_POS_BUTTON_R_X - (MPD_TEXT_WIDTH * 6)
class Crossfeed_Lines {
    type = line;
    width = 3;
    points[] = {
        {{0.98, MPD_POS_BUTTON_LR_3_Y - 0.5 * MPD_TEXT_HEIGHT}, 1},
        {{PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_3_Y - 0.5 * MPD_TEXT_HEIGHT}, 1},
        {{PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y - 4 * MPD_TEXT_SMALL_HEIGHT}, 1},
        {},
        {{PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y + 5 * MPD_TEXT_SMALL_HEIGHT}, 1},
        {{PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_5_Y + 1.5 * MPD_TEXT_HEIGHT}, 1},
        {{0.98, MPD_POS_BUTTON_LR_5_Y + 1.5 * MPD_TEXT_HEIGHT}, 1}};
};

MPD_TEXT_SMALL_C(CrossfeedChar1, PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y - 4 * MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("C"))
MPD_TEXT_SMALL_C(CrossfeedChar2, PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y - 3 * MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("R"))
MPD_TEXT_SMALL_C(CrossfeedChar3, PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y - 2 * MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("O"))
MPD_TEXT_SMALL_C(CrossfeedChar4, PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y - 1 * MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("S"))
MPD_TEXT_SMALL_C(CrossfeedChar5, PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("S"))
MPD_TEXT_SMALL_C(CrossfeedChar6, PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y + 1 * MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("F"))
MPD_TEXT_SMALL_C(CrossfeedChar7, PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y + 2 * MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("E"))
MPD_TEXT_SMALL_C(CrossfeedChar8, PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y + 3 * MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("E"))
MPD_TEXT_SMALL_C(CrossfeedChar9, PAGE_MPD_CROSSFEED_X, MPD_POS_BUTTON_LR_4_Y + 4 * MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("D"))

// Fuel boost
#define FUEL_X MPD_POS_BUTTON_R_X - 0.1*MPD_TEXT_WIDTH
#define FUEL_Y MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT
class fuel_Off {
    class lines_fuelOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{FUEL_X - 0.010, FUEL_Y + 0.000}, 1},
            {{FUEL_X - 0.007, FUEL_Y - 0.007}, 1},
            {{FUEL_X - 0.000, FUEL_Y - 0.010}, 1},
            {{FUEL_X + 0.007, FUEL_Y - 0.007}, 1},
            {{FUEL_X + 0.010, FUEL_Y + 0.000}, 1},
            {{FUEL_X + 0.007, FUEL_Y + 0.007}, 1},
            {{FUEL_X + 0.000, FUEL_Y + 0.010}, 1},
            {{FUEL_X - 0.007, FUEL_Y + 0.007}, 1}, 
            {{FUEL_X - 0.010, FUEL_Y + 0.000}, 1},
        };
    };
};
MPD_TEXT_L(FBOOST, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("BOOST "))

MPD_TEXT_C(FWD_FUEL, 0.5, 0.19, MPD_TEXT_USER(MFD_TEXT_IND_FUEL_FWD))
MPD_TEXT_C(AFT_FUEL, 0.5, 0.53, MPD_TEXT_USER(MFD_TEXT_IND_FUEL_AFT))

MPD_TEXT_SMALL_C(ENG_1_INDICATOR, 0.395, 0.475, MPD_TEXT_STATIC("1"))
MPD_TEXT_SMALL_C(ENG_2_INDICATOR, 0.605, 0.475, MPD_TEXT_STATIC("2"))

class Static {
    type = line;
    width = 3;
    points[] = {
        {{0.355,0.449},1}, {{0.186,0.432},1}, {{0.186,0.336},1}, {{0.418,0.317},1}, {{0.417,0.166},1}, {{0.421,0.150},1}, {{0.432,0.134},1}, {{0.448,0.123},1}, {{0.466,0.119},1}, {},
        {{0.418,0.599},1}, {{0.418,0.636}, 1}, {},
        {{0.346,0.390}, 1}, {{0.361,0.495}, 1}, {},
        {{0.435,0.390},1}, {{0.420,0.495}, 1}, {},
        {{0.346,0.390}, 1}, {{0.435,0.390}, 1}, {},
        {{0.346,0.600}, 1}, {{0.361,0.495}, 1}, {},
        {{0.435,0.600}, 1}, {{0.420,0.495}, 1}, {},
        {{0.346,0.600}, 1}, {{0.435, 0.600}, 1}, {},
        {{0.390,0.356}, 1}, {{0.379,0.361}, 1}, {{0.374,0.373}, 1}, {{0.379,0.385}, 1}, {{0.390,0.390}, 1}, {},
        {{0.390,0.356}, 1}, {{0.401,0.361}, 1}, {{0.406,0.373}, 1}, {{0.401,0.385}, 1}, {{0.390,0.390}, 1}, {},
        {{0.467,0.119}, 1}, {{0.470,0.108}, 1}, {{0.477,0.100}, 1}, {{0.487,0.094}, 1}, {{0.500, 0.093}, 1}, {},
        {{0.639,0.449}, 1}, {{0.808,0.432}, 1}, {{0.808,0.336}, 1}, {{0.576,0.317}, 1}, {{0.576,0.166}, 1}, {{0.572,0.150}, 1}, {{0.561,0.134}, 1}, {{0.545,0.123}, 1}, {{0.527,0.119}, 1}, {},
        {{0.576,0.599}, 1}, {{0.576,0.636}, 1}, {},
        {{0.648,0.390}, 1}, {{0.633,0.495}, 1}, {},
        {{0.559,0.390}, 1}, {{0.574,0.496}, 1}, {},
        {{0.648,0.390}, 1}, {{0.559,0.390}, 1}, {},
        {{0.648,0.600}, 1}, {{0.633,0.495}, 1}, {},
        {{0.559,0.600}, 1}, {{0.574,0.495}, 1}, {},
        {{0.648,0.600}, 1}, {{0.559,0.600}, 1}, {},
        {{0.604,0.356}, 1}, {{0.615,0.361}, 1}, {{0.620,0.373}, 1}, {{0.615,0.385}, 1}, {{0.603,0.390}, 1}, {},
        {{0.604,0.356}, 1}, {{0.592,0.361}, 1}, {{0.587,0.373}, 1}, {{0.593,0.385}, 1}, {{0.603,0.390}, 1}, {},
        {{0.527,0.119}, 1}, {{0.524,0.108}, 1}, {{0.520,0.100}, 1}, {{0.510,0.094}, 1}, {{0.500,0.093}, 1}, {},
        //m 527,119              -3,-11              -7,-8              -10,-6 -10,-1"
        {{0.576,0.636}, 1}, {{0.417,0.636}, 1}, {},
        //M 576,636.00001 H 417.99999"
        // Fuel quantity
        MPD_POINTS_BOX(Null, 0.09, 0.80, (MPD_TEXT_SMALL_WIDTH * 5) + (MPD_TEXT_WIDTH * 4) + (MPD_TEXT_SMALL_WIDTH * 2), 2 * MPD_TEXT_HEIGHT), {},
        // Fuel flow
        MPD_POINTS_BOX(Null, PAGE_MPD_FUELFLOW_X, 0.96 - (MPD_TEXT_HEIGHT * 4), (MPD_TEXT_SMALL_WIDTH * 5) + (MPD_TEXT_WIDTH * 3) + (MPD_TEXT_SMALL_WIDTH * 5), 4 * MPD_TEXT_HEIGHT), {},
        // SFR
        MPD_POINTS_BOX(Null, 0.5 - (MPD_TEXT_SMALL_WIDTH * 3), 0.96 - (MPD_TEXT_HEIGHT * 5.5), MPD_TEXT_SMALL_WIDTH * 7, MPD_TEXT_SMALL_HEIGHT), {},
        // Fuel endurance
        MPD_POINTS_BOX(Null, 0.69, 0.77, (MPD_TEXT_SMALL_WIDTH * 5) + (MPD_TEXT_WIDTH * 3.5), (MPD_TEXT_SMALL_HEIGHT) + (MPD_TEXT_HEIGHT * 2)), {}
    };
};

class FuelLines {
    type = line;
    width = 9;
    points[] = {
        {{0.360, 0.390}, 1}, {{0.360,0.220}, 1}, {{0.430,0.220}, 1}, {},
        {{0.520, 0.620}, 1}, {{0.520,0.660}, 1}, {{0.630,0.660}, 1}, {{0.630,0.600},1}
    };
};

class TextBoxes {
    type = line;
    width = 3;
    points[] = {
        MPD_POINTS_BOX("Null", 0.4425,0.18, 0.1075, 0.070), {},
        MPD_POINTS_BOX("Null", (0.5-0.05),0.4875,0.095,0.125)
    };
};



#define IAFS_QTY_X 0.46
#define IAFS_QTY_Y 0.33

#define IAFS_X MPD_POS_BUTTON_L_X + 0.1*MPD_TEXT_WIDTH
#define IAFS_Y MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT
class ShowIAFS {
    condition = C_COND(C_MPD_USER(MFD_IND_FUEL_IAFS_INSTALLED));

    MPD_TEXT_R(IAFS_TXT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC(" C AUX"))
    //Center tank quantity
    MPD_TEXT_C(IAFS_QTY, IAFS_QTY_X, IAFS_QTY_Y, MPD_TEXT_USER(MFD_TEXT_IND_FUEL_IAFS))
    
    //Total quantity
    MPD_TEXT_SMALL_R(FTANKSTOT, 0.09, 0.85 + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("TOT"))
    MPD_TEXT_R(FTANKSTOTQTY, 0.09 + (MPD_TEXT_SMALL_WIDTH * 4), 0.85, MPD_TEXT_USER(MFD_TEXT_IND_FUEL_TOT))
    MPD_TEXT_SMALL_R(FTANKSTOTLB, 0.09 + (MPD_TEXT_SMALL_WIDTH * 5) + (MPD_TEXT_WIDTH * 4), 0.85 + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("LB"))

    //Total endurance
    MPD_TEXT_SMALL_R(FENDR_TOT_TEXT, 0.69, 0.82 + MPD_TEXT_SMALL_HEIGHT + MPD_TEXT_SMALL_PAD, MPD_TEXT_STATIC("TOT"))
    MPD_TEXT_L(FENDR_TOT_TIME, 0.69 + (MPD_TEXT_SMALL_WIDTH * 5) + (MPD_TEXT_WIDTH * 3.5), 0.82 + MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FUEL_ENDR_TOT))

    class box_IAFS {
        type = line;
        width = 3;
        points[] = {
        MPD_POINTS_BOX(Null, IAFS_QTY_X-(1.5*MPD_TEXT_WIDTH), IAFS_QTY_Y, 3*MPD_TEXT_WIDTH, 0.98*MPD_TEXT_HEIGHT),
        };
    };


    class iafs_Off {
        class lines_iafsOnOff {
            type = line;
            width = 3;
            points[] = {
                //Power Indicator
                {{IAFS_X - 0.010, IAFS_Y + 0.000}, 1},
                {{IAFS_X - 0.007, IAFS_Y - 0.007}, 1},
                {{IAFS_X - 0.000, IAFS_Y - 0.010}, 1},
                {{IAFS_X + 0.007, IAFS_Y - 0.007}, 1},
                {{IAFS_X + 0.010, IAFS_Y + 0.000}, 1},
                {{IAFS_X + 0.007, IAFS_Y + 0.007}, 1},
                {{IAFS_X + 0.000, IAFS_Y + 0.010}, 1},
                {{IAFS_X - 0.007, IAFS_Y + 0.007}, 1}, 
                {{IAFS_X - 0.010, IAFS_Y + 0.000}, 1},
            };
        };
    };
    class iafs_On {
        condition = C_COND(C_MPD_USER(MFD_IND_FUEL_IAFS_ON));
        class iafs_draw {
            class polys_iafsOnOff {
                class Polygons {
                    type = polygon;
                    points[] = {
                        { //Top left
                            {{IAFS_X - 0.010, IAFS_Y + 0.000}, 1},
                            {{IAFS_X - 0.007, IAFS_Y - 0.007}, 1},
                            {{IAFS_X - 0.000, IAFS_Y - 0.010}, 1},
                            {{IAFS_X, IAFS_Y}, 1}
                        },
                        { //Top right
                            {{IAFS_X - 0.000, IAFS_Y - 0.010}, 1},
                            {{IAFS_X + 0.007, IAFS_Y - 0.007}, 1},
                            {{IAFS_X + 0.010, IAFS_Y + 0.000}, 1},
                            {{IAFS_X, IAFS_Y}, 1}
                        },
                        { //Bottom right
                            {{IAFS_X + 0.010, IAFS_Y + 0.000}, 1},
                            {{IAFS_X + 0.007, IAFS_Y + 0.007}, 1}, 
                            {{IAFS_X + 0.000, IAFS_Y + 0.010}, 1},
                            {{IAFS_X, IAFS_Y}, 1}
                        },
                        { //Bottom left
                            {{IAFS_X + 0.000, IAFS_Y + 0.010}, 1},
                            {{IAFS_X - 0.007, IAFS_Y + 0.007}, 1}, 
                            {{IAFS_X - 0.010, IAFS_Y + 0.000}, 1},
                            {{IAFS_X, IAFS_Y}, 1}
                        }
                    };
                };
            };
        };
    };

    class fuelLines_IAFS {
        type = line;
        width = 9;
        points[] = {
            {{0.48, 0.256}, 1},
            {{0.48, 0.322}, 1}, 
            {},
            {{0.48, 0.382}, 1},
            {{0.48, 0.480}, 1} 
        };
    };
};