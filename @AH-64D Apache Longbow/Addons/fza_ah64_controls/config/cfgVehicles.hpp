class CfgVehicles
{
	class Helicopter;
	class Helicopter_Base_F : Helicopter {
		class Components;
		class EventHandlers;
		class Turrets;
	};
	#include "cfgVehicles\crew.hpp"
	class fza_ah64base : Helicopter_Base_F
	{
		class NewTurret;
		class CargoTurret;

		//Images
		picture = "\fza_ah64_us\icons\b2_silloheutte_128x64_ca.paa";
		mapSize = 10;
		icon = "\fza_ah64_us\icons\b2_topdown_128x128_ca.paa";
		displayName="AH-64D";

		A3TI_ThermalSelections[] = {"skin"};	
		
		#include "cfgVehicles\sfmplus.hpp"
		#include "cfgVehicles\sounds.hpp"
		#include "cfgVehicles\soundsExt.hpp"
		#include "cfgVehicles\userActions.hpp"
		#include "cfgVehicles\acre.hpp"
		#include "cfgVehicles\itcAir.hpp"
		#include "cfgVehicles\CfgAce.hpp"
		#include "\fza_ah64_misc\config\CfgAce.hpp"
		class itc_air 
		{
			class rover 
			{
				capable = 1;
				frequency_default = 5784;
			};
			targeting_user = "gunner";
			hmd = 1;
			tgp = 1;
			wso = 0;
			mfdApps[] = {"STAT","OPT"};
			systems[] = {"UFC","MFD","MFD_R","ROVER","ACMI"};
			mfdType = "classic";
		};

		//Sensors definition
    	receiveRemoteTargets    = 1;
    	reportRemoteTargets     = 1;
    	reportOwnPosition       = 1;
	
		//lesh tow compatabilty
		LESH_canBeTowed = 1;
		LESH_towFromFront = 0;
		LESH_AxisOffsetTarget[] = {0,-9.2,-2};
		LESH_WheelOffset[] = {0,2.5};

		//SFM Variables-------------/
		startDuration          = 15;
		liftForceCoef          = 1.25;
		bodyFrictionCoef       = 0.00;
		cyclicAsideForceCoef   = 0.00;
		cyclicForwardForceCoef = 0.00;
		backRotorForceCoef     = 0.00;
	    fuelCapacity           = 1423;
		fuelconsumptionrate    = 0.0;
		maxSpeed               = 298;
		altFullForce 		   = 1615;
		altNoForce 			   = 9000;
		//SFM Variables-------------/

		side=1;
		scope=0;
		simulation=helicopterRTD;
		attenuationEffectType = "HeliAttenuation";
		availableForSupportTypes[] = {"CAS_Heli", "Transport"};
		cargoGetInAction[] = {"GetInHigh","GetInHigh"};
		cargoGetOutAction[] = {"GetOutHigh","GetOutHigh"};
		destrtype = "DestructWreck";
		driveOnComponent[] = {"Wheels"};
		driverCanSee = 1+2+4+8;
		driverlefthandanimname = "p_collective";
		driverleftleganimname = "pedalL";	
		driverrighthandanimname = "p_cyclic";
		driverrightleganimname = "pedalR";
		enableCopilot = true;
		enableSweep = true;
		extCameraPosition[] = {0,0,-20};
		faction="fza_usaav";
		vehicleclass="fza_helicopters";
		formationX = 20;
		formationZ = 20;
		formationTime = 20;
		getInAction = "pilot_Heli_Light_02_Enter";
		getInRadius = 1.500000;
		getOutAction = "GetOutHigh";
		gunnerCanSee = 1+2+4+8;
		hideUnitInfo = 0;
		insideSoundCoef = 0.5;
		irTargetSize = 0.800000;
		mainBladeRadius = 7.3;
		mainbladecenter = "rotor_center";
		maxFordingDepth = 0.55;
		maxGForce = 9;
		obstructSoundsWhenIn = 0.316228;
		occludeSoundsWhenIn = 0.562341;
		preciseGetInOut = 1;
		radarTarget = 1;
		radarTargetSize = 0.700000;
		radartype = 4;
		transportMaxBackpacks = 2;
		transportMaxMagazines = 10;
		transportMaxWeapons = 3;
		type = VAir;
		unitinfotype = "fza_ah64_rscInfoMinimal";
		unitInfoTypeLite = "fza_ah64_rscInfoBasic";
		unitInfoTypeRTD = "fza_ah64_rscInfoRTD";

		usePreciseGetInAction = 1;
		emptySound[] = {"", 0, 1};
		soundGeneralCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_1", 1.000000, 1, 10};
		soundGeneralCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_2", 1.000000, 1, 10};
		soundGeneralCollision3[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_3", 1.000000, 1, 10};
		soundCrashes[] = {"soundGeneralCollision1", 0.330000, "soundGeneralCollision2", 0.330000, "soundGeneralCollision3", 0.330000};
		soundLandCrashes[] = {"soundGeneralCollision1", 0.330000, "soundGeneralCollision2", 0.330000, "soundGeneralCollision3", 0.330000};
		soundBuildingCrash[] = {"soundGeneralCollision1", 1, "soundGeneralCollision2", 1, "soundGeneralCollision3", 1};
		soundArmorCrash[] = {"soundGeneralCollision1", 1, "soundGeneralCollision2", 1, "soundGeneralCollision3", 1};
		soundWoodCrash[] = {"soundGeneralCollision1", 1, "soundGeneralCollision2", 1, "soundGeneralCollision3", 1};
		soundBushCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_1", 1.000000, 1, 10};
		soundBushCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_2", 1.000000, 1, 10};
		soundBushCollision3[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_3", 1.000000, 1, 10};
		soundBushCrash[] = {"soundBushCollision1", 0.330000, "soundBushCollision2", 0.330000, "soundBushCollision3", 0.330000};
		soundWaterCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_water_ext_1", 1.000000, 1, 10};
		soundWaterCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_water_ext_2", 1.000000, 1, 10};
		soundWaterCrashes[] = {"soundWaterCollision1", 0.500000, "soundWaterCollision2", 0.500000};
		soundDammage[] = {"\fza_ah64_US\audio\Crash.ogg", 3.162278, 1, 100};
		soundgetin[] = {"A3\Sounds_F\vehicles\air\noises\heli_get_in2",1,1,1};
		soundgetout[] = {"A3\Sounds_F\vehicles\air\noises\heli_get_out2",1,1,1};
		soundEngineOffExt[] = {"fza_ah64_us\audio\Ext_Off.ogg",1,0.6,300};
		soundEngineOffInt[] = {"emptySound", 0};
		soundEngineOnExt[] = {"fza_ah64_us\audio\Ext_Start.ogg",1,0.6,300};
		soundEngineOnInt[] = {"fza_ah64_us\audio\Int_Start.ogg",1,0.6};
		rotorDamageInt[] = {"\fza_ah64_US\audio\Int_Rotor_Damage.ogg", 1.000000, 1.000000};
		rotorDamageOut[] = {"\fza_ah64_US\audio\Ext_Rotor_Damage.ogg", 2.511886, 1.000000, 100};
		rotorDamage[] = {"rotorDamageInt", "rotorDamageOut"};
		tailDamageInt[] = {"\fza_ah64_US\audio\Tail_Damage.ogg", 1.000000, 1.000000};
		tailDamageOut[] = {"\fza_ah64_US\audio\Tail_Damage.ogg", 1.000000, 1.000000, 100};
		tailDamage[] = {"tailDamageInt", "tailDamageOut"};
		landingSoundInt0[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_int1_open", 1.000000, 1.000000};
		landingSoundInt1[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_int1_open", 1.000000, 1.000000};
		landingSoundInt[] = {"landingSoundInt0", 0.500000, "landingSoundInt1", 0.500000};
		landingSoundOut0[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_ext1", 1.778279, 1.000000, 10};
		landingSoundOut1[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_ext1", 1.778279, 1.000000, 10};
		landingSoundOut[] = {"landingSoundOut0", 0.500000, "landingSoundOut1", 0.500000};
		soundenviron[] = {"", 1, 1};
		author="Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Rosd6(Dryden) & Community";
		class SimpleObject
		{
			eden = 1;
			animate[] = {};
			hide[] = {"mr_blur","tr_blur","hdam_tr","hdam_rtr"};
			verticalOffset = 1.785;
			verticalOffsetWorld = 0.006;
			init = "[this, '', []] call bis_fnc_initVehicle";
		};
		class Components : Components
		{
			#include "cfgVehicles\pylons.hpp"
		};
		class EventHandlers {
			class fza_ah64 {
				init = "[_this # 0] spawn fza_fnc_eventInit; [_this # 0] spawn fza_aiCrew_fnc_init; [_this # 0] spawn fza_audio_fnc_audioInit";
				handleDamage = "_this call fza_fnc_damageSystem";
			};
		};
		class RenderTargets
		{
			class driverpnvs2
			{
				renderTarget = "fza_ah64_pnvscam2";
				class View01
				{
					pointPosition = "driverview";
					pointDirection = "driverview_dir";
					renderQuality = 2;
					renderVisionMode = 2; //TI HDU
					fov = 0.2;
				};
			};
		};
		class Exhausts
		{
				class Exhaust1
				{
					direction = "exhaust1_dir";
					effect = "ExhaustEffectHeli";
					position = "exhaust1";
				};
				class Exhaust2
				{
					direction = "exhaust2_dir";
					effect = "ExhaustEffectHeli";
					position = "exhaust2";
				};
		};
		class MFD {};

		class Turrets : Turrets {
			class MainTurret : NewTurret {
				class MFD;
			};
		};
		
		class Attributes
		{
			class fza_pylonLoadout
			{
				displayName = "Loadout Config";
				tooltip = "Loadout in JSON form to export";
				property = "fza_ah64_loadout";
				control = "Edit";
				expression = "[_this, _value] call fza_fnc_loadoutImportJson;";
				defaultValue = "''";
				unique = 0;
				validate = "none";
				condition = "1";
				typeName = "STRING";    
			};
			class fza_ah64_tailNumber {
				displayName  = "Custom Tail Number";
				tooltip 	 = "Enter a 7 character tail number. Leave a space to skip a position.";
				property 	 = "fza_attribute_tailNumber";
				control      = "Edit";
				expression   = "[_this, _value] call fza_fnc_setTailNumber;";
				defaultValue = "None";
				condition    = "objectVehicle";
			};
		};
	};
////////////////////////////////////////////////////////////////////////////////////////////////////
//AH-64D Radar        //////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
	class fza_ah64d_b2e: fza_ah64base
	{
		side			=1;
		scope			=2;
		author			="Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Rosd6(Dryden) & Community";
		displayName		="AH-64D Apache Longbow";
		editorPreview 	= "\fza_ah64_us\editorPreview\fza_ah64d_b2e.jpg";
		model			="\fza_ah64_US\fza_ah64d_b2.p3d";

		#include "hiddenSelections.hpp"
		#include "cfgVehicles\textureSources.hpp"
		#include "cfgVehicles\turrets.hpp"		
		#include "cfgVehicles\UVAnimations.hpp"
		#include "cfgVehicles\animationSources.hpp"
		#include "cfgVehicles\markerLights.hpp"
		#include "cfgVehicles\reflectors.hpp"
		#include "cfgVehicles\ace.hpp"
		#include "sensor_b2e.hpp"

		//map light condition not working
		ace_map_vehicleExteriorTurrets[] = {-1,0,1,2}; // due to ace limits, this is set in script


		ace_vehicle_damage_hullDetonationProb = 0.1;
		ace_vehicle_damage_turretDetonationProb = 0.2;
		ace_vehicle_damage_engineDetonationProb = 0.1;
		ace_vehicle_damage_hullFireProb = 0;
		ace_vehicle_damage_turretFireProb = 0;
		ace_vehicle_damage_engineFireProb = 0;
		ace_vehicle_damage_detonationDuringFireProb = 0.2;
		ace_vehicle_damage_canHaveFireRing = 1;

		ace_cargo_space 	= 0;
        ace_cargo_hasCargo 	= 0;
		
		allowTabLock = 0;
		accuracy=5;
		armor = 600;
		armorLights = 0.4;
		armorStructural = 4;
		audible=4;
		attendant = 0;
		camshakecoef = 0.3;
		cargoAction[]={"fza_ah64_leftcargo","fza_ah64_rightcargo"};
		commanderUsesPilotView = false;
		crewCrashProtection = 0.25;
		crewVulnerable = 0;
		//damageResistance=0.0055499999;
		driverAction = "fza_ah64_pilot";
		crew="fza_ah64_pilot";
		driverOpticsColor[] = {1,1,1,1};
		driveropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
		ejectDeadCargo=true;
		ejectdeadgunner = false;
		explosionShielding = 8;
		gForceShakeAttenuation = 0.5;
		gunnerUsesPilotView = false;
		hasGunner=1;
		impactEffectSpeedLimit = 8;
		impactEffectsSea = "ImpactEffectsAir";
		incomingMissileDetectionSystem = 16;
		countermeasureActivationRadius = 6000;
		irScanGround = 1;
		irScanRangeMax = 10000;
		irScanRangeMin = 700;
		irScanToEyeFactor = 2;
		laserScanner=1;
		laserTarget=0;
		magazines[] = {"60Rnd_CMFlareMagazine","fza_IR_JAMMING","fza_RF_JAMMING"};
		lockdetectionsystem = "8+4";
		gunAimDown = 0;
		selectionHRotorStill = "mr_blades";
		selectionHRotorMove = "mr_blur";
		selectionVRotorStill = "tr_blades";
		selectionVRotorMove = "tr_blur";
		mainRotorSpeed = 1;
		maxBackRotorDive = 0;
		maxMainRotorDive = 0;
		memoryPointLMissile = "l strela";
		memoryPointLRocket = "l raketa";
		memoryPointRMissile = "p strela";
		memoryPointRRocket = "p raketa";
		memoryPointsGetInCargo = "pos cargo";
		memoryPointsGetInCargoDir = "pos cargo dir";
		memoryPointsGetInDriver = "pos driver";
		memoryPointsGetInDriverDir = "pos driver dir";
		memorypointcm[] = {"flare_1_beg","Flare_2_beg"};
		memorypointcmdir[] = {"flare_1_end","flare_2_end"};
		memorypointdriveroptics[] = {"driverview", "pilot"};
		minBackRotorDive = 0;
		minMainRotorDive = 0;
		nameSound="veh_Helicopter";
		neutralBackRotorDive = 0;
		neutralMainRotorDive = 0;
		nightVision=1;
		nvScanner = 0;
		nvTarget = 0;
		threat[] = {1,1,0.5};
		transportSoldier=2;
		visualTarget = 1;
		visualTargetsize = 1.0;
		weapons[] = {"fza_CMFlareLauncher","fza_AseIRjammer","fza_AseRFjammer"};
		envelope[]={
			0.0,0.6,1.6,3.2,3.8,5.0,5.25,5.4,5.6,5.7,5.8,5.9,6.0,4.0,1.5 // lift
		};
		class Library
		{
			libTextDesc = "The AH-64D Block II is an anti-tank attack helicopter. Defining characteristics are: Four bladed main rotor, X-shaped tail rotor, a boxy cockpit with two distinct bays on the sides, two stub wings with two pylons each, two main wheels and a tail wheel, a chin mounted turret, and a long rounded tailboom with a stabilizator at the rear. Production began in 1982 and the first unit was deployed in 1986. By 1993, the US Army had over 800 Apaches in service. It was firsted used in combat during Operation Just Cause, the invasion of Panama in 1989 where some drawbacks were encountered (primarily with the avionics). During Desert Storm in 1991, Apaches performed the first strike of that conflict by destroying Iraqi early warning radars. More drawbacks were encountered in Desert Storm, some of which were: limited navigation capabilities, high maintenance, and intolerance to desert conditions. AH-64As went through some modernization upgrades, but the AH-64A has been phased out of active US Army service in favor of the AH-64D, and now only National Guard and Reserve units operate the A model. The AH-64D has two General Electric T700-GE-701C engines producing a total of 3392shp, giving the aircraft a maximum clean speed of about 227mph (365kmh). This speed comes down to about 300kmh loaded. Combat endurance is about 2 hours with standard loads. It is armed with a M230 30mm Chain Gun cannon by default, with provisions for AGM-114 HELLFIRE missiles and 2.75in HYDRA-70 rockets. Experimentally it has used the Stinger missile, Sidearm missile, Sidewinder missile, and Starstreak missile. The US Army has not used any of these weapons operationally with the Apache.";
		};

		class HeadLimits
		{
			initanglex = 0;
			initangley = 0;
			maxanglex = 40;
			maxangley = 90;
			maxanglez = 45;
			minanglex = -40;
			minangley = -90;
			minanglez = -45;
			rotzradius = 0.2;
		};
		class ViewPilot
		{
			initFov=0.700000;
			minFov=0.400000;
			maxFov=0.850000;
			initAngleX=0;
			minAngleX=-75;
			maxAngleX=50;
			initAngleY=0;
			minAngleY=-150;
			maxAngleY=150;
			maxmovex = 0.15;
			maxmovey = 0.1;
			maxmovez = 0.1;
			minmovex = -0.15;
			minmovey = -0.1;
			minmovez = -0.1;
		};

		//PNVS TURRET OPTICS BACK UP
		class ViewOptics
		{
			initFov=0.7;
			minFov=0.7;
			maxFov=0.7;			
			initAngleX=0;
			minAngleX=-90;
			maxAngleX=90;
			initAngleY=0;
			minAngleY=-45;
			maxAngleY=20;
			maxXRotSpeed = 4;	// yawing speed
			maxYRotSpeed = 4;	// pitching speed
			thermalmode[] = {2};
			visionmode[] = {"Ti"}; //PNVS
		};
<<<<<<< HEAD
=======

		class UVAnimations
		{
			class plt_mmap_01_tnsx
			{
				type			= translation;
				source			= plt_mmap_tx;
				section			= plt_pr_mpd_back;
				minValue		= -1;
				maxValue		= 2;
				offset0[]		= {-1,0};
				offset1[]		= {2,0};
			};
			class plt_mmap_02_tnsy
			{
				type			= translation;
				source			= plt_mmap_ty;
				section			= plt_pr_mpd_back;
				minValue		= -1;
				maxValue		= 2;
				offset0[]		= {0,-1};
				offset1[]		= {0,2};
			};
			class plt_mmap_03_rot
			{
				type			= rotate;
				source			= plt_mmap_r;
				section			= plt_pr_mpd_back;
				minValue		= 0;
				maxValue		= 360;
				center[]		= { 0.5, 0.75 };
				angle0			= 0;
				angle1			= rad 360;
			};
			class plt_mmap_04_scale
			{
				type = scale;
				source = plt_mmap_sc;
				section	= plt_pr_mpd_back;
				minValue = 0.01;
				maxValue = 100;
				center[] = { 0.50, 0.75 };
				scale0[] = {0.01,0.01};
				scale1[] = {100,100};
			};
			class cpg_mmap_01_tnsx : plt_mmap_01_tnsx
			{
				section	= cpg_pr_mpd_back;
				source = cpg_mmap_tx;
			};
			class cpg_mmap_02_tnsy : plt_mmap_02_tnsy
			{
				section	= cpg_pr_mpd_back;
				source = cpg_mmap_ty;
			};
			class cpg_mmap_03_rot : plt_mmap_03_rot
			{
				section	= cpg_pr_mpd_back;
				source = cpg_mmap_r;
			};
			class cpg_mmap_04_scale : plt_mmap_04_scale
			{
				section	= cpg_pr_mpd_back;
				source = cpg_mmap_sc;
			};
		};

		class AnimationSources
		{
			#define ANIMS_MMAP(seat) \
			class seat##_mmap_tx \
			{ \
				source = "user"; \
				animPeriod = 0.001; \
				initPhase=0; \
			}; \
			class seat##_mmap_ty \
			{ \
				source = "user"; \
				animPeriod = 0.001; \
				initPhase=0; \
			}; \
			class seat##_mmap_r \
			{ \
				source = "user"; \
				animPeriod = 0.001; \
				initPhase=0; \
			}; \
			class seat##_mmap_sc \
			{ \
				source = "user"; \
				animPeriod = 0.001; \
				initPhase=1; \
			}; 
		ANIMS_MMAP(plt)
		ANIMS_MMAP(cpg)
		////////RADAR///////
		class fcr_enable
		{
			displayName = "Install FCR";
			author = "Apache mod development team";
			onPhaseChanged = "_this # 0 enableVehicleSensor [""ActiveRadarSensorComponent"",_this # 1 == 1];";
			source = "user";
			initPhase = 1;
			animPeriod = 0.001;
		};
		class msn_equip_american
		{
			displayName = "Install American Mission Equipment";
			author = "Apache mod development team";
			onPhaseChanged = "";
			source = "user";
			initPhase = 1;
			animPeriod = 0.001;
		};
		class msn_equip_british
		{
			displayName = "Install British Mission Equipment";
			author = "Apache mod development team";
			onPhaseChanged = "";
			source = "user";
			initPhase = 0;
			animPeriod = 0.001;
		};
		class mast
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=1;
		};
		class magazine_set_1200
		{
			displayName = "Swap IAFS for 1200rnd magazine";
			author = "Apache mod development team";
			onPhaseChanged = "_this remoteExec [""fza_fnc_weaponSwapM230Mag"",_this # 0];";
			source = "user";
			initPhase = 0;
			animPeriod = 0.001;
		};
		class hstab
		{
			source = "user";
			animPeriod = 0.01;
			initPhase  = 1;
		};
		class pnvs
		{
			source = "user";
			animPeriod = 0.01;
			initPhase=0;
		};
		class pnvs_vert
		{
			source = "user";
			animPeriod = 0.01;
			initPhase=0;
		};
		class tads_stow
		{
			source = "user";
			animPeriod = 1;
			initPhase  = 1;
			onPhaseChanged = "[_this # 0, ""fza_ah64_tadsStow"", ""tads_stow""] call fza_fnc_animReset";
		};
		class m230_recoil
		{
			source = "reload";
			weapon = "fza_m230";
		};
		class mainTurret
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class maingun
		{
			source = "user";
			animPeriod = 0.1;
			initPhase  = 0.298;
		};
		class pylon1
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class pylon2
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class pylon3
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class pylon4
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swashplate_up_tns
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swashplate_up_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swashplate_up_bank
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swashplate_dn_tns
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swashplate_dn_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swashplate_dn_bank
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class mr_act_tns
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swup_arm1
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swup_arm1_t
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swup_arm2
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swup_arm3
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swup_arm3_t
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class swup_arm4
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class trsw
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class tr_blade1_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class tr_blade2_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class tr_blade3_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class tr_blade4_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class blade1_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class blade1_flap
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class blade2_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class blade2_flap
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class blade3_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class blade3_flap
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class blade4_pitch
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		class blade4_flap
		{
			source = "user";
			animPeriod = 0.1;
			initPhase=0;
		};
		//////weapons///////////
		class pod_m260_1
		{
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
		};
		class pod_m260_2
		{
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
		};
		class pod_m260_3
		{
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
		};
		class pod_m260_4
		{
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
		};
		class rail_m299_1
		{
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
		};
		class rail_m299_2
		{
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
		};
		class rail_m299_3
		{
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
		};
		class rail_m299_4
		{
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
		};
			////////////////////////////////
			///////////COCKPIT//////////////
			////////////////////////////////
			class plt_eng1_start
            {
				source = "user";
				animPeriod = 0.15;
				initPhase=0;
				sound = "eng1_start_sound";
            };
			class plt_eng2_start
            {
				source = "user";
				animPeriod = 0.15;
				initPhase=0;
				sound = "eng2_start_sound";
            };
			class plt_rtrbrake
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=1;
				onPhaseChanged = "[_this # 0, ""fza_ah64_rtrbrake"", ""plt_rtrbrake""] call fza_fnc_animReset";
            };
			class plt_anticollision
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
				onPhaseChanged = "[_this # 0, ""fza_ah64_anticollision"", ""plt_anticollision""] call fza_fnc_animReset";
            };
			class plt_firesw
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0.5;
            };
			class cpg_firesw
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0.5;
            };
			class plt_nvsmode
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class cpg_nvsmode
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class plt_batt
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
				onPhaseChanged = "[_this # 0, ""fza_ah64_battery"", ""plt_batt""] call fza_fnc_animReset";
            };
			class plt_apu
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
				onPhaseChanged = "[_this # 0, ""fza_ah64_apu"", ""plt_apu""] call fza_fnc_animReset";
            };
			class cpg_ihadss_brt
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class plt_eng1_throttle
            {
				source = "user";
				animPeriod = 1;
				initPhase=0;
				onPhaseChanged = "[_this # 0, ""fza_ah64_powerLever1"", ""plt_eng1_throttle""] call fza_fnc_animReset";
            };
			class plt_eng2_throttle
            {
				source = "user";
				animPeriod = 1;
				initPhase=0;
				onPhaseChanged = "[_this # 0, ""fza_ah64_powerLever2"", ""plt_eng2_throttle""] call fza_fnc_animReset";
            };
						//////////////MPD OBJECTS//////////////////
#define SECTION(val) \
			class val##_x {\
				source= user;\
				animPeriod = 0.001;\
			};\
			class val##_y {\
				source=user;\
				animPeriod = 0.001;\
			};
			LIST_OF_BONES(pl)
			LIST_OF_BONES(pr)
			LIST_OF_BONES(cl)
			LIST_OF_BONES(cr)
		//////////////DOORS//////////////////
		class pdoor
		{
			displayName = "Open Pilot door";
			author = "Apache mod development team";
			source = "user";
			animPeriod = 1;
			initPhase=0;
		};
		class gdoor
		{
			displayName = "Open Gunner door";
			author = "Apache mod development team";
			source = "user";
			animPeriod = 1;
			initPhase=0;
		};
		///////////////ADS//////////////////
		class l_ads_p
        {
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
        };
		class l_ads_b : l_ads_p
        {
			source = "user";
        };
		class l_ads_y : l_ads_p
        {
			source = "user";
        };
		class r_ads_p
        {
			source = "user";
			animPeriod = 0.001;
			initPhase=0;
        };
		class r_ads_b : r_ads_p
        {
			source = "user";
        };
		class r_ads_y : r_ads_p
        {
			source = "user";
        };
	};
	class MarkerLights
	{
		class PositionWhite
		{
			name = "tail_light";
			ambient[] = {0.1,0.1,0.1};
			color[] = {1,1,1};
			drawLightSize = 0.50;
			drawLightCenterSize = 0.16;
			activeLight = 0;
			blinking = 0;
			dayLight = 0;
			drawLight = 1;
			intensity = 75;
			useFlare = 1;
			class Attenuation
			{
				constant = 0;
				hardLimitEnd = 1;
				hardLimitStart = 0.75;
				linear = 25;
				quadratic = 50;
				start = 0;
			};
		};
		class PositionGreen: PositionWhite
		{
			name = "zeleny pozicni";
			ambient[] = {0,0.08,0};
			color[] = {0,0.8,0};
			drawLightSize = 0.50;
			drawLightCenterSize = 0.16;
		};
		class PositionRed: PositionWhite
		{
			name = "cerveny pozicni";
			ambient[] = {0.08,0,0};
			color[] = {0.8,0,0};
			drawLightSize = 0.50;
			drawLightCenterSize = 0.16;
		};
		class RedStrobe_1
		{
			name="cerveny pozicni blik_1";
			color[]={0.89999998,0.15000001,0.1};
			ambient[]={0.090000004,0.015,0.0099999998};
			intensity=2500;
			drawLightSize = 0.50;
			drawLightCenterSize = 0.16;
			blinking = 1;
			blinkingPattern[]={0.03,2.10};
			blinkingPatternGuarantee = 1;
			daylight = 1;
		};
		class RedStrobe_2
		{
			name="cerveny pozicni blik_2";
			color[]={0.89999998,0.15000001,0.1};
			ambient[]={0.090000004,0.015,0.0099999998};
			intensity=2500;
			drawLightSize = 0.50;
			drawLightCenterSize = 0.16;
			blinking = 1;
			blinkingPattern[]={0.03,2};
			blinkingPatternGuarantee = 1;
			daylight = 1;
		};
	};
	class Reflectors
	{
		class Landing_Light
		{
			position = "landing_light";
			direction = "landing_light_dir";
			hitpoint = "landing_light";
			selection = "Light";
			color[] = {7000,7500,10000};
			ambient[] = {70,75,100};
			intensity = 100;
			size = 1;
			innerAngle = 15;
			outerAngle = 90;
			coneFadeCoef = 10;
			useFlare = 1;
			flareSize = 15;
			flareMaxDistance = 500;
			daylight = 1;		//added
			class Attenuation
			{
				start = 0;
				constant = 0;
				linear = 1;
				quadratic = 1;
				hardLimitStart = 100;
				hardLimitEnd = 200;
			};
		};
	};
	#include "sensor_b2e.hpp"
