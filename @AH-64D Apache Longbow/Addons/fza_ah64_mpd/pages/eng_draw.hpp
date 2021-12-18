///////////////// T ///////////////
MPD_ARROW_C(FLT, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
MPD_TEXT_C(FLT, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FLT"))

MPD_ARROW_C(FUEL, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, 4)
MPD_TEXT_C(FUEL, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FUEL"))

MPD_ARROW_C(PERF, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 4)
MPD_TEXT_C(PERF, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("PERF"))

MPD_ARROW_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
MPD_TEXT_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))

///////////////// B ///////////////
MPD_BOX_C(ENG, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, 3)
MPD_TEXT_C(ENG, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ENG"))

MPD_ARROW_C(SYS, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y, 3)
MPD_TEXT_C(SYS, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("SYS"))

MPD_ARROW_C(ETF, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_B_Y, 3)
MPD_TEXT_C(ETF, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ETF"))

MPD_ARROW_C(WCA, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, 3)
MPD_TEXT_C(WCA, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("WCA"))

MPD_TEXT_C(TORQUETAPE_LABEL, 0.115, 0.07, MPD_TEXT_STATIC("TORQUE %"))
MPD_TEXT_C(TGT_LABEL, 0.33, 0.07, MPD_TEXT_STATIC("TGT *C"))
MPD_TEXT_C(NP_1_LABEL, 0.49, 0.07, MPD_TEXT_STATIC("NP %"))
MPD_TEXT_C(NR_LABEL, 0.58, 0.07, MPD_TEXT_STATIC("NR %"))
MPD_TEXT_C(NP_2_LABEL, 0.67, 0.07, MPD_TEXT_STATIC("NP %"))

#define ENG_TAPE_HEIGHT 0.43
#define ENG_TAPE_BOTTOM_Y (0.07+MPD_TEXT_HEIGHT+ENG_TAPE_HEIGHT)
#define ENG_TAPE_HALF_WIDTH 0.015
#define ENG_TAPE_MEDIUM_HALF_WIDTH 0.025
#define ENG_TAPE_CHEVRON_MEDIUM_HEIGHT 0.015
#define ENG_TAPE_LARGE_HALF_WIDTH 0.035
#define ENG_TAPE_XLARGE_HALF_WIDTH 0.04
#define ENG_TAPE_CHEVRON_XLARGE_HEIGHT 0.024

#define ENG_TAPE_TORQUE_1_X 0.05
#define ENG_TAPE_TORQUE_2_X 0.15
#define ENG_TAPE_TGT_1_X (0.33-0.05)
#define ENG_TAPE_TGT_2_X (0.33+0.05)
#define ENG_TAPE_NP_1_X 0.49
#define ENG_TAPE_NP_2_X 0.67
#define ENG_TAPE_NR_X 0.58

#define ENG_SIDE_DATA_X 0.85

#define ENG_SIDE_DATA_1_X 0.78
#define ENG_SIDE_DATA_2_X 0.92

MPD_TEXT_C(TORQUE_1_NUMBER, ENG_TAPE_TORQUE_1_X, ENG_TAPE_BOTTOM_Y, MPD_TEXT_STATIC("1"))
MPD_TEXT_C(TORQUE_2_NUMBER, ENG_TAPE_TORQUE_2_X, ENG_TAPE_BOTTOM_Y, MPD_TEXT_STATIC("2"))
MPD_TEXT_C(TGT_1_NUMBER, ENG_TAPE_TGT_1_X, ENG_TAPE_BOTTOM_Y, MPD_TEXT_STATIC("1"))
MPD_TEXT_C(TGT_2_NUMBER, ENG_TAPE_TGT_2_X, ENG_TAPE_BOTTOM_Y, MPD_TEXT_STATIC("2"))
MPD_TEXT_C(NP_1_NUMBER, ENG_TAPE_NP_1_X, ENG_TAPE_BOTTOM_Y, MPD_TEXT_STATIC("1"))
MPD_TEXT_C(NP_2_NUMBER, ENG_TAPE_NP_2_X, ENG_TAPE_BOTTOM_Y, MPD_TEXT_STATIC("2"))


#define ENG_TAPE_RECT(middleX, halfWidth, startPct, bone) \
    {\
        { {middleX - halfWidth, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT}, 1},\
        { {middleX + halfWidth, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT}, 1},\
        { bone, {middleX + halfWidth, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT}, 1},\
        { bone, {middleX - halfWidth, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT}, 1}\
    }

#define ENG_TAPE_CHEVRON(middleX, halfWidth, chevronHeight, startPct, bone) \
    {\
        { {middleX - halfWidth, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT + chevronHeight}, 1},\
        { {middleX, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT}, 1},\
        { bone, {middleX, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT}, 1},\
        { bone, {middleX - halfWidth, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT + chevronHeight}, 1}\
    },\
    {\
        { {middleX + halfWidth, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT + chevronHeight}, 1},\
        { {middleX, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT}, 1},\
        { bone, {middleX, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT}, 1},\
        { bone, {middleX + halfWidth, ENG_TAPE_BOTTOM_Y - startPct * ENG_TAPE_HEIGHT + chevronHeight}, 1}\
    }


#define ENG_TORQUE_TAPE(num, posX, textInd)\
    class Tapes {\
        type = "polygon";\
        points[] = {\
            ENG_TAPE_RECT(posX, ENG_TAPE_HALF_WIDTH, 0, CONCAT_3(Eng_Torque_,num,_Zone_1)),\
            ENG_TAPE_RECT(posX, ENG_TAPE_MEDIUM_HALF_WIDTH, 0.7, CONCAT_3(Eng_Torque_,num,_Zone_2)),\
            ENG_TAPE_RECT(posX, ENG_TAPE_LARGE_HALF_WIDTH, 0.85, CONCAT_3(Eng_Torque_,num,_Zone_3))\
        };\
    };\
    MPD_TEXT_C(Digit, posX, ENG_TAPE_BOTTOM_Y - 0.7 * ENG_TAPE_HEIGHT, MPD_TEXT_USER(textInd))

#define ENG_TGT_TAPE(num, posX, textInd)\
    class Tapes {\
        type = "polygon";\
        points[] = {\
            ENG_TAPE_RECT(posX, ENG_TAPE_HALF_WIDTH, 0, CONCAT_3(Eng_Tgt_,num,_Zone_1) COMMA 1 COMMA CONCAT_3(Eng_Tgt_,num,_Zone_2)),\
            ENG_TAPE_RECT(posX, ENG_TAPE_MEDIUM_HALF_WIDTH, 0.7, CONCAT_3(Eng_Tgt_,num,_Zone_3))\
        };\
    };\
    MPD_TEXT_C(Digit, posX, ENG_TAPE_BOTTOM_Y - 0.7 * ENG_TAPE_HEIGHT, MPD_TEXT_USER(textInd))

#define ENG_NP_TAPE(num, posX, textX, textInd)\
    class Tapes {\
        type = "polygon";\
        points[] = {\
            ENG_TAPE_RECT(posX, ENG_TAPE_HALF_WIDTH, 0, CONCAT_3(Eng_Np_,num,_Zone_1) COMMA 1 COMMA CONCAT_3(Eng_Np_,num,_Zone_2)),\
            ENG_TAPE_CHEVRON(posX, ENG_TAPE_MEDIUM_HALF_WIDTH, ENG_TAPE_CHEVRON_MEDIUM_HEIGHT, 0.75, CONCAT_3(Eng_Np_,num,_Zone_3) COMMA 1 COMMA CONCAT_3(Eng_Np_,num,_Zone_4))\
        };\
    };\
    MPD_TEXT_C(Digit, textX, 0.35+MPD_TEXT_HEIGHT, MPD_TEXT_USER(textInd))

#define ENG_NR_TAPE\
    class Tapes {\
        type = "polygon";\
        points[] = {\
            ENG_TAPE_CHEVRON(ENG_TAPE_NR_X, ENG_TAPE_XLARGE_HALF_WIDTH, -ENG_TAPE_CHEVRON_XLARGE_HEIGHT, 0, "Eng_Nr_Zone_1"),\
            ENG_TAPE_RECT(ENG_TAPE_NR_X, ENG_TAPE_HALF_WIDTH, 0.4, "Eng_Nr_Zone_2"),\
            ENG_TAPE_RECT(ENG_TAPE_NR_X, ENG_TAPE_HALF_WIDTH, 0.7, "Eng_Nr_Zone_3"),\
            ENG_TAPE_CHEVRON(ENG_TAPE_NR_X, ENG_TAPE_MEDIUM_HALF_WIDTH, ENG_TAPE_CHEVRON_MEDIUM_HEIGHT, 0.75, "Eng_Nr_Zone_4"),\
            ENG_TAPE_CHEVRON(ENG_TAPE_NR_X, ENG_TAPE_XLARGE_HALF_WIDTH, ENG_TAPE_CHEVRON_XLARGE_HEIGHT, 0.9, "Eng_Nr_Zone_5")\
        };\
    };\
    MPD_TEXT_C(Digit, ENG_TAPE_NR_X, ENG_TAPE_BOTTOM_Y - 0.7 * ENG_TAPE_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_ENG_NR))

#define COLOR_G_Y_R(name, value, del1, del2, config) \
    class name##_Green {\
        condition = __EVAL(format ["%2 - user%1", MFD_OFFSET + value, del1]);\
        config\
    };\
    class name##_Yellow {\
        color[] = {1,1,0,1};\
        condition = __EVAL(format ["(user%1 - %2) * (%3 - user%1)", MFD_OFFSET + value, del1-0.05, del2+0.05]);\
        config\
    };\
    class name##_Red {\
        color[] = {1,0,0,1};\
        condition = __EVAL(format ["user%1 - %2", MFD_OFFSET + value, del2]);\
        config\
    };

