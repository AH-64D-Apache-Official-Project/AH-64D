#include "\fza_ah64_controls\headers\systemConstants.h"
    
//FMC
#define FMC_X    MPD_POS_BUTTON_L_X + 0.1*MPD_TEXT_WIDTH
#define PITCH_Y  MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT
#define ROLL_Y   MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT
#define YAW_Y    MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT
#define COLL_Y   MPD_POS_BUTTON_LR_4_Y + 0.5*MPD_TEXT_HEIGHT
#define TRIM_Y   MPD_POS_BUTTON_LR_5_Y + 0.5*MPD_TEXT_HEIGHT
#define NOEA_Y   MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT
    
//Anti-Ice
#define AICE_X   MPD_POS_BUTTON_R_X - 0.1*MPD_TEXT_WIDTH
#define PITOT_Y  MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT
#define INLET_Y  MPD_POS_BUTTON_LR_2_Y + 0.5*MPD_TEXT_HEIGHT
#define CANOPY_Y MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT
#define SENSOR_Y MPD_POS_BUTTON_LR_4_Y + 0.5*MPD_TEXT_HEIGHT

//FMC Pitch
class pitch_Off {
    class lines_pitchOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{FMC_X - 0.010, PITCH_Y + 0.000}, 1},
            {{FMC_X - 0.007, PITCH_Y - 0.007}, 1},
            {{FMC_X - 0.000, PITCH_Y - 0.010}, 1},
            {{FMC_X + 0.007, PITCH_Y - 0.007}, 1},
            {{FMC_X + 0.010, PITCH_Y + 0.000}, 1},
            {{FMC_X + 0.007, PITCH_Y + 0.007}, 1},
            {{FMC_X + 0.000, PITCH_Y + 0.010}, 1},
            {{FMC_X - 0.007, PITCH_Y + 0.007}, 1}, 
            {{FMC_X - 0.010, PITCH_Y + 0.000}, 1},
        };
    };
};
class pitch_On {
    condition = C_COND(C_MPD_USER(ACUTIL_IND_PITCH));
    class pitch_draw {
        class polys_pitchOnOff {
            class Polygons {
                type = polygon;
                points[] = {
                    { //Top left
                        {{FMC_X - 0.010, PITCH_Y + 0.000}, 1},
                        {{FMC_X - 0.007, PITCH_Y - 0.007}, 1},
                        {{FMC_X - 0.000, PITCH_Y - 0.010}, 1},
                        {{FMC_X, PITCH_Y}, 1}
                    },
                    { //Top right
                        {{FMC_X - 0.000, PITCH_Y - 0.010}, 1},
                        {{FMC_X + 0.007, PITCH_Y - 0.007}, 1},
                        {{FMC_X + 0.010, PITCH_Y + 0.000}, 1},
                        {{FMC_X, PITCH_Y}, 1}
                    },
                    { //Bottom right
                        {{FMC_X + 0.010, PITCH_Y + 0.000}, 1},
                        {{FMC_X + 0.007, PITCH_Y + 0.007}, 1}, 
                        {{FMC_X + 0.000, PITCH_Y + 0.010}, 1},
                        {{FMC_X, PITCH_Y}, 1}
                    },
                    { //Bottom left
                        {{FMC_X + 0.000, PITCH_Y + 0.010}, 1},
                        {{FMC_X - 0.007, PITCH_Y + 0.007}, 1}, 
                        {{FMC_X - 0.010, PITCH_Y + 0.000}, 1},
                        {{FMC_X, PITCH_Y}, 1}
                    }
                };
            };
        };
    };
};//End FMC Pitch

