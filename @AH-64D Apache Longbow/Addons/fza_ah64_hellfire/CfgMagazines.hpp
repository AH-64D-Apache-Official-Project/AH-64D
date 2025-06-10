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
            model = \fza_ah64_model\weps\pylons\fza_rail_ll.p3d; \
            hardpoints[] = {"fza_agm114_ll"}; \
        }; \
        class ammoname##_lr: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_model\weps\pylons\fza_rail_lr.p3d; \
            hardpoints[] = {"fza_agm114_lr"}; \
        }; \
        class ammoname##_ul: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_model\weps\pylons\fza_rail_ul.p3d; \
            hardpoints[] = {"fza_agm114_ul"}; \
        }; \
        class ammoname##_ur: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_model\weps\pylons\fza_rail_ur.p3d; \
            hardpoints[] = {"fza_agm114_ur"} ; \
        };

    HELLFIRE_MAGAZINE_CONFIG(fza_agm114fa,  "AGM-114FA", "SAL 1 Guidance, effective range - 7km. The FA variant introduced a blast sleeve onto the C model for a cheap anti-personel missile.");
    HELLFIRE_MAGAZINE_CONFIG(fza_agm114k,   "AGM-114K", "SAL 2 Guidance, effective range - 8km. This is the most advanced model of all the laser guided hellfires available.");
    HELLFIRE_MAGAZINE_CONFIG(fza_agm114k2a, "AGM-114K2A", "SAL 2 Guidance, effective range - 8km. The K2A variant added a blast sleeve onto the K model for a cheap anti-personel missile.");
    HELLFIRE_MAGAZINE_CONFIG(fza_agm114l,   "AGM-114L", "One of the most advanced anti-tank missiles in the world. Radar guided, it is capable of hitting targets out to 8km and can destroy any known armored vehicle in existence.");
    HELLFIRE_MAGAZINE_CONFIG(fza_agm114n,   "AGM-114N", "SAL 2 Guidance, effective range - 8km. , The N variant is a K model with a thermobaric warhead. It is very deadly when used against hardened targets.");
    
    class fza_agm114_rail: fza_agm114k_ur {
        descriptionShort = "The M299 is a 4-Rail Hellfire Launcher";
        model = "\fza_ah64_model\weps\pylons\fza_rail_ul.p3d";
        hardpoints[] = {"fza_railzone"};
        fza_pylonType = "hellfire";
        displayName = "M299"; 
        count = 0;
    };
};