#define COLOR_R_G_Y_R(name, value, del1, del2, del3, config) \
    class name##_Red {\
        color[] = {1,0,0,1};\
        condition = __EVAL(format ["%2 - user%1", MFD_OFFSET + value, del1]);\
        config\
    };\
    class name##_Green {\
        condition = __EVAL(format ["(user%1 - %2) * (%3 - user%1)", MFD_OFFSET + value, del1-0.1, del2+0.1]);\
        config\
    };\
    class name##_Yellow {\
        color[] = {1,1,0,1};\
        condition = __EVAL(format ["(user%1 - %2) * (%3 - user%1)", MFD_OFFSET + value, del2-0.1, del3+0.1]);\
        config\
    };\
    class name##_Red2 {\
        color[] = {1,0,0,1};\
        condition = __EVAL(format ["user%1 - %2", MFD_OFFSET + value, del3]);\
        config\
    };

COLOR_G_Y_R(Torque_1, MFD_IND_ENG_TORQUE_1, 110, 125, ENG_TORQUE_TAPE(1, ENG_TAPE_TORQUE_1_X, MFD_TEXT_IND_ENG_TORQUE_1))
COLOR_G_Y_R(Torque_2, MFD_IND_ENG_TORQUE_2, 110, 125, ENG_TORQUE_TAPE(2, ENG_TAPE_TORQUE_2_X, MFD_TEXT_IND_ENG_TORQUE_2))
COLOR_G_Y_R(Tgt_1, MFD_IND_ENG_TGT_1, 811, 950, ENG_TGT_TAPE(1, ENG_TAPE_TGT_1_X, MFD_TEXT_IND_ENG_TGT_1))
COLOR_G_Y_R(Tgt_2, MFD_IND_ENG_TGT_2, 811, 950, ENG_TGT_TAPE(2, ENG_TAPE_TGT_2_X, MFD_TEXT_IND_ENG_TGT_2))
COLOR_R_G_Y_R(Np_1, MFD_IND_ENG_NP_1, 95, 105, 110, ENG_NP_TAPE(1, ENG_TAPE_NP_1_X, ENG_SIDE_DATA_1_X, MFD_TEXT_IND_ENG_NP_1))
COLOR_R_G_Y_R(Np_2, MFD_IND_ENG_NP_2, 95, 105, 110, ENG_NP_TAPE(2, ENG_TAPE_NP_2_X, ENG_SIDE_DATA_2_X, MFD_TEXT_IND_ENG_NP_2))
COLOR_R_G_Y_R(Nr, MFD_IND_ENG_NR, 95, 105, 110, ENG_NR_TAPE)

