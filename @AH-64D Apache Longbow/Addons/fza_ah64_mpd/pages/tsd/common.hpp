class vabs_show {
    condition = C_COND(C_NOT(C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 1)));
    #include "components\vabs_top.hpp"
};

class tsdCommon {
    class occluders {
        color[] = {0,0,0,1};
        class Polygons {
            type = polygon;
            points[] = {
                {
                    {{0.0, 0.0}, 1},
                    {{1.0, 0.0}, 1},
                    {{1.0, 0.095}, 1},
                    {{0.0, 0.095}, 1}
                },
                {
                    {{0.0, 0.905}, 1},
                    {{1.0, 0.905}, 1},
                    {{1.0, 1.0}, 1},
                    {{0.0, 1.0}, 1}
                },
                {
                    {{0.0, 0.095}, 1},
                    {{0.095, 0.095}, 1},
                    {{0.095, 0.905}, 1},
                    {{0.0, 0.905}, 1}
                },
                {
                    {{0.905, 0.095}, 1},
                    {{1.0, 0.095}, 1},
                    {{1.0, 0.905}, 1},
                    {{0.905, 0.905}, 1}
                }
            };
        };
    };

    #define MPD_TSD_SCALE_BOX(posX, posY, bone)\
        {"Tsd_Ownship", 1, {posX, posY}, 1},\
        {"Tsd_Ownship", 1, bone, {posX + MPD_TEXT_WIDTH + 0.01, posY}, 1},\
        {"Tsd_Ownship", 1, bone, {posX + MPD_TEXT_WIDTH + 0.01, posY + MPD_TEXT_HEIGHT}, 1},\
        {"Tsd_Ownship", 1, {posX, posY +MPD_TEXT_HEIGHT}, 1},\
        {"Tsd_Ownship", 1, {posX, posY}, 1}

    class lines {
        type = line;
        width = 3;
        points[] = {
            {{0.095, 0.095}, 1}, {{0.905, 0.095}, 1}, {{0.905, 0.9}, 1}, {{0.095, 0.905}, 1}, {{0.095, 0.095}, 1}, {}, //outside box
            
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

            MPD_POINTS_BOX(Null, 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_B_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {}, //Heading
            MPD_POINTS_BOX(Null, 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_T_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01),     //Heading
        };
    };
    class ase_footPrint {
        condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_TSD_ASE_FOOTPRINT)));
        class ase_footprint_lines {
            type = line;
            width = 3;
            points[] = {
                {{0.18, 0.18}, 1}, {{0.82, 0.18}, 1}, {{0.82, 0.82}, 1}, {{0.18, 0.82}, 1}, {{0.18, 0.18}, 1}, {}, //inside box
            };
        };
    };


    class Scale_Boxes_5km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 5000));
        MPD_TEXT_BONE_R(ScaleBox1, Tsd_Ownship, 0.10,  0.87-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("3"))
        MPD_TEXT_BONE_R(ScaleBox2, Tsd_Ownship, 0.10,  0.62-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("1"))
        MPD_TEXT_BONE_R(ScaleBox3, Tsd_Ownship, 0.10,  0.37-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("1"))
        MPD_TEXT_BONE_R(ScaleBox4, Tsd_Ownship, 0.10,  0.12-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("3"))
        MPD_TEXT_BONE_R(ScaleBox5, Tsd_Ownship, 0.10, -0.13-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("5"))
    };
    
    class Scale_Boxes_10km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 10000));
        MPD_TEXT_BONE_R(ScaleBox1, Tsd_Ownship, 0.10,  0.87-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("3"))
        MPD_TEXT_BONE_R(ScaleBox2, Tsd_Ownship, 0.10,  0.62-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("2"))
        MPD_TEXT_BONE_R(ScaleBox3, Tsd_Ownship, 0.10,  0.37-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("2"))
        MPD_TEXT_BONE_R(ScaleBox4, Tsd_Ownship, 0.10,  0.12-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("6"))
        MPD_TEXT_BONE_R(ScaleBox5, Tsd_Ownship, 0.10, -0.13-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("10"))
    };

    class Scale_Boxes_25km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 25000));
        MPD_TEXT_BONE_R(ScaleBox1, Tsd_Ownship, 0.10,  0.87-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("15"))
        MPD_TEXT_BONE_R(ScaleBox2, Tsd_Ownship, 0.10,  0.62-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("5"))
        MPD_TEXT_BONE_R(ScaleBox3, Tsd_Ownship, 0.10,  0.37-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("5"))
        MPD_TEXT_BONE_R(ScaleBox4, Tsd_Ownship, 0.10,  0.12-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("15"))
        MPD_TEXT_BONE_R(ScaleBox5, Tsd_Ownship, 0.10, -0.13-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("25"))
    };

    class Scale_Boxes_50km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 50000));
        MPD_TEXT_BONE_R(ScaleBox1, Tsd_Ownship, 0.10,  0.87-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("30"))
        MPD_TEXT_BONE_R(ScaleBox2, Tsd_Ownship, 0.10,  0.62-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("10"))
        MPD_TEXT_BONE_R(ScaleBox3, Tsd_Ownship, 0.10,  0.37-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("10"))
        MPD_TEXT_BONE_R(ScaleBox4, Tsd_Ownship, 0.10,  0.12-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("30"))
        MPD_TEXT_BONE_R(ScaleBox5, Tsd_Ownship, 0.10, -0.13-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("50"))
    };

    //Ownship Icon
    class Ownship {
        color[] = {0,1,1,1};
        class Lines {
            type = line;
            width = 3;
            points[] = {
                //Ownship rotor
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.020,  0.000}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.014, -0.014}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.000, -0.020}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.014, -0.014}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.020,  0.000}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.014,  0.014}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.000,  0.020}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.014,  0.014}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.020,  0.000}, 1},
                {},
                //Tail boom line
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.000, 0.020}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.000, 0.040}, 1},
                {},
                //Tail rotor axle line
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.000, 0.040}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.0125, 0.040}, 1},
                {},
                //Tail rotor line
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.0125, 0.030}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.0125, 0.05}, 1},
                {},
                //Ownship center dot
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.000,  0.0025}, 1},
                {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", { 0.000, -0.0025}, 1},
            };
        };
    };

    //B1 or M
    MPD_BOX_C(TSD,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, 3)
    MPD_TEXT_C(TSD, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("TSD"))
    //B2
    MPD_TEXT_C(PHASE_Label, MPD_POS_BUTTON_TB_2_X-0.005, MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT+0.005, MPD_TEXT_STATIC("PHASE"))
    MPD_BOX_C(PHASE,        MPD_POS_BUTTON_TB_2_X-0.005, MPD_POS_BUTTON_B_Y, 3)

    class AtkOnly {
        condition = C_COND(C_MPD_USER(MFD_IND_TSD_PHASE));
        MPD_TEXT_C(PHASE, MPD_POS_BUTTON_TB_2_X-0.005, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ATK"))
    };

    class NavOnly {
        condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_TSD_PHASE)));
        MPD_TEXT_C(PHASE, MPD_POS_BUTTON_TB_2_X-0.005, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("NAV"))
    };

    // Hdg info
    MPD_TEXT_C(HeadingHigh, 0.5, MPD_POS_BUTTON_T_Y, source = heading; sourceScale = 1;)
    MPD_TEXT_C(HeadingLow,  0.5, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("360"))

