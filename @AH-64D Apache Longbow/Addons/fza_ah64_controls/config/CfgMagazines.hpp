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
			pylonWeapon = "fza_hellfire"; \
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
			pylonWeapon = "fza_hydra70"; \
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
	ROCKET_CONFIG(fza_275_m257, "M151 IL")

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

	class fza_ah64_tailrotor_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "TAIL ROTOR DGRD";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_tailrotor_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "TAIL ROTOR FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_rotor_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "MAIN ROTOR DGRD";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_rotor_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "MAIN ROTOR FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_tads_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "TADS DGRD";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_tads_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "TADS FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_pnvs_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "PNVS FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_gun_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "GUN FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_gun_jam: VehicleMagazine
	{
		scope = 2;
		displayName = "GUN JAM";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_trans_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "TRANS DGRD";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_trans_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "TRANS FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e1_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "ENG1 DAM";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e1_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "ENG1 FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e2_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "ENG2 DAM";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e2_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "ENG2 FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_fwd_leak: VehicleMagazine
	{
		scope = 2;
		displayName = "FWD LEAK";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_aft_leak: VehicleMagazine
	{
		scope = 2;
		displayName = "AFT LEAK";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_fcr_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "FCR FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
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
	class fza_ah64_apu_fire: VehicleMagazine
	{
		scope = 2;
		displayName = "APU FIRE";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e1_fire: VehicleMagazine
	{
		scope = 2;
		displayName = "E1 FIRE";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e2_fire: VehicleMagazine
	{
		scope = 2;
		displayName = "E2 FIRE";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_irjamfail: VehicleMagazine
	{
		scope = 2;
		displayName = "IRJAM FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_rfjamfail: VehicleMagazine
	{
		scope = 2;
		displayName = "RFJAM FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_firepdisch: VehicleMagazine
	{
		scope = 2;
		displayName = "FIREP DISCH";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_firerdisch: VehicleMagazine
	{
		scope = 2;
		displayName = "FIRER DISCH";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
/////////////////////////////////////////////////
/////////////////////LIGHT///////////////////////
/////////////////////////////////////////////////
	class fza_ah64_dam_fuse: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LFUSE";
	};
	class fza_ah64_dam_nose: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "NOSE";
	};
	class fza_ah64_dam_leng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LENG";
	};
	class fza_ah64_dam_reng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RENG";
	};
	class fza_ah64_dam_lfab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LFAB";
	};
	class fza_ah64_dam_rfab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RFAB";
	};
	class fza_ah64_dam_lwing: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LWING";
	};
	class fza_ah64_dam_rwing: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RWING";
	};
	class fza_ah64_dam_tailboom: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "TAILBOOM";
	};
	class fza_ah64_dam_vtail: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "VTAIL";
	};
	class fza_ah64_dam_hstab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "HSTAB";
	};
	class fza_ah64_dam_pylon1: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON1";
	};
	class fza_ah64_dam_pylon2: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON2";
	};
	class fza_ah64_dam_pylon3: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON3";
	};
	class fza_ah64_dam_pylon4: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON4";
	};
	class fza_ah64_dam_tr: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "TR";
	};
	class fza_ah64_dam_rtr: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RTR";
	};
/////////////////////////////////////////////////
/////////////////////MEDIUM//////////////////////
/////////////////////////////////////////////////
	class fza_ah64_mdam_fuse: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "FUSE";
	};
	class fza_ah64_mdam_nose: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "NOSE";
	};
	class fza_ah64_mdam_leng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LENG";
	};
	class fza_ah64_mdam_reng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RENG";
	};
	class fza_ah64_mdam_lfab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LFAB";
	};
	class fza_ah64_mdam_rfab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RFAB";
	};
	class fza_ah64_mdam_lwing: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LWING";
	};
	class fza_ah64_mdam_rwing: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RWING";
	};
	class fza_ah64_mdam_tailboom: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "TAILBOOM";
	};
	class fza_ah64_mdam_vtail: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "VTAIL";
	};
	class fza_ah64_mdam_hstab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "HSTAB";
	};
	class fza_ah64_mdam_pylon1: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON1";
	};
	class fza_ah64_mdam_pylon2: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON2";
	};
	class fza_ah64_mdam_pylon3: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON3";
	};
	class fza_ah64_mdam_pylon4: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON4";
	};
/////////////////////////////////////////////////
/////////////////////HEAVY///////////////////////
/////////////////////////////////////////////////
	class fza_ah64_hdam_reng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RENG";
	};
	class fza_ah64_hdam_leng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RENG";
	};
//////////////////////////////////////////////////////////
/////////CATASTROPHIC DAMAGE//////////////////////////////
//////////////////////////////////////////////////////////
	class fza_ah64_cdam_tailboom: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "TAILBOOM";
	};
};