class StarterBox {
    condition = MPD_COND_USER(MFD_IND_ENG_START)
    class StarterBox {
        type = line;
        width = 3;
        points[] = {
            MPD_POINTS_BOX(Null, 0.72, 0.45, 0.26, (5*MPD_TEXT_HEIGHT))
        };
    };
    MPD_TEXT_C(NG_SIDE_START, ENG_SIDE_DATA_X, 0.45+4*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("START"))
}

class StarterEng1 {
    condition = __EVAL(format [STRINGIFY(EQ(user%1, 1)), MFD_OFFSET + MFD_IND_ENG_START]);
    color[] = {1,1,1,1};
    MPD_TEXT_C(NP_SIDE_ENG_1_STARTER, ENG_SIDE_DATA_1_X, 0.45+3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ON"))
};

class StarterEng2 {
    condition = __EVAL(format [STRINGIFY(EQ(user%1, 2)), MFD_OFFSET + MFD_IND_ENG_START]);
    color[] = {1,1,1,1};
    MPD_TEXT_C(NG_SIDE_ENG_2_STARTER, ENG_SIDE_DATA_2_X, 0.45+3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ON"))
};

MPD_TEXT_C(NP_SIDE_LABEL, ENG_SIDE_DATA_X, 0.35, MPD_TEXT_STATIC("Np %"))
MPD_TEXT_C(NG_SIDE_LABEL, ENG_SIDE_DATA_X, 0.45, MPD_TEXT_STATIC("NG %"))
MPD_TEXT_C(NP_SIDE_NG_1, ENG_SIDE_DATA_1_X, 0.45+MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_ENG_NG_1))
MPD_TEXT_C(NG_SIDE_NG_2, ENG_SIDE_DATA_2_X, 0.45+MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_ENG_NG_2))
MPD_TEXT_C(NP_SIDE_ENG_1_LABEL, ENG_SIDE_DATA_1_X, 0.45+2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("1"))
MPD_TEXT_C(NG_SIDE_ENG_2_LABEL, ENG_SIDE_DATA_2_X, 0.45+2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("2"))


