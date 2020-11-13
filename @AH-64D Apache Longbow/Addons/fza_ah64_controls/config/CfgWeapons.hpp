class Mode_SemiAuto;
class CfgWeapons
{	
	class MGunCore;
	class MGun;
	class RocketPods;
	class CannonCore;
	class SmokeLauncher;
	class LauncherCore;
	class MissileLauncher;
	class missiles_DAR;
	
	class fza_CMFlareLauncher: SmokeLauncher 
	{
		scope = 2;
		displayName = "$STR_A3_CMFlareLauncher0";
		magazines[] = {"60Rnd_CMFlareMagazine"};
		magazineReloadTime = 0.200000;
		simulation = "cmlauncher";
		modes[] = {"Single"};
		class Single
		{
			displayName = "$STR_A3_CMFlareLauncher_weapon_mode_Single_name";
			reloadTime = 0.050000;
			burst = 1;
			autoFire = 1;
			useAction = 0;
			useActionTitle = 0;
			soundContinuous = 0;
			artilleryDispersion = 0;
			artilleryCharge = 0;
			textureType = "single";
			recoil = "Empty";
			recoilProne = "";
			sounds[] = {"StandardSound"};

			class StandardSound {
				begin1[] = {"\fza_ah64_us\audio\Flares.ogg", 1.000000, 1, 300};
				soundBegin[] = {"begin1", 1};
			};
			showToPlayer = 1;
			multiplier = 2;
			soundBurst = 0;
			dispersion = 0.400000;
			aiRateOfFire = 1;
			aiRateOfFireDistance = 10;
			minRange = 0;
			minRangeProbab = 0.010000;
			midRange = 1;
			midRangeProbab = 0.010000;
			maxRange = 2;
			maxRangeProbab = 0.010000;
		};
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////M230 CHAINGUN////////////////////////////
	///////////////////////////////////////////////////////////////////////

	class fza_m230: CannonCore
	{
		class GunParticles
		{
			class Effect
			{
				effectName = "MachineGun2";
				positionName = "Usti hlavne";
				directionName = "Konec hlavne";
			};
		};
		class StandardSound 
		{
			soundSetShot[] = {"fza_m230_soundset"};
		};	
		scope = 1;
		displayName="M230";
		cursor = "";
		cursorAim = "";
		reloadTime=0.102;
		weaponLockSystem = "8+4";
		ballisticscomputer = 1;
		weaponLockDelay = 0;
		autoreload = 1;
		multiplier = 1;
		shotFromTurret = 0;
		magazines[]={"fza_m230_300","fza_m230_1200"};
		modes[]= {"this"};
		sounds[] = {"StandardSound"};
		autofire= 1;
		useAction = 0;
		useActionTitle = "";
		recoil = "Empty";
		recoilProne = "Empty";
		dispersion = 0.006;
		aiRateOfFire = 0.102;
		aiRateOfFireDistance = 2800;
		minRange = 1200;
		minRangeProbab = 0.9;
		midRange = 1900;
		midRangeProbab = 0.9;
		maxRange = 2500;
		maxRangeProbab = 0.9;
		showToPlayer = 1;
	};		
	
	class fza_burstlimiter: fza_m230
	{	
		scope = 1;
		displayName="BURST LIMIT";
		cursor="";
		cursorAim="";
		magazines[]={"fza_burstlimit"};
	};	
		
	class fza_ma_safe: fza_m230
	{
		scope = 1;
		displayName="MASTER ARM SAFE";
		cursor="";
		cursorAim="";
		magazines[]={"fza_safe"};
	};

	///////////////////////////////////////////////////////////////////////
	//////////////////////////////HELLFIRE/////////////////////////////////
	///////////////////////////////////////////////////////////////////////
	
