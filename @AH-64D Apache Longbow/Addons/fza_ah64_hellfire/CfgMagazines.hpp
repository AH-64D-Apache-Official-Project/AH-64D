class CfgMagazines {
    class PylonRack_4Rnd_ACE_Hellfire_AGM114K;
    #define HELLFIRE_MAGAZINE_CONFIG(ammoname, disp, descShort) \
        class ammoname##_base: PylonRack_4Rnd_ACE_Hellfire_AGM114K {\
            descriptionShort = descShort;\
            ammo = ammoname;\
            displayName = disp; \
            count = 1; \
            pylonWeapon = ammoname##_wep; \
            muzzlePos = "muzzlepos"; \
            muzzleEnd = "muzzleend"; \
            sound[] = {"A3\sounds_f\dummysound", 3.16228, 1}; \
            reloadSound[] = {"A3\sounds_f\dummysound", 0.000316228, 1}; \
            weight = 62.94; \
            fza_pylonType = "hellfire"; \
        };\
        class ammoname##_ll: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_hellfire\data\pylon\fza_rail_ll.p3d; \
            hardpoints[] = {"fza_agm114_ll"}; \
        }; \
        class ammoname##_lr: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_hellfire\data\pylon\fza_rail_lr.p3d; \
            hardpoints[] = {"fza_agm114_lr"}; \
        }; \
        class ammoname##_ul: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_hellfire\data\pylon\fza_rail_ul.p3d; \
            hardpoints[] = {"fza_agm114_ul"}; \
        }; \
        class ammoname##_ur: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_hellfire\data\pylon\fza_rail_ur.p3d; \
            hardpoints[] = {"fza_agm114_ur"} ; \
        };

    HELLFIRE_MAGAZINE_CONFIG(fza_agm114fa,  "$STR_FZA_AH64_HELLFIRE_AGM_114FA", "$STR_FZA_AH64_HELLFIRE_AGM_114FA_INFO");
    HELLFIRE_MAGAZINE_CONFIG(fza_agm114k,   "$STR_FZA_AH64_HELLFIRE_AGM_114K", "$STR_FZA_AH64_HELLFIRE_AGM_114K_INFO");
    HELLFIRE_MAGAZINE_CONFIG(fza_agm114k2a, "$STR_FZA_AH64_HELLFIRE_AGM_114K2A", "$STR_FZA_AH64_HELLFIRE_AGM_114K2A_INFO");
    HELLFIRE_MAGAZINE_CONFIG(fza_agm114l,   "$STR_FZA_AH64_HELLFIRE_AGM_114L", "$STR_FZA_AH64_HELLFIRE_AGM_114L_INFO");
    HELLFIRE_MAGAZINE_CONFIG(fza_agm114n,   "$STR_FZA_AH64_HELLFIRE_AGM_114N", "$STR_FZA_AH64_HELLFIRE_AGM_114N_INFO");

    class fza_agm114_rail: fza_agm114k_ur {
        descriptionShort = "$STR_FZA_AH64_HELLFIRE_M299_INFO";
        model = "\fza_ah64_hellfire\data\pylon\fza_rail_ul.p3d";
        hardpoints[] = {"fza_railzone"};
        fza_pylonType = "hellfire";
        displayName = "$STR_FZA_AH64_HELLFIRE_M299"; 
        count = 0;
    };
};