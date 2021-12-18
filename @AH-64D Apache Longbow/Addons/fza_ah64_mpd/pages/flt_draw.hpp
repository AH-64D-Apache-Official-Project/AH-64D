///////////////// L ///////////////
MPD_TEXT_R(Waterline, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("-W-"))
MPD_TEXT_R(Bias, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y+MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("BIAS"))


///////////////// T ///////////////
MPD_ARROW_C(ENG, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 3)
MPD_TEXT_C(ENG, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ENG"))

MPD_ARROW_C(FUEL, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, 4)
MPD_TEXT_C(FUEL, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FUEL"))

MPD_ARROW_C(PERF, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 4)
MPD_TEXT_C(PERF, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("PERF"))

MPD_ARROW_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
MPD_TEXT_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))

///////////////// B ///////////////
MPD_BOX_C(FLT, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, 3)
MPD_TEXT_C(FLT, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("FLT"))

MPD_ARROW_C(SET, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, 3)
MPD_TEXT_C(SET, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("SET"))

///////////////// Torque ///////////////
MPD_TEXT_L(Torque, 0.15, 0.14, MPD_TEXT_USER(MFD_TEXT_IND_FLT_TORQUE))

///////////////// Altitude ///////////////
MPD_TEXT_L(AltMSL, 0.93, 0.13, MPD_TEXT_USER(MFD_TEXT_IND_FLT_BALT) sourceScale = MPD_SCALE_METERS_FEET;)
MPD_TEXT_L(AltAGL, 0.90, 0.5 - 0.5 * MPD_TEXT_WIDTH, MPD_TEXT_USER(MFD_TEXT_IND_FLT_GALT) sourceScale = MPD_SCALE_METERS_FEET;)

///////////////// Airspeed ///////////////
MPD_TEXT_L(Airspeed, 0.16, 0.5, MPD_TEXT_USER(MFD_TEXT_IND_FLT_AIRSPEED) sourceScale = MPD_SCALE_MPS_KNOTS; )

///////////////// Heading Tape ///////////////
class HeadingTape {
    //Source info
    source = heading;
    sourceScale = 1;

    //Tape setup
    type = scale;
    horizontal = 1;
    neverEatSeaWeed = 1;
    step = 10;
    stepSize = __EVAL(0.5/18-0.001);
    lineXLeft = 0.15;
    lineYRight = 0.165;
    lineXLeftMajor = 0.15;
    lineYRightMajor = 0.18;
    top = 0.25;
    bottom = 0.75;
    center = 0.5;
    majorLineEach = 3;
    numberEach = 3;
    width = 3;

    //Text config
    align = center;
    scale = 1;
    pos[] = {0.25, 0.15-MPD_TEXT_HEIGHT};
    right[] = {0.25 + MPD_TEXT_WIDTH_VEC, 0.15-MPD_TEXT_HEIGHT};
    down[] = {0.25, 0.15};
};

#define MPD_FLT_HORIZON_LINE_TEXT(angle, startX, startY, alignment) class text_##alignment {\
        type = text; \
        align = alignment; \
        scale = 1; \
        pos[] = {"Flt_Horizon", {startX, startY-(MPD_TEXT_HEIGHT/2*0.9)}, 1}; \
        right[] = {"Flt_Horizon", {(startX)+MPD_TEXT_WIDTH_VEC, startY-(MPD_TEXT_HEIGHT/2)}, 1}; \
        down[] = {"Flt_Horizon", {startX, (startY)+(MPD_TEXT_HEIGHT/2)}, 1}; \
        MPD_TEXT_STATIC(STRINGIFY(angle)) \
    };

