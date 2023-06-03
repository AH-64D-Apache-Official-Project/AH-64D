class CfgAmmo {
    class Bulletbase;
    class FlareCore;
        
    class fza_ah64_Chaff_shot: Bulletbase
    {
        hit                         = 1;
        timeToLive                  = 14;
        thrustTime                  = 4;
        airFriction                 = -0.01;
        simulation                  = "shotCM";
        effectsSmoke                = "fza_CounterMeasureChaff";
        weaponLockSystem            = 8;
        model                       = "\A3\weapons_f\empty";
        maxControlRange             = -1;
        initTime                    = 0;
        aiAmmoUsageFlags            = 8;
    };
    class fza_ah64_flare_shot: fza_ah64_Chaff_shot
    {
        effectsSmoke                = "fza_AC130_Flares";
        weaponLockSystem            = 2;

    }
    class fza_IR_JAMMING_shot: FlareCore 
    {
        hit                         = 0;
        indirectHit                 = 0;
        indirectHitRange            = 0;
        timeToLive                  = 15;
        thrustTime                  = 4;
        airFriction                 = -0.01;
        simulation                  = "shotCM";
        effectsSmoke                = "";
        weaponLockSystem            = 2;
        model                       = "\A3\weapons_f\empty";
        maxControlRange             = -1;
        initTime                    = 0;
        aiAmmoUsageFlags            = 8;
    };
};
    ///////////////////////////////////////////////////////////////////////
    ////////////////////////USAF Flares From AC130 Beta////////////////////
    ////////////////////////Permission for use from pingopete//////////////
    ////////////////////////anyone wishing to use this/////////////////////
    ////////////////////////code and effect must contact///////////////////
    //////////////////////////////// pingopete ////////////////////////////

class fza_AC130_Flares
{
    class fza_FlareSmokeLong_VERYLOW
    {
        simulation="particles";
        type="fza_FlareSmokeLong_LOW";
        position[]={0,0,0};
        intensity=1;
        interval=1;
        lifeTime=4.5;
        qualityLevel=0;
        enabled=1;
    };
    class fza_FlareLightMain_LOW
    {
        simulation="light";
        type="fza_FlareLightMain";
        position[]={0,0,0};
        intensity=1;
        interval=1;
        lifeTime=3.5;
        qualityLevel=1;
        enabled=1;
    };
    class fza_FlareLightMain
    {
        simulation="light";
        type="fza_FlareLightMain";
        position[]={0,0,0};
        intensity=1;
        interval=1;
        lifeTime=3.5;
        qualityLevel=0;
        enabled=1;
    };
    class fza_FlareLightwhite
    {
        simulation="light";
        type="fza_FlareLightwhite";
        position[]={0,0,0};
        intensity=1;
        interval=1;
        lifeTime=4;
        enabled=1;
    };
    class fza_Flare_DayTime
    {
        simulation = "particles";
        type = "Cmeasures2";
        position[] = {0,0,0};
        intensity = 4;
        interval = 1;
        lifeTime = 3.2;
    };
};

class fza_CounterMeasureChaff
{
	class Cmeasures3
	{
		simulation = "particles";
		type = "Cmeasures3";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 0.05;
	};
};
