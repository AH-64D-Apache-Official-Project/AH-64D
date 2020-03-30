class fza_CounterMeasureFlare
{
		class Cmeasures1
		{
			simulation = "particles";
			type = "Cmeasures1";
			position[] = {0,0,0};
			intensity = 1;
			interval = 1;
			lifeTime = 4.5;
			qualityLevel = 2;
		};
		class Cmeasures1M
		{
			simulation = "particles";
			type = "Cmeasures1M";
			position[] = {0,0,0};
			intensity = 1;
			interval = 1;
			lifeTime = 4.5;
			qualityLevel = 1;
		};
		class Cmeasures1L
		{
			simulation = "particles";
			type = "Cmeasures1L";
			position[] = {0,0,0};
			intensity = 1;
			interval = 1;
			lifeTime = 4.5;
			qualityLevel = 0;
		};
		class Cmeasures2
		{
			simulation = "particles";
			type = "Cmeasures2";
			position[] = {0,0,0};
			intensity = 1;
			interval = 1;
			lifeTime = 3.2;
		};
		class Light1
		{
			simulation = "light";
			type = "CmeasuresLight";
			position[] = {0,0,0};
			intensity = 1;
			interval = 1;
			lifeTime = 3;
		};
};

class CfgAmmo
{
	class Default {};
	class BulletCore : Default {};
	class B_30mm_HE: BulletCore {};
	class RocketCore: Default {};
	class RocketBase: RocketCore {};
	class 38Rnd_80mm_rockets: RocketBase {};
	class MissileCore : Default {};
	class MissileBase: MissileCore {};
	class CMflareAmmo: BulletCore {};
	class fza_ah64_flare_shot: CMflareAmmo 
	{
		hit = 1;
		indirectHit = 0;
		indirectHitRange = 0;
		timeToLive = 6;
		thrustTime = 4;
		airFriction = -0.01;
		simulation = "shotCM";
		effectsSmoke = "fza_CounterMeasureFlare";
		weaponLockSystem = 2;
		model = "\A3\weapons_f\empty";
		maxControlRange = -1;
		initTime = 0;
		aiAmmoUsageFlags = 8;	
	};
	class fza_master: Default
	{
		airLock=0;
		irLock=0;
		laserLock=0;
		nvLock=0;
		artilleryLock=0;
		weaponLockSystem=0;
		lockType=2;
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////M230/////////////////////////////////////
	///////////////////////////////////////////////////////////////////////	
	
	class fza_30x113: B_30mm_HE
	{
		access = 1;
		muzzleeffect = "fza_ah64_fx_30mm";		
		hit = 60;
		indirectHit = 10;
		indirectHitRange = 3.5;		
		maxspeed = 805;
		explosive = 0.50;
		airFriction = -0.00036;
		airlock = 0;
		irlock = 0;
		allowAgainstInfantry = 1;	
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////HELLFIRE/////////////////////////////////
	///////////////////////////////////////////////////////////////////////	
	
	class fza_agm114l : MissileBase
	{
		model = "\fza_ah64_US\fza_agm114l";
		proxyShape="\fza_ah64_US\fza_agm114l";
		simulation = "shotMissile";
		thrustTime=4;
		fuseDistance = 5;
		thrust = 60;
		trackOversteer = 1;
		trackLead = 1;
		simulationStep=0.01;
		sideairfriction = 0.2;
		effectsMissileInit = "MissileDAR1";
		effectsmissile = "fza_ah64_hellfiresmoke";
		muzzleEffect = "BIS_fnc_effectFiredRocket";
		whistledist = 300;
		explosionEffects = "BombExplosion";
		hit = 1400;
		indirectHit = 800;
		indirectHitRange = 10;
		timetolive= 50;
		initTime = 0.0000;
		manualControl = 0;
		weaponLockSystem = 8;
		laserLock = 0;
		airLock = 0;
		irlock = 0;	
		nvLock=0;
		maneuvrability = 10;
		airfriction = -0.00001;
		maxSpeed = 1200;
		cost = 1000;			
	};
	class fza_agm114k : MissileBase
	{
		model = "\fza_ah64_US\fza_agm114k";
		proxyShape="\fza_ah64_US\fza_agm114k";	
		simulation = "shotMissile";
		thrustTime=4;
		fuseDistance = 5;
		thrust = 60;
		trackOversteer = 1;
		trackLead = 1;
		simulationStep=0.01;
		sideairfriction = 0.2;
		effectsMissileInit = "MissileDAR1";
		effectsmissile = "fza_ah64_hellfiresmoke";
		muzzleEffect = "BIS_fnc_effectFiredRocket";
		whistledist = 300;
		explosionEffects = "BombExplosion";
		hit = 1400;
		indirectHit = 800;
		indirectHitRange = 10;
		timetolive= 50;
		initTime = 0.0000;
		manualControl = 0;
		weaponLockSystem = 4;
		laserLock = 1;
		airLock = 0;
		irlock = 0;	
		nvLock=0;
		canlock = 0;
		maneuvrability = 10;
		airfriction = -0.00001;
		maxSpeed = 1200;
		cost = 1000;			
	};
	class fza_agm114a : fza_agm114k
	{	
		model = "\fza_ah64_US\fza_agm114c";
		proxyShape="\fza_ah64_US\fza_agm114c";
		effectsmissile = "missile3";	
		hit = 800;
		indirectHit = 400;
		indirectHitRange = 10;
		cost = 1000;
	};
	class fza_agm114c : fza_agm114k
	{
		model = "\fza_ah64_US\fza_agm114c";
		proxyShape="\fza_ah64_US\fza_agm114c";		
		hit= 800;
		indirectHit = 400;
		indirectHitRange = 10;
		cost = 1000;
	};
	class fza_agm114m : fza_agm114k
	{
		model = "\fza_ah64_US\fza_agm114k";
		proxyShape ="\fza_ah64_US\fza_agm114k";		
		hit = 900;
		indirectHit = 500;
		indirectHitRange = 20;
		cost = 1000;
	};
	class fza_agm114n : fza_agm114k
	{	
		model = "\fza_ah64_US\fza_agm114k";
		proxyShape = "\fza_ah64_US\fza_agm114k";	
		hit = 600;
		indirecthit = 600;
		indirecthitrange = 20;
		explosionEffects = "BombExplosion";
		cost = 1000;
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////ROCKETS//////////////////////////////////
	///////////////////////////////////////////////////////////////////////	
	
