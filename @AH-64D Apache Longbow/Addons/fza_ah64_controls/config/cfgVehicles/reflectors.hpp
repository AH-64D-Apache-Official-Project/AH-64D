class Reflectors
{
    class landing_light
    {
        position  = "landing_light_beg";
        direction = "landing_light_end";
        hitpoint  = "landing_light_sel";
        selection = "landing_light_sel";
        color[] = {7000,7500,10000};
        ambient[] = {70,75,100};
        intensity = 100;
        size = 1;
        innerAngle = 15;
        outerAngle = 90;
        coneFadeCoef = 10;
        useFlare = 1;
        flareSize = 10;
        flareMaxDistance = 500;
        daylight = 1; //added
        class Attenuation
        {
            start = 0;
            constant = 0;
            linear = 1;
            quadratic = 1;
            hardLimitStart = 100;
            hardLimitEnd = 200;
        };
    };
    class Plt_floodLight
    {
        position  = "plt_flood_begin";
        direction = "plt_flood_end";
        hitpoint  = "plt_flood_sel";
        selection = "plt_flood_sel";
        color[]={0.306, 0.878, 0.349};
        ambient[] = {0.306, 0.878, 0.349};
        intensity = 25;
        size = 1;
        innerAngle = 30;
        outerAngle = 150;
        coneFadeCoef = 1;
        useFlare = 0;
        flareSize = 0;
        flareMaxDistance = 0;
        dayLight = 1;
        blinking = 0;
        class Attenuation
        {
            start           = 0;
            constant        = 0;
            linear          = 1;
            quadratic       = 2;
            hardLimitStart  = 0.65;
            hardLimitEnd    = 1.9;
        };
    };
    class cpg_floodlight: Plt_floodLight
    {
        position  = "cpg_flood_begin";
        direction = "cpg_flood_end";
        hitpoint  = "cpg_flood_sel";
        selection = "cpg_flood_sel";
    };
};