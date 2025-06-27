class CfgSoundSets {

    class fza_basic_soundset;
    class fza_soundset_hellfire_explosion {
        soundShaders[] = {"fza_soundshader_hellfire_explosion_stereo", "fza_soundshader_hellfire_explosion_distance"};
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
    class fza_soundset_hellfire_shot: fza_basic_soundset {
        soundShaders[] = {"fza_soundshader_hellfire_close","fza_soundshader_hellfire_close_distance","fza_soundshader_hellfire_medium_distance","fza_soundshader_hellfire_close_distance_pool","fza_soundshader_hellfire_far_distance_pool","fza_soundshader_hellfire_very_far_distance_pool"};
    };
};