>>>>>>> 84bad512... Correction to some logic
	};
////////////////////////////////////////////////////////////////////////////////////////////////////
//AH-64D No Radar     //////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
	class fza_ah64d_b2e_nr: fza_ah64d_b2e
	{
		side		  = 1;
		scope		  = 1;
		author		  = "Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Rosd6(Dryden) & Community";
		displayName   = "AH-64D Apache Longbow (no radar)";
		editorPreview = "\fza_ah64_us\editorPreview\fza_ah64d_b2e_nr.jpg";
		
		class AnimationSources: AnimationSources {
			class fcr_enable: fcr_enable
			{
				initPhase = 0;
			};
		};

		class Components: Components
		{
			class TransportPylonsComponent : TransportPylonsComponent {
				class pylons: pylons {
					class pylons1: pylons1 {};
					class pylons2: pylons2 {};
					class pylons3: pylons3 {};
					class pylons4: pylons4 {};
					class pylons5: pylons5 {};
					class pylons6: pylons6 {};
					class pylons7: pylons7 {
						attachment = "fza_agm114k_ll";
					};
					class pylons8: pylons8 {
						attachment = "fza_agm114k_lr";
					};
					class pylons9: pylons9 {};
					class pylons10: pylons10 {};
					class pylons11: pylons11 {
						attachment = "fza_agm114k_ll";
					};
					class pylons12: pylons12 {
						attachment = "fza_agm114k_lr";
					};
					class pylons13: pylons13 {};
					class pylons14: pylons14 {};
					class pylons15: pylons15 {};
					class pylons16: pylons16 {};
				};
			};
		};
	};
////////////////////////////////////////////////////////////////////////////////////////////////////
//AH-64D HeliSim      //////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
	class fza_ah64d_b2e_heliSim: fza_ah64d_b2e
	{
		side=1;
		scope=2;
		author="Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Rosd6(Dryden) & Community";
		displayName="AH-64D Apache Longbow (HeliSim)";
		editorPreview = "\fza_ah64_us\editorPreview\fza_ah64d_b2e.jpg";

		//SFM Variables-------------/
		liftForceCoef          = 0.00;
		//SFM Variables-------------/
	};
};