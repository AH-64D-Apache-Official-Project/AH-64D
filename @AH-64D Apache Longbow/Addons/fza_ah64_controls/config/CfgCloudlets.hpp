class CfgCloudlets
{
    class Default;
    class Missile4;
    class ObjectDestructionRefract;
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
    class fza_ah64_redSmoke: Default
    {
        animationSpeed[] = {0};
        animationSpeedCoef = 1;
        circleRadius = 0;
        circleVelocity[] = {0.2,0.2,0.2};
        color[] = {{0.4,0,0,0.8},{0.4,0,0,0.7},{0.4,0,0,0.6},{0.4,0,0,0.5},{0,0,0,0}};
        interval = 1;
        lifeTime = 7;
        particleFSNtieth = 16;
        particleFSIndex = 12;
        particleFSFrameCount = 40;
        particleFSLoop = 1;
        particleShape = "\A3\data_f\ParticleEffects\Universal\Universal";
        particleType = "Billboard";
        position[] = {0,0,0};
        positionVar[] = {0.5,0.5,0.5};
        randomDirectionIntensity = 0.2;
        randomDirectionIntensityVar = 0;
        randomDirectionPeriod = 0.1;
        randomDirectionPeriodVar = 0;
        rubbing = 0.2;
        size[] = {0.6,1.2,1.5,1.75,1.85,2};
        sizeCoef = 1;
        sizeVar = 0.3;
        timerPeriod = 0.5;
        volume = 0.1;
        weight = 0.1275;
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
class fza_ah64_deploysmoke
{
    class MissileEffects1
    {
        simulation = "particles";
        type = "fza_ah64_redSmoke";
        position[] = {0,0,0};
        intensity = 1;
        interval = 1;
        lifeTime = 0.01;
    };
};