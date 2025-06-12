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

    class fza_missile_explosion_stereo_soundset {
        soundShaders[] = {"fza_missile_explosion_stereo_soundshader", "fza_missile_explosion_distance_soundshader"};
        volumefactor = 0.750000;
        volumecurve = "fza_basic_vl_sin";
        spatial = 1;
        doppler = 0;
        loop = 0;
        soundshaderslimit = 2;
        sound3dprocessingtype = "fza_exp_stereo_big_prc";
        distancefilter = "fza_basic_lp_dia";
        frequencyrandomizer = 3;
        occlusionfactor = 0.250000;
        obstructionfactor = 0.250000;
    };

    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////WEAPONS//////////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_agm114_soundset: fza_basic_soundset {
        soundShaders[] = {"fza_agm114_close_soundshader","fza_agm114_close_distance_soundshader","fza_agm114_medium_distance_soundshader","fza_agm114_close_distance_pool_soundshader","fza_agm114_far_distance_pool_soundshader","fza_agm114_very_far_distance_pool_soundshader"};
    };
};