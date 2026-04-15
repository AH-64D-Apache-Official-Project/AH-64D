class CfgWeapons {
    class RocketPods;
    class fza_hydra70: RocketPods
    {
        scope = private;
        displayName="$STR_FZA_AH64_HYDRA_M275";
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
            displayName="$STR_FZA_AH64_HYDRA_M275";
            sounds[] = {"StandardSound"};
            class StandardSound 
            {
                soundSetShot[] = {"fza_soundset_hydra_shot"};
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
            displayName="$STR_FZA_AH64_HYDRA_M275";
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
                soundSetShot[] = {"fza_soundset_hydra_shot"};
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
    ROCKET_WEAPON_CONFIG(fza_275_m151, "$STR_FZA_AH64_HYDRA_M151")
    ROCKET_WEAPON_CONFIG(fza_275_m255a1, "$STR_FZA_AH64_HYDRA_M255A1")
    ROCKET_WEAPON_CONFIG(fza_275_m257, "$STR_FZA_AH64_HYDRA_M257_IL")
    ROCKET_WEAPON_CONFIG(fza_275_m261, "$STR_FZA_AH64_HYDRA_M278_IR_IL")
    ROCKET_WEAPON_CONFIG(fza_275_m278, "$STR_FZA_AH64_HYDRA_M275")
};
