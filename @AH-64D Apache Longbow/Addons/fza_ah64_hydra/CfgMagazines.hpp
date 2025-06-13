class CfgMagazines {
    class 6Rnd_Missile_AGM_02_F;
    class fza_275_rocket_base: 6Rnd_Missile_AGM_02_F {
        scope = private;
    };

    #define ROCKET_MAGAZINE_CONFIG(ammoname, disp, dispShort) \
        class ammoname##_zoneA: fza_275_rocket_base { \
            scope=public;\
            ammo = ammoname; \
            displayName = disp; \
            descriptionShort = dispShort; \
            model = \fza_ah64_hydra\data\pylon\fza_pod_zoneA.p3d; \
            count = 12; \
            hardpoints[] = {"fza_hydra70_zone_AC"}; \
            pylonWeapon = ammoname##_wep; \
            muzzlePos = "muzzlepos"; \
            muzzleEnd = "muzzleend"; \
            sound[] = {"A3\sounds_f\weapons\rockets\explosion_missile_01", 1, 1, 1200};\
            reloadSound[] = {"A3\sounds_f\dummysound", 0.000316228, 1}; \
            weight = 150.06; \
            fza_pylonType = "rocket"; \
        }; \
        class ammoname##_zoneB: ammoname##_zoneA { \
            model = \fza_ah64_hydra\data\pylon\fza_pod_zoneB.p3d; \
            hardpoints[] = {"fza_hydra70_zone_BD"}; \
            count = 4; \
            weight = 50.02;\
        }; \
        class ammoname##_zoneE: ammoname##_zoneA { \
            model = \fza_ah64_hydra\data\pylon\fza_pod_zoneE.p3d; \
            hardpoints[] = {"fza_hydra70_zone_E"}; \
            count = 3; \
            weight = 37.51;\
        }
    
    ROCKET_MAGAZINE_CONFIG(fza_275_m151, "M151 HEDP", "The M151 warhead is a 10 pound warhead with a pre-fragmented shell. It is effective against light armored vehicles and personnel. It is mounted to a Mark 66 Mod 6 rocket motor with an effective range of 5km.");
    ROCKET_MAGAZINE_CONFIG(fza_275_m255a1, "M255A1 FLEC", "The M255 warhead is a submunition rocket with over 1000 60 grain flechettes. These are effective against personnel with moderate effectiveness against unarmored vehicles. It is mounted to a Mark 66 Mod 6 rocket motor with an effective range of 5km.");
    ROCKET_MAGAZINE_CONFIG(fza_275_m261, "M261 MPSM", "The M261 warhead is a submunition rocket with 9 parachute-retarded munitions. These are effective against both personnel and light armored vehicles. It is mounted to a Mark 66 Mod 6 rocket motor with an effective range of 5km.");
    ROCKET_MAGAZINE_CONFIG(fza_275_m257, "M257 IL", "The M257 is an illumination warhead containing a parachute flare. It can illuminate an area of a square kilometer for approximately 100 seconds. It is mounted to a Mark 66 Mod 6 rocket motor with a trigger distance of 3.5km.");
    ROCKET_MAGAZINE_CONFIG(fza_275_m278, "M278 IR IL", "The M278 is an IR illumination warhead containing a parachute flare. It can illuminate an area of a square kilometer for approximately 100 seconds. It is mounted to a Mark 66 Mod 6 rocket motor with a trigger distance of 3.5km.");

    class fza_275_pod: fza_275_m151_zoneA {
        descriptionShort = "The M261 is a 19-tube, 2.75” FFAR Launcher";
        model = "\fza_ah64_hydra\data\pylon\fza_pod_zoneA.p3d";
        hardpoints[] = {"fza_railzone"};
        fza_pylonType = "rocket";
        displayName = "M261"; 
        count = 0;
    };
};