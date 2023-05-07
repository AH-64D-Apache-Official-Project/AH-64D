class CfgWeapons {
    class MissileLauncher;
    class ace_hellfire_launcher;
    
    class fza_hellfire: ace_hellfire_launcher
    {
        scope = private;
        displayName="AGM-114";
        magazines[]={};
        holdsterAnimValue = 3;
        reloadTime = 0.1;
        magazineReloadTime = 0.1;
        showAimCursorInternal = 0;
        textureType = "semi";
        weaponLockDelay = 0;
        weaponLockSystem = 4;
        cmImmunity = 0.9;
        lockedtargetsound[] = {"", 1, 1};
        lockingtargetsound[] = {"", 1, 1};
        sounds[] = {"StandardSound"};
        class StandardSound 
        {
            soundSetShot[] = {"fza_agm114_soundset"};
        };
        modes[] = {"TopDown"};
        class TopDown: MissileLauncher
        {
            displayName = "LOAL-HI";
            textureType = "terrain";
            reloadTime = 0.1;
            magazineReloadTime = 0.1;
            sounds[] = {"StandardSound"};
            class StandardSound 
            {
                soundSetShot[] = {"fza_agm114_soundset"};
            };
            lockedtargetsound[] = {"", 1, 1};
            lockingtargetsound[] = {"", 1, 1};
            minRange = 360;
            minRangeProbab = 0.4;
            midRange = 1500;
            midRangeProbab = 1.0;
            maxRange = 8000;
            maxRangeProbab = 0.95;
        };
        //ACE CFG
        ace_overpressure_angle = 50;
        ace_overpressure_range = 12;
        ace_overpressure_damage = 0.7;
        ace_overpressure_offset = 1;
    };
    #define HELLFIRE_MAGAZINES(ammoName) ammoName##_ll, ammoName##_lr, ammoName##_ul, ammoName##_ur
    #define HELLFIRE_WEAPON_CONFIG(ammoName, prettyName) \
        class ammoName##_wep : fza_hellfire {\
            scope = protected;\
            displayName = prettyName;\
            magazines[] = {HELLFIRE_MAGAZINES(ammoName)};\
            fza_ammoType = ammoName;\
        };
    HELLFIRE_WEAPON_CONFIG(fza_agm114a, "AGM-114A")
    HELLFIRE_WEAPON_CONFIG(fza_agm114c, "AGM-114C")
    HELLFIRE_WEAPON_CONFIG(fza_agm114k, "AGM-114K")
    HELLFIRE_WEAPON_CONFIG(fza_agm114l, "AGM-114L")
    HELLFIRE_WEAPON_CONFIG(fza_agm114m, "AGM-114M")
    HELLFIRE_WEAPON_CONFIG(fza_agm114n, "AGM-114N")
};