// VIDEO page labels (fza_mpd_fnc_pageVIDDraw); the video and its symbology are drawn by the page's display. With VSEL
// (decluttered) only the boxed VSEL label, VIEW abbreviated to W, N and Z, and the SHARP arrows are presented. SHARP is
// not available.

#define VID_FULL C_COND(C_EQ(C_MPD_USER(MFD_IND_VID_VSEL), 0))
#define VID_DECL C_COND(C_EQ(C_MPD_USER(MFD_IND_VID_VSEL), 1))
#define VID_IS(index, value) C_COND(C_EQ(C_MPD_USER(index), value))

// A box round a two line label on the right, centred on the button
#define VID_BOX2_L(name, posY, chars) class Vid_Box2_##name { \
    type = "line"; \
    width = 2; \
    points[] = { \
        {{MPD_POS_BUTTON_R_X + MPD_BOX_PAD_X, (posY) - MPD_TEXT_HEIGHT}, 1}, \
        {{MPD_POS_BUTTON_R_X - MPD_BOX_PAD_X - (chars) * MPD_TEXT_WIDTH, (posY) - MPD_TEXT_HEIGHT}, 1}, \
        {{MPD_POS_BUTTON_R_X - MPD_BOX_PAD_X - (chars) * MPD_TEXT_WIDTH, (posY) + MPD_TEXT_HEIGHT}, 1}, \
        {{MPD_POS_BUTTON_R_X + MPD_BOX_PAD_X, (posY) + MPD_TEXT_HEIGHT}, 1}, \
        {{MPD_POS_BUTTON_R_X + MPD_BOX_PAD_X, (posY) - MPD_TEXT_HEIGHT}, 1}}; \
};

// T6 VSEL: the symbology that goes with the underlay, boxed when selected
MPD_TEXT_C(Vsel, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_USER(MFD_TEXT_IND_VID_VSEL))
class VselBox {
    condition = VID_DECL;
    MPD_BOX_C(Vsel, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 5)
};

// L4/L5 SHARP arrows, not available
MPD_BOX_BAR_L(SharpUp, MPD_POS_BUTTON_L_X - 0.6 * MPD_TEXT_HEIGHT, MPD_POS_BUTTON_LR_4_Y - 0.5 * MPD_TEXT_HEIGHT)
MPD_BOX_BAR_L(SharpDown, MPD_POS_BUTTON_L_X - 0.6 * MPD_TEXT_HEIGHT, MPD_POS_BUTTON_LR_5_Y - 0.5 * MPD_TEXT_HEIGHT)
class SharpUp {
    type = "polygon";
    points[] = {{
        {{MPD_POS_BUTTON_L_X + 0.5 * MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_4_Y - 0.02}, 1},
        {{MPD_POS_BUTTON_L_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_4_Y + 0.012}, 1},
        {{MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y + 0.012}, 1}
    }};
};
class SharpDown {
    type = "polygon";
    points[] = {{
        {{MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.012}, 1},
        {{MPD_POS_BUTTON_L_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_5_Y - 0.012}, 1},
        {{MPD_POS_BUTTON_L_X + 0.5 * MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_5_Y + 0.02}, 1}
    }};
};

class Declutter {
    condition = VID_DECL;
    MPD_TEXT_R(ViewW, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT), MPD_TEXT_STATIC("W"))
    MPD_TEXT_R(ViewN, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_2_Y - 0.5 * MPD_TEXT_HEIGHT), MPD_TEXT_STATIC("N"))
    MPD_TEXT_R(ViewZ, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_3_Y - 0.5 * MPD_TEXT_HEIGHT), MPD_TEXT_STATIC("Z"))
    class ViewWide {
        condition = VID_IS(MFD_IND_VID_VIEW, 0);
        MPD_BOX_R(ViewW, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT), 1)
    };
    class ViewNorm {
        condition = VID_IS(MFD_IND_VID_VIEW, 1);
        MPD_BOX_R(ViewN, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_2_Y - 0.5 * MPD_TEXT_HEIGHT), 1)
    };
    class ViewZoom {
        condition = VID_IS(MFD_IND_VID_VIEW, 2);
        MPD_BOX_R(ViewZ, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_3_Y - 0.5 * MPD_TEXT_HEIGHT), 1)
    };
};

class Full {
    condition = VID_FULL;

    // T2 VCR and T3 IMAGE, not available
    MPD_BOX_BAR_T(Vcr, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y)
    MPD_TEXT_C(Vcr, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("VCR"))
    MPD_BOX_BAR_T(Image, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y)
    MPD_TEXT_C(Image, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("IMAGE"))

