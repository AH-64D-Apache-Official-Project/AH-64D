class CfgAmmo {
    class MissileBase;
    class GrenadeBase;
    class FlareCore;
    class B_9x21_Ball;

    class fza_275_base: MissileBase 
    {
        airLock                     = 0;
        irLock                      = 0;
        laserLock                   = 0;
        maneuvrability              = 0;
        weaponLockSystem            = 0;
        simulation                  = "shotRocket";
        manualControl               = 0;
        maxControlRange             = 0;

        ace_frag_enabled            = 0;
        ace_frag_skip               = 1;

        fza_wpnPageIconB            = "";
        fza_wpnPageIconG            = "";
        fza_shortCode               = "";
        fza_weaponName              = "";

        soundfly[]                  = {"fza_ah64_model\audio\Flyby\SoundFly1.ogg", 1, 1, 400};
        soundsetexplosion[]         = {"fza_rocket_explosion_soundset", "fza_soundset_hydra_explosion_stereo", "fza_shell_explosion_reverb_soundset"};
        soundsetsoniccrack[]        = {"fza_soundset_hydra_flyby"};
        model                       = "\fza_ah64_hydra\fza_hydra_m151_wep";
        explosionEffects            = "GrenadeExplosion";
        effectsmissile              = "fza_hydraEffect";
        effectsMissileInit          = "";
        muzzleEffect                = "";
        effectFly                   = "";

        hit                         = 30;
        indirectHit                 = 4;
        indirectHitRange            = 2;

        //AI uasge
        aiAmmoUsageFlags            = "128+512";
        allowAgainstInfantry        = 1;
        cost                        = 75;
        aiRateOfFire                = 0.3;
        aiRateOfFireDistance        = 0;

        weaponType                  = "rocket";
        suppressionRadiusHit        = 15;
        dangerRadiusHit             = 40;
        initTime                    = 0.02;
        maxSpeed                    = 840;
        thrustTime                  = 0.5;
        thrust                      = 1700;
        fuseDistance                = 75;
        airFriction                 = 0.05;
        sideAirFriction             = 0.004;
        timeToLive                  = 17;
        whistleDist                 = 24;

        class CamShakeExplode
        {
            power = 16;
            duration = 1.8;
            frequency = 20;
        };
        class CamShakeHit
        {
            power = 80;
            duration = 0.6;
            frequency = 20;
        };
    };
    class fza_275_m151: fza_275_base
    {
        ace_frag_enabled            = 1;
        ace_frag_skip               = 0;
        fza_shortCode               = "6PD";
        fza_weaponName              = "fza_275_m151_wep";
        model                       = "\fza_ah64_hydra\fza_hydra_m151_wep";
        proxyShape                  = "\fza_ah64_hydra\fza_hydra_m151";
        hit                         = 60;
        indirectHit                 = 40;
        indirectHitRange            = 13;
        suppressionRadiusHit        = 20;
    };
    class fza_275_m255a1: fza_275_base 
    {
        fza_shortCode               = "6FL";
        fza_weaponName              = "fza_275_m255a1_wep";
        model                       = "\fza_ah64_hydra\fza_hydra_m261_wep";
        proxyShape                  = "\fza_ah64_hydra\fza_hydra_m261";
        CraterEffects               = "ATMissileCrater";

        submunitionDirectionType    ="SubmunitionModelDirection";
        submunitionAmmo             = "fza_flec_cluster";
        submunitionConeType[]       = {"randomcenter",100};
        submunitionConeAngle        = 12;
        triggerDistance             = 200;
        submunitionInitSpeed        = 500;
        deleteParentWhenTriggered   = 1;
        submunitionInitialOffset[]  = {0,0,2};

        soundHit1[]                 = {"A3\sounds_f\dummysound",2.5118864,1,5};
        multiSoundHit[]             = {"soundHit1",1};

        //AI uasge
        aiAmmoUsageFlags            = "64+128";
        cost                        = 100;
    };
    class fza_275_m257: fza_275_base 
    {
        fza_shortCode               = "6IL";
        fza_weaponName              = "fza_275_m257_wep";
        model                       = "\fza_ah64_hydra\fza_hydra_m261_wep";
        proxyShape                  = "\fza_ah64_hydra\fza_hydra_m261";
        CraterEffects               = "ATMissileCrater";

        submunitionAmmo             = "fza_m257_flare";
        submunitionCount            = 1;
        submunitionConeAngle        = 0;
        deleteParentWhenTriggered   = 1;

        triggerTime                 = 5.6;
        soundHit1[]                 = {"A3\sounds_f\dummysound",2.5118864,1,5};
        multiSoundHit[]             = {"soundHit1",1};

        //AI uasge
        aiAmmoUsageFlags            = "1";
        allowAgainstInfantry        = 0;
    };
    class fza_275_m261: fza_275_base 
    {
        fza_shortCode               = "6MP";
        fza_weaponName              = "fza_275_m261_wep";
        model                       = "\fza_ah64_hydra\fza_hydra_m261_wep";
        proxyShape                  = "\fza_ah64_hydra\fza_hydra_m261";

        submunitionDirectionType    = "SubmunitionModelDirection";
        submunitionAmmo             = "fza_m73mpsm";
        submunitionConeType[]       = {"randomcenter",9};
        submunitionConeAngle        = 2;
        triggerDistance             = 500;
        submunitionInitSpeed        = 500;
        deleteParentWhenTriggered   = 1;
        
        //AI uasge
        aiAmmoUsageFlags            = "64+128";
        cost                        = 100;
    };
    class fza_275_m278: fza_275_base 
    {
        fza_shortCode               = "6IR";
        fza_weaponName              = "fza_275_m278_wep";
        model                       = "\fza_ah64_hydra\fza_hydra_m261_wep";
        proxyShape                  = "\fza_ah64_hydra\fza_hydra_m261";
        CraterEffects               = "ATMissileCrater";

        submunitionAmmo             = "fza_m278_flare";
        submunitionCount            = 1;
        submunitionConeAngle        = 0;
        deleteParentWhenTriggered   = 1;

        triggerTime                 = 5.4;
        soundHit1[]                 = {"A3\sounds_f\dummysound",2.5118864,1,5};
        multiSoundHit[]             = {"soundHit1",1};

        //AI uasge
        aiAmmoUsageFlags            = "1";
        allowAgainstInfantry        = 0;
    };
    
    ///////////////////////////////////////////////////////////////////////
    //////////////////////////////SUBMUNITIONS/////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    class fza_m73mpsm: GrenadeBase
    {
        ace_frag_enabled            = 1;
        ace_frag_skip               = 0;

        soundsetexplosion[]         = {"fza_soundset_hydra_explosion_small", "fza_soundset_hydra_explosion", "fza_soundset_hydra_explosion_reverb"};
        simulation                  = "shotShell";
        model                       = "\A3\weapons_f\ammo\UGL_slug"; //M73 model needed.
        explosionEffects            = "ExploAmmoExplosion";
        CraterEffects               = "ExploAmmoCrater";
        muzzleEffect                = "";
        hit                         = 30;
        indirectHit                 = 15;
        indirectHitRange            = 20;
        visibleFire                 = 1;
        audibleFire                 = 30;
        visibleFireTime             = 3;
        dangerRadiusHit             = 60;
        suppressionRadiusHit        = 30;
        explosive                   = 1;
        deflecting                  = 0;
        airFriction                 = -0.001;
        fuseDistance                = 30;
        whistleDist                 = 16;
        typicalSpeed                = 300;
        caliber                     = 3.7;
        soundHit1[] = {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_01",1.7782794,1,1600};
        soundHit2[] = {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_02",1.7782794,1,1600};
        soundHit3[] = {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_03",1.7782794,1,1600};
        soundHit4[] = {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_04",1.7782794,1,1600};
        multiSoundHit[] = {"soundHit1",0.25,"soundHit2",0.25,"soundHit3",0.25,"soundHit4",0.25};
    };
    class fza_m257_flare: FlareCore
    {
        timeToLive                  = 100;
        model                       = "\A3\Weapons_F\Ammo\UGL_Flare";
        lightColor[]                = {1,0.8,0.7,0.5};
        smokeColor[]                = {1,1,1,0.4};
        effectFlare                 = "CounterMeasureFlare";
        brightness                  = 0.1;
        size                        = 3;
        triggerTime                 = 0.25;
        triggerSpeedCoef            = 1;
        audibleFire                 = 20;
        intensity                   = 1000000;
    };
    class fza_m278_flare: fza_m257_flare
    {
        irLight                     = 1;
        intensity                   = 300000;
    };
    class fza_flec_cluster: B_9x21_Ball
    {
        ace_frag_enabled            = 0;
        ace_frag_skip               = 1;
        
        hit                         = 6;
        indirectHit                 = 6;
        indirectHitRange            = 4;
        deflecting                  = 0;
        fuseDistance                = 50;
        effectFly                   = "fza_ah64_deploysmoke";
    };
};