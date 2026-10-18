// Acquisition source list (fza_mpd_fnc_acqHandleControl, fza_mpd_fnc_acqDraw), drawn over a page with an ACQ button while
// it is open. A frame runs down the left of R1-R6, with ACQUISITION beside it, and steps across above B4-B6. The sources
// the crew station can select are listed in their places, the selected one boxed; B5 is the crew station's coordinate
// point, the last selected on its COORD page or ?01. ?SKR and ?TRN are not built yet and are barriered.
// The page's text there is hidden (MPD_ACQ_COVERS) and its lines are blanked here.

// The frame line runs against the left of the ACQUISITION letters
#define ACQ_FRAME_X  (MPD_POS_BUTTON_R_X - 5.6 * MPD_TEXT_WIDTH)
#define ACQ_FRAME_T  (MPD_POS_BUTTON_LR_1_Y - 0.9 * MPD_TEXT_HEIGHT)
#define ACQ_FRAME_B  (1 - 0.7 * (1 - (MPD_POS_BUTTON_B_Y - 1.2 * MPD_TEXT_HEIGHT)))
#define ACQ_FRAME_BX (MPD_POS_BUTTON_TB_4_X - 3 * MPD_TEXT_WIDTH)

#define ACQ_OPTION_R(name, posY, floatIndex, label, chars) class name { \
    condition = C_COND(C_MPD_USER(floatIndex)); \
    MPD_TEXT_ACQ(name, MPD_POS_BUTTON_R_X, posY - 0.5 * MPD_TEXT_HEIGHT, "left", label) \
    class Selected { \
        condition = C_COND(C_EQ(C_MPD_USER(floatIndex), 2)); \
        MPD_BOX_L(name, MPD_POS_BUTTON_R_X, posY - 0.5 * MPD_TEXT_HEIGHT, chars) \
    }; \
};

class Obscurants {
    color[] = {0, 0, 0, 1};
    class Right {
        type = "polygon";
        points[] = {{
            {{ACQ_FRAME_X, ACQ_FRAME_T}, 1},
            {{1, ACQ_FRAME_T}, 1},
            {{1, ACQ_FRAME_B}, 1},
            {{ACQ_FRAME_X, ACQ_FRAME_B}, 1}
        }};
    };
    class Bottom {
        type = "polygon";
        points[] = {{
            {{ACQ_FRAME_BX, ACQ_FRAME_B}, 1},
            {{1, ACQ_FRAME_B}, 1},
            {{1, 1}, 1},
            {{ACQ_FRAME_BX, 1}, 1}
        }};
    };
};

class Frame {
    type = "line";
    width = 3;
    points[] = {
        {{1, ACQ_FRAME_T}, 1},
        {{ACQ_FRAME_X, ACQ_FRAME_T}, 1},
        {{ACQ_FRAME_X, ACQ_FRAME_B}, 1},
        {{ACQ_FRAME_BX, ACQ_FRAME_B}, 1},
        {{ACQ_FRAME_BX, 1}, 1}
    };
};

#define ACQ_LETTER(name, index, letter) MPD_TEXT_ACQ(name, ACQ_FRAME_X + 0.6 * MPD_TEXT_WIDTH, 0.5 + (index - 5.5) * 0.85 * MPD_TEXT_HEIGHT, "center", letter)
ACQ_LETTER(Acq_1, 0, "A")
ACQ_LETTER(Acq_2, 1, "C")
ACQ_LETTER(Acq_3, 2, "Q")
ACQ_LETTER(Acq_4, 3, "U")
ACQ_LETTER(Acq_5, 4, "I")
ACQ_LETTER(Acq_6, 5, "S")
ACQ_LETTER(Acq_7, 6, "I")
ACQ_LETTER(Acq_8, 7, "T")
ACQ_LETTER(Acq_9, 8, "I")
ACQ_LETTER(Acq_10, 9, "O")
ACQ_LETTER(Acq_11, 10, "N")

ACQ_OPTION_R(PHS, MPD_POS_BUTTON_LR_1_Y, MFD_IND_ACQ_OPT_PHS, "PHS", 3)
ACQ_OPTION_R(GHS, MPD_POS_BUTTON_LR_2_Y, MFD_IND_ACQ_OPT_GHS, "GHS", 3)
MPD_TEXT_ACQ(SKR, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y - 0.5 * MPD_TEXT_HEIGHT, "left", "?SKR")
MPD_BOX_BAR_L(SKR, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y - 0.5 * MPD_TEXT_HEIGHT)
ACQ_OPTION_R(FCR, MPD_POS_BUTTON_LR_5_Y, MFD_IND_ACQ_OPT_FCR, "FCR", 3)
ACQ_OPTION_R(FXD, MPD_POS_BUTTON_LR_6_Y, MFD_IND_ACQ_OPT_FXD, "FXD", 3)

MPD_TEXT_ACQ(TRN, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y, "center", "?TRN")
MPD_BOX_BAR_B(TRN, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y)
class Coord {
    condition = C_COND(C_MPD_USER(MFD_IND_ACQ_OPT_POINT));
    MPD_TEXT_ACQ_USER(Coord, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, "center", MFD_TEXT_IND_ACQ_POINT)
    class Selected {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ACQ_OPT_POINT), 2));
        MPD_BOX_C(Coord, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 3)
    };
};
class TADS {
    condition = C_COND(C_MPD_USER(MFD_IND_ACQ_OPT_TADS));
    MPD_TEXT_ACQ(TADS, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, "center", "TADS")
    class Selected {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ACQ_OPT_TADS), 2));
        MPD_BOX_C(TADS, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, 4)
    };
};

#undef ACQ_LETTER
#undef ACQ_OPTION_R
#undef ACQ_FRAME_X
#undef ACQ_FRAME_T
#undef ACQ_FRAME_B
#undef ACQ_FRAME_BX