#define HSI_OUTER_RADIUS 0.263
#define HSI_INNER_RADIUS_5_INC 0.240
#define HSI_INNER_RADIUS_10_INC 0.233
#define HSI_INNER_RADIUS_30_INC 0.223

#define MPD_HSI_TEXT(bone, label) class bone##_Text { \
                align = "center"; \
                down[] =  {bone, {0,-0.22+MPD_TEXT_HEIGHT},1, "TSD_Ownship",1}; \
                pos[] =   {bone, {0,-0.22},1, "TSD_Ownship",1}; \
                right[] = {bone, {-MPD_TEXT_WIDTH_VEC,-0.22},1, "TSD_Ownship",1}; \
                scale = 1; \
                source = "static"; \
                sourceScale = 1; \
                text = label; \
                type = "text"; \
            };

#define HSI_LINES_30_SEGMENT(hdg) \
        {Tsd_Hsi_##hdg, POLAR(0, HSI_INNER_RADIUS_30_INC) , 1, Tsd_Ownship, 1}, \
        {Tsd_Hsi_##hdg, POLAR(0, HSI_OUTER_RADIUS)        , 1, Tsd_Ownship, 1}, \
        {}, \
        {Tsd_Hsi_##hdg, POLAR(5, HSI_INNER_RADIUS_5_INC)  , 1, Tsd_Ownship, 1}, \
        {Tsd_Hsi_##hdg, POLAR(5, HSI_OUTER_RADIUS)        , 1, Tsd_Ownship, 1}, \
        {}, \
        {Tsd_Hsi_##hdg, POLAR(10, HSI_INNER_RADIUS_10_INC), 1, Tsd_Ownship, 1}, \
        {Tsd_Hsi_##hdg, POLAR(10, HSI_OUTER_RADIUS)       , 1, Tsd_Ownship, 1}, \
        {}, \
        {Tsd_Hsi_##hdg, POLAR(15, HSI_INNER_RADIUS_5_INC) , 1, Tsd_Ownship, 1}, \
        {Tsd_Hsi_##hdg, POLAR(15, HSI_OUTER_RADIUS)       , 1, Tsd_Ownship, 1}, \
        {}, \
        {Tsd_Hsi_##hdg, POLAR(20, HSI_INNER_RADIUS_10_INC), 1, Tsd_Ownship, 1}, \
        {Tsd_Hsi_##hdg, POLAR(20, HSI_OUTER_RADIUS)       , 1, Tsd_Ownship, 1}, \
        {}, \
        {Tsd_Hsi_##hdg, POLAR(25, HSI_INNER_RADIUS_5_INC) , 1, Tsd_Ownship, 1}, \
        {Tsd_Hsi_##hdg, POLAR(25, HSI_OUTER_RADIUS)       , 1, Tsd_Ownship, 1}, \
        {}

#define HSI_POLY_BARBELL(hdg) \
        { \
            {Tsd_Hsi_Static_##hdg, {-0.005, HSI_OUTER_RADIUS+0.005} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {0.005, HSI_OUTER_RADIUS+0.005} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {0.005, HSI_OUTER_RADIUS-0.005} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {-0.005, HSI_OUTER_RADIUS-0.005} , 1, Tsd_Ownship, 1}, \
        }, \
        { \
            {Tsd_Hsi_Static_##hdg, {-0.005, HSI_OUTER_RADIUS-0.005} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {0.005, HSI_OUTER_RADIUS-0.005} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {0, HSI_OUTER_RADIUS-0.01} , 1, Tsd_Ownship, 1}, \
        }, \
        { \
            {Tsd_Hsi_Static_##hdg, {-0.005, HSI_OUTER_RADIUS-0.035} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {0.005, HSI_OUTER_RADIUS-0.035} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {0, HSI_OUTER_RADIUS-0.03} , 1, Tsd_Ownship, 1}, \
        }, \
        { \
            {Tsd_Hsi_Static_##hdg, {-0.005, HSI_OUTER_RADIUS-0.035} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {0.005, HSI_OUTER_RADIUS-0.035} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {0.005, HSI_OUTER_RADIUS-0.045} , 1, Tsd_Ownship, 1}, \
            {Tsd_Hsi_Static_##hdg, {-0.005, HSI_OUTER_RADIUS-0.045} , 1, Tsd_Ownship, 1}, \
        }

    class Occlude {
        clipTL[] = {0.1, 0.1};
        clipBR[] = {0.9, 0.9};
        class HSI {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_HSI));
            class lines {
                type = line;
                points[] = {
                    HSI_LINES_30_SEGMENT(360),
                    HSI_LINES_30_SEGMENT(30),
                    HSI_LINES_30_SEGMENT(60),
                    HSI_LINES_30_SEGMENT(90),
                    HSI_LINES_30_SEGMENT(120),
                    HSI_LINES_30_SEGMENT(150),
                    HSI_LINES_30_SEGMENT(180),
                    HSI_LINES_30_SEGMENT(210),
                    HSI_LINES_30_SEGMENT(240),
                    HSI_LINES_30_SEGMENT(270),
                    HSI_LINES_30_SEGMENT(300),
                    HSI_LINES_30_SEGMENT(330)
                };
                width = 3;
            };

            class BarBells {
                type=polygon;
                points[] = {
                    HSI_POLY_BARBELL(360),
                    HSI_POLY_BARBELL(45),
                    HSI_POLY_BARBELL(90),
                    HSI_POLY_BARBELL(135),
                    HSI_POLY_BARBELL(180),
                    HSI_POLY_BARBELL(225),
                    HSI_POLY_BARBELL(270),
                    HSI_POLY_BARBELL(315)
                };
            };

            MPD_HSI_TEXT(Tsd_Hsi_360, "N")
            MPD_HSI_TEXT(Tsd_Hsi_30, "3")
            MPD_HSI_TEXT(Tsd_Hsi_60, "6")
            MPD_HSI_TEXT(Tsd_Hsi_90, "E")
            MPD_HSI_TEXT(Tsd_Hsi_120, "12")
            MPD_HSI_TEXT(Tsd_Hsi_150, "15")
            MPD_HSI_TEXT(Tsd_Hsi_180, "S")
            MPD_HSI_TEXT(Tsd_Hsi_210, "21")
            MPD_HSI_TEXT(Tsd_Hsi_240, "24")
            MPD_HSI_TEXT(Tsd_Hsi_270, "W")
            MPD_HSI_TEXT(Tsd_Hsi_300, "30")
            MPD_HSI_TEXT(Tsd_Hsi_330, "33")
        };
    };
};
