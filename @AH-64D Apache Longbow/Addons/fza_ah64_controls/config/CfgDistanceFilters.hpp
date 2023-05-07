class CfgDistanceFilters {

    class fza_weapons_lowpass_filter 
    {
        type = "lowpassfilter";
        mincutofffrequency = 1000;
        qfactor = 1;
        innerrange = 40;
        range = 1000;
        powerfactor = 55;
    };
    class fza_explosions_lowpass_filter 
    {
        type = "lowpassfilter";
        mincutofffrequency = 165;
        qfactor = 1;
        innerrange = 30;
        range = 2000;
        powerfactor = 32;
    };	
    class fza_wpn_echo_lp_dia 
    {
        type = "lowpassfilter";
        mincutofffrequency = 2500;
        qfactor = 1;
        innerrange = 30;
        range = 300;
        powerfactor = 75;
    };	
    class fza_basic_lp_dia 
    {
        type = "lowpassfilter";
        mincutofffrequency = 350;
        qfactor = 1;
        innerrange = 7;
        range = 150;
        powerfactor = 40;
    };
    class fza_explosion_tail_lowpass_filter 
    {
        type = "lowPassFilter";
        minCutoffFrequency = 200;
        qFactor = 1;
        innerRange = 50;
        range = 1000;
        powerFactor = 32;
    };
    
};