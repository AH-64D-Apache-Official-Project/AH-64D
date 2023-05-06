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
            model = \fza_ah64_us\weps\pylons\fza_rail_ll.p3d; \
            hardpoints[] = {"fza_agm114_ll"}; \
        }; \
        class ammoname##_lr: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_us\weps\pylons\fza_rail_lr.p3d; \
            hardpoints[] = {"fza_agm114_lr"}; \
        }; \
        class ammoname##_ul: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_us\weps\pylons\fza_rail_ul.p3d; \
            hardpoints[] = {"fza_agm114_ul"}; \
        }; \
        class ammoname##_ur: ammoname##_base { \
            scope = public;\
            model = \fza_ah64_us\weps\pylons\fza_rail_ur.p3d; \
            hardpoints[] = {"fza_agm114_ur"} ; \
        };
	
	HELLFIRE_MAGAZINE_CONFIG(fza_agm114a, "AGM-114A", "Semi-active laser guided missile with an effective range out to 7km. The A variant was the first built, capable of destroying non-reactive armor threats.");
	HELLFIRE_MAGAZINE_CONFIG(fza_agm114c, "AGM-114C", "Semi-active laser guided missile with an effective range out to 7km. The C variant introduced an improved motor, seeker, and autopilot over the A variant.");
	HELLFIRE_MAGAZINE_CONFIG(fza_agm114k, "AGM-114K", "Semi-active laser guided missile with an effective range out to 7km. This is the most advanced model of all the laser guided HELLFIRES available.");
	HELLFIRE_MAGAZINE_CONFIG(fza_agm114l, "AGM-114L", "One of the most advanced anti-tank missiles in the world. Radar guided, it is capable of hitting targets out to 8km and can destroy any known armored vehicle in existence.");
	HELLFIRE_MAGAZINE_CONFIG(fza_agm114m, "AGM-114M", "Semi-active laser guided missile with an effective range out to 7km, with a blast-fragmentation warhead. It is ideal for soft targets.");
	HELLFIRE_MAGAZINE_CONFIG(fza_agm114n, "AGM-114N", "Semi-active laser guided missile with an effective range out to 7km, with a thermobaric warhead. It is very deadly when used against hardened targets.");

};