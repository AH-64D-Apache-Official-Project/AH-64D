class CfgSoundShaders {
    class fza_soundshader_hellfire_close {
        samples[] = {{"fza_ah64_hellfire\data\audio\Missile_small_close_1.ogg", 1}};
        volume = "4*(1-interior/1.4)";
        range = 100;
        frequency = 1;
    };
    class fza_soundshader_hellfire_close_distance {
        samples[] = {{"fza_ah64_hellfire\data\audio\Close_Distance.ogg", 1}};
        volume = "4*(1-interior/1.4)";
        range = 300;
        rangeCurve[] = {{0, 0}, {10, 0.25}, {20, 0.5}, {50, 1}, {100, 1}, {300, 0}};
        frequency = 1;
    };
    class fza_soundshader_hellfire_medium_distance {
        samples[] = {{"fza_ah64_hellfire\data\audio\distance\Missile_small_dist_1.ogg", 1},{"fza_ah64_hellfire\data\audio\distance\Missile_small_dist_2.ogg", 1},{"fza_ah64_hellfire\data\audio\distance\Missile_small_dist_3.ogg", 1}};
        volume = 3.9810717;
        range = 600;
        rangeCurve[] = {{0, 0}, {100, 0}, {300, 1}, {600, 0}};
        frequency = 1;
    };
    class fza_soundshader_hellfire_close_distance_pool {
        samples[] = {{"fza_ah64_hellfire\data\audio\distance\shot_1.ogg", 1}};
        volume = 3.9810717;
        range = 1500;
        rangeCurve[] = {{0, 0}, {300, 0}, {600, 1}, {1500, 0}};
        frequency = 1;
    };
    class fza_soundshader_hellfire_far_distance_pool {
        samples[] = {{"fza_ah64_hellfire\data\audio\distance\shot_far_1.ogg", 1}};
        volume = 3.9810717;
        range = 2000;
        rangeCurve[] = {{0, 0}, {600, 0}, {1500, 1}, {2000, 0}};
        frequency = 1;
    };
    class fza_soundshader_hellfire_very_far_distance_pool {
        samples[] = {{"fza_ah64_hellfire\data\audio\distance\shot_very_far_1.ogg", 1}};
        volume = 3.9810717;
        range = 4000;
        rangeCurve[] = {{0, 0}, {600, 0}, {1500, 0}, {3000, 1}, {4000, 0}};
        frequency = 1;
    };


    class fza_soundshader_hellfire_explosion_stereo 
    {
        samples[] = {{"fza_ah64_hellfire\data\audio\missile.ogg", 1}};
        volume = 1;
        range = 700;
        rangeCurve[] = {{0, 1}, {700, 0}};
        limitation = 1;
    };
    class fza_soundshader_hellfire_explosion_distance 
    {
        samples[] = {{"fza_ah64_hellfire\data\audio\missile_distance.ogg", 1}};
        volume = 1;
        range = 1500;
        rangeCurve[] = {{0, 0}, {700, 1}, {1500, 0}};
        limitation = 1;
    };
};