    // L1-L3 VIEW: framed from the page edge, VIEW down the frame's side in a break in its line
    #define VID_VIEW_X      (MPD_POS_BUTTON_L_X + 4.6 * MPD_TEXT_WIDTH)
    #define VID_VIEW_T      (MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT - 0.015)
    #define VID_VIEW_B      (MPD_POS_BUTTON_LR_3_Y + 0.5 * MPD_TEXT_HEIGHT + 0.015)
    #define VID_VIEW_TEXT_T (MPD_POS_BUTTON_LR_2_Y - 1.775 * MPD_TEXT_HEIGHT)
    class ViewFrameTop {
        type = "line";
        width = 2;
        points[] = {{{0, VID_VIEW_T}, 1}, {{VID_VIEW_X, VID_VIEW_T}, 1}, {{VID_VIEW_X, VID_VIEW_TEXT_T - 0.005}, 1}};
    };
    class ViewFrameBottom {
        type = "line";
        width = 2;
        points[] = {{{VID_VIEW_X, VID_VIEW_TEXT_T + 3.55 * MPD_TEXT_HEIGHT + 0.005}, 1}, {{VID_VIEW_X, VID_VIEW_B}, 1}, {{0, VID_VIEW_B}, 1}};
    };
    MPD_MASK_V_R(View, VID_VIEW_X, VID_VIEW_TEXT_T + 0 * MPD_TEXT_HEIGHT, VID_VIEW_TEXT_T + 2.55 * MPD_TEXT_HEIGHT)
    MPD_TEXT_R(ViewLetter0, VID_VIEW_X, VID_VIEW_TEXT_T + 0 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("V"))
    MPD_TEXT_R(ViewLetter1, VID_VIEW_X, VID_VIEW_TEXT_T + 0.85 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("I"))
    MPD_TEXT_R(ViewLetter2, VID_VIEW_X, VID_VIEW_TEXT_T + 1.7 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
    MPD_TEXT_R(ViewLetter3, VID_VIEW_X, VID_VIEW_TEXT_T + 2.55 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("W"))
    MPD_TEXT_R(ViewWide, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT), MPD_TEXT_STATIC("WIDE"))
    MPD_TEXT_R(ViewNorm, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_2_Y - 0.5 * MPD_TEXT_HEIGHT), MPD_TEXT_STATIC("NORM"))
    MPD_TEXT_R(ViewZoom, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_3_Y - 0.5 * MPD_TEXT_HEIGHT), MPD_TEXT_STATIC("ZOOM"))
    class ViewWide {
        condition = VID_IS(MFD_IND_VID_VIEW, 0);
        MPD_BOX_R(ViewWide, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT), 4)
    };
    class ViewNorm {
        condition = VID_IS(MFD_IND_VID_VIEW, 1);
        MPD_BOX_R(ViewNorm, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_2_Y - 0.5 * MPD_TEXT_HEIGHT), 4)
    };
    class ViewZoom {
        condition = VID_IS(MFD_IND_VID_VIEW, 2);
        MPD_BOX_R(ViewZoom, MPD_POS_BUTTON_L_X, (MPD_POS_BUTTON_LR_3_Y - 0.5 * MPD_TEXT_HEIGHT), 4)
    };

    // L4/L5 SHARP
    MPD_TEXT_R(Sharp, MPD_POS_BUTTON_L_X, 0.5 * (MPD_POS_BUTTON_LR_4_Y + MPD_POS_BUTTON_LR_5_Y) - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SHARP"))

    // L6 COLOR
    MPD_TEXT_R(Color, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("COLOR"))
    class ColorWhite {
        condition = VID_IS(MFD_IND_VID_COLOR, 0);
        MPD_TEXT_R(ColorWhite, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("WHITE"))
        MPD_BOX_R(ColorWhite, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 5)
    };
    class ColorGreen {
        condition = VID_IS(MFD_IND_VID_COLOR, 1);
        MPD_TEXT_R(ColorGreen, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("GREEN"))
        MPD_BOX_R(ColorGreen, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 5)
    };

    // R1-R6 UNDERLAY, the selected boxed
    // R1-R6 UNDERLAY: framed from the page edge, UNDERLAY down the frame's side in a break in its line
    #define VID_UND_X      (MPD_POS_BUTTON_R_X - 5.6 * MPD_TEXT_WIDTH)
    #define VID_UND_T      (MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT - 0.015)
    #define VID_UND_B      (MPD_POS_BUTTON_LR_6_Y + MPD_TEXT_HEIGHT + 0.015)
    #define VID_UND_TEXT_T (0.5 * (VID_UND_T + VID_UND_B) - 3.475 * MPD_TEXT_HEIGHT)
    class UnderlayFrameTop {
        type = "line";
        width = 2;
        points[] = {{{1, VID_UND_T}, 1}, {{VID_UND_X, VID_UND_T}, 1}, {{VID_UND_X, VID_UND_TEXT_T - 0.005}, 1}};
    };
    class UnderlayFrameBottom {
        type = "line";
        width = 2;
        points[] = {{{VID_UND_X, VID_UND_TEXT_T + 6.95 * MPD_TEXT_HEIGHT + 0.005}, 1}, {{VID_UND_X, VID_UND_B}, 1}, {{1, VID_UND_B}, 1}};
    };
    MPD_MASK_V_L(Underlay, VID_UND_X, VID_UND_TEXT_T + 0 * MPD_TEXT_HEIGHT, VID_UND_TEXT_T + 5.95 * MPD_TEXT_HEIGHT)
    MPD_TEXT_L(UnderlayLetter0, VID_UND_X, VID_UND_TEXT_T + 0 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("U"))
    MPD_TEXT_L(UnderlayLetter1, VID_UND_X, VID_UND_TEXT_T + 0.85 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("N"))
    MPD_TEXT_L(UnderlayLetter2, VID_UND_X, VID_UND_TEXT_T + 1.7 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("D"))
    MPD_TEXT_L(UnderlayLetter3, VID_UND_X, VID_UND_TEXT_T + 2.55 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
    MPD_TEXT_L(UnderlayLetter4, VID_UND_X, VID_UND_TEXT_T + 3.4 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("R"))
    MPD_TEXT_L(UnderlayLetter5, VID_UND_X, VID_UND_TEXT_T + 4.25 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
    MPD_TEXT_L(UnderlayLetter6, VID_UND_X, VID_UND_TEXT_T + 5.1 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
    MPD_TEXT_L(UnderlayLetter7, VID_UND_X, VID_UND_TEXT_T + 5.95 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Y"))
    MPD_TEXT_L(SrcTads, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TADS"))
    MPD_TEXT_L(SrcCpgSightA, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CPG"))
    MPD_TEXT_L(SrcCpgSightB, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("SIGHT"))
    MPD_TEXT_L(SrcCpgHmdA, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CPG"))
    MPD_TEXT_L(SrcCpgHmdB, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("HMD"))
    MPD_TEXT_L(SrcPltSightA, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PLT"))
    MPD_TEXT_L(SrcPltSightB, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("SIGHT"))
    MPD_TEXT_L(SrcPltHmdA, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PLT"))
    MPD_TEXT_L(SrcPltHmdB, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("HMD"))
    MPD_TEXT_L(SrcNoneA, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("NO"))
    MPD_TEXT_L(SrcNoneB, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("VIDEO"))
    class SelTads {
        condition = VID_IS(MFD_IND_VID_UNDERLAY, 0);
        MPD_BOX_L(SrcTads, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT, 4)
    };
    class SelCpgSight {
        condition = VID_IS(MFD_IND_VID_UNDERLAY, 1);
        VID_BOX2_L(CpgSight, MPD_POS_BUTTON_LR_2_Y, 5)
    };
    class SelCpgHmd {
        condition = VID_IS(MFD_IND_VID_UNDERLAY, 2);
        VID_BOX2_L(CpgHmd, MPD_POS_BUTTON_LR_3_Y, 3)
    };
    class SelPltSight {
        condition = VID_IS(MFD_IND_VID_UNDERLAY, 3);
        VID_BOX2_L(PltSight, MPD_POS_BUTTON_LR_4_Y, 5)
    };
    class SelPltHmd {
        condition = VID_IS(MFD_IND_VID_UNDERLAY, 4);
        VID_BOX2_L(PltHmd, MPD_POS_BUTTON_LR_5_Y, 3)
    };
    class SelNone {
        condition = VID_IS(MFD_IND_VID_UNDERLAY, 5);
        VID_BOX2_L(None, MPD_POS_BUTTON_LR_6_Y, 5)
    };

    // B1 VIDEO, this page; B2 SYMB, B3 RESET, B6 G/S
    MPD_TEXT_C(Video, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("VIDEO"))
    MPD_BOX_C(Video, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, 5)
    MPD_TEXT_C(Symb, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SYMB"))
    class SymbNorm {
        condition = VID_IS(MFD_IND_VID_SYMB, 0);
        MPD_TEXT_C(SymbNorm, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("NORM"))
    };
    class SymbBoost {
        condition = VID_IS(MFD_IND_VID_SYMB, 1);
        MPD_TEXT_C(SymbBoost, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("BOOST"))
    };
    MPD_TEXT_C(Reset, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("RESET"))
    MPD_TEXT_C(GreyScale, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("G/S"))
    class GreyScaleOn {
        condition = VID_IS(MFD_IND_VID_GS, 1);
        MPD_BOX_C(GreyScale, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, 3)
    };
};
