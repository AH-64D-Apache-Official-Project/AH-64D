class Mode_SemiAuto;
class CfgWeapons
{	
	class RocketPods;
	class CannonCore;
	class SmokeLauncher;
	class MissileLauncher;
	class arifle_SPAR_01_blk_F;

	class fza_CMFlareLauncher: SmokeLauncher 
	{
		scope = 2;
		displayName = "$STR_A3_CMFlareLauncher0";
		magazines[] = {"60Rnd_CMFlareMagazine"};
		magazineReloadTime = 0.500000;
		simulation = "cmlauncher";
		modes[] = {"Single","AIBurst"};
		class Single: Mode_SemiAuto
		{
			displayName = "$STR_A3_CMFlareLauncher_weapon_mode_Single_name";
			reloadTime = 0.05;
			useAction = 0;
			useActionTitle = "";
			artilleryDispersion = 0;
			artilleryCharge = 0;
			burst = 1;
			sounds[] = {"StandardSound"};
			class StandardSound {
				begin1[] = {"\fza_ah64_us\audio\Flares.ogg", 1.000000, 1, 300};
				soundBegin[] = {"begin1", 1};
			};
			showToPlayer = 1;
			multiplier = 2;
			soundBurst = 0;
			dispersion = 0.4;
			aiRateOfFire = 1;
			aiRateOfFireDistance = 10;
			minRange = 0;
			minRangeProbab = 0.01;
			midRange = 1;
			midRangeProbab = 0.01;
			maxRange = 2;
			maxRangeProbab = 0.01;
		};
		class AIBurst: Mode_SemiAuto
		{
			burst = 5;
			burstRangeMax = 7;
			showToPlayer = 0;
			soundBurst = 0;
			minRange = 100;
			minRangeProbab = 1;
			midRange = 1000;
			midRangeProbab = 1;
			maxRange = 25000;
			maxRangeProbab = 1;
			sounds[] = {"StandardSound"};
			class StandardSound {
				begin1[] = {"", 1.000000, 1, 300};
				soundBegin[] = {"begin1", 1};
			};
		};
	};
    class fza_AseIRjammer: SmokeLauncher 
	{
		scope = 2;
		displayName = "IRJAM";
		magazines[] = {"fza_IR_JAMMING"};
		magazineReloadTime = 0.500000;
		simulation = "cmlauncher";
		modes[] = {"Single","AIBurst"};
		class Single
		{
			displayName = "$STR_A3_CMFlareLauncher_weapon_mode_Single_name";
			reloadTime = 0.050000;
			useAction = 0;
			useActionTitle = "";
			artilleryDispersion = 0;
			artilleryCharge = 0;
			burst = 1;
			autoFire = 1;
			soundContinuous = 0;
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
		class AIBurst: Mode_SemiAuto
		{
			burst = 3;
			burstRangeMax = 7;
			showToPlayer = 0;
			soundBurst = 0;
			minRange = 100;
			minRangeProbab = 1;
			midRange = 1000;
			midRangeProbab = 1;
			maxRange = 25000;
			maxRangeProbab = 1;
			sounds[] = {"StandardSound"};
			class StandardSound {
				begin1[] = {"", 1.000000, 1, 300};
				soundBegin[] = {"begin1", 1};
			};
		};
	};
    class fza_AseRFjammer: fza_AseIRjammer
	{
		displayName = "RFJAM";
		magazines[] = {"fza_RF_JAMMING"};

	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////M230 CHAINGUN////////////////////////////
	///////////////////////////////////////////////////////////////////////

	class fza_m230: CannonCore
	{
		scope 				= 1;
		displayName			= "M230-E1";
		nameSound 			= "cannon";
		cursor 				= "EmptyCursor";
		cursorAim 			= "mg";
		showAimCursorInternal = 0;
		magazines[]			={"fza_m230_300","fza_m230_1200"};
        canLock 			= 1;
		ballisticsComputer 	= "1 + 2 + 16";
		FCSZeroingDelay 	= 0;
		maxZeroing 			= 4200;
		aiDispersionCoefY 	= 0.5;
		aiDispersionCoefX 	= 0.5;
		weaponLockDelay 	= 0;
		multiplier 			= 1;
		shotFromTurret 		= 0;
		useAction 			= 0;
		useActionTitle 		= "";
		modes[] 			= {"manual","close","short","medium","far"};

