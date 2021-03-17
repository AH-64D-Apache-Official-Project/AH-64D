class CfgMagazines
{
	class CA_Magazine;
	class VehicleMagazine;
	class 24Rnd_PG_missiles;
	class 24Rnd_missiles;
	class 6Rnd_Missile_AGM_02_F;
	
	class 60Rnd_CMFlareMagazine: CA_Magazine
	{
		author = "$STR_A3_Bohemia_Interactive";
		count = 60;
		ammo = "fza_ah64_flare_shot";
		initSpeed = 30;
	};
	class fza_safe: VehicleMagazine
	{
		scope = 1;
		displayName="SAFE";
		ammo="fza_master";
		count=1;
		initSpeed=0;
		tracersEvery=0;
		nameSound="";
	};
	class fza_burstlimit: VehicleMagazine
	{
		scope = 1;
		displayName="SAFE";
		ammo="fza_master";
		count=1;
		initSpeed=0;
		tracersEvery=0;
		nameSound="";
	};
	
	////////////////////////////////////////////////////////////////////////
	///////////////////////////////M230/////////////////////////////////////
	////////////////////////////////////////////////////////////////////////	
	
	class fza_m230_300: VehicleMagazine
	{
		scope = 2;
		displayName = "30mm HEDP";
		ammo = "fza_30x113";
		count = 300;
		initSpeed = 1620;
		tracersevery = 0;
		weight = 104.78;
	};
	class fza_m230_1200: fza_m230_300
	{
		scope = 2;
		displayName = "30mm HEDP";
		ammo = "fza_30x113";
		count = 1200;
		initSpeed = 1620;
		tracersevery = 0;
		weight = 419.119;
	};
	
	////////////////////////////////////////////////////////////////////////
	///////////////////////////////STINGERS/////////////////////////////////
	////////////////////////////////////////////////////////////////////////	
	
	class fza_atas_2: VehicleMagazine
	{
		scope = 2;
		displayName = "FIM-92";
		count = 4;
		ammo = "fza_fim92";
		initSpeed = 150;
		sound[] = {"A3\sounds_f\dummysound", 3.16228, 1};
		reloadSound[] = {"A3\sounds_f\dummysound", 0.000316228, 1};
		weight = 60;		
	};
	
	////////////////////////////////////////////////////////////////////////
	///////////////////////////////HELLFIRE/////////////////////////////////
	////////////////////////////////////////////////////////////////////////

	#define HELLFIRE_CONFIG(ammoname, disp) \
		class ammoname##_ll: 6Rnd_Missile_AGM_02_F { \
			ammo = ammoname;\
			model = \fza_ah64_us\weps\pylons\fza_rail_ll.p3d; \
			displayName = disp; \
			count = 1; \
			hardpoints[] = {"fza_agm114_ll"}; \
			pylonWeapon = ammoname##_wep; \
			muzzlePos = "muzzlepos"; \
			muzzleEnd = "muzzleend"; \
			sound[] = {"A3\sounds_f\dummysound", 3.16228, 1}; \
			reloadSound[] = {"A3\sounds_f\dummysound", 0.000316228, 1}; \
			weight = 108.09106; \
		}; \
		class ammoname##_lr: ammoname##_ll { \
			model = \fza_ah64_us\weps\pylons\fza_rail_lr.p3d; \
			hardpoints[] = {"fza_agm114_lr"}; \
		}; \
		class ammoname##_ul: ammoname##_ll { \
			model = \fza_ah64_us\weps\pylons\fza_rail_ul.p3d; \
			hardpoints[] = {"fza_agm114_ul"}; \
		}; \
		class ammoname##_ur: ammoname##_ll { \
			model = \fza_ah64_us\weps\pylons\fza_rail_ur.p3d; \
			hardpoints[] = {"fza_agm114_ur"} ; \
		};
	HELLFIRE_CONFIG(fza_agm114a, "AGM-114A")
	HELLFIRE_CONFIG(fza_agm114c, "AGM-114C")
	HELLFIRE_CONFIG(fza_agm114k, "AGM-114K")
	HELLFIRE_CONFIG(fza_agm114l, "AGM-114L")
	HELLFIRE_CONFIG(fza_agm114m, "AGM-114M")
	HELLFIRE_CONFIG(fza_agm114n, "AGM-114N")

	////////////////////////////////////////////////////////////////////////
	///////////////////////////////ROCKETS/////////////////////////////////
	////////////////////////////////////////////////////////////////////////
	#define ROCKET_CONFIG(ammoname, disp) \
		class ammoname##_zoneA: 6Rnd_Missile_AGM_02_F { \
			ammo = ammoname; \
			displayName = disp; \
			model = \fza_ah64_us\weps\pylons\fza_pod_zoneA.p3d; \
			count = 12; \
			hardpoints[] = {"fza_hydra70_zone_AC"}; \
			pylonWeapon = ammoname##_wep; \
			muzzlePos = "muzzlepos"; \
			muzzleEnd = "muzzleend"; \
			sound[] = {"A3\sounds_f\weapons\rockets\explosion_missile_01", 1, 1, 1200};\
			reloadSound[] = {"A3\sounds_f\dummysound", 0.000316228, 1}; \
			weight = 205.024; \
		}; \
		class ammoname##_zoneB: ammoname##_zoneA { \
			model = \fza_ah64_us\weps\pylons\fza_pod_zoneB.p3d; \
			hardpoints[] = {"fza_hydra70_zone_BD"}; \
			count = 4; \
			weight = 68.341;\
		}; \
		class ammoname##_zoneE: ammoname##_zoneA { \
			model = \fza_ah64_us\weps\pylons\fza_pod_zoneE.p3d; \
			hardpoints[] = {"fza_hydra70_zone_E"}; \
			count = 3; \
			weight = 51.256;\
		};
	
	ROCKET_CONFIG(fza_275_m151, "M151 HEDP")
	ROCKET_CONFIG(fza_275_m229, "M229 HEDP")
	ROCKET_CONFIG(fza_275_m255, "M255 FLEC")
	ROCKET_CONFIG(fza_275_m261, "M261 MPSM")
	ROCKET_CONFIG(fza_275_m257, "M257 IL")

	////////////////////////////////////////////////////////////////////////
	//////////////////////////////FUEL TANKS////////////////////////////////
	////////////////////////////////////////////////////////////////////////

	class fza_iafs_100: VehicleMagazine
	{
		scope = 2;
		displayName = "IAFS 100gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
		weight = 320.6;
	};
	class fza_iafs_130: VehicleMagazine
	{
		scope = 2;
		displayName = "IAFS 130gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
		weight = 320.6;
	};
	class fza_auxtank_230_1: VehicleMagazine
	{
		scope = 2;
		displayName = "Wing Aux 230gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
		weight = 698.9858;
	};
	class fza_auxtank_230_2: VehicleMagazine
	{
		scope = 2;
		displayName = "Wing Aux 230gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
		weight = 698.9858;
	};
	class fza_auxtank_230_3: VehicleMagazine
	{
		scope = 2;
		displayName = "Wing Aux 230gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
		weight = 698.9858;
	};
	class fza_auxtank_230_4: VehicleMagazine
	{
		scope = 2;
		displayName = "Wing Aux 230gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
		weight = 698.9858;
	};

	///////////////////////////////////////////////////////////////////////////
	///////////////////////////DAMAGE//////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////
	class fza_ah64_rdp_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "RDP FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_ldp_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "LDP FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_rwp_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "RWP FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_lwp_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "LWP FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
};
