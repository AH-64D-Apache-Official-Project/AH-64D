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
        tex= "\fza_ah64_mpd\tex\tsdIcons\cc_ca.paa";
        color    = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_WP;
        iconType = MPD_ICON_TYPE_A;
        textA    = MPD_ICON_TEXT_ID;
    };
    class LZ:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\lz_ca.paa";};  //Landing Zone
    class PP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\pp_ca.paa";};  //Passage Point
    class RP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\rp_ca.paa";};  //Release Point
    class SP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\sp_ca.paa";};  //Start Point
    class WP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\wp_ca.paa";};  //Waypoint
    //Hazards
    class TO {                                                  //Tower - Over 1000ft agl
        tex= "\fza_ah64_mpd\tex\tsdIcons\to_ca.paa";
        color    = MPD_ICON_COLOR_YELLOW;
        type     = POINT_TYPE_HZ;
        iconType = MPD_ICON_TYPE_A;
        textA    = MPD_ICON_TEXT_ID;
    };
    class TU:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\tu_ca.paa";};  //Tower - Under 1000ft agl
    class WL:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\wl_ca.paa";};  //Wires - Power transmission lines
    class WS:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\ws_ca.paa";};  //Wires - Telephon & electric
    //Control Measures
    class AA {                                                  //Assembly area
        tex= "\fza_ah64_mpd\tex\tsdIcons\aa_ca.paa";
        color    = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_A;
        textA    = MPD_ICON_TEXT_FREE;
    };
    class BR:CC  {                                              //Bridge
        tex= "\fza_ah64_mpd\tex\tsdIcons\br_ca.paa";
        type = POINT_TYPE_CM;
    };
    class EA:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\ea_ca.paa";
        color    = MPD_ICON_COLOR_RED;
    };
    class EF:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\ef_ca.paa";
        color    = MPD_ICON_COLOR_RED;
    };
    class EI:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\ei_ca.paa";
        color    = MPD_ICON_COLOR_RED;
    };
    class EM:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\em_ca.paa";
        color    = MPD_ICON_COLOR_RED;
    };
    class FI:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\fi_ca.paa";
        color    = MPD_ICON_COLOR_CYAN;
    };
    class FL:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\fl_ca.paa";
        color    = MPD_ICON_COLOR_CYAN;
    };
    class MI:AA  { 
        tex= "\fza_ah64_mpd\tex\tsdIcons\mi_ca.paa";
        color    = MPD_ICON_COLOR_CYAN;
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
    class FU {                                                  //Friendly Unit
        tex= "\fza_ah64_mpd\tex\tsdIcons\fu_ca.paa";
        color    = MPD_ICON_COLOR_CYAN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_B;
        textA    = MPD_ICON_TEXT_FREE;    
    };
    class EU:FU  {                                              //Enemy Unit
        tex= "\fza_ah64_mpd\tex\tsdIcons\eu_ca.paa";
        color    = MPD_ICON_COLOR_RED;
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
    class AP  {                                                 //Air Control Point
        tex= "\fza_ah64_mpd\tex\tsdIcons\ap_ca.paa";
        color    = MPD_ICON_COLOR_GREEN;               
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_C;
        textA    = MPD_ICON_TEXT_ID;
    };
    class BP:AP  { tex= "\fza_ah64_mpd\tex\tsdIcons\bp.paa";};  //Battle Position
    class FA:AP  { tex= "\fza_ah64_mpd\tex\tsdIcons\fa.paa";};  //Forward Assembly Area
    class HA:AP  { tex= "\fza_ah64_mpd\tex\tsdIcons\ha.paa";};  //Holding Area
    //Target/Threats
    //ASE

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
        tex= "\fza_ah64_mpd\tex\tsdIcons\fc_ca.paa";
        color    = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_D;
        textA    = MPD_ICON_TEXT_ID;
        textB    = MPD_ICON_TEXT_FREE;
    };
    class FF:FC  { tex= "\fza_ah64_mpd\tex\tsdIcons\ff_ca.paa";};  //FARP - Fuel only
    class FM:FC  { tex= "\fza_ah64_mpd\tex\tsdIcons\fm_ca.paa";};  //Farm - Ammo only
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
    class AG  {                                                     //Airfield - General
        tex= "\fza_ah64_mpd\tex\tsdIcons\ag_ca.paa";
        color    = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_E;
        textA    = MPD_ICON_TEXT_FREE;
    };
    class AI:AG  { tex= "\fza_ah64_mpd\tex\tsdIcons\ai_ca.paa";};      //Airfield - Instrumented
    class AL:AG  { tex= "\fza_ah64_mpd\tex\tsdIcons\al_ca.paa";};      //Light Airport
    class GL:AG  { tex= "\fza_ah64_mpd\tex\tsdIcons\gl_ca.paa";};      //Ground Light
    class IDM:AG {                                                  //IDM Subsriber
        tex= "\fza_ah64_mpd\tex\tsdIcons\idmsub_ca.paa";
        color    = MPD_ICON_COLOR_CYAN;
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
    class TG  {
        tex= "\fza_ah64_mpd\tex\tsdIcons\tg_ca.paa";
        color    = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_TG;
        iconType = MPD_ICON_TYPE_F;
        textA    = MPD_ICON_TEXT_ID;
    };
    class SR:TG    { tex= "\fza_ah64_mpd\tex\tsdIcons\r_ca.paa";};
    class TR:TG    { tex= "\fza_ah64_mpd\tex\tsdIcons\r_ca.paa";};
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
    
    //Target/Threats
    class GU    { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        color    = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_TG;
        iconType = MPD_ICON_TYPE_G;
        textA    = "46"; 
    };
    class Icon1:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = " 1";
    };
        class Icon2:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = " 2";
    };
        class Icon3:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = " 3";
    };
        class Icon4:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = " 4";
    };
        class Icon5:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = " 5";
    };
        class Icon6:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = " 6";
    };
        class Icon7:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = " 7";
    };
        class Icon8:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = " 8";
    };
        class Icon9:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = " 9";
    };
        class Icon10:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "10";
    };
        class Icon11:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "11";
    };
        class Icon12:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "12";
    };
        class Icon13:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "13";
    };
        class Icon14:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "14";
    };
        class Icon15:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "15";
    };
        class Icon16:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "16";
    };
        class Icon17:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "17";
    };
    class S6:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "56";
    };
    class ZU:GU { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu_ca.paa";
        textA = "66";
    };
    
    //ASE
    //--SA1
    class ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        color    = MPD_ICON_COLOR_RED;
        type     = POINT_TYPE_ASE;
        iconType = MPD_ICON_TYPE_G;
        textA    = " 1";
    };
    class ASE_ADU_ACQ_Icon1:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA2
    class ASE_ADU_SRH_Icon2:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = " 2";
    };
    class ASE_ADU_ACQ_Icon2:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA3
    class ASE_ADU_SRH_Icon3:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = " 3";
    };
    class ASE_ADU_ACQ_Icon3:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA4
    class ASE_ADU_SRH_Icon4:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = " 4";
    };
    class ASE_ADU_ACQ_Icon4:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA5
    class ASE_ADU_SRH_Icon5:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = " 5";
    };
    class ASE_ADU_ACQ_Icon5:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA6
    class ASE_ADU_SRH_Icon6:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = " 6";
    };
    class ASE_ADU_ACQ_Icon6:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA7
    class ASE_ADU_SRH_Icon7:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = " 7";
    };
    class ASE_ADU_ACQ_Icon7:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA8
    class ASE_ADU_SRH_Icon8:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = " 8";
    };
    class ASE_ADU_ACQ_Icon8:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA9
    class ASE_ADU_SRH_Icon9:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = " 9";
    };
    class ASE_ADU_ACQ_Icon9:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA10
    class ASE_ADU_SRH_Icon10:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "10";
    };
    class ASE_ADU_ACQ_Icon10:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA11
    class ASE_ADU_SRH_Icon11:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "11";
    };
    class ASE_ADU_ACQ_Icon11:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA12
    class ASE_ADU_SRH_Icon12:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "12";
    };
    class ASE_ADU_ACQ_Icon12:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA13
    class ASE_ADU_SRH_Icon13:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "13";
    };
    class ASE_ADU_ACQ_Icon13:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA14
    class ASE_ADU_SRH_Icon14:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "14";
    };
    class ASE_ADU_ACQ_Icon14:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA15
    class ASE_ADU_SRH_Icon15:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "15";
    };
    class ASE_ADU_ACQ_Icon15:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA16
    class ASE_ADU_SRH_Icon16:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "16";
    };
    class ASE_ADU_ACQ_Icon16:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--SA17
    class ASE_ADU_SRH_Icon17:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "17";
    };
    class ASE_ADU_ACQ_Icon17:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--2S6
    class ASE_ADU_SRH_S6:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "56";
    };
    class ASE_ADU_ACQ_S6:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    //--ZSU-23-4
    class ASE_ADU_SRH_ZU:ASE_ADU_SRH_Icon1 { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUSearch_ca.paa";
        textA = "66";
    };
    class ASE_ADU_ACQ_ZU:ASE_ADU_SRH_Icon1 {
        tex = "\fza_ah64_mpd\tex\tsdIcons\ADUAcquisition_ca.paa";
    };
    class ASE_LSR_RNG:ASE_ADU_SRH_Icon1  { 
        tex = "\fza_ah64_mpd\tex\tsdIcons\LSRRanging_ca.paa";
        textA    = "  "; 
    };

