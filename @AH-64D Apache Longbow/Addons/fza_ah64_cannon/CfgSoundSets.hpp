class CfgSoundSets {

    class fza_basic_soundset {
        volumeFactor = 1;
        volumecurve = "fza_weapons_basic_volumecurve";
        sound3dprocessingtype = "fza_weapons_3dprocessor";
        distancefilter = "fza_weapons_lowpass_filter";
        occlusionFactor = 0.250000;
        obstructionFactor = 0.300000;
        spatial = 1;
        doppler = 0;
        loop = 0;
        frequencyrandomizer = 0.500000;
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////SONICCRACKS//////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_basic_soniccrack_soundset {
        volumefactor = 1.250000;
        volumerandomizer = 1;
        volumecurve = "fza_basic_vl_sin";
        spatial = 1;
        doppler = 0;
        loop = 0;
        sound3dprocessingtype = "fza_snaps_3dprocessor";
        distancefilter = "fza_weapons_lowpass_filter";
        frequencyrandomizer = 4;
    };
    class fza_sc_bullet_flyby_soundset: fza_basic_soniccrack_soundset {
        soundShaders[]  = {"fza_sc_bullet_flyby_soundshader"};
        volumefactor = 1;
        soundshaderslimit = 2;
    };
    class fza_sc_30x113_soundset: fza_basic_soniccrack_soundset {
        soundShaders[] = {"fza_sc_30x113_close_soundshader", "fza_sc_30x113_medium_soundshader", "fza_sc_30x113_far_soundshader"};
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////EXPLOSIONS///////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_20mm_explosion_soundset {
        soundShaders[] = {"fza_20mm_explosion_close_distance_soundshader", "fza_20mm_explosion_medium_distance_soundshader", "fza_20mm_explosion_far_distance_soundshader", "fza_small_debris_regular_soundshader", "fza_small_debris_houses_soundshader"};
        volumefactor = 1.500000;
        volumecurve = "fza_explosions_volumecurve";
        sound3dprocessingtype = "fza_explosions_3dprocessor";
        distancefilter = "fza_explosions_lowpass_filter";
        spatial = 1;
        doppler = 0;
        loop = 0;
        occlusionfactor = 0.100000;
        obstructionfactor = 0.100000;
        frequencyrandomizer = 3;
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////ECHO/////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_explosion_echo_small_soundset {
        soundShaders[] = {"fza_explosion_echo_small_soundshader", "fza_explosion_echo_houses_soundshader"};
        volumefactor = 1.400000;
        volumecurve = "fza_basic_vl_sin";
        volumerandomizer = 0.500000;
        sound3dprocessingtype = "fza_wpn_small_tl_prc";
        spatial = 1;
        doppler = 0;
        loop = 0;
        distancefilter = "fza_wpn_echo_lp_dia";
        frequencyrandomizer = 2;
        soundshaderslimit = 2;
        occlusionfactor = 0.200000;
        obstructionfactor = 0;
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////WEAPONS//////////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_m230_soundset: fza_basic_soundset {
        soundShaders[] = {"fza_m230_close_soundshader","fza_m230_close_distance_soundshader","fza_m230_medium_distance_soundshader","fza_m230_close_distance_pool_soundshader","fza_m230_far_distance_pool_soundshader","fza_m230_very_far_distance_pool_soundshader"};
    };
};