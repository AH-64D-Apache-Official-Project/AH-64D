// US autopage group, half a character in from the buttons' labels: the labels and boxes, the bracket and its text
#define ASE_AP_X      (MPD_POS_BUTTON_L_X - 0.5*MPD_TEXT_WIDTH)
#define ASE_AP_LINE_X (0.080 - 0.5*MPD_TEXT_WIDTH)
#define ASE_AP_TEXT_X (0.08 - 0.5*MPD_TEXT_WIDTH)
class ase_draw {
    class lines {
        type = "line";
        width = 3;
        points[] = {
            //ASE footprint circle
            {{0.175, 0.500}, 1},
            {{0.178, 0.458}, 1},
            {{0.186, 0.416}, 1},
            {{0.200, 0.376}, 1},
            {{0.219, 0.338}, 1},
            {{0.242, 0.302}, 1},
            {{0.270, 0.270}, 1},
            {{0.302, 0.242}, 1},
            {{0.338, 0.219}, 1},
            {{0.376, 0.200}, 1},
            {{0.416, 0.186}, 1},
            {{0.458, 0.178}, 1},
            {{0.500, 0.175}, 1},
            {{0.542, 0.178}, 1},
            {{0.584, 0.186}, 1},
            {{0.624, 0.200}, 1},
            {{0.663, 0.219}, 1},
            {{0.698, 0.242}, 1},
            {{0.730, 0.270}, 1},
            {{0.758, 0.302}, 1},
            {{0.781, 0.338}, 1},
            {{0.800, 0.376}, 1},
            {{0.814, 0.416}, 1},
            {{0.822, 0.458}, 1},
            {{0.825, 0.500}, 1},
            {{0.822, 0.542}, 1},
            {{0.814, 0.584}, 1},
            {{0.800, 0.624}, 1},
            {{0.781, 0.663}, 1},
            {{0.758, 0.698}, 1},
            {{0.730, 0.730}, 1},
            {{0.698, 0.758}, 1},
            {{0.663, 0.781}, 1},
            {{0.624, 0.800}, 1},
            {{0.584, 0.814}, 1},
            {{0.542, 0.822}, 1},
            {{0.500, 0.825}, 1},
            {{0.458, 0.822}, 1},
            {{0.416, 0.814}, 1},
            {{0.376, 0.800}, 1},
            {{0.338, 0.781}, 1},
            {{0.302, 0.758}, 1},
            {{0.270, 0.730}, 1},
            {{0.242, 0.698}, 1},
            {{0.219, 0.663}, 1},
            {{0.200, 0.624}, 1},
            {{0.186, 0.584}, 1},
            {{0.178, 0.542}, 1}, 
            {{0.175, 0.500}, 1}, {},
            //Heading box top
            MPD_POINTS_BOX("Null", 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_T_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {},
            //Heading box bottom
            MPD_POINTS_BOX("Null", 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_B_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {},
        };
    };

    //US only: autopage bracket, CMS count box
    class lines_US {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AMERICAN), 1));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                //Autopage top, clear of the RFI count above it
                {{0.002, 0.385}, 1},
                {{ASE_AP_LINE_X, 0.385}, 1}, {},
                //Autopage right, broken round the AUTOPAGE text down it
                {{ASE_AP_LINE_X, 0.385}, 1},
                {{ASE_AP_LINE_X, 0.600-3.5*MPD_TEXT_HEIGHT-0.005}, 1}, {},
                {{ASE_AP_LINE_X, 0.600+4.5*MPD_TEXT_HEIGHT+0.005}, 1}, 
                {{ASE_AP_LINE_X, 0.870}, 1}, {},
                //Autopage bottom
                {{ASE_AP_LINE_X, 0.870}, 1}, 
                {{0.002, 0.870}, 1}, {},
                //Chaff box
                MPD_POINTS_BOX("Null", MPD_POS_BUTTON_TB_1_X-(2.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_B_Y-(3*MPD_TEXT_HEIGHT), 5*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT*2), {},
            };
        };
    };

    #define IRJamX MPD_POS_BUTTON_R_X - 0.1*MPD_TEXT_WIDTH
    #define IRJamY MPD_POS_BUTTON_LR_1_Y - 0.05*MPD_TEXT_HEIGHT
    class lines_msnEquipOnOff {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AMERICAN), 1));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                //Power Indicator
                {{IRJamX - 0.010, IRJamY + 0.000}, 1},
                {{IRJamX - 0.007, IRJamY - 0.007}, 1},
                {{IRJamX - 0.000, IRJamY - 0.010}, 1},
                {{IRJamX + 0.007, IRJamY - 0.007}, 1},
                {{IRJamX + 0.010, IRJamY + 0.000}, 1},
                {{IRJamX + 0.007, IRJamY + 0.007}, 1},
                {{IRJamX + 0.000, IRJamY + 0.010}, 1},
                {{IRJamX - 0.007, IRJamY + 0.007}, 1}, 
                {{IRJamX - 0.010, IRJamY + 0.000}, 1},
            };
        };
    };
    //HIDAS (UK mission equipment)
    #define ASE_RING_PT(r, a) {{__EVAL(0.5 + (r) * sin (a)), __EVAL(0.5 - (r) * cos (a))}, 1}
    #define ASE_CM_Y1 (MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT)
    #define ASE_CM_Y2 MPD_POS_BUTTON_B_Y
    #define ASE_CM_XL (MPD_POS_BUTTON_L_X + 1.5*MPD_TEXT_WIDTH)
    #define ASE_CM_XR (MPD_POS_BUTTON_R_X - 1.5*MPD_TEXT_WIDTH)
    class showHIDAS {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_BRITISH), 1));

        //Threat rings
        class lines_rings {
            type = "line";
            width = 2;
            points[] = {
                ASE_RING_PT(MPD_ASE_RING_3, 0), ASE_RING_PT(MPD_ASE_RING_3, 15), ASE_RING_PT(MPD_ASE_RING_3, 30), ASE_RING_PT(MPD_ASE_RING_3, 45), ASE_RING_PT(MPD_ASE_RING_3, 60), ASE_RING_PT(MPD_ASE_RING_3, 75), ASE_RING_PT(MPD_ASE_RING_3, 90), ASE_RING_PT(MPD_ASE_RING_3, 105), ASE_RING_PT(MPD_ASE_RING_3, 120), ASE_RING_PT(MPD_ASE_RING_3, 135), ASE_RING_PT(MPD_ASE_RING_3, 150), ASE_RING_PT(MPD_ASE_RING_3, 165), ASE_RING_PT(MPD_ASE_RING_3, 180), ASE_RING_PT(MPD_ASE_RING_3, 195), ASE_RING_PT(MPD_ASE_RING_3, 210), ASE_RING_PT(MPD_ASE_RING_3, 225), ASE_RING_PT(MPD_ASE_RING_3, 240), ASE_RING_PT(MPD_ASE_RING_3, 255), ASE_RING_PT(MPD_ASE_RING_3, 270), ASE_RING_PT(MPD_ASE_RING_3, 285), ASE_RING_PT(MPD_ASE_RING_3, 300), ASE_RING_PT(MPD_ASE_RING_3, 315), ASE_RING_PT(MPD_ASE_RING_3, 330), ASE_RING_PT(MPD_ASE_RING_3, 345), ASE_RING_PT(MPD_ASE_RING_3, 360), {},
                ASE_RING_PT(MPD_ASE_RING_2, 0), ASE_RING_PT(MPD_ASE_RING_2, 15), ASE_RING_PT(MPD_ASE_RING_2, 30), ASE_RING_PT(MPD_ASE_RING_2, 45), ASE_RING_PT(MPD_ASE_RING_2, 60), ASE_RING_PT(MPD_ASE_RING_2, 75), ASE_RING_PT(MPD_ASE_RING_2, 90), ASE_RING_PT(MPD_ASE_RING_2, 105), ASE_RING_PT(MPD_ASE_RING_2, 120), ASE_RING_PT(MPD_ASE_RING_2, 135), ASE_RING_PT(MPD_ASE_RING_2, 150), ASE_RING_PT(MPD_ASE_RING_2, 165), ASE_RING_PT(MPD_ASE_RING_2, 180), ASE_RING_PT(MPD_ASE_RING_2, 195), ASE_RING_PT(MPD_ASE_RING_2, 210), ASE_RING_PT(MPD_ASE_RING_2, 225), ASE_RING_PT(MPD_ASE_RING_2, 240), ASE_RING_PT(MPD_ASE_RING_2, 255), ASE_RING_PT(MPD_ASE_RING_2, 270), ASE_RING_PT(MPD_ASE_RING_2, 285), ASE_RING_PT(MPD_ASE_RING_2, 300), ASE_RING_PT(MPD_ASE_RING_2, 315), ASE_RING_PT(MPD_ASE_RING_2, 330), ASE_RING_PT(MPD_ASE_RING_2, 345), ASE_RING_PT(MPD_ASE_RING_2, 360), {},
                ASE_RING_PT(MPD_ASE_RING_1, 0), ASE_RING_PT(MPD_ASE_RING_1, 15), ASE_RING_PT(MPD_ASE_RING_1, 30), ASE_RING_PT(MPD_ASE_RING_1, 45), ASE_RING_PT(MPD_ASE_RING_1, 60), ASE_RING_PT(MPD_ASE_RING_1, 75), ASE_RING_PT(MPD_ASE_RING_1, 90), ASE_RING_PT(MPD_ASE_RING_1, 105), ASE_RING_PT(MPD_ASE_RING_1, 120), ASE_RING_PT(MPD_ASE_RING_1, 135), ASE_RING_PT(MPD_ASE_RING_1, 150), ASE_RING_PT(MPD_ASE_RING_1, 165), ASE_RING_PT(MPD_ASE_RING_1, 180), ASE_RING_PT(MPD_ASE_RING_1, 195), ASE_RING_PT(MPD_ASE_RING_1, 210), ASE_RING_PT(MPD_ASE_RING_1, 225), ASE_RING_PT(MPD_ASE_RING_1, 240), ASE_RING_PT(MPD_ASE_RING_1, 255), ASE_RING_PT(MPD_ASE_RING_1, 270), ASE_RING_PT(MPD_ASE_RING_1, 285), ASE_RING_PT(MPD_ASE_RING_1, 300), ASE_RING_PT(MPD_ASE_RING_1, 315), ASE_RING_PT(MPD_ASE_RING_1, 330), ASE_RING_PT(MPD_ASE_RING_1, 345), ASE_RING_PT(MPD_ASE_RING_1, 360)
            };
        };

        //Countermeasure boxes: flares and chaff on the left, flares on the right, the totals above the right
        class lines_cms {
            type = "line";
            width = 3;
            points[] = {
                MPD_POINTS_BOX("Null", ASE_CM_XL, ASE_CM_Y1, 8*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT), {},
                //FL total underline
                {{ASE_CM_XR - 4*MPD_TEXT_WIDTH, ASE_CM_Y1 - 1.4*MPD_TEXT_HEIGHT + 0.003}, 1},
                {{ASE_CM_XR, ASE_CM_Y1 - 1.4*MPD_TEXT_HEIGHT + 0.003}, 1}
            };
        };
        class lines_cmsRight {
            condition = C_COND(C_LESS(C_MPD_USER(MFD_IND_ASE_FLARE_R_QTY), 2));
            class lines {
                type = "line";
                width = 3;
                points[] = {
                    MPD_POINTS_BOX("Null", ASE_CM_XR - 8*MPD_TEXT_WIDTH, ASE_CM_Y1, 8*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT)
                };
            };
        };
        class FLARE_L_qty0 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_FLARE_L_QTY), 0));
            MPD_TEXT_R(FLARE_L, ASE_CM_XL, ASE_CM_Y1, MPD_TEXT_USER(MFD_TEXT_IND_ASE_FLARE_L))
        };
        class FLARE_L_qty1 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_FLARE_L_QTY), 1));
            color[] = {1,1,0,1};
            MPD_TEXT_R(FLARE_L, ASE_CM_XL, ASE_CM_Y1, MPD_TEXT_USER(MFD_TEXT_IND_ASE_FLARE_L))
        };
        class FLARE_L_qty2 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_FLARE_L_QTY), 2));
            color[] = {1,0,0,1};
            MPD_TEXT_R(FLARE_L, ASE_CM_XL, ASE_CM_Y1, MPD_TEXT_USER(MFD_TEXT_IND_ASE_FLARE_L))
            MPD_BOX_R(FLARE_L, ASE_CM_XL, ASE_CM_Y1, 8)
        };
        class CHAFF_qty0 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_CHAFF_QTY), 0));
            MPD_TEXT_R(CHAFF, ASE_CM_XL, ASE_CM_Y2, MPD_TEXT_USER(MFD_TEXT_IND_ASE_CHAFF))
        };
        class CHAFF_qty1 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_CHAFF_QTY), 1));
            color[] = {1,1,0,1};
            MPD_TEXT_R(CHAFF, ASE_CM_XL, ASE_CM_Y2, MPD_TEXT_USER(MFD_TEXT_IND_ASE_CHAFF))
        };
        class CHAFF_qty2 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_CHAFF_QTY), 2));
            color[] = {1,0,0,1};
            MPD_TEXT_R(CHAFF, ASE_CM_XL, ASE_CM_Y2, MPD_TEXT_USER(MFD_TEXT_IND_ASE_CHAFF))
            MPD_BOX_R(CHAFF, ASE_CM_XL, ASE_CM_Y2, 8)
        };
        class FLARE_R_qty0 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_FLARE_R_QTY), 0));
            MPD_TEXT_L(FLARE_R, ASE_CM_XR, ASE_CM_Y1, MPD_TEXT_USER(MFD_TEXT_IND_ASE_FLARE_R))
        };
        class FLARE_R_qty1 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_FLARE_R_QTY), 1));
            color[] = {1,1,0,1};
            MPD_TEXT_L(FLARE_R, ASE_CM_XR, ASE_CM_Y1, MPD_TEXT_USER(MFD_TEXT_IND_ASE_FLARE_R))
        };
        class FLARE_R_qty2 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_FLARE_R_QTY), 2));
            color[] = {1,0,0,1};
            MPD_TEXT_L(FLARE_R, ASE_CM_XR, ASE_CM_Y1, MPD_TEXT_USER(MFD_TEXT_IND_ASE_FLARE_R))
            MPD_BOX_L(FLARE_R, ASE_CM_XR, ASE_CM_Y1, 8)
        };
        MPD_TEXT_L(FL_TOTAL, ASE_CM_XR, ASE_CM_Y1 - 2.4*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_ASE_FL_TOTAL))
        MPD_TEXT_L(CH_TOTAL, ASE_CM_XR, ASE_CM_Y1 - 1.3*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_ASE_CH_TOTAL))

        //ASE threat count
        //Left aligned with UTIL above it
        #define ASE_COUNT_X (MPD_POS_BUTTON_TB_6_X - 2*MPD_TEXT_WIDTH)
        #define ASE_COUNT_Y (MPD_POS_BUTTON_LR_1_Y - 1.9*MPD_TEXT_HEIGHT)
        MPD_TEXT_R(ASE_COUNT, ASE_COUNT_X, ASE_COUNT_Y, MPD_TEXT_USER(MFD_TEXT_IND_ASE_COUNT))
        class aseCount {
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_ASE_COUNT_WIDE)));
            class lines {
                type = "line";
                width = 3;
                points[] = {
                    MPD_POINTS_BOX("Null", ASE_COUNT_X, ASE_COUNT_Y, 5*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT)
                };
            };
        };
        class aseCountWide {
            condition = C_COND(C_MPD_USER(MFD_IND_ASE_COUNT_WIDE));
            class lines {
                type = "line";
                width = 3;
                points[] = {
                    MPD_POINTS_BOX("Null", ASE_COUNT_X, ASE_COUNT_Y, 6*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT)
                };
            };
        };

        //R5
        MPD_BOX_BAR_L(RVW, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y)
        MPD_TEXT_L(RVW, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("RVW"))

        //L1 CMDS mode
        MPD_TEXT_R(CMDS_MODE, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CMDS MODE"))
        class cmdsMan {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_CMDS_MODE), ASE_CMDS_MAN));
            MPD_BOX_R(cmdsMan, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 3)
            MPD_TEXT_R(cmdsMan, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MAN"))
        };
        class cmdsSemi {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_CMDS_MODE), ASE_CMDS_SEMI));
            MPD_BOX_R(cmdsSemi, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 4)
            MPD_TEXT_R(cmdsSemi, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SEMI"))
        };
        class cmdsAuto {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_CMDS_MODE), ASE_CMDS_AUTO));
            MPD_BOX_R(cmdsAuto, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 4)
            MPD_TEXT_R(cmdsAuto, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("AUTO"))
        };

        //R1 Autopage
        MPD_TEXT_L(AUTOPAGE_UK, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("AUTOPAGE"))
        class autopageSrch {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_SRH));
            MPD_BOX_L(autopageSrch, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 4)
            MPD_TEXT_L(autopageSrch, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SRCH"))
        };
        class autopageAcq {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_ACQ));
            MPD_BOX_L(autopageAcq, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 3)
            MPD_TEXT_L(autopageAcq, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ACQ"))
        };
        class autopageTrck {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_TRK));
            MPD_BOX_L(autopageTrck, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 4)
            MPD_TEXT_L(autopageTrck, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TRCK"))
        };
        class autopageOff {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_OFF));
            MPD_BOX_L(autopageOff, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 3)
            MPD_TEXT_L(autopageOff, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("OFF"))
        };

        //R2 Voice: the RLWR announces at this level and above
        MPD_TEXT_L(VOICE, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("VOICE"))
        class voiceSrch {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_VOICE), ASE_AUTOPAGE_SRH));
            MPD_BOX_L(voiceSrch, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 4)
            MPD_TEXT_L(voiceSrch, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SRCH"))
        };
        class voiceAcq {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_VOICE), ASE_AUTOPAGE_ACQ));
            MPD_BOX_L(voiceAcq, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 3)
            MPD_TEXT_L(voiceAcq, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ACQ"))
        };
        class voiceTrck {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_VOICE), ASE_AUTOPAGE_TRK));
            MPD_BOX_L(voiceTrck, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 4)
            MPD_TEXT_L(voiceTrck, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TRCK"))
        };
        class voiceOff {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_VOICE), ASE_AUTOPAGE_OFF));
            MPD_BOX_L(voiceOff, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, 3)
            MPD_TEXT_L(voiceOff, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("OFF"))
        };
    };
    class ShowIRJam {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AMERICAN), 1));
        MPD_TEXT_C(CHAFF_COUNT_1,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y - 3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CHAFF"))
        MPD_TEXT_L(IRJAM_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("IRJAM  "))
        MPD_TEXT_C(CHAFF_1,   MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("CHAFF"))
        class IRJam_ON {
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_ASE_IRJAM_PWR)));
            class IRJamDraw {
                class polys_IRJamOnOff {
                    class Polygons {
                        type = "polygon";
                        points[] = {
                            { //Top left
                                {{IRJamX - 0.010, IRJamY + 0.000}, 1},
                                {{IRJamX - 0.007, IRJamY - 0.007}, 1},
                                {{IRJamX - 0.000, IRJamY - 0.010}, 1},
                                {{IRJamX, IRJamY}, 1}
                            },
                            { //Top right
                                {{IRJamX - 0.000, IRJamY - 0.010}, 1},
                                {{IRJamX + 0.007, IRJamY - 0.007}, 1},
                                {{IRJamX + 0.010, IRJamY + 0.000}, 1},
                                {{IRJamX, IRJamY}, 1}
                            },
                            { //Bottom right
                                {{IRJamX + 0.010, IRJamY + 0.000}, 1},
                                {{IRJamX + 0.007, IRJamY + 0.007}, 1}, 
                                {{IRJamX + 0.000, IRJamY + 0.010}, 1},
                                {{IRJamX, IRJamY}, 1}
                            },
                            { //Bottom left
                                {{IRJamX + 0.000, IRJamY + 0.010}, 1},
                                {{IRJamX - 0.007, IRJamY + 0.007}, 1}, 
                                {{IRJamX - 0.010, IRJamY + 0.000}, 1},
                                {{IRJamX, IRJamY}, 1}
                            }
                        };
                    };
                    class lines_IRJam {
                        type = "line";
                        width = 3;
                        points[] = {
                            MPD_POINTS_BOX("Null", MPD_POS_BUTTON_R_X-(4*MPD_TEXT_WIDTH), MPD_POS_BUTTON_LR_1_Y + 0.6*MPD_TEXT_HEIGHT, 4*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.015),
                        };
                    };
                    class text_IRJamWarm {
                        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_IRJAM_STATE), ASE_IRJAM_STATE_WARM));
                        //R1
                        MPD_TEXT_L(IRJAM_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("WARM"))
                    };
                    class text_IRJamOper {
                        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_IRJAM_STATE), ASE_IRJAM_STATE_OPER));
                        //R1
                        MPD_TEXT_L(IRJAM_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("OPER"))
                    };
                };
            };
        };
    };

    //Radar Jammer, B4-B6: the selected mode boxed, or in inverse video while warming up
    #define RJamL 0.548
    #define RJamR 0.887
    #define RJamY (MPD_POS_BUTTON_B_Y - 0.02)
    #define RJamX (0.5*(RJamL + RJamR))
    class ShowRJam {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AMERICAN), 1));
        //Bracket over B4-B6, broken round the RJAM label
        class lines_RJam {
            type = "line";
            width = 2;
            points[] = {
                {{RJamL, MPD_POS_BUTTON_B_Y + 0.04}, 1},
                {{RJamL, RJamY}, 1},
                {{RJamX - 2*MPD_TEXT_WIDTH - 0.005, RJamY}, 1}, {},
                {{RJamX + 2*MPD_TEXT_WIDTH + 0.005, RJamY}, 1},
                {{RJamR, RJamY}, 1},
                {{RJamR, MPD_POS_BUTTON_B_Y + 0.04}, 1}
            };
        };
        MPD_TEXT_BONE_C(RJAM, "Null", RJamX, RJamY - 0.035, MPD_TEXT_STATIC("RJAM"))
        MPD_TEXT_C(RJAM_OFF, MPD_POS_BUTTON_TB_4_X+0.025, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("OFF"))
        class RJam_Stby {
            condition = C_COND(C_NOT(C_EQ(C_MPD_USER(MFD_IND_ASE_RJAM_STATE), ASE_RJAM_STATE_WARM_STBY)));
            MPD_TEXT_C(RJAM_STBY, MPD_POS_BUTTON_TB_5_X+0.0125, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("STBY"))
        };
        class RJam_Oper {
            condition = C_COND(C_NOT(C_EQ(C_MPD_USER(MFD_IND_ASE_RJAM_STATE), ASE_RJAM_STATE_WARM_OPER)));
            MPD_TEXT_C(RJAM_OPER, MPD_POS_BUTTON_TB_6_X+0.0125, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("OPER"))
        };
        class RJam_OffBox {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_RJAM_STATE), ASE_RJAM_STATE_OFF));
            MPD_BOX_C(RJAM_OFF, MPD_POS_BUTTON_TB_4_X+0.025, MPD_POS_BUTTON_B_Y, 3)
        };
        class RJam_StbyBox {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_RJAM_STATE), ASE_RJAM_STATE_STBY));
            MPD_BOX_C(RJAM_STBY, MPD_POS_BUTTON_TB_5_X+0.0125, MPD_POS_BUTTON_B_Y, 4)
        };
        class RJam_OperBox {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_RJAM_STATE), ASE_RJAM_STATE_OPER));
            MPD_BOX_C(RJAM_OPER, MPD_POS_BUTTON_TB_6_X+0.0125, MPD_POS_BUTTON_B_Y, 4)
        };
        class RJam_WarmStby {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_RJAM_STATE), ASE_RJAM_STATE_WARM_STBY));
            MPD_BOX_INV_C(RJAM_STBY_INV, MPD_POS_BUTTON_TB_5_X+0.0125, MPD_POS_BUTTON_B_Y, 4)
            color[] = {0,0,0,1};
            class text_color {
                MPD_TEXT_C(RJAM_STBY_INV, MPD_POS_BUTTON_TB_5_X+0.0125, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("STBY"))
            };
        };
        class RJam_WarmOper {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_RJAM_STATE), ASE_RJAM_STATE_WARM_OPER));
            MPD_BOX_INV_C(RJAM_OPER_INV, MPD_POS_BUTTON_TB_6_X+0.0125, MPD_POS_BUTTON_B_Y, 4)
            color[] = {0,0,0,1};
            class text_color {
                MPD_TEXT_C(RJAM_OPER_INV, MPD_POS_BUTTON_TB_6_X+0.0125, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("OPER"))
            };
        };
    };

    #define RLWRX MPD_POS_BUTTON_R_X - 0.1*MPD_TEXT_WIDTH
    #define RLWRY MPD_POS_BUTTON_LR_6_Y - 0.05*MPD_TEXT_HEIGHT
    
    
    //US only: RLWR power and count at R6
    class RLWR_US {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AMERICAN), 1));
        class RLWR_Off {
            class lines_RLWROnOff {
                type = "line";
                width = 3;
                points[] = {
                    //Power Indicator
                    {{RLWRX - 0.010, RLWRY + 0.000}, 1},
                    {{RLWRX - 0.007, RLWRY - 0.007}, 1},
                    {{RLWRX - 0.000, RLWRY - 0.010}, 1},
                    {{RLWRX + 0.007, RLWRY - 0.007}, 1},
                    {{RLWRX + 0.010, RLWRY + 0.000}, 1},
                    {{RLWRX + 0.007, RLWRY + 0.007}, 1},
                    {{RLWRX + 0.000, RLWRY + 0.010}, 1},
                    {{RLWRX - 0.007, RLWRY + 0.007}, 1}, 
                    {{RLWRX - 0.010, RLWRY + 0.000}, 1},
                };
            };
        };
        class RLWR_On {
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_ASE_RLWR_PWR)));
            class RLWR_draw {
                class polys_RLWROnOff {
                    class Polygons {
                        type = "polygon";
                        points[] = {
                            { //Top left
                                {{RLWRX - 0.010, RLWRY + 0.000}, 1},
                                {{RLWRX - 0.007, RLWRY - 0.007}, 1},
                                {{RLWRX - 0.000, RLWRY - 0.010}, 1},
                                {{RLWRX, RLWRY}, 1}
                            },
                            { //Top right
                                {{RLWRX - 0.000, RLWRY - 0.010}, 1},
                                {{RLWRX + 0.007, RLWRY - 0.007}, 1},
                                {{RLWRX + 0.010, RLWRY + 0.000}, 1},
                                {{RLWRX, RLWRY}, 1}
                            },
                            { //Bottom right
                                {{RLWRX + 0.010, RLWRY + 0.000}, 1},
                                {{RLWRX + 0.007, RLWRY + 0.007}, 1}, 
                                {{RLWRX + 0.000, RLWRY + 0.010}, 1},
                                {{RLWRX, RLWRY}, 1}
                            },
                            { //Bottom left
                                {{RLWRX + 0.000, RLWRY + 0.010}, 1},
                                {{RLWRX - 0.007, RLWRY + 0.007}, 1}, 
                                {{RLWRX - 0.010, RLWRY + 0.000}, 1},
                                {{RLWRX, RLWRY}, 1}
                            }
                        };
                    };
                };
                class lines_RLWR {
                    type = "line";
                    width = 3;
                    points[] = {
                        //RLWR box
                        MPD_POINTS_BOX("Null", MPD_POS_BUTTON_R_X-(2*MPD_TEXT_WIDTH), MPD_POS_BUTTON_LR_6_Y + 0.6*MPD_TEXT_HEIGHT, 2*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.015),
                    };
                };
                MPD_TEXT_L(RLWR_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_ASE_RLWR_COUNT))
            };
        };
    };

    //Ownship Icon
    class lines_ownshipIcon {
        color[] = {0,1,1,1};
        class Lines {
            type = "line";
            width = 3;
            points[] = {
                //Ownship rotor
                {"ase_ownship", { 0.020,  0.000}, 1},
                {"ase_ownship", { 0.014, -0.014}, 1},
                {"ase_ownship", { 0.000, -0.020}, 1},
                {"ase_ownship", {-0.014, -0.014}, 1},
                {"ase_ownship", {-0.020,  0.000}, 1},
                {"ase_ownship", {-0.014,  0.014}, 1},
                {"ase_ownship", { 0.000,  0.020}, 1},
                {"ase_ownship", { 0.014,  0.014}, 1},
                {"ase_ownship", { 0.020,  0.000}, 1},
                {},
                //Tail boom line
                {"ase_ownship", { 0.000, 0.020}, 1},
                {"ase_ownship", { 0.000, 0.040}, 1},
                {},
                //Tail rotor axle line
                {"ase_ownship", { 0.000, 0.040}, 1},
                {"ase_ownship", {-0.0125, 0.040}, 1},
                {},
                //Tail rotor line
                {"ase_ownship", {-0.0125, 0.030}, 1},
                {"ase_ownship", {-0.0125, 0.05}, 1},
                {},
                //Ownship center dot
                {"ase_ownship", { 0.000,  0.0025}, 1},
                {"ase_ownship", { 0.000, -0.0025}, 1},
            };
        };
    };

    //Radar jammer transmitting: a filled bolt, in convex pieces
    class polys_rJamBolt {
        condition = C_COND(C_MPD_USER(MFD_IND_ASE_RJAM_XMIT));
        color[] = {0,1,1,1};
        class Polygons {
            type = "polygon";
            points[] = {
                { //Upper bar
                    {"ase_ownship", {-0.0055, -0.0105}, 1},
                    {"ase_ownship", { 0.0075, -0.0105}, 1},
                    {"ase_ownship", { 0.0025, -0.0015}, 1},
                    {"ase_ownship", {-0.0075, -0.0015}, 1}
                },
                { //Step
                    {"ase_ownship", {-0.0075, -0.0015}, 1},
                    {"ase_ownship", { 0.0070, -0.0015}, 1},
                    {"ase_ownship", { 0.0031,  0.0030}, 1},
                    {"ase_ownship", {-0.0085,  0.0030}, 1}
                },
                { //Spike
                    {"ase_ownship", {-0.0030,  0.0030}, 1},
                    {"ase_ownship", { 0.0031,  0.0030}, 1},
                    {"ase_ownship", {-0.0085,  0.0165}, 1}
                }
            };
        };
    };

    class polys {

    };

    //L2: RFI power and emitter count, with the FCR mast fitted; raised a little so the count clears the autopage bracket
    #define RFIX MPD_POS_BUTTON_L_X + 0.1*MPD_TEXT_WIDTH
    #define RFIY MPD_POS_BUTTON_LR_2_Y - 0.25*MPD_TEXT_HEIGHT
    class RFI {
        condition = C_COND(C_MORE(C_MPD_USER(MFD_IND_ASE_RFI_PWR), 0));
        MPD_TEXT_R(RFI_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y - 0.7*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(" RFI"))
        class RFI_Off {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_RFI_PWR), 1));
            class lines_RFIOff {
                type = "line";
                width = 3;
                points[] = {
                    {{RFIX - 0.010, RFIY + 0.000}, 1},
                    {{RFIX - 0.007, RFIY - 0.007}, 1},
                    {{RFIX - 0.000, RFIY - 0.010}, 1},
                    {{RFIX + 0.007, RFIY - 0.007}, 1},
                    {{RFIX + 0.010, RFIY + 0.000}, 1},
                    {{RFIX + 0.007, RFIY + 0.007}, 1},
                    {{RFIX + 0.000, RFIY + 0.010}, 1},
                    {{RFIX - 0.007, RFIY + 0.007}, 1},
                    {{RFIX - 0.010, RFIY + 0.000}, 1},
                };
            };
        };
        class RFI_On {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_RFI_PWR), 2));
            class polys_RFIOn {
                class Polygons {
                    type = "polygon";
                    points[] = {
                        {
                            {{RFIX - 0.010, RFIY + 0.000}, 1},
                            {{RFIX - 0.007, RFIY - 0.007}, 1},
                            {{RFIX - 0.000, RFIY - 0.010}, 1},
                            {{RFIX, RFIY}, 1}
                        },
                        {
                            {{RFIX - 0.000, RFIY - 0.010}, 1},
                            {{RFIX + 0.007, RFIY - 0.007}, 1},
                            {{RFIX + 0.010, RFIY + 0.000}, 1},
                            {{RFIX, RFIY}, 1}
                        },
                        {
                            {{RFIX + 0.010, RFIY + 0.000}, 1},
                            {{RFIX + 0.007, RFIY + 0.007}, 1},
                            {{RFIX + 0.000, RFIY + 0.010}, 1},
                            {{RFIX, RFIY}, 1}
                        },
                        {
                            {{RFIX + 0.000, RFIY + 0.010}, 1},
                            {{RFIX - 0.007, RFIY + 0.007}, 1},
                            {{RFIX - 0.010, RFIY + 0.000}, 1},
                            {{RFIX, RFIY}, 1}
                        }
                    };
                };
            };
            class lines_RFICount {
                type = "line";
                width = 3;
                points[] = {
                    MPD_POINTS_BOX("Null", MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.4*MPD_TEXT_HEIGHT, 2*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.015),
                };
            };
            MPD_TEXT_R(RFI_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y + 0.3*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_ASE_RFI_COUNT))
        };
    };

    class vabs {
        //T2
        MPD_BOX_TALL_C(ASE, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_ARROW_C(ASE,    MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(ASE,     MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ASE"))
        //T6
        MPD_BOX_BAR_T(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        //MPD_ARROW_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
        MPD_TEXT_C(UTIL,    MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))

        //R4: CAQ chooses an RFI emitter, with the RFI on and a sight other than the FCR
        class caqBarrier {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_CAQ), 0));
            MPD_BOX_BAR_L(CTR, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
        };
        class caqChoosing {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_CAQ), 2));
            MPD_BOX_L(CAQ, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, 3)
        };
        MPD_TEXT_L(CTR,    MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("CAQ"))
        //MPD_BOX_L(PGM,   MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, 2)

    };
    class vabs_US {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AMERICAN), 1));
        //T1
        MPD_BOX_C(CHAFF_2,    MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, 4)
        //B1 or M, under the chaff count (HIDAS has its countermeasures window there)
        MPD_TEXT_C(TSD, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("TSD"))
        //R6
        MPD_TEXT_L(RLWR_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("RLWR "))
        //L1
        MPD_TEXT_R(MODE,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CHAFF MODE"))
        MPD_BOX_R(PGM,    MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 6)
        MPD_TEXT_R(PGM,   MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MANUAL"))
        MPD_BOX_BAR_R(MODE, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y)
        //L3
        MPD_MASK_V_R(SRH, ASE_AP_X, MPD_POS_BUTTON_LR_3_Y - 0.75*MPD_TEXT_HEIGHT, MPD_POS_BUTTON_LR_3_Y + 0.75*MPD_TEXT_HEIGHT)
        MPD_TEXT_R(SRH_1, ASE_AP_X, MPD_POS_BUTTON_LR_3_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
        MPD_TEXT_R(SRH_2, ASE_AP_X, MPD_POS_BUTTON_LR_3_Y,                        MPD_TEXT_STATIC("R"))
        MPD_TEXT_R(SRH_3, ASE_AP_X, MPD_POS_BUTTON_LR_3_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("H"))
        //L4
        MPD_MASK_V_R(ACQ, ASE_AP_X, MPD_POS_BUTTON_LR_4_Y - 0.75*MPD_TEXT_HEIGHT, MPD_POS_BUTTON_LR_4_Y + 0.75*MPD_TEXT_HEIGHT)
        MPD_TEXT_R(ACQ_1, ASE_AP_X, MPD_POS_BUTTON_LR_4_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(ACQ_2, ASE_AP_X, MPD_POS_BUTTON_LR_4_Y,                        MPD_TEXT_STATIC("C"))
        MPD_TEXT_R(ACQ_3, ASE_AP_X, MPD_POS_BUTTON_LR_4_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Q"))
        //L5
        MPD_MASK_V_R(TRK, ASE_AP_X, MPD_POS_BUTTON_LR_5_Y - 0.75*MPD_TEXT_HEIGHT, MPD_POS_BUTTON_LR_5_Y + 0.75*MPD_TEXT_HEIGHT)
        MPD_TEXT_R(TRK_1, ASE_AP_X, MPD_POS_BUTTON_LR_5_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(TRK_2, ASE_AP_X, MPD_POS_BUTTON_LR_5_Y,                        MPD_TEXT_STATIC("R"))
        MPD_TEXT_R(TRK_3, ASE_AP_X, MPD_POS_BUTTON_LR_5_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("K"))
        //L6
        MPD_MASK_V_R(OFF, ASE_AP_X, MPD_POS_BUTTON_LR_6_Y - 0.75*MPD_TEXT_HEIGHT, MPD_POS_BUTTON_LR_6_Y + 0.75*MPD_TEXT_HEIGHT)
        MPD_TEXT_R(OFF_1, ASE_AP_X, MPD_POS_BUTTON_LR_6_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_R(OFF_2, ASE_AP_X, MPD_POS_BUTTON_LR_6_Y,                        MPD_TEXT_STATIC("F"))
        MPD_TEXT_R(OFF_3, ASE_AP_X, MPD_POS_BUTTON_LR_6_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("F"))
    };

    //Chaff, US only: HIDAS arming is a UTIL page item
    class text_Chaff_US {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AMERICAN), 1));
        class text_ChaffSafe {
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_ASE_CHAFF_STATE)));
            MPD_TEXT_C(CHAFF_2,   MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SAFE"))
        };
        class text_ChaffArm {
            condition = C_COND(C_MPD_USER(MFD_IND_ASE_CHAFF_STATE));
            MPD_TEXT_C(CHAFF_2,   MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ARM"))
        };
    };

    class autopage_US {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AMERICAN), 1));
        //ASE Autopage
        class textBox_AutopageSrh {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_SRH));
            MPD_BOX_V(SRH, ASE_AP_X, MPD_POS_BUTTON_LR_3_Y, 3)
        };
        class textBox_AutopageAcq {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_ACQ));
            MPD_BOX_V(ACQ,  ASE_AP_X, MPD_POS_BUTTON_LR_4_Y, 3)
        };
        class textBox_AutopageTrk {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_TRK));
            MPD_BOX_V(TRK,  ASE_AP_X, MPD_POS_BUTTON_LR_5_Y, 3)
        };
        class textBox_AutopageOff {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_OFF));
            MPD_BOX_V(OFF,  ASE_AP_X, MPD_POS_BUTTON_LR_6_Y, 3)
        };
    };

    class text_US {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AMERICAN), 1));
        //Autopage text
        MPD_MASK_V_R(AUTOPAGE, ASE_AP_TEXT_X, 0.600-3.5*MPD_TEXT_HEIGHT, 0.600+3.5*MPD_TEXT_HEIGHT)
        MPD_TEXT_R(AUTOPAGE_01, ASE_AP_TEXT_X, 0.600-3.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(AUTOPAGE_02, ASE_AP_TEXT_X, 0.600-2.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("U"))
        MPD_TEXT_R(AUTOPAGE_03, ASE_AP_TEXT_X, 0.600-1.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(AUTOPAGE_04, ASE_AP_TEXT_X, 0.600-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O")) //Mid
        MPD_TEXT_R(AUTOPAGE_05, ASE_AP_TEXT_X, 0.600+0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("P")) //Mid
        MPD_TEXT_R(AUTOPAGE_06, ASE_AP_TEXT_X, 0.600+1.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(AUTOPAGE_07, ASE_AP_TEXT_X, 0.600+2.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("G"))
        MPD_TEXT_R(AUTOPAGE_08, ASE_AP_TEXT_X, 0.600+3.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))

        //CMS count box
        MPD_TEXT_C(CHAFF_COUNT_2,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y - 2*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_CMS_QTY))
    };
    class text {
        // Hdg info
        MPD_TEXT_C(HeadingHigh, 0.5, MPD_POS_BUTTON_T_Y, source = "heading"; sourceScale = 1;)
        MPD_TEXT_C(HeadingLow,  0.5, MPD_POS_BUTTON_B_Y, MPD_TEXT_USER(MFD_TEXT_IND_ASE_HDG_RECIP))
    };
};