		//ACE Advanced Ballistics Cfg
		ACE_barrelTwist 			= 177.8;
        ACE_barrelLength 			= 1066;
		ACE_twistDirection 			= 1;
        ace_overpressure_angle 		= 90;
        ace_overpressure_range 		= 2;
        ace_overpressure_damage 	= 0.265;

		class GunParticles
		{
			class Effect
			{
				effectName = "MachineGun2";
				positionName = "Usti hlavne";
				directionName = "Konec hlavne";
			};
		};
		class manual: CannonCore
		{
			displayName="M230";
			autoFire = 1;
			textureType = "fullAuto";
			sounds[] = {"StandardSound"};
            class StandardSound 
            {
                soundSetShot[] = {"fza_m230_soundset"};
            };	
			soundContinuous = 0;
			soundBurst = 0;
			reloadTime = 0.109;
			dispersion = 0.006;
			aiRateOfFire = 1;
			aiRateOfFireDistance = 10;
			minRange = 0;
			minRangeProbab = 0.01;
			midRange = 1;
			midRangeProbab = 0.01;
			maxRange = 2;
			maxRangeProbab = 0.01;
		};
		class close: manual
		{
			aiBurstTerminable = 1;
			showToPlayer = 0;
			burst = 16;
			burstRangeMax = 37;
			aiRateOfFire = 0.5;
			aiRateOfFireDispersion = 1;
			aiRateOfFireDistance = 50;
			minRange = 0;
			minRangeProbab = 0.1;
			midRange = 50;
			midRangeProbab = 0.65;
			maxRange = 400;
			maxRangeProbab = 0.75;
		};
		class short: close
		{
			aiBurstTerminable = 1;
			showToPlayer = 0;
			burst = 12;
			burstRangeMax = 32;
			aiRateOfFire = 1;
			aiRateOfFireDispersion = 2;
			aiRateOfFireDistance = 200;
			minRange = 200;
			minRangeProbab = 0.65;
			midRange = 400;
			midRangeProbab = 0.75;
			maxRange = 1000;
			maxRangeProbab = 0.7;
		};
		class medium: close
		{
			aiBurstTerminable = 1;
			showToPlayer = 0;
			burst = 12;
			burstRangeMax = 28;
			aiRateOfFire = 2;
			aiRateOfFireDispersion = 2;
			aiRateOfFireDistance = 800;
			minRange = 800;
			minRangeProbab = 0.7;
			midRange = 1400;
			midRangeProbab = 0.4;
			maxRange = 1800;
			maxRangeProbab = 0.15;
		};
		class far: close
		{
			aiBurstTerminable = 1;
			showToPlayer = 0;
			burst = 9;
			burstRangeMax = 20;
			aiRateOfFire = 4;
			aiRateOfFireDispersion = 4;
			aiRateOfFireDistance = 1400;
			minRange = 1400;
			minRangeProbab = 0.5;
			midRange = 1800;
			midRangeProbab = 0.15;
			maxRange = 2500;
			maxRangeProbab = 0.05;
		};
	};		
	
	class fza_burstlimiter: fza_m230
	{	
		scope = 1;
		displayName="BURST LIMIT";
		cursor="";
		cursorAim="";
		magazines[]={"fza_burstlimit"};
		textureType = "single";
	};	
		
	class fza_ma_safe: fza_m230
	{
		scope = 1;
		displayName="MASTER ARM SAFE";
		cursor="";
		cursorAim="";
		magazines[]={"fza_safe"};
		textureType = "single";
	};
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////HELLFIRE/////////////////////////////////
	///////////////////////////////////////////////////////////////////////
	
