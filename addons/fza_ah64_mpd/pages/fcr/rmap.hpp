// Native MFD overlay for the FCRRMAP page, drawn above the HTML browser texture
// Painter order: scan bar → blackout mask → geometry/text (so mask clips scan bar at B-scope edges,
// and all HPP geometry/text appears on top of the mask).
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\mpd_defines.hpp"
#include "\fza_ah64_controls\headers\systemConstants.h"

class root {

    // 1. CUED LOS — before mask so it clips to the B-scope area
    class polys_CuedLOS {
        class Polygon {
            type = "polygon";
            points[] = {
                {
                    {"FCR_CuedLOS_X", 1, "FCR_CuedLOS_Y", {-0.005, 0.000}, 1},
                    {"FCR_CuedLOS_X", 1, "FCR_CuedLOS_Y", {0.000, -0.005}, 1},
                    {"FCR_CuedLOS_X", 1, "FCR_CuedLOS_Y", {0.005, 0.000}, 1},
                    {"FCR_CuedLOS_X", 1, "FCR_CuedLOS_Y", {0.000, 0.005}, 1}
                },
            };
        };
    };

    // 2. SCAN BAR — bone-driven, before mask; near L->R spans 0-4km, far R->L spans 4-8km
    class lines_show {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_LINE_SHOW), 1));
        class lines_continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_TYPE), FCR_MODE_ON_CONTINUOUS));
            class nearBar {
                condition = C_COND(C_AND(C_LESS(0,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM),1.6)));
                class line {
                    type = "line";
                    width = 3;
                    points[] = {
                        {"FCR_RMAP_NearBar", {0, 0.513}, 1},
                        {"FCR_RMAP_NearBar", {0, 0.875}, 1}
                    };
                };
            };
            class farBar {
                condition = C_COND(C_AND(C_LESS(1.6,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM),3.2)));
                class line {
                    type = "line";
                    width = 3;
                    points[] = {
                        {"FCR_RMAP_FarBar", {0, 0.150}, 1},
                        {"FCR_RMAP_FarBar", {0, 0.513}, 1}
                    };
                };
            };
        };
        class lines_single {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_TYPE), FCR_MODE_ON_SINGLE));
            color[] = {1,1,1,1};
            class nearBar {
                condition = C_COND(C_AND(C_LESS(0,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM),1.6)));
                class line {
                    type = "line";
                    width = 3;
                    points[] = {
                        {"FCR_RMAP_NearBar", {0, 0.513}, 1},
                        {"FCR_RMAP_NearBar", {0, 0.875}, 1}
                    };
                };
            };
            class farBar {
                condition = C_COND(C_AND(C_LESS(1.6,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM),3.2)));
                class line {
                    type = "line";
                    width = 3;
                    points[] = {
                        {"FCR_RMAP_FarBar", {0, 0.150}, 1},
                        {"FCR_RMAP_FarBar", {0, 0.513}, 1}
                    };
                };
            };
        };
    };

    // 3. BLACKOUT MASK — after the scan bar so it clips it, everything below draws on top
    class rmapBlackoutMask {
        color[] = {0, 0, 0, 1};
        class MaskLeft {
            type = "polygon";
            points[] = {
                {
                    {{0.000, 0.025}, 1},
                    {{0.180, 0.025}, 1},
                    {{0.180, 0.975}, 1},
                    {{0.000, 0.975}, 1}
                }
            };
        };
        class MaskRight {
            type = "polygon";
            points[] = {
                {
                    {{0.820, 0.025}, 1},
                    {{1.000, 0.025}, 1},
                    {{1.000, 0.975}, 1},
                    {{0.820, 0.975}, 1}
                }
            };
        };
        class MaskTop {
            type = "polygon";
            points[] = {
                {
                    {{0.180, 0.025}, 1},
                    {{0.820, 0.025}, 1},
                    {{0.820, 0.150}, 1},
                    {{0.180, 0.150}, 1}
                }
            };
        };
        class MaskBottom {
            type = "polygon";
            points[] = {
                {
                    {{0.180, 0.875}, 1},
                    {{0.820, 0.875}, 1},
                    {{0.820, 0.975}, 1},
                    {{0.180, 0.975}, 1}
                }
            };
        };
    };

    // ── 4. HAD BOX ───────────────────────────────────────────────────────────
    class lines_HAD {
        type = "line";
        width = 3;
        points[] = {
            //Top
            {{0.38, 0.894}, 1},
            {{0.62, 0.894}, 1},
            //Right
            {{0.62, 0.894}, 1},
            {{0.62, 0.984}, 1},
            //Bottom
            {{0.62, 0.984}, 1},
            {{0.38, 0.984}, 1},
            //Left
            {{0.38, 0.984}, 1},
            {{0.38, 0.894}, 1}, {},
            //Left HAD box
            MPD_POINTS_BOX("Null", 0.22-(6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, 12*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT), {},
            //Right HAD box
            MPD_POINTS_BOX("Null", 0.78-(6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, 12*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT), {},
        };
    };

    // 5. HEADING TAPE
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

    // 6. B-SCOPE GEOMETRY — border matches HTML canvas RADAR_* bounds (0.18,0.150)-(0.82,0.875)
    class lines_bscopeOutline {
        type = "line";
        width = 2;
        points[] = {
            {{0.18, 0.150}, 1}, {{0.82, 0.150}, 1}, {{0.82, 0.875}, 1}, {{0.18, 0.875}, 1}, {{0.18, 0.150}, 1}, {},
        };
    };

    // Range lines at 2/4/6 km, edge tics at 1/3/5/7 km; 0.090625 HPP/km
    class lines_bscopeRangeMarkers {
        type = "line";
        width = 1;
        points[] = {
            // 2 km — Y = 0.694
            {{0.18, 0.694}, 1}, {{0.82, 0.694}, 1}, {},
            // 4 km — Y = 0.513
            {{0.18, 0.513}, 1}, {{0.82, 0.513}, 1}, {},
            // 6 km — Y = 0.331
            {{0.18, 0.331}, 1}, {{0.82, 0.331}, 1}, {},
            // 1 km tic marks — Y = 0.784
            {{0.18, 0.784}, 1}, {{0.21, 0.784}, 1}, {}, {{0.79, 0.784}, 1}, {{0.82, 0.784}, 1}, {},
            // 3 km tic marks — Y = 0.603
            {{0.18, 0.603}, 1}, {{0.21, 0.603}, 1}, {}, {{0.79, 0.603}, 1}, {{0.82, 0.603}, 1}, {},
            // 5 km tic marks — Y = 0.422
            {{0.18, 0.422}, 1}, {{0.21, 0.422}, 1}, {}, {{0.79, 0.422}, 1}, {{0.82, 0.422}, 1}, {},
            // 7 km tic marks — Y = 0.241
            {{0.18, 0.241}, 1}, {{0.21, 0.241}, 1}, {}, {{0.79, 0.241}, 1}, {{0.82, 0.241}, 1}, {},
        };
    };

    // Scan sector boundary marks on TOP border, pointing inward (down).
    class lines_bscopeAzimuthNotches {
        type = "line";
        width = 1;
        points[] = {
            {{0.287, 0.150}, 1}, {{0.287, 0.165}, 1}, {},
            {{0.393, 0.150}, 1}, {{0.393, 0.165}, 1}, {},
            {{0.500, 0.150}, 1}, {{0.500, 0.165}, 1}, {},
            {{0.607, 0.150}, 1}, {{0.607, 0.165}, 1}, {},
            {{0.713, 0.150}, 1}, {{0.713, 0.165}, 1}, {},
        };
    };

    // ── 7. TEXT / BUTTONS / STATUS ───────────────────────────────────────────
    class acq {
        MPD_ACQ_SRC(Acq, MFD_IND_FCR_ACQ_BOX, MFD_TEXT_IND_FCR_ACQ_SRC, "Fcr_Acq")
        MPD_BOX_BAR_L(Acq, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y)
    };

    class text {
        //HAD left
        MPD_TEXT_R(SSS, 0.22 - (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_SSS))
        MPD_TEXT_L(RRS, 0.22 + (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_RRS))
        MPD_TEXT_R(SS,  0.22 - (6*MPD_TEXT_WIDTH), 0.939,                   MPD_TEXT_USER(MFD_TEXT_IND_FCR_SS))
        //HAD right
        MPD_TEXT_R(WC,  0.78 - (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_WC))
        MPD_TEXT_R(WS,  0.78 - (6*MPD_TEXT_WIDTH), 0.939,                   MPD_TEXT_USER(MFD_TEXT_IND_FCR_WS))
    };

    class Cscope {
        MPD_TEXT_C(C_SCP, MPD_POS_BUTTON_TB_1_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("C SCP"))
        class Boxed {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_CSCOPE), 1));
            MPD_BOX_C(UTIL, MPD_POS_BUTTON_TB_1_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_T_Y, 5)
        };
    };

    class elev {
        class polys_elev {
            type = "polygon";
            points[] = {
                {
                    { {0.060, 0.860}, 1 },
                    { {0.072, 0.850}, 1 },
                    { {0.072, 0.870}, 1 },
                },
            };
        };
        class lines_elev {
            type = "line";
            width = 3;
            points[] = {
                {{0.030, 0.800}, 1}, {{0.060, 0.800}, 1}, {},
                {{0.030, 0.815}, 1}, {{0.050, 0.815}, 1}, {},
                {{0.030, 0.830}, 1}, {{0.050, 0.830}, 1}, {},
                {{0.030, 0.845}, 1}, {{0.050, 0.845}, 1}, {},
                {{0.030, 0.860}, 1}, {{0.050, 0.860}, 1}, {},
                {{0.030, 0.875}, 1}, {{0.060, 0.875}, 1}, {},
                {{0.030, 0.890}, 1}, {{0.050, 0.890}, 1}, {},
                {{0.030, 0.905}, 1}, {{0.050, 0.905}, 1}, {},
                {{0.030, 0.920}, 1}, {{0.060, 0.920}, 1}, {},
                MPD_POINTS_BOX("Null", 0.95-(4*MPD_TEXT_WIDTH), 0.04, 4*MPD_TEXT_WIDTH, 0.9*MPD_TEXT_HEIGHT), {},
            };
        };
        MPD_TEXT_L(COUNT, 0.95, 0.04, MPD_TEXT_USER(MFD_TEXT_IND_FCR_COUNT))
    };

    class rmapVabs {
        //T6
        MPD_BOX_BAR_T(UTIL,    MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        MPD_TEXT_C(UTIL,       MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))
        //R1 ZOOM
        MPD_TEXT_L(ZOOM_1,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 1.125 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Z"))
        MPD_TEXT_L(ZOOM_2,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.375 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_L(ZOOM_3,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.375 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_L(ZOOM_4,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 1.125 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))
        MPD_BOX_BAR_L(ZOOM, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y)
        //R4
        MPD_TEXT_L(RFHO_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("RF"))
        MPD_TEXT_L(RFHO_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("HO"))
        MPD_BOX_BAR_L(RFHO, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
        //L1 NTS
        MPD_TEXT_R(NTS_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("N"))
        MPD_TEXT_R(NTS_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y,                        MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(NTS_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
        //L4 TGT
        MPD_TEXT_R(TGT_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(TGT_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y,                        MPD_TEXT_STATIC("G"))
        MPD_TEXT_R(TGT_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_BOX_BAR_R(TGT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y)
        //L5 ELEV
        MPD_TEXT_R(ELEV_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ELEV"))
        MPD_BOX_R(ELEV, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, 4)
        MPD_TEXT_R(ELEV, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("AUTO"))
        MPD_BOX_BAR_R(ELEV, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y)
    };

    class fcrOffsetArrows {
        class leftArrowHollow {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_ARROW_L), 1));
            class lines {
                type = "line";
                width = 3;
                points[] = {
                    {{0.025, 0.335}, 1},
                    {{0.054, 0.320}, 1},
                    {{0.060, 0.320}, 1},
                    {{0.060, 0.328}, 1},
                    {{0.078, 0.328}, 1},
                    {{0.078, 0.344}, 1},
                    {{0.060, 0.344}, 1},
                    {{0.060, 0.352}, 1},
                    {{0.054, 0.352}, 1},
                    {{0.025, 0.335}, 1},
                };
            };
        };
        class leftArrowSolid {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_ARROW_L), 2));
            class poly {
                type = "polygon";
                points[] = {
                    {{{0.025, 0.335}, 1}, {{0.054, 0.320}, 1}, {{0.054, 0.352}, 1}},
                    {{{0.054, 0.352}, 1}, {{0.054, 0.320}, 1}, {{0.060, 0.320}, 1}, {{0.060, 0.352}, 1}},
                    {{{0.060, 0.328}, 1}, {{0.078, 0.328}, 1}, {{0.078, 0.344}, 1}, {{0.060, 0.344}, 1}}
                };
            };
        };
        class leftArrowBrick {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_ARROW_L), 3));
            MPD_BOX_BAR_R(leftArrowBrick, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y)
        };
        class rightArrowHollow {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_ARROW_R), 1));
            class lines {
                type = "line";
                width = 3;
                points[] = {
                    {{0.975, 0.335}, 1},
                    {{0.946, 0.320}, 1},
                    {{0.940, 0.320}, 1},
                    {{0.940, 0.328}, 1},
                    {{0.922, 0.328}, 1},
                    {{0.922, 0.344}, 1},
                    {{0.940, 0.344}, 1},
                    {{0.940, 0.352}, 1},
                    {{0.946, 0.352}, 1},
                    {{0.975, 0.335}, 1},
                };
            };
        };
        class rightArrowSolid {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_ARROW_R), 2));
            class poly {
                type = "polygon";
                points[] = {
                    {{{0.975, 0.335}, 1}, {{0.946, 0.320}, 1}, {{0.946, 0.352}, 1}},
                    {{{0.946, 0.352}, 1}, {{0.946, 0.320}, 1}, {{0.940, 0.320}, 1}, {{0.940, 0.352}, 1}},
                    {{{0.940, 0.328}, 1}, {{0.922, 0.328}, 1}, {{0.922, 0.344}, 1}, {{0.940, 0.344}, 1}}
                };
            };
        };
        class rightArrowBrick {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_ARROW_R), 3));
            MPD_BOX_BAR_L(rightArrowBrick, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y)
        };
    };

};
