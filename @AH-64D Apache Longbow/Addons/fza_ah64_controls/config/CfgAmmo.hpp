class CfgAmmo
{
	class Default{};
	class B_30mm_HE;
	class Bulletbase;
	class MissileBase;
	class Missile_AA_04_F;
	class Missile_AGM_02_F : MissileBase {
		class Components;
		class EventHandlers;
	};
	class GrenadeBase;
	class FlareCore;
	class B_9x21_Ball;
	class ammo_Penetrator_Base;
	
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
	//////////////////////////////M230/////////////////////////////////////
	///////////////////////////////////////////////////////////////////////	
	
	class fza_30x113: B_30mm_HE
	{
		ace_frag_enabled			= 0;
		ace_frag_skip 				= 1;
		soundsetbulletfly[] 		= {"fza_sc_bullet_flyby_soundset"};
		soundsetsoniccrack[] 		= {"fza_sc_30x113_soundset"};
		soundsetexplosion[] 		= {"fza_20mm_explosion_soundset", "fza_explosion_echo_small_soundset"};

		//duel purpose warhead
		submunitionAmmo				="ammo_Penetrator_30mm";
		submunitionDirectionType	="SubmunitionModelDirection";
		submunitionInitSpeed		=1000;
		submunitionParentSpeedCoef	=0;
		submunitionInitialOffset[]	={0,0,-0.2};
		triggerOnImpact				=1;
		deleteParentWhenTriggered	=0;

		hit 						= 60;
		indirectHit 				= 20;
		indirectHitRange 			= 3.5;		
		maxspeed 					= 805;
		explosive					= 0.8;

		airFriction 				= -0.00036;
		airlock 					= 0;
		irlock						= 0;
		weaponType 					= "cannon";

		//AI uasge
		aiAmmoUsageFlags 			= "64+128+256";
		allowAgainstInfantry 		= 1;
		cost 						= 15;
		visibleFire=32;
		audibleFire=200;
		visibleFireTime=3;
		dangerRadiusBulletClose=20;
		dangerRadiusHit=60;
		suppressionRadiusBulletClose=12;
		suppressionRadiusHit=24;

		aiRateOfFire = 0.109;
		aiRateOfFireDistance = 0;
		minRange = 0;
		minRangeProbab = 0.9;
		midRange = 2400;
		midRangeProbab = 0.8;
		maxRange = 3500;
		maxRangeProbab = 0.6;
		class CamShakeExplode
		{
			power = 6;
			duration = 1;
			frequency = 20;
			distance = 67.8178;
		};
		class CamShakeHit
		{
			power = 30;
			duration = 0.4;
			frequency = 20;
			distance = 1;
		};
		class CamShakeFire
		{
			power = 2.23607;
			duration = 1;
			frequency = 20;
			distance = 40;
		};
		class CamShakePlayerFire
		{
			power = 0.01;
			duration = 0.1;
			frequency = 20;
			distance = 1;
		};
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////HELLFIRE/////////////////////////////////
	///////////////////////////////////////////////////////////////////////	

	class Fza_Penetrator_9KG_Tandem: ammo_Penetrator_Base
	{
		caliber = 60;
		warheadName = "TandemHEAT";
		hit = 1650;
	};
	class Fza_Penetrator_8KG: ammo_Penetrator_Base
	{
		caliber = 60;
		warheadName = "HEAT";
		hit = 780;
	};
	class fza_agm114base : Missile_AGM_02_F {

		ace_frag_enabled 			= 0;
		ace_frag_skip 				= 1;

		fza_salType 				= "sal2";
		irLock						= 1;
		laserLock					= 0;
		airLock						= 0;

		maxSpeed					= 166;
		simulationStep				= 0.005;
		airFriction					= 0.03;
		sideAirFriction				= 0.15;
		initTime					= 0;
		thrustTime					= 3;
		thrust						= 199;
		fuseDistance				= 100;
		manualControl 				= 0;
		maxControlRange				= 8000;
		trackOversteer				= 1;
		trackLead					= 1;
		maneuvrability				= 21;
		timeToLive					= 70;
		cmImmunity					= 0.97;

		//AI uasge
		aiAmmoUsageFlags 			= "64+128+512";
		allowAgainstInfantry 		= 1;
		cost 						= 1000;
		minRange = 300;
		minRangeProbab = 0.7;
		midRange = 3500;
		midRangeProbab = 1.0;
		maxRange = 8000;
		maxRangeProbab = 0.8;	

		//Penetrator
		submunitionAmmo				="Fza_Penetrator_9KG_Tandem";
		submunitionDirectionType	="SubmunitionModelDirection";
		submunitionInitSpeed		=1000;
		submunitionParentSpeedCoef	=0;
		submunitionInitialOffset[]	={0,0,-0.2};
		triggerOnImpact				=1;
		deleteParentWhenTriggered	=0;

		effectsmissile 				= "fza_ah64_hellfiresmoke";
		muzzleEffect 				= "BIS_fnc_effectFiredHeliRocket";
		effectsMissileInit 			= "MissileDAR1";
		explosionEffects 			= "BombExplosion"; 
		soundsetsoniccrack[] 		= {"fza_sc_wire_flyby_soundset"};
		soundfly[]  				= {"fza_ah64_us\audio\Flyby\soundfly1.ogg", 1, 1.500000, 400};
		soundsetexplosion[] 		= {"fza_rocket_explosion_soundset", "fza_missile_explosion_stereo_soundset", "fza_shell_explosion_reverb_soundset"};
		whistledist 				= 300;

		//Missile sensors definition
		missileLockMaxDistance		= 8000;
		missileLockMinDistance		= 200;
		missileLockMaxSpeed			= 56;
		missileLockCone				= 90;
		missileKeepLockedCone		= 90;
		lockSeekRadius				= 2000;
		autoSeekTarget 				= 0;
		weaponLockSystem			= "4 + 8";
		maneuvDependsOnSpeedCoef	= 0.018;

		flightProfiles[]	= {TopDown,LoalDistance,Cruise};
		class Direct{};
		class TopDown
		{
			ascendAngle				= 39;
			ascendHeight			= 360;
			minDistance				= 600;
			descendDistance			= 700;
		};
		class LoalDistance
		{
			lockSeekDistanceFromParent = 500;
		};
		class Cruise
		{
			preferredFlightAltitude = 500;
			lockDistanceToTarget = 1000;
		};

		class Components : Components
		{
			class SensorsManagerComponent
			{
				class Components
				{
					class RadarSensorComponent : SensorTemplateActiveRadar
					{
						class AirTarget {
							minRange = 500;
							maxRange = 2500;
						};
						class GroundTarget {
							minRange = 500;
							maxRange = 2500;
						};
						typeRecognitionDistance = -1; // distance how far the target type gets recognized
						angleRangeHorizontal = 90;     // sensor azimuth coverage in degrees
						angleRangeVertical = 90;
						groundNoiseDistanceCoef = -1;
						maxGroundNoiseDistance = -1;
						minSpeedThreshold = 0;        // target speed in km/h above which the target will start to become visible
						maxSpeedThreshold = -1;       // target speed above which the target becomes visible even if below groundNoiseDistanceCoef, linearly decreases to minSpeedThreshold
						maxFogSeeThrough = 0.8;
						minTrackableSpeed = 0;
						maxTrackableSpeed = 56;
						minTrackableATL = -1;
						maxTrackableATL = 1000;
					};
				};
			};
		};
		class Eventhandlers: Eventhandlers
		{
			class FZA_EH
			{
				fired = "_this call fza_fnc_weaponMissileSlowDown";
			};
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
	class fza_agm114l : fza_agm114base
	{
		fza_salType 				= "rf";
		model 						= "\fza_ah64_US\fza_agm114l";
		proxyShape					= "\fza_ah64_US\fza_agm114l";
		simulation 					= "shotMissile";

		//AI usage
		aiAmmoUsageFlags 			= "128+512";
		allowAgainstInfantry 		= 0;
		cost 						= 1000;
		
		hit 						= 600;
		indirectHit 				= 200;
		indirectHitRange 			= 4;

		airLock 					= 1;
		irlock 						= 1;	
		nvLock						= 0;

		activeSensorAlwaysOn        = 1;
		missileLockCone				= 90;
		missileKeepLockedCone		= 90;
		autoSeekTarget				= 1;
		lockSeekDistanceFromParent  = 300;
		lockSeekRadius 				= 2500;
		lockAcquire					= 1;

		flightProfiles[]	= {TopDown};
		class TopDown
		{
			ascendAngle				= 26.5;
			ascendHeight			= 850;
			minDistance				= 1000;
			descendDistance			= 1200;
			autoSeekTarget				= 1;
			lockSeekDistanceFromParent  = 300;
			lockSeekRadius 				= 2500;
			activeSensorAlwaysOn        = 1;
			lockType                    = 0;
			lockAcquire 				= 1;
		};
	};
	class fza_agm114k : fza_agm114base
	{
		model 						= "\fza_ah64_us\fza_agm114k"; 
		proxyShape					= "\fza_ah64_us\fza_agm114k";

		//AI usage
		aiAmmoUsageFlags 			= "64+128+512";
		allowAgainstInfantry 		= 1;
		cost 						= 1000;

		hit 						= 600;
		indirectHit 				= 200;
		indirectHitRange 			= 4;

		laserLock 					= 1;
		airLock 					= 0;
		irlock 						= 0;	
		nvLock						= 0;
		
		//MSL sensors definition
		missileLockMaxDistance 		= 8000;
		missileLockMinDistance 		= 300;
		missileLockMaxSpeed 		= 56;
		missileLockCone 			= 90;
		missileKeepLockedCone 		= 90;
		missileManualControlCone 	= 90;
		weaponLockSystem 			= "4";
		weaponType					= "missileAT";

		autoSeekTarget				= 1;
		lockSeekDistanceFromParent  = 300;
		lockSeekRadius 				= 500;
		
		class Components : Components
		{
			class SensorsManagerComponent
			{
				class Components
				{
					class LaserSensorComponent : SensorTemplateLaser
					{
						class AirTarget {
							minRange = 300;
							maxRange = 7000;
						};
						class GroundTarget {
							minRange = 300;
							maxRange = 7000;
						};
						angleRangeHorizontal = 30;
						angleRangeVertical = 50;
						typeRecognitionDistance = -1;
						maxGroundNoiseDistance = 0;   // distance from the ground in meters, hard cap, above which the target will be visible even if still below groundNoiseDistanceCoef
						maxFogSeeThrough = 0.3;
						allowsMarking= 1;
					};
				};
			};
		};
	};
	class fza_agm114a : fza_agm114k
	{		
		fza_salType 				= "sal1";
		model 						= "\fza_ah64_US\fza_agm114c";
		proxyShape					= "\fza_ah64_US\fza_agm114c";
		effectsmissile 				= "missile3";

		submunitionAmmo				= "Fza_Penetrator_8KG";

		hit							= 200;
		indirectHit 				= 80;
		indirectHitRange 			= 4;

		//AI usage
		cost 						= 500;
	};
	class fza_agm114c : fza_agm114k
	{
		fza_salType 				= "sal1";
		model 						= "\fza_ah64_US\fza_agm114c";
		proxyShape					= "\fza_ah64_US\fza_agm114c";

		submunitionAmmo				= "Fza_Penetrator_8KG";

		hit							= 260;
		indirectHit 				= 100;
		indirectHitRange 			= 4;

		//AI usage
		cost 						= 600;
	};
	class fza_agm114m : fza_agm114k
	{
		ace_frag_enabled 			= 1;
		ace_frag_skip 				= 0;
		ace_frag_force 				= 1;
		model 						= "\fza_ah64_US\fza_agm114k";
		proxyShape 					= "\fza_ah64_US\fza_agm114k";		
		hit 						= 100;
		indirectHit 				= 100;
		indirectHitRange 			= 40;

		submunitionAmmo				= "";

		//AI usage
		cost 						= 700;
	};
	class fza_agm114n : fza_agm114k
	{
		model 						= "\fza_ah64_US\fza_agm114k";
		proxyShape 					= "\fza_ah64_US\fza_agm114k";	
		hit 						= 200;
		indirecthit 				= 200;
		indirecthitrange 			= 12;
		explosionEffects 			= "BombExplosion";

		submunitionAmmo				= "";

		//AI usage
		cost 						= 700;
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////ROCKETS//////////////////////////////////
	///////////////////////////////////////////////////////////////////////	
	
	class fza_275_base: MissileBase 
	{

		ace_frag_enabled 			= 0;
		ace_frag_skip 				= 1;

		fza_wpnPageIconB 			= "";
		fza_wpnPageIconG 			= "";
		fza_shortCode 				= "";
		fza_weaponName              = "";
		soundfly[]  				= {"fza_ah64_us\audio\Flyby\SoundFly1.ogg", 1, 1, 400};	
		soundsetexplosion[]  		= {"fza_rocket_explosion_soundset", "fza_rocket_explosion_stereo_soundset", "fza_shell_explosion_reverb_soundset"};
		soundsetsoniccrack[] 		= {"fza_sc_rocket_flyby_soundset"};
		model 						= "\fza_ah64_us\weps\fza_hydra_m151_wep";
		effectsmissile 				= "fza_ah64_rocketsmoke";
		effectsMissileInit 			= "MissileDAR1";
		muzzleEffect 				= "BIS_fnc_effectFiredHeliRocket";
		hit							= 60;
		indirectHit					= 20;
		indirectHitRange			= 10;
		manualControl				= 0;
		maxControlRange 			= 0;
		maneuvrability 				= 0;
		airLock 					= 0;
		irLock						= 0;
		laserLock 					= 0;
		nvLock 						= 0;
		weaponLockSystem			= 0;
		cmimmunity 					= 1;

		//AI uasge
		aiAmmoUsageFlags 			= "128+512";
		allowAgainstInfantry 		= 1;
		cost 						= 75;
		aiRateOfFire = 0.3;
		aiRateOfFireDistance = 0;

		weaponType 					= "rocket";
		suppressionRadiusHit 		= 15;
		dangerRadiusHit 			= 40;
		initTime 					= 0.02;
		maxSpeed					= 840;
		thrustTime					= 2;
		thrust 						= 840;
		fuseDistance 				= 75;
		airFriction 				= 0.1;
		sideAirFriction 			= 0.004;
		timeToLive					= 15;
		whistleDist					= 24;
		class CamShakeExplode
		{
			power = 16;
			duration = 1.8;
			frequency = 20;
			distance = 191.554;
		};
		class CamShakeHit
		{
			power = 80;
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
			power = 2;
			duration = 0.1;
			frequency = 20;
			distance = 1;
		};
	};
	class fza_275_m151: fza_275_base
	{
		fza_shortCode 				= "6PD";
		fza_weaponName              = "fza_275_m151_wep";
		model 						= "\fza_ah64_us\weps\fza_hydra_m151_wep";
		proxyShape 					= "\fza_ah64_us\fza_hydra_m151";	
		explosionEffects 			= "GrenadeExplosion";
		hit							= 60;
		indirectHit					= 40;
		indirectHitRange			= 13;
	};
	class fza_275_m229: fza_275_base
	{
		fza_shortCode 				= "6RC";
		fza_weaponName              = "fza_275_m229_wep";
		model 						= "\fza_ah64_us\weps\fza_hydra_m229_wep";	
		proxyShape 					= "\fza_ah64_us\fza_hydra_m229";	
		explosionEffects 			= "GrenadeExplosion";
		hit							= 100;
		indirectHit					= 66;
		indirectHitRange			= 20;
		suppressionRadiusHit 		= 20;

	};
	class fza_275_m261: fza_275_base 
	{
		fza_shortCode 				= "6MP";
		fza_weaponName              = "fza_275_m261_wep";
		model 						= "\fza_ah64_us\weps\fza_hydra_m261_wep";	
		proxyShape 					= "\fza_ah64_us\fza_hydra_m261";	
		explosionEffects 			= "GrenadeExplosion";		
		maxSpeed 					= 600;
		hit 						= 30;
		indirectHit 				= 5;
		indirectHitRange 			= 5;

		submunitionDirectionType	= "SubmunitionModelDirection";
		submunitionAmmo 			= "fza_m73mpsm";
		submunitionConeType[] 		= {"randomcenter",9};
		submunitionConeAngle		= 2;
		triggerDistance				= 500;
		submunitionInitSpeed		= 500;
		deleteParentWhenTriggered	= 1;
		

		//AI uasge
		aiAmmoUsageFlags 			= "64+128";
		cost 						= 100;
	};
	class fza_275_m257: fza_275_base 
	{
		fza_shortCode 				= "6IL";
		fza_weaponName              = "fza_275_m257_wep";
		model 						= "\fza_ah64_us\weps\fza_hydra_m261_wep";
		proxyShape 					= "\fza_ah64_us\fza_hydra_m261";
		CraterEffects 				= "ATMissileCrater";
		explosionEffects 			= "";	
		hit 						= 30;
		indirectHit 				= 0;
		indirectHitRange 			= 0;

		submunitionAmmo 			= "fza_m257_flare";
		submunitionCount 			= 1;
		submunitionConeAngle		= 0;
		deleteParentWhenTriggered	= 1;

		triggerTime 				= 1.5;
		maxSpeed 					= 450;
		soundHit1[] 				= {"A3\sounds_f\dummysound",2.5118864,1,5};
		multiSoundHit[] 			= {"soundHit1",1};

		//AI uasge
		aiAmmoUsageFlags 			= "1";
		allowAgainstInfantry 		= 0;
	};
	class fza_275_m255: fza_275_base 
	{
		fza_shortCode 				= "6FL";
		fza_weaponName              = "fza_275_m255_wep";
		model 						= "\fza_ah64_us\weps\fza_hydra_m261_wep";	
		proxyShape 					= "\fza_ah64_us\fza_hydra_m261";
		CraterEffects 				= "ATMissileCrater";
		explosionEffects 			= "";	
		maxSpeed 					= 600;
		hit 						= 30;
		indirectHit					= 0;
		indirectHitRange 			= 0;

		submunitionDirectionType	="SubmunitionModelDirection";
		submunitionAmmo 			= "fza_flec_cluster";
		submunitionConeType[] 		= {"randomcenter",100};
		submunitionConeAngle 		= 12;
		triggerDistance				= 200;
		submunitionInitSpeed		= 500;
		deleteParentWhenTriggered	= 1;

		soundHit1[] 				= {"A3\sounds_f\dummysound",2.5118864,1,5};
		multiSoundHit[] 			= {"soundHit1",1};

		//AI uasge
		aiAmmoUsageFlags 			= "64+128";
		cost 						= 100;
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////SUBMUNITIONS/////////////////////////////
	///////////////////////////////////////////////////////////////////////	
	
	class fza_m73mpsm: GrenadeBase
	{
		ace_frag_enabled 			= 0;
		ace_frag_skip 				= 1;

		soundsetexplosion[] 		= {"fza_small_explosion_soundset", "fza_he_explosion_stereo_soundset", "fza_small_explosion_reverb_soundset"};
		simulation 					= "shotShell";
		model 						= "\A3\weapons_f\ammo\UGL_slug"; //M73 model needed.
		explosionEffects 			= "ExploAmmoExplosion";
		CraterEffects 				= "ExploAmmoCrater";
		muzzleEffect 				= "BIS_fnc_effectFiredHeliRocket";
		hit 						= 30;
		indirectHit 				= 15;
		indirectHitRange 			= 20;
		visibleFire 				= 1;
		audibleFire 				= 30;
		visibleFireTime 			= 3;
		dangerRadiusHit 			= 60;
		suppressionRadiusHit		= 30;
		explosive 					= 1;
		deflecting 					= 0;
		airFriction 				= -0.001;
		fuseDistance 				= 30;
		whistleDist 				= 16;
		typicalSpeed 				= 300;
		caliber 					= 3.7;
		soundHit1[] = {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_01",1.7782794,1,1600};
		soundHit2[] = {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_02",1.7782794,1,1600};
		soundHit3[] = {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_03",1.7782794,1,1600};
		soundHit4[] = {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_04",1.7782794,1,1600};
		multiSoundHit[] = {"soundHit1",0.25,"soundHit2",0.25,"soundHit3",0.25,"soundHit4",0.25};
	};	
	class fza_m257_flare: FlareCore
	{		
		timeToLive 					= 100;
		model 						= "\A3\Weapons_F\Ammo\UGL_Flare";
		lightColor[] 				= {1,0.8,0.7,0.5};
		smokeColor[] 				= {1,1,1,0.4};
		effectFlare 				= "CounterMeasureFlare";
		brightness 					= 0.1;
		size 						= 3;
		triggerTime					= 0.25;
		triggerSpeedCoef 			= 1;
		audibleFire 				= 20;
		intensity 					= 1000000;
	};
	class fza_flec_cluster: B_9x21_Ball
	{
		ace_frag_enabled 			= 0;
		ace_frag_skip 				= 1;
		
		hit 						= 6;
		indirectHit 				= 6;
		indirectHitRange 			= 4;
		deflecting 					= 0;
		fuseDistance 				= 50;
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