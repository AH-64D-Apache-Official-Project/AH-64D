#define MPD_ICON_TYPE_A 0
#define MPD_ICON_TYPE_B 1
#define MPD_ICON_TYPE_C 2
#define MPD_ICON_TYPE_D 3
#define MPD_ICON_TYPE_E 4
#define MPD_ICON_TYPE_F 5
#define MPD_ICON_TYPE_G 6
#define MPD_ICON_TYPE_H 7
#define MPD_ICON_TYPE_I 8

#define MPD_ICON_TEXT_ID 0
#define MPD_ICON_TEXT_FREE 1

#define ICON_SIZE 0.09

class FzaIconTypes {
    // Common templates to be used for generating icons.
    // Position text around the icons in standard locations
    class IconTypeA {
        type = -1;
        size = ICON_SIZE;

        textAOffset[] = {0.7,0.5};
        textAHAlign = "left";
        textAVAlign = "center";
    };
    class IconTypeB {
        type = -1;
        size = ICON_SIZE;

        textAOffset[] = {0.5, 0.5};
        textAHAlign = "center";
        textAVAlign = "center";
    };
    class IconTypeC {
        type = -1;
        size = ICON_SIZE;

        textAOffset[] = {0.5, 0.51};
        textAHAlign = "center";
        textAVAlign = "top";
    };
    class IconTypeD {
        type = -1;
        size = ICON_SIZE;

        textAOffset[] = {0.83,0.5};
        textAHAlign = "left";
        textAVAlign = "center";

        textBOffset[] = {0.5,0.12};
        textBHAlign = "center";
        textBVAlign = "bottom";
    };
    class IconTypeE {
        type = -1;
        size = ICON_SIZE;

        textAOffset[] = {0.5, 0.25};
        textAHAlign = "center";
        textAVAlign = "bottom";
    };
    class IconTypeF {
        type = -1;
        size = ICON_SIZE;

        textAOffset[] = {0.55, 0.5};
        textAHAlign = "left";
        textAVAlign = "center";
    };
    class IconTypeG {
        type = -1;
        size = ICON_SIZE;

        textAOffset[] = {0.15, 0.3};
        textAHAlign = "left";
        textAVAlign = "center";
        
        textBOffset[] = {0.85, 0.3};
        textBHAlign = "right";
        textBVAlign = "center";
    };
    class IconTypeH {
        type = -1;
        size = ICON_SIZE;
    };
    class IconTypeI {
        type = -1;
        size = ICON_SIZE;

        textAOffset[] = {0.15, 0.3};
        textAHAlign = "left";
        textAVAlign = "center";
        
        textBOffset[] = {0.85, 0.3};
        textBHAlign = "right";
        textBVAlign = "center";
    };
//--------------------Icon Type A--------------------
//                          
//                      +---------+
//                      |         |
//                      |   TEX   | 00/AAA 
//                      |         |
//                      +---------+  
    //Waypoints
    class CC : IconTypeA {                                          //Communication check point
        tex= "\fza_ah64_mpd\tex\tsdIcons\waypoints\cc_ca.paa";
        color[]  = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_WP;
        textA    = MPD_ICON_TEXT_ID;
    };
    class PP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\waypoints\pp_ca.paa";};   //Passage Point
    class RP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\waypoints\rp_ca.paa";};   //Release Point
    class SP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\waypoints\sp_ca.paa";};   //Start Point
    class WP:CC  { //Waypoint
        tex= "\fza_ah64_mpd\tex\tsdIcons\waypoints\wp_ca.paa";
        textAOffset[] = {0.6, 0.5};
    };
    class LZ:CC  { //Landing Zone
        tex= "\fza_ah64_mpd\tex\tsdIcons\waypoints\lz_ca.paa";
        textAOffset[] = {0.83, 0.5};
    };
    //Hazards
    class TO : IconTypeA {                                          //Tower - Over 1000ft agl
        tex      = "\fza_ah64_mpd\tex\tsdIcons\hazards\to_ca.paa";
        color[]  = MPD_ICON_COLOR_YELLOW;
        type     = POINT_TYPE_HZ;
        textA    = MPD_ICON_TEXT_ID;
        textAOffset[] = {0.59, 0.5};
    };
    class TU:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\hazards\tu_ca.paa";};  //Tower - Under 1000ft agl
    class WL:IconTypeA {
        tex   = "\fza_ah64_mpd\tex\tsdIcons\hazards\wl_ca.paa";
        color[] = MPD_ICON_COLOR_YELLOW;
        type  = POINT_TYPE_HZ;
        textA = MPD_ICON_TEXT_ID;
        textAOffset[] = {0.86, 0.5};
    };  //Wires - Power transmission lines
    class WS:WL {
        tex = "\fza_ah64_mpd\tex\tsdIcons\hazards\ws_ca.paa";
        textAOffset[] = {0.81, 0.5};
    };  //Wires - Telephon & electric
    
