class CfgWeapons {
    class CannonCore;
    class fza_m230: CannonCore
    {
        scope               = 1;
        displayName         = "M230-E1";
        nameSound           = "cannon";
        cursor              = "EmptyCursor";
        cursorAim           = "mg";
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
            displayName="M230";
            autoFire = 1;
            textureType = "fullAuto";
            sounds[] = {"StandardSound"};
            class StandardSound 
            {
                soundSetShot[] = {"fza_m230_soundset"};
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
    
    class fza_burstlimiter: fza_m230
    {
        scope = 1;
        displayName="BURST LIMIT";
        cursor="";
        cursorAim="";
        magazines[]={"fza_burstlimit"};
        textureType = "single";
    };
        
    class fza_ma_safe: fza_m230
    {
        scope = 1;
        displayName="MASTER ARM SAFE";
        cursor="";
        cursorAim="";
        magazines[]={"fza_safe"};
        textureType = "single";
    };
    class fza_gun_safe: fza_ma_safe {displayName = "Gun Safe";};
};