// (horizonDive ,  rad (directionNum * angle - 31)) *(horizonDive < rad (directionNum * angle + 31))
#define MPD_FLT_HORIZON_LINE_MAIN(angle, directionNum, directionName, horizonLineType, lineColour) class HorizonLine_##angle##_##directionName { \
    condition = 1; \
    color[] = lineColour; \
    MPD_FLT_HORIZON_LINE_TEXT(angle, (0.7 * (-(0.2 + angle * 0.002))), (0.7 * (- directionNum * angle * 0.014)),left)\
    MPD_FLT_HORIZON_LINE_TEXT(angle, (0.7 * (0.2 + angle * 0.002)), (0.7 * (- directionNum * angle * 0.014)),right)\
    class horizontal { \
        type = line; \
        lineType = horizonLineType; \
        width = 3; \
        points[] = { \
            {"Flt_Horizon", {0.7 * (-(0.04 + angle * 0.002)), 0.7 * (- directionNum * angle * 0.014)}, 1}, \
            {"Flt_Horizon", {0.7 * (-(0.18 + angle * 0.002)), 0.7 * (- directionNum * angle * 0.014)}, 1}, \
            {}, \
            {"Flt_Horizon", {0.7 * (0.04 + angle * 0.002), 0.7 * (- directionNum * angle * 0.014)}, 1}, \
            {"Flt_Horizon", {0.7 * (0.18 + angle * 0.002), 0.7 * (- directionNum * angle * 0.014)}, 1}}; \
    }; \
    class vertical { \
        type = line; \
        width = 3; \
        points[] = { \
            {"Flt_Horizon", {0.7 * (-(0.18 + angle * 0.002)), 0.7 * (- directionNum * angle * 0.014)}, 1}, \
            {"Flt_Horizon", {0.7 * (-(0.18 + angle * 0.002)), 0.7 * ((- directionNum * angle * 0.014) + directionNum * 0.026)}, 1}, \
            {}, \
            {"Flt_Horizon", {0.7 * (0.18 + angle * 0.002), 0.7 * (- directionNum * angle * 0.014)}, 1}, \
            {"Flt_Horizon", {0.7 * (0.18 + angle * 0.002), 0.7 * ((- directionNum * angle * 0.014) + directionNum * 0.026)}, 1}}; \
    }; \
};
#define MPD_FLT_HORIZON_LINE_SEC(angle, directionNum, directionName, lineColour) class HorizonLine_##angle##_##directionName { \
    color[] = lineColour; \
    class horizontal { \
        type = line; \
        lineType = 0; \
        width = 3; \
        points[] = { \
            {"Flt_Horizon", {-0.01, 0.7 * (- directionNum * angle * 0.014)}, 1}, \
            {"Flt_Horizon", {0.01, 0.7 * (- directionNum * angle * 0.014)}, 1} \
        }; \
    }; \
};

#define MPD_COLOUR_GROUND {1, 0.78, 0.69, 1}
#define MPD_COLOUR_AIR {0, 1, 1, 1}
#define MPD_FLT_HORIZON_LINE_SEC_GROUND(angle) MPD_FLT_HORIZON_LINE_SEC(angle, -1,Ground, MPD_COLOUR_GROUND)
#define MPD_FLT_HORIZON_LINE_SEC_AIR(angle) MPD_FLT_HORIZON_LINE_SEC(angle, 1,Air, MPD_COLOUR_AIR)
#define MPD_FLT_HORIZON_LINE_MAIN_AIR(angle) MPD_FLT_HORIZON_LINE_MAIN(angle, 1,Ground, 2, MPD_COLOUR_AIR)
#define MPD_FLT_HORIZON_LINE_MAIN_GROUND(angle) MPD_FLT_HORIZON_LINE_MAIN(angle, -1,Air, 0, MPD_COLOUR_GROUND)

class Horizon_Display {
    clipTL[] = {0.2, 0.27};
    clipBR[] = {0.8, 0.73};
    MPD_FLT_HORIZON_LINE_SEC_AIR(5)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(10)
    MPD_FLT_HORIZON_LINE_SEC_AIR(15)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(20)
    MPD_FLT_HORIZON_LINE_SEC_AIR(25)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(30)
    MPD_FLT_HORIZON_LINE_SEC_AIR(35)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(40)
    MPD_FLT_HORIZON_LINE_SEC_AIR(45)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(50)
    MPD_FLT_HORIZON_LINE_SEC_AIR(55)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(60)
    MPD_FLT_HORIZON_LINE_SEC_AIR(65)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(70)
    MPD_FLT_HORIZON_LINE_SEC_AIR(75)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(80)
    MPD_FLT_HORIZON_LINE_SEC_AIR(85)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(90)
    MPD_FLT_HORIZON_LINE_SEC_AIR(95)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(100)
    MPD_FLT_HORIZON_LINE_SEC_AIR(105)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(110)
    MPD_FLT_HORIZON_LINE_SEC_AIR(115)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(120)
    MPD_FLT_HORIZON_LINE_SEC_AIR(125)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(130)
    MPD_FLT_HORIZON_LINE_SEC_AIR(135)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(140)
    MPD_FLT_HORIZON_LINE_SEC_AIR(145)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(150)
    MPD_FLT_HORIZON_LINE_SEC_AIR(155)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(160)
    MPD_FLT_HORIZON_LINE_SEC_AIR(165)
    MPD_FLT_HORIZON_LINE_MAIN_AIR(170)
    MPD_FLT_HORIZON_LINE_SEC_AIR(175)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(5)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(10)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(15)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(20)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(25)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(30)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(35)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(40)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(45)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(50)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(55)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(60)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(65)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(70)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(75)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(80)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(85)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(90)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(95)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(100)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(105)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(110)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(115)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(120)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(125)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(130)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(135)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(140)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(145)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(150)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(155)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(160)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(165)
    MPD_FLT_HORIZON_LINE_MAIN_GROUND(170)
    MPD_FLT_HORIZON_LINE_SEC_GROUND(175)
    class Horizon_0 { \
        color[] = MPD_COLOUR_GROUND; \
        class Line { \
            type = line; \
            width = 3; \
            points[] = { \
                {"Flt_Horizon", {-0.36, 0}, 1}, \
                {"Flt_Horizon", {0.36, 0}, 1}, \
            }; \
        }; \
    };
};