    //Control Measures
    class BR:IconTypeA  {         //Bridge
        tex   = "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\br_ca.paa";
        color[] = MPD_ICON_COLOR_GREEN;
        type  = POINT_TYPE_CM;
        textA = MPD_ICON_TEXT_ID;
        textAOffset[] = {0.6,0.5}; 
    };
    class CP:CC  {
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\cp_ca.paa";
        type  = POINT_TYPE_CM;
    };
    class AE:IconTypeA {      //Enemy Armor
        tex      = "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\enemy\ae_ca.paa";
        type     = POINT_TYPE_CM;
        color[]  = MPD_ICON_COLOR_RED;
        textA    = MPD_ICON_TEXT_FREE;
        textAOffset[] = {0.85,0.5}; 
    };
    class AM:AE  {      //Friendly Armor
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\friendly\am_ca.paa";
        color[]  = MPD_ICON_COLOR_BLUE;
        textA    = MPD_ICON_TEXT_FREE;
        textAOffset[] = {0.8,0.5}; 
    };
    class EF:AE  {      //Enemy Artillery
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\enemy\ef_ca.paa";
        color[]  = MPD_ICON_COLOR_RED;
        textA    = MPD_ICON_TEXT_FREE;  
    };
    class EI:AE  {      //Enemy Infantry
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\enemy\ei_ca.paa";
        color[]  = MPD_ICON_COLOR_RED;
        textA    = MPD_ICON_TEXT_FREE;
    };
    class EM:AE  {      //Enemy Mech Infantry
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\enemy\em_ca.paa";
        color[]  = MPD_ICON_COLOR_RED;
        textA    = MPD_ICON_TEXT_FREE;
    };
    class FI:AE  {      //Friendly Infantry
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\friendly\fi_ca.paa";
        color[]  = MPD_ICON_COLOR_BLUE;
        textA    = MPD_ICON_TEXT_FREE;
        textAOffset[] = {0.8,0.5}; 
    };
    class FL:AE  {      //Friendly Artillery
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\friendly\fl_ca.paa";
        color[]  = MPD_ICON_COLOR_BLUE;
        textA    = MPD_ICON_TEXT_FREE;
        textAOffset[] = {0.8,0.5}; 
    };
    class MI:AE  {      //Friendly Mech Infantry
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\friendly\mi_ca.paa";
        color[]  = MPD_ICON_COLOR_BLUE;
        textA    = MPD_ICON_TEXT_FREE;
        textAOffset[] = {0.8,0.5}; 
    };
    //Target/Threats
    //ASE

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
    class FU : IconTypeB {      //Friendly Unit
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\friendly\fu_ca.paa";
        color[]  = MPD_ICON_COLOR_BLUE;
        type     = POINT_TYPE_CM;
        textA    = MPD_ICON_TEXT_FREE;    
    };
    class EU:FU  {              //Enemy Unit
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\enemy\eu_ca.paa";
        color[]  = MPD_ICON_COLOR_RED;
    };
    //Target/Threats
    //ASE

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
    class AA : IconTypeC {                                          //Assembly area
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\aa_ca.paa";
        color[]  = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        textA    = MPD_ICON_TEXT_ID;
    };
    class AP:AA { tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\ap_ca.paa";};  //Air Control Point
    class BP:AP { tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\bp_ca.paa";};  //Battle Position
    class HA:AP { tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\ha_ca.paa";};  //Holding Area
    //Target/Threats
    //ASE

//--------------------Icon Type D--------------------
//                          AAA
//                      +---------+
//                      |         |
//                      |   TEX   | 00
//                      |         |
//                      +---------+
    //Waypoints
    //Hazards
    //Control Measures
    class FC:IconTypeD {                                          //FARP - Fuel and Ammo
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\fc_ca.paa";
        color[]  = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        textA    = MPD_ICON_TEXT_ID;
        textB    = MPD_ICON_TEXT_FREE;
    };
    class FF:FC  { tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\ff_ca.paa";};   //FARP - Fuel only
    class FM:FC  { tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\fm_ca.paa";};   //Farm - Ammo only
    //Target/Threats
    //ASE

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
    class AG:IconTypeE {                                                                      //Airfield - General
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\ag_ca.paa";
        color[]  = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        textA    = MPD_ICON_TEXT_FREE;
    };
    class AI:AG  { tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\ai_ca.paa";};       //Airfield - Instrumented
    class AL:AG  { tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\al_ca.paa";};       //Light Airport
    class GL:AG  { tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\gl_ca.paa";};       //Ground Light
    class ID:AG {                                                                               //IDM Subscriber
        tex= "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\id_ca.paa";
        color[]  = MPD_ICON_COLOR_BLUE;
        textAOffset[] = {0.5, 0.74};
        textAVAlign = "top";
    };
    //Target/Threats
    //ASE
 
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
    class TG:IconTypeF  {
        tex= "\fza_ah64_mpd\tex\tsdIcons\targetThreats\tg_ca.paa";
        color[]  = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_TG;
        textA    = MPD_ICON_TEXT_ID;
    };
    class SR:TG    {
        tex= "\fza_ah64_mpd\tex\tsdIcons\targetThreats\r_ca.paa";
        textAOffset[] = {0.65, 0.5};
    };
    class TR:SR    { tex= "\fza_ah64_mpd\tex\tsdIcons\targetThreats\r_ca.paa";};
    //ASE  

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
    class F1:IconTypeG { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\f1_f2_ca.paa";
        color[]  = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_CM;
        textAOffset[] = {0.56, 0.3};
        textAHAlign = "right";
        textAVAlign = "bottom";
        textA    = MPD_ICON_TEXT_FREE;
    };
    class F2:IconTypeG { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\f1_f2_ca.paa";
        color[]  = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_CM;
        textBOffset[] = {0.44, 0.3};
        textBHAlign = "left";
        textBVAlign = "bottom";
        textB    = MPD_ICON_TEXT_FREE;
    };
    //Target/Threats
    class GU:IconTypeG { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        color[]  = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_TG;
        textA    = "G";
        textB    = "U";
    };
    class Icon1:IconTypeG { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        color[]  = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_TG;
        textB = "1";
    };
    class Icon2:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textB = "2";
    };
    class Icon3:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textB = "3";
    };
    class Icon4:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textB = "4";
    };
    class Icon5:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textB = "5";
    };
    class Icon6:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textB = "6";
    };
    class Icon7:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textB = "7";
    };
    class Icon8:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textB = "8";
    };
    class Icon9:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textB = "9";
    };
    class Icon10:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "1";
        textB = "0";
    };
    class Icon11:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "1";
        textB = "1";
    };
    class Icon12:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "1";
        textB = "2";
    };
    class Icon13:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "1";
        textB = "3";
    };
    class Icon14:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "1";
        textB = "4";
    };
    class Icon15:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "1";
        textB = "5";
    };
    class Icon16:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "1";
        textB = "6";
    };
    class Icon17:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "1";
        textB = "7";
    };
    class S6:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "S";
        textB = "6";
    };
    class ZU:Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\targetThreats\gu_ca.paa";
        textA = "Z";
        textB = "U";
    };
    
