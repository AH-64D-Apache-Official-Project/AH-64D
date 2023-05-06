class CfgAmmo
{
	class Default{};
	class B_30mm_HE;
	class Bulletbase;
	class MissileBase;
	class Missile_AA_04_F;
	class M_Scalpel_AT : MissileBase {
		class Components;
		class EventHandlers;
	};
	class FlareCore;
	class B_9x21_Ball;
	class ammo_Penetrator_Base;
	class fza_master: Default
	{
		airLock						=0;
		irLock						=0;
		laserLock					=0;
		nvLock						=0;
		artilleryLock				=0;
		weaponLockSystem			=0;
		lockType					=2;
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////STINGERS/////////////////////////////////
	///////////////////////////////////////////////////////////////////////	

	class fza_fim92: Missile_AA_04_F
	{
		model = "\fza_ah64_us\fza_fim92";
		proxyShape = "\fza_ah64_us\fza_fim92";
		cost = 1000;
		hit = 100;
		indirectHit = 75;
		indirectHitRange = 9;
		proximityExplosionDistance = 15;
		warheadName = "HE";
		airLock = 2;
		irLock = 1;
		laserLock = 0;
		nvLock = 0;
		missileLockCone = 45;
		missileKeepLockedCone = 60;
		missileLockMaxDistance = 4500;
		missileLockMinDistance = 150;
		missileLockMaxSpeed = 445;
		weaponLockSystem = "2 + 16";
		cmImmunity = 0.9;
		manualControl = 0;
		maxControlRange = 8000;
		aiAmmoUsageFlags = 256;
		initTime = 0;
		thrust = 220;
		thrustTime = 5;
		airFriction = 0.14;
		sideAirFriction = 0.2;
		maxSpeed = 2700;
		maneuvrability = 36;
		simulationStep = 0.002;
		fuseDistance = 500;
		timeToLive = 20;
		trackLead = 0.9;
		trackOversteer = 1;
		craterEffects = "ATRocketCrater";
		effectsMissileInit = "PylonBackEffects";
		effectsmissile = "fza_ah64_stingersmoke";
		explosioneffects = "AAMissileExplosion";
		muzzleEffect = "fza_ah64_fx_msl_shake";
		whistleDist = 16;
		soundsetexplosion[] = {"fza_rocket_explosion_soundset", "fza_rocket_explosion_stereo_soundset", "fza_shell_explosion_reverb_soundset"};		
		soundsetsoniccrack[] = {"fza_sc_rocket_flyby_soundset"};
		soundfly[]  = {"fza_ah64_us\audio\Flyby\soundfly1.ogg", 1, 1.500000, 400};
		class Hiteffects
		{
			hitWater = "ImpactEffectsSmall";
		};
		class CamShakeExplode
		{
			power = 22;
			duration = 2;
			frequency = 20;
			distance = 163.905;
		};
		class CamShakeHit
		{
			power = 110;
			duration = 0.6;
			frequency = 20;
			distance = 1;
		};
		class CamShakeFire
		{
			power = 2.9907;
			duration = 1.8;
			frequency = 20;
			distance = 71.5542;
		};
		class CamShakePlayerFire
		{
			power = 4;
			duration = 0.1;
			frequency = 20;
			distance = 1;
		};
	};
};