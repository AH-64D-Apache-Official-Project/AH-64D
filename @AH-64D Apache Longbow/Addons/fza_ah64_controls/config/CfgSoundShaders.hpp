class CfgSoundShaders {
    class fza_sc_wire_flyby_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Flyby\wire_flyby_1.ogg", 1}, {"fza_ah64_model\audio\Flyby\wire_flyby_2.ogg", 1}};
        volume = 1;
        range = 200;
        rangecurve = "fza_basic_vl_sin";
        frequency = "((speed factor [250, 990]) * 0.1) + 1.05";
        limitation = 1;
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////EXPLOSIONS///////////////////////////////
    ///////////////////////////////////////////////////////////////////////

    class fza_rocket_explosion_close_distance_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Explosions\Rockets\close_distance_1.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\close_distance_2.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\close_distance_3.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\close_distance_4.ogg", 1}};
        volume = 1.500000;
        range = 100;
        rangeCurve[] = {{0, 1}, {50, 0}};
    };
    class fza_rocket_explosion_medium_distance_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Explosions\Rockets\medium_distance_1.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\medium_distance_2.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\medium_distance_3.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\medium_distance_4.ogg", 1}};
        volume = 1;
        range = 400;
        rangeCurve[] = {{0, 0}, {100, 1}, {400, 0}};
    };
    class fza_rocket_explosion_far_distance_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Explosions\Rockets\far_distance_1.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\far_distance_2.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\far_distance_3.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\far_distance_4.ogg", 1}};
        volume = 1;
        range = 800;
        rangeCurve[] = {{0, 0}, {50, 0}, {400, 1}, {800, 0}};
    };
    class fza_rocket_explosion_very_far_distance_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Explosions\Rockets\very_far_distance_1.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\very_far_distance_2.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\very_far_distance_3.ogg", 1}, {"fza_ah64_model\audio\Explosions\Rockets\very_far_distance_4.ogg", 1}};
        volume = 1;
        range = 3000;
        rangeCurve[] = {{0, 0}, {400, 0}, {800, 1}, {3000, 0}};
    };
    
    class fza_explosion_big_shockwave_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Explosions\Shockwave\big_explosion_shockwave_1.ogg", 1}, {"fza_ah64_model\audio\Explosions\Shockwave\big_explosion_shockwave_2.ogg", 1}, {"fza_ah64_model\audio\Explosions\Shockwave\big_explosion_shockwave_3.ogg", 1}, {"fza_ah64_model\audio\Explosions\Shockwave\big_explosion_shockwave_4.ogg", 1}, {"fza_ah64_model\audio\Explosions\Shockwave\big_explosion_shockwave_5.ogg", 1}, {"fza_ah64_model\audio\Explosions\Shockwave\big_explosion_shockwave_6.ogg", 1}, {"fza_ah64_model\audio\Explosions\Shockwave\big_explosion_shockwave_7.ogg", 1}, {"fza_ah64_model\audio\Explosions\Shockwave\big_explosion_shockwave_8.ogg", 1}};
        volume = 1.500000;
        range = 65;
        limitation = 1;
    };
    
    class fza_small_explosion_close_distance_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Explosions\Small\close_distance_1.ogg", 1}, {"fza_ah64_model\audio\Explosions\Small\close_distance_2.ogg", 1}, {"fza_ah64_model\audio\Explosions\Small\close_distance_3.ogg", 1}, {"fza_ah64_model\audio\Explosions\Small\close_distance_4.ogg", 1}};
        volume = 1;
        range = 100;
        rangeCurve[] = {{0, 1}, {50, 0}};
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////DEBRIS///////////////////////////////////
    ///////////////////////////////////////////////////////////////////////

    class fza_small_debris_regular_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Debris\meadow_1.ogg", 1}, {"fza_ah64_model\audio\Debris\meadow_2.ogg", 1}, {"fza_ah64_model\audio\Debris\meadow_3.ogg", 1}, {"fza_ah64_model\audio\Debris\meadow_4.ogg", 1}};
        volume = "2*(1-houses)";
        range = 100;
        rangeCurve[] = {{0, 1}, {20, 0.250000}, {100, 0}};
        limitation = 1;
    };
    class fza_small_debris_houses_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Debris\houses_1.ogg", 1}, {"fza_ah64_model\audio\Debris\houses_2.ogg", 1}, {"fza_ah64_model\audio\Debris\houses_3.ogg", 1}, {"fza_ah64_model\audio\Debris\houses_4.ogg", 1}};
        volume = "2*houses";
        range = 100;
        rangeCurve[] = {{0, 1}, {20, 0.250000}, {100, 0}};
        limitation = 1;
    };
    
    class fza_big_debris_regular_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Debris\Big\meadow_1.ogg", 1}, {"fza_ah64_model\audio\Debris\Big\meadow_2.ogg", 1}, {"fza_ah64_model\audio\Debris\Big\meadow_3.ogg", 1}, {"fza_ah64_model\audio\Debris\Big\meadow_4.ogg", 1}};
        volume = "2*(1-houses)";
        range = 100;
        rangeCurve[] = {{0, 1}, {20, 0.250000}, {100, 0}};
        limitation = 1;
    };
    class fza_big_debris_houses_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Debris\Big\houses_1.ogg", 1}, {"fza_ah64_model\audio\Debris\Big\houses_2.ogg", 1}, {"fza_ah64_model\audio\Debris\Big\houses_3.ogg", 1}, {"fza_ah64_model\audio\Debris\Big\houses_4.ogg", 1}};
        volume = "2*houses";
        range = 100;
        rangeCurve[] = {{0, 1}, {20, 0.250000}, {100, 0}};
        limitation = 1;
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////ECHO/////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_explosion_echo_small_soundshader 
    {
        samples[]  = {{"fza_ah64_model\audio\Echo\explo_s_1.ogg", 1}, {"fza_ah64_model\audio\Echo\explo_s_2.ogg", 1}, {"fza_ah64_model\audio\Echo\explo_s_3.ogg", 1}, {"fza_ah64_model\audio\Echo\explo_s_4.ogg", 1}, {"fza_ah64_model\audio\Echo\explo_s_5.ogg", 1}, {"fza_ah64_model\audio\Echo\explo_s_6.ogg", 1}};
        volume = 5.000000;
        range = 1000;
        rangeCurve[] = {{0, 0}, {30, 1}, {1000, 0}};
    };
    class fza_explosion_echo_medium_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Echo\Medium\explo_m_1.ogg", 1}, {"fza_ah64_model\audio\Echo\Medium\explo_m_2.ogg", 1}, {"fza_ah64_model\audio\Echo\Medium\explo_m_3.ogg", 1}, {"fza_ah64_model\audio\Echo\Medium\explo_m_4.ogg", 1}, {"fza_ah64_model\audio\Echo\Medium\explo_m_5.ogg", 1}, {"fza_ah64_model\audio\Echo\Medium\explo_m_6.ogg", 1}, {"fza_ah64_model\audio\Echo\Medium\explo_m_7.ogg", 1}, {"fza_ah64_model\audio\Echo\Medium\explo_m_8.ogg", 1}, {"fza_ah64_model\audio\Echo\Medium\explo_m_9.ogg", 1}, {"fza_ah64_model\audio\Echo\Medium\explo_m_10.ogg", 1}};
        volume = 5.000000;
        range = 1000;
        rangeCurve[] = {{0, 0}, {30, 1}, {1000, 0}};
    };
    class fza_explosion_echo_houses_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Echo\houses_1.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_2.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_3.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_4.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_5.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_6.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_7.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_8.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_9.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_10.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_11.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_12.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_14.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_15.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_16.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_17.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_18.ogg", 1}, {"fza_ah64_model\audio\Echo\houses_19.ogg", 1}};
        volume = "5 * houses";
        range = 1000;
        rangeCurve[] = {{0, 0}, {30, 1}, {1000, 0}};
    };

    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////REVERB///////////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_shell_explosion_reverb_forest_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Echo\Reflections\forest.ogg", 1}};
        volume = "forest";
        range = 500;
        limitation = 1;
        rangeCurve[] = {{0, 1}, {100, 0.500000}, {500, 0}};
    };
    class fza_shell_explosion_reverb_houses_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Echo\Reflections\houses.ogg", 1}};
        volume = "houses";
        range = 500;
        limitation = 1;
        rangeCurve[] = {{0, 1}, {100, 0.500000}, {500, 0}};
    };
    class fza_shell_explosion_reverb_meadow_soundshader 
    {
        samples[] = {{"fza_ah64_model\audio\Echo\Reflections\meadow.ogg", 1}};
        volume = "meadows max sea";
        range = 500;
        limitation = 1;
        rangeCurve[] = {{0, 1}, {100, 0.500000}, {500, 0}};
    };
};