#define ENG_HYDRAULICS_X 0.48
#define ENG_HYDRAULICS_Y 0.64
#define ENG_OIL_PSI_X 0.20
#define ENG_OIL_PSI_Y 0.64

#define LIMITS_DIAMOND(bone, posX, posY) \
    {\
        {bone, {posX, posY-0.01}, 1},\
        {bone, {posX+0.01, posY}, 1},\
        {bone, {posX, posY+0.01}, 1},\
        {bone, {posX-0.01, posY}, 1}\
    }

class Limits_Red {
    color[] = {1,0,0,1};

    class Lines {
        type = line;
        width = 12;
        points[] = {
            {"Eng_Torque_Limit_Zone_1", 1, "Eng_Torque_Limit_Zone_2", 1, "Eng_Torque_Limit_Zone_3", {0.115 - 0.095, ENG_TAPE_BOTTOM_Y}, 1},
            {"Eng_Torque_Limit_Zone_1", 1, "Eng_Torque_Limit_Zone_2", 1, "Eng_Torque_Limit_Zone_3", {0.115 + 0.095, ENG_TAPE_BOTTOM_Y}, 1}, {},
            {"Eng_Tgt_Limit_Zone_1", 1, "Eng_Tgt_Limit_Zone_2", 1, "Eng_Tgt_Limit_Zone_3", {0.33 - 0.095, ENG_TAPE_BOTTOM_Y}, 1},
            {"Eng_Tgt_Limit_Zone_1", 1, "Eng_Tgt_Limit_Zone_2", 1, "Eng_Tgt_Limit_Zone_3", {0.33 + 0.095, ENG_TAPE_BOTTOM_Y}, 1}, {},
            {{ENG_TAPE_NR_X - ENG_TAPE_XLARGE_HALF_WIDTH, ENG_TAPE_BOTTOM_Y - 0.9 * ENG_TAPE_HEIGHT + ENG_TAPE_CHEVRON_XLARGE_HEIGHT}, 1},
            {{ENG_TAPE_NR_X, ENG_TAPE_BOTTOM_Y - 0.9 * ENG_TAPE_HEIGHT}, 1},
            {{ENG_TAPE_NR_X + ENG_TAPE_XLARGE_HALF_WIDTH, ENG_TAPE_BOTTOM_Y - 0.9 * ENG_TAPE_HEIGHT + ENG_TAPE_CHEVRON_XLARGE_HEIGHT}, 1}
        };
    };

