#define ENG_TAPE_HEIGHT 0.43

#define TGT_SCALING(num, sourceNum) \
    class Eng_##num##_Zone_1 {\
        type = "linear";\
        MPD_NUM_USER(sourceNum)\
        min=0;\
        max=400;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.1 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_2: Eng_##num##_Zone_1 {\
        min=400;\
        max=810;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.5 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_3: Eng_##num##_Zone_1 {\
        min=810;\
        max=999;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.3 * ENG_TAPE_HEIGHT};\
    };\

#define TORQUE_SCALING(num, sourceNum) \
    class Eng_##num##_Zone_1 {\
        type = "linear";\
        MPD_NUM_USER(sourceNum)\
        min=0;\
        max=100;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.6 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_2: Eng_##num##_Zone_1 {\
        min=100;\
        max=115;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.15 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_3: Eng_##num##_Zone_1 {\
        min=115;\
        max=130;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.15 * ENG_TAPE_HEIGHT};\
    };

#define NP_SCALING(num, sourceNum) \
    class Eng_##num##_Zone_1 {\
        type = "linear";\
        MPD_NUM_USER(sourceNum)\
        min=0;\
        max=95;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.40 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_2: Eng_##num##_Zone_1 {\
        min=95;\
        max=105;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.35 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_3: Eng_##num##_Zone_1 {\
        min=105;\
        max=110;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.15 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_4: Eng_##num##_Zone_1 {\
        min=110;\
        max=120;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.10 * ENG_TAPE_HEIGHT};\
    };

class Eng_Hyd_Box {
    type = "linear";
    MPD_NUM_USER(MFD_IND_ENG_MODE)
    min=1;
    max=2;
    maxPos[] = {0, 0};
    minPos[] = {0.26, -0.51};
};

#define NR_SCALING(num, sourceNum) \
    class Eng_##num##_Zone_1 {\
        type = "linear";\
        MPD_NUM_USER(sourceNum)\
        min=0;\
        max=95;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.40 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_2: Eng_##num##_Zone_1 {\
        min=95;\
        max=95+10*0.2/0.35;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.2 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_3: Eng_##num##_Zone_1 {\
        min=105-10*0.05/0.35;\
        max=105;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.05 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_4: Eng_##num##_Zone_1 {\
        min=105;\
        max=110;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.15 * ENG_TAPE_HEIGHT};\
    };\
    class Eng_##num##_Zone_5: Eng_##num##_Zone_1 {\
        min=110;\
        max=120;\
        maxPos[] = {0, 0};\
        minPos[] = {0, -0.10 * ENG_TAPE_HEIGHT};\
    };


TGT_SCALING(Tgt_1, MFD_IND_ENG_TGT_1)
TGT_SCALING(Tgt_2, MFD_IND_ENG_TGT_2)
TGT_SCALING(Tgt_Limit, MFD_IND_ENG_TGT_BAR)
TGT_SCALING(Tgt_Sub_1, MFD_IND_ENG_TGT_SUB_1)
TGT_SCALING(Tgt_Sub_2, MFD_IND_ENG_TGT_SUB_2)
TGT_SCALING(Tgt_Sub_3, MFD_IND_ENG_TGT_SUB_3)
TGT_SCALING(Tgt_Sub_4, MFD_IND_ENG_TGT_SUB_4)
TORQUE_SCALING(Torque_1, MFD_IND_ENG_TORQUE_1)
TORQUE_SCALING(Torque_2, MFD_IND_ENG_TORQUE_2)
TORQUE_SCALING(Torque_Limit, MFD_IND_ENG_TORQUE_BAR)
TORQUE_SCALING(Torque_Sub_1, MFD_IND_ENG_TORQUE_SUB_1)
TORQUE_SCALING(Torque_Sub_2, MFD_IND_ENG_TORQUE_SUB_2)
NP_SCALING(Np_1, MFD_IND_ENG_NP_1)
NP_SCALING(Np_2, MFD_IND_ENG_NP_2)
NR_SCALING(Nr, MFD_IND_ENG_NR)

//The emergency procedure title's inverse bar, as long as the title
class Eng_Emer_Title {
    type = "linear";
    source = "user";
    sourceIndex = MFD_IND_ENG_EMER_TITLE_LEN;
    min = 0;
    max = 40;
    maxPos[] = {0, 0};
    minPos[] = {40 * MPD_TEXT_WIDTH, 0};
};

MPD_BONE_ACQ_SRC_BOX(Eng_Acq, MFD_IND_ENG_ACQ_BOX)
