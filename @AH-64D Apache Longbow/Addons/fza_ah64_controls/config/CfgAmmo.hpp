class CfgAmmo
{
	class Default{};
	class BulletCore : Default{};
	class BulletBase : BulletCore{};
	class B_20mm_AA: BulletBase {};
	class RocketCore: Default {};
	class RocketBase: RocketCore {};
	class R_Hydra_HE: RocketBase {};
	class MissileCore : Default{};
	class MissileBase: MissileCore{};
	class M_Sidewinder_AA: MissileBase{};
	class M_Stinger_AA: MissileBase{};
	class M_Hellfire_AT: MissileBase{};
	class B_30mm_MP: BulletBase
	{
		ace_frag_skip = 1;
	};
	class B_23mm_AA: BulletBase{};
	class B_127x107_Ball: BulletBase{};
	class ShellCore: Default {};
	class ShellBase: ShellCore {};
	class Sh_120_HE: ShellBase {};
	class GrenadeCore: Default {};
	class GrenadeBase: GrenadeCore {};
	class G_40mm_HE: GrenadeBase {};
	class FlareCore: GrenadeCore {};
	class FlareBase: FlareCore {};
	class F_40mm_White: FlareBase {};
	class CMflareAmmo: BulletBase {};
	class CMflare_Chaff_Ammo: CMflareAmmo {};

	class fza_ah64_chaff_shot: CMflareAmmo {};
	class fza_ah64_flare_shot: CMflareAmmo {};

	class fza_30x113: B_30mm_MP
	{
		hit=130;
		indirectHit=30;
		indirectHitRange=5;
		cost=50;
		explosive = 0.35;
		minRange=20;
		minRangeProbab=0.20;
		midRange=700;
		midRangeProbab=0.50;
		maxRange=2000;
		maxRangeProbab=0.05;
		timeToLive=8;
		tracerstarttime = 0;
		typicalspeed = 805;
		CraterEffects = "ExploAmmoCrater";
		explosionEffects = "ExploAmmoExplosion";
		muzzleeffect = "fza_ah64_fx_30mm";
		tracerColor[] = {0.800000,0.100000,0.100000,0.040000};
		tracerColorR[] = {0.800000,0.100000,0.100000,0.040000};
		model = "\A3\Weapons_f\Data\bullettracer\tracer_red";
	};
	class fza_agm114l : MissileBase
	{
		ace_frag_skip = 1;
		model = "\fza_ah64_US\fza_agm114l";
		proxyShape="\fza_ah64_US\fza_agm114l";
		hit = 2400;
		indirectHit = 100;
		indirectHitRange = 15;
		cost = 10000;
		maxSpeed = 1200;
		irLock = 0; //modified
		airLock= 0;
		laserLock = 0; //modified
		timetolive=50;
		manualControl = 0;
		maxControlRange = 8000;
		initTime = 0.0000;
		thrustTime=4;
		thrust = 60;
		trackOversteer = 1;
		trackLead = 1;
		maneuvrability = 10;
		weaponlocksystem = 8; //modified
		airfriction = -0.00001;
		simulationStep=0.01;
		muzzleeffect = "";
		effectsmissile = "fza_ah64_hellfiresmoke";
		cmimmunity = 0.8;
		fusedistance = 5;
		sideairfriction = 0.2;
		whistledist = 4;
		CraterEffects = "BombCrater";
		explosionEffects = "BombExplosion";
	};
	class fza_agm114k : fza_agm114l
	{
		hit=2400;
		indirectHit=100;
		indirectHitRange=15;
		//thrustTime=10;
		//thrust=400;
		//maxspeed=600;
		//sideAirFriction=0.6;
		weaponlocksystem = 4; //modified
		model = "\fza_ah64_US\fza_agm114k";
		proxyShape="\fza_ah64_US\fza_agm114k";
		airLock= 0;
		laserLock= 1;
		irLock= 1;
		//maneuvrability=25.0;
		//maxSpeed=250;
		minRange=200;
		minRangeProbab=0.200000;
		midRange=4000;
		midRangeProbab=0.200000;
		maxRange=8000;
		maxRangeProbab=0.50000;
	};
	class fza_agm114a : fza_agm114k
	{
		hit=625;
		indirectHit=30;
		indirectHitRange=10;
		//thrustTime=10;
		//thrust=400;
		//maxspeed=600;
		//sideAirFriction=0.6;
		model = "\fza_ah64_US\fza_agm114c";
		proxyShape="\fza_ah64_US\fza_agm114c";
		effectsmissile = "missile3";
		airLock=false;
		laserLock=true;
		irLock=true;
		//maneuvrability=25.0;
		//maxSpeed=250;
		minRange=200;
		minRangeProbab=0.200000;
		midRange=4000;
		midRangeProbab=0.200000;
		maxRange=8000;
		maxRangeProbab=0.50000;
	};
	class fza_agm114c : fza_agm114k
	{
		hit=625;
		indirectHit=30;
		indirectHitRange=10;
		//thrustTime=10;
		//thrust=400;
		//maxspeed=600;
		//sideAirFriction=0.6;
		model = "\fza_ah64_US\fza_agm114c";
		proxyShape="\fza_ah64_US\fza_agm114c";
		airLock=false;
		laserLock=true;
		irLock=true;
		//maneuvrability=25.0;
		//maxSpeed=250;
		minRange=200;
		minRangeProbab=0.200000;
		midRange=4000;
		midRangeProbab=0.200000;
		maxRange=8000;
		maxRangeProbab=0.50000;
	};
	class fza_agm114m : fza_agm114k
	{
		hit=1800;
		indirectHit=100;
		indirectHitRange=30;
		//thrustTime=10;
		//thrust=400;
		//maxspeed=600;
		//sideAirFriction=0.6;
		model = "\fza_ah64_US\fza_agm114k";
		proxyShape="\fza_ah64_US\fza_agm114k";
		airLock=false;
		laserLock=true;
		irLock=true;
		//maneuvrability=25.0;
		//maxSpeed=250;
		minRange=200;
		minRangeProbab=0.200000;
		midRange=4000;
		midRangeProbab=0.200000;
		maxRange=8000;
		maxRangeProbab=0.50000;
	};
	class fza_agm114n : fza_agm114m
	{
		hit=1200;
		indirectHit=70;
		indirectHitRange=40;
		//thrustTime=10;
		//thrust=400;
		//maxspeed=600;
		//sideAirFriction=0.6;
		model = "\fza_ah64_US\fza_agm114k";
		proxyShape="\fza_ah64_US\fza_agm114k";
		airLock=false;
		laserLock=true;
		irLock=true;
		//maneuvrability=25.0;
		//maxSpeed=250;
		minRange=200;
		minRangeProbab=0.200000;
		midRange=4000;
		midRangeProbab=0.200000;
		maxRange=8000;
		maxRangeProbab=0.50000;
	};
	class fza_275_m151: RocketBase
	{
		hit=160;
		indirectHit=80;
		indirectHitRange=10;
		minRange=100;
		minRangeProbab=0.200000;
		midRange=750;
		midRangeProbab=0.200000;
		maxRange=2000;
		maxRangeProbab=0.050000;
		simulation="shotRocket";
		simulationStep=0.050000;
		cost=10;
		maneuvrability=0;
		maxControlRange=0;
		thrustTime=1.3;
		thrust=1200;
		model = "\fza_ah64_us\weps\fza_hydra_m151_wep";
		airLock=false;
		fusedistance = 100;
		//laserLock=true;
		//irLock=true;
		muzzleeffect = "";
		effectsmissile = "fza_ah64_rocketsmoke";
		maxspeed = 740;
		sideairfriction = 0.2;
		timetolive = 20;
		whistledist = 24;
	};
	class fza_275_m229: fza_275_m151
	{
		hit=220;
		indirectHit=110;
		indirectHitRange=10;
		minRange=100;
		minRangeProbab=0.200000;
		midRange=750;
		midRangeProbab=0.200000;
		maxRange=2000;
		maxRangeProbab=0.050000;
		simulation="shotRocket";
		simulationStep=0.050000;
		cost=10;
		//model="ZUNI";
		maneuvrability=0;
		maxControlRange=0;
		thrustTime=1.3;
		thrust=1200;
		model = "\fza_ah64_us\weps\fza_hydra_m229_wep";
		airLock=false;
		fusedistance = 100;
		explosiontime = 0.1;
		//laserLock=true;
		//irLock=true;
	};
	class fza_275_m261: fza_275_m151
	{
		//hit=50;
		//indirectHit=50;
		//indirectHitRange=8;
		hit=1;
		indirectHit=1;
		indirectHitRange=1;
		minRange=100;
		minRangeProbab=0.200000;
		midRange=750;
		midRangeProbab=0.200000;
		maxRange=2000;
		maxRangeProbab=0.050000;
		simulation="shotRocket";
		simulationStep=0.050000;
		cost=9;
		//model="ZUNI";
		maneuvrability=0;
		maxControlRange=0;
		thrustTime=1.3;
		thrust=1200;
		model = "\fza_ah64_us\weps\fza_hydra_m261_wep";
		airLock=false;
		fusedistance = 100;
		//laserLock=true;
		//irLock=true;
	};
	class fza_275_m255: fza_275_m151
	{
		hit=1;
		indirectHit=1;
		indirectHitRange=1;
		minRange=100;
		minRangeProbab=0.200000;
		midRange=750;
		midRangeProbab=0.200000;
		maxRange=2000;
		maxRangeProbab=0.050000;
		simulation="shotRocket";
		simulationStep=0.050000;
		cost=8;
		//model="ZUNI";
		maneuvrability=0;
		maxControlRange=0;
		thrustTime=1.3;
		thrust=1200;
		model = "\fza_ah64_us\weps\fza_hydra_m261_wep";
		airLock=false;
		fusedistance = 100;
		//laserLock=true;
		//irLock=true;
	};
	class fza_275_m257: fza_275_m151
	{
		hit=1;
		indirectHit=1;
		indirectHitRange=1;
		minRange=100;
		minRangeProbab=0.200000;
		midRange=750;
		midRangeProbab=0.200000;
		maxRange=2000;
		maxRangeProbab=0.050000;
		simulation="shotRocket";
		simulationStep=0.050000;
		cost=8;
		//model="ZUNI";
		maneuvrability=0;
		maxControlRange=0;
		thrustTime=1.3;
		thrust=1200;
		model = "\fza_ah64_us\weps\fza_hydra_m261_wep";
		airLock=false;
		fusedistance = 100;
		//laserLock=true;
		//irLock=true;
	};
	class fza_fim92: MissileBase
	{
		ace_frag_skip = 1;
		airlock = 1;
		cmimmunity = 0.95;
		cost = 10000;
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
	};
	class fza_m73mpsm: B_30mm_MP
	{
		hit=120;
		indirectHit=50;
		indirectHitRange=6;
		timeToLive=60;
		thrust = 0;
		thrusttime = 0;
		explosive = true;
		typicalspeed = 1;
		CraterEffects = "ExploAmmoCrater";
		explosionEffects = "ExploAmmoExplosion";
	};
	class fza_flec_cluster: B_30mm_MP
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
	class fza_m257_flare: F_40mm_White
	{
		lightcolor[] = {0.5, 0.5, 0.5, 0};
		airfriction = -0.0050;
		timetolive = 100;
	};
};
