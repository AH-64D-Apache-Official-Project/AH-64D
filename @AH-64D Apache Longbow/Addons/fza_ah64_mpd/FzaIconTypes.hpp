#define MPD_ICON_TYPE_A 0
#define MPD_ICON_TYPE_B 1
#define MPD_ICON_TYPE_C 2
#define MPD_ICON_TYPE_D 3
#define MPD_ICON_TYPE_E 4
#define MPD_ICON_TYPE_F 5
#define MPD_ICON_TYPE_G 6
#define MPD_ICON_TYPE_H 7

#define MPD_ICON_TEXT_ID 0
#define MPD_ICON_TEXT_FREE 1

class FzaIconTypes {
//--------------------Icon Type A--------------------
//                          
//                      +---------+
//                      |         |
//               00/AAA |   TEX   |  
//                      |         |
//                      +---------+  
    //Waypoints
    class CC {                                                  //Communication check point
        tex= "\fza_ah64_mpd\tex\tsdIcons\cc.paa";
        color    = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_WP;
        iconType = MPD_ICON_TYPE_A;
        textA    = MPD_ICON_TEXT_ID;
    };
    class LZ:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\lz.paa";};  //Landing Zone
    class PP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\pp.paa";};  //Passage Point
    class RP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\rp.paa";};  //Release Point
    class SP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\sp.paa";};  //Start Point
    class WP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\wp.paa";};  //Waypoint
    //Hazards
    class TO {                                                  //Tower - Over 1000ft agl
        tex= "\fza_ah64_mpd\tex\tsdIcons\to.paa";
        color    = MPD_ICON_COLOR_YELLOW;
        type     = POINT_TYPE_HZ;
        iconType = MPD_ICON_TYPE_A;
        textA    = MPD_ICON_TEXT_ID;
    };
    class TU:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\tu.paa";};  //Tower - Under 1000ft agl
    class WL:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\wl.paa";};  //Wires - Power transmission lines
    class WS:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\ws.paa";};  //Wires - Telephon & electric
    //Control Measures
    class AA {                                                  //Assembly area
        tex= "\fza_ah64_mpd\tex\tsdIcons\aa.paa";
        color    = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_A;
        textA    = MPD_ICON_TEXT_FREE;
    };
    class BR:CC  {                                              //Bridge
        tex= "\fza_ah64_mpd\tex\tsdIcons\br.paa";
        type = POINT_TYPE_CM;
    };
    class EA:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\ea.paa";
        color    = MPD_ICON_COLOR_RED;
    };
    class EF:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\ef.paa";
        color    = MPD_ICON_COLOR_RED;
    };
    class EI:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\ei.paa";
        color    = MPD_ICON_COLOR_RED;
    };
    class EM:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\em.paa";
        color    = MPD_ICON_COLOR_RED;
    };
    class FI:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\fi.paa";
        color    = MPD_ICON_COLOR_CYAN;
    };
    class FL:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\fl.paa";
        color    = MPD_ICON_COLOR_CYAN;
    };
    class MI:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\mi.paa";
        color    = MPD_ICON_COLOR_CYAN;
    };
    //Target/Threats

//--------------------Icon Type B--------------------
//                          
//                      +---------+
//                      |         |
//                      |   AAA   |  
//                      |   TEX   |
//                      +---------+                       
    //Waypoints
    //Hazards
    //Control Measures
    class FU {                                                  //Friendly Unit
        tex= "\fza_ah64_mpd\tex\tsdIcons\fu.paa";
        color    = MPD_ICON_COLOR_CYAN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_B;
        textA    = MPD_ICON_TEXT_FREE;    
    };
    class EU:FU  {                                              //Enemy Unit
        tex= "\fza_ah64_mpd\tex\tsdIcons\eu.paa";
        color    = MPD_ICON_COLOR_RED;
    };
    //Target/Threats

//--------------------Icon Type C--------------------
//                          
//                      +---------+
//                      |         |
//                      |   TEX   |
//                      |   0 0   |
//                      +---------+
    //Waypoints
    //Hazards
    //Control Measures
    class AP  {                                                 //Air Control Point
        tex= "\fza_ah64_mpd\tex\tsdIcons\ap.paa";
        color    = MPD_ICON_COLOR_GREEN;               
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_C;
        textA    = MPD_ICON_TEXT_ID;
    };
    class BP:AP  { tex= "\fza_ah64_mpd\tex\tsdIcons\bp.paa";};  //Battle Position
    class FA:AP  { tex= "\fza_ah64_mpd\tex\tsdIcons\fa.paa";};  //Forward Assembly Area
    class HA:AP  { tex= "\fza_ah64_mpd\tex\tsdIcons\ha.paa";};  //Holding Area
    //Target/Threats

