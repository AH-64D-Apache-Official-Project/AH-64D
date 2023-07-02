class root {
    class polys_elev {
        class Polygon {
            type = polygon;
            points[] = {
                {
                    { {0.060, 0.860}, 1 },
                    { {0.072, 0.850}, 1 },
                    { {0.072, 0.870}, 1 },
                },
            };
        };
    };

    class lines_elev {
        type = line;
        width = 3;
        points[] = {
            //25 deg
            {{0.030, 0.800}, 1}, 
            {{0.060, 0.800}, 1}, {},
            //18.75 deg
            {{0.030, 0.815}, 1}, 
            {{0.050, 0.815}, 1}, {},
            //12.5 deg
            {{0.030, 0.830}, 1}, 
            {{0.050, 0.830}, 1}, {},
            //6.25 deg
            {{0.030, 0.845}, 1}, 
            {{0.050, 0.845}, 1}, {},
            //0 deg
            {{0.030, 0.860}, 1}, 
            {{0.050, 0.860}, 1}, {},
            //6.25 deg
            {{0.030, 0.875}, 1}, 
            {{0.060, 0.875}, 1}, {},
            //12.5 deg
            {{0.030, 0.890}, 1}, 
            {{0.050, 0.890}, 1}, {},
            //18.75 deg
            {{0.030, 0.905}, 1}, 
            {{0.050, 0.905}, 1}, {},
            //25 deg
            {{0.030, 0.920}, 1}, 
            {{0.060, 0.920}, 1}, {},
        };
    };

    class lines_HAD {
        type = line;
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
            MPD_POINTS_BOX(Null, 0.22-(6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, 12*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT), {},
            //Right HAD box
            MPD_POINTS_BOX(Null, 0.78-(6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, 12*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT), {},
            //Target count box
            MPD_POINTS_BOX(Null, 0.95-(4*MPD_TEXT_WIDTH), 0.04, 4*MPD_TEXT_WIDTH, 0.9*MPD_TEXT_HEIGHT), {},
        };
    };

    class lines_HAD_CPGFormat {
        type = line;
        width = 3;
        points[] = {
            //Top center index
            {{0.500, 0.894}, 1}, 
            {{0.500, 0.909}, 1}, {},
            //Bottom center index
            {{0.500, 0.984}, 1}, 
            {{0.500, 0.969}, 1}, {},
            //90 deg left top
            {{0.410, 0.894}, 1}, 
            {{0.410, 0.909}, 1}, {},
            //90 deg left bottom
            {{0.410, 0.984}, 1}, 
            {{0.410, 0.969}, 1}, {},
            //90 deg right top
            {{0.590, 0.894}, 1}, 
            {{0.590, 0.909}, 1}, {},
            //90 deg left bottom
            {{0.590, 0.984}, 1}, 
            {{0.590, 0.969}, 1}, {},
            //Left center index
            {{0.380, 0.917}, 1}, 
            {{0.395, 0.917}, 1}, {},
            //Right center index
            {{0.620, 0.917}, 1},
            {{0.605, 0.917}, 1}, {},
        };
    };

    class lines_HAD_PLTFormat {
        type = line;
        width = 3;
        points[] = {
            //Top center index
            {{0.500, 0.894}, 1}, 
            {{0.500, 0.909}, 1}, {},
            //Bottom center index
            {{0.500, 0.984}, 1}, 
            {{0.500, 0.969}, 1}, {},
            //Left center index
            {{0.380, 0.917}, 1}, 
            {{0.395, 0.917}, 1}, {},
            //Right center index
            {{0.620, 0.917}, 1},
            {{0.605, 0.917}, 1}, {},
        };
    };

    class lines_CurScanLine {
        //Needs bone
        type = line;
        width = 3;
        points[] = {
            {{0.450, 0.894}, 1}, 
            {{0.450, 0.984}, 1}, {},
        };
    };

    class lines_PrevScanLine {
        //Needs bone
        type = line;
        width = 3;
        points[] = {
            //1
            {{0.580, 0.894}, 1}, 
            {{0.580, 0.904}, 1}, {},
            //2
            {{0.580, 0.914}, 1}, 
            {{0.580, 0.924}, 1}, {},
            //3
            {{0.580, 0.934}, 1}, 
            {{0.580, 0.944}, 1}, {},
            //4
            {{0.580, 0.954}, 1}, 
            {{0.580, 0.964}, 1}, {},
            //5
            {{0.580, 0.974}, 1}, 
            {{0.580, 0.984}, 1}, {},
        };
    };

    class polys_CuedLOS {
        //Needs bone
        class Polygon {
            type = polygon;
            points[] = {
                {
                    { {0.495, 0.939}, 1 },
                    { {0.500, 0.934}, 1 },
                    { {0.505, 0.939}, 1 },
                    { {0.500, 0.944}, 1 }
                },
            };
        };
    };

    class lines_FOVBox {
        //Needs bone
        type = line;
        width = 3;
        points[] = {
            //Top
            {{0.480, 0.926}, 1}, 
            {{0.520, 0.926}, 1},
            //Right
            {{0.520, 0.926}, 1}, 
            {{0.520, 0.952}, 1},
            //Bottom
            {{0.520, 0.952}, 1}, 
            {{0.480, 0.952}, 1},
            //Left
            {{0.480, 0.952}, 1}, 
            {{0.480, 0.926}, 1}, {},
        };
    };

    #include "common\headingtape.hpp"

    class Obscurants {
        color[] = {0,0,0,1};
        class HeadingTape {
            type = polygon;
            points[] = {
                {
                    {{0.5 - MPD_TEXT_WIDTH * 1.5, 0.144 - MPD_TEXT_HEIGHT}, 1},
                    {{0.5 + MPD_TEXT_WIDTH * 1.5, 0.144 - MPD_TEXT_HEIGHT}, 1},
                    {{0.5 + MPD_TEXT_WIDTH * 1.5, 0.144}, 1},
                    {{0.5 - MPD_TEXT_WIDTH * 1.5, 0.144}, 1}
                }
            };
        };
    };

    MPD_TEXT_C(Heading, 0.5, 0.105, source = heading; sourceScale = 1;)
    
    class vabs{
        //T6
        MPD_BOX_BAR_T(UTIL,    MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        MPD_TEXT_C(UTIL,       MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))
        
        //R4
        MPD_TEXT_L(RFHO_1,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("RF"))
        MPD_TEXT_L(RFHO_2,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("HO"))
        //R6
        MPD_ACQ_SRC(Acq, MFD_IND_FCR_ACQ_BOX, MFD_TEXT_IND_FCR_ACQ_SRC, Fcr_Acq)

        //L1
        MPD_TEXT_R(NTS_1,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("N"))
        MPD_TEXT_R(NTS_2,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y,                        MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(NTS_3,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
        //L4
        MPD_TEXT_R(TGT_1,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(TGT_2,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y,                        MPD_TEXT_STATIC("G"))
        MPD_TEXT_R(TGT_3,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        //L5
        MPD_TEXT_R(ELEV_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ELEV"))
        MPD_BOX_R(ELEV,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, 4)
        MPD_TEXT_R(ELEV,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("AUTO"))
    };

    class text {
        //Target count
        MPD_TEXT_L(COUNT, 0.95, 0.04, MPD_TEXT_USER(MFD_TEXT_IND_FCR_COUNT))

        //HAD left
        //Sight Select Status (6 chars)
        MPD_TEXT_R(SSS, 0.22 - (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_SSS))
        //Range and Range Source 5 chars
        MPD_TEXT_L(RRS, 0.22 + (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_RRS))
        //Sight Status (12 chars)
        MPD_TEXT_R(SS,  0.22 - (6*MPD_TEXT_WIDTH), 0.939,                   MPD_TEXT_USER(MFD_TEXT_IND_FCR_SS))

        //HAD right
        //Weapon Control 5 chars
        MPD_TEXT_R(WC,  0.78 - (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_WC))
        //Acquisition Select Status 4 chars
        MPD_TEXT_R(ACQ, 0.78 + MPD_TEXT_WIDTH,     0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_ACQ))
        //Weapon Status 12 chars
        MPD_TEXT_R(WS,  0.78 - (6*MPD_TEXT_WIDTH), 0.939,                   MPD_TEXT_USER(MFD_TEXT_IND_FCR_WS))
    };
    class Cscope {
        MPD_TEXT_C(C_SCP,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("C SCP"))
        class Boxed {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_CSCOPE), 1));
            MPD_BOX_C(UTIL, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 5)
        };
    };
    class GTM {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_MODE), 1));
        #include "fcr\gtm.hpp"
    };
    class ATM {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_MODE), 2));
        #include "fcr\atm.hpp"
    };
};