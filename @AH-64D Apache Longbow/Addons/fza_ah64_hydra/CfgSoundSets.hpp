class CfgSoundSets {
    class fza_basic_soundset;
    class fza_basic_soniccrack_soundset;
    class fza_soundset_hydra_flyby: fza_basic_soniccrack_soundset {
        soundShaders[] = {"fza_soundshader_hydra_flyby"};
        volumefactor = 1;
        soundshaderslimit = 2;
    };
    class fza_soundset_hydra_explosion_stereo {
        soundShaders[] = {"fza_soundshader_hydra_explosion_stereo", "fza_soundshader_hydra_explosion_distance"};
        volumefactor = 0.750000;
        volumecurve = "fza_basic_vl_sin";
        spatial = 1;
        doppler = 0;
        loop = 0;
        soundshaderslimit = 2;
        sound3dprocessingtype = "fza_exp_stereo_medium_prc";
        distancefilter = "fza_basic_lp_dia";
        frequencyrandomizer = 3;
        occlusionfactor = 0.250000;
        obstructionfactor = 0.250000;
    };
    class fza_soundset_hydra_explosion_small {
        soundShaders[] = {"fza_small_explosion_close_distance_soundshader", "fza_soundshader_hydra_explosion_medium_distance", "fza_soundshader_hydra_explosion_far_distance", "fza_soundshader_hydra_explosion_very_far_distance", "fza_small_debris_regular_soundshader", "fza_small_debris_houses_soundshader"};
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
    class fza_soundset_hydra_explosion {
        soundShaders[] = {"fza_soundshader_submunition_explosion", "fza_soundshader_submunition_explosion_distance"};
        volumefactor = 0.750000;
        volumecurve = "fza_basic_vl_sin";
        spatial = 1;
        doppler = 0;
        loop = 0;
        soundshaderslimit = 2;
        sound3dprocessingtype = "fza_exp_stereo_medium_prc";
        distancefilter = "fza_basic_lp_dia";
        frequencyrandomizer = 3;
        occlusionfactor = 0.250000;
        obstructionfactor = 0.250000;
    };
    class fza_soundset_hydra_explosion_reverb {
        soundshaders[] = {"fza_explosion_echo_small_soundshader", "fza_explosion_echo_houses_soundshader", "fza_soundshader_hydra_reverb_houses", "fza_soundshader_hydra_reverb_forest", "fza_soundshader_hydra_reverb_meadow"};
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
    class fza_soundset_hydra_shot: fza_basic_soundset{
        soundShaders[] = {"fza_soundshader_hydra_shot_close","fza_soundshader_hydra_shot_close_distance","fza_soundshader_hydra_shot_medium_distance","fza_soundshader_hydra_shot_close_distance_pool","fza_soundshader_hydra_shot_far_distance_pool","fza_soundshader_hydra_shot_very_far_distance_pool"};
    };
};