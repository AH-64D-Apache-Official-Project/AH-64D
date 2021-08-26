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
    class fza_AseIRjammer: SmokeLauncher 
	{
		scope = 2;
		displayName = "IRJAM";
		magazines[] = {"fza_IR_JAMMING"};
		magazineReloadTime = 0.500000;
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
				begin1[] = {"", 1.000000, 1, 300};
				soundBegin[] = {"begin1", 1};
			};
			showToPlayer = 0;
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
    class fza_AseRFjammer: fza_AseIRjammer
	{
		displayName = "RFJAM";
		magazines[] = {"fza_RF_JAMMING"};
		modes[] = {"Single"};

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
		nameSound="cannon";
		cursor = "";
		cursorAim = "";
		showAimCursorInternal=0;
		reloadTime=0.109;
		weaponLockSystem = "8+4";
		ballisticscomputer = 16;
		FCSMaxLeadSpeed=200;
		FCSZeroingDelay=0;
		maxZeroing=4200;
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
		showToPlayer = 1;
		dispersion = 0.006;

		//AI
		burst=1;
		burstRangeMax=50;
		aiRateOfFire=0.1091;
		aiRateOfFireDispersion=2;
		aiRateOfFireDistance=0;
		minRange=0;
		minRangeProbab=0.64999998;
		midRange=1500;
		midRangeProbab=0.75;
		maxRange=3000;
		maxRangeProbab=0.69999999;
		aiDispersionCoefY=0.5;
		aiDispersionCoefX=0.5;
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
	class fza_Fx1: fza_m230
	{
		showToPlayer = 0;
		magazines[]={"fza_Fb1"};
	};	
	class fza_Fx2: fza_Fx1
	{
		magazines[]={"fza_Fb2"};
	};	

	///////////////////////////////////////////////////////////////////////
	//////////////////////////////HELLFIRE/////////////////////////////////
	///////////////////////////////////////////////////////////////////////
	
	class fza_hellfire : MissileLauncher
	{
		scope = private;
		class StandardSound 
		{
			soundSetShot[] = {"fza_agm114_soundset"};
		};
		sounds[] = {"StandardSound"};
		displayName="AGM-114K";
		magazines[]={};
		weaponLockDelay = 1;
		weaponLockSystem = 4;
		lockedtargetsound[] = {"", 1, 1};
		lockingtargetsound[] = {"", 1, 1};
		canlock = 0;
		lockAcquire = 0;
		cursor = "EmptyCursor";
		cursoraim = "EmptyCursor";
		minRange = 500;
		minRangeProbab = 0.7;
		midRange = 3500;
		midRangeProbab = 1.0;
		maxRange = 8000;
		maxRangeProbab = 0.8;	
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
	#define HELLFIRE_DEFS(ammoName) ammoName##_ll, ammoName##_lr, ammoName##_ul, ammoName##_ur
	#define HELLFIRE_CONFIG(ammoName, prettyName) \
		class ammoName##_wep : fza_hellfire {\
			scope = protected;\
			displayName = prettyName;\
			magazines[] = {HELLFIRE_DEFS(ammoName)};\
		} 
	HELLFIRE_CONFIG(fza_agm114a, "AGM-114A")
	HELLFIRE_CONFIG(fza_agm114c, "AGM-114C")
	HELLFIRE_CONFIG(fza_agm114k, "AGM-114K")
	HELLFIRE_CONFIG(fza_agm114l, "AGM-114L")
	HELLFIRE_CONFIG(fza_agm114m, "AGM-114M")
	HELLFIRE_CONFIG(fza_agm114n, "AGM-114N")
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////ROCKETS//////////////////////////////////
	///////////////////////////////////////////////////////////////////////
	
	class fza_hydra70: RocketPods
	{
		scope = private;
		displayName="M261";
		cursor = "EmptyCursor";
		cursoraim = "EmptyCursor";
		burst=1;
		magazines[]={};
		modes[]= {
			"Single",
			"Medium_AI",
			"Close_AI"
		};
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
			burstRangeMax=4;
			aiRateOfFire=4;
			aiRateOfFireDistance=0;
			aiRateOfFireDispersion=4;
			minRange=1000;
			minRangeProbab=0.69999999;
			midRange=1500;
			midRangeProbab=0.69999999;
			maxRange=3200;
			maxRangeProbab=0.1;
			cursor = "EmptyCursor";
			cursoraim = "EmptyCursor";
		};
		class Medium_AI: Single
		{
			aiBurstTerminable=1;
			showToPlayer=0;
			burst=1;
			burstRangeMax=6;
			aiRateOfFire=3;
			aiRateOfFireDistance=0;
			aiRateOfFireDispersion=3;
			minRange=400;
			minRangeProbab=0.1;
			midRange=800;
			midRangeProbab=0.69999999;
			maxRange=1200;
			maxRangeProbab=0.75;
		};
		class Close_AI: Medium_AI
		{
			aiBurstTerminable=1;
			showToPlayer=0;
			burst=1;
			burstRangeMax=42;
			aiRateOfFire=1;
			aiRateOfFireDistance=0;
			minRange=1600;
			minRangeProbab=0.6;
			midRange=2000;
			midRangeProbab=0.69;
			maxRange=2400;
			maxRangeProbab=0.8;
		};
	};
	#define ROCKET_DEFS(ammoName) ammoName##_zoneA, ammoName##_zoneB, ammoName##_zoneE
	#define ROCKET_CONFIG(ammoName, prettyName) \
		class ammoName##_wep : fza_hydra70 {\
			scope = protected;\
			displayName = prettyName;\
			magazines[] = {ROCKET_DEFS(ammoName)};\
		} 
	ROCKET_CONFIG(fza_275_m151, "M151 HEDP")
	ROCKET_CONFIG(fza_275_m229, "M229 HEDP")
	ROCKET_CONFIG(fza_275_m255, "M255 FLEC")
	ROCKET_CONFIG(fza_275_m261, "M261 MPSM")
	ROCKET_CONFIG(fza_275_m257, "M257 IL")
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