	class fza_275_m151: 38Rnd_80mm_rockets
	{
		model = "\fza_ah64_us\weps\fza_hydra_m151_wep";
		soundfly[] = {"\fza_ah64_us\audio\fakesound.ogg",1,1,1};
		simulation="shotRocket";
		muzzleeffect = "BIS_fnc_effectFiredHeliRocket";
		effectsmissile = "fza_ah64_rocketsmoke";
		hit = 400;
		indirectHit = 60;
		indirectHitRange = 10;
		maxSpeed = 740;
		thrustTime = 3;
		thrust = 740;
		fuseDistance = 40;
		airfriction = -0.00001;
		cost=500;
	};
	class fza_275_m229: fza_275_m151
	{
		model = "\fza_ah64_us\weps\fza_hydra_m229_wep";		
		simulation="shotRocket";
		muzzleEffect = "BIS_fnc_effectFiredHeliRocket";
		soundfly[] = {"\fza_ah64_us\audio\fakesound.ogg",1,1,1};
		hit= 600;
		indirectHit = 120;
		indirectHitRange = 10;
		thrustTime = 3;
		thrust = 740;
		fusedistance = 40;
		cost=500;
	};
	class fza_275_m261: fza_275_m151
	{
		model = "\fza_ah64_us\weps\fza_hydra_m261_wep";
		hit=1;
		indirectHit=1;
		indirectHitRange=1;
		simulation="shotRocket";
		simulationStep=0.050000;
		maneuvrability=0;
		maxControlRange=0;
		thrustTime= 3;
		thrust = 740;
		fusedistance = 100;
		cost=9;
	};
	class fza_275_m255: fza_275_m151
	{
		model = "\fza_ah64_us\weps\fza_hydra_m261_wep";		
		hit=1;
		indirectHit=1;
		indirectHitRange=1;
		simulation="shotRocket";
		simulationStep=0.050000;
		maneuvrability=0;
		maxControlRange=0;
		thrustTime= 3;
		thrust = 740;
		fusedistance = 100;
		cost=8;
	};
	class fza_275_m257: fza_275_m151
	{
		hit=1;
		indirectHit=1;
		indirectHitRange=1;
		simulation="shotRocket";
		simulationStep=0.050000;
		maneuvrability=0;
		maxControlRange=0;
		thrustTime= 3;
		thrust = 740;
		model = "\fza_ah64_us\weps\fza_hydra_m261_wep";
		fusedistance = 100;
		cost=8;
	};
	class fza_fim92: MissileBase
	{
		ace_frag_skip = 1;
		airlock = 1;
		cmimmunity = 0.95;
		cratereffects = "AAMissileCrater";
		effectsmissile = "fza_ah64_stingersmoke";
		explosioneffects = "AAMissileExplosion";
		fusedistance = 5;
		hit = 120;
		indirecthit = 65;
		indirecthitrange = 4;
		inittime = 0.25;
		irlock = 1;
		maneuvrability = 4;
		maxspeed = 2400;
		model = "\fza_ah64_us\fza_fim92";
		sideairfriction = 0.25;
		airfriction = -0.00001;
		simulationstep = 0.01;
		thrust = 100;
		thrusttime = 3;
		timetolive = 17;
		tracklead = 0;
		trackoversteer = 0.85;
		weaponlocksystem = "16 + 2";
		whistledist = 16;
		cost = 5000;
	};
	class fza_m73mpsm: B_30mm_HE
	{
		hit=120;
		indirectHit=50;
		indirectHitRange=6;
		timeToLive=60;
		thrust = 0;
		thrusttime = 0;
		explosive = true;
		typicalspeed = 1;
		explosionEffects = "ExploAmmoExplosion";
	};
	class fza_flec_cluster: B_30mm_HE
	{
		hit=50;
		indirectHit=20;
		indirectHitRange=10;
		timeToLive=60;
		thrust = 0;
		thrusttime = 0;
		explosive = true;
		typicalspeed = 1;
		CraterEffects = "ExploAmmoCrater";
		explosionEffects = "ExploAmmoExplosion";
	};
	/*
	class fza_m257_flare: F_40mm_White
	{
		lightcolor[] = {0.5, 0.5, 0.5, 0};
		airfriction = -0.0050;
		timetolive = 100;
	};
	*/
};
