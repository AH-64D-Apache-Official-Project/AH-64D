class CfgWeapons {
    class CannonCore;
    class fza_m230: CannonCore
    {
        scope               = 1;
        displayName         = "$STR_FZA_AH64_M230_E1";
        nameSound           = "cannon";
        cursor              = "EmptyCursor";
        cursorAim           = "";
        showAimCursorInternal = 0;
        magazines[]         ={"fza_m230_300","fza_m230_1200"};
        canLock             = 1;
        ballisticsComputer  = "1 + 16";
        FCSZeroingDelay     = 0;
        maxZeroing          = 4200;
        aiDispersionCoefY   = 0.5;
        aiDispersionCoefX   = 0.5;
        weaponLockDelay     = 0;
        multiplier          = 1;
        shotFromTurret      = 0;
        useAction           = 0;
        useActionTitle      = "";
        modes[]             = {"manual","close","short","medium","far"};

        //ACE Advanced Ballistics Cfg
        ACE_barrelTwist             = 177.8;
        ACE_barrelLength            = 1676;
        ACE_twistDirection          = 1;
        ace_overpressure_angle      = 90;
        ace_overpressure_range      = 2;
        ace_overpressure_damage     = 0.265;
        ace_overheating_barrelMass  = 16;   //16kg

        class GunParticles
        {
            class Effect
            {
                effectName = "MachineGun2";
                positionName = "Usti hlavne";
                directionName = "Konec hlavne";
            };
        };
        class manual: CannonCore
        {
            displayName="$STR_FZA_AH64_M230_E1";
            autoFire = 1;
            textureType = "fullAuto";
            sounds[] = {"StandardSound"};
            class StandardSound 
            {
                soundSetShot[] = {"fza_soundset_cannon_shot"};
            };
            soundContinuous = 0;
            soundBurst = 0;
            reloadTime = 0.109;
            dispersion = 0.006;
            aiRateOfFire = 1;
            aiRateOfFireDistance = 10;
            minRange = 0;
            minRangeProbab = 0.01;
            midRange = 1;
            midRangeProbab = 0.01;
            maxRange = 2;
            maxRangeProbab = 0.01;
        };
        class close: manual
        {
            aiBurstTerminable = 1;
            showToPlayer = 0;
            burst = 16;
            burstRangeMax = 37;
            aiRateOfFire = 0.5;
            aiRateOfFireDispersion = 1;
            aiRateOfFireDistance = 50;
            minRange = 0;
            minRangeProbab = 0.1;
            midRange = 50;
            midRangeProbab = 0.65;
            maxRange = 400;
            maxRangeProbab = 0.75;
        };
        class short: close
        {
            aiBurstTerminable = 1;
            showToPlayer = 0;
            burst = 12;
            burstRangeMax = 32;
            aiRateOfFire = 1;
            aiRateOfFireDispersion = 2;
            aiRateOfFireDistance = 200;
            minRange = 200;
            minRangeProbab = 0.65;
            midRange = 400;
            midRangeProbab = 0.75;
            maxRange = 1000;
            maxRangeProbab = 0.7;
        };
        class medium: close
        {
            aiBurstTerminable = 1;
            showToPlayer = 0;
            burst = 12;
            burstRangeMax = 28;
            aiRateOfFire = 2;
            aiRateOfFireDispersion = 2;
            aiRateOfFireDistance = 800;
            minRange = 800;
            minRangeProbab = 0.7;
            midRange = 1400;
            midRangeProbab = 0.4;
            maxRange = 1800;
            maxRangeProbab = 0.15;
        };
        class far: close
        {
            aiBurstTerminable = 1;
            showToPlayer = 0;
            burst = 9;
            burstRangeMax = 20;
            aiRateOfFire = 4;
            aiRateOfFireDispersion = 4;
            aiRateOfFireDistance = 1400;
            minRange = 1400;
            minRangeProbab = 0.5;
            midRange = 1800;
            midRangeProbab = 0.15;
            maxRange = 2500;
            maxRangeProbab = 0.05;
        };
    };
    
    class fza_cannon_limit: fza_m230{displayName="$STR_FZA_AH64_BURST_LIMIT";magazines[]={"fza_cannon_limit"};};
    class fza_ma_safe: fza_cannon_limit{ displayName="$STR_FZA_AH64_MASTER_ARM_SAFE";magazines[]={"fza_safe"};};
    class fza_gun_inhibit: fza_cannon_limit {displayName = "$STR_FZA_AH64_CANNON_INHIBIT";magazines[]={"fza_gun_inhibit"};};
    class fza_hydra_limit: fza_cannon_limit {displayName = "$STR_FZA_AH64_SALVO_LIMIT";magazines[]={"fza_hydra_limit"};};
    class fza_pylon_inhibit: fza_cannon_limit {displayName = "$STR_FZA_AH64_PYLON_INHIBIT";magazines[]={"fza_pylon_inhibit"};};
};