class Obscurants {
    color[] = {0,0,0,1};
    class HeadingTape {
        type = polygon;
        points[] = {
            {
                {{0.5 - MPD_TEXT_WIDTH * 1.5, 0.15 - MPD_TEXT_HEIGHT}, 1},
                {{0.5 + MPD_TEXT_WIDTH * 1.5, 0.15 - MPD_TEXT_HEIGHT}, 1},
                {{0.5 + MPD_TEXT_WIDTH * 1.5, 0.15}, 1},
                {{0.5 - MPD_TEXT_WIDTH * 1.5, 0.15}, 1}
            }
        };
    };
};

///////////////// Heading ///////////////
MPD_TEXT_C(Heading, 0.5, 0.11, source = heading; sourceScale = 1;)

class HorizonMiddle {
    type = line;
    width = 8;
    points[] = {
        {{0.4, 0.5}, 1},
        {{0.47, 0.5}, 1},
        {{0.485, 0.53}, 1},
        {{0.5, 0.5}, 1},
        {{0.515, 0.53}, 1},
        {{0.53, 0.5}, 1},
        {{0.6, 0.5}, 1}
    };
};

class VSIStatic {
    type = line;
    width = 3;
    points[] = {
        // Main markers
        {{0.94, 0.25}, 1}, {{0.965, 0.25}, 1}, {},
        {{0.94, 0.375}, 1}, {{0.965, 0.375}, 1}, {},
        {{0.94, 0.5}, 1}, {{0.965, 0.5}, 1}, {},
        {{0.94, 0.625}, 1}, {{0.965, 0.625}, 1}, {},
        {{0.94, 0.75}, 1}, {{0.965, 0.75}, 1}, {},

        // Small markers (left)
        {{0.95, 0.4}, 1}, {{0.965, 0.4}, 1}, {},
        {{0.95, 0.425}, 1}, {{0.965, 0.425}, 1}, {},
        {{0.95, 0.45}, 1}, {{0.965, 0.45}, 1}, {},
        {{0.95, 0.475}, 1}, {{0.965, 0.475}, 1}, {},
        {{0.95, 0.525}, 1}, {{0.965, 0.525}, 1}, {},
        {{0.95, 0.55}, 1}, {{0.965, 0.55}, 1}, {},
        {{0.95, 0.575}, 1}, {{0.965, 0.575}, 1}, {},
        {{0.95, 0.6}, 1}, {{0.965, 0.6}, 1}, {},
    };
};
class RadarAltimeter {
    condition = (altitudeAGL * MPD_SCALE_METERS_FEET) < 200;
    class RadarAltTape {
        type = polygon;
        points[] = {
            {
                {"Flt_RadarAlt", {0.965, 0.75}, 1},
                {"Flt_RadarAlt", {0.98, 0.75}, 1},
                {{0.98, 0.75}, 1},
                {{0.965, 0.75}, 1}
            }
        };
    };
    class RadarAltStatic {
        type = line;
        width = 3;
        points[] = {
            // Main markers
            {{0.98, 0.25}, 1}, {{1, 0.25}, 1}, {},
            {{0.98, 0.375}, 1}, {{1, 0.375}, 1}, {},
            {{0.98, 0.5}, 1}, {{1, 0.5}, 1}, {},
            {{0.98, 0.625}, 1}, {{1, 0.625}, 1}, {},
            {{0.98, 0.75}, 1}, {{1, 0.75}, 1}, {},

            // Small markers (right)
            {{0.98, 0.65}, 1}, {{0.995, 0.65}, 1}, {},
            {{0.98, 0.675}, 1}, {{0.995, 0.675}, 1}, {},
            {{0.98, 0.7}, 1}, {{0.995, 0.7}, 1}, {},
            {{0.98, 0.725}, 1}, {{0.995, 0.725}, 1}
        };
    }
}

