class CfgCloudlets
{
    class Default;
    class Missile4;
    class ObjectDestructionRefract;
    class fza_FlareSmokeLong_LOW: Default
    {
        interval=0.02;
        circleRadius=0;
        circleVelocity[]={0,0,0};
        particleShape="fza_ah64_us\cloudSmall1.p3d";
        particleFSNtieth=1;
        particleFSIndex=0;
        particleFSFrameCount=1;
        particleFSLoop=1;
        angle=0;
        angleVar=360;
        animationName="";
        particleType="Billboard";
        timerPeriod=1;
        lifeTime=0.67;
        moveVelocity[]={0,0,0};
        rotationVelocity=0;
        weight=1;
        volume=0.80000001;
        rubbing=0.1;
        size[]={0.30000002,0.9,1,1.03,1.01,1.1,1.15,1.24};
        sizeVar=0.40000001;
        color[]=
        {
            {1,1,1,0.40000001},
            {1,1,1,0.2},
            {1,1,1,0}
        };
        animationSpeed[]={0.5};
        randomDirectionPeriod=0;
        randomDirectionIntensity=0;
        onTimerScript="";
        beforeDestroyScript="";
        lifeTimeVar=0;
        positionVar[]={0,0,0};
        MoveVelocityVar[]={0.050000001,0.050000001,0.050000001};
        rotationVelocityVar=15;
        ignoreWind=0;
        colorVar[]={0,0,0,0};
        randomDirectionPeriodVar=0;
        randomDirectionIntensityVar=0;
        destroyOnWaterSurface=1;
    };
    class fzaHydraTrailSmoke: Missile4
    {
        weight = 1;
        rubbing= 0.5;
        color[]=
        {
            {0.06,0.04,0.04, 0.06}
        };
    };
    class hellfireHeatBlur: ObjectDestructionRefract
    {
        weight = 1;
        rubbing= 0;
        size[] = {1.8,2.4};
    };
    class hydraHeatBlur : hellfireHeatBlur
    {
        size[] = {0.25,0.5};
    };
};

class CfgLights
{
    class fza_FlareLightMain
    {
        ambient[]={1,0.9,0.1,0.003,0};
        diffuse[]={1,0.9,0.1};
        color[]={1,0.9,0.1};
        brightness=0.8;
        size=1;
        drawLight=0;
        blinking="false";
        flareSize=2;
        flareMaxDistance=10000;
        useFlare=1;
        shape="fza_ah64_us\flare2single.p3d";
        class Attenuation
        {
            start=0;
            constant=0;
            linear=0;
            quadratic=0;
            hardLimitStart=1;
            hardLimitEnd=0;
        };
        position[]={0,0,0};
    };
    class fza_FlareLightwhite
    {
        diffuse[]={1,1,0.8};
        color[]={1,1,0.8};
        ambient[]={0,0,0,0};
        brightness=1;
        size=1;
        drawLight=0;
        blinking="false";
        flareSize=3;
        flareMaxDistance=10000;
        useFlare=1;
        shape="fza_ah64_us\flare2single.p3d";
        class Attenuation
        {
            start=0;
            constant=0;
            linear=0;
            quadratic=0;
            hardLimitStart=0.0099999998;
            hardLimitEnd=0.0099999998;
        };
        position[]={0,0,0};
    };
};
class fza_hellfirelight
{
    class motorLight
    {
        simulation = "light";
        type = "RocketLight";
        position[] = {0,0,0};
        intensity = 0.01;
        interval = 1;
        lifeTime = 1;
    };
    class heatblur
    {
        simulation = "particles";
        type = "hellfireHeatBlur";
        lifeTime = 3;
    };
};
class fza_hydraEffect
{
    class motorLight
    {
        simulation = "light";
        type = "RocketLight";
        position[] = {0,0,0};
        intensity = 0.01;
        interval = 1;
        lifeTime = 1;
    };
    class heatblur
    {
        simulation = "particles";
        type = "hydraHeatBlur";
        lifeTime = 0.5;
    };
    class trailSmoke
    {
        simulation = "particles";
        type = "fzaHydraTrailSmoke";
        position[] = {0,0,0};
        intensity = 0.005;
        interval = 1;
        lifeTime = 1;
    };
};