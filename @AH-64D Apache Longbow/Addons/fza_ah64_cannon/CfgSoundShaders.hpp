class CfgSoundShaders {

    /////////////////////////////////M230 30MM////////////////////////////////
    class fza_soundshader_cannon_close {
        samples[] = {{"fza_ah64_cannon\data\shot\Close_1.ogg", 1}};
        volume = "3.9810717*(1-interior/1.4)";
        range = 20;
        //rangeCurve[] = {{0, 1}, {20, 1}, {50, 0}};
        frequency = 1;
    };
    class fza_soundshader_cannon_close_distance {
        samples[] = {{"fza_ah64_cannon\data\shot\Close_Distance.ogg", 1}};
        volume = "3.9810717*(1-interior/1.4)";
        range = 300;
        rangeCurve[] = {{0, 0}, {10, 0.25}, {20, 0.5}, {50, 1}, {100, 1}, {300, 0}};
        frequency = 1;
    };
    class fza_soundshader_cannon_medium_distance {
        samples[] = {{"fza_ah64_cannon\data\shot\Medium_Distance.ogg", 1}};
        volume = 3.9810717;
        range = 600;
        rangeCurve[] = {{0, 0}, {100, 0}, {300, 1}, {600, 0}};
        frequency = 1;
    };
    class fza_soundshader_cannon_close_distance_pool {
        samples[] = {{"fza_ah64_cannon\data\shot\distance\shot_1.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_2.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_3.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_4.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_5.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_6.ogg", 1}};
        volume = 3.9810717;
        range = 1500;
        rangeCurve[] = {{0, 0}, {300, 0}, {600, 1}, {1500, 0}};
        frequency = 1;
    };
    class fza_soundshader_cannon_far_distance_pool {
        samples[] = {{"fza_ah64_cannon\data\shot\distance\shot_far_1.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_far_2.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_far_3.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_far_4.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_far_6.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_far_5.ogg", 1}};
        volume = 3.9810717;
        range = 2000;
        rangeCurve[] = {{0, 0}, {600, 0}, {1500, 1}, {2000, 0}};
        frequency = 1;
    };
    class fza_soundshader_cannon_very_far_distance_pool {
        samples[] = {{"fza_ah64_cannon\data\shot\distance\shot_very_far_1.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_very_far_2.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_very_far_3.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_very_far_4.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_very_far_6.ogg", 1}, {"fza_ah64_cannon\data\shot\distance\shot_very_far_5.ogg", 1}};
        volume = 3.9810717;
        range = 4000;
        rangeCurve[] = {{0, 0}, {600, 0}, {1500, 0}, {3000, 1}, {4000, 0}};
        frequency = 1;
    };


    ////////////////////////////Explosions////////////////////////////////
    class fza_soundshader_cannon_explosion_close_distance {
        samples[] = {{"fza_ah64_cannon\data\explosions\close_distance_1.ogg", 1}, {"fza_ah64_cannon\data\explosions\close_distance_2.ogg", 1}, {"fza_ah64_cannon\data\explosions\close_distance_3.ogg", 1}, {"fza_ah64_cannon\data\explosions\close_distance_4.ogg", 1}};
        volume = 1;
        range = 100;
        rangeCurve[] = {{0, 1}, {50, 0}};
    };
    class fza_soundshader_cannon_explosion_medium_distance {
        samples[] = {{"fza_ah64_cannon\data\explosions\medium_distance_2.ogg", 1}, {"fza_ah64_cannon\data\explosions\medium_distance_1.ogg", 1}, {"fza_ah64_cannon\data\explosions\medium_distance_3.ogg", 1}, {"fza_ah64_cannon\data\explosions\medium_distance_4.ogg", 1}};
        volume = 1.500000;
        range = 400;
        rangeCurve[] = {{0, 0}, {50, 1.500000}, {400, 0}};
    };
    class fza_soundshader_cannon_explosion_far_distance {
        samples[] = {{"fza_ah64_cannon\data\explosions\far_distance_1.ogg", 1}, {"fza_ah64_cannon\data\explosions\far_distance_2.ogg", 1}, {"fza_ah64_cannon\data\explosions\far_distance_3.ogg", 1}, {"fza_ah64_cannon\data\explosions\far_distance_4.ogg", 1}};
        volume = 1;
        range = 2000;
        rangeCurve[] = {{0, 0}, {50, 0}, {400, 1}, {2000, 0}};
    };
    

    ///////////////////////soniccracks////////////////////////////////
    class fza_soundshader_cannon_sonic_crack_close {
        samples[] = {{"fza_ah64_cannon\data\sonic_cracks\soniccrack_very_close_distance_1", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_very_close_distance_2", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_very_close_distance_3", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_very_close_distance_4", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_very_close_distance_5", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_very_close_distance_6", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_very_close_distance_7", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_very_close_distance_8", 1}};
        volume = 2;
        range = 5;
        rangeCurve[] = {{0, 1.500000}, {10, 1}, {20, 0}};
    };
    class fza_soundshader_cannon_sonic_crack_medium {
        samples[] = {{"fza_ah64_cannon\data\sonic_cracks\soniccrack_close_distance_1", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_close_distance_2", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_close_distance_3", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_close_distance_4", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_close_distance_5", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_close_distance_6", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_close_distance_7", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_close_distance_8", 1}};
        volume = 1.500000;
        range = 20;
        rangeCurve[] = {{0, 0}, {20, 1}, {100, 0}};
    };
    class fza_soundshader_cannon_sonic_crack_far {
        samples[] = {{"fza_ah64_cannon\data\sonic_cracks\soniccrack_medium_distance_1", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_medium_distance_2", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_medium_distance_3", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_medium_distance_4", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_medium_distance_5", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_medium_distance_6", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_medium_distance_7", 1}, {"fza_ah64_cannon\data\sonic_cracks\soniccrack_medium_distance_8", 1}};
        volume = 1;
        range = 700;
        rangeCurve[] = {{0, 0}, {20, 0}, {100, 1}, {700, 0}};
    };

    ////////////////////////Bullet Flyby////////////////////////////////
    class fza_soundshader_cannon_flyby 
    {
        samples[] = {{"fza_ah64_cannon\data\flyby\30mm_Flyby_1.ogg", 1}, {"fza_ah64_cannon\data\flyby\30mm_Flyby_2.ogg", 1}, {"fza_ah64_cannon\data\flyby\30mm_Flyby_3.ogg", 1}, {"fza_ah64_cannon\data\flyby\30mm_Flyby_4.ogg", 1}, {"fza_ah64_cannon\data\flyby\30mm_Flyby_5.ogg", 1}, {"fza_ah64_cannon\data\flyby\30mm_Flyby_6.ogg", 1}};
        volume = 1.000000;
        range = 200;
    };
};