//--------------------Icon Type D--------------------
//                          AAA
//                      +---------+
//                      |         |
//                   00 |   TEX   |
//                      |         |
//                      +---------+
    //Waypoints
    //Hazards
    //Control Measures
    class FC {                                                  //FARP - Fuel and Ammo
        tex= "\fza_ah64_mpd\tex\tsdIcons\fc.paa";
        color    = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_D;
        textA    = MPD_ICON_TEXT_ID;
        textB    = MPD_ICON_TEXT_FREE;
    };
    class FF:FC  { tex= "\fza_ah64_mpd\tex\tsdIcons\ff.paa";};  //FARP - Fuel only
    class FM:FC  { tex= "\fza_ah64_mpd\tex\tsdIcons\fm.paa";};  //Farm - Ammo only
    //Target/Threats

//--------------------Icon Type E--------------------
//                          AAA
//                      +---------+
//                      |         |
//                      |   TEX   |
//                      |         |
//                      +---------+
    //Waypoints
    //Hazards
    //Control Measures
    class AG  {                                                     //Airfield - General
        tex= "\fza_ah64_mpd\tex\tsdIcons\ag.paa";
        color    = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_E;
        textA    = MPD_ICON_TEXT_FREE;
    };
    class AI:AG  { tex= "\fza_ah64_mpd\tex\tsdIcons\ai.paa";};      //Airfield - Instrumented
    class AL:AG  { tex= "\fza_ah64_mpd\tex\tsdIcons\al.paa";};      //Light Airport
    class GL:AG  { tex= "\fza_ah64_mpd\tex\tsdIcons\gl.paa";};      //Ground Light
    class IDM:AG {                                                  //IDM Subsriber
        tex= "\fza_ah64_mpd\tex\tsdIcons\idmsub.paa";
        color    = MPD_ICON_COLOR_CYAN;
    };
    //Target/Threats
 
//--------------------Icon Type F--------------------
//
//                      +---------+
//                      |         |
//                      |   TEX   | 00
//                      |         |
//                      +---------+
    //Waypoints
    //Hazards
    //Control Measures
    //Target/Threats
    class TG  {
        tex= "\fza_ah64_mpd\tex\tsdIcons\tg.paa";
        color    = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_TG;
        iconType = MPD_ICON_TYPE_F;
        textA    = MPD_ICON_TEXT_ID;
    };
    class SR:TG    { tex= "\fza_ah64_mpd\tex\tsdIcons\r.paa";};
    class TR:TG    { tex= "\fza_ah64_mpd\tex\tsdIcons\r.paa";};  

//--------------------Icon Type G--------------------
//
//                      +---------+
//                      | 0     0 |
//                      |   TEX   |
//                      |         |
//                      +---------+
    //Waypoints

    //Hazards

    //Control Measures
    
    //Target/Threats
    class GU    { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";
        color    = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_TG;
        iconType = MPD_ICON_TYPE_G;
        textA    = MPD_ICON_TEXT_ID; 
    };
    class Icon1:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";};
    class Icon2:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";};
    class Icon3:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon4:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon5:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon6:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon7:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon8:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon9:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon10:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon11:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon12:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon13:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon14:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon15:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon16:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";}; 
    class Icon17:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";};
    class S6:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";};
    class ZU:GU { tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";};
};

