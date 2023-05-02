class ACE_Hellfire_AGM114K: M_Scalpel_AT {
    class ace_missileguidance;
};
class Fza_Penetrator_9KG_Tandem: ammo_Penetrator_Base {
    caliber = 60;
    warheadName = "TandemHEAT";
    hit = 1650;
};
class Fza_Penetrator_8KG: ammo_Penetrator_Base {
    caliber = 60;
    warheadName = "HEAT";
    hit = 780;
};
class fza_agm114base: ACE_Hellfire_AGM114K {

    ace_frag_enabled = 0;
    ace_frag_skip = 1;

    fza_salType = "sal2";
    irLock = 1;
    laserLock = 0;
    airLock = 0;

    maxSpeed = 450;
    simulationStep = 0.005;
    airFriction = -0.0350;
    sideAirFriction = -0.0250;
    initTime = 0;
    thrustTime = 6;
    thrust = 100;
    fuseDistance = 100;
    manualControl = 0;
    maxControlRange = 8000;
    trackOversteer = 1;
    trackLead = 1;
    maneuvrability = 0;
    timeToLive = 50;
    cmImmunity = 0.97;

    //AI uasge
    aiAmmoUsageFlags = "64+128+512";
    allowAgainstInfantry = 1;
    cost = 1000;
    minRange = 300;
    minRangeProbab = 0.7;
    midRange = 3500;
    midRangeProbab = 1.0;
    maxRange = 8000;
    maxRangeProbab = 0.8;

    //Penetrator
    submunitionAmmo = "Fza_Penetrator_9KG_Tandem";
    submunitionDirectionType = "SubmunitionModelDirection";
    submunitionInitSpeed = 1000;
    submunitionParentSpeedCoef = 0;
    submunitionInitialOffset[] = {
        0,
        0,
        -0.2
    };
    triggerOnImpact = 1;
    deleteParentWhenTriggered = 0;

    effectsmissile = "fza_ah64_hellfiresmoke";
    muzzleEffect = "BIS_fnc_effectFiredHeliRocket";
    effectsMissileInit = "MissileDAR1";
    explosionEffects = "BombExplosion";
    soundsetsoniccrack[] = {
        "fza_sc_wire_flyby_soundset"
    };
    soundfly[] = {
        "fza_ah64_us\audio\Flyby\soundfly1.ogg",
        1,
        1.500000,
        400
    };
    soundsetexplosion[] = {
        "fza_rocket_explosion_soundset",
        "fza_missile_explosion_stereo_soundset",
        "fza_shell_explosion_reverb_soundset"
    };
    whistledist = 300;

    //Missile sensors definition
    missileLockMaxDistance = 8000;
    missileLockMinDistance = 200;
    missileLockMaxSpeed = 56;
    missileLockCone = 90;
    missileKeepLockedCone = 90;
    lockSeekRadius = 2000;
    autoSeekTarget = 0;
    weaponLockSystem = "4 + 8";
    maneuvDependsOnSpeedCoef = 0.018;
    class CamShakeExplode {
        power = 22;
        duration = 2;
        frequency = 20;
        distance = 163.905;
    };
    class CamShakeHit {
        power = 110;
        duration = 0.6;
        frequency = 20;
        distance = 1;
    };
    class CamShakeFire {
        power = 2.9907;
        duration = 1.8;
        frequency = 20;
        distance = 71.5542;
    };
    class CamShakePlayerFire {
        power = 4;
        duration = 0.1;
        frequency = 20;
        distance = 1;
    };
};
class fza_agm114l: fza_agm114base {
    fza_salType = "rf";
    model = "\fza_ah64_US\fza_agm114l";
    proxyShape = "\fza_ah64_US\fza_agm114l";
    simulation = "shotMissile";

    //AI usage
    aiAmmoUsageFlags = "128+512";
    allowAgainstInfantry = 0;
    cost = 1000;

    hit = 600;
    indirectHit = 200;
    indirectHitRange = 4;

    airLock = 1;
    irlock = 1;
    nvLock = 0;

    activeSensorAlwaysOn = 1;
    missileLockCone = 90;
    missileKeepLockedCone = 90;
    maneuvrability = 0;

    class ace_missileguidance {
        enabled = 1;