class VerticalSpeedIndicator {
    type = polygon;
    points[] = {
        {
            {"Flt_VerticalSpeed", {0.945, 0.5}, 1},
            {"Flt_VerticalSpeed", {0.925, 0.49}, 1},
            {"Flt_VerticalSpeed", {0.925, 0.51}, 1}
        }
    };
};

//Todo: Make go white when bank angle ,  20 degrees
#define MPD_BANK_ANGLE_STATIC_RADIAL(angle, y1, y2) {{__EVAL(0.5 + y1 * sin(angle)), __EVAL(0.5 - y1 * cos(angle))}, 1}, {{__EVAL(0.5 + y2 * sin(angle)), __EVAL(0.5 - y2 * cos(angle))}, 1}, {},
class BankAngleStatic {
    type = line;
    width = 3;
    points[] = {
        MPD_BANK_ANGLE_STATIC_RADIAL(5, 0.3, 0.31) MPD_BANK_ANGLE_STATIC_RADIAL(-5, 0.3, 0.31)
        MPD_BANK_ANGLE_STATIC_RADIAL(15, 0.3, 0.31) MPD_BANK_ANGLE_STATIC_RADIAL(-15, 0.3, 0.31)
        MPD_BANK_ANGLE_STATIC_RADIAL(25, 0.3, 0.31) MPD_BANK_ANGLE_STATIC_RADIAL(-25, 0.3, 0.31)

        MPD_BANK_ANGLE_STATIC_RADIAL(10, 0.29, 0.31) MPD_BANK_ANGLE_STATIC_RADIAL(-10, 0.29, 0.31)
        MPD_BANK_ANGLE_STATIC_RADIAL(20, 0.29, 0.31) MPD_BANK_ANGLE_STATIC_RADIAL(-20, 0.29, 0.31) {}
    };
}

class BankAngleStaticThick {
    type = line;
    width = 9;
    points[] = {
        {{0.5, 0.165}, 1},{{0.5, 0.205}, 1}, {},
        MPD_BANK_ANGLE_STATIC_RADIAL(30, 0.29, 0.31)
        MPD_BANK_ANGLE_STATIC_RADIAL(-30, 0.29, 0.31) {}
    };
};

class BankAngleExtension {
    condition = (horizonBank ,  rad 20) + (horizonBank < rad -20);
    class BankAngleStaticThick {
        type = line;
        width = 9;
        points[] = {
            MPD_BANK_ANGLE_STATIC_RADIAL(45, 0.29, 0.31)
            MPD_BANK_ANGLE_STATIC_RADIAL(-45, 0.29, 0.31) {}
        };
    };
};

class BankAngleTriangle {
    type = polygon;
    points[] = {
        {
            {"Flt_BankAngle", { 0.0, 0.315}, 1},
            {"Flt_BankAngle", {-0.013, 0.286}, 1},
            {"Flt_BankAngle", { 0.013, 0.286}, 1}
        }
    };
};

class TurnRateSkidSlipLines {
    type = line;
    width = 3;
    points[] = {
        //Horizontal slip line
        {{0.375, 0.975}, 1}, {{0.625, 0.975}, 1}, {},
        //Vertical slip lines
        {{0.48, 0.975}, 1}, {{0.48, 0.94}, 1}, {},
        {{0.52, 0.975}, 1}, {{0.52, 0.94}, 1}, {},
        //Vertical turn rate lines
        {{0.36, 0.93}, 1}, {{0.36, 0.90}, 1}, {},
        {{0.40, 0.93}, 1}, {{0.40, 0.90}, 1}, {},
        {{0.44, 0.93}, 1}, {{0.44, 0.90}, 1}, {},
        {{0.48, 0.93}, 1}, {{0.48, 0.90}, 1}, {},
        {{0.52, 0.93}, 1}, {{0.52, 0.90}, 1}, {},
        {{0.56, 0.93}, 1}, {{0.56, 0.90}, 1}, {},
        {{0.60, 0.93}, 1}, {{0.60, 0.90}, 1}, {},
        {{0.64, 0.93}, 1}, {{0.64, 0.90}, 1}
    };
};

