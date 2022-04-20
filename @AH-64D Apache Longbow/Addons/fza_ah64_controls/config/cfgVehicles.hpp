class CfgVehicles
{
	class Helicopter;
	class Helicopter_Base_F : Helicopter {
		class Components;
		class EventHandlers;
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
		
		A3TI_ThermalSelections[] = {"skin"};	
		
		#include "cfgVehicles\sfmplus.hpp"
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
		startDuration          = 45;
		liftForceCoef          = 1.25;
		bodyFrictionCoef       = 1.0;
		cyclicAsideForceCoef   = 0.4;
		cyclicForwardForceCoef = 0.5;
		backRotorForceCoef     = 0.7;
	    fuelCapacity           = 1423;
		fuelconsumptionrate    = 0.0;
		maxSpeed               = 298;
		altFullForce 		   = 1615;
		altNoForce 			   = 9000;
		//SFM Variables-------------/

		side=1;
		scope=0;
		displayName="AH-64D";
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
				init = "[_this # 0] spawn fza_fnc_eventInit; [_this # 0] spawn fza_aiCrew_fnc_init";
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
						renderQuality = 0;
						renderVisionMode = 0; //DTV HDU
						fov = 0.2;
					};
				};
				class driverpnvs3
				{
					renderTarget = "fza_ah64_pnvscam3";
					class View01
					{
						pointPosition = "driverview";
						pointDirection = "driverview_dir";
						renderQuality = 0;
						renderVisionMode = 1; //NVG HDU
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
		class Sounds
		{
				class EngineExt
				{
					sound[] = {"\fza_ah64_US\audio\Engine", 1, 1.000000, 1200};
					frequency = "rotorSpeed";
					volume = "camPos*((rotorSpeed-0.72)*4)";
				};
				class RotorExt
				{
					sound[] = {"\fza_ah64_US\audio\Ext_Rotor.ogg", 1, 1.000000, 1200};
					frequency = "rotorSpeed * (1 - rotorThrust/5)";
					volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				class EngineClose
				{
					sound[] = {"\fza_ah64_US\audio\Engine_Close.ogg", 1, 1.000000, 1200};
					frequency = "rotorSpeed";
					volume = "camPos*((rotorSpeed-0.72)*4)";
				};
				class RotorClose
				{
					sound[] = {"\fza_ah64_US\audio\Rotor_Close.ogg", 1, 1.000000, 1200};
					frequency = "rotorSpeed * (1 - rotorThrust/5)";
					volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				class RotorSwist
				{
					sound[] = {"A3\Sounds_F\vehicles\air\Heli_Attack_01\swist", 0.500000, 1, 300};
					frequency = 1;
					volume = "camPos * (rotorThrust factor [0.7, 0.9])";
				};
				class TailRotor
				{
					cone[] = {3, 1.57, 3, 1.57};
					frequency = "rotorSpeed";
					sound[] = {"\fza_ah64_US\audio\Ext_Tail_Rotor.ogg", 3, 1, 1200};
					volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				class Distance
				{
					sound[]  = {"\fza_ah64_US\audio\Engine_Far.ogg", 4, 1, 3500};
					frequency = "rotorSpeed";
					volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
				};
				class FarDistance
				{
					sound[]  = {"\fza_ah64_US\audio\Rotor_Far.ogg", 4, 1, 3500};
					frequency = "rotorSpeed";
					volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
				};
				class EngineInt
				{
					sound[] = {"\fza_ah64_us\audio\Int_Engine.ogg", 1, 1.000000};
					frequency = "rotorSpeed";
					volume = "(1-camPos)*((rotorSpeed-0.75)*4)";
				};
				class RotorInt
				{
					sound[] = {"\fza_ah64_us\audio\Int_Rotor.ogg", 1, 1};
					frequency = "rotorSpeed * (1 - rotorThrust/5)";
					volume = "(1-camPos)*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				class TransmissionDamageExt_phase1
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_1", 1.000000, 1.000000, 150};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "camPos * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class TransmissionDamageExt_phase2
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_2", 1.000000, 1.000000, 150};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "camPos * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class TransmissionDamageInt_phase1
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_1", 1.000000, 1.000000, 150};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "(1 - camPos) * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class TransmissionDamageInt_phase2
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_2", 1.000000, 1.000000, 150};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "(1 - camPos) * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class damageAlarmInt
				{
					sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm.ogg", 1, 1.000000};
					frequency = 1;
					volume = "engineOn * (1 - camPos) * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0.0, 0.001])";
				};
				class rotorLowAlarmInt
				{
					sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm_low.ogg", 1, 1.000000};
					frequency = 1;
					volume = "engineOn * (1 - camPos) * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
				};
				class scrubLandInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\wheelsInt", 1.000000, 1.000000, 100};
					frequency = 1;
					volume = "2 * (1-camPos) * (scrubLand factor[0.02, 0.05]) * (1 - (lateralMovement factor [0.7,1]))";
				};
				class scrubLandExt
				{
					sound[] = {"A3\Sounds_F\dummysound", 1.000000, 1.000000, 100};
					frequency = 1;
					volume = "camPos * (scrubLand factor[0.02, 0.05]) * (1 - (lateralMovement factor [0.7,1]))";
				};
				class scrubBuildingInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\wheelsInt", 1.000000, 1.000000, 100};
					frequency = 1;
					volume = "(1-camPos) * (scrubBuilding factor[0.02, 0.05]) * (1 - (lateralMovement factor [0.7,1]))";
				};
				class scrubBuildingExt
				{
					sound[] = {"A3\Sounds_F\dummysound", 1.000000, 1.000000, 100};
					frequency = 1;
					volume = "camPos * (scrubBuilding factor[0.02, 0.05])";
				};
				class scrubTreeInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubTreeInt", 1.000000, 1.000000, 100};
					frequency = 1;
					volume = "(1 - camPos) * ((scrubTree) factor [0, 0.01])";
				};
				class scrubTreeExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubTreeExt", 1.000000, 1.000000, 100};
					frequency = 1;
					volume = "camPos * ((scrubTree) factor [0, 0.01])";
				};
				class RainExt
				{
					sound[] = {"\fza_ah64_us\audio\Ext_Rain.ogg", 1.000000, 1.000000, 100};
					frequency = 1;
					volume = "camPos * (rain - rotorSpeed/2) * 2";
				};
				class RainInt
				{
					sound[] = {"\fza_ah64_us\audio\Int_Rain.ogg", 1.000000, 1.000000, 100};
					frequency = 1;
					volume = "(1-camPos)*(rain - rotorSpeed/2)*2";
				};
				class SlingLoadDownExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownEXT", 1.258925, 1.000000, 500};
					frequency = 1;
					volume = "camPos*(slingLoadActive factor [0,-1])";
				};
				class SlingLoadUpExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineupEXT", 1.258925, 1.000000, 500};
					frequency = 1;
					volume = "camPos*(slingLoadActive factor [0,1])";
				};
				class SlingLoadDownInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownINT", 1.000000, 1.000000, 500};
					frequency = 1;
					volume = "(1-camPos)*(slingLoadActive factor [0,-1])";
				};
				class SlingLoadUpInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineUpINT", 1.000000, 1.000000, 500};
					frequency = 1;
					volume = "(1-camPos)*(slingLoadActive factor [0,1])";
				};
				class WindInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\wind_closed", 0.398107, 1.000000, 50};
					frequency = 1;
					volume = "(1-camPos)*(speed factor[5, 50])*(speed factor[5, 50])";
				};
				class GStress
				{
					sound[] = {"A3\Sounds_F\vehicles\noises\vehicle_stress2b", 0.354813, 1.000000, 50};
					frequency = 1;
					volume = "engineOn * (1-camPos) * ((gmeterZ factor[1.5, 2.5]) + (gmeterZ factor[0.5, -0.5]))";
				};
		};
		class SoundsExt
		{
			class Sounds
			{
				class EngineExt
				{
					sound[] = {"\fza_ah64_US\audio\Engine", 1, 1.000000, 1200};
					frequency = "rotorSpeed";
					volume = "camPos*((rotorSpeed-0.72)*4)";
				};
				class RotorExt
				{
					sound[] = {"\fza_ah64_US\audio\Ext_Rotor.ogg", 1, 1.000000, 1200};
					frequency = "rotorSpeed * (1 - rotorThrust/5)";
					volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				class EngineClose
				{
					sound[] = {"\fza_ah64_US\audio\Engine_Close.ogg", 1, 1.000000, 1200};
					frequency = "rotorSpeed";
					volume = "camPos*((rotorSpeed-0.72)*4)";
				};
				class RotorClose
				{
					sound[] = {"\fza_ah64_US\audio\Rotor_Close.ogg", 1, 1.000000, 1200};
					frequency = "rotorSpeed * (1 - rotorThrust/5)";
					volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				class RotorSwist
				{
					sound[] = {"A3\Sounds_F\vehicles\air\Heli_Attack_01\swist", 0.500000, 1, 300};
					frequency = 1;
					volume = "camPos * (rotorThrust factor [0.7, 0.9])";
				};
				class TailRotor
				{
					cone[] = {3, 1.57, 3, 1.57};
					frequency = "rotorSpeed";
					sound[] = {"\fza_ah64_US\audio\Ext_Tail_Rotor.ogg", 3, 1, 1200};
					volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				class Distance
				{
					sound[]  = {"\fza_ah64_US\audio\Engine_Far.ogg", 4, 1, 3500};
					frequency = "rotorSpeed";
					volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
				};
				class FarDistance
				{
					sound[]  = {"\fza_ah64_US\audio\Rotor_Far.ogg", 4, 1, 3500};
					frequency = "rotorSpeed";
					volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
				};
				class EngineInt
				{
					sound[] = {"\fza_ah64_us\audio\Int_Engine.ogg", 1, 1.000000};
					frequency = "rotorSpeed";
					volume = "(1-camPos)*((rotorSpeed-0.75)*4)";
				};
				class RotorInt
				{
					sound[] = {"\fza_ah64_us\audio\Int_Rotor.ogg", 1, 1};
					frequency = "rotorSpeed * (1 - rotorThrust/5)";
					volume = "(1-camPos)*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				class TransmissionDamageExt_phase1
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_1", 1.000000, 1.000000, 200};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "camPos * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class TransmissionDamageExt_phase2
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_2", 1.000000, 1.000000, 200};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "camPos * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class TransmissionDamageInt_phase1
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_1", 1.000000, 1.000000, 200};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "(1 - camPos) * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class TransmissionDamageInt_phase2
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_2", 1.000000, 1.000000, 200};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "(1 - camPos) * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class damageAlarmInt
				{
					sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm.ogg", 1, 1.000000};
					frequency = 1;
					volume = "engineOn * (1 - camPos) * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0.0, 0.001])";
				};
			};
		};
		class Damage
		{
			tex[] = {
				"fza_ah64_us\tex\ex\rtrs_co.paa",
				"fza_ah64_us\tex\dam\mdam_Rtrs_co.paa",
				"fza_ah64_us\tex\dam\hdam_Rtrs_co.paa"
			};
			mat[] = {
				"fza_ah64_us\mat\body.rvmat",
				"fza_ah64_us\mat\body_damage.rvmat", //"fza_ah64_us\mat\body_damage.rvmat",
				"fza_ah64_us\mat\body_damage.rvmat"
			};
		};
		class HitPoints
		{
			class Hithull
			{
				armor = 999;
				minimalHit=0.05;
				material = -1;
				name = "fuselage";
				passthrough = 1;
				visual = "skin_fuse";
				explosionShielding = 2.5;
				convexComponent = "fuselage";
				radius = 0.3;
				depends = "Total";
			};/*
			class HitAvionics
			{	// Causes no affect in aircraft control, visual or otherwise
				armor = 2.2;
				material = 51;
				name = "cockpit";
				passthrough = 0.2;
				visual = "skin_nose";
				explosionShielding = 1;
				convexComponent = "cockpit";
				minimalHit = 0.1;
				radius = 0.4;
			};*/
			class HitEngine1 
			{
				armor = 0.9;
				material = 51;
				name = "leng";
				passthrough = 1;
				visual = "skin_leng";
				explosionShielding = 3;
				convexComponent = "leng";
				minimalHit = 0.3;
				radius = 0.4;
			};
			class HitEngine2: HitEngine1
			{
				name = "reng";
				visual = "skin_reng";
				convexComponent = "reng";
			};/*
			class HitEngine
			{	// Causes no affect in aircraft control, visual or otherwise
				armor = 1.2;
				material = 51;
				name = "trans";
				passthrough = 0;
				visual = "trans";
				explosionShielding = 3;
				convexComponent = "trans";
				minimalHit = 0.5;
				radius = 0.4;
			};*/
			class HitFuel
			{
				armor = 0.8;
				material = 51;
				name = "lfuel";
				passthrough = 0;
				explosionShielding=2;
			};
			class IrJammer
			{
				armor = 0.9;
				material = 51;
				name = "IR Jammer";
				passthrough = 0.1;
				visual = "skin_lefab";
				minimalHit = 0.3;
			};
			class RfJammer: IrJammer
			{
				name = "RF Jammer";
				visual = "skin_refab";
			};
			class HitVRotor
			{
				armor = 3;
				material = 51;
				name = "mala vrtule";
				passthrough = 0.1;
				visual = "tr_blades";
				explosionShielding = 6;
				convexComponent = "mala vrtule";
				minimalHit = 0.05;
				radius = 0.06;
			};
			class HitHRotor
			{
				armor = 4;
				material = 51;
				name = "velka vrtule";
				passthrough = 0.1;
				visual = "mr_blades";
				explosionShielding = 2.5;
				convexComponent = "velka vrtule";
				minimalHit = 0.09;
				radius = 0.4;
			};
			class HitHStabilizerL1
			{	//causes aircraft to shake slightly when damaged
				armor = 1;
				material = 51;
				name = "lwing";
				passthrough = 0.1;
				visual = "skin_lwing";
				minimalHit = 0.3;
			};
			class HitHStabilizerR1: HitHStabilizerL1
			{   //causes aircraft to shake slightly when damaged
				name = "rwing";
				visual = "skin_rwing";
			};
			class HitVStabilizer1
			{   //causes aircraft to shake slightly when damaged
				armor = 0.5;
				material = 51;
				name = "vtail";
				passthrough = 0.1;
				visual = "skin_vtail";
			};
			class TailBoom
			{   //Causes no effect on aircraft other than visual
				armor = 1;
				material = 51;
				name = "tailboom";
				passthrough = 0.5;
				visual = "skin_tailboom";
			};
			class HitTail
			{   //Causes no effect on aircraft other than visual
				armor = 0.5;
				material = 51;
				passthrough = 0.1;
				name = "hstab";
				visual = "skin_hstab";
			};
			class PNVS
			{
				armor = 0.3;
				material = 51;
				name = "pnvs";
				passthrough = 0.1;
				visual = "pnvs";
			};
			class FCR
			{   
				armor = 0.08;
				material = 51;
				name = "radar";
				passthrough = 0.1;
				visual = "radar";
			};
			/* CUSTOM HITPOINTS NOT CURRANTLY USED
			class Actuator
			{   //Causes no effect on aircraft other than visual, already done in hitgun
				armor = 0.3;
				material = 51;
				name = "otocvez";
				passthrough = 0.1;
				visual = "skin_m230";
			};
			class Gun: Actuator
			{   //Causes no effect on aircraft other than visual, already done in hitgun
				name = "otochlaven";
				visual = "skin_otochlaven";
			};
			class HitGear
			{   //Causes no effect on aircraft other than visual
				armor = 0.3;
				material = 51;
				name = "maingear";
				passthrough = 0.1;
				visual = "skin_gear";
			};
			class RearGear: HitGear
			{   //Causes no effect on aircraft other than visual
				name = "twsus";
				visual = "twsus";
			};*/
			class Pylon1
			{   //Causes no effect on aircraft other than visual
				armor = 0.3;
				material = 51;
				name = "pylon1";
				passthrough = 0.1;
				visual = "skin_pylon1";
			};
			class pylon2: Pylon1
			{   //Causes no effect on aircraft other than visual
				name = "pylon2";
				visual = "skin_pylon2";
			};
			class pylon3: Pylon1
			{   //Causes no effect on aircraft other than visual
				name = "pylon3";
				visual = "skin_pylon3";
			};
			class pylon4: Pylon1
			{   //Causes no effect on aircraft other than visual
				name = "pylon4";
				visual = "skin_pylon4";
			};
		};
		class UserActions
		{
			class lookcenter
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && alive this && !(this iskindof ""fza_ah64a_l"")";
				shortcut="LookCenter";
				statement="fza_ah64_mousehorpos = 0.5; fza_ah64_mousevertpos = 0.5; ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 601) ctrlSetPosition[fza_ah64_mousehorpos - 0.005, fza_ah64_mousevertpos - 0.009]; ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 602) ctrlSetPosition[fza_ah64_mousehorpos - 0.25, fza_ah64_mousevertpos + 0.02]; ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 601) ctrlCommit 0.01; ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 602) ctrlCommit 0.01;";
			};
			class sensorselect
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				//condition="(player == driver this || player == gunner this) && alive this && !(this iskindof ""fza_ah64a_l"" || this iskindof ""fza_ah64a_e"")";
				condition="(player == driver this || player == gunner this) && alive this && !(this iskindof ""fza_ah64a_l"")";
				shortcut="OpticsMode";
				statement="[this] call fza_fnc_weaponguncontrol;";
			};
			class pilotdoor_open
			{
				displayName="Open Pilot Door";
				position="pilot_action";
				onlyForPlayer=1;
				radius=3;
				showWindow=1;
				priority=10;
				condition="this animationphase ""pdoor"" < 0.5 && alive this && !(isengineon this)";
				shortcut="";
				statement="[this] spawn fza_fnc_doortoggleP";
			};
			class pilotdoor_close
			{
				displayName="Close Pilot Door";
				position="pilot_action";
				onlyForPlayer=1;
				radius=3;
				showWindow=0;
				priority=10;
				condition="this animationphase ""pdoor"" > 0.5 && alive this";
				shortcut="";
				statement="[this] spawn fza_fnc_doortoggleP";
			};
			class gundoor_open
			{
				displayName="Open Gunner Door";
				position="gunner_action";
				onlyForPlayer=1;
				radius=3;
				showWindow=0;
				priority=10;
				condition="this animationphase ""gdoor"" < 0.5 && alive this && !(isengineon this)";
				shortcut="";
				statement="[this] spawn fza_fnc_doortoggleG";
			};
			class gundoor_close
			{
				displayName="Close Gunner Door";
				position="gunner_action";
				onlyForPlayer=1;
				radius=3;
				showWindow=0;
				priority=10;
				condition="this animationphase ""gdoor"" > 0.5 && alive this";
				shortcut="";
				statement="[this] spawn fza_fnc_doortoggleG";
			};
			class tiron
			{
				displayName="Toggle Head Tracking On";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=9;
				condition="!fza_ah64_tiron && (player == driver this || player == gunner this)";
				statement="fza_ah64_tiron = !fza_ah64_tiron";
			};
			class tiroff
			{
				displayName="Toggle Head Tracking Off";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=9;
				condition="fza_ah64_tiron && (player == driver this || player == gunner this)";
				statement="fza_ah64_tiron = !fza_ah64_tiron";
			};
		};
		class MFD {};
		
		class AcreIntercoms
		{
            class Intercom_1
			{
                displayName = "Intercom (ICS)";
                shortName = "ICS";
                allowedPositions[] = {"crew"};
                disabledPositions[] = {};
                masterPositions[] = {"crew"}; // Seats with master stations have the possibility of broadcasting a message in that network
                limitedPositions[] = {"cargo"}; // Despite not having regular access to the network, units in cargo positions can have limited connections to communicate with the crew. These positions do not transmit automatically in the limited network; units in this position must toggle the functionality manually.
                numLimitedPositions = 3;  // This is the number of simultaneous connections that units defined in the previous array can have
                connectedByDefault = 0; // The intercom initial configuration is enabled upon entering a vehicle
            };
		};
		
		acre_hasInfantryPhone = 1; // 1 - enabled, 0 - disabled
		acre_infantryPhoneDisableRinging = 1;   // If set to 1, the ringing funtionality will not be available
		acre_infantryPhoneCustomRinging[] = {}; // An array used in order to override the default sound for the ringing functionality
		acre_infantryPhoneIntercom[] = {"intercom_1"}; // List of intercom names (intercom_1, intercom_2) or "all" in order to specify which intercom networks the phone can connect to
		acre_infantryPhoneControlActions[] = {"intercom_1"}; // Only those units in "intercom_1" can have access to ringing functionality
		acre_eventInfantryPhone = QFUNC(noApiFunction);
		
       class AcreRacks
        {
            class Rack_1
            {
               displayName = "ARC-186 (VHF)"; // Name is displayed in the interaction menu.
               shortName = "VHF";
               allowedPositions[] = {"driver","gunner"};     // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
               componentName = "ACRE_VRC103";
               disabledPositions[] = {};
               defaultComponents[] = {};                     // Use this to attach simple components like Antennas. Not yet fully implemented
               mountedRadio = "ACRE_PRC117F";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
           };
            class Rack_2
            {
               displayName = "ARC-164 (UHF)"; // Name is displayed in the interaction menu.
               shortName = "UHF";
               allowedPositions[] = {"driver","gunner"};     // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
               componentName = "ACRE_VRC103";
               disabledPositions[] = {};
               defaultComponents[] = {};                     // Use this to attach simple components like Antennas. Not yet fully implemented
               mountedRadio = "ACRE_PRC117F";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
           };
			class Rack_3
            {
               displayName = "ARC-201D (FM1)"; // Name is displayed in the interaction menu.
               shortName = "FM1";
               allowedPositions[] = {"driver","gunner"};     // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
               componentName = "ACRE_SEM90";
               disabledPositions[] = {};
               defaultComponents[] = {};                     // Use this to attach simple components like Antennas. Not yet fully implemented
               mountedRadio = "ACRE_SEM70";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
           };
            class Rack_4
            {
               displayName = "ARC-201D (FM2)"; // Name is displayed in the interaction menu.
               shortName = "FM2";
               allowedPositions[] = {"driver","gunner"};     // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
               componentName = "ACRE_SEM90";
               disabledPositions[] = {};
               defaultComponents[] = {};                     // Use this to attach simple components like Antennas. Not yet fully implemented
               mountedRadio = "ACRE_SEM70";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
           };
        };
		class Attributes
		{
			class fza_pylonLoadout
			{
				displayName = "Loadout Config"; // Name assigned to UI control class Title
				tooltip = "Loadout in JSON form to export"; // Tooltip assigned to UI control class Title
				property = "fza_ah64_loadout"; // Unique config property name saved in SQM
				control = "Edit"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

				// Expression called when applying the attribute in Eden and at the scenario start
				// The expression is called twice - first for data validation, and second for actual saving
				// Entity is passed as _this, value is passed as _value
				// %s is replaced by attribute config name. It can be used only once in the expression
				// In MP scenario, the expression is called only on server.
				expression = "[_this, _value] call fza_fnc_loadoutImportJson;";

				// Expression called when custom property is undefined yet (i.e., when setting the attribute for the first tim>
				// Entity (unit, group, marker, comment etc.) is passed as _this
				// Returned value is the default value
				// Used when no value is returned, or when it is of other type than NUMBER, STRING or ARRAY
				// Custom attributes of logic entities (e.g., modules) are saved always, even when they have default value
				defaultValue = "";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for var>
				validate = "none";
				condition = "object";
				typeName = "STRING";    
			};
		};
	};
	class fza_ah64d_b2e: fza_ah64base
	{
		side=1;
		scope=2;
		author="Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Rosd6(Dryden) & Community";
		displayName="AH-64D Apache Longbow";
		editorPreview = "\fza_ah64_us\editorPreview\fza_ah64d_b2e.jpg";
		model="\fza_ah64_US\fza_ah64d_b2.p3d";
		#include "hiddenSelections.hpp"
		//Ace Hitpoints
		ace_repair_hitpointPositions[] = {
			{"Hithull", 					{0,0,-1.5}},
			{"HitEngine1", 					{-1,0.7,-1}},
			{"HitEngine2", 					{1,0.7,-1}},
			{"HitVRotor", 					{-0.6,-6.95,-0.1}},
			{"HitHRotor", 					{0,2,0.7}},
			{"HitTail", 					{0,-7,-2}},
			{"HitVStabilizer1", 			{0,-7,-1}},
			{"HitHStabilizerL1", 			{-2,1.8,-1.3}},
			{"HitHStabilizerR1", 			{2,1.8,-1.3}},
			{"Hitfuel", 					{0,1,-1.6}},
			{"Hitfuel1", 					{0,5,-1.6}},
			{"HitGun", 						{0,5,-2.3}},
			{"HitTurret", 					{0,6.9,-1.5}},
			{"PNVS", 						{0,6.8,-1}},
			{"FCR", 						{0,2,1.6}},
			{"TailBoom", 					{0,-3,-2}},
			{"IrJammer", 					{-1,5,-1.6}},
			{"RfJammer", 					{1,5,-1.6}},
			{"Pylon1", 						{-2.385,2.4,-1.8}},
			{"Pylon2", 						{-1.665,2.4,-1.8}},
			{"Pylon3", 						{1.665,2.4,-1.8}},
			{"Pylon4", 						{2.385,2.4,-1.8}}
		};

		allowTabLock = 0;
		accuracy=5;
		armor=80;
		armorLights = 0.4;
		armorStructural = 4;
		audible=4;
		attendant = 0;
		camshakecoef = 0.3;
		cargoAction[]={"fza_ah64_leftcargo","fza_ah64_rightcargo"};
		commanderUsesPilotView = false;
		crewCrashProtection = 0.25;
		crewVulnerable = 0;
		damageResistance=0.0055499999;
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
		class textureSources
		{
			class b2
			{
				displayName = "Default";
				author = "NodUnit";
				textures[]= {"\fza_ah64_us\tex\Ex\b2_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class b2_weather
			{
				displayName = "Default (weathered)";
				author = "Franze";
				textures[]= {"\fza_ah64_us\tex\Ex\b2_weather_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class arb229th
			{
				displayName = "229th ARB";
				author = "Apache mod development team";
				textures[]= {"\fza_ah64_us\tex\Ex\229arb_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class arb229th_weather
			{
				displayName = "229th ARB (weathered)";
				author = "Apache mod development team";
				textures[]= {"\fza_ah64_us\tex\Ex\229arb_weather_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class rnlaf_q_09
			{
				displayName = "RNLAF 301 Squadron Q-09";
				author = "Houseman";
				textures[]= {"\fza_ah64_us\tex\Ex\b2_rnlaf_q_09_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class rnlaf_demo
			{
				displayName = "RNLAF 301 Squadron Demo Team";
				author = "Houseman";
				textures[]= {"\fza_ah64_us\tex\Ex\b2_rnlaf_demo_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class UK_AAC
			{
				displayName = "United Kingdom Army Air Corps";
				author = "Rosd6(Dryden) & NodUnit";
				textures[]= {"\fza_ah64_us\tex\Ex\UKAAC.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class UK_AAC_weathered
			{
				displayName = "United Kingdom Army Air Corps (weathered)";
				author = "Rosd6(Dryden) & NodUnit";
				textures[]= {"\fza_ah64_us\tex\Ex\UKAAC_weathered.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class UK_AAC_SF
			{
				displayName = "United Kingdom Army Air Corps Special Forces";
				author = "Rosd6(Dryden) & NodUnit";
				textures[]= {"\fza_ah64_us\tex\Ex\UKAAC_SF.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class 211th_clean
			{
				displayName = "1/211th ARB ""The Air Pirates"" Utah National Guard";
				author = "seven10 & Apache mod development team";
				textures[]= {"\fza_ah64_us\tex\Ex\211th_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class 211th_weathered
			{
				displayName = "1/211th ARB ""The Air Pirates"" Utah National Guard (weathered)";
				author = "seven10 & Apache mod development team";
				textures[]= {"\fza_ah64_us\tex\Ex\211th_weather_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class Israeli_Air_Force
			{
				displayName = "Israeli Air Force (IAF Saraf)";
				author = "NodUnit";
				textures[]= {"\fza_ah64_us\tex\Ex\Nodunit_Isreal_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class Shield
			{
				displayName = "Shield (Marvel)";
				author = "NodUnit";
				textures[]= {"\fza_ah64_us\tex\Ex\Shield.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
			class NodUnit
			{
				displayName = "Kane's Wrath";
				author = "NodUnit";
				textures[]= {"\fza_ah64_us\tex\Ex\Nodunit.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
			};
		};
		textureList[] = {"b2", 1};
		hiddenSelectionsTextures[] = {"\fza_ah64_us\tex\Ex\b2_co.paa","\fza_ah64_us\tex\ex\fcr_co.paa"};
		class Turrets
		{
			class MainTurret: NewTurret
			{
				gunnerAction = "fza_ah64_copilot";
				gunnerGetInAction = "pilot_Heli_Light_02_Enter";
				gunnerGetOutAction = "GetOutHigh";
				preciseGetInOut = 1;
				hideWeaponsGunner = false;
				primary = 1;
				primaryGunner = 1;
				stabilizedInAxes = 3;
				weapons[] = {"fza_ma_safe", "fza_gun_safe", "fza_rkt_safe", "fza_msl_safe", "Laserdesignator_mounted", "fza_burstlimiter","fza_m230"};
				magazines[] = {"fza_safe", "LaserBatteries", "fza_m230_300"};
				memoryPointsGetInGunner = "pos gunner";
			    memoryPointsGetInGunnerDir = "pos gunner dir";
			    memoryPointGun = "laserBegin";
				memoryPointGunnerOptics = "gunnerview";
				body = "tads_tur";
				gun = "tads";
				animationsourcebody = "tads_tur";
				animationsourcegun = "tads";
				gunBeg = "laserBegin";
				gunEnd = "laserEnd";
				gunnerOpticsModel = "";
				gunnerOpticsColor[] = {1,1,1,1};
				minElev = -60;
				maxElev = 30;
				initElev= 0;
				maxXRotSpeed = 1;	// yawing speed
				maxYRotSpeed = 1;	// pitching speed
				maxMouseXRotSpeed= 0.5;
				maxMouseYRotSpeed= 0.5;
				minTurn = -120;
				maxTurn = 120;
				initTurn = 0;
				minGunElev = -60;
				maxGunElev = 30;
				minGunTurn = -120;
				maxGunTurn = 120;
				minGunTurnAI = -90;
				maxGunTurnAI = 90;
				commanding = -1;
				gunnerForceOptics = 0;
				startEngine=0;
				outGunnerMayFire = 1;
				turretinfotype = "RscUnitInfoNoHUD";
				turretFollowFreeLook = 0;
				discreteDistance[]={100,200,300,400,500,600,700,800,1000,1200,1500,1800,2100,2500,2800,3300};
				discreteDistanceInitIndex=5;
				isCopilot = 1;
				usePiP=1;
				class Reflectors
				{
					class cabin
					{
						color[]={0.306, 0.878, 0.349};
						ambient[] = {0.306, 0.878, 0.349};
						intensity = 25;
						size = 1;
						innerAngle = 30;
						outerAngle = 150;
						coneFadeCoef = 1;
						position = "plt_floodlamps";
						direction = "plt_memflood";
						hitpoint = "plt_floodlamps";
						selection = "plt_floodlamps";
						useFlare = 0;
						flareSize = 0;
						flareMaxDistance = 0;
						dayLight = 1;
						blinking = 0;
						class Attenuation
						{
							start           = 0;
							constant        = 0;
							linear          = 1;
							quadratic       = 2;
							hardLimitStart  = 0.65;
							hardLimitEnd    = 1.9;
						};
					};
					class cargo_light_1: cabin
					{
						position = "cpg_flood";
						direction = "cpg_memflood";
						hitpoint = "cpg_flood";
						selection = "cpg_flood";
					};
				};
				class HitPoints
				{
					class HitTurret
					{
						armor = 0.9;
						material = 51;
						name = "tads_tur";
						visual = "skin_tads1";
						passThrough = 1;
					};
					class HitGun
					{
						armor = 1.3;
						material = 52;
						name = "otochlaven";
						visual = "skin_otochlaven";
						passThrough = 1;
					};
				};
				class OpticsIn
				{
					class Wide
					{
						gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
						directionStabilized = 1;
						initanglex = 0;
						initangley = 0;
						initfov = 0.466;
						maxanglex = 30;
						maxangley = 120;
						maxfov = 0.466;
						minanglex = -60;
						minangley = -120;
						minfov = 0.466;
						opticsdisplayname = "W";
						thermalmode[] = {0,1};
						visionmode[] = {"Normal","Ti"};
					};
					class Medium: Wide
					{
						gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
						initfov = 0.09;
						maxfov = 0.09;
						minfov = 0.09;
						opticsdisplayname = "M";
					};
					class Narrow: Wide
					{
						gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
						initfov = 0.01;
						maxfov = 0.01;
						minfov = 0.01;
						opticsdisplayname = "N";
					};
				};
				class OpticsOut
				{
					class Monocular //FOV CPG
					{
						gunneropticseffect[] = {};
						gunneropticsmodel = "";
						initfov = 0.7;
						initanglex = 0;
						initangley = 0;
						minfov = 0.4;
						maxfov = 0.7;
						minanglex = -60;
						maxanglex = 30;
						minangley = -120;
						maxangley = 120;
					};
				};
				class Components
				{
					class VehicleSystemsDisplayManagerComponentLeft
					{
						componentType = "VehicleSystemsDisplayManager";
						x = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFOLEFT_X"",	(safezoneX + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40))])";
						y = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFOLEFT_Y"",	(safezoneY + safezoneH - 21 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
						left = 1;
						defaultDisplay = "CrewDisplay";
						class Components
						{
							class EmptyDisplay		// Empty display - hide panel
							{
								componentType = "EmptyDisplayComponent";
							};
							class MinimapDisplay	// GPS
							{
								componentType = "MinimapDisplayComponent";
								resource = "RscCustomInfoMiniMap";
							};
						};
					};
					class VehicleSystemsDisplayManagerComponentRight : VehicleSystemsDisplayManagerComponentLeft {
						left = 0;
						right = 1;
						x = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFORIGHT_X"",((safezoneX + safezoneW) - ((10 * (((safezoneW / safezoneH) min 1.2) / 40)) + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40)))])";
						y = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFORIGHT_Y"",(safezoneY + safezoneH - 21 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
					};
				};
			};
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
			thermalmode[] = {0, 1};
			visionmode[] = {"Normal","Ti"}; //PNVS
		};

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
			displayName = "Add FCR";
			author = "Apache mod development team";
			onPhaseChanged = "_this # 0 enableVehicleSensor [""ActiveRadarSensorComponent"",_this # 1 == 1];";
			source = "user";
			initPhase = 1;
			animPeriod = 0.001;
		};
		class magazine_set_1200
		{
			displayName = "Swap IAFS for 1200rnd magazine"
			author = "Apache mod development team";
			onPhaseChanged = "_this remoteExec [""fza_fnc_weaponSwapM230Mag"",_this # 0];";
			source = "user";
			initPhase = 0;
			animPeriod = 0.001;
		};
		/*
		class hstab
		{
			source = "user";
			animPeriod = 0.01;
			initPhase  = 1;
		};
		*/
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
			/*
			class plt_floodlamps
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			*/
			class mpd_pl_obj1_v
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_pl_obj1_h
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_pl_obj1_z
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class hstab
			{
				source = "user";
				animPeriod = 0.001;
				initphase = 0;
			};
			class mpd_pl_obj2_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj2";
            };
			class mpd_pl_obj2_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj2";
            };
			class mpd_pl_obj2_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj2";
            };
			class mpd_pl_obj3_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj3";
            };
			class mpd_pl_obj3_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj3";
            };
			class mpd_pl_obj3_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj3";
            };
			class mpd_pl_obj4_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj4";
            };
			class mpd_pl_obj4_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj4";
            };
			class mpd_pl_obj4_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj4";
            };
			class mpd_pl_obj5_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj5";
            };
			class mpd_pl_obj5_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj5";
            };
			class mpd_pl_obj5_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj5";
            };
			class mpd_pl_obj6_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj6";
            };
			class mpd_pl_obj6_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj6";
            };
			class mpd_pl_obj6_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj6";
            };
			class mpd_pl_obj7_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj7";
            };
			class mpd_pl_obj7_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj7";
            };
			class mpd_pl_obj7_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj7";
            };
			class mpd_pl_obj8_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj8";
            };
			class mpd_pl_obj8_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj8";
            };
			class mpd_pl_obj8_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj8";
            };
			class mpd_pl_obj9_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj9";
            };
			class mpd_pl_obj9_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj9";
            };
			class mpd_pl_obj9_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj9";
            };
			class mpd_pl_obj10_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj10";
            };
			class mpd_pl_obj10_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj10";
            };
			class mpd_pl_obj10_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj10";
            };
			class mpd_pl_obj11_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj11";
            };
			class mpd_pl_obj11_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj11";
            };
			class mpd_pl_obj11_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj11";
            };
			class mpd_pl_obj12_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj12";
            };
			class mpd_pl_obj12_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj12";
            };
			class mpd_pl_obj12_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj12";
            };
			class mpd_pl_obj13_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj13";
            };
			class mpd_pl_obj13_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj13";
            };
			class mpd_pl_obj13_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj13";
            };
			class mpd_pl_obj14_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj14";
            };
			class mpd_pl_obj14_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj14";
            };
			class mpd_pl_obj14_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj14";
            };
			class mpd_pl_obj15_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj15";
            };
			class mpd_pl_obj15_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj15";
            };
			class mpd_pl_obj15_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj15";
            };
			class mpd_pl_obj16_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj16";
            };
			class mpd_pl_obj16_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj16";
            };
			class mpd_pl_obj16_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj16";
            };
			class mpd_pl_obj17_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj17";
            };
			class mpd_pl_obj17_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj17";
            };
			class mpd_pl_obj17_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj17";
            };
			class mpd_pl_obj18_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj18";
            };
			class mpd_pl_obj18_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj18";
            };
			class mpd_pl_obj18_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj18";
            };
			class mpd_pl_obj19_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj19";
            };
			class mpd_pl_obj19_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj19";
            };
			class mpd_pl_obj19_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj19";
            };
			class mpd_pl_obj20_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj20";
            };
			class mpd_pl_obj20_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj20";
            };
			class mpd_pl_obj20_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj20";
            };
			class mpd_pl_obj21_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj21";
            };
			class mpd_pl_obj21_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj21";
            };
			class mpd_pl_obj21_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj21";
            };
			class mpd_pl_obj22_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj22";
            };
			class mpd_pl_obj22_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj22";
            };
			class mpd_pl_obj22_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj22";
            };
			class mpd_pl_obj23_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj23";
            };
			class mpd_pl_obj23_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj23";
            };
			class mpd_pl_obj23_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj23";
            };
			class mpd_pl_obj24_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj24";
            };
			class mpd_pl_obj24_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj24";
            };
			class mpd_pl_obj24_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj24";
            };
			class mpd_pl_obj25_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj25";
            };
			class mpd_pl_obj25_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj25";
            };
			class mpd_pl_obj25_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj25";
            };
			class mpd_pl_obj26_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj26";
            };
			class mpd_pl_obj26_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj26";
            };
			class mpd_pl_obj26_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj26";
            };
			class mpd_pl_obj27_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj27";
            };
			class mpd_pl_obj27_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj27";
            };
			class mpd_pl_obj27_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj27";
            };
			class mpd_pl_obj28_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj28";
            };
			class mpd_pl_obj28_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj28";
            };
			class mpd_pl_obj28_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj28";
            };
			class mpd_pl_obj29_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj29";
            };
			class mpd_pl_obj29_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj29";
            };
			class mpd_pl_obj29_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj29";
            };
			class mpd_pl_obj30_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj30";
            };
			class mpd_pl_obj30_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj30";
            };
			class mpd_pl_obj30_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj30";
            };
			class mpd_pl_obj31_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj31";
            };
			class mpd_pl_obj31_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj31";
            };
			class mpd_pl_obj31_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj31";
            };
			class mpd_pl_obj32_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_obj32";
            };
			class mpd_pl_obj32_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_obj32";
            };
			class mpd_pl_obj32_z : mpd_pl_obj1_z
            {
                selection = "mpd_pl_obj32";
            };
			////LMPDOBJS//////
			class mpd_gr_obj1_v
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_gr_obj1_h
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_gr_obj1_z
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_gr_obj2_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj2";
            };
			class mpd_gr_obj2_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj2";
            };
			class mpd_gr_obj2_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj2";
            };
			class mpd_gr_obj3_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj3";
            };
			class mpd_gr_obj3_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj3";
            };
			class mpd_gr_obj3_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj3";
            };
			class mpd_gr_obj4_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj4";
            };
			class mpd_gr_obj4_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj4";
            };
			class mpd_gr_obj4_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj4";
            };
			class mpd_gr_obj5_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj5";
            };
			class mpd_gr_obj5_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj5";
            };
			class mpd_gr_obj5_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj5";
            };
			class mpd_gr_obj6_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj6";
            };
			class mpd_gr_obj6_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj6";
            };
			class mpd_gr_obj6_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj6";
            };
			class mpd_gr_obj7_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj7";
            };
			class mpd_gr_obj7_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj7";
            };
			class mpd_gr_obj7_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj7";
            };
			class mpd_gr_obj8_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj8";
            };
			class mpd_gr_obj8_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj8";
            };
			class mpd_gr_obj8_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj8";
            };
			class mpd_gr_obj9_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj9";
            };
			class mpd_gr_obj9_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj9";
            };
			class mpd_gr_obj9_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj9";
            };
			class mpd_gr_obj10_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj10";
            };
			class mpd_gr_obj10_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj10";
            };
			class mpd_gr_obj10_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj10";
            };
			class mpd_gr_obj11_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj11";
            };
			class mpd_gr_obj11_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj11";
            };
			class mpd_gr_obj11_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj11";
            };
			class mpd_gr_obj12_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj12";
            };
			class mpd_gr_obj12_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj12";
            };
			class mpd_gr_obj12_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj12";
            };
			class mpd_gr_obj13_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj13";
            };
			class mpd_gr_obj13_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj13";
            };
			class mpd_gr_obj13_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj13";
            };
			class mpd_gr_obj14_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj14";
            };
			class mpd_gr_obj14_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj14";
            };
			class mpd_gr_obj14_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj14";
            };
			class mpd_gr_obj15_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj15";
            };
			class mpd_gr_obj15_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj15";
            };
			class mpd_gr_obj15_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj15";
            };
			class mpd_gr_obj16_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj16";
            };
			class mpd_gr_obj16_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj16";
            };
			class mpd_gr_obj16_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj16";
            };
			class mpd_gr_obj17_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj17";
            };
			class mpd_gr_obj17_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj17";
            };
			class mpd_gr_obj17_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj17";
            };
			class mpd_gr_obj18_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj18";
            };
			class mpd_gr_obj18_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj18";
            };
			class mpd_gr_obj18_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj18";
            };
			class mpd_gr_obj19_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj19";
            };
			class mpd_gr_obj19_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj19";
            };
			class mpd_gr_obj19_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj19";
            };
			class mpd_gr_obj20_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj20";
            };
			class mpd_gr_obj20_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj20";
            };
			class mpd_gr_obj20_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj20";
            };
			class mpd_gr_obj21_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj21";
            };
			class mpd_gr_obj21_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj21";
            };
			class mpd_gr_obj21_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj21";
            };
			class mpd_gr_obj22_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj22";
            };
			class mpd_gr_obj22_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj22";
            };
			class mpd_gr_obj22_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj22";
            };
			class mpd_gr_obj23_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj23";
            };
			class mpd_gr_obj23_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj23";
            };
			class mpd_gr_obj23_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj23";
            };
			class mpd_gr_obj24_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj24";
            };
			class mpd_gr_obj24_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj24";
            };
			class mpd_gr_obj24_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj24";
            };
			class mpd_gr_obj25_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj25";
            };
			class mpd_gr_obj25_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj25";
            };
			class mpd_gr_obj25_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj25";
            };
			class mpd_gr_obj26_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj26";
            };
			class mpd_gr_obj26_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj26";
            };
			class mpd_gr_obj26_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj26";
            };
			class mpd_gr_obj27_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj27";
            };
			class mpd_gr_obj27_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj27";
            };
			class mpd_gr_obj27_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj27";
            };
			class mpd_gr_obj28_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj28";
            };
			class mpd_gr_obj28_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj28";
            };
			class mpd_gr_obj28_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj28";
            };
			class mpd_gr_obj29_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj29";
            };
			class mpd_gr_obj29_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj29";
            };
			class mpd_gr_obj29_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj29";
            };
			class mpd_gr_obj30_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj30";
            };
			class mpd_gr_obj30_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj30";
            };
			class mpd_gr_obj30_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj30";
            };
			class mpd_gr_obj31_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj31";
            };
			class mpd_gr_obj31_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj31";
            };
			class mpd_gr_obj31_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj31";
            };
			class mpd_gr_obj32_v : mpd_gr_obj1_v
            {
                selection = "mpd_gr_obj32";
            };
			class mpd_gr_obj32_h : mpd_gr_obj1_h
            {
                selection = "mpd_gr_obj32";
            };
			class mpd_gr_obj32_z : mpd_gr_obj1_z
            {
                selection = "mpd_gr_obj32";
            };
			////ELMPDOBJS/////
			class mpd_pr_flt_wbear : mpd_pl_obj1_h
            {
                selection = "mpd_pr_flt_wbear";
            };
			class mpd_pr_flt_rdr : mpd_pl_obj1_h
            {
                selection = "mpd_pr_flt_rdr";
            };
			class mpd_pr_flt_wp_v : mpd_pl_obj1_v
            {
                selection = "mpd_pr_flt_wp";
            };
			class mpd_pr_flt_wp_h : mpd_pl_obj1_h
            {
                selection = "mpd_pr_flt_wp";
            };
			class mpd_pr_flt_vvi_v : mpd_pl_obj1_v
            {
                selection = "mpd_pr_flt_vvi";
            };
			class mpd_pr_flt_vvi_h : mpd_pl_obj1_h
            {
                selection = "mpd_pr_flt_vvi";
            };
			class mpd_pr_flt_turn : mpd_pl_obj1_h
            {
                selection = "mpd_pr_flt_turn";
            };
			class mpd_pr_flt_slip : mpd_pl_obj1_h
            {
                selection = "mpd_pr_flt_slip";
            };
			class mpd_pl_flt_wbear : mpd_pl_obj1_h
            {
                selection = "mpd_pl_flt_wbear";
            };
			class mpd_pl_flt_rdr : mpd_pl_obj1_h
            {
                selection = "mpd_pl_flt_rdr";
            };
			class mpd_pl_flt_wp_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_flt_wp";
            };
			class mpd_pl_flt_wp_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_flt_wp";
            };
			class mpd_pl_flt_vvi_v : mpd_pl_obj1_v
            {
                selection = "mpd_pl_flt_vvi";
            };
			class mpd_pl_flt_vvi_h : mpd_pl_obj1_h
            {
                selection = "mpd_pl_flt_vvi";
            };
			class mpd_pl_flt_turn : mpd_pl_obj1_h
            {
                selection = "mpd_pl_flt_turn";
            };
			class mpd_pl_flt_slip : mpd_pl_obj1_h
            {
                selection = "mpd_pl_flt_slip";
            };
			class mpd_pr_eng_ltrqbar : mpd_pl_obj1_v
            {
                selection = "mpd_pr_eng_ltrqbar";
            };
			class mpd_pr_eng_1tgt : mpd_pr_eng_ltrqbar
            {
                selection = "mpd_pr_eng_1tgt";
            };
			class mpd_pr_eng_e1trq : mpd_pr_eng_1tgt
            {
                selection = "mpd_pr_eng_e1trq";
            };
			class mpd_pr_eng_e1np : mpd_pr_eng_1tgt
            {
                selection = "mpd_pr_eng_e1np";
            };
			class mpd_pr_eng_2tgt : mpd_pr_eng_1tgt
            {
                selection = "mpd_pr_eng_2tgt";
            };
			class mpd_pr_eng_e2trq : mpd_pr_eng_1tgt
            {
                selection = "mpd_pr_eng_e2trq";
            };
			class mpd_pr_eng_e2np : mpd_pr_eng_1tgt
            {
                selection = "mpd_pr_eng_e2np";
            };
			class mpd_pr_eng_rtrrpm : mpd_pr_eng_1tgt
            {
                selection = "mpd_pr_eng_rtrrpm";
            };
			/*
			class mpd_pr_eng_rtrrpm : mpd_pr_eng_1tgt
            {
                selection = "mpd_pr_eng_rtrrpm";
            };
			*/
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
		////MOVING MAP TEST/////
			class mpd_gr_mmap_v
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_gr_mmap_h
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_gr_mmap_z
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_gr_mmap_s1
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_gr_mmap_s2
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_gr_mmap_s3
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };

			class mpd_pr_mmap_v
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_pr_mmap_h
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_pr_mmap_z
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_pr_mmap_s1
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_pr_mmap_s2
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };
			class mpd_pr_mmap_s3
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
            };

		////MOVING MAP/////
		class mpd_pr_mpd_had_apos_v
		{
			source = "user";
			animPeriod = 0.01;
			initPhase=0;
		};
		class mpd_pr_mpd_had_apos_h
		{
			source = "user";
			animPeriod = 0.01;
			initPhase=0;
		};
		class mpd_pr_mpd_had_apos2_h
		{
			source = "user";
			animPeriod = 0.01;
			initPhase=0;
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
			useFlare = 0;
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
			flareSize = 10;
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
	};
	class fza_ah64d_b2e_nr: fza_ah64d_b2e
	{
		side=1;
		scope=2;
		author="Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Rosd6(Dryden) & Community";
		displayName="AH-64D Apache Longbow (no radar)";
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

	/////////////////////////////////////////////////
	///////////////////JAMMERS///////////////////////
	/////////////////////////////////////////////////

	class RoadCone_F;
	class fza_ah64_ic: RoadCone_F
	{
		scope=1;
		irtarget=0;
		displayname="CONTROL";
		model="\fza_ah64_US\fza_ic_box";
		ladders[]={};
		//make it indestructable til we delete it
		armor=1000000000;
		side=3;
		simulation = "thing";
	};
	class fza_ah64_tailboom_debris: RoadCone_F
	{
		scope=1;
		model = "\fza_ah64_us\prx\fza_dam_tailboom_debris";
		displayName = "DEBRIS";
		submerged = 0;
		submergeSpeed = 0;
		timeToLive = 30;
		disappearAtContact = 0;
	};
	class fza_ah64_vtail_debris: fza_ah64_tailboom_debris
	{
		model = "\fza_ah64_us\prx\fza_dam_vtail_debris";
	};
	class fza_ah64_tr_debris: fza_ah64_tailboom_debris
	{
		model = "\fza_ah64_us\prx\dam_tr_debris";
	};
	class fza_ah64_hstab_debris: fza_ah64_tailboom_debris
	{
		model = "\fza_ah64_us\prx\fza_dam_hstab_debris";
	};
};
