#include "\fza_ah64_controls\headers\systemConstants.h"

class fmc_lines {
    type = line;
    width = 3;
    points[] =
        { {{0.015, 0.15}, 1} //Top 
        , {{0.17 , 0.15}, 1}
        , {{0.17 , 0.42}, 1}
        , {}
        , {{0.17 , 0.58}, 1} //Bottom
        , {{0.17 , 0.88}, 1}
        , {{0.015, 0.88}, 1}
        };
};

class aice_lines {
    type = line;
    width = 3;
    points[] =
        { {{0.985, 0.150}, 1} //Top 
        , {{0.80 , 0.150}, 1}
        , {{0.80 , 0.335}, 1}
        , {}
        , {{0.80 , 0.715}, 1} //Bottom
        , {{0.80 , 0.880}, 1}
        , {{0.985, 0.880}, 1}
        };
};

class bleedAir_lines {
    type = line;
    width = 3;
    points[] =
        { {{0.27, 0.985}, 1} //Left 
        , {{0.27, 0.920}, 1}
        , {{0.29, 0.920}, 1}
        , {}
        , {{0.49, 0.920}, 1} //Right
        , {{0.51, 0.920}, 1}
        , {{0.51, 0.985}, 1}
        };
};

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
#define PITOT_Y  MPD_POS_BUTTON_LR_3_Y + 0.5*MPD_TEXT_HEIGHT
#define INLET_Y  MPD_POS_BUTTON_LR_4_Y + 0.5*MPD_TEXT_HEIGHT
#define CANOPY_Y MPD_POS_BUTTON_LR_5_Y + 0.5*MPD_TEXT_HEIGHT
#define SENSOR_Y MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT

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
    condition = C_COND(C_MPD_USER(MFD_IND_ACUTIL_PITCH));
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
    condition = C_COND(C_MPD_USER(MFD_IND_ACUTIL_ROLL));
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
    condition = C_COND(C_MPD_USER(MFD_IND_ACUTIL_YAW));
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
    condition = C_COND(C_MPD_USER(MFD_IND_ACUTIL_COLL));
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
    condition = C_COND(C_MPD_USER(MFD_IND_ACUTIL_TRIM));
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

//Anti-Ice Pitot
class pitot_Off {
    class lines_pitotOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{AICE_X - 0.010, PITOT_Y + 0.000}, 1},
            {{AICE_X - 0.007, PITOT_Y - 0.007}, 1},
            {{AICE_X - 0.000, PITOT_Y - 0.010}, 1},
            {{AICE_X + 0.007, PITOT_Y - 0.007}, 1},
            {{AICE_X + 0.010, PITOT_Y + 0.000}, 1},
            {{AICE_X + 0.007, PITOT_Y + 0.007}, 1},
            {{AICE_X + 0.000, PITOT_Y + 0.010}, 1},
            {{AICE_X - 0.007, PITOT_Y + 0.007}, 1}, 
            {{AICE_X - 0.010, PITOT_Y + 0.000}, 1},
        };
    };
};//End Anti-Ice Pitot

//Anti-Ice Inlet
class inlet_Off {
    class lines_inletOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{AICE_X - 0.010, INLET_Y + 0.000}, 1},
            {{AICE_X - 0.007, INLET_Y - 0.007}, 1},
            {{AICE_X - 0.000, INLET_Y - 0.010}, 1},
            {{AICE_X + 0.007, INLET_Y - 0.007}, 1},
            {{AICE_X + 0.010, INLET_Y + 0.000}, 1},
            {{AICE_X + 0.007, INLET_Y + 0.007}, 1},
            {{AICE_X + 0.000, INLET_Y + 0.010}, 1},
            {{AICE_X - 0.007, INLET_Y + 0.007}, 1}, 
            {{AICE_X - 0.010, INLET_Y + 0.000}, 1},
        };
    };
};//End Anti-Ice Inlet

//Anti-Ice Canopy
class canopy_Off {
    class lines_inletOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{AICE_X - 0.010, CANOPY_Y + 0.000}, 1},
            {{AICE_X - 0.007, CANOPY_Y - 0.007}, 1},
            {{AICE_X - 0.000, CANOPY_Y - 0.010}, 1},
            {{AICE_X + 0.007, CANOPY_Y - 0.007}, 1},
            {{AICE_X + 0.010, CANOPY_Y + 0.000}, 1},
            {{AICE_X + 0.007, CANOPY_Y + 0.007}, 1},
            {{AICE_X + 0.000, CANOPY_Y + 0.010}, 1},
            {{AICE_X - 0.007, CANOPY_Y + 0.007}, 1}, 
            {{AICE_X - 0.010, CANOPY_Y + 0.000}, 1},
        };
    };
};//End Anti-Ice Canopy

