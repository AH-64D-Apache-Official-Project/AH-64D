class Gun {
    class Selected {
        condition = C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN), 1), C_EQ(C_MPD_USER(MFD_IND_WPN_CANNON_FAILURE), 0)));
        //Here
        class Polygon {
            type = polygon;
            points[] = {
                {
                    { {0.4775, 0.3220}, 1 },
                    { {0.4788, 0.3170}, 1 },
                    { {0.4875, 0.3220}, 1 },
                }, {
                    { {0.4788, 0.3170}, 1 },
                    { {0.4825, 0.3133}, 1 },
                    { {0.4875, 0.3220}, 1 },
                }, {
                    { {0.4825, 0.3133}, 1 },
                    { {0.4875, 0.3120}, 1 },
                    { {0.4875, 0.3220}, 1 },
                }, {
                    { {0.4875, 0.3220}, 1 },
                    { {0.4875, 0.3133}, 1 },
                    { {0.5125, 0.3133}, 1 },
                    { {0.5125, 0.3220}, 1 },
                }, {
                    { {0.5125, 0.3120}, 1 },
                    { {0.5175, 0.3133}, 1 },
                    { {0.5125, 0.3220}, 1 },
                }, {
                    { {0.5175, 0.3133}, 1 },
                    { {0.5212, 0.3170}, 1 },
                    { {0.5125, 0.3220}, 1 },
                }, {
                    { {0.5212, 0.3170}, 1 },
                    { {0.5225, 0.3220}, 1 },
                    { {0.5125, 0.3220}, 1 },
                }, {
                    { {0.4775, 0.3220}, 1 },
                    { {0.5225, 0.3220}, 1 },
                    { {0.5225, 0.3720}, 1 },
                    { {0.4775, 0.3720}, 1 },
                }, {
                    //Gun Tip
                    {{0.507, 0.236}, 1}, 
                    {{0.492, 0.236}, 1}, 
                    {{0.492, 0.254}, 1}, 
                    {{0.507, 0.254}, 1},
                }, {
                    //Gun Barrel
                    {{0.505, 0.254}, 1}, 
                    {{0.495, 0.254}, 1}, 
                    {{0.495, 0.312}, 1}, 
                    {{0.505, 0.312}, 1},
                }, {
                    //Gun Ammo Box
                    {{0.445, 0.372}, 1}, 
                    {{0.555, 0.372}, 1}, 
                    {{0.555, 0.372+0.06}, 1}, 
                    {{0.445, 0.372+0.06}, 1},
                },
            };
        };
        class Ammo {
            color[] = {0,0,0,0};
            MPD_TEXT_C(Gun_Ammo, 0.5, 0.382, MPD_TEXT_USER(MFD_TEXT_IND_WPN_GUN_ROUNDS))
        };
    };
    class Deselected {
        condition = C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN), 0), C_EQ(C_MPD_USER(MFD_IND_WPN_CANNON_FAILURE), 0)));
        MPD_TEXT_C(Ammo, 0.5, 0.382, MPD_TEXT_USER(MFD_TEXT_IND_WPN_GUN_ROUNDS))
        class Lines {
            type = line;
            width = 3;
            points[] = {
                 //Gun Tip
                {{0.507, 0.236}, 1}, {{0.492, 0.236}, 1}, {{0.492, 0.254}, 1}, {{0.507, 0.254}, 1}, {{0.507, 0.236}, 1}, {},
                //Gun Barrel
                {{0.505, 0.254}, 1}, {{0.495, 0.254}, 1}, {{0.495, 0.312}, 1}, {{0.505, 0.312}, 1}, {{0.505, 0.254}, 1}, {},
                
                //Gun Base
                MPD_POINTS_CURVED_CORNER(Null, 0.5125, 0.322, 0.01, -0.01), {},
                MPD_POINTS_CURVED_CORNER(Null, 0.4875, 0.322, -0.01, -0.01), {},
                {{0.4875, 0.312}, 1}, {{0.5125, 0.312}, 1}, {},
                {{0.5225,0.322}, 1}, {{0.5225,0.372}, 1}, {{0.4775,0.372}, 1}, {{0.4775,0.322}, 1}, {},
                //Gun Ammo Box
                {{0.445, 0.372}, 1}, {{0.555, 0.372}, 1}, {{0.555, 0.372+0.06}, 1}, {{0.445, 0.372+0.06}, 1}, {{0.445, 0.372}, 1},
            };
        };
    }; 
    class failed {
        condition =  C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_CANNON_FAILURE),1));
        color[] = {1,1,0,1};
        class Yellow_Box
        {
            type = polygon;
            points[] = {
                {
                    { {0.4775, 0.3220}, 1 },
                    { {0.4788, 0.3170}, 1 },
                    { {0.4875, 0.3220}, 1 },
                }, {
                    { {0.4788, 0.3170}, 1 },
                    { {0.4825, 0.3133}, 1 },
                    { {0.4875, 0.3220}, 1 },
                }, {
                    { {0.4825, 0.3133}, 1 },
                    { {0.4875, 0.3120}, 1 },
                    { {0.4875, 0.3220}, 1 },
                }, {
                    { {0.4875, 0.3220}, 1 },
                    { {0.4875, 0.3133}, 1 },
                    { {0.5125, 0.3133}, 1 },
                    { {0.5125, 0.3220}, 1 },
                }, {
                    { {0.5125, 0.3120}, 1 },
                    { {0.5175, 0.3133}, 1 },
                    { {0.5125, 0.3220}, 1 },
                }, {
                    { {0.5175, 0.3133}, 1 },
                    { {0.5212, 0.3170}, 1 },
                    { {0.5125, 0.3220}, 1 },
                }, {
                    { {0.5212, 0.3170}, 1 },
                    { {0.5225, 0.3220}, 1 },
                    { {0.5125, 0.3220}, 1 },
                }, {
                    { {0.4775, 0.3220}, 1 },
                    { {0.5225, 0.3220}, 1 },
                    { {0.5225, 0.3720}, 1 },
                    { {0.4775, 0.3720}, 1 },
                }, {
                    //Gun Tip
                    {{0.507, 0.236}, 1}, 
                    {{0.492, 0.236}, 1}, 
                    {{0.492, 0.254}, 1}, 
                    {{0.507, 0.254}, 1},
                }, {
                    //Gun Barrel
                    {{0.505, 0.254}, 1}, 
                    {{0.495, 0.254}, 1}, 
                    {{0.495, 0.312}, 1}, 
                    {{0.505, 0.312}, 1},
                }, {
                    //Gun Ammo Box
                    {{0.445, 0.372}, 1}, 
                    {{0.555, 0.372}, 1}, 
                    {{0.555, 0.372+0.06}, 1}, 
                    {{0.445, 0.372+0.06}, 1},
                },
            };
        };
        class Fail {
            color[] = {0,0,0,0};
            MPD_TEXT_C(Gun_FAIL, 0.5, 0.382, MPD_TEXT_STATIC("FAIL"))
        };
    };
};

