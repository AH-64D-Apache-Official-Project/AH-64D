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
	
	class fza_ah64_flare_shot: Bulletbase
	{
		hit 						= 1;
		indirectHit 				= 0;
		indirectHitRange 			= 0;
		timeToLive 					= 14;
		thrustTime 					= 4;
		airFriction 				= -0.01;
		simulation 					= "shotCM";
		effectsSmoke 				= "fza_AC130_Flares";
		weaponLockSystem 			= 2 + 8;
		model 						= "\A3\weapons_f\empty";
		maxControlRange 			= -1;
		initTime 					= 0;
		aiAmmoUsageFlags			= 8;	
	};
    class fza_IR_JAMMING_shot: FlareCore 
	{
		hit 						= 0;
		indirectHit 				= 0;
		indirectHitRange 			= 0;
		timeToLive 					= 15;
		thrustTime 					= 4;
		airFriction 				= -0.01;
		simulation 					= "shotCM";
		effectsSmoke 				= "";
		weaponLockSystem 			= 2;
		model 						= "\A3\weapons_f\empty";
		maxControlRange 			= -1;
		initTime 					= 0;
		aiAmmoUsageFlags			= 8;	
	};
    class fza_RF_JAMMING_shot: fza_IR_JAMMING_shot
	{
		weaponLockSystem 			= 8;
	};
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
	//////////////////////////////ROCKETS//////////////////////////////////
	///////////////////////////////////////////////////////////////////////	
	
	
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
	///////////////////////////////////////////////////////////////////////
	////////////////////////USAF Flares From AC130 Beta////////////////////
	////////////////////////Permission for use from pingopete//////////////
	////////////////////////anyone wishing to use this/////////////////////
	////////////////////////code and effect must contact///////////////////
	//////////////////////////////// pingopete ////////////////////////////

class fza_AC130_Flares
{
	class fza_FlareSmokeLong_VERYLOW
	{
		simulation="particles";
		type="fza_FlareSmokeLong_LOW";
		position[]={0,0,0};
		intensity=1;
		interval=1;
		lifeTime=4.5;
		qualityLevel=0;
		enabled=1;
	};
	class fza_FlareLightMain_LOW
	{
		simulation="light";
		type="fza_FlareLightMain";
		position[]={0,0,0};
		intensity=1;
		interval=1;
		lifeTime=3.5;
		qualityLevel=1;
		enabled=1;
	};
	class fza_FlareLightMain
	{
		simulation="light";
		type="fza_FlareLightMain";
		position[]={0,0,0};
		intensity=1;
		interval=1;
		lifeTime=3.5;
		qualityLevel=0;
		enabled=1;
	};
	class fza_FlareLightwhite
	{
		simulation="light";
		type="fza_FlareLightwhite";
		position[]={0,0,0};
		intensity=1;
		interval=1;
		lifeTime=4;
		enabled=1;
	};
	class fza_Flare_DayTime
	{
		simulation = "particles";
		type = "Cmeasures2";
		position[] = {0,0,0};
		intensity = 4;
		interval = 1;
		lifeTime = 3.2;
	};
};