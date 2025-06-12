class CfgSoundSets {

    class fza_basic_soundset; 
    class fza_basic_soniccrack_soundset;
    class fza_sc_wire_flyby_soundset: fza_basic_soniccrack_soundset {
        soundShaders[] = {"fza_sc_wire_flyby_soundshader"};
        volumefactor = 1;
        soundshaderslimit = 2;
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////EXPLOSIONS///////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_rocket_explosion_soundset {
        soundShaders[] = {"fza_rocket_explosion_close_distance_soundshader", "fza_rocket_explosion_medium_distance_soundshader", "fza_rocket_explosion_far_distance_soundshader", "fza_rocket_explosion_very_far_distance_soundshader", "fza_big_debris_regular_soundshader", "fza_big_debris_houses_soundshader"};
        volumefactor = 1.950000;
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
    //////////////////////////////REVERB///////////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_shell_explosion_reverb_soundset {
        soundShaders[] = {"fza_explosion_echo_medium_soundshader", "fza_explosion_echo_houses_soundshader", "fza_explosion_big_shockwave_soundshader", "fza_shell_explosion_reverb_houses_soundshader", "fza_shell_explosion_reverb_forest_soundshader", "fza_shell_explosion_reverb_meadow_soundshader"};
        volumefactor = 1.000000;
        volumecurve = "fza_fadeout_volumecurve";
        sound3dprocessingtype = "fza_explosion_tail_3dprocessor";
        distancefilter = "fza_explosion_tail_lowpass_filter";
        spatial = 1;
        doppler = 0;
        loop = 0;
        occlusionfactor = 0.100000;
        obstructionfactor = 0.100000;
        frequencyrandomizer = 2;
        soundshaderslimit = 2;
    };
};