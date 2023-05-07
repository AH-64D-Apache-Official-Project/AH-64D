#define ENG_TAPE_HEIGHT 0.43

#define TGT_SCALING(num, sourceNum) \
    class Eng_##num##_Zone_1 {\
        type = linear;\
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
        type = linear;\
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
        type = linear;\
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
    type = linear;
    MPD_NUM_USER(MFD_IND_ENG_MODE)
    min=0;
    max=1;
    maxPos[] = {0, 0};
    minPos[] = {0.26, -0.51};
};

#define NR_SCALING(num, sourceNum) \
    class Eng_##num##_Zone_1 {\
        type = linear;\
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
TORQUE_SCALING(Torque_1, MFD_IND_ENG_TORQUE_1)
TORQUE_SCALING(Torque_2, MFD_IND_ENG_TORQUE_2)
TORQUE_SCALING(Torque_Limit, MFD_IND_ENG_TORQUE_BAR)
NP_SCALING(Np_1, MFD_IND_ENG_NP_1)
NP_SCALING(Np_2, MFD_IND_ENG_NP_2)
NR_SCALING(Nr, MFD_IND_ENG_NR)