	class ace_hellfire_launcher;
	class fza_hellfire_laser: ace_hellfire_launcher
	{
		scope = private;
		displayName="AGM-114";
		magazines[]={};
		holdsterAnimValue = 3;
		reloadTime = 0.1;
		magazineReloadTime = 0.1;
		showAimCursorInternal = 0;
		textureType = "semi";
		weaponLockDelay = 0;
		weaponLockSystem = 4;
		cmImmunity = 0.9;
		lockedtargetsound[] = {"", 1, 1};
		lockingtargetsound[] = {"", 1, 1};
		sounds[] = {"StandardSound"};
		class StandardSound 
		{
			soundSetShot[] = {"fza_agm114_soundset"};
		};
		//ACE CFG
		ace_overpressure_angle = 50;
		ace_overpressure_range = 12;
		ace_overpressure_damage = 0.7;
		ace_overpressure_offset = 1;
	};
	#define HELLFIRE_MAGAZINES(ammoName) ammoName##_ll, ammoName##_lr, ammoName##_ul, ammoName##_ur
	#define HELLFIRE_WEAPON_CONFIG_LASER(ammoName, prettyName) \
		class ammoName##_wep : fza_hellfire_laser {\
			scope = protected;\
			displayName = prettyName;\
			magazines[] = {HELLFIRE_MAGAZINES(ammoName)};\
			fza_ammoType = ammoName;\
		};
	HELLFIRE_WEAPON_CONFIG_LASER(fza_agm114a, "AGM-114A")
	HELLFIRE_WEAPON_CONFIG_LASER(fza_agm114c, "AGM-114C")
	HELLFIRE_WEAPON_CONFIG_LASER(fza_agm114k, "AGM-114K")
	HELLFIRE_WEAPON_CONFIG_LASER(fza_agm114m, "AGM-114M")
	HELLFIRE_WEAPON_CONFIG_LASER(fza_agm114n, "AGM-114N")
	
	class fza_hellfire_radar: ace_hellfire_launcher
	{
		scope = private;
		displayName="AGM-114";
		magazines[]={};
		holdsterAnimValue = 3;
		reloadTime = 0.1;
		magazineReloadTime = 0.1;
		showAimCursorInternal = 0;
		textureType = "semi";
		weaponLockDelay = 0;
		weaponLockSystem = 4;
		cmImmunity = 0.9;
		lockedtargetsound[] = {"", 1, 1};
		lockingtargetsound[] = {"", 1, 1};
		sounds[] = {"StandardSound"};
		class StandardSound 
		{
			soundSetShot[] = {"fza_agm114_soundset"};
		};
		//ACE CFG
		ace_overpressure_angle = 50;
		ace_overpressure_range = 12;
		ace_overpressure_damage = 0.7;
		ace_overpressure_offset = 1;
	};
	#define HELLFIRE_MAGAZINES(ammoName) ammoName##_ll, ammoName##_lr, ammoName##_ul, ammoName##_ur
	#define HELLFIRE_WEAPON_CONFIG_RADAR(ammoName, prettyName) \
		class ammoName##_wep : fza_hellfire_radar {\
			scope = protected;\
			displayName = prettyName;\
			magazines[] = {HELLFIRE_MAGAZINES(ammoName)};\
			fza_ammoType = ammoName;\
		};
	HELLFIRE_WEAPON_CONFIG_RADAR(fza_agm114l, "AGM-114L")
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////ROCKETS//////////////////////////////////
	///////////////////////////////////////////////////////////////////////
	
	class fza_hydra70: RocketPods
	{
		scope = private;
		displayName="M261";
		magazines[]={};
		modes[] = {"Single","Far_AI","Medium_AI"};
		canLock = 0;
		weaponLockDelay = 0.0;
		cursor = "EmptyCursor";
		cursorAim = "rocket";
		holdsterAnimValue = 3;
		weight = 80;
		useAction = 0;
		useActionTitle = "";

		//ACE CFG
		ace_overpressure_angle = 50;
		ace_overpressure_range = 5;
		ace_overpressure_damage = 0.4;
		ace_overpressure_offset = 1;

