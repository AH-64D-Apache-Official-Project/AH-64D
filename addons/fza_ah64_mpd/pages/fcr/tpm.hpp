// Native MFD overlay for the FCRTPM page, drawn above the HTML browser texture
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\mpd_defines.hpp"
#include "\fza_ah64_controls\headers\systemConstants.h"

class root {

    // 1. SCAN BAR — L->R then R->L, wide 6.4s cycle / narrow 3.2s
    class lines_tpmScanBar {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_LINE_SHOW), 1));

        class wide_near {
            condition = C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 1), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 3.2)));
            class line {
                type = "line"; width = 2;
                points[] = {
                    {"Fcr_TPM_NearBar_Wide", {0, 0.025}, 1},
                    {"Fcr_TPM_NearBar_Wide", {0, 0.600}, 1}
                };
            };
        };
        class wide_far {
            condition = C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 1), C_LESS(3.2, C_MPD_USER(MFD_IND_FCR_ANIM))));
            class line {
                type = "line"; width = 2;
                points[] = {
                    {"Fcr_TPM_FarBar_Wide", {0, 0.025}, 1},
                    {"Fcr_TPM_FarBar_Wide", {0, 0.600}, 1}
                };
            };
        };
        class narrow_near {
            condition = C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 0), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 1.6)));
            class line {
                type = "line"; width = 2;
                points[] = {
                    {"Fcr_TPM_NearBar_Narrow", {0, 0.025}, 1},
                    {"Fcr_TPM_NearBar_Narrow", {0, 0.600}, 1}
                };
            };
        };
        class narrow_far {
            condition = C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 0), C_LESS(1.6, C_MPD_USER(MFD_IND_FCR_ANIM))));
            class line {
                type = "line"; width = 2;
                points[] = {
                    {"Fcr_TPM_FarBar_Narrow", {0, 0.025}, 1},
                    {"Fcr_TPM_FarBar_Narrow", {0, 0.600}, 1}
                };
            };
        };
    };

    // 2. BLACKOUT MASK — arc covered by convex strips matching lines_tpmGeometry_* chords (concave polygons fan-fill unreliably)
    class tpmBlackoutMask_Always {
        color[] = {0, 0, 0, 1};
        class MaskTop {
            type = "polygon";
            points[] = {
                {
                    {{0.000, 0.025}, 1},
                    {{1.000, 0.025}, 1},
                    {{1.000, 0.270}, 1},
                    {{0.000, 0.270}, 1}
                }
            };
        };
        class MaskBottom {
            type = "polygon";
            points[] = {
                {
                    {{0.000, 0.870}, 1},
                    {{1.000, 0.870}, 1},
                    {{1.000, 0.975}, 1},
                    {{0.000, 0.975}, 1}
                }
            };
        };
    };

    // Wide mode mask (TPM_WIDE=1)
    class tpmBlackoutMask_Wide {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 1));
        class lines {
            color[] = {0, 0, 0, 1};
            class MaskLeft {
                type = "polygon";
                points[] = {
                    {
                        {{0.000, 0.270}, 1},
                        {{0.080, 0.270}, 1},
                        {{0.080, 0.870}, 1},
                        {{0.000, 0.870}, 1}
                    }
                };
            };
            class MaskRight {
                type = "polygon";
                points[] = {
                    {
                        {{0.920, 0.270}, 1},
                        {{1.000, 0.270}, 1},
                        {{1.000, 0.870}, 1},
                        {{0.920, 0.870}, 1}
                    }
                };
            };
            // One convex strip per arc chord — points match lines_tpmGeometry_Wide 2500m arc
            class MaskArcTop {
                type = "polygon";
                points[] = {
                    { {{0.080, 0.442}, 1}, {{0.124, 0.403}, 1}, {{0.124, 0.270}, 1}, {{0.080, 0.270}, 1} },
                    { {{0.124, 0.403}, 1}, {{0.171, 0.369}, 1}, {{0.171, 0.270}, 1}, {{0.124, 0.270}, 1} },
                    { {{0.171, 0.369}, 1}, {{0.221, 0.339}, 1}, {{0.221, 0.270}, 1}, {{0.171, 0.270}, 1} },
                    { {{0.221, 0.339}, 1}, {{0.273, 0.315}, 1}, {{0.273, 0.270}, 1}, {{0.221, 0.270}, 1} },
                    { {{0.273, 0.315}, 1}, {{0.328, 0.295}, 1}, {{0.328, 0.270}, 1}, {{0.273, 0.270}, 1} },
                    { {{0.328, 0.295}, 1}, {{0.384, 0.281}, 1}, {{0.384, 0.270}, 1}, {{0.328, 0.270}, 1} },
                    { {{0.384, 0.281}, 1}, {{0.442, 0.273}, 1}, {{0.442, 0.270}, 1}, {{0.384, 0.270}, 1} },
                    { {{0.442, 0.273}, 1}, {{0.500, 0.270}, 1}, {{0.442, 0.270}, 1} },
                    { {{0.500, 0.270}, 1}, {{0.558, 0.273}, 1}, {{0.558, 0.270}, 1} },
                    { {{0.558, 0.273}, 1}, {{0.616, 0.281}, 1}, {{0.616, 0.270}, 1}, {{0.558, 0.270}, 1} },
                    { {{0.616, 0.281}, 1}, {{0.672, 0.295}, 1}, {{0.672, 0.270}, 1}, {{0.616, 0.270}, 1} },
                    { {{0.672, 0.295}, 1}, {{0.727, 0.315}, 1}, {{0.727, 0.270}, 1}, {{0.672, 0.270}, 1} },
                    { {{0.727, 0.315}, 1}, {{0.779, 0.339}, 1}, {{0.779, 0.270}, 1}, {{0.727, 0.270}, 1} },
                    { {{0.779, 0.339}, 1}, {{0.829, 0.369}, 1}, {{0.829, 0.270}, 1}, {{0.779, 0.270}, 1} },
                    { {{0.829, 0.369}, 1}, {{0.876, 0.403}, 1}, {{0.876, 0.270}, 1}, {{0.829, 0.270}, 1} },
                    { {{0.876, 0.403}, 1}, {{0.920, 0.442}, 1}, {{0.920, 0.270}, 1}, {{0.876, 0.270}, 1} }
                };
            };
        };
    };

    // Narrow mode mask (TPM_WIDE=0): convex rect + radial triangle per side
    class tpmBlackoutMask_Narrow {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 0));
        class lines {
            color[] = {0, 0, 0, 1};
            class MaskNarrowLeft {
                type = "polygon";
                points[] = {
                    { {{0.000, 0.270}, 1}, {{0.076, 0.270}, 1}, {{0.076, 0.870}, 1}, {{0.000, 0.870}, 1} },
                    { {{0.076, 0.446}, 1}, {{0.500, 0.870}, 1}, {{0.076, 0.870}, 1} }
                };
            };
            class MaskNarrowRight {
                type = "polygon";
                points[] = {
                    { {{0.924, 0.270}, 1}, {{1.000, 0.270}, 1}, {{1.000, 0.870}, 1}, {{0.924, 0.870}, 1} },
                    { {{0.924, 0.446}, 1}, {{0.924, 0.870}, 1}, {{0.500, 0.870}, 1} }
                };
            };
            // One convex strip per arc chord — points match lines_tpmGeometry_Narrow 2500m arc
            class MaskArcTop {
                type = "polygon";
                points[] = {
                    { {{0.076, 0.446}, 1}, {{0.167, 0.371}, 1}, {{0.167, 0.270}, 1}, {{0.076, 0.270}, 1} },
                    { {{0.167, 0.371}, 1}, {{0.271, 0.316}, 1}, {{0.271, 0.270}, 1}, {{0.167, 0.270}, 1} },
                    { {{0.271, 0.316}, 1}, {{0.383, 0.282}, 1}, {{0.383, 0.270}, 1}, {{0.271, 0.270}, 1} },
                    { {{0.383, 0.282}, 1}, {{0.500, 0.270}, 1}, {{0.383, 0.270}, 1} },
                    { {{0.500, 0.270}, 1}, {{0.617, 0.282}, 1}, {{0.617, 0.270}, 1} },
                    { {{0.617, 0.282}, 1}, {{0.729, 0.316}, 1}, {{0.729, 0.270}, 1}, {{0.617, 0.270}, 1} },
                    { {{0.729, 0.316}, 1}, {{0.833, 0.371}, 1}, {{0.833, 0.270}, 1}, {{0.729, 0.270}, 1} },
                    { {{0.833, 0.371}, 1}, {{0.924, 0.446}, 1}, {{0.924, 0.270}, 1}, {{0.833, 0.270}, 1} }
                };
            };
        };
    };

    // 3. HAD BOX
    class lines_HAD {
        type = "line";
        width = 3;
        points[] = {
            {{0.38, 0.894}, 1},
            {{0.62, 0.894}, 1},
            {{0.62, 0.894}, 1},
            {{0.62, 0.984}, 1},
            {{0.62, 0.984}, 1},
            {{0.38, 0.984}, 1},
            {{0.38, 0.984}, 1},
            {{0.38, 0.894}, 1}, {},
            MPD_POINTS_BOX("Null", 0.22-(6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, 12*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT), {},
            MPD_POINTS_BOX("Null", 0.78-(6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, 12*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT), {},
        };
    };

    // TM 4.35.17: obstacle count window appears only when obstacles are detected
    class linesObsCountBox {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_OBS_SHOW), 1));
        class box {
            type = "line";
            width = 3;
            points[] = {
                MPD_POINTS_BOX("Null", 0.95-(4*MPD_TEXT_WIDTH), 0.04, 4*MPD_TEXT_WIDTH, 0.9*MPD_TEXT_HEIGHT), {},
            };
        };
    };

    // 4. HEADING TAPE
    #include "..\common\fcrHeadingTape.hpp"
    class Obscurants {
        color[] = {0,0,0,1};
        class HeadingTape {
            type = "polygon";
            points[] = {
                {
                    {{0.5 - MPD_TEXT_WIDTH * 1.5, 0.06 - MPD_TEXT_HEIGHT}, 1},
                    {{0.5 + MPD_TEXT_WIDTH * 1.5, 0.06 - MPD_TEXT_HEIGHT}, 1},
                    {{0.5 + MPD_TEXT_WIDTH * 1.5, 0.06}, 1},
                    {{0.5 - MPD_TEXT_WIDTH * 1.5, 0.06}, 1}
                }
            };
        };
    };
    MPD_TEXT_C(Heading, 0.5, 0.015, source = "heading"; sourceScale = 1;)

    class headingTapeNotch {
        type = "line";
        width = 8;
        points[] = {
            {{0.5, 0.09}, 1},
            {{0.5, 0.13}, 1},
        };
    };

    // 5. BUTTONS / TEXT
    class Cscope {
        MPD_TEXT_C(C_SCP, MPD_POS_BUTTON_TB_1_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("C SCP"))
        class Boxed {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_CSCOPE), 1));
            MPD_BOX_C(UTIL, MPD_POS_BUTTON_TB_1_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_T_Y, 5)
        };
    };

    class text {
        MPD_TEXT_R(SSS, 0.22 - (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_SSS))
        MPD_TEXT_L(RRS, 0.22 + (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_RRS))
        MPD_TEXT_R(SS,  0.22 - (6*MPD_TEXT_WIDTH), 0.939,                   MPD_TEXT_USER(MFD_TEXT_IND_FCR_SS))
        MPD_TEXT_R(WC,  0.78 - (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_WC))
        MPD_TEXT_R(WS,  0.78 - (6*MPD_TEXT_WIDTH), 0.939,                   MPD_TEXT_USER(MFD_TEXT_IND_FCR_WS))
        MPD_TEXT_L(OBS_Count, 0.95, 0.04, MPD_TEXT_USER(MFD_TEXT_IND_FCR_TPM_OBS))
    };

    class tpmVabs {
        MPD_BOX_BAR_T(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        MPD_TEXT_C(UTIL,    MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))
    };

    class tpmValueBoxes {
        MPD_TEXT_R(PROF_Label,   MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PROF"))
        MPD_TEXT_R(PROF_Val,     MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_TPM_PROF))
        MPD_BOX_R(PROF_ValBox,   MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 5)
        MPD_TEXT_R(LINES_Label,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("LINES"))
        MPD_TEXT_R(LINES_Val,    MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_TPM_LINES))
        MPD_BOX_R(LINES_ValBox,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 1)
        MPD_TEXT_L(CLRNC_Label,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CLEARANCE"))
        MPD_TEXT_L(CLRNC_Val,    MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_TPM_CLR))
        MPD_BOX_L(CLRNC_ValBox,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 3)
        MPD_TEXT_L(ELEV_Label,   MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ELEV"))
        MPD_TEXT_L(ELEV_Val,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("NEAR"))
        MPD_BOX_L(ELEV_ValBox,   MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 4)
    };

    // 6. TPM ARC GEOMETRY — ownship (0.5, 0.870), r=0.600 HPP = 2500 m

    // Wide geometry: full +-90 deg arcs. Shown when speed <45kts (TPM_WIDE=1).
    class lines_tpmGeometry_Wide {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 1));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                // 100 m arc — r=0.024, 33 pts, step=5.625 deg, az=-90->+90
                {{0.476, 0.870}, 1}, {{0.476, 0.868}, 1}, {{0.476, 0.865}, 1}, {{0.477, 0.863}, 1},
                {{0.478, 0.861}, 1}, {{0.479, 0.859}, 1}, {{0.480, 0.857}, 1}, {{0.481, 0.855}, 1},
                {{0.483, 0.853}, 1}, {{0.485, 0.852}, 1}, {{0.487, 0.850}, 1}, {{0.489, 0.849}, 1},
                {{0.491, 0.848}, 1}, {{0.493, 0.847}, 1}, {{0.495, 0.847}, 1}, {{0.497, 0.846}, 1},
                {{0.500, 0.846}, 1},
                {{0.503, 0.846}, 1}, {{0.505, 0.847}, 1}, {{0.507, 0.847}, 1}, {{0.509, 0.848}, 1},
                {{0.511, 0.849}, 1}, {{0.513, 0.850}, 1}, {{0.515, 0.852}, 1}, {{0.517, 0.853}, 1},
                {{0.519, 0.855}, 1}, {{0.520, 0.857}, 1}, {{0.521, 0.859}, 1}, {{0.522, 0.861}, 1},
                {{0.523, 0.863}, 1}, {{0.524, 0.865}, 1}, {{0.524, 0.868}, 1}, {{0.524, 0.870}, 1}, {},

                // 1000 m arc — r=0.240, 33 pts, step=5.625 deg, az=-90->+90
                {{0.260, 0.870}, 1}, {{0.261, 0.847}, 1}, {{0.265, 0.823}, 1}, {{0.270, 0.800}, 1},
                {{0.278, 0.778}, 1}, {{0.288, 0.757}, 1}, {{0.300, 0.737}, 1}, {{0.314, 0.718}, 1},
                {{0.330, 0.700}, 1}, {{0.348, 0.684}, 1}, {{0.367, 0.671}, 1}, {{0.387, 0.659}, 1},
                {{0.408, 0.649}, 1}, {{0.430, 0.640}, 1}, {{0.453, 0.635}, 1}, {{0.476, 0.631}, 1},
                {{0.500, 0.630}, 1},
                {{0.524, 0.631}, 1}, {{0.547, 0.635}, 1}, {{0.570, 0.640}, 1}, {{0.592, 0.649}, 1},
                {{0.613, 0.659}, 1}, {{0.633, 0.671}, 1}, {{0.652, 0.684}, 1}, {{0.670, 0.700}, 1},
                {{0.686, 0.718}, 1}, {{0.700, 0.737}, 1}, {{0.712, 0.757}, 1}, {{0.722, 0.778}, 1},
                {{0.730, 0.800}, 1}, {{0.735, 0.823}, 1}, {{0.739, 0.847}, 1}, {{0.740, 0.870}, 1}, {},

                // 2000 m arc — r=0.480, 25 pts, clipped at x=0.080/0.920
                {{0.080, 0.637}, 1}, {{0.103, 0.600}, 1}, {{0.127, 0.568}, 1}, {{0.157, 0.534}, 1},
                {{0.191, 0.503}, 1}, {{0.221, 0.479}, 1}, {{0.257, 0.456}, 1}, {{0.295, 0.436}, 1},
                {{0.334, 0.420}, 1}, {{0.375, 0.407}, 1}, {{0.417, 0.397}, 1}, {{0.458, 0.392}, 1},
                {{0.500, 0.390}, 1},
                {{0.542, 0.392}, 1}, {{0.583, 0.397}, 1}, {{0.625, 0.407}, 1}, {{0.666, 0.420}, 1},
                {{0.705, 0.436}, 1}, {{0.743, 0.456}, 1}, {{0.779, 0.479}, 1}, {{0.809, 0.503}, 1},
                {{0.843, 0.534}, 1}, {{0.873, 0.568}, 1}, {{0.897, 0.600}, 1}, {{0.920, 0.637}, 1}, {},

                // 2500 m arc — r=0.600, 17 pts, clipped at x=0.080/0.920
                {{0.080, 0.442}, 1}, {{0.124, 0.403}, 1}, {{0.171, 0.369}, 1}, {{0.221, 0.339}, 1},
                {{0.273, 0.315}, 1}, {{0.328, 0.295}, 1}, {{0.384, 0.281}, 1}, {{0.442, 0.273}, 1},
                {{0.500, 0.270}, 1},
                {{0.558, 0.273}, 1}, {{0.616, 0.281}, 1}, {{0.672, 0.295}, 1}, {{0.727, 0.315}, 1},
                {{0.779, 0.339}, 1}, {{0.829, 0.369}, 1}, {{0.876, 0.403}, 1}, {{0.920, 0.442}, 1}, {},
            };
        };
    };

    // Wide border: U-shape down both sides and across bottom.
    class lines_tpmBorder_Wide {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 1));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {{0.080, 0.442}, 1}, {{0.080, 0.870}, 1}, {{0.920, 0.870}, 1}, {{0.920, 0.442}, 1}, {},
            };
        };
    };

    // Narrow geometry: +-45 deg arcs. Shown when speed >55kts (TPM_WIDE=0).
    class lines_tpmGeometry_Narrow {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 0));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                // 100 m arc — r=0.024, az=-45->+45, 9 pts
                {{0.483, 0.853}, 1}, {{0.487, 0.850}, 1}, {{0.491, 0.848}, 1}, {{0.496, 0.847}, 1},
                {{0.500, 0.846}, 1},
                {{0.504, 0.847}, 1}, {{0.509, 0.848}, 1}, {{0.513, 0.850}, 1}, {{0.517, 0.853}, 1}, {},

                // 1000 m arc — r=0.240, az=-45->+45, 9 pts
                {{0.330, 0.700}, 1}, {{0.367, 0.670}, 1}, {{0.408, 0.648}, 1}, {{0.453, 0.635}, 1},
                {{0.500, 0.630}, 1},
                {{0.547, 0.635}, 1}, {{0.592, 0.648}, 1}, {{0.633, 0.670}, 1}, {{0.670, 0.700}, 1}, {},

                // 2000 m arc — r=0.480, az=-45->+45, 9 pts
                {{0.161, 0.531}, 1}, {{0.233, 0.471}, 1}, {{0.316, 0.426}, 1}, {{0.406, 0.399}, 1},
                {{0.500, 0.390}, 1},
                {{0.594, 0.399}, 1}, {{0.684, 0.426}, 1}, {{0.767, 0.471}, 1}, {{0.839, 0.531}, 1}, {},

                // 2500 m arc — r=0.600, az=-45->+45, 9 pts
                {{0.076, 0.446}, 1}, {{0.167, 0.371}, 1}, {{0.271, 0.316}, 1}, {{0.383, 0.282}, 1},
                {{0.500, 0.270}, 1},
                {{0.617, 0.282}, 1}, {{0.729, 0.316}, 1}, {{0.833, 0.371}, 1}, {{0.924, 0.446}, 1}, {},
            };
        };
    };

    // Narrow border: straight radial lines from ownship to +-45 deg @ 2500m.
    class lines_tpmBorder_Narrow {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_TPM_WIDE), 0));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {{0.500, 0.870}, 1}, {{0.076, 0.446}, 1}, {},
                {{0.500, 0.870}, 1}, {{0.924, 0.446}, 1}, {},
            };
        };
    };

};