	class fza_hellfire : MissileLauncher
	{
		class StandardSound 
		{
			soundSetShot[] = {"fza_agm114_soundset"};
		};
		sounds[] = {"StandardSound"};		
		scope = 2;
		displayName="AGM-114K";
		#define HELLFIRE_DEFS(ammoName) ammoName##_ll, ammoName##_lr, ammoName##_ul, ammoName##_ur
		magazines[]={HELLFIRE_DEFS(fza_agm114k)};
		weaponLockDelay = 1;
		weaponLockSystem = 4;
		lockedtargetsound[] = {"", 1, 1};
		lockingtargetsound[] = {"", 1, 1};
		canlock = 0;
		lockAcquire = 0;
		cursor = "EmptyCursor";
		cursoraim = "EmptyCursor";
		aiRateOfFire = 5;
		aiRateOfFireDistance = 3000;
		minRange = 2000;
		minRangeProbab = 0.5;
		midRange = 3500;
		midRangeProbab = 1.0;
		maxRange = 8000;
		maxRangeProbab = 0.8;
		reloadtime = 1;	
		modes[]	= {TopDown,LoalDistance,Cruise};
		class TopDown: Mode_SemiAuto
		{
			textureType = "topDown";
			displayName = "LOAL-Lo";

			aiRateOfFire			= 5;
			aiRateOfFireDistance	= 1000;

			maxrange				= 8000;
			maxrangeprobab			= 0.6;
			midrange				= 2000;
			midrangeprobab			= 0.9;
			minrange				= 250;
			minrangeprobab			= 0.6;
			sounds[] = {"StandardSound"};
			class StandardSound 
			{
				soundSetShot[] = {"fza_agm114_soundset"};
			};
		};
		class LoalDistance: TopDown
		{
			displayName = "LOAL-DIR";
		};
		class Cruise: TopDown
		{
			displayName = "LOAL-HI";
		};
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////ROCKETS//////////////////////////////////
	///////////////////////////////////////////////////////////////////////
	
	class fza_hydra70: RocketPods
	{
		scope = 1;
		displayName="M261";
		cursor = "EmptyCursor";
		cursoraim = "EmptyCursor";
		burst=1;
		#define ROCKET_DEFS(ammoName) ammoName##_zoneA, ammoName##_zoneB, ammoName##_zoneE
		magazines[]={ROCKET_DEFS(fza_275_m151)
			, ROCKET_DEFS(fza_275_m229)
			, ROCKET_DEFS(fza_275_m255)
			, ROCKET_DEFS(fza_275_m261)
			, ROCKET_DEFS(fza_275_m257)};
		modes[]= {"Single"};
		class Single: LauncherCore
		{
			class StandardSound 
			{
				soundSetShot[] = {"fza_m261_soundset"};
			};	
			showToPlayer = 1;			
			displayName="M261";
			multiplier=1;
			burst=1;
			dispersion = 0.010;
			sounds[] = {"StandardSound"};
			soundburst= 1;
			soundContinuous= 0;
			reloadTime=0.01;
			autofire=0;
			useAction = 0;
			useActionTitle = "";
			minRange = 200;
			minRangeProbab = 0.041;
			midRange = 600;
			midRangeProbab = 0.21;
			maxRange = 2500;
			maxRangeProbab = 0.11;
			cursor = "EmptyCursor";
			cursoraim = "EmptyCursor";
		};
	};
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////STINGERS/////////////////////////////////
	///////////////////////////////////////////////////////////////////////	
	
	class fza_atas_2: MissileLauncher
	{
		class StandardSound 
		{
			soundSetShot[] = {"fza_atas_soundset"};
		};		
		airateoffire = 5;
		airateoffiredistance = 2500;
		cmimmunity = 0.8;
		canlock = 0;
		cursor = "";
		cursoraim = "";
		displayname = "FIM-92F Stinger";
		magazinereloadtime = 30;
		magazines[] = {"fza_atas_2"};
		maxrange = 4000;
		maxrangeprobab = 0.1;
		midrange = 1000;
		midrangeprobab = 0.8;
		minrange = 50;
		minrangeprobab = 0.3;
		reloadtime = 0.5;
		sounds[] = {"StandardSound"};
		weaponlockdelay = 0;
		weaponlocksystem = "1+2+8";
		lockedtargetsound[] = {"", 1, 1};
		lockingtargetsound[] = {"", 1, 1};
	};
};