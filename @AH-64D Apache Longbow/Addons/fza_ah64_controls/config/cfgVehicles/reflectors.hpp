class Reflectors
{
    class Landing_Light
    {
        position = "landing_light";
        direction = "landing_light_dir";
        hitpoint = "landing_light";
        selection = "Light";
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
};