//FMC Roll
class roll_Off {
    class lines_rollOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{FMC_X - 0.010, ROLL_Y + 0.000}, 1},
            {{FMC_X - 0.007, ROLL_Y - 0.007}, 1},
            {{FMC_X - 0.000, ROLL_Y - 0.010}, 1},
            {{FMC_X + 0.007, ROLL_Y - 0.007}, 1},
            {{FMC_X + 0.010, ROLL_Y + 0.000}, 1},
            {{FMC_X + 0.007, ROLL_Y + 0.007}, 1},
            {{FMC_X + 0.000, ROLL_Y + 0.010}, 1},
            {{FMC_X - 0.007, ROLL_Y + 0.007}, 1}, 
            {{FMC_X - 0.010, ROLL_Y + 0.000}, 1},
        };
    };
};
class roll_On {
    condition = C_COND(C_MPD_USER(ACUTIL_IND_ROLL));
    class roll_draw {
        class polys_rollOnOff {
            class Polygons {
                type = polygon;
                points[] = {
                    { //Top left
                        {{FMC_X - 0.010, ROLL_Y + 0.000}, 1},
                        {{FMC_X - 0.007, ROLL_Y - 0.007}, 1},
                        {{FMC_X - 0.000, ROLL_Y - 0.010}, 1},
                        {{FMC_X, ROLL_Y}, 1}
                    },
                    { //Top right
                        {{FMC_X - 0.000, ROLL_Y - 0.010}, 1},
                        {{FMC_X + 0.007, ROLL_Y - 0.007}, 1},
                        {{FMC_X + 0.010, ROLL_Y + 0.000}, 1},
                        {{FMC_X, ROLL_Y}, 1}
                    },
                    { //Bottom right
                        {{FMC_X + 0.010, ROLL_Y + 0.000}, 1},
                        {{FMC_X + 0.007, ROLL_Y + 0.007}, 1}, 
                        {{FMC_X + 0.000, ROLL_Y + 0.010}, 1},
                        {{FMC_X, ROLL_Y}, 1}
                    },
                    { //Bottom left
                        {{FMC_X + 0.000, ROLL_Y + 0.010}, 1},
                        {{FMC_X - 0.007, ROLL_Y + 0.007}, 1}, 
                        {{FMC_X - 0.010, ROLL_Y + 0.000}, 1},
                        {{FMC_X, ROLL_Y}, 1}
                    }
                };
            };
        };
    };
}; //End FMC Roll 

//FMC Yaw
class yaw_Off {
    class lines_yawOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{FMC_X - 0.010, YAW_Y + 0.000}, 1},
            {{FMC_X - 0.007, YAW_Y - 0.007}, 1},
            {{FMC_X - 0.000, YAW_Y - 0.010}, 1},
            {{FMC_X + 0.007, YAW_Y - 0.007}, 1},
            {{FMC_X + 0.010, YAW_Y + 0.000}, 1},
            {{FMC_X + 0.007, YAW_Y + 0.007}, 1},
            {{FMC_X + 0.000, YAW_Y + 0.010}, 1},
            {{FMC_X - 0.007, YAW_Y + 0.007}, 1}, 
            {{FMC_X - 0.010, YAW_Y + 0.000}, 1},
        };
    };
};
class yaw_On {
    condition = C_COND(C_MPD_USER(ACUTIL_IND_YAW));
    class yaw_draw {
        class polys_yawOnOff {
            class Polygons {
                type = polygon;
                points[] = {
                    { //Top left
                        {{FMC_X - 0.010, YAW_Y + 0.000}, 1},
                        {{FMC_X - 0.007, YAW_Y - 0.007}, 1},
                        {{FMC_X - 0.000, YAW_Y - 0.010}, 1},
                        {{FMC_X, YAW_Y}, 1}
                    },
                    { //Top right
                        {{FMC_X - 0.000, YAW_Y - 0.010}, 1},
                        {{FMC_X + 0.007, YAW_Y - 0.007}, 1},
                        {{FMC_X + 0.010, YAW_Y + 0.000}, 1},
                        {{FMC_X, YAW_Y}, 1}
                    },
                    { //Bottom right
                        {{FMC_X + 0.010, YAW_Y + 0.000}, 1},
                        {{FMC_X + 0.007, YAW_Y + 0.007}, 1}, 
                        {{FMC_X + 0.000, YAW_Y + 0.010}, 1},
                        {{FMC_X, YAW_Y}, 1}
                    },
                    { //Bottom left
                        {{FMC_X + 0.000, YAW_Y + 0.010}, 1},
                        {{FMC_X - 0.007, YAW_Y + 0.007}, 1}, 
                        {{FMC_X - 0.010, YAW_Y + 0.000}, 1},
                        {{FMC_X, YAW_Y}, 1}
                    }
                };
            };
        };
    };
};//End FMC Yaw

