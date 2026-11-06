class vabs_show {
    condition = C_COND(C_AND(C_NOT(C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 1)), C_NOT(C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 5))));
    #include "components\vabs_top.hpp"
};

// The scale boxes' numbers (frame.hpp), from behind the ownship to ahead of it; with ZOOM 20 percent further from it,
// those still on the map
#define TSD_SCALE_TEXT(name, posY, label) MPD_TEXT_BONE_R(name, "Tsd_Ownship", 0.10, (posY)-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(label))
#define TSD_SCALE_TEXTS(label1, label2, label3, label4, label5) \
    class Unzoomed { \
        condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_TSD_ZOOM))); \
        TSD_SCALE_TEXT(ScaleBox1, 0.87, label1) \
        TSD_SCALE_TEXT(ScaleBox2, 0.62, label2) \
        TSD_SCALE_TEXT(ScaleBox3, 0.37, label3) \
        TSD_SCALE_TEXT(ScaleBox4, 0.12, label4) \
        TSD_SCALE_TEXT(ScaleBox5, -0.13, label5) \
    }; \
    class Zoomed { \
        condition = C_COND(C_MPD_USER(MFD_IND_TSD_ZOOM)); \
        TSD_SCALE_TEXT(ScaleBox2, TSD_ZOOMED(0.62), label2) \
        TSD_SCALE_TEXT(ScaleBox3, TSD_ZOOMED(0.37), label3) \
        class LowerThird { \
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_TSD_CTR))); \
            TSD_SCALE_TEXT(ScaleBox4, TSD_ZOOMED(0.12), label4) \
        }; \
    };

class tsdCommon {
    class ase_footPrint {
        condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_TSD_ASE_FOOTPRINT)));
        class ase_footprint_lines {
            type = "line";
            width = 3;
            points[] = {
                {{0.18, 0.18}, 1}, {{0.82, 0.18}, 1}, {{0.82, 0.82}, 1}, {{0.18, 0.82}, 1}, {{0.18, 0.18}, 1}, {}, //inside box
            };
        };
    };


    class Scale_Boxes_5km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 5000));
        TSD_SCALE_TEXTS("3", "1", "1", "3", "5")
    };

    class Scale_Boxes_10km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 10000));
        TSD_SCALE_TEXTS("3", "2", "2", "6", "10")
    };

    class Scale_Boxes_25km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 25000));
        TSD_SCALE_TEXTS("15", "5", "5", "15", "25")
    };

    class Scale_Boxes_50km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 50000));
        TSD_SCALE_TEXTS("30", "10", "10", "30", "50")
    };

    // The ownship: cyan on a live map. On a frozen map (FRZ, CAQ, PAN) white at its place with stopped rotors, and the live
    // one in cyan moving over the map; the map border is dashed (frame.hpp)
    class Ownship {
        class Live {
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_TSD_FROZEN)));
            color[] = {0,1,1,1};
            class Lines {
                type = "line";
                width = 3;
                points[] = {
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.02, 0.0}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.014, -0.014}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, -0.02}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.014, -0.014}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.02, 0.0}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.014, 0.014}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, 0.02}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.014, 0.014}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.02, 0.0}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, 0.02}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, 0.04}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, 0.04}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.0125, 0.04}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.0125, 0.03}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.0125, 0.05}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, 0.0025}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, -0.0025}, 1}
                };
            };
        };
        class Frozen {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_FROZEN));
            color[] = {1,1,1,1};
            class Lines {
                type = "line";
                width = 3;
                points[] = {
                    //Stopped rotor blades
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, -0.02}, 1}, {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, 0.02}, 1}, {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.014, -0.014}, 1}, {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.014, 0.014}, 1}, {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.014, -0.014}, 1}, {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.014, 0.014}, 1}, {},
                    //Tail boom, tail rotor axle and tail rotor
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, 0.02}, 1}, {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, 0.04}, 1}, {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.0, 0.04}, 1}, {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.0125, 0.04}, 1}, {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.0125, 0.03}, 1}, {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.0125, 0.05}, 1}
                };
            };
        };
        class Moving {
            condition = C_COND(C_MPD_USER(MFD_IND_TSD_FROZEN));
            color[] = {0,1,1,1};
            clipTL[] = {0, 0};
            clipBR[] = {1, 1};
            class Lines {
                type = "line";
                width = 3;
                points[] = {
                    {"Tsd_Live_Rot", {0.02, 0.0}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {0.014, -0.014}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {0.0, -0.02}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {-0.014, -0.014}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {-0.02, 0.0}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {-0.014, 0.014}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {0.0, 0.02}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {0.014, 0.014}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {0.02, 0.0}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {},
                    {"Tsd_Live_Rot", {0.0, 0.02}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {0.0, 0.04}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {},
                    {"Tsd_Live_Rot", {0.0, 0.04}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {-0.0125, 0.04}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {},
                    {"Tsd_Live_Rot", {-0.0125, 0.03}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {-0.0125, 0.05}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {},
                    {"Tsd_Live_Rot", {0.0, 0.0025}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1},
                    {"Tsd_Live_Rot", {0.0, -0.0025}, 1, "Tsd_Live_X", 1, "Tsd_Live_Y", 1}
                };
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
    MPD_TEXT_C(HeadingHigh, 0.5, MPD_POS_BUTTON_T_Y, source = "heading"; sourceScale = 1;)
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
                type = "line";
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
                type="polygon";
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

#undef TSD_SCALE_TEXTS
#undef TSD_SCALE_TEXT