        minDeflection = 0.0005;
        maxDeflection = 0.01;
        incDeflection = 0.0005;

        canVanillaLock = 0;

        defaultSeekerType = "Fza_ARH";
        seekerTypes[] = {
            "Fza_ARH"
        };
        defaultSeekerLockMode = "LOBL";
        seekerLockModes[] = {
            "LOAL",
            "LOBL"
        };

        seekLastTargetPos = 1;
        seekerAngle = 60;
        seekerAccuracy = 1;

        seekerMinRange = 1;
        activeRadarEngageDistance = 1000;
        seekerMaxRange = 2000;

        defaultAttackProfile = "hellfire_hi";
        attackProfiles[] = {
            "hellfire_hi",
            "hellfire"
        };
    };

    class Components: Components {
        class SensorsManagerComponent {
            class Components {
                class RadarSensorComponent {
                    class AirTarget {
                        minRange = 0;
                        maxRange = 2000;
                        viewDistanceLimitCoef = -1;
                        objectDistanceLimitCoef = -1
                    };
                    class GroundTarget {
                        minRange = 0;
                        maxRange = 2000;
                        viewDistanceLimitCoef = -1;
                        objectDistanceLimitCoef = -1
                    };
                    typeRecognitionDistance = -1;
                    angleRangeHorizontal = 90;
                    angleRangeVertical = 90;
                    maxGroundNoiseDistance = 0;
                    maxFogSeeThrough = 0.8;
                    allowsMarking = 0;
                };
            };
        };
    };
};
class fza_agm114k: fza_agm114base {
    model = "\fza_ah64_us\fza_agm114k";
    proxyShape = "\fza_ah64_us\fza_agm114k";

    //AI usage
    aiAmmoUsageFlags = "64+128+512";
    allowAgainstInfantry = 1;
    cost = 1000;

    hit = 600;
    indirectHit = 200;
    indirectHitRange = 4;

    laserLock = 1;
    airLock = 0;
    irlock = 0;
    nvLock = 0;

    //MSL sensors definition
    missileLockMaxDistance = 8000;
    missileLockMinDistance = 300;
    missileLockMaxSpeed = 56;
    missileLockCone = 90;
    missileKeepLockedCone = 90;
    missileManualControlCone = 90;
    weaponLockSystem = "4";
    weaponType = "missileAT";

    autoSeekTarget = 1;
    lockSeekDistanceFromParent = 300;
    lockSeekRadius = 500;

    class ace_missileguidance {
        enabled = 1;

        minDeflection = 0.0005;
        maxDeflection = 0.01;
        incDeflection = 0.0005;

        canVanillaLock = 0;

        defaultSeekerType = "Fza_SALH";
        seekerTypes[] = {
            "Fza_SALH"
        };

        defaultSeekerLockMode = "LOBL";
        seekerLockModes[] = {
            "LOAL",
            "LOBL"
        };

        seekLastTargetPos = 1;
        seekerAngle = 40;
        seekerAccuracy = 1;

        seekerMinRange = 1;
        seekerMaxRange = 8100;

        defaultAttackProfile = "hellfire";
        attackProfiles[] = {
            "hellfire",
            "hellfire_hi",
            "hellfire_lo"
        };
    };
    class Components: Components {
        class SensorsManagerComponent {
            class Components {
                class LaserSensorComponent {
                    class AirTarget {
                        minRange = 500;
                        maxRange = 7000;
                    };
                    class GroundTarget {
                        minRange = 500;
                        maxRange = 7000;
                    };
                    angleRangeHorizontal = 30;
                    angleRangeVertical = 50;
                    typeRecognitionDistance = -1;
                    maxGroundNoiseDistance = 0;
                    maxFogSeeThrough = 0.3;
                    allowsMarking = 0;
                };
            };
        };
    };
};
class fza_agm114a: fza_agm114k {
    fza_salType = "sal1";
    model = "\fza_ah64_US\fza_agm114c";
    proxyShape = "\fza_ah64_US\fza_agm114c";
    effectsmissile = "missile3";

    submunitionAmmo = "Fza_Penetrator_8KG";

    hit = 200;
    indirectHit = 80;
    indirectHitRange = 4;

    //AI usage
    cost = 500;
    class ace_missileguidance {
        enabled = 1;