//FMC Coll
class coll_Off {
    class lines_collOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{FMC_X - 0.010, COLL_Y + 0.000}, 1},
            {{FMC_X - 0.007, COLL_Y - 0.007}, 1},
            {{FMC_X - 0.000, COLL_Y - 0.010}, 1},
            {{FMC_X + 0.007, COLL_Y - 0.007}, 1},
            {{FMC_X + 0.010, COLL_Y + 0.000}, 1},
            {{FMC_X + 0.007, COLL_Y + 0.007}, 1},
            {{FMC_X + 0.000, COLL_Y + 0.010}, 1},
            {{FMC_X - 0.007, COLL_Y + 0.007}, 1}, 
            {{FMC_X - 0.010, COLL_Y + 0.000}, 1},
        };
    };
};
class coll_On {
    condition = C_COND(C_MPD_USER(ACUTIL_IND_COLL));
    class coll_draw {
        class polys_collOnOff {
            class Polygons {
                type = polygon;
                points[] = {
                    { //Top left
                        {{FMC_X - 0.010, COLL_Y + 0.000}, 1},
                        {{FMC_X - 0.007, COLL_Y - 0.007}, 1},
                        {{FMC_X - 0.000, COLL_Y - 0.010}, 1},
                        {{FMC_X, COLL_Y}, 1}
                    },
                    { //Top right
                        {{FMC_X - 0.000, COLL_Y - 0.010}, 1},
                        {{FMC_X + 0.007, COLL_Y - 0.007}, 1},
                        {{FMC_X + 0.010, COLL_Y + 0.000}, 1},
                        {{FMC_X, COLL_Y}, 1}
                    },
                    { //Bottom right
                        {{FMC_X + 0.010, COLL_Y + 0.000}, 1},
                        {{FMC_X + 0.007, COLL_Y + 0.007}, 1}, 
                        {{FMC_X + 0.000, COLL_Y + 0.010}, 1},
                        {{FMC_X, COLL_Y}, 1}
                    },
                    { //Bottom left
                        {{FMC_X + 0.000, COLL_Y + 0.010}, 1},
                        {{FMC_X - 0.007, COLL_Y + 0.007}, 1}, 
                        {{FMC_X - 0.010, COLL_Y + 0.000}, 1},
                        {{FMC_X, COLL_Y}, 1}
                    }
                };
            };
        };
    };
};//End FMC Coll

//FMC Trim
class trim_Off {
    class lines_trimOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{FMC_X - 0.010, TRIM_Y + 0.000}, 1},
            {{FMC_X - 0.007, TRIM_Y - 0.007}, 1},
            {{FMC_X - 0.000, TRIM_Y - 0.010}, 1},
            {{FMC_X + 0.007, TRIM_Y - 0.007}, 1},
            {{FMC_X + 0.010, TRIM_Y + 0.000}, 1},
            {{FMC_X + 0.007, TRIM_Y + 0.007}, 1},
            {{FMC_X + 0.000, TRIM_Y + 0.010}, 1},
            {{FMC_X - 0.007, TRIM_Y + 0.007}, 1}, 
            {{FMC_X - 0.010, TRIM_Y + 0.000}, 1},
        };
    };
};
class trim_On {
    condition = C_COND(C_MPD_USER(ACUTIL_IND_TRIM));
    class trim_draw {
        class polys_trimOnOff {
            class Polygons {
                type = polygon;
                points[] = {
                    { //Top left
                        {{FMC_X - 0.010, TRIM_Y + 0.000}, 1},
                        {{FMC_X - 0.007, TRIM_Y - 0.007}, 1},
                        {{FMC_X - 0.000, TRIM_Y - 0.010}, 1},
                        {{FMC_X, TRIM_Y}, 1}
                    },
                    { //Top right
                        {{FMC_X - 0.000, TRIM_Y - 0.010}, 1},
                        {{FMC_X + 0.007, TRIM_Y - 0.007}, 1},
                        {{FMC_X + 0.010, TRIM_Y + 0.000}, 1},
                        {{FMC_X, TRIM_Y}, 1}
                    },
                    { //Bottom right
                        {{FMC_X + 0.010, TRIM_Y + 0.000}, 1},
                        {{FMC_X + 0.007, TRIM_Y + 0.007}, 1}, 
                        {{FMC_X + 0.000, TRIM_Y + 0.010}, 1},
                        {{FMC_X, TRIM_Y}, 1}
                    },
                    { //Bottom left
                        {{FMC_X + 0.000, TRIM_Y + 0.010}, 1},
                        {{FMC_X - 0.007, TRIM_Y + 0.007}, 1}, 
                        {{FMC_X - 0.010, TRIM_Y + 0.000}, 1},
                        {{FMC_X, TRIM_Y}, 1}
                    }
                };
            };
        };
    };
};//End FMC Trim