class TurnRateTriangles {
    type = polygon;
    points[] = {
        {
            {{0.40, 0.90}, 1},
            {{0.44, 0.90}, 1},
            {{0.42, 0.885}, 1}
        },
        {
            {{0.48, 0.90}, 1},
            {{0.52, 0.90}, 1},
            {{0.50, 0.885}, 1}
        },
        {
            {{0.56, 0.90}, 1},
            {{0.60, 0.90}, 1},
            {{0.58, 0.885}, 1}
        }
    };
};

MPD_CIRCLE(SlipIndicator, Flt_SlipIndicator, 0.018)

class TurnIndicatorBox {
    type = polygon;
    points[] = {
        {
            {"Flt_TurnIndicator", {-0.0125, -0.0125}, 1},
            {"Flt_TurnIndicator", {0.0125, -0.0125}, 1},
            {"Flt_TurnIndicator", {0.0125, 0.0125}, 1},
            {"Flt_TurnIndicator", {-0.0125, 0.0125}, 1}
        }
    };
}

class WaypointBoxStatic {
    type = line;
    width = 3;
    points[] = {
        MPD_POINTS_CURVED_CORNER(Null, 0.0725, 0.8530 - 2 * MPD_TEXT_HEIGHT, -0.015, -0.015), {}, // Top Left corner
        MPD_POINTS_CURVED_CORNER(Null, 0.3425, 0.8530 - 2 * MPD_TEXT_HEIGHT, 0.015, -0.015), {}, // Top Right corner
        MPD_POINTS_CURVED_CORNER(Null, 0.3425, 0.8515, 0.015, 0.015), {}, // Bottom Right corner
        MPD_POINTS_CURVED_CORNER(Null, 0.0725, 0.8515, -0.015, 0.015), {}, // Bottom Left corner
        {{0.0725, 0.838 - 2 * MPD_TEXT_HEIGHT}, 1}, {{0.3425, 0.838 - 2 * MPD_TEXT_HEIGHT}, 1}, {}, //Top line
        {{0.0725, 0.8665}, 1}, {{0.3425, 0.8665}, 1}, {}, // Bottom Line
        {{0.0575, 0.85 - 2 * MPD_TEXT_HEIGHT}, 1}, {{0.0575, 0.85}, 1}, {}, // Left Line
        {{0.3575, 0.85 - 2 * MPD_TEXT_HEIGHT}, 1}, {{0.3575, 0.85}, 1} // Right Line
    };
};

MPD_TEXT_R(DestinationPoint, 0.0725, 0.8530 - 2 * MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FLT_DESTINATION))
MPD_TEXT_R(GroundSpeed, 0.0725, 0.8530 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FLT_GROUNDSPEED))

MPD_TEXT_L(DistanceToGo, 0.3425, 0.8530 - 2 * MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FLT_DISTANCETOGO))
MPD_TEXT_L(TimeToGo, 0.3425, 0.8530 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FLT_TIMETOGO))

class NavSymbology {
    clipTL[] = {0.2, 0.27};
    clipBR[] = {0.8, 0.73};

    class FlyToCueLines {
        type = line;
        width = 3;
        points[] = {
            {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {-0.035, 0.025}, 1},
            {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {0.035, 0.025}, 1},
            {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {0.055, 0.005}, 1},
            {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {0.055, -0.01}, 1},
            {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {0, -0.06}, 1},
            {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {-0.055, -0.01}, 1},
            {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {-0.055, 0.005}, 1},
            {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {-0.035, 0.025}, 1},
            {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {-0.035, 0.025}, 1}
        };
    };
    
    class FlyToCueTriangle {
        type = polygon;
        points[] = {
            {
                {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {0, -0.005}, 1},
                {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {0.0075, 0.005}, 1},
                {"Flt_FlyToCueX", 1, "Flt_FlyToCueY", {-0.0075, 0.005}, 1}
            };
        };
    };