        minDeflection = 0.0005;
        maxDeflection = 0.01;
        incDeflection = 0.0005;

        canVanillaLock = 0;

        defaultSeekerType = "Fza_SALH";
        seekerTypes[] = {
            "Fza_SALH"
        };

        defaultSeekerLockMode = "LOBL";
        seekerLockModes[] = {
            "LOAL",
            "LOBL"
        };

        seekLastTargetPos = 0;
        seekerAngle = 40;
        seekerAccuracy = 1;

        seekerMinRange = 1;
        seekerMaxRange = 8100;

        defaultAttackProfile = "hellfire";
        attackProfiles[] = {
            "hellfire",
            "hellfire_hi",
            "hellfire_lo"
        };
    };
};
class fza_agm114c: fza_agm114k {
    fza_salType = "sal1";
    model = "\fza_ah64_US\fza_agm114c";
    proxyShape = "\fza_ah64_US\fza_agm114c";

    submunitionAmmo = "Fza_Penetrator_8KG";

    hit = 260;
    indirectHit = 100;
    indirectHitRange = 4;

    //AI usage
    cost = 600;
    class ace_missileguidance {
        enabled = 1;

        minDeflection = 0.0005;
        maxDeflection = 0.01;
        incDeflection = 0.0005;

        canVanillaLock = 0;

        defaultSeekerType = "Fza_SALH";
        seekerTypes[] = {
            "Fza_SALH"
        };

        defaultSeekerLockMode = "LOBL";
        seekerLockModes[] = {
            "LOAL",
            "LOBL"
        };

        seekLastTargetPos = 1;
        seekerAngle = 40;
        seekerAccuracy = 1;

        seekerMinRange = 1;
        seekerMaxRange = 8100;

        defaultAttackProfile = "hellfire";
        attackProfiles[] = {
            "hellfire",
            "hellfire_hi",
            "hellfire_lo"
        };
    };
};
class fza_agm114m: fza_agm114k {
    ace_frag_enabled = 1;
    ace_frag_skip = 0;
    ace_frag_force = 1;
    model = "\fza_ah64_US\fza_agm114k";
    proxyShape = "\fza_ah64_US\fza_agm114k";
    hit = 100;
    indirectHit = 100;
    indirectHitRange = 40;

    submunitionAmmo = "";

    //AI usage
    cost = 700;
    class ace_missileguidance {
        enabled = 1;

        minDeflection = 0.0005;
        maxDeflection = 0.01;
        incDeflection = 0.0005;

        canVanillaLock = 0;

        defaultSeekerType = "Fza_SALH";
        seekerTypes[] = {
            "Fza_SALH"
        };

        defaultSeekerLockMode = "LOBL";
        seekerLockModes[] = {
            "LOAL",
            "LOBL"
        };

        seekLastTargetPos = 1;
        seekerAngle = 40;
        seekerAccuracy = 1;

        seekerMinRange = 1;
        seekerMaxRange = 8100;

        defaultAttackProfile = "hellfire";
        attackProfiles[] = {
            "hellfire",
            "hellfire_hi",
            "hellfire_lo"
        };
    };
};
class fza_agm114n: fza_agm114k {
    model = "\fza_ah64_US\fza_agm114k";
    proxyShape = "\fza_ah64_US\fza_agm114k";
    hit = 200;
    indirecthit = 200;
    indirecthitrange = 12;
    explosionEffects = "BombExplosion";

    submunitionAmmo = "";

    //AI usage
    cost = 700;
    class ace_missileguidance {
        enabled = 1;

        minDeflection = 0.0005;
        maxDeflection = 0.01;
        incDeflection = 0.0005;

        canVanillaLock = 0;

        defaultSeekerType = "Fza_SALH";
        seekerTypes[] = {
            "Fza_SALH"
        };

        defaultSeekerLockMode = "LOBL";
        seekerLockModes[] = {
            "LOAL",
            "LOBL"
        };

        seekLastTargetPos = 1;
        seekerAngle = 40;
        seekerAccuracy = 1;

        seekerMinRange = 1;
        seekerMaxRange = 8100;

        defaultAttackProfile = "hellfire";
        attackProfiles[] = {
            "hellfire",
            "hellfire_hi",
            "hellfire_lo"
        };
    };
};