    class Polygons {
        type = polygon;
        points[] = {
            LIMITS_DIAMOND("Eng_Torque_Limit_Zone_1" COMMA 1 COMMA "Eng_Torque_Limit_Zone_2" COMMA 1 COMMA "Eng_Torque_Limit_Zone_3", 0.115, ENG_TAPE_BOTTOM_Y),
            LIMITS_DIAMOND("Eng_Tgt_Limit_Zone_1" COMMA 1 COMMA "Eng_Tgt_Limit_Zone_2" COMMA 1 COMMA "Eng_Tgt_Limit_Zone_3", 0.33, ENG_TAPE_BOTTOM_Y),
            LIMITS_DIAMOND(Null, ENG_TAPE_NR_X - 0.055, ENG_TAPE_BOTTOM_Y - 0.9 * ENG_TAPE_HEIGHT),
            LIMITS_DIAMOND(Null, ENG_TAPE_NR_X + 0.055, ENG_TAPE_BOTTOM_Y - 0.9 * ENG_TAPE_HEIGHT)
        };
    };
};

class AirFormatOnly {
    condition=__EVAL(format ["user%1", MFD_OFFSET + MFD_IND_ENG_MODE]);
    class WCA_Box{
        type = line;
        width = 3;
        points[] = {
            //Center lines
            {{0.496, 0.6}, 1}, {{0.496, 0.6 + 6*MPD_TEXT_HEIGHT}, 1}, {},
            {{0.504, 0.6}, 1}, {{0.504, 0.6 + 6*MPD_TEXT_HEIGHT}, 1}, {},
            //Curved box
            MPD_POINTS_BOX(Null, (0.05), 0.60, (0.9), 6*MPD_TEXT_HEIGHT) 
        };
    };
    MPD_WCA_ITEM(MFD_IND_ENG_WCA_1, 0.05, 0.6, 0)
    MPD_WCA_ITEM(MFD_IND_ENG_WCA_2, 0.05, 0.6, 1)
    MPD_WCA_ITEM(MFD_IND_ENG_WCA_3, 0.05, 0.6, 2)
    MPD_WCA_ITEM(MFD_IND_ENG_WCA_4, 0.05, 0.6, 3)
    MPD_WCA_ITEM(MFD_IND_ENG_WCA_5, MPD_WCA_COLUMN_2_X, 0.6, 0)
    MPD_WCA_ITEM(MFD_IND_ENG_WCA_6, MPD_WCA_COLUMN_2_X, 0.6, 1)
    MPD_WCA_ITEM(MFD_IND_ENG_WCA_7, MPD_WCA_COLUMN_2_X, 0.6, 2)
    MPD_WCA_ITEM(MFD_IND_ENG_WCA_8, MPD_WCA_COLUMN_2_X, 0.6, 3)
}
class Hydraulics_Box {
    type = line;
    width = 3;
    points[] = {
         MPD_POINTS_BOX(Eng_Hyd_Box, ENG_HYDRAULICS_X - 0.015, ENG_HYDRAULICS_Y, (5*MPD_TEXT_WIDTH + 4*MPD_TEXT_WIDTH + 0.03), (4*MPD_TEXT_HEIGHT+0.01))
    };
};

