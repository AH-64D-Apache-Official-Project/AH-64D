class CfgMagazines {
    class 6Rnd_Missile_AGM_02_F;
    class fza_275_rocket_base: 6Rnd_Missile_AGM_02_F {
        scope = private;
    };

    #define ROCKET_MAGAZINE_CONFIG(AMMO_CLASS,DISP,DISP_SHORT) \
        class AMMO_CLASS##_zoneA: fza_275_rocket_base { \
            scope=public;\
            ammo = QUOTE(AMMO_CLASS); \
            displayName = DISP; \
            descriptionShort = DISP_SHORT; \
            model = "\fza_ah64_hydra\data\pylon\fza_pod_zoneA.p3d"; \
            count = 12; \
            hardpoints[] = {"fza_hydra70_zone_AC"}; \
            pylonWeapon = QUOTE(AMMO_CLASS##_WEP); \
            muzzlePos = "muzzlepos"; \
            muzzleEnd = "muzzleend"; \
            sound[] = {"A3\sounds_f\weapons\rockets\explosion_missile_01.wss", 1, 1, 1200};\
            reloadSound[] = {"A3\sounds_f\dummysound.wss", 0.000316228, 1}; \
            weight = 150.06; \
            fza_pylonType = "rocket"; \
        }; \
        class AMMO_CLASS##_zoneB: AMMO_CLASS##_zoneA { \
            model = "\fza_ah64_hydra\data\pylon\fza_pod_zoneB.p3d"; \
            hardpoints[] = {"fza_hydra70_zone_BD"}; \
            count = 4; \
            weight = 50.02;\
        }; \
        class AMMO_CLASS##_zoneE: AMMO_CLASS##_zoneA { \
            model = "\fza_ah64_hydra\data\pylon\fza_pod_zoneE.p3d"; \
            hardpoints[] = {"fza_hydra70_zone_E"}; \
            count = 3; \
            weight = 37.51;\
        }
    
    ROCKET_MAGAZINE_CONFIG(fza_275_m151,"$STR_FZA_AH64_HYDRA_M151","$STR_FZA_AH64_HYDRA_M151_INFO");
    ROCKET_MAGAZINE_CONFIG(fza_275_m255a1,"$STR_FZA_AH64_HYDRA_M255A1","$STR_FZA_AH64_HYDRA_M255A1_INFO");
    ROCKET_MAGAZINE_CONFIG(fza_275_m261,"$STR_FZA_AH64_HYDRA_M261_MPSM","$STR_FZA_AH64_HYDRA_M261_MPSM_INFO");
    ROCKET_MAGAZINE_CONFIG(fza_275_m257,"$STR_FZA_AH64_HYDRA_M257_IL","$STR_FZA_AH64_HYDRA_M257_IL_INFO");
    ROCKET_MAGAZINE_CONFIG(fza_275_m278,"$STR_FZA_AH64_HYDRA_M278_IR_IL","$STR_FZA_AH64_HYDRA_M278_IR_IL_INFO");

    class fza_275_pod: fza_275_m151_zoneA {
        descriptionShort = "$STR_FZA_AH64_HYDRA_M275_INFO";
        model = "\fza_ah64_hydra\data\pylon\fza_pod_zoneA.p3d";
        hardpoints[] = {"fza_railzone"};
        fza_pylonType = "rocket";
        displayName = "$STR_FZA_AH64_HYDRA_M275"; 
        count = 0;
    };
};
