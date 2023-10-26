class CfgAmmo {
    class ammo_Penetrator_Base;
    class M_Scalpel_AT;

    class ACE_Hellfire_AGM114K: M_Scalpel_AT {
        class Components;
    };
    class Fza_Penetrator_9KG_Tandem: ammo_Penetrator_Base
    {
        caliber = 60;
        warheadName = "TandemHEAT";
        hit = 1650;
        ace_vehicle_damage_incendiary = 1;
    };
    class Fza_Penetrator_8KG: ammo_Penetrator_Base
    {
        caliber = 60;
        warheadName = "HEAT";
        hit = 780;
        ace_vehicle_damage_incendiary = 0.7;
    };
    class fza_agm114base : ACE_Hellfire_AGM114K {

        ace_frag_enabled            = 1;
        ace_frag_skip               = 0;
        ace_frag_force              = 1;
        ace_vehicle_damage_incendiary = 0.3;

        fza_salType                 = "sal2";

        maxSpeed                    = 450;
        simulationStep              = 0.005;
		airFriction                 = 0.056; //-0.0350;
		sideAirFriction             = 0.03;  //-0.0250;
        initTime                    = 0.1;
        thrustTime                  = 2.5;
        thrust                      = 200;
        fuseDistance                = 100;
        timeToLive                  = 40;
        explosionTime               = 39;
        cmImmunity                  = 0.97;

        //AI uasge
        aiAmmoUsageFlags            = "64+128+512";
        allowAgainstInfantry        = 1;
        cost                        = 1000;
        minRange                    = 300;
        minRangeProbab              = 0.7;
        midRange                    = 3500;
        midRangeProbab              = 1.0;
        xRange                    = 8000;
        maxRangeProbab              = 0.8;

        //Penetrator
        submunitionAmmo             ="Fza_Penetrator_9KG_Tandem";
        submunitionDirectionType    ="SubmunitionModelDirection";
        submunitionInitSpeed        =1000;
        submunitionParentSpeedCoef  =1;
        submunitionInitialOffset[]  ={0,0,-0.2};
        triggerOnImpact             =1;
        deleteParentWhenTriggered   =0;

        effectsmissile              = "fza_ah64_hellfiresmoke";
        muzzleEffect                = "BIS_fnc_effectFiredHeliRocket";
        effectsMissileInit          = "MissileDAR1";
        explosionEffects            = "ATMissileExplosion"; 
        soundsetsoniccrack[]        = {"fza_sc_wire_flyby_soundset"};
        soundfly[]                  = {"fza_ah64_us\audio\Flyby\soundfly1.ogg", 1, 1.500000, 400};
        soundsetexplosion[]         = {"fza_rocket_explosion_soundset", "fza_missile_explosion_stereo_soundset", "fza_shell_explosion_reverb_soundset"};
        whistledist                 = 300;

        class CamShakeExplode
        {
            power = 22;
            duration = 2;
            frequency = 20;
        };
        class CamShakeHit
        {
            power = 110;
            duration = 0.6;
            frequency = 20;
        };
        class ace_missileguidance {
            enabled                             = 1;

            minDeflection                       = 0.0005;      // Minium flap deflection for guidance
            maxDeflection                       = 0.01;       // Maximum flap deflection for guidance
            incDeflection                       = 0.0005;      // The incrmeent in which deflection adjusts.

            canVanillaLock                      = 0;          // Can this default vanilla lock? Only applicable to non-cadet mode

            // Guidance type for munitions
            defaultSeekerType                   = "Fza_SALH";
            seekerTypes[]                       = { "Fza_SALH" };

            defaultSeekerLockMode               = "LOBL";
            seekerLockModes[]                   = { "LOAL", "LOBL" };

            seekLastTargetPos                   = 1;      // seek last target position [if seeker loses LOS of target, continue to last known pos]
            seekerAngle                         = 45;           // Angle in front of the missile which can be searched
            seekerAccuracy                      = 1;         // seeker accuracy multiplier

            seekerMinRange                      = 1;
            seekerMaxRange                      = 8100;      // Range from the missile which the seeker can visually search

            // Attack profile type selection
            defaultAttackProfile                = "hellfire";
            attackProfiles[]                    = {"hellfire", "hellfire_hi", "hellfire_lo"};
        };
    };
    class fza_agm114fa : fza_agm114base
    {
        fza_salType                 = "sal1";
        model                       = "\fza_ah64_US\fza_agm114fa";
        proxyShape                  = "\fza_ah64_US\fza_agm114fa";
        submunitionAmmo             = "Fza_Penetrator_8KG";

        hit                         = 260;
        indirectHit                 = 100;
        indirectHitRange            = 10;

        //Blast sleeve
        ace_frag_enabled            = 1;
        ace_frag_metal              = 15000;
        ace_frag_charge             = 5000;
        ace_frag_gurney_c           = 2680;
        ace_frag_gurney_k           = 3/5;
        ace_frag_classes[]          = {"ACE_frag_large"};
        ace_frag_skip               = 0;
        ace_frag_force              = 1;
        explosionEffects            = "BombExplosion"; 
        
        //AI usage
        cost                        = 600;
        class ace_missileguidance: ace_missileguidance {
            enabled                             = 1;
        };
    };
    class fza_agm114k : fza_agm114base
    {
        model                       = "\fza_ah64_us\fza_agm114k"; 
        proxyShape                  = "\fza_ah64_us\fza_agm114k";

        //AI usage
        aiAmmoUsageFlags            = "64+128+512";
        allowAgainstInfantry        = 1;
        cost                        = 1000;

        hit                         = 600;
        indirectHit                 = 200;
        indirectHitRange            = 4;
        class ace_missileguidance: ace_missileguidance {
            enabled                             = 1;
        };
    };
    class fza_agm114k2a : fza_agm114base
    {
        model                       = "\fza_ah64_us\fza_agm114k2a"; 
        proxyShape                  = "\fza_ah64_us\fza_agm114k2a";

        //AI usage
        aiAmmoUsageFlags            = "64+128+512";
        allowAgainstInfantry        = 1;
        cost                        = 1000;

        hit                         = 600;
        indirectHit                 = 200;
        indirectHitRange            = 4;

        //Blast sleeve
        ace_frag_enabled            = 1;
        ace_frag_metal              = 20000;
        ace_frag_charge             = 7000;
        ace_frag_gurney_c           = 2900;
        ace_frag_gurney_k           = 3/5;
        ace_frag_classes[]          = {"ACE_frag_large"};
        ace_frag_skip               = 0;
        ace_frag_force              = 1;
        explosionEffects            = "BombExplosion"; 

        class ace_missileguidance: ace_missileguidance {
            enabled                             = 1;
        };
    };
    class fza_agm114l : fza_agm114base
    {
        fza_salType                 = "rf";
        model                       = "\fza_ah64_US\fza_agm114l";
        proxyShape                  = "\fza_ah64_US\fza_agm114l";
        simulation                  = "shotMissile";

        //AI usage
        aiAmmoUsageFlags            = "128+512";
        allowAgainstInfantry        = 0;
        cost                        = 1000;
        
        hit                         = 600;
        indirectHit                 = 200;
        indirectHitRange            = 4;
        
        class ace_missileguidance: ace_missileguidance {
            enabled                             = 1;
            // Guidance type for munitions
            defaultSeekerType                   = "Fza_ARH";
            seekerTypes[]                       = { "Fza_ARH" };

            seekerAngle                         = 60;
            activeRadarEngageDistance           = 1000;
            seekerMaxRange                      = 2000;
        };
    };
    class fza_agm114n : fza_agm114base
    {
        model                       = "\fza_ah64_US\fza_agm114n";
        proxyShape                  = "\fza_ah64_US\fza_agm114n";
        hit                         = 300;
        indirecthit                 = 300;
        indirecthitrange            = 20;
        explosionEffects            = "HeavyBombExplosion";

        submunitionAmmo             = "";

        //AI usage
        cost                        = 700;
        class ace_missileguidance: ace_missileguidance {
            enabled                 = 1;
        };
    };
};