		class Far_AI: RocketPods
		{
		    displayName="M261";
			sounds[] = {"StandardSound"};
			class StandardSound 
			{
				soundSetShot[] = {"fza_m261_soundset"};
			};
			autoFire = 0;
			reloadTime = 0.09;
			dispersion = 0.08;
			showToPlayer = 0;
			aiRateOfFire = 4;
			aiRateOfFireDispersion = 4;
			aiRateOfFireDistance = 1000;
			minRange = 1000;
			minRangeProbab = 0.7;
			midRange = 1500;
			midRangeProbab = 0.7;
			maxRange = 3200;
			maxRangeProbab = 0.1;
		};
		class Medium_AI: Far_AI
		{
			showToPlayer = 0;
			aiRateOfFire = 3;
			aiRateOfFireDispersion = 3;
			aiRateOfFireDistance = 1000;
			minRange = 400;
			minRangeProbab = 0.1;
			midRange = 800;
			midRangeProbab = 0.7;
			maxRange = 1200;
			maxRangeProbab = 0.75;
		};
		class Single: RocketPods
		{
		    displayName="M261";
			soundContinuous = 0;
			autoFire = 0;
			reloadTime = 0.09;
			dispersion = 0.015;
			aiRateOfFire = 1;
			aiRateOfFireDistance = 10;
			minRange = 0;
			minRangeProbab = 0.01;
			midRange = 1;
			midRangeProbab = 0.01;
			maxRange = 2;
			maxRangeProbab = 0.01;
			sounds[] = {"StandardSound"};
			class StandardSound 
			{
				soundSetShot[] = {"fza_m261_soundset"};
			};
			textureType = "semi";
		};
	};
	#define ROCKET_MAGAZINES(ammoName) ammoName##_zoneA, ammoName##_zoneB, ammoName##_zoneE
	#define ROCKET_WEAPON_CONFIG(ammoName, prettyName) \
		class ammoName##_wep : fza_hydra70 {\
			scope = protected;\
			displayName = prettyName;\
			magazines[] = {ROCKET_MAGAZINES(ammoName)};\
			fza_ammoType = ammoName;\
		};
	ROCKET_WEAPON_CONFIG(fza_275_m151, "M151 HEDP")
	ROCKET_WEAPON_CONFIG(fza_275_m229, "M229 HEDP")
	ROCKET_WEAPON_CONFIG(fza_275_m255, "M255 FLEC")
	ROCKET_WEAPON_CONFIG(fza_275_m261, "M261 MPSM")
	ROCKET_WEAPON_CONFIG(fza_275_m257, "M257 IL")
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////STINGERS/////////////////////////////////
	///////////////////////////////////////////////////////////////////////	
	
	class fza_atas_2: RocketPods
	{
		displayname = "FIM-92F Stinger";
		magazines[] = {"fza_atas_2"};
		magazinereloadtime = 30;
		reloadtime = 1;
		holdsterAnimValue = 2;
		aiRateOfFire = 5.0;
		aiRateOfFireDistance = 500;
		autoFire = 0;
		cursor = "EmptyCursor";
		cursorAim = "missile";
		showAimCursorInternal = 0;
		nameSound = "MissileLauncher";
		textureType = "fullAuto";
		weaponLockDelay = 0;
		weaponLockSystem = 2;
		cmImmunity = 0.7;
		lockedtargetsound[] = {"", 1, 1};
		lockingtargetsound[] = {"", 1, 1};
		sounds[] = {"StandardSound"};
		class StandardSound
		{
			begin1[] = {"A3\Sounds_F_EPC\Weapons\missile_epc_3",1.0,1,2000};
			soundBegin[] = {"begin1",1};
		};
		minRange = 160;
		minRangeProbab = 0.25;
		midRange = 1250;
		midRangeProbab = 0.95;
		maxRange = 4000;
		maxRangeProbab = 0.85;
	};

	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////Crew Weapon//////////////////////////////
	///////////////////////////////////////////////////////////////////////

	class arifle_SPAR_01_blk_MRCO_Flash_F: arifle_SPAR_01_blk_F
	{
		author = "Rosd6(Dryden)";
		_generalMacro = "arifle_SPAR_01_blk_MRCO_Flash_F";
		baseWeapon = "arifle_SPAR_01_blk_F";
		scope = 1;
		class LinkedItems
		{
			class LinkedItemsOptic
			{
				slot = "CowsSlot";
				item = "optic_MRCO";
			};
			class LinkedItemsAcc
			{
				slot = "PointerSlot";
				item = "acc_flashlight";
			};
		};
	};
};