MPD_TEXT_BONE_R(Hydraulics_Label, Eng_Hyd_Box, ENG_HYDRAULICS_X, ENG_HYDRAULICS_Y, MPD_TEXT_STATIC("HYD PSI"))
MPD_TEXT_BONE_R(Hydraulics_Pri_Label, Eng_Hyd_Box, (ENG_HYDRAULICS_X + MPD_TEXT_WIDTH/2), (ENG_HYDRAULICS_Y+MPD_TEXT_HEIGHT+0.01), MPD_TEXT_STATIC("PRI"))
MPD_TEXT_BONE_R(Hydraulics_Util_Label, Eng_Hyd_Box, (ENG_HYDRAULICS_X + MPD_TEXT_WIDTH/2), (ENG_HYDRAULICS_Y+2*MPD_TEXT_HEIGHT+0.01), MPD_TEXT_STATIC("UTIL"))
MPD_TEXT_BONE_R(Hydraulics_Acc_Label, Eng_Hyd_Box, (ENG_HYDRAULICS_X + MPD_TEXT_WIDTH/2), (ENG_HYDRAULICS_Y+3*MPD_TEXT_HEIGHT+0.01), MPD_TEXT_STATIC("ACC"))
MPD_TEXT_BONE_R(Hydraulics_Pri, Eng_Hyd_Box, (ENG_HYDRAULICS_X+5*MPD_TEXT_WIDTH), (ENG_HYDRAULICS_Y+MPD_TEXT_HEIGHT+0.01), MPD_TEXT_STATIC("2970"))
MPD_TEXT_BONE_R(Hydraulics_Util, Eng_Hyd_Box, (ENG_HYDRAULICS_X+5*MPD_TEXT_WIDTH), (ENG_HYDRAULICS_Y+2*MPD_TEXT_HEIGHT+0.01), MPD_TEXT_STATIC("2970"))
MPD_TEXT_BONE_R(Hydraulics_Acc, Eng_Hyd_Box, (ENG_HYDRAULICS_X+5*MPD_TEXT_WIDTH), (ENG_HYDRAULICS_Y+3*MPD_TEXT_HEIGHT+0.01), MPD_TEXT_STATIC("3000"))

class GroundFormatOnly {
    condition=__EVAL(format ["1 - user%1", MFD_OFFSET + MFD_IND_ENG_MODE]);

    class GroundFormatBoxes {
        type = line;
        width = 3;
        points[] = {
            MPD_POINTS_BOX(Null, ENG_OIL_PSI_X - 0.015, ENG_OIL_PSI_Y, (5*MPD_TEXT_WIDTH + 4*MPD_TEXT_WIDTH + 0.03), (4*MPD_TEXT_HEIGHT+0.01))
        };
    };

    MPD_TEXT_R(Oil_PSI_Label_1, ENG_OIL_PSI_X, ENG_OIL_PSI_Y, MPD_TEXT_STATIC("ENGINE"))
    MPD_TEXT_R(Oil_PSI_Label_2, ENG_OIL_PSI_X, ENG_OIL_PSI_Y + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(" OIL PSI"))

    MPD_TEXT_L(Oil_PSI_1, ENG_OIL_PSI_X+4*MPD_TEXT_WIDTH+0.005, ENG_OIL_PSI_Y+2*MPD_TEXT_HEIGHT+0.01, MPD_TEXT_USER(MFD_TEXT_IND_ENG_OIL_PSI_1))
    MPD_TEXT_L(Oil_PSI_1_Label, ENG_OIL_PSI_X+3*MPD_TEXT_WIDTH+0.005, ENG_OIL_PSI_Y+3*MPD_TEXT_HEIGHT+0.01, MPD_TEXT_STATIC("1"))
    MPD_TEXT_L(Oil_PSI_2, ENG_OIL_PSI_X+9*MPD_TEXT_WIDTH-0.005, ENG_OIL_PSI_Y+2*MPD_TEXT_HEIGHT+0.01, MPD_TEXT_USER(MFD_TEXT_IND_ENG_OIL_PSI_2))
    MPD_TEXT_L(Oil_PSI_2_Label, ENG_OIL_PSI_X+8*MPD_TEXT_WIDTH-0.005, ENG_OIL_PSI_Y+3*MPD_TEXT_HEIGHT+0.01, MPD_TEXT_STATIC("2"))
};