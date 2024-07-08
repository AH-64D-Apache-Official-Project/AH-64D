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
    

    class fza_Close_Engine_Filter {
        type="lowpassfilter";
        mincutofffrequency=100;
        qfactor=1.0;
        innerrange=0;
        range=1200;
        powerfactor=10;
    };
    class fza_Distant_Engine_Filter: fza_Close_Engine_Filter {
        mincutofffrequency=200;
        innerrange=1000;
        range=4000;
        powerfactor=18;
    };
    class fza_Distant_Apu_Filter: fza_Close_Engine_Filter {
        range=400;
    };
    class fza_Distant_Int_Filter: fza_Close_Engine_Filter {
        range=1;
    };
};