//--------------------Icon Type H--------------------
//
//                      +---------+
//                      |         |
//                      |   TEX   |
//                      |         |
//                      +---------+
    //--------------------FCR LOAL--------------------
    //ADU
    class FCR_ADU_LOAL { 
        tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOAL.paa";
        type     = POINT_TYPE_FCR;
        iconType = MPD_ICON_TYPE_H;
    };
    class FCR_ADU_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOAL_ANTS_ca.paa";};
    class FCR_ADU_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOAL_NTS_ca.paa";};
    class FCR_ADU_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOAL_NTS_NoMSL_ca.paa";};
    //Heli
    class FCR_HELI_LOAL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOAL_ca.paa";};
    class FCR_HELI_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOAL_ANTS_ca.paa";};
    class FCR_HELI_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOAL_NTS_ca.paa";};
    class FCR_HELI_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOAL_NTS_NoMSL_ca.paa";};
    //Tracked
    class FCR_TRACK_LOAL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOA_ca.paa";};
    class FCR_TRACK_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOAL_ANTS_ca.paa";};
    class FCR_TRACK_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOAL_NTS_ca.paa";};
    class FCR_TRACK_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOAL_NTS_NoMSL_ca.paa";};    
    //Unknown
    class FCR_UNK_LOAL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOAL_ca.paa";};
    class FCR_UNK_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOAL_ANTS_ca.paa";};
    class FCR_UNK_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOAL_NTS_ca.paa";};
    class FCR_UNK_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOAL_NTS_NoMSL_ca.paa";}; 
    //Wheeled
    class FCR_WHEEL_LOAL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOAL_ca.paa";};
    class FCR_WHEEL_LOAL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOAL_ANTS_ca.paa";};
    class FCR_WHEEL_LOAL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOAL_NTS_ca.paa";};
    class FCR_WHEEL_LOAL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOAL_NTS_NoMSL_ca.paa";}; 

    //--------------------FCR LOBL--------------------
    //ADU
    class FCR_ADU_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOBL_ca.paa";};
    class FCR_ADU_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOBL_ANTS_ca.paa";};
    class FCR_ADU_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOBL_NTS_ca.paa";};
    class FCR_ADU_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\aduLOBL_NTS_NoMSL_ca.paa";};
    //Heli
    class FCR_HELI_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOBL_ca.paa";};
    class FCR_HELI_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOBL_ANTS_ca.paa";};
    class FCR_HELI_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOBL_NTS_ca.paa";};
    class FCR_HELI_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\heliLOBL_NTS_NoMSL_ca.paa";};
    //Tracked
    class FCR_TRACK_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOBL_ca.paa";};
    class FCR_TRACK_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOBL_ANTS_ca.paa";};
    class FCR_TRACK_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOBL_NTS_ca.paa";};
    class FCR_TRACK_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\trackLOBL_NTS_NoMSL_ca.paa";};  
    //Unknown
    class FCR_UNK_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOBL_ca.paa";};
    class FCR_UNK_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOBL_ANTS_ca.paa";};
    class FCR_UNK_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOBL_NTS_ca.paa";};
    class FCR_UNK_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\unkLOBL_NTS_NoMSL_ca.paa";}; 
    //Wheeled
    class FCR_WHEEL_LOBL:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOBL_ca.paa";};
    class FCR_WHEEL_LOBL_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOBL_ANTS_ca.paa";};
    class FCR_WHEEL_LOBL_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOBL_NTS_ca.paa";};
    class FCR_WHEEL_LOBL_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelLOBL_NTS_NoMSL_ca.paa";}; 

    //--------------------FCR MOVE--------------------
    //ADU
    class FCR_ADU_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\aduMOVE_ca.paa";};
    class FCR_ADU_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\aduMOVE_ANTS_ca.paa";};
    class FCR_ADU_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\aduMOVE_NTS_ca.paa";};
    class FCR_ADU_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\aduMOVE_NTS_NoMSL_ca.paa";};
    //Heli
    class FCR_HELI_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\heliMOVE_ca.paa";};
    class FCR_HELI_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\heliMOVE_ANTS_ca.paa";};
    class FCR_HELI_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\heliMOVE_NTS_ca.paa";};
    class FCR_HELI_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\heliMOVE_NTS_NoMSL_ca.paa";};
    //Tracked
    class FCR_TRACK_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\trackMOVE_ca.paa";};
    class FCR_TRACK_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\trackMOVE_ANTS_ca.paa";};
    class FCR_TRACK_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\trackMOVE_NTS_ca.paa";};
    class FCR_TRACK_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\trackMOVE_NTS_NoMSL_ca.paa";};      
    //Unknown
    class FCR_UNK_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\unkMOVE_ca.paa";};
    class FCR_UNK_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\unkMOVE_ANTS_ca.paa";};
    class FCR_UNK_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\unkMOVE_NTS_ca.paa";};
    class FCR_UNK_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\unkMOVE_NTS_NoMSL_ca.paa";}; 
    //Wheeled
    class FCR_WHEEL_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelMOVE_ca.paa";};
    class FCR_WHEEL_MOVE_ANTS:FCR_ADU_LOAL      { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelMOVE_ANTS_ca.paa";};
    class FCR_WHEEL_MOVE_NTS:FCR_ADU_LOAL       { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelMOVE_NTS_ca.paa";};
    class FCR_WHEEL_MOVE_NTS_NOMSL:FCR_ADU_LOAL { tex = "\fza_ah64_mpd\tex\fcrIcons\wheelMOVE_NTS_NoMSL_ca.paa";}; 
    //Flyer
    class FCR_FLYER_MOVE:FCR_ADU_LOAL           { tex = "\fza_ah64_mpd\tex\fcrIcons\flyer_ca.paa";};
};