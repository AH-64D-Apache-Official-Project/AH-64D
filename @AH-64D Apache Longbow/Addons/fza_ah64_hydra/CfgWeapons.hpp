class CfgWeapons {
    class RocketPods;
    class fza_hydra70: RocketPods
    {
        scope = private;
        displayName="M261";
        magazines[]={};
        modes[] = {"Single","Far_AI","Medium_AI"};
        canLock = 0;
        weaponLockDelay = 0.0;
        cursor = "EmptyCursor";
        cursorAim = "EmptyCursor";
        holdsterAnimValue = 3;
        weight = 80;
        useAction = 0;
        useActionTitle = "";

        //ACE CFG
        ace_overpressure_angle = 50;
        ace_overpressure_range = 5;
        ace_overpressure_damage = 0.4;
        ace_overpressure_offset = 1;

        class Far_AI: RocketPods
        {
            displayName="M261";
            sounds[] = {"StandardSound"};
            class StandardSound 
            {
                soundSetShot[] = {"fza_m261_soundset"};
            };
            autoFire = 0;
            reloadTime = 0.09;
            dispersion = 0.08;
            showToPlayer = 0;
            aiRateOfFire = 4;
            aiRateOfFireDispersion = 4;
            aiRateOfFireDistance = 1000;
            minRange = 1000;
            minRangeProbab = 0.7;
            midRange = 1500;
            midRangeProbab = 0.7;
            maxRange = 3200;
            maxRangeProbab = 0.1;
        };
        class Medium_AI: Far_AI
        {
            showToPlayer = 0;
            aiRateOfFire = 3;
            aiRateOfFireDispersion = 3;
            aiRateOfFireDistance = 1000;
            minRange = 400;
            minRangeProbab = 0.1;
            midRange = 800;
            midRangeProbab = 0.7;
            maxRange = 1200;
            maxRangeProbab = 0.75;
        };
        class Single: RocketPods
        {
            displayName="M261";
            soundContinuous = 0;
            autoFire = 1;
            reloadTime = 0.09;
            dispersion = 0.0025;
            aiRateOfFire = 1;
            aiRateOfFireDistance = 10;
            minRange = 0;
            minRangeProbab = 0.01;
            midRange = 1;
            midRangeProbab = 0.01;
            maxRange = 2;
            maxRangeProbab = 0.01;
            sounds[] = {"StandardSound"};
            class StandardSound 
            {
                soundSetShot[] = {"fza_m261_soundset"};
            };
            textureType = "semi";
        };
    };
    #define ROCKET_MAGAZINES(ammoName) ammoName##_zoneA, ammoName##_zoneB, ammoName##_zoneE
    #define ROCKET_WEAPON_CONFIG(ammoName, prettyName) \
        class ammoName##_wep : fza_hydra70 {\
            scope = protected;\
            displayName = prettyName;\
            magazines[] = {ROCKET_MAGAZINES(ammoName)};\
            fza_ammoType = ammoName;\
        };
    ROCKET_WEAPON_CONFIG(fza_275_m151, "M151 HEDP")
    ROCKET_WEAPON_CONFIG(fza_275_m255a1, "M255A1 FLEC")
    ROCKET_WEAPON_CONFIG(fza_275_m257, "M257 IL")
    ROCKET_WEAPON_CONFIG(fza_275_m261, "M261 MPSM")
    ROCKET_WEAPON_CONFIG(fza_275_m278, "M278 IR IL")
};