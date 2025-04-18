#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_ase\headers\ase.h"

class ase_draw {
    class lines {
        type = line;
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
            //Autopage top
            {{0.002, 0.380}, 1}, 
            {{0.080, 0.380}, 1}, {},
            //Autopage right
            {{0.080, 0.380}, 1}, 
            {{0.080, 0.870}, 1}, {},
            //Autopage bottom
            {{0.080, 0.870}, 1}, 
            {{0.002, 0.870}, 1}, {},
            //Heading box top
            MPD_POINTS_BOX(Null, 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_T_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {},
            //Heading box bottom
            MPD_POINTS_BOX(Null, 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_B_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {},
            //Chaff box
            MPD_POINTS_BOX(Null, MPD_POS_BUTTON_TB_1_X-(2.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_B_Y-(3*MPD_TEXT_HEIGHT), 5*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT*2), {},
        };
    };

    class occluders {
        color[] = {0,0,0,1};
        class Polygons {
            type = polygon;
            points[] = {
                { //Autopage occluder
                    {{0.075,                0.600-3.5*MPD_TEXT_HEIGHT}, 1},
                    {{0.080+MPD_TEXT_WIDTH, 0.600-3.5*MPD_TEXT_HEIGHT}, 1},
                    {{0.080+MPD_TEXT_WIDTH, 0.600+4.5*MPD_TEXT_HEIGHT}, 1},
                    {{0.075,                0.600+4.5*MPD_TEXT_HEIGHT}, 1}
                },
                { //RJAM occluder
                    {{0.718-2.1*MPD_TEXT_WIDTH, 0.925}, 1},
                    {{0.718-2.1*MPD_TEXT_WIDTH, 0.920-MPD_TEXT_HEIGHT}, 1},
                    {{0.718+2.1*MPD_TEXT_WIDTH, 0.920-MPD_TEXT_HEIGHT}, 1},
                    {{0.718+2.1*MPD_TEXT_WIDTH, 0.925}, 1}
                },
            };
        };
    };

    #define IRJamX MPD_POS_BUTTON_R_X - 0.1*MPD_TEXT_WIDTH
    #define IRJamY MPD_POS_BUTTON_LR_1_Y - 0.05*MPD_TEXT_HEIGHT
    class lines_msnEquipOnOff {
        type = line;
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
    class showMWS {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_BRITISH), 1));
        MPD_TEXT_C(CHAFF_COUNT_1,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y - 3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CH/FL"))
        MPD_TEXT_L(IRJAM_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MWS "))
        MPD_TEXT_C(CHAFF_1,   MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("CMS"))
        class MWS_ON {
            condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_ASE_IRJAM_PWR)));
            class MWSDraw {
                class polys_MWSOnOff {
                    class Polygons {
                        type = polygon;
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
                        type = line;
                        width = 3;
                        points[] = {
                            MPD_POINTS_BOX(Null, MPD_POS_BUTTON_R_X-(4*MPD_TEXT_WIDTH), MPD_POS_BUTTON_LR_1_Y + 0.6*MPD_TEXT_HEIGHT, 4*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.015),
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
                        type = polygon;
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
                        type = line;
                        width = 3;
                        points[] = {
                            MPD_POINTS_BOX(Null, MPD_POS_BUTTON_R_X-(4*MPD_TEXT_WIDTH), MPD_POS_BUTTON_LR_1_Y + 0.6*MPD_TEXT_HEIGHT, 4*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.015),
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

    #define RLWRX MPD_POS_BUTTON_R_X - 0.1*MPD_TEXT_WIDTH
    #define RLWRY MPD_POS_BUTTON_LR_6_Y - 0.05*MPD_TEXT_HEIGHT
    
    
    class RLWR_Off {
        class lines_RLWROnOff {
            type = line;
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
                    type = polygon;
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
                type = line;
                width = 3;
                points[] = {
                    //RLWR box
                    MPD_POINTS_BOX(Null, MPD_POS_BUTTON_R_X-(2*MPD_TEXT_WIDTH), MPD_POS_BUTTON_LR_6_Y + 0.6*MPD_TEXT_HEIGHT, 2*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.015),
                };
            };
            MPD_TEXT_L(RLWR_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_ASE_RLWR_COUNT))

            //Draw ASE Lines
            #define ASE_AZ(name, mpdVal)\
            class aseaz_##name {\
                color[] = {1,1,0,1};\
                class line##name {\
                condition = C_COND(C_MORE(C_MPD_USER(mpdVal), -1));\
                    class trackLine {\
                        type     = line;\
                        width    = 3;\
                        points[] = {\
                            {ase_az_##name, { 0.000, 0.018}, 1},\
                            {ase_az_##name, { 0.000, 0.036}, 1}, {},\
                            {ase_az_##name, { 0.000, 0.054}, 1},\
                            {ase_az_##name, { 0.000, 0.071}, 1}, {},\
                            {ase_az_##name, { 0.000, 0.089}, 1},\
                            {ase_az_##name, { 0.000, 0.107}, 1}, {},\
                            {ase_az_##name, { 0.000, 0.125}, 1},\
                            {ase_az_##name, { 0.000, 0.143}, 1}, {},\
                            {ase_az_##name, { 0.000, 0.161}, 1},\
                            {ase_az_##name, { 0.000, 0.179}, 1}, {},\
                            {ase_az_##name, { 0.000, 0.196}, 1},\
                            {ase_az_##name, { 0.000, 0.214}, 1}, {},\
                            {ase_az_##name, { 0.000, 0.232}, 1},\
                            {ase_az_##name, { 0.000, 0.250}, 1}, {},\
                        };\
                    };\
                };\
            };
        };
    };

    ASE_AZ(01, MFD_IND_ASE_01_AZ)
    ASE_AZ(02, MFD_IND_ASE_02_AZ)
    ASE_AZ(03, MFD_IND_ASE_03_AZ)
    ASE_AZ(04, MFD_IND_ASE_04_AZ)
    ASE_AZ(05, MFD_IND_ASE_05_AZ)
    ASE_AZ(06, MFD_IND_ASE_06_AZ)
    ASE_AZ(07, MFD_IND_ASE_07_AZ)

    //Ownship Icon
    class lines_ownshipIcon {
        color[] = {0,1,1,1};
        class Lines {
            type = line;
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

    class polys {

    };

    class vabs {
        //T1
        MPD_BOX_C(CHAFF_2,    MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, 4)
        //T2
        MPD_BOX_TALL_C(ASE, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_ARROW_C(ASE,    MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(ASE,     MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ASE"))
        //T6
        MPD_BOX_BAR_T(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        //MPD_ARROW_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
        MPD_TEXT_C(UTIL,    MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))
        
        //R4
        MPD_BOX_BAR_L(CTR, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
        MPD_TEXT_L(CTR,    MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("CAQ"))
        //R6
        MPD_TEXT_L(RLWR_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("RLWR "))
        //MPD_BOX_L(PGM,   MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, 2)

        //L1
        MPD_TEXT_R(MODE,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CHAFF MODE"))
        MPD_BOX_R(PGM,    MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 6)
        MPD_TEXT_R(PGM,   MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MANUAL"))
        //L3
        MPD_TEXT_R(SRH_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
        MPD_TEXT_R(SRH_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y,                        MPD_TEXT_STATIC("R"))
        MPD_TEXT_R(SRH_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("H"))
        //L4
        MPD_TEXT_R(ACQ_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(ACQ_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y,                        MPD_TEXT_STATIC("C"))
        MPD_TEXT_R(ACQ_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Q"))
        //L5
        MPD_TEXT_R(TRK_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(TRK_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y,                        MPD_TEXT_STATIC("R"))
        MPD_TEXT_R(TRK_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("K"))
        //L6
        MPD_TEXT_R(OFF_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_R(OFF_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y,                        MPD_TEXT_STATIC("F"))
        MPD_TEXT_R(OFF_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("F"))
    };

    //Chaff
    class text_ChaffSafe {
        condition = C_COND(C_NOT(C_MPD_USER(MFD_IND_ASE_CHAFF_STATE)));
        MPD_TEXT_C(CHAFF_2,   MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SAFE"))
    };
    class text_ChaffArm {
        condition = C_COND(C_MPD_USER(MFD_IND_ASE_CHAFF_STATE));
        MPD_TEXT_C(CHAFF_2,   MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ARM"))
    };

    //ASE Autopage
    class textBox_AutopageSrh {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_SRH));
        MPD_BOX_V(SRH, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, 3)
    };
    class textBox_AutopageAcq {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_ACQ));
        MPD_BOX_V(ACQ,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 3)
    };
    class textBox_AutopageTrk {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_TRK));
        MPD_BOX_V(TRK,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, 3)
    };
    class textBox_AutopageOff {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_ASE_AUTOPAGE), ASE_AUTOPAGE_OFF));
        MPD_BOX_V(OFF,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 3)
    };

    class text {
        //Autopage text
        MPD_TEXT_R(AUTOPAGE_01, 0.08, 0.600-3.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(AUTOPAGE_02, 0.08, 0.600-2.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("U"))
        MPD_TEXT_R(AUTOPAGE_03, 0.08, 0.600-1.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(AUTOPAGE_04, 0.08, 0.600-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O")) //Mid
        MPD_TEXT_R(AUTOPAGE_05, 0.08, 0.600+0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("P")) //Mid
        MPD_TEXT_R(AUTOPAGE_06, 0.08, 0.600+1.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(AUTOPAGE_07, 0.08, 0.600+2.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("G"))
        MPD_TEXT_R(AUTOPAGE_08, 0.08, 0.600+3.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))

        //CMS count box
        MPD_TEXT_C(CHAFF_COUNT_2,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y - 2*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_CMS_QTY))

        // Hdg info
        MPD_TEXT_C(HeadingHigh, 0.5, MPD_POS_BUTTON_T_Y, source = heading; sourceScale = 1;)
        MPD_TEXT_C(HeadingLow,  0.5, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("360"))
    };
};