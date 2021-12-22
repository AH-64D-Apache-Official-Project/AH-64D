#define MPD_ICON_TYPE_A 0
#define MPD_ICON_TYPE_B 1
#define MPD_ICON_TYPE_C 2
#define MPD_ICON_TYPE_D 3
#define MPD_ICON_TYPE_E 4
#define MPD_ICON_TYPE_F 5
#define MPD_ICON_TYPE_G 6

#define MPD_ICON_TEXT_ID 0
#define MPD_ICON_TEXT_FREE 1

class FzaIconTypes {
//--------------------Icon Type A--------------------
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
    //Waypoints

    //Hazards

    //Control Measures
    class FU {                                                  //Friendly Unit
        tex= "\fza_ah64_mpd\tex\tsdIcons\fu.paa";
        color    = MPD_ICON_COLOR_CYAN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_A;
        textA    = MPD_ICON_TEXT_FREE;    
    };
    class EU:FU  {                                              //Enemy Unit
        tex= "\fza_ah64_mpd\tex\tsdIcons\eu.paa";
        color    = MPD_ICON_COLOR_RED;
    };

    //Target/Threats

//--------------------Icon Type C--------------------
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
    //Waypoints

    //Hazards

    //Control Measures
    class FC {                                                  //FARP - Fuel and Ammo
        tex= "\fza_ah64_mpd\tex\tsdIcons\fc.paa";
        color    = MPD_ICON_COLOR_GREEN;
        type     = POINT_TYPE_CM;
        iconType = MPD_ICON_TYPE_C;
        textA    = MPD_ICON_TEXT_ID;
        textB    = MPD_ICON_TEXT_FREE;
    };
    class FF:FC  { tex= "\fza_ah64_mpd\tex\tsdIcons\ff.paa";};  //FARP - Fuel only
    class FM:FC  { tex= "\fza_ah64_mpd\tex\tsdIcons\fm.paa";};  //Farm - Ammo only

    //Target/Threats

//--------------------Icon Type E--------------------
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
    //Waypoints

    //Hazards

    //Control Measures

    //Target/Threats
    class TG  {
        tex= "\fza_ah64_mpd\tex\tsdIcons\tg.paa";
        color    = MPD_ICON_COLOR_RED;
        type = POINT_TYPE_TG;
        iconType = MPD_ICON_TYPE_F;
        textA    = MPD_ICON_TEXT_ID;
    };
    class SR:TG    { tex= "\fza_ah64_mpd\tex\tsdIcons\r.paa";};
    class TR:TG    { tex= "\fza_ah64_mpd\tex\tsdIcons\r.paa";};  

//--------------------Icon Type G--------------------
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