//Anti-Ice Sensor
class sensor_Off {
    class lines_sensorOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{AICE_X - 0.010, SENSOR_Y + 0.000}, 1},
            {{AICE_X - 0.007, SENSOR_Y - 0.007}, 1},
            {{AICE_X - 0.000, SENSOR_Y - 0.010}, 1},
            {{AICE_X + 0.007, SENSOR_Y - 0.007}, 1},
            {{AICE_X + 0.010, SENSOR_Y + 0.000}, 1},
            {{AICE_X + 0.007, SENSOR_Y + 0.007}, 1},
            {{AICE_X + 0.000, SENSOR_Y + 0.010}, 1},
            {{AICE_X - 0.007, SENSOR_Y + 0.007}, 1}, 
            {{AICE_X - 0.010, SENSOR_Y + 0.000}, 1},
        };
    };
};//End Anti-Ice Sensor

//Bleed Air 1
#define BLEED1_X MPD_POS_BUTTON_TB_2_X - 0.60 * MPD_TEXT_WIDTH
#define BUBBLE_Y MPD_POS_BUTTON_B_Y + 0.5 * MPD_TEXT_HEIGHT
class bleedAir1_On {
    class bleedAir1_draw {
        class polys_bleedAir1OnOff {
            class Polygons {
                type = polygon;
                points[] = {
                    { //Top left
                        {{BLEED1_X - 0.010, BUBBLE_Y + 0.000}, 1},
                        {{BLEED1_X - 0.007, BUBBLE_Y - 0.007}, 1},
                        {{BLEED1_X - 0.000, BUBBLE_Y - 0.010}, 1},
                        {{BLEED1_X, BUBBLE_Y}, 1}
                    },
                    { //Top right
                        {{BLEED1_X - 0.000, BUBBLE_Y - 0.010}, 1},
                        {{BLEED1_X + 0.007, BUBBLE_Y - 0.007}, 1},
                        {{BLEED1_X + 0.010, BUBBLE_Y + 0.000}, 1},
                        {{BLEED1_X, BUBBLE_Y}, 1}
                    },
                    { //Bottom right
                        {{BLEED1_X + 0.010, BUBBLE_Y + 0.000}, 1},
                        {{BLEED1_X + 0.007, BUBBLE_Y + 0.007}, 1}, 
                        {{BLEED1_X + 0.000, BUBBLE_Y + 0.010}, 1},
                        {{BLEED1_X, BUBBLE_Y}, 1}
                    },
                    { //Bottom left
                        {{BLEED1_X + 0.000, BUBBLE_Y + 0.010}, 1},
                        {{BLEED1_X - 0.007, BUBBLE_Y + 0.007}, 1}, 
                        {{BLEED1_X - 0.010, BUBBLE_Y + 0.000}, 1},
                        {{BLEED1_X, BUBBLE_Y}, 1}
                    }
                };
            };
        };
    };
};  //End Bleed Air 1

//Bleed Air 2
#define BLEED2_X  MPD_POS_BUTTON_TB_3_X - 0.60 * MPD_TEXT_WIDTH
class bleedAir2_On {
    class bleedAir2_draw {
        class polys_bleedAir2OnOff {
            class Polygons {
                type = polygon;
                points[] = {
                    { //Top left
                        {{BLEED2_X - 0.010, BUBBLE_Y + 0.000}, 1},
                        {{BLEED2_X - 0.007, BUBBLE_Y - 0.007}, 1},
                        {{BLEED2_X - 0.000, BUBBLE_Y - 0.010}, 1},
                        {{BLEED2_X, BUBBLE_Y}, 1}
                    },
                    { //Top right
                        {{BLEED2_X - 0.000, BUBBLE_Y - 0.010}, 1},
                        {{BLEED2_X + 0.007, BUBBLE_Y - 0.007}, 1},
                        {{BLEED2_X + 0.010, BUBBLE_Y + 0.000}, 1},
                        {{BLEED2_X, BUBBLE_Y}, 1}
                    },
                    { //Bottom right
                        {{BLEED2_X + 0.010, BUBBLE_Y + 0.000}, 1},
                        {{BLEED2_X + 0.007, BUBBLE_Y + 0.007}, 1}, 
                        {{BLEED2_X + 0.000, BUBBLE_Y + 0.010}, 1},
                        {{BLEED2_X, BUBBLE_Y}, 1}
                    },
                    { //Bottom left
                        {{BLEED2_X + 0.000, BUBBLE_Y + 0.010}, 1},
                        {{BLEED2_X - 0.007, BUBBLE_Y + 0.007}, 1}, 
                        {{BLEED2_X - 0.010, BUBBLE_Y + 0.000}, 1},
                        {{BLEED2_X, BUBBLE_Y}, 1}
                    }
                };
            };
        };
    };
};  //End Bleed Air 2