    class FlightPathVector {
        type = line;
        width = 3;
        points[] = {
                MPD_POINTS_CURVED_CORNER("Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", 0, 0, 0.02, 0.02), {},
                MPD_POINTS_CURVED_CORNER("Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", 0, 0, 0.02, -0.02), {},
                MPD_POINTS_CURVED_CORNER("Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", 0, 0, -0.02, -0.02), {},
                MPD_POINTS_CURVED_CORNER("Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", 0, 0, -0.02, 0.02), {},
                {"Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", {-0.02, 0}, 1}, {"Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", {-0.04, 0}, 1}, {},
                {"Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", {0.02, 0}, 1}, {"Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", {0.04, 0}, 1}, {},
                {"Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", {0, -0.02}, 1}, {"Flt_FlightPathVectorY" COMMA 1 COMMA "Flt_FlightPathVectorX", {0, -0.04}, 1}
        };
    };
};

class CommandHeading {
    type = line;
    width = 3;
    points[] = {
        {"Flt_CommandHeading", {-0.0075, 0.015}, 1},
        {"Flt_CommandHeading", {0, 0}, 1},
        {"Flt_CommandHeading", {0.0075, 0.015}, 1}
    };
};

class AltSensorBearing {
    type = polygon;
    points[] = {
        {
            {"Flt_AltSensorBearing", {-0.0075, 0.015}, 1},
            {"Flt_AltSensorBearing", {0, 0}, 1},
            {"Flt_AltSensorBearing", {0.0075, 0.015}, 1}
        }
    };
};

class Flt_FCRCenterline {
    type = polygon;
    points[] = {
        {
            //Main rectangles
            {"Flt_FCRCenterline", {-0.0065, 0}, 1},
            {"Flt_FCRCenterline", {-0.0025, 0}, 1},
            {"Flt_FCRCenterline", {-0.0025, 0.012}, 1},
            {"Flt_FCRCenterline", {-0.0065, 0.012}, 1}
        },  {
            {"Flt_FCRCenterline", {0.0065, 0}, 1},
            {"Flt_FCRCenterline", {0.0025, 0}, 1},
            {"Flt_FCRCenterline", {0.0025, 0.012}, 1},
            {"Flt_FCRCenterline", {0.0065, 0.012}, 1}
        },
            //Left curve
        {
            {"Flt_FCRCenterline", {-0.0065, 0}, 1},
            {"Flt_FCRCenterline", {-0.0094, 0.0007}, 1},
            {"Flt_FCRCenterline", {-0.0094, 0.0113}, 1},
            {"Flt_FCRCenterline", {-0.0065, 0.012}, 1}
        }, {
            {"Flt_FCRCenterline", {-0.0094, 0.0007}, 1},
            {"Flt_FCRCenterline", {-0.0116, 0.0027}, 1},
            {"Flt_FCRCenterline", {-0.0116, 0.0093}, 1},
            {"Flt_FCRCenterline", {-0.0094, 0.0113}, 1}
        }, {
            {"Flt_FCRCenterline", {-0.0116, 0.0027}, 1},
            {"Flt_FCRCenterline", {-0.0125, 0.0056}, 1},
            {"Flt_FCRCenterline", {-0.0125, 0.0064}, 1},
            {"Flt_FCRCenterline", {-0.0116, 0.0093}, 1}
        },
            //Right curve
        {
            {"Flt_FCRCenterline", {0.0065, 0}, 1},
            {"Flt_FCRCenterline", {0.0094, 0.0007}, 1},
            {"Flt_FCRCenterline", {0.0094, 0.0113}, 1},
            {"Flt_FCRCenterline", {0.0065, 0.012}, 1}
        }, {
            {"Flt_FCRCenterline", {0.0094, 0.0007}, 1},
            {"Flt_FCRCenterline", {0.0116, 0.0027}, 1},
            {"Flt_FCRCenterline", {0.0116, 0.0093}, 1},
            {"Flt_FCRCenterline", {0.0094, 0.0113}, 1}
        }, {
            {"Flt_FCRCenterline", {0.0116, 0.0027}, 1},
            {"Flt_FCRCenterline", {0.0125, 0.0056}, 1},
            {"Flt_FCRCenterline", {0.0125, 0.0064}, 1},
            {"Flt_FCRCenterline", {0.0116, 0.0093}, 1}
        }
    };
}