//--------------------Icon Type H--------------------
//
//             +---------+    +---------+   
//             |         |    |         |
//             |   TEX   |    |  TEX 2  |
//             |         |    |         |
//             +---------+    +---------+
    //----------TSD FCR ICON SCALE 25 & 50-----------
        class FCR_TSD_SC25_50:IconTypeH { 
        tex   = "\fza_ah64_mpd\tex\fcrIcons\scale25_50_icon_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    //--------------------FCR LOAL--------------------
    //ADU
    class FCR_ADU_LOAL:IconTypeH { 
        tex   = "\fza_ah64_mpd\tex\fcrIcons\aduLOAL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_ADU_LOAL_ANTS:FCR_ADU_LOAL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_ADU_LOAL_NTS:FCR_ADU_LOAL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_ADU_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};
    //Heli
    class FCR_HELI_LOAL:IconTypeH { 
        tex   = "\fza_ah64_mpd\tex\fcrIcons\heliLOAL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_HELI_LOAL_ANTS:FCR_HELI_LOAL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_HELI_LOAL_NTS:FCR_HELI_LOAL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_HELI_LOAL_NTS_NOMSL:FCR_HELI_LOAL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};
    //Tracked
    class FCR_TRACK_LOAL:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\trackLOAL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_TRACK_LOAL_ANTS:FCR_TRACK_LOAL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_TRACK_LOAL_NTS:FCR_TRACK_LOAL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_TRACK_LOAL_NTS_NOMSL:FCR_TRACK_LOAL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};    
    //Unknown
    class FCR_UNK_LOAL:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\unkLOAL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_UNK_LOAL_ANTS:FCR_UNK_LOAL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_UNK_LOAL_NTS:FCR_UNK_LOAL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_UNK_LOAL_NTS_NOMSL:FCR_UNK_LOAL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";}; 
    //Wheeled
    class FCR_WHEEL_LOAL:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\wheelLOAL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_WHEEL_LOAL_ANTS:FCR_WHEEL_LOAL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_WHEEL_LOAL_NTS:FCR_WHEEL_LOAL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_WHEEL_LOAL_NTS_NOMSL:FCR_WHEEL_LOAL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};

    //--------------------FCR LOBL--------------------
    //ADU
    class FCR_ADU_LOBL : IconTypeH { 
        tex   = "\fza_ah64_mpd\tex\fcrIcons\aduLOBL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_ADU_LOBL_ANTS:FCR_ADU_LOBL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_ADU_LOBL_NTS:FCR_ADU_LOBL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_ADU_LOBL_NTS_NOMSL:FCR_ADU_LOBL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};
    //Heli
    class FCR_HELI_LOBL:IconTypeH { 
        tex   = "\fza_ah64_mpd\tex\fcrIcons\heliLOBL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_HELI_LOBL_ANTS:FCR_HELI_LOBL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_HELI_LOBL_NTS:FCR_HELI_LOBL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_HELI_LOBL_NTS_NOMSL:FCR_HELI_LOBL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};
    //Tracked
    class FCR_TRACK_LOBL:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\trackLOBL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_TRACK_LOBL_ANTS:FCR_TRACK_LOBL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_TRACK_LOBL_NTS:FCR_TRACK_LOBL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_TRACK_LOBL_NTS_NOMSL:FCR_TRACK_LOBL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};    
    //Unknown
    class FCR_UNK_LOBL:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\unkLOBL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_UNK_LOBL_ANTS:FCR_UNK_LOBL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_UNK_LOBL_NTS:FCR_UNK_LOBL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_UNK_LOBL_NTS_NOMSL:FCR_UNK_LOBL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";}; 
    //Wheeled
    class FCR_WHEEL_LOBL:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\wheelLOBL_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_WHEEL_LOBL_ANTS:FCR_WHEEL_LOBL      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_WHEEL_LOBL_NTS:FCR_WHEEL_LOBL       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_WHEEL_LOBL_NTS_NOMSL:FCR_WHEEL_LOBL { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};
    //--------------------FCR MOVE--------------------
    //ADU
    class FCR_ADU_MOVE : IconTypeH { 
        tex   = "\fza_ah64_mpd\tex\fcrIcons\aduMOVE_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_ADU_MOVE_ANTS:FCR_ADU_MOVE      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_ADU_MOVE_NTS:FCR_ADU_MOVE       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_ADU_MOVE_NTS_NOMSL:FCR_ADU_MOVE { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};
    //Heli
    class FCR_HELI_MOVE:IconTypeH { 
        tex   = "\fza_ah64_mpd\tex\fcrIcons\heliMOVE_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_HELI_MOVE_ANTS:FCR_HELI_MOVE      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_HELI_MOVE_NTS:FCR_HELI_MOVE       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_HELI_MOVE_NTS_NOMSL:FCR_HELI_MOVE { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};
    //Tracked
    class FCR_TRACK_MOVE:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\trackMOVE_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_TRACK_MOVE_ANTS:FCR_TRACK_MOVE      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_TRACK_MOVE_NTS:FCR_TRACK_MOVE       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_TRACK_MOVE_NTS_NOMSL:FCR_TRACK_MOVE { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};    
    //Unknown
    class FCR_UNK_MOVE:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\unkMOVE_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_UNK_MOVE_ANTS:FCR_UNK_MOVE      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_UNK_MOVE_NTS:FCR_UNK_MOVE       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_UNK_MOVE_NTS_NOMSL:FCR_UNK_MOVE { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";}; 
    //Wheeled
    class FCR_WHEEL_MOVE:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\wheelMOVE_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_WHEEL_MOVE_ANTS:FCR_WHEEL_MOVE      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_WHEEL_MOVE_NTS:FCR_WHEEL_MOVE       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_WHEEL_MOVE_NTS_NOMSL:FCR_WHEEL_MOVE { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};
    //Flyer
    class FCR_FLYER_MOVE:IconTypeH {
        tex   = "\fza_ah64_mpd\tex\fcrIcons\flyer_ca.paa";
        type  = POINT_TYPE_FCR;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
    class FCR_FLYER_MOVE_ANTS:FCR_FLYER_MOVE      { tex2 = "\fza_ah64_mpd\tex\fcrIcons\ants_ca.paa";};
    class FCR_FLYER_MOVE_NTS:FCR_FLYER_MOVE       { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_ca.paa";};
    class FCR_FLYER_MOVE_NTS_NOMSL:FCR_FLYER_MOVE { tex2 = "\fza_ah64_mpd\tex\fcrIcons\nts_noMsl_ca.paa";};

//--------------------Icon Type I--------------------
//
//             +---------+    +---------+   
//             | 0     0 |    |         |
//             |   TEX   |    |  TEX 2  |
//             |         |    |         |
//             +---------+    +---------+
    //SA-2
    class RLWR_SA2_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textB = "2";
    };
    class RLWR_SA2_ACQ_TRK:RLWR_SA2_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SA-3
    class RLWR_SA3_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textB = "3";
    };
    class RLWR_SA3_ACQ_TRK:RLWR_SA3_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SA-8
    class RLWR_SA8_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textB = "8";
    };
    class RLWR_SA8_ACQ_TRK:RLWR_SA8_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SA-10
    class RLWR_SA10_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "1";
        textB = "0";
    };
    class RLWR_SA10_ACQ_TRK:RLWR_SA10_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SA-11
    class RLWR_SA11_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "1";
        textB = "1";
    };
    class RLWR_SA11_ACQ_TRK:RLWR_SA11_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SA-15
    class RLWR_SA15_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "1";
        textB = "5";
    };
    class RLWR_SA15_ACQ_TRK:RLWR_SA15_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SA-17
    class RLWR_SA17_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "1";
        textB = "7";
    };
    class RLWR_SA17_ACQ_TRK:RLWR_SA17_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SA-19
    class RLWR_SA19_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "1";
        textB = "9";
    };
    class RLWR_SA19_ACQ_TRK:RLWR_SA19_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SA-20
    class RLWR_SA20_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "2";
        textB = "0";
    };
    class RLWR_SA20_ACQ_TRK:RLWR_SA20_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SA-21
    class RLWR_SA21_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "2";
        textB = "1";
    };
    class RLWR_SA21_ACQ_TRK:RLWR_SA21_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //GU
    class RLWR_GU_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "G";
        textB = "U";
    };
    class RLWR_GU_ACQ_TRK:RLWR_GU_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //HK
    class RLWR_HK_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "H";
        textB = "K";
    };
    class RLWR_HK_ACQ_TRK:RLWR_HK_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //NV
    class RLWR_NV_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "N";
        textB = "V";
    };
    class RLWR_NV_ACQ_TRK:RLWR_NV_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //2S6
    class RLWR_2S6_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "S";
        textB = "6";
    };
    class RLWR_2S6_ACQ_TRK:RLWR_2S6_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //SR
    class RLWR_SR_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "S";
        textB = "R";
    };
    class RLWR_SR_ACQ_TRK:RLWR_SR_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //ZU
    class RLWR_ZU_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "Z";
        textB = "U";
    };
    class RLWR_ZU_ACQ_TRK:RLWR_ZU_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //ST
    class RLWR_ST_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "S";
        textB = "T";
    };
    class RLWR_ST_ACQ_TRK:RLWR_ST_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    //VU
    class RLWR_VU_SRH : IconTypeI {
        tex   = "\fza_ah64_mpd\tex\aseIcons\rlwrIcon_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "V";
        textB = "U";
    };
    class RLWR_VU_ACQ_TRK:RLWR_VU_SRH { tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";};
    
    class RLWR_MSL_LNC : IconTypeB {
        tex = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
        textA = "M";
    };
    class RLWR_LSR_DES : IconTypeI {
        tex = "\fza_ah64_mpd\tex\tsdIcons\controlMeasures\general\GL_ca.paa";
        tex2 = "\fza_ah64_mpd\tex\aseIcons\rlwrBox_ca.paa";
        type  = POINT_TYPE_ASE;
        color[] = MPD_ICON_COLOR_YELLOW;
    };
};