#include "components\info_boxes.hpp"

class Common {
    class Occluders {
        color[] = {0,0,0,1};
        class Polygons {
            type = polygon;
            points[] = {
                MPD_TEXT_OCCLUDER_R(Null, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, 16),
                MPD_TEXT_OCCLUDER_C(Null, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 3),
                MPD_TEXT_OCCLUDER_L(Null, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y, 16),
                MPD_TEXT_OCCLUDER_L(Null, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, 11),
                MPD_TEXT_OCCLUDER_L(Null, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, 14),
                MPD_TEXT_OCCLUDER_L(Null, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, 12),
                MPD_TEXT_OCCLUDER_C(Null, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 4),
                MPD_TEXT_OCCLUDER_C(Null, MPD_POS_BUTTON_TB_3_X-0.038, MPD_POS_BUTTON_B_Y, 4),
                MPD_TEXT_OCCLUDER_L(Null, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, 11),
                MPD_TEXT_OCCLUDER_C(Null, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 4),
                MPD_TEXT_OCCLUDER_R(Null, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, 5),
                MPD_TEXT_OCCLUDER_R(Null, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, 5),
                MPD_TEXT_OCCLUDER_R(Null, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, 14)
            };
        };
    };
    //T1
    class HSIBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_HSI);
        MPD_BOX_C(HSI, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, 4)
    };
    MPD_TEXT_C(HSI, MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("HSI"))

    //R1
    class CTRLMBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_CTRLM);
        MPD_BOX_L(CTRLM,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y, 16)
    };
    MPD_TEXT_L(CTRLM, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_STATIC("CONTROL MEASURES"))
    //R2
    class ENEMYUNITBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_ENEMY_UNITS);
        MPD_BOX_L(ENEMY,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, 11)
    };
    MPD_TEXT_L(ENEMY, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("ENEMY UNITS"))
    //R3
    class FRIENDLYUNITBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_FRIENDLY_UNITS);
        MPD_BOX_L(FRIENDLY, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, 14)
    };
    MPD_TEXT_L(FRIENDLY, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("FRIENDLY UNITS"))
    //R4
    MPD_TEXT_L(RFI, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("RFI THREATS"))
    //R5
    class RLWRBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_RLWR);
        MPD_BOX_L(RLWR,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, 12)
    };    
    MPD_TEXT_L(RLWR, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("RLWR THREATS"))

    //B5
    class WINDBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_WIND);
        MPD_BOX_C(WIND,  MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, 4)
    }; 
    MPD_TEXT_C(WIND, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("WIND"))
    //B3
    class ENDRBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_ENDR);
        MPD_BOX_C(ENDR,  MPD_POS_BUTTON_TB_3_X-0.038, MPD_POS_BUTTON_B_Y, 4)
    }; 
    MPD_TEXT_C(ENDR, MPD_POS_BUTTON_TB_3_X-0.038, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ENDR"))

    //L6
    MPD_BOX_TALL_R(SHOW, MPD_POS_BUTTON_L_X,  MPD_POS_BUTTON_LR_6_Y, 4)
    MPD_ARROW_R(SHOW, MPD_POS_BUTTON_L_X,  MPD_POS_BUTTON_LR_6_Y, 4)
    MPD_TEXT_R(SHOW, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("SHOW"))
    //L5
    class PLANTGTBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_PLAN_TGTS);
        MPD_BOX_R(PLANTGT,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, 16)
    };
    MPD_TEXT_R(PLANTGT, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("PLANNED TGT/THRT"))
    //L3
    MPD_TEXT_R(LINES, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("LINES"))
    //L2
    MPD_TEXT_R(AREAS, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("AREAS"))
    //L1
    MPD_TEXT_R(INACZN, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_STATIC("INACTIVE ZONES"))
};

class AtkOnly {
    condition = __EVAL(format["user%1", MFD_IND_TSD_PHASE + MFD_OFFSET]);

    class Occluders {
        color[] = {0,0,0,1};
        class Polygons {
            type = polygon;
            points[] = {
                MPD_TEXT_OCCLUDER_C(Null, 0.5-(8 * MPD_TEXT_WIDTH), 0.12, 12),
                MPD_TEXT_OCCLUDER_L(Null, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y,20),
                MPD_TEXT_OCCLUDER_C(Null, MPD_POS_BUTTON_TB_6_X+0.01, MPD_POS_BUTTON_B_Y, 7),
                MPD_TEXT_OCCLUDER_C(Null, MPD_POS_BUTTON_TB_4_X+0.022, MPD_POS_BUTTON_B_Y, 4),
                MPD_TEXT_OCCLUDER_R(Null, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 13)
            };
        };
    };

    MPD_TEXT_C(atkPhaseLabel, 0.5, 0.12, MPD_TEXT_STATIC("ATTACK PHASE"))
    
    class Static {
        type = line;
        width = 3;
        points[] = {
            //Curved box
            MPD_POINTS_BOX(Null, 0.5-(6 * MPD_TEXT_WIDTH), 0.12, (12 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT) 
        };
    };
    
    //R6
    MPD_TEXT_L(OBST, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("TOTAL TARGETS/OBSTACLES"))

    //B6
    class HAZBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_HAZ);
        MPD_BOX_C(HAZ,  MPD_POS_BUTTON_TB_6_X+0.01, MPD_POS_BUTTON_B_Y, 7)
    }; 
    MPD_TEXT_C(HAZ, MPD_POS_BUTTON_TB_6_X+0.01, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("HAZARDS"))
    //B4
    class SHOTBox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_SHOT);
        MPD_BOX_C(SHOT,  MPD_POS_BUTTON_TB_4_X+0.022, MPD_POS_BUTTON_B_Y, 4)
    }; 
    MPD_TEXT_C(SHOT, MPD_POS_BUTTON_TB_4_X+0.022, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("SHOT"))

    //L4
    class WPTDATABox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE);
        MPD_BOX_R(WPTDATA, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 13)
    };
    MPD_TEXT_R(WPTDATA, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("CURRENT ROUTE"))
};

class NavOnly {
    condition = __EVAL(format["1 - user%1", MFD_IND_TSD_PHASE + MFD_OFFSET]);

    class Occluders {
        color[] = {0,0,0,1};
        class Polygons {
            type = polygon;
            points[] = {
                MPD_TEXT_OCCLUDER_C(Null, 0.5-(8 * MPD_TEXT_WIDTH), 0.12, 16),
                MPD_TEXT_OCCLUDER_L(Null, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y, 9),
                MPD_TEXT_OCCLUDER_R(Null, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 13)
            };
        };
    };

    MPD_TEXT_C(navPhaseLabel, 0.5, 0.12, MPD_TEXT_STATIC("NAVIGATION PHASE"))
    
    class Static {
        type = line;
        width = 3;
        points[] = {
            //Curved box
            MPD_POINTS_BOX(Null, 0.5-(8 * MPD_TEXT_WIDTH), 0.12, (16 * MPD_TEXT_WIDTH), MPD_TEXT_HEIGHT) 
        };
    };
    
    //R6
    MPD_TEXT_L(OBST, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("OBSTACLES"))
    
    //L4
    class WPTDATABox {
        condition = MPD_COND_USER(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE);
        MPD_BOX_R(WPTDATA, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 13)
    };
    MPD_TEXT_R(WPTDATA, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("WAYPOINT DATA"))
};