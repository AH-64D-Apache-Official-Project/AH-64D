class MarkerLights
{
    class PositionWhite
    {
        name = "tail_light";
        ambient[] = {0.1,0.1,0.1};
        color[] = {1,1,1};
        drawLightSize = 0.50;
        drawLightCenterSize = 0.16;
        activeLight = 0;
        blinking = 0;
        dayLight = 0;
        drawLight = 1;
        intensity = 75;
        useFlare = 0;
        class Attenuation
        {
            constant = 0;
            hardLimitEnd = 1;
            hardLimitStart = 0.75;
            linear = 25;
            quadratic = 50;
            start = 0;
        };
    };
    class PositionGreen: PositionWhite
    {
        name = "zeleny pozicni";
        ambient[] = {0,0.08,0};
        color[] = {0,0.8,0};
        drawLightSize = 0.50;
        drawLightCenterSize = 0.16;
    };
    class PositionRed: PositionWhite
    {
        name = "cerveny pozicni";
        ambient[] = {0.08,0,0};
        color[] = {0.8,0,0};
        drawLightSize = 0.50;
        drawLightCenterSize = 0.16;
    };
    class RedStrobe_1
    {
        name="cerveny pozicni blik_1";
        color[]={0.89999998,0.15000001,0.1};
        ambient[]={0.090000004,0.015,0.0099999998};
        intensity=2500;
        drawLightSize = 0.50;
        drawLightCenterSize = 0.16;
        blinking = 1;
        blinkingPattern[]={0.03,2.10};
        blinkingPatternGuarantee = 1;
        daylight = 1;
    };
    class RedStrobe_2
    {
        name="cerveny pozicni blik_2";
        color[]={0.89999998,0.15000001,0.1};
        ambient[]={0.090000004,0.015,0.0099999998};
        intensity=2500;
        drawLightSize = 0.50;
        drawLightCenterSize = 0.16;
        blinking = 1;
        blinkingPattern[]={0.03,2};
        blinkingPatternGuarantee = 1;
        daylight = 1;
    };
};