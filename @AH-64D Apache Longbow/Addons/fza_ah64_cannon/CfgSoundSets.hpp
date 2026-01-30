class CfgSoundSets {
    class fza_basic_soundset;
    class fza_basic_soniccrack_soundset;
    class fza_soundset_cannon_flyby: fza_basic_soniccrack_soundset {
        soundShaders[]  = {"fza_soundshader_cannon_flyby"};
        volumefactor = 1;
        soundshaderslimit = 2;
    };
    class fza_soundset_cannon_flyby_1: fza_basic_soniccrack_soundset {
        soundShaders[] = {"fza_soundshader_cannon_sonic_crack_close", "fza_soundshader_cannon_sonic_crack_medium", "fza_soundshader_cannon_sonic_crack_far"};
    };
    class fza_soundset_cannon_explosion {
        soundShaders[] = {"fza_soundshader_cannon_explosion_close_distance", "fza_soundshader_cannon_explosion_medium_distance", "fza_soundshader_cannon_explosion_far_distance", "fza_small_debris_regular_soundshader", "fza_small_debris_houses_soundshader"};
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
    class fza_soundset_cannon_explosion_echo {
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
    class fza_soundset_cannon_shot: fza_basic_soundset {
        soundShaders[] = {"fza_soundshader_cannon_close","fza_soundshader_cannon_close_distance","fza_soundshader_cannon_medium_distance","fza_soundshader_cannon_close_distance_pool","fza_soundshader_cannon_far_distance_pool","fza_soundshader_cannon_very_far_distance_pool"};
    };
};