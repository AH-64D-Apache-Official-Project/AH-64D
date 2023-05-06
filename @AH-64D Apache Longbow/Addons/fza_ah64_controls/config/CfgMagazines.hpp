class CfgMagazines
{
	class CA_Magazine;
	class VehicleMagazine;
	class 24Rnd_PG_missiles;
	class 24Rnd_missiles;
	class 6Rnd_Missile_AGM_02_F;
	
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