//--------------------Icon Type H--------------------
//
//                      +---------+
//                      |         |
//                      |   TEX   |
//                      |         |
//                      +---------+
/*
    //--------------------FCR LOAL--------------------
    //ADU
    class FCR_ADU_LOAL { 
        tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOAL.paa";
        type     = POINT_TYPE_FCR;
        iconType = MPD_ICON_TYPE_H;
    };
    class FCR_ADU_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOAL_ANTS.paa";};
    class FCR_ADU_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOAL_NTS.paa";};
    class FCR_ADU_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOAL_NTS_NoMSL.paa";};
    //Heli
    class FCR_HELI_LOAL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOAL.paa";};
    class FCR_HELI_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOAL_ANTS.paa";};
    class FCR_HELI_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOAL_NTS.paa";};
    class FCR_HELI_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOAL_NTS_NoMSL.paa";};
    //Tracked
    class FCR_TRACK_LOAL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOAL.paa";};
    class FCR_TRACK_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOAL_ANTS.paa";};
    class FCR_TRACK_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOAL_NTS.paa";};
    class FCR_TRACK_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOAL_NTS_NoMSL.paa";};    
    //Unknown
    class FCR_UNK_LOAL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOAL.paa";};
    class FCR_UNK_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOAL_ANTS.paa";};
    class FCR_UNK_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOAL_NTS.paa";};
    class FCR_UNK_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOAL_NTS_NoMSL.paa";}; 
    //Wheeled
    class FCR_WHEEL_LOAL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOAL.paa";};
    class FCR_WHEEL_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOAL_ANTS.paa";};
    class FCR_WHEEL_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOAL_NTS.paa";};
    class FCR_WHEEL_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOAL_NTS_NoMSL.paa";}; 

    //--------------------FCR LOBL--------------------
    //ADU
    class FCR_ADU_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOBL.paa";};
    class FCR_ADU_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOBL_ANTS.paa";};
    class FCR_ADU_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOBL_NTS.paa";};
    class FCR_ADU_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOBL_NTS_NoMSL.paa";};
    //Heli
    class FCR_HELI_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOBL.paa";};
    class FCR_HELI_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOBL_ANTS.paa";};
    class FCR_HELI_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOBL_NTS.paa";};
    class FCR_HELI_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOBL_NTS_NoMSL.paa";};
    //Tracked
    class FCR_TRACK_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOBL.paa";};
    class FCR_TRACK_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOBL_ANTS.paa";};
    class FCR_TRACK_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOBL_NTS.paa";};
    class FCR_TRACK_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOBL_NTS_NoMSL.paa";};  
    //Unknown
    class FCR_UNK_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOBL.paa";};
    class FCR_UNK_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOBL_ANTS.paa";};
    class FCR_UNK_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOBL_NTS.paa";};
    class FCR_UNK_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOBL_NTS_NoMSL.paa";}; 
    //Wheeled
    class FCR_WHEEL_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOBL.paa";};
    class FCR_WHEEL_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOBL_ANTS.paa";};
    class FCR_WHEEL_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOBL_NTS.paa";};
    class FCR_WHEEL_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOBL_NTS_NoMSL.paa";}; 

    //--------------------FCR MOVE--------------------
    //ADU
    class FCR_ADU_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\aduMOVE.paa";};
    class FCR_ADU_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\aduMOVE_ANTS.paa";};
    class FCR_ADU_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\aduMOVE_NTS.paa";};
    class FCR_ADU_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\aduMOVE_NTS_NoMSL.paa";};
    //Heli
    class FCR_HELI_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\heliMOVE.paa";};
    class FCR_HELI_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\heliMOVE_ANTS.paa";};
    class FCR_HELI_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\heliMOVE_NTS.paa";};
    class FCR_HELI_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\heliMOVE_NTS_NoMSL.paa";};
    //Tracked
    class FCR_TRACK_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\trackMOVE.paa";};
    class FCR_TRACK_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\trackMOVE_ANTS.paa";};
    class FCR_TRACK_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\trackMOVE_NTS.paa";};
    class FCR_TRACK_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\trackMOVE_NTS_NoMSL.paa";};      
    //Unknown
    class FCR_UNK_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\unkMOVE.paa";};
    class FCR_UNK_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\unkMOVE_ANTS.paa";};
    class FCR_UNK_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\unkMOVE_NTS.paa";};
    class FCR_UNK_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\unkMOVE_NTS_NoMSL.paa";}; 
    //Wheeled
    class FCR_WHEEL_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelMOVE.paa";};
    class FCR_WHEEL_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelMOVE_ANTS.paa";};
    class FCR_WHEEL_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelMOVE_NTS.paa";};
    class FCR_WHEEL_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelMOVE_NTS_NoMSL.paa";}; 
    //Flyer
    class FCR_FLYER_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\flyer.paa";};
    */