//ECS
#define ECS_X  MPD_POS_BUTTON_TB_5_X - 1.1 * MPD_TEXT_WIDTH
class ecs_On {
    class ecs_draw {
        class polys_ecsOnOff {
            class Polygons {
                type = polygon;
                points[] = {
                    { //Top left
                        {{ECS_X - 0.010, BUBBLE_Y + 0.000}, 1},
                        {{ECS_X - 0.007, BUBBLE_Y - 0.007}, 1},
                        {{ECS_X - 0.000, BUBBLE_Y - 0.010}, 1},
                        {{ECS_X, BUBBLE_Y}, 1}
                    },
                    { //Top right
                        {{ECS_X - 0.000, BUBBLE_Y - 0.010}, 1},
                        {{ECS_X + 0.007, BUBBLE_Y - 0.007}, 1},
                        {{ECS_X + 0.010, BUBBLE_Y + 0.000}, 1},
                        {{ECS_X, BUBBLE_Y}, 1}
                    },
                    { //Bottom right
                        {{ECS_X + 0.010, BUBBLE_Y + 0.000}, 1},
                        {{ECS_X + 0.007, BUBBLE_Y + 0.007}, 1}, 
                        {{ECS_X + 0.000, BUBBLE_Y + 0.010}, 1},
                        {{ECS_X, BUBBLE_Y}, 1}
                    },
                    { //Bottom left
                        {{ECS_X + 0.000, BUBBLE_Y + 0.010}, 1},
                        {{ECS_X - 0.007, BUBBLE_Y + 0.007}, 1}, 
                        {{ECS_X - 0.010, BUBBLE_Y + 0.000}, 1},
                        {{ECS_X, BUBBLE_Y}, 1}
                    }
                };
            };
        };
    };
};  //End ECS

//Ground override
#define GROUND_X  MPD_POS_BUTTON_TB_6_X - 1.1 * MPD_TEXT_WIDTH
class ground_Off {
    class lines_groundOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{GROUND_X - 0.010, BUBBLE_Y + 0.000}, 1},
            {{GROUND_X - 0.007, BUBBLE_Y - 0.007}, 1},
            {{GROUND_X - 0.000, BUBBLE_Y - 0.010}, 1},
            {{GROUND_X + 0.007, BUBBLE_Y - 0.007}, 1},
            {{GROUND_X + 0.010, BUBBLE_Y + 0.000}, 1},
            {{GROUND_X + 0.007, BUBBLE_Y + 0.007}, 1},
            {{GROUND_X + 0.000, BUBBLE_Y + 0.010}, 1},
            {{GROUND_X - 0.007, BUBBLE_Y + 0.007}, 1}, 
            {{GROUND_X - 0.010, BUBBLE_Y + 0.000}, 1},
        };
    };
};//End ground override

class fat_box_outline {
    type = line;
    width = 3;
    points[] = {
        MPD_POINTS_BOX(Null, 0.5 - 0.5*(5*MPD_TEXT_WIDTH), 0.25 - 0.5*MPD_TEXT_HEIGHT, 5.0*MPD_TEXT_WIDTH, 2.0*MPD_TEXT_HEIGHT), {},
    };
};

class ice_box_outline {
    type = line;
    width = 3;
    points[] = {
        MPD_POINTS_BOX(Null, 0.5 - 0.5*(6*MPD_TEXT_WIDTH), 0.425 - 0.5*MPD_TEXT_HEIGHT, 6.0*MPD_TEXT_WIDTH, 2.0*MPD_TEXT_HEIGHT), {},
    };
};

