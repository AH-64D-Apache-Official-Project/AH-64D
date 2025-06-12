class CfgSoundShaders {
    class fza_soundshader_hydra_flyby 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\flyby\rocket_flyby_1.ogg", 1}, {"fza_ah64_hydra\data\audio\flyby\rocket_flyby_2.ogg", 1}, {"fza_ah64_hydra\data\audio\flyby\rocket_flyby_3.ogg", 1}, {"fza_ah64_hydra\data\audio\flyby\rocket_flyby_4.ogg", 1}, {"fza_ah64_hydra\data\audio\flyby\rocket_flyby_5.ogg", 1}, {"fza_ah64_hydra\data\audio\flyby\rocket_flyby_6.ogg", 1}};
        volume = 1;
        range = 200;
        rangecurve = "fza_basic_vl_sin";
        frequency = "((speed factor [250, 990]) * 0.1) + 1.05";
        limitation = 1;
    };
    class fza_soundshader_hydra_explosion_stereo 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\rocket.ogg", 1}};
        volume = 1;
        range = 400;
        rangeCurve[] = {{0, 1}, {400, 0}};
        limitation = 1;
    };
    class fza_soundshader_hydra_explosion_distance 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\rocket_distance.ogg", 1}};
        volume = 1;
        range = 1000;
        rangeCurve[] = {{0, 0}, {400, 1}, {1000, 0}};
        limitation = 1;
    };

    class fza_soundshader_hydra_explosion_medium_distance 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\explosion\medium_distance_1.ogg", 1}, {"fza_ah64_hydra\data\audio\explosion\medium_distance_2.ogg", 1}, {"fza_ah64_hydra\data\audio\explosion\medium_distance_3.ogg", 1}, {"fza_ah64_hydra\data\audio\explosion\medium_distance_4.ogg", 1}};
        volume = 1.500000;
        range = 400;
        rangeCurve[] = {{0, 0}, {50, 1.500000}, {400, 0}};
    };
    class fza_soundshader_hydra_explosion_far_distance 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\explosion\far_distance_1.ogg", 1}, {"fza_ah64_hydra\data\audio\explosion\far_distance_2.ogg", 1}, {"fza_ah64_hydra\data\audio\explosion\far_distance_3.ogg", 1}, {"fza_ah64_hydra\data\audio\explosion\far_distance_4.ogg", 1}};
        volume = 1;
        range = 800;
        rangeCurve[] = {{0, 0}, {50, 0}, {400, 1}, {800, 0}};
    };
    class fza_soundshader_hydra_explosion_very_far_distance 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\explosion\very_far_distance_1.ogg", 1}, {"fza_ah64_hydra\data\audio\explosion\very_far_distance_2.ogg", 1}, {"fza_ah64_hydra\data\audio\explosion\very_far_distance_3.ogg", 1}, {"fza_ah64_hydra\data\audio\explosion\very_far_distance_4.ogg", 1}};
        volume = 1;
        range = 2000;
        rangeCurve[] = {{0, 0}, {400, 0}, {800, 1}, {2000, 0}};
    };

    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////REVERB///////////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    

    class fza_soundshader_hydra_reverb_houses 
    {
        samples[] = {{"fza_ah64_model\audio\Echo\Reflections\Small\houses.ogg", 1}};
        volume = "houses";
        range = 500;
        limitation = 1;
        rangeCurve[] = {{0, 1}, {100, 0.500000}, {500, 0}};
    };
    class fza_soundshader_hydra_reverb_meadow 
    {
        samples[] = {{"fza_ah64_model\audio\Echo\Reflections\Small\meadow.ogg", 1}};
        volume = "meadows max sea";
        range = 500;
        limitation = 1;
        rangeCurve[] = {{0, 1}, {100, 0.500000}, {500, 0}};
    };
    class fza_soundshader_hydra_reverb_forest 
    {
        samples[] = {{"fza_ah64_model\audio\Echo\Reflections\Small\forest.ogg", 1}};
        volume = "forest";
        range = 500;
        limitation = 1;
        rangeCurve[] = {{0, 1}, {100, 0.500000}, {500, 0}};
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////ROCKETS//////////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_soundshader_hydra_shot_close 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\M261_1", 0.5}, {"fza_ah64_hydra\data\audio\M261_2", 0.5}};
        volume = "4*(1-interior/1.4)";
        range = 20;
        //rangeCurve[] = {{0, 1}, {20, 1}, {50, 0}};
        frequency = 1;
    };
    class fza_soundshader_hydra_shot_close_distance 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\Close_Distance.ogg", 1}};
        volume = "3.9810717*(1-interior/1.4)";
        range = 300;
        rangeCurve[] = {{0, 0}, {10, 0.25}, {20, 0.5}, {50, 1}, {100, 1}, {300, 0}};
        frequency = 1;
    };
    class fza_soundshader_hydra_shot_medium_distance 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\Medium_Distance.ogg", 1}};
        volume = 4;
        range = 600;
        rangeCurve[] = {{0, 0}, {100, 0}, {300, 1}, {600, 0}};
        frequency = 1;
    };
    class fza_soundshader_hydra_shot_close_distance_pool 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\distance\shot_1.ogg", 1}, {"fza_ah64_hydra\data\audio\distance\shot_2.ogg", 1}};
        volume = 4;
        range = 1500;
        rangeCurve[] = {{0, 0}, {300, 0}, {600, 1}, {1500, 0}};
        frequency = 1;
    };
    class fza_soundshader_hydra_shot_far_distance_pool 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\distance\shot_far_1.ogg", 1}, {"fza_ah64_hydra\data\audio\distance\shot_far_2.ogg", 1}};
        volume = 4;
        range = 2000;
        rangeCurve[] = {{0, 0}, {600, 0}, {1500, 1}, {2000, 0}};
        frequency = 1;
    };
    class fza_soundshader_hydra_shot_very_far_distance_pool 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\distance\shot_very_far_1.ogg", 1}, {"fza_ah64_hydra\data\audio\distance\shot_very_far_2.ogg", 1}};
        volume = 4;
        range = 4000;
        rangeCurve[] = {{0, 0}, {600, 0}, {1500, 0}, {3000, 1}, {4000, 0}};
        frequency = 1;
    };

    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////MPSM/////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////

    class fza_soundshader_submunition_explosion 
    {
        samples[]  = {{"fza_ah64_hydra\data\audio\explosion\Explosions\he.ogg", 1}};
        volume = 1;
        range = 150;
        rangeCurve[] = {{0, 1}, {150, 0}};
        limitation = 1;
    };
    class fza_soundshader_submunition_explosion_distance 
    {
        samples[] = {{"fza_ah64_hydra\data\audio\explosion\Explosions\he_distance.ogg", 1}};
        volume = 1;
        range = 500;
        rangeCurve[] = {{0, 0}, {150, 1}, {500, 0}};
        limitation = 1;
    };
};