// Hellfire icons
#define MFD_WPN_HF_PYLON(num, posX, posY) \
    class HellfirePylon##num { \
        class Deselected {\
            condition =  C_COND(C_NOT(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN),3)));\
            class Pylon {\
                type = pylonicon;\
                pos[] = {{posX, posY}, 1};\
                pylon = num;\
                name = fza_ah64_hellfire;\
            };\
        };\
        class Ready: Deselected {\
            condition =  C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN),3), C_NOT(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_HF),num))));\
            class Pylon : Pylon {\
                name = fza_ah64_hellfire_inverse;\
            };\
        };\
        class Selected : Deselected {\
            condition =  C_COND(C_AND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN),3), C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_HF),num)));\
            class Pylon : Pylon {\
                name = fza_ah64_hellfire_selected;\
            };\
            class White {\
                color[] = {1,1,1,1};\
                MPD_TEXT_C(Line1, posX, posY+0.07-2*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_MSL_IMAGE_LINE_1))\
                MPD_TEXT_C(Line2, posX, posY+0.063-MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_MSL_IMAGE_LINE_2))\
            };\
        };\
    };
MFD_WPN_HF_PYLON(1, 0.245, 0.43)
MFD_WPN_HF_PYLON(2, 0.29, 0.43)
MFD_WPN_HF_PYLON(3, 0.245, 0.565)
MFD_WPN_HF_PYLON(4, 0.29, 0.565)

MFD_WPN_HF_PYLON(5, 0.345, 0.43)
MFD_WPN_HF_PYLON(6, 0.39, 0.43)
MFD_WPN_HF_PYLON(7, 0.345, 0.565)
MFD_WPN_HF_PYLON(8, 0.39, 0.565)

MFD_WPN_HF_PYLON(9, 0.61, 0.43)
MFD_WPN_HF_PYLON(10, 0.655, 0.43)
MFD_WPN_HF_PYLON(11, 0.61, 0.565)
MFD_WPN_HF_PYLON(12, 0.655, 0.565)