class cpt_box_outline {
    type = line;
    width = 3;
    points[] = {
        MPD_POINTS_BOX(Null, 0.5 - 0.5*(13*MPD_TEXT_WIDTH), 0.60 - 0.5*MPD_TEXT_HEIGHT, 13.0*MPD_TEXT_WIDTH, 2.0*MPD_TEXT_HEIGHT), {},
    };
};

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
    MPD_BOX_BAR_L(PIT, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y)
    MPD_TEXT_L(PIT, MPD_POS_BUTTON_R_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("PITOT"))
    //R4
    MPD_BOX_BAR_L(INL, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
    MPD_TEXT_L(INL, MPD_POS_BUTTON_R_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("INLET"))
    //R5
    MPD_BOX_BAR_L(CAN, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y)
    MPD_TEXT_L(CAN, MPD_POS_BUTTON_R_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("CANOPY"))
    //R6
    MPD_BOX_BAR_L(SNS, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y)
    MPD_TEXT_L(SNS, MPD_POS_BUTTON_R_X - MPD_TEXT_WIDTH, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("SENSOR"))

    //B1
    MPD_TEXT_C(ENG, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ENG"))
    //B2
    MPD_BOX_BAR_B(ONE, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y)
    MPD_TEXT_C(ONE, MPD_POS_BUTTON_TB_2_X + 0.5 * MPD_TEXT_WIDTH, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("1"))
    //B3 
    MPD_BOX_BAR_B(TWO, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_B_Y)
    MPD_TEXT_C(TWO, MPD_POS_BUTTON_TB_3_X + 0.5 * MPD_TEXT_WIDTH, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("2"))    
    //B4
    MPD_BOX_BAR_B(TEMP, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y)
    MPD_TEXT_C(TEMP1, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("TEMP>"))
    MPD_TEXT_C(TEMP2, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("69°C"))
    //B5
    MPD_BOX_BAR_B(ECS, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y)
    MPD_TEXT_C(ECS, MPD_POS_BUTTON_TB_5_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ECS"))
    //B6
    MPD_BOX_BAR_B(GND, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y)
    MPD_TEXT_C(GND, MPD_POS_BUTTON_TB_6_X + MPD_TEXT_WIDTH, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("GND"))

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

    //FMC Text
    MPD_TEXT_R(FMCChar1, 0.17, 0.50 - 1.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("F"))
    MPD_TEXT_R(FMCChar2, 0.17, 0.50 - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))
    MPD_TEXT_R(FMCChar3, 0.17, 0.50 + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("C"))

    //Bleed Air Text
    MPD_TEXT_C(BLEED, 0.39, 0.925 - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("BLEED AIR"))

    //Anti-Ice Text
    MPD_TEXT_L(AIceChar1, 0.80, 0.50 - 3.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
    MPD_TEXT_L(AIceChar2, 0.80, 0.50 - 2.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("N"))
    MPD_TEXT_L(AIceChar3, 0.80, 0.50 - 1.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
    MPD_TEXT_L(AIceChar4, 0.80, 0.50 - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("I"))
    MPD_TEXT_L(AIceChar5, 0.80, 0.50 + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(" "))
    MPD_TEXT_L(AIceChar6, 0.80, 0.50 + 1.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("I"))
    MPD_TEXT_L(AIceChar7, 0.80, 0.50 + 2.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("C"))
    MPD_TEXT_L(AIceChar8, 0.80, 0.50 + 3.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))

    //FAT box
    MPD_TEXT_C(FAT1, 0.5, 0.25 - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("FAT"))
    //This needs to be populated by the environment simulation
    MPD_TEXT_C(FAT2, 0.5, 0.25 + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("15°C"))

    //ICE box
    MPD_TEXT_C(ICE1, 0.5, 0.425 - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ICE"))
    //If i ever get around to simulating icing, this will need to be populated by the system,
    //the following are the indications: TRACE, LIGHT, MODER, SEVERE
    MPD_TEXT_C(ICE2, 0.5, 0.425 + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("      ")) 

    //Cockpit Temp Box
    MPD_TEXT_C(CPT1, 0.5, 0.60 - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PLT CKPT TEMP"))
    MPD_TEXT_C(CPT2, 0.5, 0.60 + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("69°F"))
};