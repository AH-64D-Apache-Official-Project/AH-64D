class CfgSound3DProcessors {

    class fza_weapons_3dprocessor 
    {
        type = "panner";
        innerrange = 1;
        range = 500;
        rangecurve = "fza_weapons_processorcurve";
    };
    class fza_snaps_3dprocessor 
    {
        type = "panner";
        innerrange = 0;
        range = 100;
        rangecurve = "fza_weapons_basic_volumecurve";
    };
    class fza_explosions_3dprocessor 
    {
        type = "panner";
        innerrange = 10;
        range = 100;
        rangecurve = "fza_fadeout_volumecurve";
    };
    class fza_wpn_small_tl_prc 
    {
        type = "panner";
        innerrange = 2;
        range = 500;
        rangecurve = "fza_wep_proc_pn_sin";
    };
    class fza_exp_stereo_medium_prc 
    {
        type = "panner";
        innerrange = 30;
        range = 400;
        rangecurve = "fza_basic_vl_sin";
    };
    class fza_explosion_tail_3dprocessor 
    {
        type = "panner";
        innerrange = 0;
        range = 200;
        rangecurve = "fza_fadeout_volumecurve";
    };
    class fza_exp_stereo_big_prc 
    {
        type = "panner";
        innerrange = 75;
        range = 700;
        rangecurve = "fza_basic_vl_sin";
    };
};