//FMC NOE/A
class noea_Off {
    class lines_noeaOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{FMC_X - 0.010, NOEA_Y + 0.000}, 1},
            {{FMC_X - 0.007, NOEA_Y - 0.007}, 1},
            {{FMC_X - 0.000, NOEA_Y - 0.010}, 1},
            {{FMC_X + 0.007, NOEA_Y - 0.007}, 1},
            {{FMC_X + 0.010, NOEA_Y + 0.000}, 1},
            {{FMC_X + 0.007, NOEA_Y + 0.007}, 1},
            {{FMC_X + 0.000, NOEA_Y + 0.010}, 1},
            {{FMC_X - 0.007, NOEA_Y + 0.007}, 1}, 
            {{FMC_X - 0.010, NOEA_Y + 0.000}, 1},
        };
    };
};//End FMC NOE/A

class vabs {
    //T2
    MPD_ARROW_C(FLT,     MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
    MPD_TEXT_C(FLT,      MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FLT"))
    //T3
    MPD_ARROW_C(FUEL,    MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, 4)
    MPD_TEXT_C(FUEL,     MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("FUEL"))
    //T4
    MPD_ARROW_C(PERF,    MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, 4)
    MPD_TEXT_C(PERF,     MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("PERF"))
    //T6
    MPD_BOX_TALL_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
    MPD_ARROW_C(UTIL,    MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
    MPD_TEXT_C(UTIL,     MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))

    //R1
    MPD_TEXT_L(SYS,    MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SYSTEM"))
    MPD_BOX_L(MAN,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5 * MPD_TEXT_HEIGHT, 6)
    MPD_BOX_BAR_L(MAN, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y)
    MPD_TEXT_L(MAN,    MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MANUAL"))
    //R3
    MPD_TEXT_L(PIT, MPD_POS_BUTTON_R_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("PITOT"))
    //R4
    MPD_TEXT_L(INL, MPD_POS_BUTTON_R_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("INLET"))
    //R5
    MPD_TEXT_L(CAN, MPD_POS_BUTTON_R_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("CANOPY"))
    //R6
    MPD_BOX_BAR_L(SNS, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y)
    MPD_TEXT_L(SNS, MPD_POS_BUTTON_R_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("SENSOR"))

    //L1
    MPD_TEXT_R(PITCH, MPD_POS_BUTTON_L_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_STATIC("PITCH"))
    //L1
    MPD_TEXT_R(ROLL,  MPD_POS_BUTTON_L_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("ROLL"))
    //L1
    MPD_TEXT_R(YAW,   MPD_POS_BUTTON_L_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("YAW"))
    //L1
    MPD_TEXT_R(COLL,  MPD_POS_BUTTON_L_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("COLL"))
    //L1
    MPD_TEXT_R(TRIM,  MPD_POS_BUTTON_L_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("TRIM"))
    //L1
    MPD_BOX_BAR_R(NOEA, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y)
    MPD_TEXT_R(NOEA,  MPD_POS_BUTTON_L_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("NOE/A"))
};