MFD_WPN_HF_PYLON(13, 0.71, 0.43)
MFD_WPN_HF_PYLON(14, 0.755, 0.43)
MFD_WPN_HF_PYLON(15, 0.71, 0.565)
MFD_WPN_HF_PYLON(16, 0.755, 0.565)

// Rocket Pylons

#define MFD_WPN_ROCKET_PYLON(num, posX, posY, selectState1, selectState2, presentIndex, presentState1, presentState2, textInd) \
    class RocketPylon##num { \
        MPD_TEXT_C(Name,posX, posY-MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(""))\
        class Present {\
            condition =  C_COND(C_OR(C_EQ(C_MPD_USER(presentIndex),presentState1), C_EQ(C_MPD_USER(presentIndex),presentState2)));\
            class Deselected {\
                condition =  C_COND(C_NOT(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN),2)));\
                class Pylon {\
                    type = pylonicon;\
                    pos[] = {{posX, posY}, 1};\
                    pylon = num;\
                    name = fza_ah64_rocket;\
                };\
                MPD_TEXT_C(Name,posX, posY-MPD_TEXT_HEIGHT, MPD_TEXT_USER(textInd))\
            };\
            class Selected {\
                condition =  C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN),2));\
                class Pylon {\
                    type = pylonicon;\
                    pos[] = {{posX, posY}, 1};\
                    pylon = num;\
                    name = fza_ah64_rocket_inverse;\
                };\
                class Black {\
                    color[] = {0,0,0,1};\
                    MPD_TEXT_C(Name,posX, posY-MPD_TEXT_HEIGHT, MPD_TEXT_USER(textInd))\
                }\
            };\
        };\
    };
MFD_WPN_ROCKET_PYLON(1, 0.267, 0.5, 1, 3, MFD_IND_WPN_ROCKET_POD_1_4_STATE, 1, 3, MFD_TEXT_IND_WPN_ROCKET_POD_1_4_TEXT)
MFD_WPN_ROCKET_PYLON(5, 0.367, 0.5, 2, 3, MFD_IND_WPN_ROCKET_POD_2_3_STATE, 1, 3, MFD_TEXT_IND_WPN_ROCKET_POD_2_3_TEXT)
MFD_WPN_ROCKET_PYLON(9, 0.633, 0.5, 2, 3, MFD_IND_WPN_ROCKET_POD_2_3_STATE, 2, 3, MFD_TEXT_IND_WPN_ROCKET_POD_2_3_TEXT)
MFD_WPN_ROCKET_PYLON(13, 0.733, 0.5, 1, 3, MFD_IND_WPN_ROCKET_POD_1_4_STATE, 2, 3, MFD_TEXT_IND_WPN_ROCKET_POD_1_4_TEXT)

#define MFD_WPN_FAILED_PYLON(num, posX, posY, presentIndex, presentState1, presentState2) \
    class FailedPylon##num { \
        condition = C_COND(C_OR(C_EQ(C_MPD_USER(presentIndex),presentState1), C_EQ(C_MPD_USER(presentIndex),presentState2)));\
        color[] = {1,1,0,1};\
        class outline {\
            type = line;\
            width = 2;\
            points[] = {\
                {{-0.045 + posX, 0.14 + posY}, 1},\
                {{-0.045 + posX, -0.14 + posY}, 1},\
                {{0.045 + posX, -0.14 + posY}, 1},\
                {{0.045 + posX, 0.14 + posY}, 1},\
                {{-0.045 + posX, 0.14 + posY}, 1}\
            };\
        };\
        class box {\
            type = polygon;\
            points[] = {{\
                {{-0.045 + posX, 0.14 + posY}, 1},\
                {{0.045 + posX, 0.14 + posY}, 1},\
                {{0.045 + posX, 0.18 + posY}, 1},\
                {{-0.045 + posX, 0.18 + posY}, 1},\
            }};\
        };\
        class text {\
            color[] = {0,0,0,0};\
            MPD_TEXT_C(Name,posX, posY + 0.14, MPD_TEXT_STATIC("FAIL"))\
        };\
    };

MFD_WPN_FAILED_PYLON(1, 0.267, 0.5, MFD_IND_WPN_PYLON_1_4_FAILURE, 1, 3)
MFD_WPN_FAILED_PYLON(2, 0.367, 0.5, MFD_IND_WPN_PYLON_2_3_FAILURE, 1, 3)
MFD_WPN_FAILED_PYLON(3, 0.633, 0.5, MFD_IND_WPN_PYLON_2_3_FAILURE, 2, 3)
MFD_WPN_FAILED_PYLON(4, 0.733, 0.5, MFD_IND_WPN_PYLON_1_4_FAILURE, 2, 3)