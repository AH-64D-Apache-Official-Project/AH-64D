#define TEast 0
#define TWest 1
#define TGuerrila 2
#define TCivilian 3
#define TSideUnknown 4
#define TEnemy 5
#define TFriendly 6
#define TLogic 7

#define true 1
#define false 0

// type scope
#define private 0
#define protected 1
#define public 2


#define CanSeeRadar 1
#define CanSeeEye 2
#define CanSeeOptics 4
#define CanSeeEar 8
#define CanSeeCompass 16
//#define CanSeeRadarC CanSeeRadar+CanSeeCompass
#define CanSeeAll 31

#define StabilizedInAxesBoth 3

class CfgFontFamilies
{
	class fza_txled
	{
		fonts[] = {"\fza_ah64_controls\font\txled6", "\fza_ah64_controls\font\txled7", "\fza_ah64_controls\font\txled", "\fza_ah64_controls\font\txled9", "\fza_ah64_controls\font\txled10", "\fza_ah64_controls\font\txled11", "\fza_ah64_controls\font\txled12", "\fza_ah64_controls\font\txled13", "\fza_ah64_controls\font\txled14", "\fza_ah64_controls\font\txled15", "\fza_ah64_controls\font\txled16", "\fza_ah64_controls\font\txled17", "\fza_ah64_controls\font\txled18", "\fza_ah64_controls\font\txled19", "\fza_ah64_controls\font\txled20", "\fza_ah64_controls\font\txled21", "\fza_ah64_controls\font\txled22", "\fza_ah64_controls\font\txled23", "\fza_ah64_controls\font\txled24", "\fza_ah64_controls\font\txled25", "\fza_ah64_controls\font\txled26", "\fza_ah64_controls\font\txled27", "\fza_ah64_controls\font\txled28", "\fza_ah64_controls\font\txled29", "\fza_ah64_controls\font\txled30", "\fza_ah64_controls\font\txled31", "\fza_ah64_controls\font\txled34", "\fza_ah64_controls\font\txled37", "\fza_ah64_controls\font\txled46" };
		spaceWidth = 0.7;
		spacing = 0.2;
	};
};
class CfgFactionClasses
{
	class fza_usaav
	{
		displayName = "FZA - US Army Aviation";
		priority = 2;
		icon = "\a3\Data_f\cfgFactionClasses_BLU_ca.paa";
		side = "TWest";
	};
};
class CfgVehicleClasses
{
	class fza_helicopters
	{
		displayName = "FZA - Helicopters";
	};
};
class CfgPatches
{
	class fza_ah64_US
	{
		units[] = {"fza_ah64base","fza_ah64d_b2e","fza_ah64d_b2e_nr"};
		weapons[] = {};
		requiredVersion = 1.0; 
		requiredAddons[] = {"A3_Air_F_Beta"};
	};
};

class CfgAnimationSourceSounds
{
		class eng1_start_sound
			{
				loop = 1;
				terminate = 0;
				sound0[] = {"\fza_ah64_us\audio\button_click1.ogg",3,1,40};
				sound[] = {"sound0",1};	
			};
		class eng2_start_sound
			{
				loop = 1;
				terminate = 0;
				sound0[] = {"\fza_ah64_us\audio\button_click2.ogg",3,1,40};
				sound[] = {"sound0",1};	
			};
		class rtrbrake_sound
			{
				loop = 1;
				terminate = 0;
				sound0[] = {"\fza_ah64_us\audio\switch_flip1.ogg",3,1,40};
				sound[] = {"sound0",1};	
			};
};

class CfgSounds
{
	class fza_ah64_pnvs_fail_1
	{
		name = "fza_ah64_pnvs_fail_1";
		sound[] = {\fza_ah64_us\audio\pnvs_fail_1.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_tads_failure_1
	{
		name = "fza_ah64_tads_failure_1";
		sound[] = {\fza_ah64_us\audio\tads_failure_1.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_tail_rotor_damaged_1
	{
		name = "fza_ah64_tail_rotor_damaged_1";
		sound[] = {\fza_ah64_us\audio\tail_rotor_damaged_1.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_tail_rotor_failure_1
	{
		name = "fza_ah64_tail_rotor_failure_1";
		sound[] = {\fza_ah64_us\audio\tail_rotor_failure_1.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_main_rotor_damaged_1
	{
		name = "fza_ah64_main_rotor_damaged_1";
		sound[] = {\fza_ah64_us\audio\main_rotor_damaged_1.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_main_rotor_failure_1
	{
		name = "fza_ah64_main_rotor_failure_1";
		sound[] = {\fza_ah64_us\audio\main_rotor_failure_1.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_2s6_track
	{
		name = "fza_ah64_2s6_track";
		sound[] = {\fza_ah64_us\audio\lb2_2s6_track.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_zsu23_track
	{
		name = "fza_ah64_zsu23_track";
		sound[] = {\fza_ah64_us\audio\lb2_zsu23_track.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_rdr_track
	{
		name = "fza_ah64_rdr_track";
		sound[] = {\fza_ah64_us\audio\lb2_rdr_track.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_sa19
	{
		name = "fza_ah64_bt_sa19";
		sound[] = {\fza_ah64_us\audio\betty\bt_sa19c.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_zsu23
	{
		name = "fza_ah64_bt_zsu23";
		sound[] = {\fza_ah64_us\audio\betty\bt_zsu23.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_tracking
	{
		name = "fza_ah64_bt_tracking";
		sound[] = {\fza_ah64_us\audio\betty\bt_trackingb.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_detected
	{
		name = "fza_ah64_bt_detected";
		sound[] = {\fza_ah64_us\audio\betty\bt_detected.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_missile
	{
		name = "fza_ah64_bt_missile";
		sound[] = {\fza_ah64_us\audio\betty\bt_missle.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_high
	{
		name = "fza_ah64_bt_high";
		sound[] = {\fza_ah64_us\audio\betty\bt_high.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_low
	{
		name = "fza_ah64_bt_low";
		sound[] = {\fza_ah64_us\audio\betty\bt_low.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_1oclock
	{
		name = "fza_ah64_bt_1oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_1oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_2oclock
	{
		name = "fza_ah64_bt_2oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_2oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_3oclock
	{
		name = "fza_ah64_bt_3oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_3oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_4oclock
	{
		name = "fza_ah64_bt_4oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_4oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_5oclock
	{
		name = "fza_ah64_bt_5oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_5oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_6oclock
	{
		name = "fza_ah64_bt_6oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_6oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_7oclock
	{
		name = "fza_ah64_bt_7oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_7oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_8oclock
	{
		name = "fza_ah64_bt_8oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_8oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_9oclock
	{
		name = "fza_ah64_bt_9oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_9oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_10oclock
	{
		name = "fza_ah64_bt_10oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_10oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_11oclock
	{
		name = "fza_ah64_bt_11oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_11oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_12oclock
	{
		name = "fza_ah64_bt_12oclock";
		sound[] = {\fza_ah64_us\audio\betty\bt_12oclock.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_fire
	{
		name = "fza_ah64_bt_fire";
		sound[] = {\fza_ah64_us\audio\betty\bt_fire.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_engine1
	{
		name = "fza_ah64_bt_engine1";
		sound[] = {\fza_ah64_us\audio\betty\bt_engine1.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_engine2
	{
		name = "fza_ah64_bt_engine2";
		sound[] = {\fza_ah64_us\audio\betty\bt_engine2b.ogg,1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_apu
	{
		name = "fza_ah64_bt_apu";
		sound[] = {"\fza_ah64_us\audio\betty\bt_apu.ogg",1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_failure
	{
		name = "fza_ah64_bt_failure";
		sound[] = {"\fza_ah64_us\audio\betty\bt_failure.ogg",1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_actuator
	{
		name = "fza_ah64_bt_actuator";
		sound[] = {"\fza_ah64_us\audio\betty\bt_actuator.ogg",1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_gun
	{
		name = "fza_ah64_bt_gun";
		sound[] = {"\fza_ah64_us\audio\betty\bt_gun.ogg",1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_jammed
	{
		name = "fza_ah64_bt_jammed";
		sound[] = {"\fza_ah64_us\audio\betty\bt_jammedb.ogg",1,1,1};
		titles[]={};
	};
	class fza_ah64_bt_rotorrpm
	{
		name = "fza_ah64_bt_rotorrpm";
		sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm.ogg",1,1,1};
		titles[]={};
	};

	///STARTING CLICKABLE SEQUENCE SOUNDS///
	class fza_ah64_estart1
	{
		name = "fza_ah64_estart1";
		sound[] = {"fza_ah64_us\audio\ah64_estart1.ogg",0.33,1,200};
		titles[]={};
	};
	class fza_ah64_apustart1
	{
		name = "fza_ah64_apustart1";
		sound[] = {"fza_ah64_us\audio\APU_Start.ogg",0.33,1,200};
		titles[]={};
	};
	///END OF STARTING CLICKABLE SEQUENCE SOUNDS////
	
	///GENERIC FLIP SOUNDS///
	class fza_ah64_button_click1
	{
		name = "fza_ah64_button_click1";
		sound[] = {"fza_ah64_us\audio\button_click1.ogg",1,1,1};
		titles[]={};
	};
	class fza_ah64_button_click2
	{
		name = "fza_ah64_button_click2";
		sound[] = {"\fza_ah64_us\audio\button_click2.ogg",1,1,1};
		titles[]={};
	};
	class fza_ah64_switch_flip1
	{
		name = "fza_ah64_switch_flip1";
		sound[] = {"\fza_ah64_us\audio\switch_flip1.ogg",1,1,1};
		titles[]={};
	};
	///END OF GENERIC FLIP SOUNDS///
	
	///DOOR SOUNDS///
	class fza_ah64_rh_dooropen1
	{
		name = "fza_ah64_rh_dooropen1";
		sound[] = {"\fza_ah64_us\audio\rh_dooropen1.ogg",1,1,1};
		titles[]={};
	};
	class fza_ah64_rh_doorclose1
	{
		name = "fza_ah64_rh_doorclose1";
		sound[] = {"\fza_ah64_us\audio\rh_doorclose1.ogg",1,1,1};
		titles[]={};
	};
	///END OF DOOR SOUNDS///
	
};
class CfgRadio
{
	class fza_ah64_pnvs_fail_1
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\pnvs_fail_1.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_tads_failure_1
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\tads_failure_1.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_tail_rotor_damaged_1
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\tail_rotor_damaged_1.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_tail_rotor_failure_1
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\tail_rotor_failure_1.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_main_rotor_damaged_1
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\main_rotor_damaged_1.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_main_rotor_failure_1
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\main_rotor_failure_1.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_2s6_track
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\lb2_2s6_track.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_zsu23_track
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\lb2_zsu23_track.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_rdr_track
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\lb2_rdr_track.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_sa19
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_sa19c.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_zsu23
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_zsu23.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_tracking
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_trackingb.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_detected
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_detected.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_missile
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_missle.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_high
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_high.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_low
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_low.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_1oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_1oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_2oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_2oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_3oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_3oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_4oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_4oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_5oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_5oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_6oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_6oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_7oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_7oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_8oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_8oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_9oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_9oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_10oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_10oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_11oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_11oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_12oclock
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_12oclock.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_fire
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_fire.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_engine1
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_engine1.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_engine2
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_engine2b.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_apu
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_apu.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_failure
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_failure.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_actuator
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_actuator.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_gun
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_gun.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_jammed
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_jammedb.ogg",1,1,1};
		title = ;
	};
	class fza_ah64_bt_rotorrpm
	{
		name = "";
		sound[] = {"fza_ah64_us\audio\betty\bt_rotorrpm.ogg",1,1,1};
		title = ;
	};
};
//////MISSILES EFFECTS//////
class fza_ah64_rocketsmoke
{
	class Light1
	{
		simulation = "light";
		type = "RocketLight";
		position[] = {0,0,0};
		intensity = 0.01;
		interval = 1;
		lifeTime = 1;
	};
	class MissileEffects1
	{
		simulation = "particles";
		type = "Missile1";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
};
class fza_ah64_hellfiresmoke
{
	class Light1
	{
		simulation = "light";
		type = "RocketLight";
		  position[] = {0,0,0};
		  intensity = 0.01;
		  interval = 1;
		  lifeTime = 1;
	};
	class Missile2
	{
		simulation = "particles";
		type = "Missile2";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
};
class fza_ah64_stingersmoke
{
	class Light1
	{
		simulation = "light";
		type = "RocketLight";
		position[] = {0,0,0};
		intensity = 0.01;
		interval = 1;
		lifeTime = 1;
	};
	class Missile3
	{
		simulation = "particles";
		type = "Missile3";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
};
//////END OF MISSILES EFFECTS//////
class CfgMovesBasic
{
	class DefaultDie;
	class ManActions
	{
		fza_ah64_leftcargo = "fza_ah64_leftcargo";
		fza_ah64_rightcargo = "fza_ah64_rightcargo";
		fza_ah64_plt_movearm = "fza_ah64_plt_movearm";
		fza_ah64_pilot = "fza_ah64_pilot";
		fza_ah64_copilot = "fza_ah64_copilot";
	};
};
class CfgMovesMaleSdr: CfgMovesBasic
{
	class States
	{
		class Crew;
		class pilot_Heli_Transport_01: Crew {};
		class fza_ah64_leftcargo_dead: DefaultDie
		{
			actions = "DeadActions";
			speed = 0.5;
			looped = "false";
			terminal = 1;
			file = "\fza_ah64_us\anim\fza_ah64_leftcargo_dead.rtm";
			connectTo[] = {"DeadState",0.1};
		};
		class fza_ah64_leftcargo: Crew
		{
			file = "\fza_ah64_us\anim\fza_ah64_leftcargo.rtm";
			interpolateTo[] = {"fza_ah64_leftcargo_dead",1};
		};
		class fza_ah64_rightcargo_dead: DefaultDie
		{
			actions = "DeadActions";
			speed = 0.5;
			looped = "false";
			terminal = 1;
			file = "\fza_ah64_us\anim\fza_ah64_rightcargo_dead.rtm";
			connectTo[] = {"DeadState",0.1};
		};
		class fza_ah64_rightcargo: Crew
		{
			file = "\fza_ah64_us\anim\fza_ah64_rightcargo.rtm";
			interpolateTo[] = {"fza_ah64_rightcargo_dead",1};
		};
		class fza_ah64_plt_movearm: Crew
		{
			file = "\fza_ah64_us\anim\fza_ah64_plt_movearm.rtm";
			interpolateTo[] = {};
			speed = 0.5;
			looped = 0;
		};
		class fza_ah64_pilot: Crew
		{
			file = "\fza_ah64_us\anim\fza_ah64_pilot.rtm";
			interpolateTo[] = {"KIA_pilot_Heli_Transport_01",1};
		};
		class fza_ah64_copilot: Crew
		{
			file = "\A3\cargoposes_F\Anim\gunner_Heli_Attack_02_mocap.rtm"; //Heli_Attack_02_Gunner  //gunner_MRAP_01 //CoDriver_Van_02 //Acts_gunner_MRAP_01_mocap //gunner_Heli_Attack_02_mocap
			speed = 0.03;
			interpolateTo[] = {"KIA_pilot_Heli_Transport_01",1};
		};
	};
};
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
class CfgWeapons
{
	class CMFlareLauncher;
	
	class Default{};
	class MGunCore: Default{};
	class MGun: MGunCore {};
	class SmokeLauncher: MGun {};
	class LauncherCore: Default{};
	class CannonCore: Default{};
	class MissileLauncher: LauncherCore{};
	class Launcher: LauncherCore {};
	class Stinger: Launcher {};
	class RocketPods: LauncherCore {};
	class fza_ah64_flare30: CMFlareLauncher {};
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
		displayName="M230E1 CORE";
		displayNameMagazine="M230 30mm";
		shortNameMagazine="M230";
		cursor = "";
		cursorAim = "";
		cursorAimOn = "";
		scope = 1;
		initspeed=805;
		ballisticscomputer = 1;
		laserLock = 1;
		canLock = 2;
		autoreload = 1;
		shotFromTurret = false;
		magazines[]={fza_m230_1200};
		//modes[]= {"fza_full","fza_burst10","fza_burst20"};
		modes[]= {"fza_burst10","fza_burst20"};
		class fza_full: CannonCore
		{
			class StandardSound
            {
				weaponfire[] = {"\fza_ah64_us\audio\M230_Dist.ogg",4,1,4000};
				soundBegin[] = {"weaponfire",1};
				weaponsoundeffect = "DefaultRifle";
            };
			displayName="M230E1 FULL AUTO";
			cursor = "";
			cursoraim = "";
			cursorAimOn = "";
			recoil = "Empty";
			recoilProne = "Empty";
			multiplier=1;
			burst=1;
			dispersion = 0.005000;
			sounds[] = {"StandardSound"};
			soundburst= false;
			soundContinuous= 0;
			reloadTime=0.096;
			autofire= false;
			autoreload = 1;
			aiRateOfFire=0.096;
			aiRateOfFireDistance = 400;
			useAction = 0;
			useActionTitle = "";
			showToPlayer = 1;
			minRange = 100;
			minRangeProbab = 0.500000;
			midRange = 1000;
			midRangeProbab = 0.780000;
			maxRange = 2000;
			maxRangeProbab = 0.200000;
	};
		class fza_burst10: fza_full
		{
			class StandardSound
            {
				weaponfire[] = {"\fza_ah64_us\audio\M230_Dist_burst10.ogg",4,1,4000};
				soundBegin[] = {"weaponfire",1};
				weaponsoundeffect = "DefaultRifle";
            };
			displayName="M230E1 BURST x10";
			burst = 10;
			sounds[] = {"StandardSound"};
			soundBurst= true;
		};
		class fza_burst20: fza_full
		{
			class StandardSound
            {
				weaponfire[] = {"\fza_ah64_us\audio\M230_Dist_burst20.ogg",4,1,4000};
				soundBegin[] = {"weaponfire",1};
				weaponsoundeffect = "DefaultRifle";
            };
			displayName="M230E1 BURST x20";
			burst = 20;
			sounds[] = {"StandardSound"};
			soundBurst= true;
		};
	};
	class fza_burstlimiter: fza_m230 
	{
		scope = 1;
	};
	class fza_agm114_16 : MissileLauncher
	{
		scope = 1;
		displayName="AGM-114 HELLFIRE";
		displayNameMagazine="AGM-114";
		shortNameMagazine="AGM-114";
		magazines[]={fza_agm114k_16};
		weaponlocksystem = 0;
		lockedtargetsound[] = {"", 1, 1};
		lockingtargetsound[] = {"", 1, 1};
		canlock = 0;
		cursor = "";
		cursoraim = "";
		cursorAimOn = "";
		cursorsize = 1;
		sounds[] = {StandardSound};
		class StandardSound
        {
			weaponfire[] = {"\fza_ah64_us\audio\AGM114_Mid.ogg", 40,1,40};
			soundBegin[] = {"weaponfire",1};
			weaponsoundeffect = "DefaultRifle";
		};
		soundfly[] = {"\ca\Sounds\weapons\cannon\rocket_fly1", 100, 1, 800};
		airateoffire = 5;
		airateoffiredistance = 4000;
		cmimmunity = 0.8;
		maxrange = 7000;
		maxrangeprobab = 0.1;
		midrange = 4000;
		midrangeprobab = 0.9;
		minrange = 2000;
		minrangeprobab = 0.6;
		reloadtime = 1;
	};
	class fza_agm114_23_8 : fza_agm114_16
	{
		displayName="AGM-114 (2,3)";
		magazines[]={fza_agm114l_23_8,fza_agm114k_23_8,fza_agm114c_23_8,fza_agm114a_23_8,fza_agm114m_23_8,fza_agm114n_23_8};
	};
	class fza_agm114_14_8 : fza_agm114_16
	{
		displayName="AGM-114 (1,4)";
		magazines[]={fza_agm114l_14_8,fza_agm114k_14_8,fza_agm114c_14_8,fza_agm114a_14_8,fza_agm114m_14_8,fza_agm114n_14_8};
	};
	///////1///////////////////////////////
	class fza_agm114_1_4 : fza_agm114_16
	{
		displayName="AGM-114 (1)";
		magazines[]={fza_agm114l_1_4,fza_agm114k_1_4,fza_agm114c_1_4,fza_agm114a_1_4,fza_agm114m_1_4,fza_agm114n_1_4};
	};
	class fza_agm114_1_ul : fza_agm114_16
	{
		displayName="AGM-114 (1,L1)";
		magazines[]={fza_agm114l_1_ul,fza_agm114k_1_ul,fza_agm114c_1_ul,fza_agm114a_1_ul,fza_agm114m_1_ul,fza_agm114n_1_ul};
	};
	class fza_agm114_1_ur : fza_agm114_16
	{
		displayName="AGM-114 (1,R1)";
		magazines[]={fza_agm114l_1_ur,fza_agm114k_1_ur,fza_agm114c_1_ur,fza_agm114a_1_ur,fza_agm114m_1_ur,fza_agm114n_1_ur};
	};
	class fza_agm114_1_ll : fza_agm114_16
	{
		displayName="AGM-114 (1,L2)";
		magazines[]={fza_agm114l_1_ll,fza_agm114k_1_ll,fza_agm114c_1_ll,fza_agm114a_1_ll,fza_agm114m_1_ll,fza_agm114n_1_ll};
	};
	class fza_agm114_1_lr : fza_agm114_16
	{
		displayName="AGM-114 (1,R2)";
		magazines[]={fza_agm114l_1_lr,fza_agm114k_1_lr,fza_agm114c_1_lr,fza_agm114a_1_lr,fza_agm114m_1_lr,fza_agm114n_1_lr};
	};
	/////////2//////////////////////////
	class fza_agm114_2_4 : fza_agm114_16
	{
		displayName="AGM-114 (2)";
		magazines[]={fza_agm114l_2_4,fza_agm114k_2_4,fza_agm114c_2_4,fza_agm114a_2_4,fza_agm114m_2_4,fza_agm114n_2_4};
	};
	class fza_agm114_2_ul : fza_agm114_16
	{
		displayName="AGM-114 (2,L1)";
		magazines[]={fza_agm114l_2_ul,fza_agm114k_2_ul,fza_agm114c_2_ul,fza_agm114a_2_ul,fza_agm114m_2_ul,fza_agm114n_2_ul};
	};
	class fza_agm114_2_ur : fza_agm114_16
	{
		displayName="AGM-114 (2,R1)";
		magazines[]={fza_agm114l_2_ur,fza_agm114k_2_ur,fza_agm114c_2_ur,fza_agm114a_2_ur,fza_agm114m_2_ur,fza_agm114n_2_ur};
	};
	class fza_agm114_2_ll : fza_agm114_16
	{
		displayName="AGM-114 (2,L2)";
		magazines[]={fza_agm114l_2_ll,fza_agm114k_2_ll,fza_agm114c_2_ll,fza_agm114a_2_ll,fza_agm114m_2_ll,fza_agm114n_2_ll};
	};
	class fza_agm114_2_lr : fza_agm114_16
	{
		displayName="AGM-114 (2,R2)";
		magazines[]={fza_agm114l_2_lr,fza_agm114k_2_lr,fza_agm114c_2_lr,fza_agm114a_2_lr,fza_agm114m_2_lr,fza_agm114n_2_lr};
	};
	/////////3/////////////////////////////
	class fza_agm114_3_4 : fza_agm114_16
	{
		displayName="AGM-114 (3)";
		magazines[]={fza_agm114l_3_4,fza_agm114k_3_4,fza_agm114c_3_4,fza_agm114a_3_4,fza_agm114m_3_4,fza_agm114n_3_4};
	};
	class fza_agm114_3_ul : fza_agm114_16
	{
		displayName="AGM-114 (3,L1)";
		magazines[]={fza_agm114l_3_ul,fza_agm114k_3_ul,fza_agm114c_3_ul,fza_agm114a_3_ul,fza_agm114m_3_ul,fza_agm114n_3_ul};
	};
	class fza_agm114_3_ur : fza_agm114_16
	{
		displayName="AGM-114 (3,R1)";
		magazines[]={fza_agm114l_3_ur,fza_agm114k_3_ur,fza_agm114c_3_ur,fza_agm114a_3_ur,fza_agm114m_3_ur,fza_agm114n_3_ur};
	};
	class fza_agm114_3_ll : fza_agm114_16
	{
		displayName="AGM-114 (3,L2)";
		magazines[]={fza_agm114l_3_ll,fza_agm114k_3_ll,fza_agm114c_3_ll,fza_agm114a_3_ll,fza_agm114m_3_ll,fza_agm114n_3_ll};
	};
	class fza_agm114_3_lr : fza_agm114_16
	{
		displayName="AGM-114 (3,R2)";
		magazines[]={fza_agm114l_3_lr,fza_agm114k_3_lr,fza_agm114c_3_lr,fza_agm114a_3_lr,fza_agm114m_3_lr,fza_agm114n_3_lr};
	};
	/////////4//////////////////////////////
	class fza_agm114_4_4 : fza_agm114_16
	{
		displayName="AGM-114 (4)";
		magazines[]={fza_agm114l_4_4,fza_agm114k_4_4,fza_agm114c_4_4,fza_agm114a_4_4,fza_agm114m_4_4,fza_agm114n_4_4};
	};
	class fza_agm114_4_ul : fza_agm114_16
	{
		displayName="AGM-114 (4,L1)";
		magazines[]={fza_agm114l_4_ul,fza_agm114k_4_ul,fza_agm114c_4_ul,fza_agm114a_4_ul,fza_agm114m_4_ul,fza_agm114n_4_ul};
	};
	class fza_agm114_4_ur : fza_agm114_16
	{
		displayName="AGM-114 (4,R1)";
		magazines[]={fza_agm114l_4_ur,fza_agm114k_4_ur,fza_agm114c_4_ur,fza_agm114a_4_ur,fza_agm114m_4_ur,fza_agm114n_4_ur};
	};
	class fza_agm114_4_ll : fza_agm114_16
	{
		displayName="AGM-114 (4,L2)";
		magazines[]={fza_agm114l_4_ll,fza_agm114k_4_ll,fza_agm114c_4_ll,fza_agm114a_4_ll,fza_agm114m_4_ll,fza_agm114n_4_ll};
	};
	class fza_agm114_4_lr : fza_agm114_16
	{
		displayName="AGM-114 (4,R2)";
		magazines[]={fza_agm114l_4_lr,fza_agm114k_4_lr,fza_agm114c_4_lr,fza_agm114a_4_lr,fza_agm114m_4_lr,fza_agm114n_4_lr};
	};
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////ROCKETS//////////////////////////////////
	///////////////////////////////////////////////////////////////////////
	class fza_m261_76: RocketPods
	{
		scope = 1;
		displayName="M261";
		displayNameMagazine="M261";
		shortNameMagazine="M261";
		reloadTime=0.05;
		maxrange = 4000;
		maxrangeprobab = 0.1;
		midrange = 2000;
		midrangeprobab = 0.9;
		minrange = 200;
		minrangeprobab = 0.6;
		burst=1;
		magazines[]={fza_m261_m151_76};
		modes[]= {"Single"};
		cursor = "EmptyCursor";
		cursoraim = "EmptyCursor";
		cursorAimOn = "";
		ballisticscomputer = 2;
		class Single: LauncherCore
		{
			class StandardSound
            {
				weaponfire[] = {"\fza_ah64_us\audio\M275_Dist.ogg", 4.5,1,4000};
				soundBegin[] = {"weaponfire",1};
				weaponsoundeffect = "DefaultRifle";
			};
			multiplier=1;
			burst=1;
			displayName="M261";
			dispersion=0.0;
			sounds[] = {StandardSound};
			soundburst= true;
			soundContinuous= 0;
			reloadTime=0.05;
			recoil = "Empty";
			recoilProne = "Empty";
			autofire=0;
			useAction = 0;
			useActionTitle = "";
			showToPlayer = 1;
			maxrange = 4000;
			maxrangeprobab = 0.1;
			midrange = 2000;
			midrangeprobab = 0.9;
			minrange = 200;
			minrangeprobab = 0.6;
			cursor = "EmptyCursor";
			cursoraim = "EmptyCursor";
			cursorAimOn = "";
		};
	};
	////////////////14/////////////////
	class fza_m261_14: fza_m261_76
	{
		displayName="M261 (1,4)";
		magazines[]={fza_m261_m151_14_38,fza_m261_m229_14_38,fza_m261_m261_14_38,fza_m261_m255_14_38,fza_m261_m257_14_38};
	};
	class fza_m261_14_zone1: fza_m261_76
	{
		displayName="M261 A (1,4)";
		magazines[]={fza_m261_m151_14_zone1_12,fza_m261_m229_14_zone1_12,fza_m261_m261_14_zone1_12,fza_m261_m255_14_zone1_12,fza_m261_m257_14_zone1_12};
	};
	class fza_m261_14_zone2: fza_m261_76
	{
		displayName="M261 B (1,4)";
		magazines[]={fza_m261_m151_14_zone2_4,fza_m261_m229_14_zone2_4,fza_m261_m261_14_zone2_4,fza_m261_m255_14_zone2_4,fza_m261_m257_14_zone2_4};
	};
	class fza_m261_14_zone3: fza_m261_76
	{
		displayName="M261 E (1,4)";
		magazines[]={fza_m261_m151_14_zone3_3,fza_m261_m229_14_zone3_3,fza_m261_m261_14_zone3_3,fza_m261_m255_14_zone3_3,fza_m261_m257_14_zone3_3};
	};
	//////////////23///////////////////
	class fza_m261_23: fza_m261_76
	{
		displayName="M261 (2,3)";
		magazines[]={fza_m261_m151_23_38,fza_m261_m229_23_38,fza_m261_m261_23_38,fza_m261_m255_23_38,fza_m261_m257_23_38};
	};
	class fza_m261_23_zone1: fza_m261_76
	{
		magazines[]={fza_m261_m151_23_zone1_12,fza_m261_m229_23_zone1_12,fza_m261_m261_23_zone1_12,fza_m261_m255_23_zone1_12,fza_m261_m257_23_zone1_12};
	};
	class fza_m261_23_zone2: fza_m261_76
	{
		magazines[]={fza_m261_m151_23_zone2_4,fza_m261_m229_23_zone2_4,fza_m261_m261_23_zone2_4,fza_m261_m255_23_zone2_4,fza_m261_m257_23_zone2_4};
	};
	class fza_m261_23_zone3: fza_m261_76
	{
		magazines[]={fza_m261_m151_23_zone3_3,fza_m261_m229_23_zone3_3,fza_m261_m261_23_zone3_3,fza_m261_m255_23_zone3_3,fza_m261_m257_23_zone3_3};
	};
	/////////////indi///////////////
	class fza_m261_1: fza_m261_76
	{
		displayName="M261 (1)";
		magazines[]={fza_m261_m151_1_19,fza_m261_m229_1_19,fza_m261_m261_1_19,fza_m261_m255_1_19,fza_m261_m257_1_19};
	};
	class fza_m261_1_zone1: fza_m261_76
	{
		displayName="M261 A (1)";
		magazines[]={fza_m261_m151_1_zone1_12,fza_m261_m229_1_zone1_12,fza_m261_m261_1_zone1_12,fza_m261_m255_1_zone1_12,fza_m261_m257_1_zone1_12};
	};
	class fza_m261_1_zone2: fza_m261_76
	{
		displayName="M261 B (1)";
		magazines[]={fza_m261_m151_1_zone2_4,fza_m261_m229_1_zone2_4,fza_m261_m261_1_zone2_4,fza_m261_m255_1_zone2_4,fza_m261_m257_1_zone2_4};
	};
	class fza_m261_1_zone3: fza_m261_76
	{
		displayName="M261 E (1)";
		magazines[]={fza_m261_m151_1_zone3_3,fza_m261_m229_1_zone3_3,fza_m261_m261_1_zone3_3,fza_m261_m255_1_zone3_3,fza_m261_m257_1_zone3_3};
	};
	/////////////////////////////////////
	class fza_m261_2: fza_m261_76
	{
		displayName="M261 (2)";
		magazines[]={fza_m261_m151_2_19,fza_m261_m229_2_19,fza_m261_m261_2_19,fza_m261_m255_2_19,fza_m261_m257_2_19};
	};
	class fza_m261_2_zone1: fza_m261_76
	{
		displayName="M261 C (2)";
		magazines[]={fza_m261_m151_2_zone1_12,fza_m261_m229_2_zone1_12,fza_m261_m261_2_zone1_12,fza_m261_m255_2_zone1_12,fza_m261_m257_2_zone1_12};
	};
	class fza_m261_2_zone2: fza_m261_76
	{
		displayName="M261 D (2)";
		magazines[]={fza_m261_m151_2_zone2_4,fza_m261_m229_2_zone2_4,fza_m261_m261_2_zone2_4,fza_m261_m255_2_zone2_4,fza_m261_m257_2_zone2_4};
	};
	class fza_m261_2_zone3: fza_m261_76
	{
		displayName="M261 E (2)";
		magazines[]={fza_m261_m151_2_zone3_3,fza_m261_m229_2_zone3_3,fza_m261_m261_2_zone3_3,fza_m261_m255_2_zone3_3,fza_m261_m257_2_zone3_3};
	};
	///////////////////////////////////////
	class fza_m261_3: fza_m261_76
	{
		displayName="M261 (3)";
		magazines[]={fza_m261_m151_3_19,fza_m261_m229_3_19,fza_m261_m261_3_19,fza_m261_m255_3_19,fza_m261_m257_3_19};
	};
	class fza_m261_3_zone1: fza_m261_76
	{
		displayName="M261 C (3)";
		magazines[]={fza_m261_m151_3_zone1_12,fza_m261_m229_3_zone1_12,fza_m261_m261_3_zone1_12,fza_m261_m255_3_zone1_12,fza_m261_m257_3_zone1_12};
	};
	class fza_m261_3_zone2: fza_m261_76
	{
		displayName="M261 D (3)";
		magazines[]={fza_m261_m151_3_zone2_4,fza_m261_m229_3_zone2_4,fza_m261_m261_3_zone2_4,fza_m261_m255_3_zone2_4,fza_m261_m257_3_zone2_4};
	};
	class fza_m261_3_zone3: fza_m261_76
	{
		displayName="M261 E (3)";
		magazines[]={fza_m261_m151_3_zone3_3,fza_m261_m229_3_zone3_3,fza_m261_m261_3_zone3_3,fza_m261_m255_3_zone3_3,fza_m261_m257_3_zone3_3};
	};
	/////////////////////////////////////
	class fza_m261_4: fza_m261_76
	{
		displayName="M261 (4)";
		magazines[]={fza_m261_m151_4_19,fza_m261_m229_4_19,fza_m261_m261_4_19,fza_m261_m255_4_19,fza_m261_m257_4_19};
	};
	class fza_m261_4_zone1: fza_m261_76
	{
		displayName="M261 A (4)";
		magazines[]={fza_m261_m151_4_zone1_12,fza_m261_m229_4_zone1_12,fza_m261_m261_4_zone1_12,fza_m261_m255_4_zone1_12,fza_m261_m257_4_zone1_12};
	};
	class fza_m261_4_zone2: fza_m261_76
	{
		displayName="M261 B (4)";
		magazines[]={fza_m261_m151_4_zone2_4,fza_m261_m229_4_zone2_4,fza_m261_m261_4_zone2_4,fza_m261_m255_4_zone2_4,fza_m261_m257_4_zone2_4};
	};
	class fza_m261_4_zone3: fza_m261_76
	{
		displayName="M261 E (4)";
		magazines[]={fza_m261_m151_4_zone3_3,fza_m261_m229_4_zone3_3,fza_m261_m261_4_zone3_3,fza_m261_m255_4_zone3_3,fza_m261_m257_4_zone3_3};
	};
	//////////////////ZONES/////////////////
	///////1 and 4 combined zones//////
	class fza_m261_14_zoneA: fza_m261_76
	{
		displayName="M261 A (1,4)";
		magazines[]={fza_m261_m151_14_zoneA,fza_m261_m229_14_zoneA,fza_m261_m261_14_zoneA,fza_m261_m255_14_zoneA,fza_m261_m257_14_zoneA};
	};
	class fza_m261_14_zoneB: fza_m261_76
	{
		displayName="M261 B (1,4)";
		magazines[]={fza_m261_m151_14_zoneB,fza_m261_m229_14_zoneB,fza_m261_m261_14_zoneB,fza_m261_m255_14_zoneB,fza_m261_m257_14_zoneB};
	};
	class fza_m261_14_zoneE: fza_m261_76
	{
		displayName="M261 E (1,4)";
		magazines[]={fza_m261_m151_14_zoneE,fza_m261_m229_14_zoneE,fza_m261_m261_14_zoneE,fza_m261_m255_14_zoneE,fza_m261_m257_14_zoneE};
	};
	/////2 and 3 combined zones///////
	class fza_m261_23_zoneC: fza_m261_76
	{
		displayName="M261 C (2,3)";
		magazines[]={fza_m261_m151_23_zoneC,fza_m261_m229_23_zoneC,fza_m261_m261_23_zoneC,fza_m261_m255_23_zoneC,fza_m261_m257_23_zoneC};
	};
	class fza_m261_23_zoneD: fza_m261_76
	{
		displayName="M261 D (2,3)";
		magazines[]={fza_m261_m151_23_zoneD,fza_m261_m229_23_zoneD,fza_m261_m261_23_zoneD,fza_m261_m255_23_zoneD,fza_m261_m257_23_zoneD};
	};
	class fza_m261_23_zoneE: fza_m261_76
	{
		displayName="M261 E (2,3)";
		magazines[]={fza_m261_m151_23_zoneE,fza_m261_m229_23_zoneE,fza_m261_m261_23_zoneE,fza_m261_m255_23_zoneE,fza_m261_m257_23_zoneE};
	};
	/////zone E combined//////////
	class fza_m261_1234_zoneE: fza_m261_76
	{
		displayName="M261 E";
		magazines[]={fza_m261_m151_1234_zoneE,fza_m261_m229_1234_zoneE,fza_m261_m261_1234_zoneE,fza_m261_m255_1234_zoneE,fza_m261_m257_1234_zoneE};
	};
	class fza_atas_2: MissileLauncher
	{
		airateoffire = 5;
		airateoffiredistance = 2500;
		cmimmunity = 0.8;
		canlock = 0;
		cursor = "";
		cursoraim = "";
		cursorAimOn = "";
		cursorsize = 1;
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
		sounds[] = {StandardSound};
		class StandardSound
        {
			weaponfire[] = {"\fza_ah64_us\audio\fim92_oneshot1.ogg", 10, 1, 1200};
			soundBegin[] = {"weaponfire",1};
			weaponsoundeffect = "DefaultRifle";
		};
		soundfly[] = {"\ca\Sounds\weapons\cannon\rocket_fly1", 10, 1.5, 700};
		weaponlockdelay = 3;
		weaponlocksystem = 1;
		lockedtargetsound[] = {"", 1, 1};
		lockingtargetsound[] = {"", 1, 1};
	};
};
class CfgMagazines
{
	class Default {};
	class CA_Magazine: Default {};
	class VehicleMagazine: CA_Magazine {};
	class fza_m230_1200: VehicleMagazine
	{
		scope = 2;
		displayName = "30mm HEDP";
		ammo = "fza_30x113";
		count = 1200;
		initSpeed = 805;
		tracersevery = 0;
	};
	class fza_atas_2: VehicleMagazine
	{
		scope = 2;
		displayName = "FIM-92";
		count = 4;
		ammo = "fza_fim92";
		initSpeed = 150;
		sound[] = {"\ca\Weapons\Data\Sound\TOW_2",3.162278,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	class fza_agm114l_16: VehicleMagazine
	{
		scope = 2;
		displayName = "AGM-114L";
		count = 16;
		ammo = "fza_agm114l";
		initSpeed = 150;
		sound[] = {"\ca\Weapons\Data\Sound\TOW_2",3.162278,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	class fza_agm114l_23_8: fza_agm114l_16
	{
		count = 8;
	};
	class fza_agm114l_14_8: fza_agm114l_16
	{
		count = 8;
	};
	/////////////////////////pylon1/////////////////////////////////////
	class fza_agm114l_1_4: fza_agm114l_16
	{
		count = 4;
	};
	class fza_agm114l_1_ur: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_1_ul: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_1_ll: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_1_lr: fza_agm114l_16
	{
		count = 1;
	};
	/////////////////////////pylon2/////////////////////////////////////
	class fza_agm114l_2_4: fza_agm114l_16
	{
		count = 4;
	};
	class fza_agm114l_2_ur: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_2_ul: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_2_ll: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_2_lr: fza_agm114l_16
	{
		count = 1;
	};
	/////////////////////////pylon3/////////////////////////////////////
	class fza_agm114l_3_4: fza_agm114l_16
	{
		count = 4;
	};
	class fza_agm114l_3_ur: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_3_ul: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_3_ll: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_3_lr: fza_agm114l_16
	{
		count = 1;
	};
	/////////////////////////pylon4/////////////////////////////////////
	class fza_agm114l_4_4: fza_agm114l_16
	{
		count = 4;
	};
	class fza_agm114l_4_ur: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_4_ul: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_4_ll: fza_agm114l_16
	{
		count = 1;
	};
	class fza_agm114l_4_lr: fza_agm114l_16
	{
		count = 1;
	};
//////////////////////////////////////114K/////////////////////////////////////////
	class fza_agm114k_16: VehicleMagazine
	{
		scope = 2;
		displayName = "AGM-114K";
		count = 16;
		ammo = "fza_agm114k";
		initSpeed = 150;
		sound[] = {"\ca\Weapons\Data\Sound\TOW_2",3.162278,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	class fza_agm114k_23_8: fza_agm114k_16
	{
		count = 8;
	};
	class fza_agm114k_14_8: fza_agm114k_16
	{
		count = 8;
	};
	/////////////////////////pylon1/////////////////////////////////////
	class fza_agm114k_1_4: fza_agm114k_16
	{
		count = 4;
	};
	class fza_agm114k_1_ur: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_1_ul: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_1_ll: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_1_lr: fza_agm114k_16
	{
		count = 1;
	};
	/////////////////////////pylon2/////////////////////////////////////
	class fza_agm114k_2_4: fza_agm114k_16
	{
		count = 4;
	};
	class fza_agm114k_2_ur: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_2_ul: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_2_ll: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_2_lr: fza_agm114k_16
	{
		count = 1;
	};
	/////////////////////////pylon3/////////////////////////////////////
	class fza_agm114k_3_4: fza_agm114k_16
	{
		count = 4;
	};
	class fza_agm114k_3_ur: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_3_ul: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_3_ll: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_3_lr: fza_agm114k_16
	{
		count = 1;
	};
	/////////////////////////pylon4/////////////////////////////////////
	class fza_agm114k_4_4: fza_agm114k_16
	{
		count = 4;
	};
	class fza_agm114k_4_ur: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_4_ul: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_4_ll: fza_agm114k_16
	{
		count = 1;
	};
	class fza_agm114k_4_lr: fza_agm114k_16
	{
		count = 1;
	};
//////////////////////////////////////114C/////////////////////////////////////////
	class fza_agm114c_16: VehicleMagazine
	{
		scope = 2;
		displayName = "AGM-114C";
		count = 16;
		ammo = "fza_agm114c";
		initSpeed = 150;
		sound[] = {"\ca\Weapons\Data\Sound\TOW_2",3.162278,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	class fza_agm114c_23_8: fza_agm114c_16
	{
		count = 8;
	};
	class fza_agm114c_14_8: fza_agm114c_16
	{
		count = 8;
	};
	/////////////////////////pylon1/////////////////////////////////////
	class fza_agm114c_1_4: fza_agm114c_16
	{
		count = 4;
	};
	class fza_agm114c_1_ur: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_1_ul: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_1_ll: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_1_lr: fza_agm114c_16
	{
		count = 1;
	};
	/////////////////////////pylon2/////////////////////////////////////
	class fza_agm114c_2_4: fza_agm114c_16
	{
		count = 4;
	};
	class fza_agm114c_2_ur: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_2_ul: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_2_ll: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_2_lr: fza_agm114c_16
	{
		count = 1;
	};
	/////////////////////////pylon3/////////////////////////////////////
	class fza_agm114c_3_4: fza_agm114c_16
	{
		count = 4;
	};
	class fza_agm114c_3_ur: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_3_ul: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_3_ll: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_3_lr: fza_agm114c_16
	{
		count = 1;
	};
	/////////////////////////pylon4/////////////////////////////////////
	class fza_agm114c_4_4: fza_agm114c_16
	{
		count = 4;
	};
	class fza_agm114c_4_ur: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_4_ul: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_4_ll: fza_agm114c_16
	{
		count = 1;
	};
	class fza_agm114c_4_lr: fza_agm114c_16
	{
		count = 1;
	};
//////////////////////////////////////114A/////////////////////////////////////////
	class fza_agm114a_16: VehicleMagazine
	{
		scope = 2;
		displayName = "AGM-114A";
		count = 16;
		ammo = "fza_agm114a";
		initSpeed = 150;
		sound[] = {"\ca\Weapons\Data\Sound\TOW_2",3.162278,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	class fza_agm114a_23_8: fza_agm114a_16
	{
		count = 8;
	};
	class fza_agm114a_14_8: fza_agm114a_16
	{
		count = 8;
	};
	/////////////////////////pylon1/////////////////////////////////////
	class fza_agm114a_1_4: fza_agm114a_16
	{
		count = 4;
	};
	class fza_agm114a_1_ur: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_1_ul: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_1_ll: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_1_lr: fza_agm114a_16
	{
		count = 1;
	};
	/////////////////////////pylon2/////////////////////////////////////
	class fza_agm114a_2_4: fza_agm114a_16
	{
		count = 4;
	};
	class fza_agm114a_2_ur: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_2_ul: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_2_ll: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_2_lr: fza_agm114a_16
	{
		count = 1;
	};
	/////////////////////////pylon3/////////////////////////////////////
	class fza_agm114a_3_4: fza_agm114a_16
	{
		count = 4;
	};
	class fza_agm114a_3_ur: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_3_ul: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_3_ll: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_3_lr: fza_agm114a_16
	{
		count = 1;
	};
	/////////////////////////pylon4/////////////////////////////////////
	class fza_agm114a_4_4: fza_agm114a_16
	{
		count = 4;
	};
	class fza_agm114a_4_ur: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_4_ul: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_4_ll: fza_agm114a_16
	{
		count = 1;
	};
	class fza_agm114a_4_lr: fza_agm114a_16
	{
		count = 1;
	};
//////////////////////////////////////114M/////////////////////////////////////////
	class fza_agm114m_16: VehicleMagazine
	{
		scope = 2;
		displayName = "AGM-114M";
		count = 16;
		ammo = "fza_agm114m";
		initSpeed = 150;
		sound[] = {"\ca\Weapons\Data\Sound\TOW_2",3.162278,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	class fza_agm114m_23_8: fza_agm114m_16
	{
		count = 8;
	};
	class fza_agm114m_14_8: fza_agm114m_16
	{
		count = 8;
	};
	/////////////////////////pylon1/////////////////////////////////////
	class fza_agm114m_1_4: fza_agm114m_16
	{
		count = 4;
	};
	class fza_agm114m_1_ur: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_1_ul: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_1_ll: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_1_lr: fza_agm114m_16
	{
		count = 1;
	};
	/////////////////////////pylon2/////////////////////////////////////
	class fza_agm114m_2_4: fza_agm114m_16
	{
		count = 4;
	};
	class fza_agm114m_2_ur: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_2_ul: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_2_ll: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_2_lr: fza_agm114m_16
	{
		count = 1;
	};
	/////////////////////////pylon3/////////////////////////////////////
	class fza_agm114m_3_4: fza_agm114m_16
	{
		count = 4;
	};
	class fza_agm114m_3_ur: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_3_ul: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_3_ll: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_3_lr: fza_agm114m_16
	{
		count = 1;
	};
	/////////////////////////pylon4/////////////////////////////////////
	class fza_agm114m_4_4: fza_agm114m_16
	{
		count = 4;
	};
	class fza_agm114m_4_ur: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_4_ul: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_4_ll: fza_agm114m_16
	{
		count = 1;
	};
	class fza_agm114m_4_lr: fza_agm114m_16
	{
		count = 1;
	};
//////////////////////////////////////114N/////////////////////////////////////////
	class fza_agm114n_16: VehicleMagazine
	{
		scope = 2;
		displayName = "AGM-114N";
		count = 16;
		ammo = "fza_agm114n";
		initSpeed = 150;
		sound[] = {"\ca\Weapons\Data\Sound\TOW_2",3.162278,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	class fza_agm114n_23_8: fza_agm114n_16
	{
		count = 8;
	};
	class fza_agm114n_14_8: fza_agm114n_16
	{
		count = 8;
	};
	/////////////////////////pylon1/////////////////////////////////////
	class fza_agm114n_1_4: fza_agm114n_16
	{
		count = 4;
	};
	class fza_agm114n_1_ur: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_1_ul: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_1_ll: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_1_lr: fza_agm114n_16
	{
		count = 1;
	};
	/////////////////////////pylon2/////////////////////////////////////
	class fza_agm114n_2_4: fza_agm114n_16
	{
		count = 4;
	};
	class fza_agm114n_2_ur: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_2_ul: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_2_ll: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_2_lr: fza_agm114n_16
	{
		count = 1;
	};
	/////////////////////////pylon3/////////////////////////////////////
	class fza_agm114n_3_4: fza_agm114n_16
	{
		count = 4;
	};
	class fza_agm114n_3_ur: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_3_ul: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_3_ll: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_3_lr: fza_agm114n_16
	{
		count = 1;
	};
	/////////////////////////pylon4/////////////////////////////////////
	class fza_agm114n_4_4: fza_agm114n_16
	{
		count = 4;
	};
	class fza_agm114n_4_ur: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_4_ul: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_4_ll: fza_agm114n_16
	{
		count = 1;
	};
	class fza_agm114n_4_lr: fza_agm114n_16
	{
		count = 1;
	};
///////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////ROCKETS//////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
	class fza_m261_m151_76: VehicleMagazine
	{
		scope = 2;
		displayName = "M151 HE";
		ammo = "fza_275_m151";
		count = 76;
		initSpeed = 44;
		nameSound = "rockets";
		sound[] = {"\ca\Weapons\Data\Sound\rocket1",1.000000,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	////////ZONES/////
	class fza_m261_m151_14_zoneA: fza_m261_m151_76
	{
		count = 24;
	};
	class fza_m261_m151_14_zoneB: fza_m261_m151_76
	{
		count = 8;
	};
	class fza_m261_m151_23_zoneC: fza_m261_m151_76
	{
		count = 24;
	};
	class fza_m261_m151_23_zoneD: fza_m261_m151_76
	{
		count = 8;
	};
	class fza_m261_m151_14_zoneE: fza_m261_m151_76
	{
		count = 6;
	};
	class fza_m261_m151_23_zoneE: fza_m261_m151_76
	{
		count = 6;
	};
	class fza_m261_m151_1234_zoneE: fza_m261_m151_76
	{
		count = 12;
	};
	/////ZONES//////
	class fza_m261_m151_14_38: fza_m261_m151_76
	{
		count = 38;
	};
	class fza_m261_m151_14_zone1_12: fza_m261_m151_76
	{
		count = 24;
	};
	class fza_m261_m151_14_zone2_4: fza_m261_m151_76
	{
		count = 8;
	};
	class fza_m261_m151_14_zone3_3: fza_m261_m151_76
	{
		count = 6;
	};
	class fza_m261_m151_23_38: fza_m261_m151_76
	{
		count = 38;
	};
	class fza_m261_m151_23_zone1_12: fza_m261_m151_76
	{
		count = 24;
	};
	class fza_m261_m151_23_zone2_4: fza_m261_m151_76
	{
		count = 8;
	};
	class fza_m261_m151_23_zone3_3: fza_m261_m151_76
	{
		count = 6;
	};
	class fza_m261_m151_1_19: fza_m261_m151_76
	{
		count = 19;
	};
	class fza_m261_m151_1_zone1_12: fza_m261_m151_76
	{
		count = 12;
	};
	class fza_m261_m151_1_zone2_4: fza_m261_m151_76
	{
		count = 4;
	};
	class fza_m261_m151_1_zone3_3: fza_m261_m151_76
	{
		count = 3;
	};
	class fza_m261_m151_2_19: fza_m261_m151_76
	{
		count = 19;
	};
	class fza_m261_m151_2_zone1_12: fza_m261_m151_76
	{
		count = 12;
	};
	class fza_m261_m151_2_zone2_4: fza_m261_m151_76
	{
		count = 4;
	};
	class fza_m261_m151_2_zone3_3: fza_m261_m151_76
	{
		count = 3;
	};
	class fza_m261_m151_3_19: fza_m261_m151_76
	{
		count = 19;
	};
	class fza_m261_m151_3_zone1_12: fza_m261_m151_76
	{
		count = 12;
	};
	class fza_m261_m151_3_zone2_4: fza_m261_m151_76
	{
		count = 4;
	};
	class fza_m261_m151_3_zone3_3: fza_m261_m151_76
	{
		count = 3;
	};
	class fza_m261_m151_4_19: fza_m261_m151_76
	{
		count = 19;
	};
	class fza_m261_m151_4_zone1_12: fza_m261_m151_76
	{
		count = 12;
	};
	class fza_m261_m151_4_zone2_4: fza_m261_m151_76
	{
		count = 4;
	};
	class fza_m261_m151_4_zone3_3: fza_m261_m151_76
	{
		count = 3;
	};
////////////////////////////////////////////////////////////////////////
////////////////M229////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
	class fza_m261_m229_76: VehicleMagazine
	{
		scope = 2;
		displayName = "M229 HE";
		ammo = "fza_275_m229";
		count = 76;
		initSpeed = 44;
		nameSound = "rockets";
		sound[] = {"\ca\Weapons\Data\Sound\rocket1",1.000000,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	////////ZONES/////
	class fza_m261_m229_14_zoneA: fza_m261_m229_76
	{
		count = 24;
	};
	class fza_m261_m229_14_zoneB: fza_m261_m229_76
	{
		count = 8;
	};
	class fza_m261_m229_23_zoneC: fza_m261_m229_76
	{
		count = 24;
	};
	class fza_m261_m229_23_zoneD: fza_m261_m229_76
	{
		count = 8;
	};
	class fza_m261_m229_14_zoneE: fza_m261_m229_76
	{
		count = 6;
	};
	class fza_m261_m229_23_zoneE: fza_m261_m229_76
	{
		count = 6;
	};
	class fza_m261_m229_1234_zoneE: fza_m261_m229_76
	{
		count = 12;
	};
	/////ZONES//////
	class fza_m261_m229_14_38: fza_m261_m229_76
	{
		count = 38;
	};
	class fza_m261_m229_14_zone1_12: fza_m261_m229_76
	{
		count = 24;
	};
	class fza_m261_m229_14_zone2_4: fza_m261_m229_76
	{
		count = 8;
	};
	class fza_m261_m229_14_zone3_3: fza_m261_m229_76
	{
		count = 6;
	};
	class fza_m261_m229_23_38: fza_m261_m229_76
	{
		count = 38;
	};
	class fza_m261_m229_23_zone1_12: fza_m261_m229_76
	{
		count = 24;
	};
	class fza_m261_m229_23_zone2_4: fza_m261_m229_76
	{
		count = 8;
	};
	class fza_m261_m229_23_zone3_3: fza_m261_m229_76
	{
		count = 6;
	};
	class fza_m261_m229_1_19: fza_m261_m229_76
	{
		count = 19;
	};
	class fza_m261_m229_1_zone1_12: fza_m261_m229_76
	{
		count = 12;
	};
	class fza_m261_m229_1_zone2_4: fza_m261_m229_76
	{
		count = 4;
	};
	class fza_m261_m229_1_zone3_3: fza_m261_m229_76
	{
		count = 3;
	};
	class fza_m261_m229_2_19: fza_m261_m229_76
	{
		count = 19;
	};
	class fza_m261_m229_2_zone1_12: fza_m261_m229_76
	{
		count = 12;
	};
	class fza_m261_m229_2_zone2_4: fza_m261_m229_76
	{
		count = 4;
	};
	class fza_m261_m229_2_zone3_3: fza_m261_m229_76
	{
		count = 3;
	};
	class fza_m261_m229_3_19: fza_m261_m229_76
	{
		count = 19;
	};
	class fza_m261_m229_3_zone1_12: fza_m261_m229_76
	{
		count = 12;
	};
	class fza_m261_m229_3_zone2_4: fza_m261_m229_76
	{
		count = 4;
	};
	class fza_m261_m229_3_zone3_3: fza_m261_m229_76
	{
		count = 3;
	};
	class fza_m261_m229_4_19: fza_m261_m229_76
	{
		count = 19;
	};
	class fza_m261_m229_4_zone1_12: fza_m261_m229_76
	{
		count = 12;
	};
	class fza_m261_m229_4_zone2_4: fza_m261_m229_76
	{
		count = 4;
	};
	class fza_m261_m229_4_zone3_3: fza_m261_m229_76
	{
		count = 3;
	};
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////m255////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
	class fza_m261_m255_76: VehicleMagazine
	{
		scope = 2;
		displayName = "M255 FLEC";
		ammo = "fza_275_m255";
		count = 76;
		initSpeed = 44;
		nameSound = "rockets";
		sound[] = {"\ca\Weapons\Data\Sound\rocket1",1.000000,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	////////ZONES/////
	class fza_m261_m255_14_zoneA: fza_m261_m255_76
	{
		count = 24;
	};
	class fza_m261_m255_14_zoneB: fza_m261_m255_76
	{
		count = 8;
	};
	class fza_m261_m255_23_zoneC: fza_m261_m255_76
	{
		count = 24;
	};
	class fza_m261_m255_23_zoneD: fza_m261_m255_76
	{
		count = 8;
	};
	class fza_m261_m255_14_zoneE: fza_m261_m255_76
	{
		count = 6;
	};
	class fza_m261_m255_23_zoneE: fza_m261_m255_76
	{
		count = 6;
	};
	class fza_m261_m255_1234_zoneE: fza_m261_m255_76
	{
		count = 12;
	};
	/////ZONES//////
	class fza_m261_m255_14_38: fza_m261_m255_76
	{
		count = 38;
	};
	class fza_m261_m255_14_zone1_12: fza_m261_m255_76
	{
		count = 24;
	};
	class fza_m261_m255_14_zone2_4: fza_m261_m255_76
	{
		count = 8;
	};
	class fza_m261_m255_14_zone3_3: fza_m261_m255_76
	{
		count = 6;
	};
	class fza_m261_m255_23_38: fza_m261_m255_76
	{
		count = 38;
	};
	class fza_m261_m255_23_zone1_12: fza_m261_m255_76
	{
		count = 24;
	};
	class fza_m261_m255_23_zone2_4: fza_m261_m255_76
	{
		count = 8;
	};
	class fza_m261_m255_23_zone3_3: fza_m261_m255_76
	{
		count = 6;
	};
	class fza_m261_m255_1_19: fza_m261_m255_76
	{
		count = 19;
	};
	class fza_m261_m255_1_zone1_12: fza_m261_m255_76
	{
		count = 12;
	};
	class fza_m261_m255_1_zone2_4: fza_m261_m255_76
	{
		count = 4;
	};
	class fza_m261_m255_1_zone3_3: fza_m261_m255_76
	{
		count = 3;
	};
	class fza_m261_m255_2_19: fza_m261_m255_76
	{
		count = 19;
	};
	class fza_m261_m255_2_zone1_12: fza_m261_m255_76
	{
		count = 12;
	};
	class fza_m261_m255_2_zone2_4: fza_m261_m255_76
	{
		count = 4;
	};
	class fza_m261_m255_2_zone3_3: fza_m261_m255_76
	{
		count = 3;
	};
	class fza_m261_m255_3_19: fza_m261_m255_76
	{
		count = 19;
	};
	class fza_m261_m255_3_zone1_12: fza_m261_m255_76
	{
		count = 12;
	};
	class fza_m261_m255_3_zone2_4: fza_m261_m255_76
	{
		count = 4;
	};
	class fza_m261_m255_3_zone3_3: fza_m261_m255_76
	{
		count = 3;
	};
	class fza_m261_m255_4_19: fza_m261_m255_76
	{
		count = 19;
	};
	class fza_m261_m255_4_zone1_12: fza_m261_m255_76
	{
		count = 12;
	};
	class fza_m261_m255_4_zone2_4: fza_m261_m255_76
	{
		count = 4;
	};
	class fza_m261_m255_4_zone3_3: fza_m261_m255_76
	{
		count = 3;
	};
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////m261////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
	class fza_m261_m261_76: VehicleMagazine
	{
		scope = 2;
		displayName = "M261 MPSM";
		ammo = "fza_275_m261";
		count = 76;
		initSpeed = 44;
		nameSound = "rockets";
		sound[] = {"\ca\Weapons\Data\Sound\rocket1",1.000000,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	////////ZONES/////
	class fza_m261_m261_14_zoneA: fza_m261_m261_76
	{
		count = 24;
	};
	class fza_m261_m261_14_zoneB: fza_m261_m261_76
	{
		count = 8;
	};
	class fza_m261_m261_23_zoneC: fza_m261_m261_76
	{
		count = 24;
	};
	class fza_m261_m261_23_zoneD: fza_m261_m261_76
	{
		count = 8;
	};
	class fza_m261_m261_14_zoneE: fza_m261_m261_76
	{
		count = 6;
	};
	class fza_m261_m261_23_zoneE: fza_m261_m261_76
	{
		count = 6;
	};
	class fza_m261_m261_1234_zoneE: fza_m261_m261_76
	{
		count = 12;
	};
	/////ZONES//////
	class fza_m261_m261_14_38: fza_m261_m261_76
	{
		count = 38;
	};
	class fza_m261_m261_14_zone1_12: fza_m261_m261_76
	{
		count = 24;
	};
	class fza_m261_m261_14_zone2_4: fza_m261_m261_76
	{
		count = 8;
	};
	class fza_m261_m261_14_zone3_3: fza_m261_m261_76
	{
		count = 6;
	};
	class fza_m261_m261_23_38: fza_m261_m261_76
	{
		count = 38;
	};
	class fza_m261_m261_23_zone1_12: fza_m261_m261_76
	{
		count = 24;
	};
	class fza_m261_m261_23_zone2_4: fza_m261_m261_76
	{
		count = 8;
	};
	class fza_m261_m261_23_zone3_3: fza_m261_m261_76
	{
		count = 6;
	};
	class fza_m261_m261_1_19: fza_m261_m261_76
	{
		count = 19;
	};
	class fza_m261_m261_1_zone1_12: fza_m261_m261_76
	{
		count = 12;
	};
	class fza_m261_m261_1_zone2_4: fza_m261_m261_76
	{
		count = 4;
	};
	class fza_m261_m261_1_zone3_3: fza_m261_m261_76
	{
		count = 3;
	};
	class fza_m261_m261_2_19: fza_m261_m261_76
	{
		count = 19;
	};
	class fza_m261_m261_2_zone1_12: fza_m261_m261_76
	{
		count = 12;
	};
	class fza_m261_m261_2_zone2_4: fza_m261_m261_76
	{
		count = 4;
	};
	class fza_m261_m261_2_zone3_3: fza_m261_m261_76
	{
		count = 3;
	};
	class fza_m261_m261_3_19: fza_m261_m261_76
	{
		count = 19;
	};
	class fza_m261_m261_3_zone1_12: fza_m261_m261_76
	{
		count = 12;
	};
	class fza_m261_m261_3_zone2_4: fza_m261_m261_76
	{
		count = 4;
	};
	class fza_m261_m261_3_zone3_3: fza_m261_m261_76
	{
		count = 3;
	};
	class fza_m261_m261_4_19: fza_m261_m261_76
	{
		count = 19;
	};
	class fza_m261_m261_4_zone1_12: fza_m261_m261_76
	{
		count = 12;
	};
	class fza_m261_m261_4_zone2_4: fza_m261_m261_76
	{
		count = 4;
	};
	class fza_m261_m261_4_zone3_3: fza_m261_m261_76
	{
		count = 3;
	};
////////////////////////////////////////////////////////////////////////
///////////////////////////////M257/////////////////////////////////////
////////////////////////////////////////////////////////////////////////
	class fza_m261_m257_76: VehicleMagazine
	{
		scope = 2;
		displayName = "M257 ILLUM";
		ammo = "fza_275_m257";
		count = 76;
		initSpeed = 44;
		nameSound = "rockets";
		sound[] = {"\ca\Weapons\Data\Sound\rocket1",1.000000,1};
		reloadSound[] = {"\ca\Weapons\Data\Sound\missload",0.000316,1};
	};
	////////ZONES/////
	class fza_m261_m257_14_zoneA: fza_m261_m257_76
	{
		count = 24;
	};
	class fza_m261_m257_14_zoneB: fza_m261_m257_76
	{
		count = 8;
	};
	class fza_m261_m257_23_zoneC: fza_m261_m257_76
	{
		count = 24;
	};
	class fza_m261_m257_23_zoneD: fza_m261_m257_76
	{
		count = 8;
	};
	class fza_m261_m257_14_zoneE: fza_m261_m257_76
	{
		count = 6;
	};
	class fza_m261_m257_23_zoneE: fza_m261_m257_76
	{
		count = 6;
	};
	class fza_m261_m257_1234_zoneE: fza_m261_m257_76
	{
		count = 12;
	};
	/////ZONES//////
	class fza_m261_m257_14_38: fza_m261_m257_76
	{
		count = 38;
	};
	class fza_m261_m257_14_zone1_12: fza_m261_m257_76
	{
		count = 24;
	};
	class fza_m261_m257_14_zone2_4: fza_m261_m257_76
	{
		count = 8;
	};
	class fza_m261_m257_14_zone3_3: fza_m261_m257_76
	{
		count = 6;
	};
	class fza_m261_m257_23_38: fza_m261_m257_76
	{
		count = 38;
	};
	class fza_m261_m257_23_zone1_12: fza_m261_m257_76
	{
		count = 24;
	};
	class fza_m261_m257_23_zone2_4: fza_m261_m257_76
	{
		count = 8;
	};
	class fza_m261_m257_23_zone3_3: fza_m261_m257_76
	{
		count = 6;
	};
	class fza_m261_m257_1_19: fza_m261_m257_76
	{
		count = 19;
	};
	class fza_m261_m257_1_zone1_12: fza_m261_m257_76
	{
		count = 12;
	};
	class fza_m261_m257_1_zone2_4: fza_m261_m257_76
	{
		count = 4;
	};
	class fza_m261_m257_1_zone3_3: fza_m261_m257_76
	{
		count = 3;
	};
	class fza_m261_m257_2_19: fza_m261_m257_76
	{
		count = 19;
	};
	class fza_m261_m257_2_zone1_12: fza_m261_m257_76
	{
		count = 12;
	};
	class fza_m261_m257_2_zone2_4: fza_m261_m257_76
	{
		count = 4;
	};
	class fza_m261_m257_2_zone3_3: fza_m261_m257_76
	{
		count = 3;
	};
	class fza_m261_m257_3_19: fza_m261_m257_76
	{
		count = 19;
	};
	class fza_m261_m257_3_zone1_12: fza_m261_m257_76
	{
		count = 12;
	};
	class fza_m261_m257_3_zone2_4: fza_m261_m257_76
	{
		count = 4;
	};
	class fza_m261_m257_3_zone3_3: fza_m261_m257_76
	{
		count = 3;
	};
	class fza_m261_m257_4_19: fza_m261_m257_76
	{
		count = 19;
	};
	class fza_m261_m257_4_zone1_12: fza_m261_m257_76
	{
		count = 12;
	};
	class fza_m261_m257_4_zone2_4: fza_m261_m257_76
	{
		count = 4;
	};
	class fza_m261_m257_4_zone3_3: fza_m261_m257_76
	{
		count = 3;
	};
////////////////////////////////////////////////////////////////////////
//////////////////////////////FUEL TANKS////////////////////////////////
////////////////////////////////////////////////////////////////////////
	class fza_iafs_100: VehicleMagazine
	{
		scope = 2;
		displayName = "IAFS 100gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_iafs_130: VehicleMagazine
	{
		scope = 2;
		displayName = "IAFS 130gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_auxtank_230_1: VehicleMagazine
	{
		scope = 2;
		displayName = "Wing Aux 230gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_auxtank_230_2: VehicleMagazine
	{
		scope = 2;
		displayName = "Wing Aux 230gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_auxtank_230_3: VehicleMagazine
	{
		scope = 2;
		displayName = "Wing Aux 230gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_auxtank_230_4: VehicleMagazine
	{
		scope = 2;
		displayName = "Wing Aux 230gal";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
///////////////////////////////////////////////////////////////////////////
///////////////////////////DAMAGE//////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
	class fza_ah64_tailrotor_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "TAIL ROTOR DGRD";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_tailrotor_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "TAIL ROTOR FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_rotor_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "MAIN ROTOR DGRD";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_rotor_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "MAIN ROTOR FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_tads_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "TADS DGRD";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_tads_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "TADS FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_pnvs_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "PNVS FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_gun_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "GUN FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_gun_jam: VehicleMagazine
	{
		scope = 2;
		displayName = "GUN JAM";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_trans_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "TRANS DGRD";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_trans_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "TRANS FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e1_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "ENG1 DAM";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e1_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "ENG1 FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e2_dam: VehicleMagazine
	{
		scope = 2;
		displayName = "ENG2 DAM";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e2_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "ENG2 FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_fwd_leak: VehicleMagazine
	{
		scope = 2;
		displayName = "FWD LEAK";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_aft_leak: VehicleMagazine
	{
		scope = 2;
		displayName = "AFT LEAK";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_fcr_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "FCR FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_rdp_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "RDP FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_ldp_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "LDP FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_rwp_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "RWP FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_lwp_fail: VehicleMagazine
	{
		scope = 2;
		displayName = "LWP FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_apu_fire: VehicleMagazine
	{
		scope = 2;
		displayName = "APU FIRE";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e1_fire: VehicleMagazine
	{
		scope = 2;
		displayName = "E1 FIRE";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_e2_fire: VehicleMagazine
	{
		scope = 2;
		displayName = "E2 FIRE";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_irjamfail: VehicleMagazine
	{
		scope = 2;
		displayName = "IRJAM FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_rfjamfail: VehicleMagazine
	{
		scope = 2;
		displayName = "RFJAM FAIL";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_firepdisch: VehicleMagazine
	{
		scope = 2;
		displayName = "FIREP DISCH";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
	class fza_ah64_firerdisch: VehicleMagazine
	{
		scope = 2;
		displayName = "FIRER DISCH";
		ammo = "fza_30x113";
		count = 1;
		initSpeed = 850;
		tracersevery = 0;
	};
/////////////////////////////////////////////////
/////////////////////LIGHT///////////////////////
/////////////////////////////////////////////////
	class fza_ah64_dam_fuse: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LFUSE";
	};
	class fza_ah64_dam_nose: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "NOSE";
	};
	class fza_ah64_dam_leng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LENG";
	};
	class fza_ah64_dam_reng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RENG";
	};
	class fza_ah64_dam_lfab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LFAB";
	};
	class fza_ah64_dam_rfab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RFAB";
	};
	class fza_ah64_dam_lwing: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LWING";
	};
	class fza_ah64_dam_rwing: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RWING";
	};
	class fza_ah64_dam_tailboom: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "TAILBOOM";
	};
	class fza_ah64_dam_vtail: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "VTAIL";
	};
	class fza_ah64_dam_hstab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "HSTAB";
	};
	class fza_ah64_dam_pylon1: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON1";
	};
	class fza_ah64_dam_pylon2: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON2";
	};
	class fza_ah64_dam_pylon3: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON3";
	};
	class fza_ah64_dam_pylon4: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON4";
	};
	class fza_ah64_dam_tr: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "TR";
	};
	class fza_ah64_dam_rtr: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RTR";
	};
/////////////////////////////////////////////////
/////////////////////MEDIUM//////////////////////
/////////////////////////////////////////////////
	class fza_ah64_mdam_fuse: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "FUSE";
	};
	class fza_ah64_mdam_nose: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "NOSE";
	};
	class fza_ah64_mdam_leng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LENG";
	};
	class fza_ah64_mdam_reng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RENG";
	};
	class fza_ah64_mdam_lfab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LFAB";
	};
	class fza_ah64_mdam_rfab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RFAB";
	};
	class fza_ah64_mdam_lwing: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "LWING";
	};
	class fza_ah64_mdam_rwing: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RWING";
	};
	class fza_ah64_mdam_tailboom: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "TAILBOOM";
	};
	class fza_ah64_mdam_vtail: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "VTAIL";
	};
	class fza_ah64_mdam_hstab: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "HSTAB";
	};
	class fza_ah64_mdam_pylon1: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON1";
	};
	class fza_ah64_mdam_pylon2: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON2";
	};
	class fza_ah64_mdam_pylon3: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON3";
	};
	class fza_ah64_mdam_pylon4: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "PYLON4";
	};
/////////////////////////////////////////////////
/////////////////////HEAVY///////////////////////
/////////////////////////////////////////////////
	class fza_ah64_hdam_reng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RENG";
	};
	class fza_ah64_hdam_leng: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "RENG";
	};
//////////////////////////////////////////////////////////
/////////CATASTROPHIC DAMAGE//////////////////////////////
//////////////////////////////////////////////////////////
	class fza_ah64_cdam_tailboom: fza_ah64_fcr_fail
	{
		scope = 2;
		displayName = "TAILBOOM";
	};
};
class CfgVehicles 
{
	class All;
	class AllVehicles : All
	{
		class NewTurret;
	};
	class Air : AllVehicles {};
	class Helicopter_Base_F : Air 
	{
		//class RotorLibHelicopterProperties;
	};
	class fza_ah64base: Helicopter_Base_F 
	{
		side=1;
		scope=0;
		displayName="AH-64D";
		driverlefthandanimname = "p_collective";
		driverleftleganimname = "pedalL";
		driverrighthandanimname = "p_cyclic";
		driverrightleganimname = "pedalR";
		simulation=helicopterRTD;
		startDuration=80;
		mainBladeRadius = 7.3;
		maxGForce = 9;
		maxFordingDepth = 0.55;
		liftForceCoef = 1.0;	
		bodyFrictionCoef = 1.0;	
		cyclicAsideForceCoef = 1.0;
		cyclicForwardForceCoef = 1.0;
		backRotorForceCoef = 1.0;
		driveOnComponent[] = {"Wheels"};
		extCameraPosition[] = {0,0,-20};
		radartype = 4;
		radarTargetSize = 0.700000;
		irTargetSize = 0.800000;		
		//TKOH ENTRIES//
		enableCopilot = true;
		usePreciseGetInAction = 1;
		preciseGetInOut = 1;
		getInRadius = 1.500000;
		//getInAction = "pilot_Heli_Light_02_Enter"; //pilot_Heli_Light_03_Enter
		getInAction = "pilot_Heli_Light_02_Enter";
		getOutAction = "GetOutHigh"; //pilot_Heli_Light_03_Exit
		cargoGetInAction[] = {"GetInHigh","GetInHigh"};
		cargoGetOutAction[] = {"GetOutHigh","GetOutHigh"};
		//TKOH END//
		_mainbladecenter = "rotor_center";
		mainbladecenter = "rotor_center";
		fuelCapacity = 1423;
		fuelconsumptionrate = 0.138;
		transportMaxWeapons = 3;
		transportMaxMagazines = 10;
		maxSpeed = 298;
		driverCanSee = 2+4+8;
		gunnerCanSee = 2+4+8;
		unitinfotype="RscUnitInfoNoHUD";
		destrtype = "DestructWreck";
		//RscUnitInfoSoldier
		hideUnitInfo = 0;
		insideSoundCoef = 0.5;
		occludeSoundsWhenIn = 0.562341;
		obstructSoundsWhenIn = 0.316228;
		attenuationEffectType = "HeliAttenuation";
		emptySound[] = {"", 0, 1};
		soundGeneralCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_1", 1.000000, 1, 10};
		soundGeneralCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_2", 1.000000, 1, 10};
		soundGeneralCollision3[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_3", 1.000000, 1, 10};
		soundCrashes[] = {"soundGeneralCollision1", 0.330000, "soundGeneralCollision2", 0.330000, "soundGeneralCollision3", 0.330000};
		soundLandCrashes[] = {"emptySound", 0};
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
		soundDammage[] = {"\fza_ah64_US\audio\helibasiccrash.ogg", 3.162278, 1, 10};
		soundgetin[] = {"A3\Sounds_F\vehicles\air\noises\heli_get_in2",1,1,1};
		soundgetout[] = {"A3\Sounds_F\vehicles\air\noises\heli_get_out2",1,1,1};
		soundEngineOffExt[] = {"fza_ah64_us\audio\Ext_Off.ogg",2,0.6,600};
		soundEngineOffInt[] = {"fza_ah64_us\audio\Int_Off.ogg",1,0.8};
		soundEngineOnExt[] = {"fza_ah64_us\audio\Ext_Start.ogg",1,0.6,600};
		soundEngineOnInt[] = {"fza_ah64_us\audio\Int_Start.ogg",0.33,0.6};
		rotorDamageInt[] = {"\fza_ah64_US\audio\heli_damage_rotor_int.ogg", 1.000000, 1.000000};
		rotorDamageOut[] = {"\fza_ah64_US\audio\heli_damage_rotor_ext.ogg", 2.511886, 1.000000, 10};
		rotorDamage[] = {"rotorDamageInt", "rotorDamageOut"};
		tailDamageInt[] = {"\fza_ah64_US\audio\heli_damage_tail.ogg", 1.000000, 1.000000};
		tailDamageOut[] = {"\fza_ah64_US\audio\heli_damage_tail.ogg", 1.000000, 1.000000, 10};
		tailDamage[] = {"tailDamageInt", "tailDamageOut"};
		landingSoundInt0[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_int1_open", 1.000000, 1.000000, 10};
		landingSoundInt1[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_int1_open", 1.000000, 1.000000, 10};
		landingSoundInt[] = {"landingSoundInt0", 0.500000, "landingSoundInt1", 0.500000};
		landingSoundOut0[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_ext1", 1.778279, 1.000000, 10};
		landingSoundOut1[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_ext1", 1.778279, 1.000000, 10};
		landingSoundOut[] = {"landingSoundOut0", 0.500000, "landingSoundOut1", 0.500000};
		soundenviron[] = {"", 1, 1};
		author="Franze, Nodunit, Sacha 'Voodoo' Oropeza & Community";
		/*class RotorLibHelicopterProperties //Keplager's RTD
		{
            autoHoverCorrection[]={3,2.45,0};
            defaultCollective=0.625;
            retreatBladeStallWarningSpeed=85.556;
            maxTorque=1600;
            stressDamagePerSec=0.0033333332;
            maxHorizontalStabilizerLeftStress=10000;
            maxHorizontalStabilizerRightStress=10000;
            maxVerticalStabilizerStress=10000;
            horizontalWingsAngleCollMin=0;
            horizontalWingsAngleCollMax=0;
            maxMainRotorStress=200000;
            maxTailRotorStress=60000;
			RTDconfig = "fza_ah64_controls\tkoh\RTD_AH64.xml";
		};*/
		class RotorLibHelicopterProperties //Voodoo's RTD
		{
			autoHoverCorrection[] = {-0.4,2.75,0};
			defaultCollective = 0.675;
			horizontalWingsAngleCollMax = 0;
			horizontalWingsAngleCollMin = 0;
			maxHorizontalStabilizerLeftStress = 100000;
			maxHorizontalStabilizerRightStress = 100000;
			maxMainRotorStress = 150000;
			maxTailRotorStress = 30000;
			maxTorque = 4800;
			stressDamagePerSec = 0.003333;
			maxVerticalStabilizerStress = 100000;
			retreatBladeStallWarningSpeed = 92.778;
			RTDconfig = "fza_ah64_controls\tkoh\fza_ah64d_blockii_exp.xml";
		};
		/*class RotorLibHelicopterProperties //Cleaned Out Franze's RTD + Voodoo's fixed Hover
		{
			//autoHoverCorrection[] = {-0.1,5.3,0};
			autoHoverCorrection[] = {-0.4,2.75,0};
			defaultCollective = 0.675;
			horizontalWingsAngleCollMax = 0;
			horizontalWingsAngleCollMin = 0;
			maxHorizontalStabilizerLeftStress = 100000;
			maxHorizontalStabilizerRightStress = 100000;
			maxMainRotorStress = 300000;
			maxTailRotorStress = 25000;
			maxTorque = 5260;
			stressDamagePerSec	= 0.0033333332666667;
			maxVerticalStabilizerStress = 100000;
			retreatBladeStallWarningSpeed = 101.346;
			rtd_center = "rtd_center";
			RTDconfig = "fza_ah64_controls\tkoh\fza_ah64d_blockii.xml";
		};*/
		class RenderTargets
		{
				class cockpitmirror1
				{
					renderTarget = "fza_ah64_cpitmirror1";
					class View01
					{
						pointPosition = "mirror_cpit1";
						pointDirection = "mirror_cpit2";
						renderQuality = 1;
						renderVisionMode = 4;
						fov = 0.5;
					};
				};
				class driverpnvs1
				{
					renderTarget = "fza_ah64_pnvscam1";
					class View01
					{
						pointPosition = "driverview";
						pointDirection = "driverview_dir";
						renderQuality = 0;
						renderVisionMode = 2;
						fov = 0.18;
					};
				};
				class driverpnvs2
				{
					renderTarget = "fza_ah64_pnvscam2";
					class View01
					{
						pointPosition = "driverview";
						pointDirection = "driverview_dir";
						renderQuality = 0;
						renderVisionMode = 0;
						fov = 0.18;
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
						renderVisionMode = 1;
						fov = 0.18;
					};
				};
									/*
					//these sources are inefficient and difficult to work with//
					//TADS/FLIR//
					class gunnertads1
					{
						renderTarget = "fza_ah64_tadscam1";
						class View01
						{
							pointPosition = "gunnerview";
							pointDirection = "gunnerview_dir";
							renderQuality = 0;
							renderVisionMode = 2;
							fov = 0.05;
						};
					};
					class gunnertads2
					{
						renderTarget = "fza_ah64_tadscam2";
						class View01
						{
							pointPosition = "gunnerview";
							pointDirection = "gunnerview_dir";
							renderQuality = 0;
							renderVisionMode = 2;
							fov = 0.1;
						};
					};
					class gunnertads3
					{
						renderTarget = "fza_ah64_tadscam3";
						class View01
						{
							pointPosition = "gunnerview";
							pointDirection = "gunnerview_dir";
							renderQuality = 0;
							renderVisionMode = 2;
							fov = 0.01;
						};
					};
					//TADS/DTV//
					class gunnertads4
					{
						renderTarget = "fza_ah64_tadscam4";
						class View01
						{
							pointPosition = "gunnerview";
							pointDirection = "gunnerview_dir";
							renderQuality = 0;
							renderVisionMode = 0;
							fov = 0.6;
						};
					};
					class gunnertads5
					{
						renderTarget = "fza_ah64_tadscam5";
						class View01
						{
							pointPosition = "gunnerview";
							pointDirection = "gunnerview_dir";
							renderQuality = 0;
							renderVisionMode = 0;
							fov = 0.1;
						};
					};
					class gunnertads6
					{
						renderTarget = "fza_ah64_tadscam6";
						class View01
						{
							pointPosition = "gunnerview";
							pointDirection = "gunnerview_dir";
							renderQuality = 0;
							renderVisionMode = 0;
							fov = 0.01;
						};
					};
					*/
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
				///GENERIC FLIP SOUNDS///
				/*class fza_ah64_button_click1
				{
		name = "fza_ah64_button_click1";
		sound[] = {"\fza_ah64_us\audio\button_click1.ogg",1,1};
		frequency = 1;
		volume = 1;
				};
				class fza_ah64_button_click2
				{
		name = "fza_ah64_button_click2";
		sound[] = {"\fza_ah64_us\audio\button_click2.ogg",1,1};
		frequency = 1;
		volume = 1;
				};
				class fza_ah64_switch_flip1
				{
		name = "fza_ah64_switch_flip1";
		sound[] = {"\fza_ah64_us\audio\switch_flip1.ogg",1,1};
		frequency = 1;
		volume = 1;
				};*/
				///END OF GENERIC FLIP SOUNDS///
				
				///ENGINE & APU START FIRST PERSON///
				/*class APUStartExt 
				{
					name = "fza_ah64_apustart1";
					sound[] = {"fza_ah64_us\audio\Ext_Start.ogg", 1,1,200};
					volume = "engineOn";
					frequency = "(0.66 + rotorSpeed)/3";
				};
				class EngineStartExt 
				{
					name = "fza_ah64_estart1";
					sound[] = {"fza_ah64_us\audio\ah64_estart1.ogg", 1,1,200};
					volume = "engineOn";
					frequency = "(0.66 + rotorSpeed)/3";
				};*/
				///ENGINE & APU START FIRST PERSON END///
				class EngineExt 
				{
					sound[] = {"\fza_ah64_us\audio\ah64_engine1.ogg", 1, 1.000000, 500};
					frequency = "rotorSpeed";
					volume = "camPos*((rotorSpeed-0.10)*4)";
				};
				class RotorExt 
				{
					sound[] = {"\fza_ah64_us\audio\ah64_rotor_ext1.ogg", 1.5, 1.000000, 500};
					frequency = "rotorSpeed * (1 - rotorThrust/5)";
					volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				/*class RotorSwist //WIP
				{
				frequency = 1;
				sound[] = {"bwa3_air\sounds\Heli_Attack_01\swist.wav",1,1,300};
				volume = "camPos * (rotorThrust factor [0.7, 0.9])";
				};*/
				class TailRotor
				{
					cone[] = {3, 1.57, 3, 1.57};
					frequency = "rotorSpeed";
					sound[] = {"\fza_ah64_US\audio\ah64_trotor_ext1.ogg", 1.5, 1, 500};
					volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
				};
				class Distance 
				{
					frequency = "rotorSpeed";
					sound[]  = {"\fza_ah64_US\audio\Engine_Far.ogg", 1, 1, 1100};
					volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
				};
				class FarDistance 
				{
					frequency = "rotorSpeed";
					sound[]  = {"\fza_ah64_US\audio\Rotor_Far.ogg", 1, 1, 4000};
					volume = "camPos * 3* (rotorSpeed factor [0.6, 1]) * (1 + rotorThrust)";
				};
				class EngineInt 
				{
					sound[] = {"\fza_ah64_us\audio\ah64_engine_int1.ogg", 1, 1.000000};
					frequency = "rotorSpeed";
					volume = "(1-camPos)*((rotorSpeed-0.75)*4)";
				};
				class RotorInt 
				{
					sound[] = {"\fza_ah64_us\audio\ah64_rotor_int1.ogg", 1, 1.000000};
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
					sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm.ogg", 0.316228, 1.000000};
					frequency = 1;
					volume = "engineOn * (1 - camPos) * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0.0, 0.001])";
				};
				class damageAlarmExt 
				{
					sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm.ogg", 0.223872, 1.000000, 20};
					frequency = 1;
					volume = "engineOn * camPos * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0, 0.001])";
				};
				class rotorLowAlarmInt 
				{
					sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm_low.ogg", 0.316228, 1.000000};
					frequency = 1;
					volume = "engineOn * (1 - camPos) * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
				};
				class rotorLowAlarmExt 
				{
					sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm_low.ogg", 0.223872, 1.000000, 20};
					frequency = 1;
					volume = "engineOn * camPos * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
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
					sound[] = {"\fza_ah64_us\audio\rain1_ext.ogg", 1.000000, 1.000000, 100};
					frequency = 1;
					volume = "camPos * (rain - rotorSpeed/2) * 2";
				};
				class RainInt 
				{
					sound[] = {"\fza_ah64_us\audio\rain1_int_open.ogg", 1.000000, 1.000000, 100};
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
				class SoundEvents {};
				class Sounds 
				{
					class EngineExt 
					{
						sound[] = {"\fza_ah64_US\audio\ah64_engine1.ogg", 1, 1.000000, 1100};
						frequency = "rotorSpeed";
						volume = "camPos*((rotorSpeed-0.10)*4)";
					};
					class RotorExt 
					{
						sound[] = {"\fza_ah64_US\audio\ah64_rotor_ext1.ogg", 3, 1.000000, 1100};
						frequency = "rotorSpeed * (1 - rotorThrust/5)";
						volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
					};
					class EngineInt 
					{
						sound[] = {"\fza_ah64_US\audio\Engine_Int.ogg", 1, 1.000000};
						frequency = "rotorSpeed";
						volume = "(1-camPos)*((rotorSpeed-0.75)*4)";
					};
					class RotorInt 
					{
						sound[] = {"\fza_ah64_US\audio\ah64_rotor_int1.ogg", 1, 1.000000};
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
						sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm.ogg", 0.316228, 1.000000};
						frequency = 1;
						volume = "engineOn * (1 - camPos) * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0.0, 0.001])";
					};
					class damageAlarmExt 
					{
						sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm.ogg", 0.223872, 1.000000, 20};
						frequency = 1;
						volume = "engineOn * camPos * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0, 0.001])";
					};
					class rotorLowAlarmInt 
					{
						sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm_low.ogg", 0.316228, 1.000000};
						frequency = 1;
						volume = "engineOn * (1 - camPos) * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
					};
					class rotorLowAlarmExt 
					{
						sound[] = {"\fza_ah64_us\audio\betty\bt_rotorrpm_low.ogg", 0.223872, 1.000000, 20};
						frequency = 1;
						volume = "engineOn * camPos * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
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
						sound[] = {"\fza_ah64_us\audio\rain1_ext.ogg", 1.000000, 1.000000, 100};
						frequency = 1;
						volume = "camPos * (rain - rotorSpeed/2) * 2";
					};
					class RainInt 
					{
						sound[] = {"\fza_ah64_us\audio\rain1_int_open.ogg", 1.000000, 1.000000, 100};
						frequency = 1;
						volume = "(1-camPos)*(rain - rotorSpeed/2)*2";
					};
					class SlingLoadDownExt 
					{
						sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownEXT", 1.000000, 1.000000, 500};
						frequency = 1;
						volume = "camPos*(slingLoadActive factor [0,-1])";
					};
					class SlingLoadUpExt 
					{
						sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineUpEXT", 1.000000, 1.000000, 500};
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
		};
		class HitPoints
		{
			class HitHull
			{
				armor = 999;
				material = 51;
				name = "fuselage";
				passthrough = 1;
				visual = "fuselage";
				explosionShielding = 3;
				convexComponent = "fuselage";
				radius = 0.01;
				depends = "Total";
			};
			class HitAvionics
			{
				armor = 2;
				material = 51;
				name = "cockpit";
				passthrough = 0.5;
				visual = "cockpit";
				explosionShielding = 1;
				convexComponent = "cockpit";
				minimalHit = 0.05;
				radius = 0.4;
			};
			/*
			class HitFuselage
			{
				armor = 1;
				material = 51;
				name = "fuselage";
				passthrough = 1;
				visual = "fuselage";
			};
			*/
			class HitTransmission
			{
				armor = 0.8;
				material = -1;
				name = "trans";
				passthrough = 0.25;
			};
			class HitEngine
			{
				armor = 0.8;
				material = 51;
				name = "trans";
				passthrough = 0.25;
				visual = "trans";
				explosionShielding = 3;
				convexComponent = "trans";
				minimalHit = 0.1;
				radius = 0.4;
				depends = "0.5 * (HitEngine1 + HitEngine2)";
			};
			class HitEngine1
			{
				armor = 0.7;
				material = 51;
				name = "leng";
				passthrough = 1;
				visual = "leng";
				explosionShielding = 3;
				convexComponent = "leng";
				minimalHit = 0.1;
				radius = 0.4;
			};
			class HitEngine2
			{
				armor = 0.7;
				material = 51;
				name = "reng";
				passthrough = 1;
				visual = "reng";
				explosionShielding = 3;
				convexComponent = "reng";
				minimalHit = 0.1;
				radius = 0.4;
			};
			class Hitlfab
			{
				armor = 0.5;
				material = 51;
				name = "lfab";
				passthrough = 0.1;
				visual = "lfab";
			};
			class Hitrfab
			{
				armor = 0.5;
				material = 51;
				name = "rfab";
				passthrough = 0.1;
				visual = "rfab";
			};
			class HitVRotor
			{
				armor = 3;
				material = 51;
				name = "mala vrtule";
				passthrough = 0.1;
				visual = "mala vrtule";
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
				visual = "velka vrtule";
				explosionShielding = 2.5;
				convexComponent = "velka vrtule";
				minimalHit = 0.09;
				radius = 0.4;
			};
			class Hitlwing
			{
				armor = 0.75;
				material = 51;
				name = "lwing";
				passthrough = 0.1;
				visual = "lwing";
			};
			class Hitrwing
			{
				armor = 0.75;
				material = 51;
				name = "rwing";
				passthrough = 0.1;
				visual = "rwing";
			};
			class HitTail
			{
				armor = 0.75;
				material = 51;
				name = "tailboom";
				passthrough = 0.5;
				visual = "tailboom";
			};
			class HitVTail
			{
				armor = 0.2;
				material = 51;
				name = "vtail";
				passthrough = 0.1;
				visual = "vtail";
			};
			class HitHTail
			{
				armor = 0.2;
				material = 51;
				name = "hstab";
				passthrough = 0.1;
				visual = "hstab";
			};
			class HitPNVS
			{
				armor = 0.25;
				material = 51;
				name = "pnvs";
				passthrough = 0.1;
				visual = "pnvs";
			};
			class Hittads
			{
				armor = 0.25;
				material = 51;
				name = "tads";
				passthrough = 0.1;
				visual = "tads";
			};
			class Hittadstur
			{
				armor = 0.25;
				material = 51;
				name = "tads_tur";
				passthrough = 0.1;
				visual = "tads_tur";
			};
			class Hitradar
			{
				armor = 0.05;
				material = 51;
				name = "radar";
				passthrough = 0.1;
				visual = "radar";
			};
			class Hitotocvez
			{
				armor = 0.25;
				material = 51;
				name = "otocvez";
				passthrough = 0.1;
				visual = "otocvez";
			};
			class Hitotochlaven
			{
				armor = 0.25;
				material = 51;
				name = "otochlaven";
				passthrough = 0.1;
				visual = "otochlaven";
			};
			class Hitmaingear
			{
				armor = 0.2;
				material = 51;
				name = "maingear";
				passthrough = 0.1;
				visual = "maingear";
			};
			class Hittwsus
			{
				armor = 0.2;
				material = 51;
				name = "twsus";
				passthrough = 0.1;
				visual = "twsus";
			};
			class Hitpylon1
			{
				armor = 0.2;
				material = 51;
				name = "pylon1";
				passthrough = 0.1;
				visual = "pylon1";
			};
			class Hitpylon2
			{
				armor = 0.2;
				material = 51;
				name = "pylon2";
				passthrough = 0.1;
				visual = "pylon2";
			};
			class Hitpylon3
			{
				armor = 0.2;
				material = 51;
				name = "pylon3";
				passthrough = 0.1;
				visual = "pylon3";
			};
			class Hitpylon4
			{
				armor = 0.2;
				material = 51;
				name = "pylon4";
				passthrough = 0.1;
				visual = "pylon4";
			};
		};	
		class UserActions
		{
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
				statement="fza_ah64_agmode = fza_ah64_agmode + 1;";
			};
			class weaponactionswitch
			{
				displayName="Weapon Action Switch (WAS)";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && alive this";
				shortcut="user4";
				statement="[this] call fza_ah64_wepactionswitch";
			};
			class gunburst
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="zamerny";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pl_mpd == ""wpn"") && (currentweapon this == ""fza_m230"" || currentweapon this == ""fza_burstlimiter"")";
				shortcut="Binocular";
				statement="[this] exec ""\fza_ah64_controls\scripting\burstlimit.sqs""";
			};
			class rocketsalvo
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="zamerny";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pl_mpd == ""wpn"") && (currentweapon this in fza_ah64_rocketweps14 || currentweapon this in fza_ah64_rocketweps23 || currentweapon this in fza_ah64_rocketweps1 || currentweapon this in fza_ah64_rocketweps2 || currentweapon this in fza_ah64_rocketweps3 || currentweapon this in fza_ah64_rocketweps4)";
				shortcut="Binocular";
				statement="fza_ah64_rs = [this] execvm ""\fza_ah64_controls\scripting\rocket_salvo.sqf""";
			};
			class guncontrol
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="zamerny";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pl_mpd == ""wpn"")";
				shortcut="User3";
				statement="fza_ah64_gc = [this] execvm ""\fza_ah64_controls\scripting\guncontrol.sqf""";
			};
			class misltraj
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="zamerny";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pl_mpd == ""wpn"") && (currentweapon this == ""fza_agm114_23_8"" || currentweapon this == ""fza_agm114_14_8"" || currentweapon this in fza_ah64_hellfireweps1 || currentweapon this in fza_ah64_hellfireweps2 || currentweapon this in fza_ah64_hellfireweps3 || currentweapon this in fza_ah64_hellfireweps4)";
				shortcut="Binocular";
				statement="fza_ah64_hfltype = [this] execvm ""\fza_ah64_controls\scripting\ltype_tog.sqf""";
			};
			class pilotdoor_open
			{
				displayName="Open Pilot Door";
				position="pilot_action";
				onlyForPlayer=0;
				radius=2.5;
				showWindow=0;
				priority=10;
				condition="this animationphase ""pdoor"" < 0.5 && alive this && !(isengineon this)";
				shortcut="";
				statement="fza_ah64_pdoor = [this] execvm ""\fza_ah64_controls\scripting\pilotdoor_toggle.sqf""";
			};
			/*class IntLight
			{
				displayName="Toggle Interior Lights";
				position="pilot_action";
				onlyForPlayer=0;
				radius=2.5;
				showWindow=0;
				priority=-10;
				condition="(alive this)";
				shortcut="";
				statement="[this] exec ""\fza_ah64_controls\scripting\IntLight.sqf""";
			};*/			
			class pilotdoor_close
			{
				displayName="Close Pilot Door";
				position="pilot_action";
				onlyForPlayer=0;
				radius=2.5;
				showWindow=0;
				priority=10;
				condition="this animationphase ""pdoor"" > 0.5 && alive this";
				shortcut="";
				statement="fza_ah64_pdoor = [this] execvm ""\fza_ah64_controls\scripting\pilotdoor_toggle.sqf""";
			};
			class gundoor_open
			{
				displayName="Open Gunner Door";
				position="gunner_action";
				onlyForPlayer=0;
				radius=3;
				showWindow=0;
				priority=10;
				condition="this animationphase ""gdoor"" < 0.5 && alive this && !(isengineon this)";
				shortcut="";
				statement="fza_ah64_pdoor = [this] execvm ""\fza_ah64_controls\scripting\gundoor_toggle.sqf""";
			};
			class gundoor_close
			{
				displayName="Close Gunner Door";
				position="gunner_action";
				onlyForPlayer=0;
				radius=3;
				showWindow=0;
				priority=10;
				condition="this animationphase ""gdoor"" > 0.5 && alive this";
				shortcut="";
				statement="fza_ah64_pdoor = [this] execvm ""\fza_ah64_controls\scripting\gundoor_toggle.sqf""";
			};
			class ihadsstoggle
			{
				displayName="IHADSS Toggle";
				position="pilot_action";
				onlyForPlayer=1;
				radius=3;
				showWindow=0;
				priority=9;
				condition="player == driver this || player == gunner this";
				shortcut="User11";
				statement="[this] exec ""\fza_ah64_controls\scripting\ihadss.sqs""";
			};
			class pilotrmpd
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="player == driver this || player == gunner this";
				shortcut="User1";
				statement="fza_ah64_prmpdcycle = [this] execvm ""\fza_ah64_controls\scripting\prmpdcycle.sqf""";
			};
			class pilotlmpd
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="player == driver this || player == gunner this";
				shortcut="User2";
				statement="fza_ah64_plmpdcycle = [this] execvm ""\fza_ah64_controls\scripting\plmpdcycle.sqf""";
			};
			/*
			DEPRECATED
			class lasertoggle
			{
				displayName="Laser Toggle";
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=-7;
				condition="player == gunner this";
				shortcut="User5";
				statement="[this] exec ""\fza_ah64_controls\scripting\laser.sqs""";
			};
			*/
			class filtertargs
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""fcr"" ||fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pl_mpd == ""tsd"")";
				shortcut="User6";
				statement="[this] exec ""\fza_ah64_controls\scripting\tsd_targfilter.sqs""";
			};
			class tsdrange
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pr_mpd == ""fcr"" || fza_ah64_pr_mpd == ""ase"")";
				shortcut="User7";
				statement="[this] exec ""\fza_ah64_controls\scripting\tsd_range.sqf""";
			};
			class tsdmode
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pl_mpd == ""tsd"")";
				shortcut="User8";
				statement="[this] exec ""\fza_ah64_controls\scripting\tsd_mode.sqs""";
			};
			////////////////TEMP NAV CONTROL/////////////
			class waypoints_add
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pl_mpd == ""tsd"") && fza_ah64_tsdmode == ""nav""";
				shortcut="";
				statement="fza_ah64_addwps = [this] execvm ""\fza_ah64_controls\scripting\nav\waypointadd.sqf""";
			};
			class waypoints_sav
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pl_mpd == ""tsd"") && fza_ah64_tsdmode == ""nav""";
				shortcut="";
				statement="fza_ah64_addwps = [this] execvm ""\fza_ah64_controls\scripting\nav\waypointsave.sqf""";
			};
			class waypoints_clr
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pl_mpd == ""tsd"") && fza_ah64_tsdmode == ""nav""";
				shortcut="";
				statement="fza_ah64_addwps = [this] execvm ""\fza_ah64_controls\scripting\nav\waypointclear.sqf""";
			};
			class map_toggle
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pl_mpd == ""tsd"")";
				shortcut="";
				statement="fza_ah64_maptog = [this] execvm ""\fza_ah64_controls\scripting\tsd_map_toggle.sqf""";
			};
			///////////PFZ CONTROL/////////////
			class pfz_create
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pr_mpd == ""fcr"")";
				shortcut="";
				statement="fza_ah64_createpfz = [this,fza_ah64_pfz_count] execvm ""\fza_ah64_controls\scripting\pfz.sqf""";
			};
			class pfz_sel
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pr_mpd == ""fcr"")";
				shortcut="User9";
				statement="fza_ah64_selpfz = [this] execvm ""\fza_ah64_controls\scripting\pfz_sel.sqf""";
			};
			class pfz_send
			{
				displayName="";
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pr_mpd == ""fcr"")";
				shortcut="";
				statement="fza_ah64_sendpfz = [this] execvm ""\fza_ah64_controls\scripting\targxfer.sqf""";
			};
			class pfz_recv
			{
				displayName="";
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""tsd"" || fza_ah64_pr_mpd == ""fcr"")";
				shortcut="";
				statement="fza_ah64_recvpfz = [this] execvm ""\fza_ah64_controls\scripting\targrecv.sqf""";
			};
			class mode_self
			{
				displayName="MODE SELF";
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pl_mpd == ""wpn"")";
				shortcut="";
				statement="fza_ah64_modeself = [this] execvm ""\fza_ah64_controls\scripting\mode_self.sqf""";
			};
			class mode_remt
			{
				displayName="MODE REMOTE";
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pl_mpd == ""wpn"")";
				shortcut="";
				statement="fza_ah64_moderemt = [this] execvm ""\fza_ah64_controls\scripting\mode_remt.sqf""";
			};
			class add_remt
			{
				displayName="BROADCAST REMOTE CODE";
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pl_mpd == ""wpn"")";
				shortcut="User5";
				statement="fza_ah64_moderemt = [this] execvm ""\fza_ah64_controls\scripting\add_remt.sqf""";
			};
			class rem_remt
			{
				displayName="CEASE REMOTE CODE";
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pl_mpd == ""wpn"")";
				shortcut="User10";
				statement="fza_ah64_moderemt = [this] execvm ""\fza_ah64_controls\scripting\rem_remt.sqf""";
			};
			class pnvs_cam_onoff
			{
				displayName="HDU PNVS Toggle";
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=8;
				condition="(player == driver this || player == gunner this)";
				shortcut="User12";
				statement="fza_ah64_pnvs_cam_toggle = [this] execvm ""\fza_ah64_controls\scripting\pnvs_cam_set.sqf""";
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
				priority=0;
				condition="(!(fza_ah64_tiron))";
				shortcut="User19";
				statement="fza_ah64_tiron = true";
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
				priority=0;
				condition="(fza_ah64_tiron)";
				shortcut="User19";
				statement="fza_ah64_tiron = false";
			};
			class cycle_wp
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this)";
				shortcut="User18";
				statement="fza_ah64_nextwp = [this] execvm ""\fza_ah64_controls\scripting\nav\nextwp.sqf""";
			};
			class cycle_wp2
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this)";
				shortcut="User17";
				statement="fza_ah64_nextwp = [this] execvm ""\fza_ah64_controls\scripting\nav\nextwp2.sqf""";
			};
			class fcr_toggle
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this)";
				shortcut="salute";
				statement="fza_ah64_fcronoff = [this] execvm ""\fza_ah64_controls\scripting\fcr_toggle.sqf""";
			};
			class irjammer_toggle
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""ase"")";
				shortcut="";
				statement="fza_ah64_irjamonoff = [this] execvm ""\fza_ah64_controls\scripting\ir_jammer.sqf""";
			};
			class rfjammer_toggle
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""ase"")";
				shortcut="";
				statement="fza_ah64_rfjamonoff = [this] execvm ""\fza_ah64_controls\scripting\rf_jammer.sqf""";
			};
			class jammer_toggle
			{
				displayName="JAMMER MAN/AUT";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""ase"")";
				shortcut="User13";
				statement="fza_ah64_jamstate = [this] execvm ""\fza_ah64_controls\scripting\jam_toggle.sqf""";
			};
			class ase_autpage
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this) && (fza_ah64_pr_mpd == ""ase"")";
				shortcut="User14";
				statement="fza_ah64_autpg = [this] execvm ""\fza_ah64_controls\scripting\ase_autpage.sqf""";
			};
			class ihadssmode
			{
				displayName="";
				useAction=false;
				showSwitchAction=false;
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=0;
				condition="(player == driver this || player == gunner this)";
				shortcut="User15";
				statement="fza_ah64_ihadssmode = [this] execvm ""\fza_ah64_controls\scripting\ihadss_mode.sqf""";
			};
			/*class clickhelpers
			{
				displayName="Click Helper Toggle";
				position="pilot_action";
				onlyForPlayer=1;
				radius=8;
				showWindow=0;
				priority=-12;
				condition="(player == driver this || player == gunner this)";
				shortcut="";
				statement="fza_ah64_clickhelpers = [this] execvm ""\fza_ah64_controls\scripting\click_helpers.sqf""";
			};*/
			class Arming 
			{ 
				displayName="<t color ='#ffff00'>Arming</t>"; 
				position="pilot_action"; 
				onlyForPlayer=1; 
				radius=8; 
				showWindow=0; 
				priority=13; 
				condition="(player == driver this) && (!isengineon this) && (speed this < 5) && (alive this)"; //removed CPG action
				shortcut=""; 
				statement="[this] execVM ""\fza_ah64_controls\arming\armingdiag_2.sqf"""; 
			};
		};
		class eventhandlers
		{
			init = "[_this select 0] execvm ""\fza_ah64_controls\scripting\ah64d_init.sqf"";";
			fired = "_this execvm ""\fza_ah64_controls\scripting\ffar_align.sqf""; _this call fza_ah64_fx_EH_Fired; _this call fza_ah64_rocketalign; _this call fza_ah64_hellfirealign;"; 
			GetIn = "_this execvm ""\fza_ah64_controls\scripting\getin.sqf""";
			GetOut = "_this execvm ""\fza_ah64_controls\scripting\getout.sqf"""; 
			IncomingMissile = "_this execvm ""\fza_ah64_controls\ecm\CMSmk2.sqf""";
			engine = "[_this select 0,_this select 1] execvm ""\fza_ah64_controls\scripting\engon.sqf""";
			HandleDamage = "if(alive (_this select 0) && !(surfaceiswater [getposasl (_this select 0) select 0,getposasl (_this select 0) select 1] && getpos (_this select 0)  select 2 < 0)) then {_this call fza_ah64_systemdamage;}; if(alive (_this select 0)) then {_this select 2};";
			killed = "_this call BIS_Effects_EH_Killed;";
		};
		class MFD {};
		/*class MFD1
		{
			rendertarget = "fza_ah64_pnvsrtarget0";
			class View01
			{
				fov = 0.2;
				pointdirection = "driverview_dir";
				pointposition = "driverview";
				renderquality = 0;
				rendervisionmode = 2;
			};
		};*/
		class AcreRacks 
		{
           class Rack_1 {
               displayName = "ARC-186"; // Name is displayed in the interaction menu.
               //allowedPositions[] = {"driver", "copilot"}; // Who has access. "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
               componentName = "ACRE_VRC103";
               allowedPositions[] = {"inside"};
			   disabledPositions[] = {};
               defaultComponents[] = {};
               mountedRadio = "ACRE_PRC117F";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {"intercom_1"};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
					acre_hasInfantryPhone = 1; // 1 - enabled, 0 - disabled
					acre_infantryPhoneDisableRinging = 0;   // If set to 1, the ringing funtionality will not be available
					acre_infantryPhoneCustomRinging[] = {}; // An array used in order to override the default sound for the ringing functionality   
					acre_infantryPhoneIntercom[] = {"all"}; // List of intercom names (intercom_1, intercom_2) or "all" in order to specify which intercom networks the phone can connect to
					acre_infantryPhoneControlActions[] = {"intercom_1"}; // Only those units in "intercom_1" can have access to ringing functionality
					acre_eventInfantryPhone = QFUNC(noApiFunction); // Here a custom function can be defined that is called when the infantry phone is picked up, put back, given to another unit or the intercom network is switched
		   };
       };
	};	
	class fza_ah64d_b2e: fza_ah64base
	{
		side=1;				
		scope=2;
		author="Franze, Nodunit, Sacha 'Voodoo' Oropeza & Community";
		displayName="AH-64D Apache Longbow";
		model="\fza_ah64_US\fza_ah64d_b2.p3d";
		ejectDeadCargo=0;
		nameSound="veh_Helicopter";
		faction="fza_usaav";
		vehicleclass="fza_helicopters";
		hasGunner=1; 
		audible=4;
		hiddenselections[]=
{
"pod1_m151_1",
"pod1_m151_2",
"pod1_m151_3",
"pod1_m151_4",
"pod1_m151_5",
"pod1_m151_6",
"pod1_m151_7",
"pod1_m151_8",
"pod1_m151_9",
"pod1_m151_10",
"pod1_m151_11",
"pod1_m151_12",
"pod1_m151_13",
"pod1_m151_14",
"pod1_m151_15",
"pod1_m151_16",
"pod1_m151_17",
"pod1_m151_18",
"pod1_m151_19",
"pod1_m229_1",
"pod1_m229_2",
"pod1_m229_3",
"pod1_m229_4",
"pod1_m229_5",
"pod1_m229_6",
"pod1_m229_7",
"pod1_m229_8",
"pod1_m229_9",
"pod1_m229_10",
"pod1_m229_11",
"pod1_m229_12",
"pod1_m229_13",
"pod1_m229_14",
"pod1_m229_15",
"pod1_m229_16",
"pod1_m229_17",
"pod1_m229_18",
"pod1_m229_19",
"pod1_m261_1",
"pod1_m261_2",
"pod1_m261_3",
"pod1_m261_4",
"pod1_m261_5",
"pod1_m261_6",
"pod1_m261_7",
"pod1_m261_8",
"pod1_m261_9",
"pod1_m261_10",
"pod1_m261_11",
"pod1_m261_12",
"pod1_m261_13",
"pod1_m261_14",
"pod1_m261_15",
"pod1_m261_16",
"pod1_m261_17",
"pod1_m261_18",
"pod1_m261_19",
"pod2_m151_1",
"pod2_m151_2",
"pod2_m151_3",
"pod2_m151_4",
"pod2_m151_5",
"pod2_m151_6",
"pod2_m151_7",
"pod2_m151_8",
"pod2_m151_9",
"pod2_m151_10",
"pod2_m151_11",
"pod2_m151_12",
"pod2_m151_13",
"pod2_m151_14",
"pod2_m151_15",
"pod2_m151_16",
"pod2_m151_17",
"pod2_m151_18",
"pod2_m151_19",
"pod2_m229_1",
"pod2_m229_2",
"pod2_m229_3",
"pod2_m229_4",
"pod2_m229_5",
"pod2_m229_6",
"pod2_m229_7",
"pod2_m229_8",
"pod2_m229_9",
"pod2_m229_10",
"pod2_m229_11",
"pod2_m229_12",
"pod2_m229_13",
"pod2_m229_14",
"pod2_m229_15",
"pod2_m229_16",
"pod2_m229_17",
"pod2_m229_18",
"pod2_m229_19",
"pod2_m261_1",
"pod2_m261_2",
"pod2_m261_3",
"pod2_m261_4",
"pod2_m261_5",
"pod2_m261_6",
"pod2_m261_7",
"pod2_m261_8",
"pod2_m261_9",
"pod2_m261_10",
"pod2_m261_11",
"pod2_m261_12",
"pod2_m261_13",
"pod2_m261_14",
"pod2_m261_15",
"pod2_m261_16",
"pod2_m261_17",
"pod2_m261_18",
"pod2_m261_19",
"pod3_m151_1",
"pod3_m151_2",
"pod3_m151_3",
"pod3_m151_4",
"pod3_m151_5",
"pod3_m151_6",
"pod3_m151_7",
"pod3_m151_8",
"pod3_m151_9",
"pod3_m151_10",
"pod3_m151_11",
"pod3_m151_12",
"pod3_m151_13",
"pod3_m151_14",
"pod3_m151_15",
"pod3_m151_16",
"pod3_m151_17",
"pod3_m151_18",
"pod3_m151_19",
"pod3_m229_1",
"pod3_m229_2",
"pod3_m229_3",
"pod3_m229_4",
"pod3_m229_5",
"pod3_m229_6",
"pod3_m229_7",
"pod3_m229_8",
"pod3_m229_9",
"pod3_m229_10",
"pod3_m229_11",
"pod3_m229_12",
"pod3_m229_13",
"pod3_m229_14",
"pod3_m229_15",
"pod3_m229_16",
"pod3_m229_17",
"pod3_m229_18",
"pod3_m229_19",
"pod3_m261_1",
"pod3_m261_2",
"pod3_m261_3",
"pod3_m261_4",
"pod3_m261_5",
"pod3_m261_6",
"pod3_m261_7",
"pod3_m261_8",
"pod3_m261_9",
"pod3_m261_10",
"pod3_m261_11",
"pod3_m261_12",
"pod3_m261_13",
"pod3_m261_14",
"pod3_m261_15",
"pod3_m261_16",
"pod3_m261_17",
"pod3_m261_18",
"pod3_m261_19",
"pod4_m151_1",
"pod4_m151_2",
"pod4_m151_3",
"pod4_m151_4",
"pod4_m151_5",
"pod4_m151_6",
"pod4_m151_7",
"pod4_m151_8",
"pod4_m151_9",
"pod4_m151_10",
"pod4_m151_11",
"pod4_m151_12",
"pod4_m151_13",
"pod4_m151_14",
"pod4_m151_15",
"pod4_m151_16",
"pod4_m151_17",
"pod4_m151_18",
"pod4_m151_19",
"pod4_m229_1",
"pod4_m229_2",
"pod4_m229_3",
"pod4_m229_4",
"pod4_m229_5",
"pod4_m229_6",
"pod4_m229_7",
"pod4_m229_8",
"pod4_m229_9",
"pod4_m229_10",
"pod4_m229_11",
"pod4_m229_12",
"pod4_m229_13",
"pod4_m229_14",
"pod4_m229_15",
"pod4_m229_16",
"pod4_m229_17",
"pod4_m229_18",
"pod4_m229_19",
"pod4_m261_1",
"pod4_m261_2",
"pod4_m261_3",
"pod4_m261_4",
"pod4_m261_5",
"pod4_m261_6",
"pod4_m261_7",
"pod4_m261_8",
"pod4_m261_9",
"pod4_m261_10",
"pod4_m261_11",
"pod4_m261_12",
"pod4_m261_13",
"pod4_m261_14",
"pod4_m261_15",
"pod4_m261_16",
"pod4_m261_17",
"pod4_m261_18",
"pod4_m261_19",
"rail1_114l_1",
"rail1_114l_2",
"rail1_114l_3",
"rail1_114l_4",
"rail1_114k_1",
"rail1_114k_2",
"rail1_114k_3",
"rail1_114k_4",
"rail2_114l_1",
"rail2_114l_2",
"rail2_114l_3",
"rail2_114l_4",
"rail2_114k_1",
"rail2_114k_2",
"rail2_114k_3",
"rail2_114k_4",
"rail3_114l_1",
"rail3_114l_2",
"rail3_114l_3",
"rail3_114l_4",
"rail3_114k_1",
"rail3_114k_2",
"rail3_114k_3",
"rail3_114k_4",
"rail4_114l_1",
"rail4_114l_2",
"rail4_114l_3",
"rail4_114l_4",
"rail4_114k_1",
"rail4_114k_2",
"rail4_114k_3",
"rail4_114k_4",
"atas_1",
"atas_2",
"fim92_1",
"fim92_2",
"fim92_3",
"fim92_4",
"auxtank_1",
"auxtank_2",
"auxtank_3",
"auxtank_4",
			"mpd_pl_obj1",
			"mpd_pl_obj2",
			"mpd_pl_obj3",
			"mpd_pl_obj4",
			"mpd_pl_obj5",
			"mpd_pl_obj6",
			"mpd_pl_obj7",
			"mpd_pl_obj8",
			"mpd_pl_obj9",
			"mpd_pl_obj10",
			"mpd_pl_obj11",
			"mpd_pl_obj12",
			"mpd_pl_obj13",
			"mpd_pl_obj14",
			"mpd_pl_obj15",
			"mpd_pl_obj16",
			"mpd_pl_obj17",
			"mpd_pl_obj18",
			"mpd_pl_obj19",
			"mpd_pl_obj20",
			"mpd_pl_obj21",
			"mpd_pl_obj22",
			"mpd_pl_obj23",
			"mpd_pl_obj24",
			"mpd_pl_obj25",
			"mpd_pl_obj26",
			"mpd_pl_obj27",
			"mpd_pl_obj28",
			"mpd_pl_obj29",
			"mpd_pl_obj30",
			"mpd_pl_obj31",
			"mpd_pl_obj32",
"pl_mpd_back",
"pr_mpd_back",
"pl_aft_fuel_n0",
"pl_aft_fuel_n1",
"pl_aft_fuel_n2",
"pl_aft_fuel_n3",
"pl_aft_line",
"pl_flow1_fuel_n0",
"pl_flow1_fuel_n1",
"pl_flow1_fuel_n2",
"pl_flow2_fuel_n0",
"pl_flow2_fuel_n1",
"pl_flow2_fuel_n2",
"pl_fwd_fuel_n0",
"pl_fwd_fuel_n1",
"pl_fwd_fuel_n2",
"pl_fwd_fuel_n3",
"pl_fwd_line",
"pl_iafs_fuel_n0",
"pl_iafs_fuel_n1",
"pl_iafs_fuel_n2",
"pl_iend_fuel_n0",
"pl_iend_fuel_n1",
"pl_iend_fuel_n2",
"pl_int_fuel_n0",
"pl_int_fuel_n1",
"pl_int_fuel_n2",
"pl_int_fuel_n3",
"pl_tend_fuel_n0",
"pl_tend_fuel_n1",
"pl_tend_fuel_n2",
"pl_tflow_fuel_n0",
"pl_tflow_fuel_n1",
"pl_tflow_fuel_n2",
"pl_tot_fuel_n0",
"pl_tot_fuel_n1",
"pl_tot_fuel_n2",
"pl_tot_fuel_n3",
"pl_waux1",
"pl_waux2",
"pl_waux3",
"pl_waux4",
"pr_aft_fuel_n0",
"pr_aft_fuel_n1",
"pr_aft_fuel_n2",
"pr_aft_fuel_n3",
"pr_aft_line",
"pr_flow1_fuel_n0",
"pr_flow1_fuel_n1",
"pr_flow1_fuel_n2",
"pr_flow2_fuel_n0",
"pr_flow2_fuel_n1",
"pr_flow2_fuel_n2",
"pr_fwd_fuel_n0",
"pr_fwd_fuel_n1",
"pr_fwd_fuel_n2",
"pr_fwd_fuel_n3",
"pr_fwd_line",
"pr_iafs_fuel_n0",
"pr_iafs_fuel_n1",
"pr_iafs_fuel_n2",
"pr_iend_fuel_n0",
"pr_iend_fuel_n1",
"pr_iend_fuel_n2",
"pr_int_fuel_n0",
"pr_int_fuel_n1",
"pr_int_fuel_n2",
"pr_int_fuel_n3",
"pr_tend_fuel_n0",
"pr_tend_fuel_n1",
"pr_tend_fuel_n2",
"pr_tflow_fuel_n0",
"pr_tflow_fuel_n1",
"pr_tflow_fuel_n2",
"pr_tot_fuel_n0",
"pr_tot_fuel_n1",
"pr_tot_fuel_n2",
"pr_tot_fuel_n3",
"pr_waux1",
"pr_waux2",
"pr_waux3",
"pr_waux4",
"pr_iafs_line",
"pl_iafs_line",
"mpd_pr_tsd_wtdir1",
"mpd_pr_tsd_wtdir2",
"mpd_pr_tsd_wtdir3",
"mpd_pr_tsd_eta1",
"mpd_pr_tsd_eta2",
"mpd_pr_tsd_eta3",
"mpd_pr_tsd_eta4",
"mpd_pr_tsd_hdg1",
"mpd_pr_tsd_hdg2",
"mpd_pr_tsd_hdg3",
"mpd_pr_tsd_dist2",
"mpd_pr_tsd_dist3",
"mpd_pr_tsd_dist4",
"mpd_pr_tsd_z1",
"mpd_pr_tsd_z2",
"mpd_pr_tsd_pfzs",
"mpd_pr_tsd_filter",
"mpd_pr_tsd_acq",
"mpd_pr_tsd_wdir1",
"mpd_pr_tsd_wdir2",
"mpd_pr_tsd_wdir3",
"mpd_pr_tsd_wv1",
"mpd_pr_tsd_wv2",
"mpd_pl_tsd_wtdir1",
"mpd_pl_tsd_wtdir2",
"mpd_pl_tsd_wtdir3",
"mpd_pl_tsd_eta1",
"mpd_pl_tsd_eta2",
"mpd_pl_tsd_eta3",
"mpd_pl_tsd_eta4",
"mpd_pl_tsd_hdg1",
"mpd_pl_tsd_hdg2",
"mpd_pl_tsd_hdg3",
"mpd_pl_tsd_dist2",
"mpd_pl_tsd_dist3",
"mpd_pl_tsd_dist4",
"mpd_pl_tsd_z1",
"mpd_pl_tsd_z2",
"mpd_pl_tsd_pfzs",
"mpd_pl_tsd_filter",
"mpd_pl_tsd_acq",
"mpd_pl_tsd_wdir1",
"mpd_pl_tsd_wdir2",
"mpd_pl_tsd_wdir3",
"mpd_pl_tsd_wv1",
"mpd_pl_tsd_wv2",
//WAS: gl_tsd_end1
"ufd_back",
"in_lt_apu",
"gl_tsd_end3",
"gl_tsd_eta1",
"gl_tsd_eta2",
"gl_tsd_eta3",
"gl_tsd_eta4",
"gl_tsd_hdg1",
"gl_tsd_hdg2",
"gl_tsd_hdg3",
"gl_tsd_rng1",
"gl_tsd_rng2",
"gl_tsd_rng3",
"gl_tsd_scale1",
"gl_tsd_scale2",
"gl_tsd_typ1",
"gl_tsd_typ2",
"gl_tsd_typ3",
"gl_tsd_winddir1",
"gl_tsd_winddir2",
"gl_tsd_winddir3",
"gl_tsd_windspd1",
"gl_tsd_windspd2",
"gr_tsd_end1",
"gr_tsd_end2",
"gr_tsd_end3",
"gr_tsd_eta1",
"gr_tsd_eta2",
"gr_tsd_eta3",
"gr_tsd_eta4",
"gr_tsd_hdg1",
"gr_tsd_hdg2",
"gr_tsd_hdg3",
"gr_tsd_rng1",
"gr_tsd_rng2",
"gr_tsd_rng3",
"gr_tsd_scale1",
"gr_tsd_scale2",
"gr_tsd_typ1",
"gr_tsd_typ2",
"gr_tsd_typ3",
"gr_tsd_winddir1",
"gr_tsd_winddir2",
"gr_tsd_winddir3",
"gr_tsd_windspd1",
"gr_tsd_windspd2",
"mpd_pl_chaff_qty_1",
"mpd_pl_chaff_qty_2",
"mpd_pl_flare1_qty_1",
"mpd_pl_flare1_qty_2",
"mpd_pl_flare2_qty_1",
"mpd_pl_flare2_qty_2",
"mpd_pl_gun_ammo_1",
"mpd_pl_gun_ammo_2",
"mpd_pl_gun_ammo_3",
"mpd_pl_gun_ammo_4",
"mpd_pl_gun_burst_1",
"mpd_pl_gun_burst_2",
"mpd_pl_gun_burst_3",
"mpd_pl_gun_burst_4",
"mpd_pl_gun_burst_5",
"mpd_pl_gun_sel",
"mpd_pl_hf_bracket",
"mpd_pl_hf_desig",
"mpd_pl_hf_salt",
"mpd_pl_hf_traj",
"mpd_pl_hf1_l1",
"mpd_pl_hf1_l2",
"mpd_pl_hf1_r1",
"mpd_pl_hf1_r2",
"mpd_pl_hf2_l1",
"mpd_pl_hf2_l2",
"mpd_pl_hf2_r1",
"mpd_pl_hf2_r2",
"mpd_pl_hf3_l1",
"mpd_pl_hf3_l2",
"mpd_pl_hf3_r1",
"mpd_pl_hf3_r2",
"mpd_pl_hf4_l1",
"mpd_pl_hf4_l2",
"mpd_pl_hf4_r1",
"mpd_pl_hf4_r2",
"mpd_pl_rg_base",
"mpd_pl_rg_bracket",
"mpd_pl_rkt_burst",
"mpd_pl_rkt_sel_type_1",
"mpd_pl_rkt_sel_type_2",
"mpd_pl_rkt_sel_type_3",
"mpd_pl_rkt_sel_type_4",
"mpd_pl_rkt_tot_1",
"mpd_pl_rkt_tot_2",
"mpd_pl_rkt1_qty_1",
"mpd_pl_rkt1_qty_2",
"mpd_pl_rkt1_type",
"mpd_pl_rkt2_qty_1",
"mpd_pl_rkt2_qty_2",
"mpd_pl_rkt2_type",
"mpd_pl_rkt3_qty_1",
"mpd_pl_rkt3_qty_2",
"mpd_pl_rkt3_type",
"mpd_pl_rkt4_qty_1",
"mpd_pl_rkt4_qty_2",
"mpd_pl_rkt4_type",
"mpd_pl_rkt5_qty_1",
"mpd_pl_rkt5_qty_2",
"mpd_pl_rkt5_type",
"mpd_pl_sight_acq",
"mpd_pl_wpn_acq",
"mpd_pl_wpn_ata_sel",
"mpd_pl_wpn_gun_sel",
"mpd_pl_wpn_hf_type",
"mpd_pl_wpn_msl_sel",
"mpd_pl_wpn_rkt_sel",
"mpd_pl_wpn_sel",
"mpd_pl_rkt1",
"mpd_pl_rkt2",
"mpd_pl_rkt3",
"mpd_pl_rkt4",
"pr_wca_pg",
"pr_wca_1",
"pr_wca_2",
"pr_wca_3",
"pr_wca_4",
"pr_wca_5",
"pr_wca_6",
"pr_wca_7",
"pr_wca_8",
"pr_wca_9",
"pr_wca_10",
"pr_wca_11",
"pr_wca_12",
"pr_wca_13",
"pr_wca_14",
"pr_wca_15",
"pr_wca_16",
"pr_wca_17",
"pr_wca_18",
"pr_wca_19",
"pr_wca_20",
"pr_wca_21",
"pr_wca_22",
"pr_wca_23",
"pr_wca_24",
"pr_wca_25",
"pr_wca_26",
"pl_wca_pg",
"pl_wca_1",
"pl_wca_2",
"pl_wca_3",
"pl_wca_4",
"pl_wca_5",
"pl_wca_6",
"pl_wca_7",
"pl_wca_8",
"pl_wca_9",
"pl_wca_10",
"pl_wca_11",
"pl_wca_12",
"pl_wca_13",
"pl_wca_14",
"pl_wca_15",
"pl_wca_16",
"pl_wca_17",
"pl_wca_18",
"pl_wca_19",
"pl_wca_20",
"pl_wca_21",
"pl_wca_22",
"pl_wca_23",
"pl_wca_24",
"pl_wca_25",
"pl_wca_26",
"gr_wca_pg",
"gr_wca_1",
"gr_wca_2",
"gr_wca_3",
"gr_wca_4",
"gr_wca_5",
"gr_wca_6",
"gr_wca_7",
"gr_wca_8",
"gr_wca_9",
"gr_wca_10",
"gr_wca_11",
"gr_wca_12",
"gr_wca_13",
"gr_wca_14",
"gr_wca_15",
"gr_wca_16",
"gr_wca_17",
"gr_wca_18",
"gr_wca_19",
"gr_wca_20",
"gr_wca_21",
"gr_wca_22",
"gr_wca_23",
"gr_wca_24",
"gr_wca_25",
"gr_wca_26",
"gl_wca_pg",
"gl_wca_1",
"gl_wca_2",
"gl_wca_3",
"gl_wca_4",
"gl_wca_5",
"gl_wca_6",
"gl_wca_7",
"gl_wca_8",
"gl_wca_9",
"gl_wca_10",
"gl_wca_11",
"gl_wca_12",
"gl_wca_13",
"gl_wca_14",
"gl_wca_15",
"gl_wca_16",
"gl_wca_17",
"gl_wca_18",
"gl_wca_19",
"gl_wca_20",
"gl_wca_21",
"gl_wca_22",
"gl_wca_23",
"gl_wca_24",
"gl_wca_25",
"gl_wca_26",
"mpd_pr_flt_balt1",
"mpd_pr_flt_balt2",
"mpd_pr_flt_balt3",
"mpd_pr_flt_balt4",
"mpd_pr_flt_bank",
"mpd_pr_flt_gspd1",
"mpd_pr_flt_gspd2",
"mpd_pr_flt_gspd3",
"mpd_pr_flt_hdg",
"mpd_pr_flt_hdg2",
"mpd_pr_flt_hi",
"mpd_pr_flt_hor",
"mpd_pr_flt_lo",
"mpd_pr_flt_n20c",
"mpd_pr_flt_p20c",
"mpd_pr_flt_ralt1",
"mpd_pr_flt_ralt2",
"mpd_pr_flt_ralt3",
"mpd_pr_flt_raltb",
"mpd_pr_flt_rdr",
"mpd_pr_flt_slip",
"mpd_pr_flt_spd1",
"mpd_pr_flt_spd2",
"mpd_pr_flt_spd3",
"mpd_pr_flt_trq1",
"mpd_pr_flt_trq2",
"mpd_pr_flt_trq3",
"mpd_pr_flt_ttg1",
"mpd_pr_flt_ttg2",
"mpd_pr_flt_ttg3",
"mpd_pr_flt_ttg4",
"mpd_pr_flt_turn",
"mpd_pr_flt_vsi",
"mpd_pr_flt_vvi",
"mpd_pr_flt_w",
"mpd_pr_flt_wbear",
"mpd_pr_flt_wp",
"mpd_pr_flt_wr1",
"mpd_pr_flt_wr2",
"mpd_pr_flt_wr3",
"mpd_pl_flt_balt1",
"mpd_pl_flt_balt2",
"mpd_pl_flt_balt3",
"mpd_pl_flt_balt4",
"mpd_pl_flt_bank",
"mpd_pl_flt_gspd1",
"mpd_pl_flt_gspd2",
"mpd_pl_flt_gspd3",
"mpd_pl_flt_hdg",
"mpd_pl_flt_hdg2",
"mpd_pl_flt_hi",
"mpd_pl_flt_hor",
"mpd_pl_flt_lo",
"mpd_pl_flt_n20c",
"mpd_pl_flt_p20c",
"mpd_pl_flt_ralt1",
"mpd_pl_flt_ralt2",
"mpd_pl_flt_ralt3",
"mpd_pl_flt_raltb",
"mpd_pl_flt_rdr",
"mpd_pl_flt_slip",
"mpd_pl_flt_spd1",
"mpd_pl_flt_spd2",
"mpd_pl_flt_spd3",
"mpd_pl_flt_trq1",
"mpd_pl_flt_trq2",
"mpd_pl_flt_trq3",
"mpd_pl_flt_ttg1",
"mpd_pl_flt_ttg2",
"mpd_pl_flt_ttg3",
"mpd_pl_flt_ttg4",
"mpd_pl_flt_turn",
"mpd_pl_flt_vsi",
"mpd_pl_flt_vvi",
"mpd_pl_flt_w",
"mpd_pl_flt_wbear",
"mpd_pl_flt_wp",
"mpd_pl_flt_wr1",
"mpd_pl_flt_wr2",
"mpd_pl_flt_wr3",
"mpd_gl_flt_balt1",
"mpd_gl_flt_balt2",
"mpd_gl_flt_balt3",
"mpd_gl_flt_balt4",
"mpd_gl_flt_bank",
"mpd_gl_flt_gspd1",
"mpd_gl_flt_gspd2",
"mpd_gl_flt_gspd3",
"mpd_gl_flt_hdg",
"mpd_gl_flt_hdg2",
"mpd_gl_flt_hi",
"mpd_gl_flt_hor",
"mpd_gl_flt_lo",
"mpd_gl_flt_n20c",
"mpd_gl_flt_p20c",
"mpd_gl_flt_ralt1",
"mpd_gl_flt_ralt2",
"mpd_gl_flt_ralt3",
"mpd_gl_flt_raltb",
"mpd_gl_flt_rdr",
"mpd_gl_flt_slip",
"mpd_gl_flt_spd1",
"mpd_gl_flt_spd2",
"mpd_gl_flt_spd3",
"mpd_gl_flt_trq1",
"mpd_gl_flt_trq2",
"mpd_gl_flt_trq3",
"mpd_gl_flt_ttg1",
"mpd_gl_flt_ttg2",
"mpd_gl_flt_ttg3",
"mpd_gl_flt_ttg4",
"mpd_gl_flt_turn",
"mpd_gl_flt_vsi",
"mpd_gl_flt_vvi",
"mpd_gl_flt_w",
"mpd_gl_flt_wbear",
"mpd_gl_flt_wp",
"mpd_gl_flt_wr1",
"mpd_gl_flt_wr2",
"mpd_gl_flt_wr3",
"mpd_gr_flt_balt1",
"mpd_gr_flt_balt2",
"mpd_gr_flt_balt3",
"mpd_gr_flt_balt4",
"mpd_gr_flt_bank",
"mpd_gr_flt_gspd1",
"mpd_gr_flt_gspd2",
"mpd_gr_flt_gspd3",
"mpd_gr_flt_hdg",
"mpd_gr_flt_hdg2",
"mpd_gr_flt_hi",
"mpd_gr_flt_hor",
"mpd_gr_flt_lo",
"mpd_gr_flt_n20c",
"mpd_gr_flt_p20c",
"mpd_gr_flt_ralt1",
"mpd_gr_flt_ralt2",
"mpd_gr_flt_ralt3",
"mpd_gr_flt_raltb",
"mpd_gr_flt_rdr",
"mpd_gr_flt_slip",
"mpd_gr_flt_spd1",
"mpd_gr_flt_spd2",
"mpd_gr_flt_spd3",
"mpd_gr_flt_trq1",
"mpd_gr_flt_trq2",
"mpd_gr_flt_trq3",
"mpd_gr_flt_ttg1",
"mpd_gr_flt_ttg2",
"mpd_gr_flt_ttg3",
"mpd_gr_flt_ttg4",
"mpd_gr_flt_turn",
"mpd_gr_flt_vsi",
"mpd_gr_flt_vvi",
"mpd_gr_flt_w",
"mpd_gr_flt_wbear",
"mpd_gr_flt_wp",
"mpd_gr_flt_wr1",
"mpd_gr_flt_wr2",
"mpd_gr_flt_wr3",
"mpd_pr_flt_dir1",
"mpd_pr_flt_dir2",
"mpd_pr_flt_dir3",
"mpd_pr_flt_dirb",
"mpd_pl_flt_dir1",
"mpd_pl_flt_dir2",
"mpd_pl_flt_dir3",
"mpd_pl_flt_dirb",
"mpd_gr_flt_dir1",
"mpd_gr_flt_dir2",
"mpd_gr_flt_dir3",
"mpd_gr_flt_dirb",
"mpd_gl_flt_dir1",
"mpd_gl_flt_dir2",
"mpd_gl_flt_dir3",
"mpd_gl_flt_dirb",
"mpd_pr_eng_1npb",
"mpd_pr_eng_1tgt_1",
"mpd_pr_eng_1tgt1",
"mpd_pr_eng_1tgt2",
"mpd_pr_eng_1tgt3",
"mpd_pr_eng_1tgtb",
"mpd_pr_eng_1tgtbg",
"mpd_pr_eng_2npb",
"mpd_pr_eng_2tgt_1",
"mpd_pr_eng_2tgt1",
"mpd_pr_eng_2tgt2",
"mpd_pr_eng_2tgt3",
"mpd_pr_eng_2tgtb",
"mpd_pr_eng_2tgtbg",
"mpd_pr_eng_1trq1",
"mpd_pr_eng_1trq2",
"mpd_pr_eng_1trqb",
"mpd_pr_eng_1trqbg",
"mpd_pr_eng_2trq1",
"mpd_pr_eng_2trq2",
"mpd_pr_eng_2trqb",
"mpd_pr_eng_2trqbg",
"mpd_pr_eng_ltrqbar",
"mpd_pr_eng_accpsi1",
"mpd_pr_eng_accpsi2",
"mpd_pr_eng_accpsi3",
"mpd_pr_eng_accpsi4",
"mpd_pr_eng_utipsi1",
"mpd_pr_eng_utipsi2",
"mpd_pr_eng_utipsi3",
"mpd_pr_eng_utipsi4",
"mpd_pr_eng_pripsi1",
"mpd_pr_eng_pripsi2",
"mpd_pr_eng_pripsi3",
"mpd_pr_eng_pripsi4",
"mpd_pr_eng_e1ng1",
"mpd_pr_eng_e1ng2",
"mpd_pr_eng_e1ng3",
"mpd_pr_eng_e2ng1",
"mpd_pr_eng_e2ng2",
"mpd_pr_eng_e2ng3",
"mpd_pr_eng_e1np1",
"mpd_pr_eng_e1np2",
"mpd_pr_eng_e1np3",
"mpd_pr_eng_e2np1",
"mpd_pr_eng_e2np2",
"mpd_pr_eng_e2np3",
"mpd_pr_eng_oil1psi1",
"mpd_pr_eng_oil1psi2",
"mpd_pr_eng_oil1psi3",
"mpd_pr_eng_oil2psi1",
"mpd_pr_eng_oil2psi2",
"mpd_pr_eng_oil2psi3",
"mpd_pr_eng_rrpm1",
"mpd_pr_eng_rrpm2",
"mpd_pr_eng_rrpm3",
"mpd_pr_eng_wca1",
"mpd_pr_eng_wca2",
"mpd_pr_eng_wca3",
"mpd_pr_eng_wca4",
"mpd_pr_eng_wca5",
"mpd_pr_eng_wca6",
"mpd_pr_eng_wca7",
"mpd_pr_eng_wca8",
"mpd_pr_eng_wca9",
"mpd_pr_eng_wca10",
"mpd_pr_eng_wca11",
"mpd_pr_eng_wca12",
"mpd_pr_eng_ifb",
"mpd_pr_eng_ofb",
"mpd_pr_eng_rtrrpmb",
"mpd_pr_eng_hpa",
"mpd_pr_eng_hpp",
"mpd_pr_eng_hpu",
"mpd_pr_eng_rbe1ng",
"mpd_pr_eng_rbe1np",
"mpd_pr_eng_rbe1op",
"mpd_pr_eng_rbe2ng",
"mpd_pr_eng_rbe2np",
"mpd_pr_eng_rbe2op",
"mpd_pr_eng_1accpsi1",
"mpd_pr_eng_1accpsi2",
"mpd_pr_eng_1accpsi3",
"mpd_pr_eng_1accpsi4",
"mpd_pr_eng_1utipsi1",
"mpd_pr_eng_1utipsi2",
"mpd_pr_eng_1utipsi3",
"mpd_pr_eng_1utipsi4",
"mpd_pr_eng_1pripsi1",
"mpd_pr_eng_1pripsi2",
"mpd_pr_eng_1pripsi3",
"mpd_pr_eng_1pripsi4",
"mpd_pl_eng_1npb",
"mpd_pl_eng_1tgt_1",
"mpd_pl_eng_1tgt1",
"mpd_pl_eng_1tgt2",
"mpd_pl_eng_1tgt3",
"mpd_pl_eng_1tgtb",
"mpd_pl_eng_1tgtbg",
"mpd_pl_eng_2npb",
"mpd_pl_eng_2tgt_1",
"mpd_pl_eng_2tgt1",
"mpd_pl_eng_2tgt2",
"mpd_pl_eng_2tgt3",
"mpd_pl_eng_2tgtb",
"mpd_pl_eng_2tgtbg",
"mpd_pl_eng_1trq1",
"mpd_pl_eng_1trq2",
"mpd_pl_eng_1trqb",
"mpd_pl_eng_1trqbg",
"mpd_pl_eng_2trq1",
"mpd_pl_eng_2trq2",
"mpd_pl_eng_2trqb",
"mpd_pl_eng_2trqbg",
"mpd_pl_eng_ltrqbar",
"mpd_pl_eng_accpsi1",
"mpd_pl_eng_accpsi2",
"mpd_pl_eng_accpsi3",
"mpd_pl_eng_accpsi4",
"mpd_pl_eng_utipsi1",
"mpd_pl_eng_utipsi2",
"mpd_pl_eng_utipsi3",
"mpd_pl_eng_utipsi4",
"mpd_pl_eng_pripsi1",
"mpd_pl_eng_pripsi2",
"mpd_pl_eng_pripsi3",
"mpd_pl_eng_pripsi4",
"mpd_pl_eng_e1ng1",
"mpd_pl_eng_e1ng2",
"mpd_pl_eng_e1ng3",
"mpd_pl_eng_e2ng1",
"mpd_pl_eng_e2ng2",
"mpd_pl_eng_e2ng3",
"mpd_pl_eng_e1np1",
"mpd_pl_eng_e1np2",
"mpd_pl_eng_e1np3",
"mpd_pl_eng_e2np1",
"mpd_pl_eng_e2np2",
"mpd_pl_eng_e2np3",
"mpd_pl_eng_oil1psi1",
"mpd_pl_eng_oil1psi2",
"mpd_pl_eng_oil1psi3",
"mpd_pl_eng_oil2psi1",
"mpd_pl_eng_oil2psi2",
"mpd_pl_eng_oil2psi3",
"mpd_pl_eng_rrpm1",
"mpd_pl_eng_rrpm2",
"mpd_pl_eng_rrpm3",
"mpd_pl_eng_wca1",
"mpd_pl_eng_wca2",
"mpd_pl_eng_wca3",
"mpd_pl_eng_wca4",
"mpd_pl_eng_wca5",
"mpd_pl_eng_wca6",
"mpd_pl_eng_wca7",
"mpd_pl_eng_wca8",
"mpd_pl_eng_wca9",
"mpd_pl_eng_wca10",
"mpd_pl_eng_wca11",
"mpd_pl_eng_wca12",
"mpd_pl_eng_ifb",
"mpd_pl_eng_ofb",
"mpd_pl_eng_rtrrpmb",
"mpd_pl_eng_hpa",
"mpd_pl_eng_hpp",
"mpd_pl_eng_hpu",
"mpd_pl_eng_rbe1ng",
"mpd_pl_eng_rbe1np",
"mpd_pl_eng_rbe1op",
"mpd_pl_eng_rbe2ng",
"mpd_pl_eng_rbe2np",
"mpd_pl_eng_rbe2op",
"mpd_pl_eng_1accpsi1",
"mpd_pl_eng_1accpsi2",
"mpd_pl_eng_1accpsi3",
"mpd_pl_eng_1accpsi4",
"mpd_pl_eng_1utipsi1",
"mpd_pl_eng_1utipsi2",
"mpd_pl_eng_1utipsi3",
"mpd_pl_eng_1utipsi4",
"mpd_pl_eng_1pripsi1",
"mpd_pl_eng_1pripsi2",
"mpd_pl_eng_1pripsi3",
"mpd_pl_eng_1pripsi4",
"p_ufd_clk1",
"p_ufd_clk2",
"p_ufd_clk3",
"p_ufd_clk4",
"p_ufd_clk5",
"p_ufd_clk6",
"p_ufd_fl1",
"p_ufd_fl2",
"p_ufd_fl3",
"p_ufd_fl4",
"p_ufd_adv1",
"p_ufd_adv2",
"p_ufd_adv3",
"p_ufd_adv4",
"p_ufd_adv5",
"p_ufd_cau1",
"p_ufd_cau2",
"p_ufd_cau3",
"p_ufd_cau4",
"p_ufd_cau5",
"p_ufd_wrn1",
"p_ufd_wrn2",
"p_ufd_wrn3",
"p_ufd_wrn4",
"p_ufd_wrn5",
"g_ufd_clk1",
"g_ufd_clk2",
"g_ufd_clk3",
"g_ufd_clk4",
"g_ufd_clk5",
"g_ufd_clk6",
"g_ufd_fl1",
"g_ufd_fl2",
"g_ufd_fl3",
"g_ufd_fl4",
"g_ufd_adv1",
"g_ufd_adv2",
"g_ufd_adv3",
"g_ufd_adv4",
"g_ufd_adv5",
"g_ufd_cau1",
"g_ufd_cau2",
"g_ufd_cau3",
"g_ufd_cau4",
"g_ufd_cau5",
"g_ufd_wrn1",
"g_ufd_wrn2",
"g_ufd_wrn3",
"g_ufd_wrn4",
"g_ufd_wrn5",
///NEWTSD///
"mpd_pr_tsd_dist1",
"mpd_pr_tsd_imap",
"mpd_pr_tsd_map",
"mpd_pr_tsd_phase",
///LMPDTSD///
"mpd_pl_tsd_dist1",
"mpd_pl_tsd_imap",
"mpd_pl_tsd_map",
"mpd_pl_tsd_phase",
////LMPDOBJS///
			"mpd_gr_obj1",
			"mpd_gr_obj2",
			"mpd_gr_obj3",
			"mpd_gr_obj4",
			"mpd_gr_obj5",
			"mpd_gr_obj6",
			"mpd_gr_obj7",
			"mpd_gr_obj8",
			"mpd_gr_obj9",
			"mpd_gr_obj10",
			"mpd_gr_obj11",
			"mpd_gr_obj12",
			"mpd_gr_obj13",
			"mpd_gr_obj14",
			"mpd_gr_obj15",
			"mpd_gr_obj16",
			"mpd_gr_obj17",
			"mpd_gr_obj18",
			"mpd_gr_obj19",
			"mpd_gr_obj20",
			"mpd_gr_obj21",
			"mpd_gr_obj22",
			"mpd_gr_obj23",
			"mpd_gr_obj24",
			"mpd_gr_obj25",
			"mpd_gr_obj26",
			"mpd_gr_obj27",
			"mpd_gr_obj28",
			"mpd_gr_obj29",
			"mpd_gr_obj30",
			"mpd_gr_obj31",
			"mpd_gr_obj32",
			"mpd_gr_tsd_mmap",
			"mpd_gr_tsd_base",
			"mpd_pr_tsd_mmap",
			"mpd_pr_tsd_base",
			"pod_m260_1",
			"pod_m260_2",
			"pod_m260_3",
			"pod_m260_4",
			"rail_m299_1",
			"rail_m299_2",
			"rail_m299_3",
			"rail_m299_4",
			"mpd_pr_tsd_gspd1",
			"mpd_pr_tsd_gspd2",
			"mpd_pr_tsd_gspd3",
			"mpd_pl_tsd_gspd1",
			"mpd_pl_tsd_gspd2",
			"mpd_pl_tsd_gspd3",
			"mpd_pr_fcraa_wiper",
			"mpd_pr_fcrag_wiper",
			"mpd_pr_fcrag_tnum1",
			"mpd_pr_fcrag_tnum2",
			"mpd_pr_mpd_had_apos",
			"mpd_pr_mpd_had_apos2",
			"mpd_pr_mpd_had_msg1",
			"mpd_pr_mpd_had_msg2",
			"mpd_pr_mpd_had_msg3",
			"mpd_pr_mpd_had_msg4",
			"mpd_pr_mpd_had_msg5",
			"mpd_pr_ase_autpg",
			"mpd_pr_ase_cc1",
			"mpd_pr_ase_cc2",
			"mpd_pr_ase_csel",
			"mpd_pr_ase_dist1",
			"mpd_pr_ase_dist2",
			"mpd_pr_ase_ijaut",
			"mpd_pr_ase_ijoff",
			"mpd_pr_ase_ijon",
			"mpd_pr_ase_rjaut",
			"mpd_pr_ase_rjoff",
			"mpd_pr_ase_rjon",
			"mpd_pr_ase_salvo",
			"mast",
			"longbow",
			"skin_pnvs",
			"skin_hstab",
			"twsus",
			"skin_alq1",
			"skin_alq2",
			"skin_cockpit",
			"skin_cockpitglass",
			"skin_fuse",
			"skin_fuse_ld",
			"skin_lefab",
			"skin_lelight",
			"skin_leng",
			"skin_lgear",
			"skin_lwing",
			"skin_m230",
			"skin_mainrotor",
			"skin_nose",
			"skin_pylon1",
			"skin_pylon2",
			"skin_pylon3",
			"skin_pylon4",
			"skin_refab",
			"skin_relight",
			"skin_reng",
			"skin_rgear",
			"skin_rwing",
			"skin_tads1",
			"skin_tads2",
			"skin_tads3",
			"skin_tailboom",
			"skin_tailboom_ld",
			"skin_tailrotor",
			"skin_vtail",
			"skin_refab_d_heavy",
			"skin_refab_d_cata",
			"skin_lefab_d_heavy",
			"skin_lefab_d_cata",
			"mpd_brt",
			"in_backlight",
			"in_backlight2",
			"in_lt_fire1",
			"in_lt_fire1rdy",
			"in_lt_fire2",
			"in_lt_fire2rdy",
			"in_lt_fireapu",
			"in_lt_fireapurdy",
			"in_lt_firepdis",
			"in_lt_firerdis",
			"in_lt_mstrcau",
			"in_lt_mstrwrn",
			"dam_fuse",
			"dam_gdoor",
			"dam_hstab",
			"dam_lefab",
			"dam_leng",
			"dam_lgear",
			"dam_lwing",
			"dam_nose",
			"dam_pdoor",
			"dam_pnvs",
			"dam_pylon1",
			"dam_pylon2",
			"dam_pylon3",
			"dam_pylon4",
			"dam_refab",
			"dam_reng",
			"dam_rgear",
			"dam_rwing",
			"dam_tads",
			"dam_tailboom",
			"dam_vtail",
			"mdam_fuse",
			"mdam_gdoor",
			"mdam_hstab",
			"mdam_lefab",
			"mdam_leng",
			"mdam_lgear",
			"mdam_lwing",
			"mdam_nose",
			"mdam_pdoor",
			"mdam_pnvs",
			"mdam_pylon1",
			"mdam_pylon2",
			"mdam_pylon3",
			"mdam_pylon4",
			"mdam_refab",
			"mdam_reng",
			"mdam_rgear",
			"mdam_rwing",
			"mdam_tads",
			"mdam_tailboom",
			"mdam_vtail",
			"tr_blades",
			"tr_blur",
			"mr_blades",
			"mr_blur",
			"mpd_pr_eng_back",
			"hdam_tr",
			"hdam_rtr",
			"skin_tailboom_tear"
};
		transportSoldier=2;
		cargoAction[]={"fza_ah64_leftcargo","fza_ah64_rightcargo"};
		accuracy=0.5;
		simulation=helicopterRTD;
		driverAction = "fza_ah64_pilot";
		//enableSweep=1;
		minMainRotorDive = 0;
		maxMainRotorDive = 0;
		neutralMainRotorDive = 0;
		minBackRotorDive = 0;
		maxBackRotorDive = 0;
		neutralBackRotorDive = 0;
		crewVulnerable = 0;
		gunnerUsesPilotView = false;
		commanderUsesPilotView = false;
		crew="B_Helipilot_F";
		memorypointdriveroptics[] = {"driverview", "pilot"};
		driveropticsmodel = "A3\Weapons_F\Reticle\Optics_Commander_01_w_F.p3d";
		driverOpticsColor[] = {1,1,1,1};
		//driverOpticsColor[] = {0.231,0.914,0.184,1};
		laserScanner=1;
		nightVision=1;
		mainRotorSpeed = 1;
		threat[] = {1,1,0.700000};
		//ARMOR VALUES
		armor=60;
		armorHull=0.5;
		armorEngine=0.6;
		armorAvionics=1.4;
		armorVRotor=0.5;
		armorHRotor=0.7;
		armorMissiles=1.6;
		armorGlass=1.0;
		//memorypointcmdir[] = {"chaff_launcher1_dir"};
		memorypointcm[] = {"chaff_launcher1"};
		memorypointcmdir[] = {"flare_1_end"};
		weapons[] = {"CMFlareLauncher"};
		magazines[] = {"60Rnd_CMFlare_Chaff_Magazine"};
		lockdetectionsystem = 8;
		incommingmissliedetectionsystem = 16;
		selectionHRotorStill = "velka vrtule staticka";
		selectionHRotorMove = "velka vrtule blur";
		selectionVRotorStill = "mala vrtule staticka";
		selectionVRotorMove = "mala vrtule blur";
		memoryPointLMissile = "l strela";
		memoryPointRMissile = "p strela";
		memoryPointLRocket = "l raketa";
		memoryPointRRocket = "p raketa";
		gunAimDown = 0;
		memoryPointsGetInDriver = "pos driver";
		memoryPointsGetInDriverDir = "pos driver dir";
		memoryPointsGetInCargo = "pos cargo";
		memoryPointsGetInCargoDir = "pos cargo dir";
		envelope[]=
		{
		0.0,0.6,1.6,3.2,3.8,5.0,5.25,5.4,5.6,5.7,5.8,5.9,6.0,4.0,1.5 // lift
		};
		/*
		class RenderTargets
		{
			class MFD1
			{
				rendertarget = "fza_ah64_pnvsrtarget0";
				class View01
				{
					fov = 0.2;
					pointdirection = "driverview_dir";
					pointposition = "driverview";
					renderquality = 0;
					rendervisionmode = 2;
				};
			};
		};
		*/

		class Turrets
		{
			class MainTurret: NewTurret
			{
				//gunnerAction = "fza_ah64_pilot";
				//gunnerInAction = "fza_ah64_pilot";
				gunnerAction = "fza_ah64_copilot"; 
				gunnerGetInAction = "GetInHigh";
				gunnerGetOutAction = "GetOutHigh";
				primary = 1;
				primaryGunner = 1;
				stabilizedInAxes = 3;
				//opticStabilized=1;
				//directionStabilized = 1;
				//horizontallyStabilized = 1;
				//weapons[] = {"fza_m230","fza_m261_14","fza_agm114_23_8"}; //DEFAULT LOADOUT 8xSAL2
				//magazines[] = {"fza_m230_1200","fza_m261_m151_14_38","fza_agm114k_23_8"}; //LOADOUT 4xRF + 4xSAL2
				//weapons[] = {"fza_m230","fza_m261_14","fza_atas_2","fza_agm114_3_4","fza_agm114_2_4"}; //LOADOUT 4xRF + 4xSAL2
				//magazines[] = {"fza_m230_1200","fza_m261_m151_14_38","fza_atas_2","fza_agm114k_3_4","fza_agm114l_2_4"}; //LOADOUT 4xRF + 4xSAL2
				//weapons[] = {"fza_m230","fza_m261_14","fza_atas_2","fza_agm114_3_ul","fza_agm114_3_ur","fza_agm114_3_ll","fza_agm114_3_lr","fza_agm114_2_ul","fza_agm114_2_ur","fza_agm114_2_ll","fza_agm114_2_lr"}; //LOADOUT DIAGONAL 4xRF + 4xSAL2
				//magazines[] = {"fza_m230_1200","fza_m261_m151_14_38","fza_atas_2","fza_agm114k_3_ul","fza_agm114k_3_lr","fza_agm114l_3_ur","fza_agm114l_3_ll","fza_agm114l_2_lr","fza_agm114l_2_ul","fza_agm114k_2_ll","fza_agm114k_2_ur"}; //LOADOUT DIAGONAL 4xRF + 4xSAL2
			    weapons[] = {"fza_m230","fza_m261_14","fza_agm114_3_ul","fza_agm114_3_ur","fza_agm114_3_ll","fza_agm114_3_lr","fza_agm114_2_ul","fza_agm114_2_ur","fza_agm114_2_ll","fza_agm114_2_lr"};
				magazines[] = {"fza_m230_1200","fza_m261_m151_14_38","fza_agm114k_3_ul","fza_agm114l_3_lr","fza_agm114k_3_ur","fza_agm114l_3_ll","fza_agm114l_2_lr","fza_agm114k_2_ul","fza_agm114l_2_ll","fza_agm114k_2_ur"};
				memoryPointsGetInGunner = "pos gunner";
			    memoryPointsGetInGunnerDir = "pos gunner dir";
			    memoryPointGun = "kulas";
				memoryPointGunnerOptics = "gunnerview";
				body = "mainTurret";
				gun = "mainGun";
				animationsourcebody = "tads_tur";
				animationsourcegun = "tads";
				gunnerOpticsModel = "";
				gunnerOpticsColor[] = {1,1,1,1};
				minElev = -60; 
				maxElev = 30;
				initElev= 0;
				minTurn = -120; 
				maxTurn = 120;
				initTurn = 0;
				minGunElev = -60;
				maxGunElev = 30;
				minGunTurn = -120;
				maxGunTurn = 120;
				minGunTurnAI = -120;
				maxGunTurnAI = 120;
				maxhorizontalrotspeed = 2;
				maxverticalrotspeed = 2;
				commanding = -1;
				gunnerForceOptics = 0;
				startEngine=0;
				outGunnerMayFire = 1;
				ejectdeadgunner = 0;
				viewgunnershadow = 1;
				viewgunnershadowamb = 1;
				viewgunnershadowdiff = 1;
				turretinfotype = "RscUnitInfoNoHUD";
				turretFollowFreeLook = 0;
				discretedistance[] = {1, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900, 3000};
				discretedistanceinitindex = 3;
				isCopilot = 1;
				usePiP=1;
				class HitPoints
				{
					class HitTurret
					{
						armor = 0.5;
						material = 51;
						name = "tads_tur";
						visual = "tads_tur";
						passThrough = 1;
					};
					class HitGun
					{
						armor = 1;
						material = 52;
						name = "tads";
						visual = "tads";
						passThrough = 1;
					};
				};
				class OpticsIn
				{
					class Wide
					{
						gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
						directionStabilized = 1;
						//stabilizedInAxes = 3;
						opticStabilized=1;
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
						visionmode[] = {"Normal","Ti","NVG"};
					};
					class Medium: Wide
					{
						gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
						directionStabilized = 1;
						stabilizedInAxes = 3;
						opticStabilized=1;
						initfov = 0.09;
						maxfov = 0.09;
						minfov = 0.09;
						opticsdisplayname = "M";
					};
					class Narrow: Wide
					{
						gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
						directionStabilized = 1;
						stabilizedInAxes = 3;
						opticStabilized=1;
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
						visionmode[] = {"Normal", "NVG"};
					};
				};
				class ViewGunner
				{
					initFov=0.7;
					minFov=0.400000;
					maxFov=0.7;
					initAngleX=0;
					minAngleX=-75;
					maxAngleX=75;
					initAngleY=0;
					minAngleY=-120;
					maxAngleY=120;
					maxmovex = 0.15;
					maxmovey = 0.1;
					maxmovez = 0.1;
					minmovex = -0.15;
					minmovey = -0.1;
					minmovez = -0.1;
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
		class ViewOptics
		{
			//aimingMarkElevSpeed = 0.5; //test
			//aimingMarkTurnSpeed = 0.5; //test
			stabilizedInAxes = 3;
			initAngleX=0;
			minAngleX=-90;
			maxAngleX=90;
			initAngleY=0;
			minAngleY=-45;
			maxAngleY=20;
			initFov=0.7;
			minFov=0.01; //test
			maxFov=0.7;
			thermalmode[] = {2};
			visionmode[] = {"Normal","Ti","NVG"};
		};
		class AnimationSources
		{
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
			initPhase=0;         
		};
		class m230_recoil
		{
			source = "reload";
			weapon = "fza_m230";
		};
		//EXPERIMENTAL//
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
			initPhase=0;
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
		//ENDEXPERIMENTAL//
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
/*
class blade1_rise1
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade1_rise2
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade1_rise3
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade1_rise4
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade1_rise5
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
*/
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
/*
class blade2_rise1
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade2_rise2
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade2_rise3
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade2_rise4
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade2_rise5
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
*/
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
/*
class blade3_rise1
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade3_rise2
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade3_rise3
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade3_rise4
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade3_rise5
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
*/
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
/*
class blade4_rise1
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade4_rise2
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade4_rise3
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade4_rise4
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
class blade4_rise5
{
source = "user";
animPeriod = 0.1;
initPhase=0;         
};
*/
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
		////////RADAR///////
		class longbow
		{
			source = "user";
			animPeriod = 0.01;
			initPhase=0;
		};
			////////////////////////////////
			///////////COCKPIT//////////////
			////////////////////////////////
			class plt_eng1_start
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
				sound = "eng1_start_sound";
            };
			class plt_eng2_start
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
				sound = "eng2_start_sound";
            };
			class plt_rtrbrake
            {
				source = "user";
				animPeriod = 0.001;
				initPhase=0;
				sound = "rtrbrake_sound";
            };
			class plt_eng1_throttle
            {
				source = "user";
				animPeriod = 1.5;
				initPhase=0;
            };
			class plt_eng2_throttle
            {
				source = "user";
				animPeriod = 1.5;
				initPhase=0;
            };
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
			/*
			class mpd_pr_eng_rtrrpm : mpd_pr_eng_1tgt
            {
                selection = "mpd_pr_eng_rtrrpm";
            };
			*/
		//////////////DOORS//////////////////
		class pdoor
		{
			source = "user";
			animPeriod = 1;
			initPhase=0;
		};
		class gdoor
		{
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
		class mpd_pr_fcraa_wiper
		{
			source = "user";
			animPeriod = 0.01;
			initPhase=0;
		};
		class mpd_pr_fcrag_wiper
		{
			source = "user";
			animPeriod = 0.01;
			initPhase=0;
		};
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
			
			class Attenuation {           
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
			
			/*class plt_light
			{         	
			name="plt_light";
			//ambient[] = {0.1,0.1,0.1};  			
			//color[] = {1,1,1};
			color[]={0.306,0.878,0.349,1};
			ambient[]={0.306,0.878,0.349,1};			
			intensity=40;			
			drawLightSize = 0.01;
			drawLightCenterSize = 0.001; 	    
			blinking = 0;                
			class Attenuation {
			constant = 0;
			hardLimitEnd = 1;
			hardLimitStart = 0.20;
			linear = 25;
			quadratic = 50;
			start = 0;
        };
			}; */    
			
			class ckpt_light
			{         	
			name="ckpt_light";
			//ambient[] = {0.1,0.1,0.1};  			
			//color[] = {1,1,1};
			color[]={0.306,0.878,0.349,1};
			ambient[]={0.306,0.878,0.349,1};			
			intensity=20;			
			drawLightSize = 0.01;
			drawLightCenterSize = 0.001; 	    
			blinking = 0;                
			class Attenuation {
			constant = 0;
			hardLimitEnd = 0.60;
			hardLimitStart = 0.20;
			linear = 25;
			quadratic = 50;
			start = 0;
        };
			};   
			
			/*class RedBlinking
			{
				name="bily pozicni blik";
				color[]={0.89999998,0.15000001,0.1};
				ambient[]={0.090000004,0.015,0.0099999998};
				intensity=150;
				blinking=1;
				blinkingPattern[] = {0.1,1.3}; 
				blinkingPatternGuarantee=0;
				drawLightSize=0.50;
				drawLightCenterSize=0.039999999;
			};*/
			
			class WhiteBlinking1 
			{          	
			name="cerveny pozicni blik_1";
			//ambient[] = {0.1,0.1,0.1};  			
			//color[] = {1,1,1};
			color[]={0.89999998,0.15000001,0.1};
			ambient[]={0.090000004,0.015,0.0099999998};			
			intensity=2500;			
			drawLightSize = 0.50;
			drawLightCenterSize = 0.16; 	    
			blinking = 1;         
			blinkingPattern[]={0.03,2.10};   
			blinkingPatternGuarantee = 1;
			daylight = 1; //added
			};    

			class WhiteBlinking2 
			{         	
			name="cerveny pozicni blik_2";
			//ambient[] = {0.1,0.1,0.1};  			
			//color[] = {1,1,1};
			color[]={0.89999998,0.15000001,0.1};
			ambient[]={0.090000004,0.015,0.0099999998};			
			intensity=2500;			
			drawLightSize = 0.50;
			drawLightCenterSize = 0.16; 	    
			blinking = 1;         
			blinkingPattern[]={0.03,2};   
			blinkingPatternGuarantee = 1; 
			daylight = 1;		//added	
			};     			
			};
		class Reflectors 
		{

			class Right {
				
				position = "landing_light";
				direction = "Light_dir";
				hitpoint = "Light_hitpoint";
				selection = "Light";
				//direction = "light_1_dir";
				//hitpoint = "L svetlo";
				//selection = "L svetlo";
				color[] = {0.850000, 0.950000, 1.000000};
				ambient[] = {0.008500, 0.009500, 0.010000};
				intensity = 100000;
				size = 1;
				innerAngle = 15;
				outerAngle = 90;
				coneFadeCoef = 5;
				useFlare = 1;
				flareSize = 1.500000;
				flareMaxDistance = 500;
				daylight = 1;		//added	
				
				/*color[] = {7000,7500,10000};
				ambient[] = {70,75,100};
				intensity = 50;
				size = 1;
				innerAngle = 15;
				outerAngle = 65;
				coneFadeCoef = 10;
				useFlare = 1;
				flareSize = 10;
				flareMaxDistance = 250;
				dayLight = 0;
				position = "landing_light";
				direction = "Light_dir";
				hitpoint = "Light_hitpoint";
				selection = "Light";*/

				class Attenuation {
					start = 0;
					constant = 0;
					linear = 1;
					quadratic = 1;
					hardLimitStart = 100;
					hardLimitEnd = 200;
				};
			};
		};
		/*class AcreRacks 
		{
           class Rack_1 {
               displayName = "Dash"; // Name is displayed in the interaction menu.
               componentName = "ACRE_VRC103";
               allowedPositions[] = {"driver", "copilot"}; // Who has access. "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
               disabledPositions[] = {};
               defaultComponents[] = {};
               mountedRadio = "ACRE_PRC117F";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {"intercom_1"};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
           };
       };*/
	};
	class fza_ah64d_b2e_nr: fza_ah64d_b2e
	{
		side=1;				
		scope=2; //UNMASKED FROM EDITOR
		author="Franze, Nodunit, Sacha 'Voodoo' Oropeza & Community";
		displayName="AH-64D Apache";
		hiddenselections[]=
		{
			"pod1_m151_1",
			"pod1_m151_2",
			"pod1_m151_3",
			"pod1_m151_4",
			"pod1_m151_5",
			"pod1_m151_6",
			"pod1_m151_7",
			"pod1_m151_8",
			"pod1_m151_9",
			"pod1_m151_10",
			"pod1_m151_11",
			"pod1_m151_12",
			"pod1_m151_13",
			"pod1_m151_14",
			"pod1_m151_15",
			"pod1_m151_16",
			"pod1_m151_17",
			"pod1_m151_18",
			"pod1_m151_19",
			"pod1_m229_1",
			"pod1_m229_2",
			"pod1_m229_3",
			"pod1_m229_4",
			"pod1_m229_5",
			"pod1_m229_6",
			"pod1_m229_7",
			"pod1_m229_8",
			"pod1_m229_9",
			"pod1_m229_10",
			"pod1_m229_11",
			"pod1_m229_12",
			"pod1_m229_13",
			"pod1_m229_14",
			"pod1_m229_15",
			"pod1_m229_16",
			"pod1_m229_17",
			"pod1_m229_18",
			"pod1_m229_19",
			"pod1_m261_1",
			"pod1_m261_2",
			"pod1_m261_3",
			"pod1_m261_4",
			"pod1_m261_5",
			"pod1_m261_6",
			"pod1_m261_7",
			"pod1_m261_8",
			"pod1_m261_9",
			"pod1_m261_10",
			"pod1_m261_11",
			"pod1_m261_12",
			"pod1_m261_13",
			"pod1_m261_14",
			"pod1_m261_15",
			"pod1_m261_16",
			"pod1_m261_17",
			"pod1_m261_18",
			"pod1_m261_19",
			"pod2_m151_1",
			"pod2_m151_2",
			"pod2_m151_3",
			"pod2_m151_4",
			"pod2_m151_5",
			"pod2_m151_6",
			"pod2_m151_7",
			"pod2_m151_8",
			"pod2_m151_9",
			"pod2_m151_10",
			"pod2_m151_11",
			"pod2_m151_12",
			"pod2_m151_13",
			"pod2_m151_14",
			"pod2_m151_15",
			"pod2_m151_16",
			"pod2_m151_17",
			"pod2_m151_18",
			"pod2_m151_19",
			"pod2_m229_1",
			"pod2_m229_2",
			"pod2_m229_3",
			"pod2_m229_4",
			"pod2_m229_5",
			"pod2_m229_6",
			"pod2_m229_7",
			"pod2_m229_8",
			"pod2_m229_9",
			"pod2_m229_10",
			"pod2_m229_11",
			"pod2_m229_12",
			"pod2_m229_13",
			"pod2_m229_14",
			"pod2_m229_15",
			"pod2_m229_16",
			"pod2_m229_17",
			"pod2_m229_18",
			"pod2_m229_19",
			"pod2_m261_1",
			"pod2_m261_2",
			"pod2_m261_3",
			"pod2_m261_4",
			"pod2_m261_5",
			"pod2_m261_6",
			"pod2_m261_7",
			"pod2_m261_8",
			"pod2_m261_9",
			"pod2_m261_10",
			"pod2_m261_11",
			"pod2_m261_12",
			"pod2_m261_13",
			"pod2_m261_14",
			"pod2_m261_15",
			"pod2_m261_16",
			"pod2_m261_17",
			"pod2_m261_18",
			"pod2_m261_19",
			"pod3_m151_1",
			"pod3_m151_2",
			"pod3_m151_3",
			"pod3_m151_4",
			"pod3_m151_5",
			"pod3_m151_6",
			"pod3_m151_7",
			"pod3_m151_8",
			"pod3_m151_9",
			"pod3_m151_10",
			"pod3_m151_11",
			"pod3_m151_12",
			"pod3_m151_13",
			"pod3_m151_14",
			"pod3_m151_15",
			"pod3_m151_16",
			"pod3_m151_17",
			"pod3_m151_18",
			"pod3_m151_19",
			"pod3_m229_1",
			"pod3_m229_2",
			"pod3_m229_3",
			"pod3_m229_4",
			"pod3_m229_5",
			"pod3_m229_6",
			"pod3_m229_7",
			"pod3_m229_8",
			"pod3_m229_9",
			"pod3_m229_10",
			"pod3_m229_11",
			"pod3_m229_12",
			"pod3_m229_13",
			"pod3_m229_14",
			"pod3_m229_15",
			"pod3_m229_16",
			"pod3_m229_17",
			"pod3_m229_18",
			"pod3_m229_19",
			"pod3_m261_1",
			"pod3_m261_2",
			"pod3_m261_3",
			"pod3_m261_4",
			"pod3_m261_5",
			"pod3_m261_6",
			"pod3_m261_7",
			"pod3_m261_8",
			"pod3_m261_9",
			"pod3_m261_10",
			"pod3_m261_11",
			"pod3_m261_12",
			"pod3_m261_13",
			"pod3_m261_14",
			"pod3_m261_15",
			"pod3_m261_16",
			"pod3_m261_17",
			"pod3_m261_18",
			"pod3_m261_19",
			"pod4_m151_1",
			"pod4_m151_2",
			"pod4_m151_3",
			"pod4_m151_4",
			"pod4_m151_5",
			"pod4_m151_6",
			"pod4_m151_7",
			"pod4_m151_8",
			"pod4_m151_9",
			"pod4_m151_10",
			"pod4_m151_11",
			"pod4_m151_12",
			"pod4_m151_13",
			"pod4_m151_14",
			"pod4_m151_15",
			"pod4_m151_16",
			"pod4_m151_17",
			"pod4_m151_18",
			"pod4_m151_19",
			"pod4_m229_1",
			"pod4_m229_2",
			"pod4_m229_3",
			"pod4_m229_4",
			"pod4_m229_5",
			"pod4_m229_6",
			"pod4_m229_7",
			"pod4_m229_8",
			"pod4_m229_9",
			"pod4_m229_10",
			"pod4_m229_11",
			"pod4_m229_12",
			"pod4_m229_13",
			"pod4_m229_14",
			"pod4_m229_15",
			"pod4_m229_16",
			"pod4_m229_17",
			"pod4_m229_18",
			"pod4_m229_19",
			"pod4_m261_1",
			"pod4_m261_2",
			"pod4_m261_3",
			"pod4_m261_4",
			"pod4_m261_5",
			"pod4_m261_6",
			"pod4_m261_7",
			"pod4_m261_8",
			"pod4_m261_9",
			"pod4_m261_10",
			"pod4_m261_11",
			"pod4_m261_12",
			"pod4_m261_13",
			"pod4_m261_14",
			"pod4_m261_15",
			"pod4_m261_16",
			"pod4_m261_17",
			"pod4_m261_18",
			"pod4_m261_19",
			"rail1_114l_1",
			"rail1_114l_2",
			"rail1_114l_3",
			"rail1_114l_4",
			"rail1_114k_1",
			"rail1_114k_2",
			"rail1_114k_3",
			"rail1_114k_4",
			"rail2_114l_1",
			"rail2_114l_2",
			"rail2_114l_3",
			"rail2_114l_4",
			"rail2_114k_1",
			"rail2_114k_2",
			"rail2_114k_3",
			"rail2_114k_4",
			"rail3_114l_1",
			"rail3_114l_2",
			"rail3_114l_3",
			"rail3_114l_4",
			"rail3_114k_1",
			"rail3_114k_2",
			"rail3_114k_3",
			"rail3_114k_4",
			"rail4_114l_1",
			"rail4_114l_2",
			"rail4_114l_3",
			"rail4_114l_4",
			"rail4_114k_1",
			"rail4_114k_2",
			"rail4_114k_3",
			"rail4_114k_4",
			"atas_1",
			"atas_2",
			"fim92_1",
			"fim92_2",
			"fim92_3",
			"fim92_4",
			"auxtank_1",
			"auxtank_2",
			"auxtank_3",
			"auxtank_4",
			"mpd_pl_obj1",
			"mpd_pl_obj2",
			"mpd_pl_obj3",
			"mpd_pl_obj4",
			"mpd_pl_obj5",
			"mpd_pl_obj6",
			"mpd_pl_obj7",
			"mpd_pl_obj8",
			"mpd_pl_obj9",
			"mpd_pl_obj10",
			"mpd_pl_obj11",
			"mpd_pl_obj12",
			"mpd_pl_obj13",
			"mpd_pl_obj14",
			"mpd_pl_obj15",
			"mpd_pl_obj16",
			"mpd_pl_obj17",
			"mpd_pl_obj18",
			"mpd_pl_obj19",
			"mpd_pl_obj20",
			"mpd_pl_obj21",
			"mpd_pl_obj22",
			"mpd_pl_obj23",
			"mpd_pl_obj24",
			"mpd_pl_obj25",
			"mpd_pl_obj26",
			"mpd_pl_obj27",
			"mpd_pl_obj28",
			"mpd_pl_obj29",
			"mpd_pl_obj30",
			"mpd_pl_obj31",
			"mpd_pl_obj32",
			"pl_mpd_back",
			"pr_mpd_back",
			"pl_aft_fuel_n0",
			"pl_aft_fuel_n1",
			"pl_aft_fuel_n2",
			"pl_aft_fuel_n3",
			"pl_aft_line",
			"pl_flow1_fuel_n0",
			"pl_flow1_fuel_n1",
			"pl_flow1_fuel_n2",
			"pl_flow2_fuel_n0",
			"pl_flow2_fuel_n1",
			"pl_flow2_fuel_n2",
			"pl_fwd_fuel_n0",
			"pl_fwd_fuel_n1",
			"pl_fwd_fuel_n2",
			"pl_fwd_fuel_n3",
			"pl_fwd_line",
			"pl_iafs_fuel_n0",
			"pl_iafs_fuel_n1",
			"pl_iafs_fuel_n2",
			"pl_iend_fuel_n0",
			"pl_iend_fuel_n1",
			"pl_iend_fuel_n2",
			"pl_int_fuel_n0",
			"pl_int_fuel_n1",
			"pl_int_fuel_n2",
			"pl_int_fuel_n3",
			"pl_tend_fuel_n0",
			"pl_tend_fuel_n1",
			"pl_tend_fuel_n2",
			"pl_tflow_fuel_n0",
			"pl_tflow_fuel_n1",
			"pl_tflow_fuel_n2",
			"pl_tot_fuel_n0",
			"pl_tot_fuel_n1",
			"pl_tot_fuel_n2",
			"pl_tot_fuel_n3",
			"pl_waux1",
			"pl_waux2",
			"pl_waux3",
			"pl_waux4",
			"pr_aft_fuel_n0",
			"pr_aft_fuel_n1",
			"pr_aft_fuel_n2",
			"pr_aft_fuel_n3",
			"pr_aft_line",
			"pr_flow1_fuel_n0",
			"pr_flow1_fuel_n1",
			"pr_flow1_fuel_n2",
			"pr_flow2_fuel_n0",
			"pr_flow2_fuel_n1",
			"pr_flow2_fuel_n2",
			"pr_fwd_fuel_n0",
			"pr_fwd_fuel_n1",
			"pr_fwd_fuel_n2",
			"pr_fwd_fuel_n3",
			"pr_fwd_line",
			"pr_iafs_fuel_n0",
			"pr_iafs_fuel_n1",
			"pr_iafs_fuel_n2",
			"pr_iend_fuel_n0",
			"pr_iend_fuel_n1",
			"pr_iend_fuel_n2",
			"pr_int_fuel_n0",
			"pr_int_fuel_n1",
			"pr_int_fuel_n2",
			"pr_int_fuel_n3",
			"pr_tend_fuel_n0",
			"pr_tend_fuel_n1",
			"pr_tend_fuel_n2",
			"pr_tflow_fuel_n0",
			"pr_tflow_fuel_n1",
			"pr_tflow_fuel_n2",
			"pr_tot_fuel_n0",
			"pr_tot_fuel_n1",
			"pr_tot_fuel_n2",
			"pr_tot_fuel_n3",
			"pr_waux1",
			"pr_waux2",
			"pr_waux3",
			"pr_waux4",
			"pr_iafs_line",
			"pl_iafs_line",
			"mpd_pr_tsd_wtdir1",
			"mpd_pr_tsd_wtdir2",
			"mpd_pr_tsd_wtdir3",
			"mpd_pr_tsd_eta1",
			"mpd_pr_tsd_eta2",
			"mpd_pr_tsd_eta3",
			"mpd_pr_tsd_eta4",
			"mpd_pr_tsd_hdg1",
			"mpd_pr_tsd_hdg2",
			"mpd_pr_tsd_hdg3",
			"mpd_pr_tsd_dist2",
			"mpd_pr_tsd_dist3",
			"mpd_pr_tsd_dist4",
			"mpd_pr_tsd_z1",
			"mpd_pr_tsd_z2",
			"mpd_pr_tsd_pfzs",
			"mpd_pr_tsd_filter",
			"mpd_pr_tsd_acq",
			"mpd_pr_tsd_wdir1",
			"mpd_pr_tsd_wdir2",
			"mpd_pr_tsd_wdir3",
			"mpd_pr_tsd_wv1",
			"mpd_pr_tsd_wv2",
			"mpd_pl_tsd_wtdir1",
			"mpd_pl_tsd_wtdir2",
			"mpd_pl_tsd_wtdir3",
			"mpd_pl_tsd_eta1",
			"mpd_pl_tsd_eta2",
			"mpd_pl_tsd_eta3",
			"mpd_pl_tsd_eta4",
			"mpd_pl_tsd_hdg1",
			"mpd_pl_tsd_hdg2",
			"mpd_pl_tsd_hdg3",
			"mpd_pl_tsd_dist2",
			"mpd_pl_tsd_dist3",
			"mpd_pl_tsd_dist4",
			"mpd_pl_tsd_z1",
			"mpd_pl_tsd_z2",
			"mpd_pl_tsd_pfzs",
			"mpd_pl_tsd_filter",
			"mpd_pl_tsd_acq",
			"mpd_pl_tsd_wdir1",
			"mpd_pl_tsd_wdir2",
			"mpd_pl_tsd_wdir3",
			"mpd_pl_tsd_wv1",
			"mpd_pl_tsd_wv2",
			"ufd_back",
			"in_lt_apu",
			"gl_tsd_end3",
			"gl_tsd_eta1",
			"gl_tsd_eta2",
			"gl_tsd_eta3",
			"gl_tsd_eta4",
			"gl_tsd_hdg1",
			"gl_tsd_hdg2",
			"gl_tsd_hdg3",
			"gl_tsd_rng1",
			"gl_tsd_rng2",
			"gl_tsd_rng3",
			"gl_tsd_scale1",
			"gl_tsd_scale2",
			"gl_tsd_typ1",
			"gl_tsd_typ2",
			"gl_tsd_typ3",
			"gl_tsd_winddir1",
			"gl_tsd_winddir2",
			"gl_tsd_winddir3",
			"gl_tsd_windspd1",
			"gl_tsd_windspd2",
			"gr_tsd_end1",
			"gr_tsd_end2",
			"gr_tsd_end3",
			"gr_tsd_eta1",
			"gr_tsd_eta2",
			"gr_tsd_eta3",
			"gr_tsd_eta4",
			"gr_tsd_hdg1",
			"gr_tsd_hdg2",
			"gr_tsd_hdg3",
			"gr_tsd_rng1",
			"gr_tsd_rng2",
			"gr_tsd_rng3",
			"gr_tsd_scale1",
			"gr_tsd_scale2",
			"gr_tsd_typ1",
			"gr_tsd_typ2",
			"gr_tsd_typ3",
			"gr_tsd_winddir1",
			"gr_tsd_winddir2",
			"gr_tsd_winddir3",
			"gr_tsd_windspd1",
			"gr_tsd_windspd2",
			"mpd_pl_chaff_qty_1",
			"mpd_pl_chaff_qty_2",
			"mpd_pl_flare1_qty_1",
			"mpd_pl_flare1_qty_2",
			"mpd_pl_flare2_qty_1",
			"mpd_pl_flare2_qty_2",
			"mpd_pl_gun_ammo_1",
			"mpd_pl_gun_ammo_2",
			"mpd_pl_gun_ammo_3",
			"mpd_pl_gun_ammo_4",
			"mpd_pl_gun_burst_1",
			"mpd_pl_gun_burst_2",
			"mpd_pl_gun_burst_3",
			"mpd_pl_gun_burst_4",
			"mpd_pl_gun_burst_5",
			"mpd_pl_gun_sel",
			"mpd_pl_hf_bracket",
			"mpd_pl_hf_desig",
			"mpd_pl_hf_salt",
			"mpd_pl_hf_traj",
			"mpd_pl_hf1_l1",
			"mpd_pl_hf1_l2",
			"mpd_pl_hf1_r1",
			"mpd_pl_hf1_r2",
			"mpd_pl_hf2_l1",
			"mpd_pl_hf2_l2",
			"mpd_pl_hf2_r1",
			"mpd_pl_hf2_r2",
			"mpd_pl_hf3_l1",
			"mpd_pl_hf3_l2",
			"mpd_pl_hf3_r1",
			"mpd_pl_hf3_r2",
			"mpd_pl_hf4_l1",
			"mpd_pl_hf4_l2",
			"mpd_pl_hf4_r1",
			"mpd_pl_hf4_r2",
			"mpd_pl_rg_base",
			"mpd_pl_rg_bracket",
			"mpd_pl_rkt_burst",
			"mpd_pl_rkt_sel_type_1",
			"mpd_pl_rkt_sel_type_2",
			"mpd_pl_rkt_sel_type_3",
			"mpd_pl_rkt_sel_type_4",
			"mpd_pl_rkt_tot_1",
			"mpd_pl_rkt_tot_2",
			"mpd_pl_rkt1_qty_1",
			"mpd_pl_rkt1_qty_2",
			"mpd_pl_rkt1_type",
			"mpd_pl_rkt2_qty_1",
			"mpd_pl_rkt2_qty_2",
			"mpd_pl_rkt2_type",
			"mpd_pl_rkt3_qty_1",
			"mpd_pl_rkt3_qty_2",
			"mpd_pl_rkt3_type",
			"mpd_pl_rkt4_qty_1",
			"mpd_pl_rkt4_qty_2",
			"mpd_pl_rkt4_type",
			"mpd_pl_rkt5_qty_1",
			"mpd_pl_rkt5_qty_2",
			"mpd_pl_rkt5_type",
			"mpd_pl_sight_acq",
			"mpd_pl_wpn_acq",
			"mpd_pl_wpn_ata_sel",
			"mpd_pl_wpn_gun_sel",
			"mpd_pl_wpn_hf_type",
			"mpd_pl_wpn_msl_sel",
			"mpd_pl_wpn_rkt_sel",
			"mpd_pl_wpn_sel",
			"mpd_pl_rkt1",
			"mpd_pl_rkt2",
			"mpd_pl_rkt3",
			"mpd_pl_rkt4",
			"pr_wca_pg",
			"pr_wca_1",
			"pr_wca_2",
			"pr_wca_3",
			"pr_wca_4",
			"pr_wca_5",
			"pr_wca_6",
			"pr_wca_7",
			"pr_wca_8",
			"pr_wca_9",
			"pr_wca_10",
			"pr_wca_11",
			"pr_wca_12",
			"pr_wca_13",
			"pr_wca_14",
			"pr_wca_15",
			"pr_wca_16",
			"pr_wca_17",
			"pr_wca_18",
			"pr_wca_19",
			"pr_wca_20",
			"pr_wca_21",
			"pr_wca_22",
			"pr_wca_23",
			"pr_wca_24",
			"pr_wca_25",
			"pr_wca_26",
			"pl_wca_pg",
			"pl_wca_1",
			"pl_wca_2",
			"pl_wca_3",
			"pl_wca_4",
			"pl_wca_5",
			"pl_wca_6",
			"pl_wca_7",
			"pl_wca_8",
			"pl_wca_9",
			"pl_wca_10",
			"pl_wca_11",
			"pl_wca_12",
			"pl_wca_13",
			"pl_wca_14",
			"pl_wca_15",
			"pl_wca_16",
			"pl_wca_17",
			"pl_wca_18",
			"pl_wca_19",
			"pl_wca_20",
			"pl_wca_21",
			"pl_wca_22",
			"pl_wca_23",
			"pl_wca_24",
			"pl_wca_25",
			"pl_wca_26",
			"gr_wca_pg",
			"gr_wca_1",
			"gr_wca_2",
			"gr_wca_3",
			"gr_wca_4",
			"gr_wca_5",
			"gr_wca_6",
			"gr_wca_7",
			"gr_wca_8",
			"gr_wca_9",
			"gr_wca_10",
			"gr_wca_11",
			"gr_wca_12",
			"gr_wca_13",
			"gr_wca_14",
			"gr_wca_15",
			"gr_wca_16",
			"gr_wca_17",
			"gr_wca_18",
			"gr_wca_19",
			"gr_wca_20",
			"gr_wca_21",
			"gr_wca_22",
			"gr_wca_23",
			"gr_wca_24",
			"gr_wca_25",
			"gr_wca_26",
			"gl_wca_pg",
			"gl_wca_1",
			"gl_wca_2",
			"gl_wca_3",
			"gl_wca_4",
			"gl_wca_5",
			"gl_wca_6",
			"gl_wca_7",
			"gl_wca_8",
			"gl_wca_9",
			"gl_wca_10",
			"gl_wca_11",
			"gl_wca_12",
			"gl_wca_13",
			"gl_wca_14",
			"gl_wca_15",
			"gl_wca_16",
			"gl_wca_17",
			"gl_wca_18",
			"gl_wca_19",
			"gl_wca_20",
			"gl_wca_21",
			"gl_wca_22",
			"gl_wca_23",
			"gl_wca_24",
			"gl_wca_25",
			"gl_wca_26",
			"mpd_pr_flt_balt1",
			"mpd_pr_flt_balt2",
			"mpd_pr_flt_balt3",
			"mpd_pr_flt_balt4",
			"mpd_pr_flt_bank",
			"mpd_pr_flt_gspd1",
			"mpd_pr_flt_gspd2",
			"mpd_pr_flt_gspd3",
			"mpd_pr_flt_hdg",
			"mpd_pr_flt_hdg2",
			"mpd_pr_flt_hi",
			"mpd_pr_flt_hor",
			"mpd_pr_flt_lo",
			"mpd_pr_flt_n20c",
			"mpd_pr_flt_p20c",
			"mpd_pr_flt_ralt1",
			"mpd_pr_flt_ralt2",
			"mpd_pr_flt_ralt3",
			"mpd_pr_flt_raltb",
			"mpd_pr_flt_rdr",
			"mpd_pr_flt_slip",
			"mpd_pr_flt_spd1",
			"mpd_pr_flt_spd2",
			"mpd_pr_flt_spd3",
			"mpd_pr_flt_trq1",
			"mpd_pr_flt_trq2",
			"mpd_pr_flt_trq3",
			"mpd_pr_flt_ttg1",
			"mpd_pr_flt_ttg2",
			"mpd_pr_flt_ttg3",
			"mpd_pr_flt_ttg4",
			"mpd_pr_flt_turn",
			"mpd_pr_flt_vsi",
			"mpd_pr_flt_vvi",
			"mpd_pr_flt_w",
			"mpd_pr_flt_wbear",
			"mpd_pr_flt_wp",
			"mpd_pr_flt_wr1",
			"mpd_pr_flt_wr2",
			"mpd_pr_flt_wr3",
			"mpd_pl_flt_balt1",
			"mpd_pl_flt_balt2",
			"mpd_pl_flt_balt3",
			"mpd_pl_flt_balt4",
			"mpd_pl_flt_bank",
			"mpd_pl_flt_gspd1",
			"mpd_pl_flt_gspd2",
			"mpd_pl_flt_gspd3",
			"mpd_pl_flt_hdg",
			"mpd_pl_flt_hdg2",
			"mpd_pl_flt_hi",
			"mpd_pl_flt_hor",
			"mpd_pl_flt_lo",
			"mpd_pl_flt_n20c",
			"mpd_pl_flt_p20c",
			"mpd_pl_flt_ralt1",
			"mpd_pl_flt_ralt2",
			"mpd_pl_flt_ralt3",
			"mpd_pl_flt_raltb",
			"mpd_pl_flt_rdr",
			"mpd_pl_flt_slip",
			"mpd_pl_flt_spd1",
			"mpd_pl_flt_spd2",
			"mpd_pl_flt_spd3",
			"mpd_pl_flt_trq1",
			"mpd_pl_flt_trq2",
			"mpd_pl_flt_trq3",
			"mpd_pl_flt_ttg1",
			"mpd_pl_flt_ttg2",
			"mpd_pl_flt_ttg3",
			"mpd_pl_flt_ttg4",
			"mpd_pl_flt_turn",
			"mpd_pl_flt_vsi",
			"mpd_pl_flt_vvi",
			"mpd_pl_flt_w",
			"mpd_pl_flt_wbear",
			"mpd_pl_flt_wp",
			"mpd_pl_flt_wr1",
			"mpd_pl_flt_wr2",
			"mpd_pl_flt_wr3",
			"mpd_gl_flt_balt1",
			"mpd_gl_flt_balt2",
			"mpd_gl_flt_balt3",
			"mpd_gl_flt_balt4",
			"mpd_gl_flt_bank",
			"mpd_gl_flt_gspd1",
			"mpd_gl_flt_gspd2",
			"mpd_gl_flt_gspd3",
			"mpd_gl_flt_hdg",
			"mpd_gl_flt_hdg2",
			"mpd_gl_flt_hi",
			"mpd_gl_flt_hor",
			"mpd_gl_flt_lo",
			"mpd_gl_flt_n20c",
			"mpd_gl_flt_p20c",
			"mpd_gl_flt_ralt1",
			"mpd_gl_flt_ralt2",
			"mpd_gl_flt_ralt3",
			"mpd_gl_flt_raltb",
			"mpd_gl_flt_rdr",
			"mpd_gl_flt_slip",
			"mpd_gl_flt_spd1",
			"mpd_gl_flt_spd2",
			"mpd_gl_flt_spd3",
			"mpd_gl_flt_trq1",
			"mpd_gl_flt_trq2",
			"mpd_gl_flt_trq3",
			"mpd_gl_flt_ttg1",
			"mpd_gl_flt_ttg2",
			"mpd_gl_flt_ttg3",
			"mpd_gl_flt_ttg4",
			"mpd_gl_flt_turn",
			"mpd_gl_flt_vsi",
			"mpd_gl_flt_vvi",
			"mpd_gl_flt_w",
			"mpd_gl_flt_wbear",
			"mpd_gl_flt_wp",
			"mpd_gl_flt_wr1",
			"mpd_gl_flt_wr2",
			"mpd_gl_flt_wr3",
			"mpd_gr_flt_balt1",
			"mpd_gr_flt_balt2",
			"mpd_gr_flt_balt3",
			"mpd_gr_flt_balt4",
			"mpd_gr_flt_bank",
			"mpd_gr_flt_gspd1",
			"mpd_gr_flt_gspd2",
			"mpd_gr_flt_gspd3",
			"mpd_gr_flt_hdg",
			"mpd_gr_flt_hdg2",
			"mpd_gr_flt_hi",
			"mpd_gr_flt_hor",
			"mpd_gr_flt_lo",
			"mpd_gr_flt_n20c",
			"mpd_gr_flt_p20c",
			"mpd_gr_flt_ralt1",
			"mpd_gr_flt_ralt2",
			"mpd_gr_flt_ralt3",
			"mpd_gr_flt_raltb",
			"mpd_gr_flt_rdr",
			"mpd_gr_flt_slip",
			"mpd_gr_flt_spd1",
			"mpd_gr_flt_spd2",
			"mpd_gr_flt_spd3",
			"mpd_gr_flt_trq1",
			"mpd_gr_flt_trq2",
			"mpd_gr_flt_trq3",
			"mpd_gr_flt_ttg1",
			"mpd_gr_flt_ttg2",
			"mpd_gr_flt_ttg3",
			"mpd_gr_flt_ttg4",
			"mpd_gr_flt_turn",
			"mpd_gr_flt_vsi",
			"mpd_gr_flt_vvi",
			"mpd_gr_flt_w",
			"mpd_gr_flt_wbear",
			"mpd_gr_flt_wp",
			"mpd_gr_flt_wr1",
			"mpd_gr_flt_wr2",
			"mpd_gr_flt_wr3",
			"mpd_pr_flt_dir1",
			"mpd_pr_flt_dir2",
			"mpd_pr_flt_dir3",
			"mpd_pr_flt_dirb",
			"mpd_pl_flt_dir1",
			"mpd_pl_flt_dir2",
			"mpd_pl_flt_dir3",
			"mpd_pl_flt_dirb",
			"mpd_gr_flt_dir1",
			"mpd_gr_flt_dir2",
			"mpd_gr_flt_dir3",
			"mpd_gr_flt_dirb",
			"mpd_gl_flt_dir1",
			"mpd_gl_flt_dir2",
			"mpd_gl_flt_dir3",
			"mpd_gl_flt_dirb",
			"mpd_pr_eng_1npb",
			"mpd_pr_eng_1tgt_1",
			"mpd_pr_eng_1tgt1",
			"mpd_pr_eng_1tgt2",
			"mpd_pr_eng_1tgt3",
			"mpd_pr_eng_1tgtb",
			"mpd_pr_eng_1tgtbg",
			"mpd_pr_eng_2npb",
			"mpd_pr_eng_2tgt_1",
			"mpd_pr_eng_2tgt1",
			"mpd_pr_eng_2tgt2",
			"mpd_pr_eng_2tgt3",
			"mpd_pr_eng_2tgtb",
			"mpd_pr_eng_2tgtbg",
			"mpd_pr_eng_1trq1",
			"mpd_pr_eng_1trq2",
			"mpd_pr_eng_1trqb",
			"mpd_pr_eng_1trqbg",
			"mpd_pr_eng_2trq1",
			"mpd_pr_eng_2trq2",
			"mpd_pr_eng_2trqb",
			"mpd_pr_eng_2trqbg",
			"mpd_pr_eng_ltrqbar",
			"mpd_pr_eng_accpsi1",
			"mpd_pr_eng_accpsi2",
			"mpd_pr_eng_accpsi3",
			"mpd_pr_eng_accpsi4",
			"mpd_pr_eng_utipsi1",
			"mpd_pr_eng_utipsi2",
			"mpd_pr_eng_utipsi3",
			"mpd_pr_eng_utipsi4",
			"mpd_pr_eng_pripsi1",
			"mpd_pr_eng_pripsi2",
			"mpd_pr_eng_pripsi3",
			"mpd_pr_eng_pripsi4",
			"mpd_pr_eng_e1ng1",
			"mpd_pr_eng_e1ng2",
			"mpd_pr_eng_e1ng3",
			"mpd_pr_eng_e2ng1",
			"mpd_pr_eng_e2ng2",
			"mpd_pr_eng_e2ng3",
			"mpd_pr_eng_e1np1",
			"mpd_pr_eng_e1np2",
			"mpd_pr_eng_e1np3",
			"mpd_pr_eng_e2np1",
			"mpd_pr_eng_e2np2",
			"mpd_pr_eng_e2np3",
			"mpd_pr_eng_oil1psi1",
			"mpd_pr_eng_oil1psi2",
			"mpd_pr_eng_oil1psi3",
			"mpd_pr_eng_oil2psi1",
			"mpd_pr_eng_oil2psi2",
			"mpd_pr_eng_oil2psi3",
			"mpd_pr_eng_rrpm1",
			"mpd_pr_eng_rrpm2",
			"mpd_pr_eng_rrpm3",
			"mpd_pr_eng_wca1",
			"mpd_pr_eng_wca2",
			"mpd_pr_eng_wca3",
			"mpd_pr_eng_wca4",
			"mpd_pr_eng_wca5",
			"mpd_pr_eng_wca6",
			"mpd_pr_eng_wca7",
			"mpd_pr_eng_wca8",
			"mpd_pr_eng_wca9",
			"mpd_pr_eng_wca10",
			"mpd_pr_eng_wca11",
			"mpd_pr_eng_wca12",
			"mpd_pr_eng_ifb",
			"mpd_pr_eng_ofb",
			"mpd_pr_eng_rtrrpmb",
			"mpd_pr_eng_hpa",
			"mpd_pr_eng_hpp",
			"mpd_pr_eng_hpu",
			"mpd_pr_eng_rbe1ng",
			"mpd_pr_eng_rbe1np",
			"mpd_pr_eng_rbe1op",
			"mpd_pr_eng_rbe2ng",
			"mpd_pr_eng_rbe2np",
			"mpd_pr_eng_rbe2op",
			"mpd_pr_eng_1accpsi1",
			"mpd_pr_eng_1accpsi2",
			"mpd_pr_eng_1accpsi3",
			"mpd_pr_eng_1accpsi4",
			"mpd_pr_eng_1utipsi1",
			"mpd_pr_eng_1utipsi2",
			"mpd_pr_eng_1utipsi3",
			"mpd_pr_eng_1utipsi4",
			"mpd_pr_eng_1pripsi1",
			"mpd_pr_eng_1pripsi2",
			"mpd_pr_eng_1pripsi3",
			"mpd_pr_eng_1pripsi4",
			"mpd_pl_eng_1npb",
			"mpd_pl_eng_1tgt_1",
			"mpd_pl_eng_1tgt1",
			"mpd_pl_eng_1tgt2",
			"mpd_pl_eng_1tgt3",
			"mpd_pl_eng_1tgtb",
			"mpd_pl_eng_1tgtbg",
			"mpd_pl_eng_2npb",
			"mpd_pl_eng_2tgt_1",
			"mpd_pl_eng_2tgt1",
			"mpd_pl_eng_2tgt2",
			"mpd_pl_eng_2tgt3",
			"mpd_pl_eng_2tgtb",
			"mpd_pl_eng_2tgtbg",
			"mpd_pl_eng_1trq1",
			"mpd_pl_eng_1trq2",
			"mpd_pl_eng_1trqb",
			"mpd_pl_eng_1trqbg",
			"mpd_pl_eng_2trq1",
			"mpd_pl_eng_2trq2",
			"mpd_pl_eng_2trqb",
			"mpd_pl_eng_2trqbg",
			"mpd_pl_eng_ltrqbar",
			"mpd_pl_eng_accpsi1",
			"mpd_pl_eng_accpsi2",
			"mpd_pl_eng_accpsi3",
			"mpd_pl_eng_accpsi4",
			"mpd_pl_eng_utipsi1",
			"mpd_pl_eng_utipsi2",
			"mpd_pl_eng_utipsi3",
			"mpd_pl_eng_utipsi4",
			"mpd_pl_eng_pripsi1",
			"mpd_pl_eng_pripsi2",
			"mpd_pl_eng_pripsi3",
			"mpd_pl_eng_pripsi4",
			"mpd_pl_eng_e1ng1",
			"mpd_pl_eng_e1ng2",
			"mpd_pl_eng_e1ng3",
			"mpd_pl_eng_e2ng1",
			"mpd_pl_eng_e2ng2",
			"mpd_pl_eng_e2ng3",
			"mpd_pl_eng_e1np1",
			"mpd_pl_eng_e1np2",
			"mpd_pl_eng_e1np3",
			"mpd_pl_eng_e2np1",
			"mpd_pl_eng_e2np2",
			"mpd_pl_eng_e2np3",
			"mpd_pl_eng_oil1psi1",
			"mpd_pl_eng_oil1psi2",
			"mpd_pl_eng_oil1psi3",
			"mpd_pl_eng_oil2psi1",
			"mpd_pl_eng_oil2psi2",
			"mpd_pl_eng_oil2psi3",
			"mpd_pl_eng_rrpm1",
			"mpd_pl_eng_rrpm2",
			"mpd_pl_eng_rrpm3",
			"mpd_pl_eng_wca1",
			"mpd_pl_eng_wca2",
			"mpd_pl_eng_wca3",
			"mpd_pl_eng_wca4",
			"mpd_pl_eng_wca5",
			"mpd_pl_eng_wca6",
			"mpd_pl_eng_wca7",
			"mpd_pl_eng_wca8",
			"mpd_pl_eng_wca9",
			"mpd_pl_eng_wca10",
			"mpd_pl_eng_wca11",
			"mpd_pl_eng_wca12",
			"mpd_pl_eng_ifb",
			"mpd_pl_eng_ofb",
			"mpd_pl_eng_rtrrpmb",
			"mpd_pl_eng_hpa",
			"mpd_pl_eng_hpp",
			"mpd_pl_eng_hpu",
			"mpd_pl_eng_rbe1ng",
			"mpd_pl_eng_rbe1np",
			"mpd_pl_eng_rbe1op",
			"mpd_pl_eng_rbe2ng",
			"mpd_pl_eng_rbe2np",
			"mpd_pl_eng_rbe2op",
			"mpd_pl_eng_1accpsi1",
			"mpd_pl_eng_1accpsi2",
			"mpd_pl_eng_1accpsi3",
			"mpd_pl_eng_1accpsi4",
			"mpd_pl_eng_1utipsi1",
			"mpd_pl_eng_1utipsi2",
			"mpd_pl_eng_1utipsi3",
			"mpd_pl_eng_1utipsi4",
			"mpd_pl_eng_1pripsi1",
			"mpd_pl_eng_1pripsi2",
			"mpd_pl_eng_1pripsi3",
			"mpd_pl_eng_1pripsi4",
			"p_ufd_clk1",
			"p_ufd_clk2",
			"p_ufd_clk3",
			"p_ufd_clk4",
			"p_ufd_clk5",
			"p_ufd_clk6",
			"p_ufd_fl1",
			"p_ufd_fl2",
			"p_ufd_fl3",
			"p_ufd_fl4",
			"p_ufd_adv1",
			"p_ufd_adv2",
			"p_ufd_adv3",
			"p_ufd_adv4",
			"p_ufd_adv5",
			"p_ufd_cau1",
			"p_ufd_cau2",
			"p_ufd_cau3",
			"p_ufd_cau4",
			"p_ufd_cau5",
			"p_ufd_wrn1",
			"p_ufd_wrn2",
			"p_ufd_wrn3",
			"p_ufd_wrn4",
			"p_ufd_wrn5",
			"g_ufd_clk1",
			"g_ufd_clk2",
			"g_ufd_clk3",
			"g_ufd_clk4",
			"g_ufd_clk5",
			"g_ufd_clk6",
			"g_ufd_fl1",
			"g_ufd_fl2",
			"g_ufd_fl3",
			"g_ufd_fl4",
			"g_ufd_adv1",
			"g_ufd_adv2",
			"g_ufd_adv3",
			"g_ufd_adv4",
			"g_ufd_adv5",
			"g_ufd_cau1",
			"g_ufd_cau2",
			"g_ufd_cau3",
			"g_ufd_cau4",
			"g_ufd_cau5",
			"g_ufd_wrn1",
			"g_ufd_wrn2",
			"g_ufd_wrn3",
			"g_ufd_wrn4",
			"g_ufd_wrn5",
			///NEWTSD///
			"mpd_pr_tsd_dist1",
			"mpd_pr_tsd_imap",
			"mpd_pr_tsd_map",
			"mpd_pr_tsd_phase",
			///LMPDTSD///
			"mpd_pl_tsd_dist1",
			"mpd_pl_tsd_imap",
			"mpd_pl_tsd_map",
			"mpd_pl_tsd_phase",
			////LMPDOBJS///
			"mpd_gr_obj1",
			"mpd_gr_obj2",
			"mpd_gr_obj3",
			"mpd_gr_obj4",
			"mpd_gr_obj5",
			"mpd_gr_obj6",
			"mpd_gr_obj7",
			"mpd_gr_obj8",
			"mpd_gr_obj9",
			"mpd_gr_obj10",
			"mpd_gr_obj11",
			"mpd_gr_obj12",
			"mpd_gr_obj13",
			"mpd_gr_obj14",
			"mpd_gr_obj15",
			"mpd_gr_obj16",
			"mpd_gr_obj17",
			"mpd_gr_obj18",
			"mpd_gr_obj19",
			"mpd_gr_obj20",
			"mpd_gr_obj21",
			"mpd_gr_obj22",
			"mpd_gr_obj23",
			"mpd_gr_obj24",
			"mpd_gr_obj25",
			"mpd_gr_obj26",
			"mpd_gr_obj27",
			"mpd_gr_obj28",
			"mpd_gr_obj29",
			"mpd_gr_obj30",
			"mpd_gr_obj31",
			"mpd_gr_obj32",
			"mpd_gr_tsd_mmap",
			"mpd_gr_tsd_base",
			"mpd_pr_tsd_mmap",
			"mpd_pr_tsd_base",
			"pod_m260_1",
			"pod_m260_2",
			"pod_m260_3",
			"pod_m260_4",
			"rail_m299_1",
			"rail_m299_2",
			"rail_m299_3",
			"rail_m299_4",
			"mpd_pr_tsd_gspd1",
			"mpd_pr_tsd_gspd2",
			"mpd_pr_tsd_gspd3",
			"mpd_pl_tsd_gspd1",
			"mpd_pl_tsd_gspd2",
			"mpd_pl_tsd_gspd3",
			"mpd_pr_fcraa_wiper",
			"mpd_pr_fcrag_wiper",
			"mpd_pr_fcrag_tnum1",
			"mpd_pr_fcrag_tnum2",
			"mpd_pr_mpd_had_apos",
			"mpd_pr_mpd_had_apos2",
			"mpd_pr_mpd_had_msg1",
			"mpd_pr_mpd_had_msg2",
			"mpd_pr_mpd_had_msg3",
			"mpd_pr_mpd_had_msg4",
			"mpd_pr_mpd_had_msg5",
			"mpd_pr_ase_autpg",
			"mpd_pr_ase_cc1",
			"mpd_pr_ase_cc2",
			"mpd_pr_ase_csel",
			"mpd_pr_ase_dist1",
			"mpd_pr_ase_dist2",
			"mpd_pr_ase_ijaut",
			"mpd_pr_ase_ijoff",
			"mpd_pr_ase_ijon",
			"mpd_pr_ase_rjaut",
			"mpd_pr_ase_rjoff",
			"mpd_pr_ase_rjon",
			"mpd_pr_ase_salvo",
			"mast",
			"longbow",
			"skin_pnvs",
			"skin_hstab",
			"twsus",
			"skin_alq1",
			"skin_alq2",
			"skin_cockpit",
			"skin_cockpitglass",
			"skin_fuse",
			"skin_fuse_ld",
			"skin_lefab",
			"skin_lelight",
			"skin_leng",
			"skin_lgear",
			"skin_lwing",
			"skin_m230",
			"skin_mainrotor",
			"skin_nose",
			"skin_pylon1",
			"skin_pylon2",
			"skin_pylon3",
			"skin_pylon4",
			"skin_refab",
			"skin_relight",
			"skin_reng",
			"skin_rgear",
			"skin_rwing",
			"skin_tads1",
			"skin_tads2",
			"skin_tads3",
			"skin_tailboom",
			"skin_tailboom_ld",
			"skin_tailrotor",
			"skin_vtail",
			"skin_refab_d_heavy",
			"skin_refab_d_cata",
			"skin_lefab_d_heavy",
			"skin_lefab_d_cata",
			"mpd_brt",
			"in_backlight",
			"in_backlight2",
			"in_lt_fire1",
			"in_lt_fire1rdy",
			"in_lt_fire2",
			"in_lt_fire2rdy",
			"in_lt_fireapu",
			"in_lt_fireapurdy",
			"in_lt_firepdis",
			"in_lt_firerdis",
			"in_lt_mstrcau",
			"in_lt_mstrwrn",
			"dam_fuse",
			"dam_gdoor",
			"dam_hstab",
			"dam_lefab",
			"dam_leng",
			"dam_lgear",
			"dam_lwing",
			"dam_nose",
			"dam_pdoor",
			"dam_pnvs",
			"dam_pylon1",
			"dam_pylon2",
			"dam_pylon3",
			"dam_pylon4",
			"dam_refab",
			"dam_reng",
			"dam_rgear",
			"dam_rwing",
			"dam_tads",
			"dam_tailboom",
			"dam_vtail",
			"mdam_fuse",
			"mdam_gdoor",
			"mdam_hstab",
			"mdam_lefab",
			"mdam_leng",
			"mdam_lgear",
			"mdam_lwing",
			"mdam_nose",
			"mdam_pdoor",
			"mdam_pnvs",
			"mdam_pylon1",
			"mdam_pylon2",
			"mdam_pylon3",
			"mdam_pylon4",
			"mdam_refab",
			"mdam_reng",
			"mdam_rgear",
			"mdam_rwing",
			"mdam_tads",
			"mdam_tailboom",
			"mdam_vtail",
			"tr_blades",
			"tr_blur",
			"mr_blades",
			"mr_blur",
			"mpd_pr_eng_back",
			"hdam_tr",
			"hdam_rtr",
			"skin_tailboom_tear"
		};
		/*class AcreRacks 
		{
           class Rack_1 {
               displayName = "Dash"; // Name is displayed in the interaction menu.
               componentName = "ACRE_VRC103";
               allowedPositions[] = {"driver", "copilot"}; // Who has access. "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
               disabledPositions[] = {};
               defaultComponents[] = {};
               mountedRadio = "ACRE_PRC117F";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {"intercom_1"};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
           };
       };*/
		class Turrets
		{
			class MainTurret: NewTurret
			{
				gunnerAction = "fza_ah64_copilot"; 
				gunnerGetInAction = "GetInHigh";
				gunnerGetOutAction = "GetOutHigh";
				primary = 1;
				primaryGunner = 1;
				//weapons[] = {"fza_m230","fza_m261_14","fza_agm114_23_8"};
				//magazines[] = {"fza_m230_1200","fza_m261_m151_14_38","fza_agm114k_23_8"};
				weapons[] = {"fza_m230","fza_m261_14","fza_agm114_3_ul","fza_agm114_3_ur","fza_agm114_3_ll","fza_agm114_3_lr","fza_agm114_2_ul","fza_agm114_2_ur","fza_agm114_2_ll","fza_agm114_2_lr"};
				magazines[] = {"fza_m230_1200","fza_m261_m151_14_38","fza_agm114k_3_ul","fza_agm114k_3_lr","fza_agm114k_3_ur","fza_agm114k_3_ll","fza_agm114k_2_lr","fza_agm114k_2_ul","fza_agm114k_2_ll","fza_agm114k_2_ur"};
				memoryPointsGetInGunner = "pos gunner";
				memoryPointsGetInGunnerDir = "pos gunner dir";
				memoryPointGun = "kulas";
				memoryPointGunnerOptics = "gunnerview";
				body = "mainTurret";
				gun = "mainGun";
				gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
				gunnerOpticsColor[] = {1,1,1,1};
				animationsourcebody = "tads_tur";
				animationsourcegun = "tads";
				minElev = -60; 
				maxElev = 30;
				initElev= 0;
				minTurn = -120; 
				maxTurn = 120;
				initTurn = 0;
				minGunElev = -60;
				maxGunElev = 30;
				minGunTurn = -120;
				maxGunTurn = 120;
				minGunTurnAI = -120;
				maxGunTurnAI = 120;
				maxhorizontalrotspeed = 3;
				maxverticalrotspeed = 3;
				commanding = -1;
				gunnerForceOptics = 0;
				startEngine=0;
				outGunnerMayFire = 1;
				ejectdeadgunner = 0;
				viewgunnershadow = 1;
				viewgunnershadowamb = 1;
				viewgunnershadowdiff = 1;
				turretinfotype = "RscUnitInfoNoHUD";
				discretedistance[] = {1, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900, 3000};
				discretedistanceinitindex = 3;
				isCopilot = 1;
				usePiP=1;
				stabilizedInAxes=3;
				class HitPoints
				{
					class HitTurret
					{
						armor = 0.5;
						material = 51;
						name = "tads_tur";
						visual = "tads_tur";
						passThrough = 1;
					};
					class HitGun
					{
						armor = 1;
						material = 52;
						name = "tads";
						visual = "tads";
						passThrough = 1;
					};
				};
				class OpticsIn
				{
					class Wide
					{
						gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
						directionStabilized = 1;
						//stabilizedInAxes = 3;
						opticStabilized=1;
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
						visionmode[] = {"Normal","Ti","NVG"};
					};
					class Medium: Wide
					{
						gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
						directionStabilized = 1;
						stabilizedInAxes = 3;
						opticStabilized=1;
						initfov = 0.09;
						maxfov = 0.09;
						minfov = 0.09;
						opticsdisplayname = "M";
					};
					class Narrow: Wide
					{
						gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
						directionStabilized = 1;
						stabilizedInAxes = 3;
						opticStabilized=1;
						initfov = 0.01;
						maxfov = 0.01;
						minfov = 0.01;
						opticsdisplayname = "N";
					};
				};
				class OpticsOut
				{
					class Monocular //FOV CPG NR
					{
						gunneropticseffect[] = {};
						gunneropticsmodel = "";
						initanglex = 0;
						initangley = 0;
						initfov = 0.7;
						maxanglex = 75;
						maxangley = 120;
						maxfov = 0.85;
						minanglex = -75;
						minangley = -120;
						minfov = 0.4;
						visionmode[] = {"Normal", "NVG"};
					};
				};
				class ViewGunner
				{
					initFov=0.7;
					minFov=0.400000;
					maxFov=0.7;
					initAngleX=0;
					minAngleX=-75;
					maxAngleX=75;
					initAngleY=0;
					minAngleY=-120;
					maxAngleY=120;
					maxmovex = 0.15;
					maxmovey = 0.1;
					maxmovez = 0.1;
					minmovex = -0.15;
					minmovey = -0.1;
					minmovez = -0.1;
				};
			};
		};
	};
	
	/////////////////////////////////////////////////
	///////////////////JAMMERS///////////////////////
	/////////////////////////////////////////////////
	class Thing: All {};
	class ThingX: Thing {};
	class RoadCone_F: Thing {};
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
	class Plane: Air {};
	class UAV: Plane {};
	class UAV_02_base_F: UAV {};
	class UAV_02_F: UAV_02_base_F {};
	class fza_ah64_jammer: UAV_02_F
	{
		class Turrets {};
		scope=1;
		model = "\fza_ah64_US\fza_ah64_fake.p3d";
		displayname="Helicopter";
		armor = 200;
		cost = 10000000;
		camouflage = 150;
		threat[] = {0.5, 1, 0.1};
		namesound = "veh_Helicopter";
		hasGunner = false;
		crew = "B_UAV_AI";
		typicalCargo[] = {"B_UAV_AI"};
	};
	////////////////////////////////////////////////
	///////////////////DEBRIS///////////////////////
	////////////////////////////////////////////////
	/*
	class ThingEffect: Thing {};
	class FxExploArmor1: ThingEffect {};
	*/
	class fza_ah64_tailboom_debris: RoadCone_F
	{
		scope=1;
		model = "\fza_ah64_us\prx\dam_tailboom_debris";
		displayName = "DEBRIS";
		submerged = 0;
		submergeSpeed = 0;
		timeToLive = 30;
		disappearAtContact = 0;
	};
	class fza_ah64_vtail_debris: fza_ah64_tailboom_debris
	{
		model = "\fza_ah64_us\prx\dam_vtail_debris";
	};
	class fza_ah64_tr_debris: fza_ah64_tailboom_debris
	{
		model = "\fza_ah64_us\prx\dam_tr_debris";
	};
	class fza_ah64_hstab_debris: fza_ah64_tailboom_debris
	{
		model = "\fza_ah64_us\prx\dam_hstab_debris";
	};
};
//////////////////////////////////////////////////////
///////////////////////DIALOGS////////////////////////
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
///////////////////////ARMING/////////////////////////
//////////////////////////////////////////////////////

#define ST_LEFT      0
#define ST_RIGHT     1
#define ST_CENTER    2

#define CT_STATIC    0
#define CT_ACTIVETEXT 11

#define CT_BUTTON   1
#define CT_EDIT 2 
#define CT_COMBO                 4
#define CT_LISTBOX               5

#define FontM "PuristaMedium"

#define CT_SHORTCUT_BUTTON 16

#define ST_FRAME   64

#define ST_PICTURE   48

class fza_ah64_RscButton
{
	type = CT_BUTTON;
	idc = -1;
	style = ST_CENTER;
	colorText[] = {0, 0, 0, 1};
	colorFocused[] = { 1, 1, 1, 1 };
	colorDisabled[] = { 0, 0, 0, 0.7 };
	colorBackground[] = { 1, 1, 1, 1 };
	colorBackgroundDisabled[] = { 1, 1, 1, 0.5 }; 
	colorBackgroundActive[] = { 1, 1, 1, 1 };
	font = FontM;
	sizeEx = 0.025;
	soundPush[] = {, 0.2, 1};
	soundClick[] = {"ui\ui_ok", 0.2, 1};
	soundEscape[] = {"ui\ui_cc", 0.2, 1};
	default = false;
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0;
	offsetPressedY = 0;
	colorShadow[] = { 0, 0, 0, 0 };
	colorBorder[] = { 0, 0, 0, 1 };
	borderSize = 0;
	soundEnter[] = { "", 0, 1 }; // no sound
	x = 0.4;
	y = 0.475;
	w = 0.2;
	h = 0.05;
	text = "Close";
	action = "";
};
class fza_ah64_wepbtn : fza_ah64_RscButton
{
    colorText[] = {0, 0, 0, 1};
	colorFocused[] = { 0, 0, 0, 0 };
	colorDisabled[] = { 0, 0, 0, 0 };
	colorBackground[] = { 0, 0, 0, 0 };
	colorBackgroundDisabled[] = { 0, 0, 0, 0 }; 
	colorBackgroundActive[] = { 0, 0, 0, 0 };
	colorShadow[] = { 0, 0, 0, 0 };
	colorBorder[] = { 0, 0, 0, 0 };
	sizeEx = 0.018;
	borderSize = 0;
	text = "";
	action = "";
};
class fza_ah64_RscText
{
	type = CT_STATIC;
	idc = -1;
	style = ST_LEFT;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {1, 1, 1, 1};
	font = FontM;
	sizeEx = 0.04;
};
class fza_ah64_RscBlueText: fza_ah64_RscText
{
        type = CT_STATIC;
        idc = -1;
        style = 16;
	linespacing = 1;
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {0, 0, 0.8, 1};
        font = FontM;
        sizeEx = 0.02;
};
class fza_ah64_RscYellowText: fza_ah64_RscText
{
	type = CT_STATIC;
	idc = -1;
	style = 16;
	linespacing = 1;
	colorBackground[] = {0.92, 0.7, 0, 1};
	colorText[] = {0, 0, 0, 1};
	font = FontM;
	sizeEx = 0.03;
};
class fza_ah64_RscLB_C
{
	style = ST_LEFT;
	idc = -1;
	colorSelect[] = {0.4, 0.4, 0.4, 1};
	colorSelectBackground[] = {0.2, 0.2, 0.2, 1};
	colorDisabled[] = { 0, 0, 1, 0.7 };
	colorText[] = {0.2, 0.2, 0.2, 1};
	colorBackground[] = {0.4, 0.4, 0.4, 1};
	font = FontM;
	sizeEx = 0.025;
	rowHeight = 0.04;
	soundPush[] = {, 0.2, 1};
	soundClick[] = {"", 0.2, 1};
	soundEscape[] = {"", 0.2, 1};
	soundEnter[] = { "", 0, 1 }; // no sound
	soundSelect[] = {"", 0.2, 1};
	soundExpand[] = {"", 0.2, 1};
	soundCollapse[] = {"", 0.2, 1};
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	maxHistoryDelay = 0.1;
	scrollbar = 1;
};
class fza_ah64_RscCombo:fza_ah64_RscLB_C
{
	type = CT_COMBO;
	wholeHeight = 0.3;
	arrowEmpty = "\ca\ui\data\ui_arrow_combo_ca.paa";
	arrowFull = "\ca\ui\data\ui_arrow_combo_active_ca.paa";
	maxHistoryDelay = 1.0;
	shadow = 0;
	class ScrollBar
	{
		color[] = {0.92, 0.73, 0, 1};
		colorActive[] = {0.92, 0.73, 0, 1};
		colorDisabled[] = {0.92, 0.73, 0, 0.3};
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
		shadow = 0;
	};
};
class fza_ah64_RscListbox:fza_ah64_RscLB_C
{
	type = CT_LISTBOX;
	wholeHeight = 0.3;
	arrowEmpty = "\ca\ui\data\ui_arrow_combo_ca.paa";
	arrowFull = "\ca\ui\data\ui_arrow_combo_active_ca.paa";
	maxHistoryDelay = 1.0;
	shadow = 0;
	class ListScrollBar
	{
		color[] = {0.92, 0.73, 0, 1};
		colorActive[] = {0.92, 0.73, 0, 1};
		colorDisabled[] = {0.92, 0.73, 0, 0.3};
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
		shadow = 0;
	};
};
class fza_ah64_TEMPL_EDIT
{
	idc = -1;
	type = CT_EDIT;
	style = ST_LEFT;
	x = 0;
	y = 0;
	w = 1;
	h = 1;
	sizeEx = 0.025;
	font = FontM;
	text = "";
	colorText[] = {1, 0, 0, 1};
	autocomplete = false;
	colorSelection[] = {1, 1, 1, 1};
	colorDisabled[] = { 0, 0, 0, 0.7 };
};
class fza_ah64_loadout2
{
	idd = -1;
	moving =true;
	movingEnable = true;
	movingEnabled = true;
	colorDisabled[] = { 0, 0, 1, 0.7 };
	controlsBackground[] = { fza_ah64_loadout_back };
	objects[] = {};
	controls[] = {fza_ah64_heli,fza_ah64_pylons,fza_ah64_weapons_list,fza_ah64_loadarea,fza_ah64_loadarea_mis1,fza_ah64_loadarea_mis2,fza_ah64_loadarea_mis3,fza_ah64_loadarea_mis4,fza_ah64_loadarea_act,fza_ah64_wepinfo,fza_ah64_hardpoint1,fza_ah64_hp1_pic,fza_ah64_hardpoint2,fza_ah64_hp2_pic,fza_ah64_hardpoint3,fza_ah64_hp3_pic,fza_ah64_hardpoint4,fza_ah64_hp4_pic,fza_ah64_hardpoint5,fza_ah64_hp5_pic,fza_ah64_load,fza_ah64_clear,fza_ah64_close,fza_ah64_repair,fza_ah64_cannon,fza_ah64_skins};
	class fza_ah64_loadout_back : fza_ah64_RscText
	{
		idc = 100;
		style = ST_PICTURE;
		x = 0.135;
		y = 0;
		w = 0.75;
		h = 1;
		text = "\fza_ah64_controls\arming\loadscreen.paa";
	};
	class fza_ah64_heli : fza_ah64_RscText
	{
		idc = 101;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.24;
		y = -0.038;
		w = 0.375;
		h = 0.5;
		text = "\fza_ah64_controls\arming\ah64db2.paa";
	};
	class fza_ah64_pylons : fza_ah64_RscText
	{
		idc = 102;
		style = ST_PICTURE;
		type = ST_LEFT;
		colorText[] = {1, 1, 1, 0.6};
		x = 0.055;
		y = -0.03;
		w = 0.75;
		h = 0.5;
		text = "\fza_ah64_controls\arming\wpn_area.paa";
	};
	class fza_ah64_weapons_list : fza_ah64_RscListbox
	{
		idc = 103;
		x = 0.705;
		y = 0.005;
		w = 0.175;
		h = 0.86;
		style = LB_MULTI;
		colorText[] = {0.92, 0.73, 0, 1};
		colorBackground[] = {0, 0, 0, 0};
		SizeEX = 0.02;
		colorSelect[] = {0.7, 0, 0, 0.8};
		colorSelectBackGround[] = {0, 0, 0.5, 0.8};
		RowHeight = 0.12;
		wholeHeight = 0.3;
		text="";
	};
	class fza_ah64_loadarea : fza_ah64_RscText
	{
		idc = 104;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.33;
		y = 0.46;
		w = 0.2;
		h = 0.135;
		text = "\fza_ah64_controls\arming\nowep_icn.paa";
	};
	class fza_ah64_loadarea_mis1 : fza_ah64_wepbtn
	{
		idc = 105;
		colorBackground[] = {0, 0, 0, 0};
		colorText[] = {0.9, 0.7, 0, 1};
		x = 0.54;
		y = 0.5;
		w = 0.045;
		h = 0.023;
		sizeEx = 0.03;
		text = "-";
		action = "";
	};
	class fza_ah64_loadarea_mis2 : fza_ah64_loadarea_mis1
	{
		idc = 117; //106 is taken? wtf? IDCs must not be local anymore
		x = 0.54;
		y = 0.533;
	};
	class fza_ah64_loadarea_mis3 : fza_ah64_loadarea_mis1
	{
		idc = 107;
		x = 0.585;
		y = 0.5;
	};
	class fza_ah64_loadarea_mis4 : fza_ah64_loadarea_mis1
	{
		idc = 108;
		x = 0.585;
		y = 0.533;
	};
	class fza_ah64_loadarea_act : fza_ah64_wepbtn
	{
		idc = 109;
		x = 0.33;
		y = 0.46;
		w = 0.2;
		h = 0.135;
		text = "";
		action = "";
	};
	class fza_ah64_wepinfo : fza_ah64_RscText
	{
		idc = 110;
		style = 16;
		linespacing = 1;
		colorBackground[] = {0, 0, 0, 0};
		colorText[] = {0.9, 0.7, 0, 1};
		x = 0.14;
		y = 0.68;
		w = 0.56;
		h = 0.182;
		sizeEx = 0.03;
		text = "-";
	};	
	class fza_ah64_hardpoint1 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.355;
		y = 0.016;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint1 = fza_ah64_curwepsel; ctrlsettext [111,(ctrltext 104)];";
	};
	class fza_ah64_hp1_pic : fza_ah64_RscText
	{
		idc = 111;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.333;
		y = 0.0025;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_hardpoint2 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.49;
		y = 0.125;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint2 = fza_ah64_curwepsel; fza_ah64_hardpoint2_ord1 = fza_ah64_weppoint1; fza_ah64_hardpoint2_ord2 = fza_ah64_weppoint2; fza_ah64_hardpoint2_ord3 = fza_ah64_weppoint3; fza_ah64_hardpoint2_ord4 = fza_ah64_weppoint4; ctrlsettext [112,(ctrltext 104)];";
	};
	class fza_ah64_hp2_pic : fza_ah64_RscText
	{
		idc = 112;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.468;
		y = 0.1115;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_hardpoint3 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.49;
		y = 0.27;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint3 = fza_ah64_curwepsel; fza_ah64_hardpoint3_ord1 = fza_ah64_weppoint1; fza_ah64_hardpoint3_ord2 = fza_ah64_weppoint2; fza_ah64_hardpoint3_ord3 = fza_ah64_weppoint3; fza_ah64_hardpoint3_ord4 = fza_ah64_weppoint4; ctrlsettext [113,(ctrltext 104)];";
	};
	class fza_ah64_hp3_pic : fza_ah64_RscText
	{
		idc = 113;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.468;
		y = 0.2565;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_hardpoint4 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.215;
		y = 0.125;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint4 = fza_ah64_curwepsel; fza_ah64_hardpoint4_ord1 = fza_ah64_weppoint1; fza_ah64_hardpoint4_ord2 = fza_ah64_weppoint2; fza_ah64_hardpoint4_ord3 = fza_ah64_weppoint3; fza_ah64_hardpoint4_ord4 = fza_ah64_weppoint4; ctrlsettext [114,(ctrltext 104)];";
	};
	class fza_ah64_hp4_pic : fza_ah64_RscText
	{
		idc = 114;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.193;
		y = 0.1115;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_hardpoint5 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.215;
		y = 0.27;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint5 = fza_ah64_curwepsel; fza_ah64_hardpoint5_ord1 = fza_ah64_weppoint1; fza_ah64_hardpoint5_ord2 = fza_ah64_weppoint2; fza_ah64_hardpoint5_ord3 = fza_ah64_weppoint3; fza_ah64_hardpoint5_ord4 = fza_ah64_weppoint4; ctrlsettext [115,(ctrltext 104)];";
	};
	class fza_ah64_hp5_pic : fza_ah64_RscText
	{
		idc = 115;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.193;
		y = 0.2565;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_load : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0.3, 0.2, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0.2, 0.3, 0.5 };
		colorText[] = {0.9, 0.7, 0, 1};
		colorBorder[] = { 0.9, 0.7, 0, 1 };
		sizeEx = 0.02;
		borderSize = 0.01;
		x = 0.15;
		y = 0.01;
		w = 0.1;
		h = 0.05;
		text = "LOAD";
		action = "[(vehicle player)] execvm ""\fza_ah64_controls\arming\loadweps.sqf""";
	};
	class fza_ah64_clear : fza_ah64_load
	{
		x = 0.6;
		y = 0.01;
		text = "CLEAR";
		action = "";
	};
	class fza_ah64_close : fza_ah64_load
	{
		x = 0.4;
		y = 0.9;
		text = "CLOSE";
		action = "closedialog 0";
	};
	class fza_ah64_repair : fza_ah64_load
	{
		x = 0.51;
		y = 0.9;
		w = 0.15;
		text = "REPAIR-REFUEL";
		action = "[(vehicle player)] execvm ""\fza_ah64_controls\arming\repair_refuel.sqf""";
	};
	class fza_ah64_skins : fza_ah64_load
	{
		x = 0.725;
		y = 0.9;
		w = 0.1;
		text = "SKINS";
		action = "[(vehicle player)] execvm ""\fza_ah64_controls\arming\skinsel.sqf""";
	};
	class fza_ah64_cannon : fza_ah64_loadarea_mis1
	{
		idc = 116;
		x = 0.405;
		y = 0.27;
		colorBackground[] = {0.5, 0, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0, 0.5, 0.5 };
		colorFocused[] = { 0.5, 0, 0.5, 0.5 };
		text = "1200";
		action = "fza_ah64_canmag = fza_ah64_canmag + 1;";
	};
};
///////////////////////////////
//////AIRCRAFT SKIN MENU///////
///////////////////////////////
class fza_ah64_skinmenu
{
	idd = 199;
	moving = true;
	movingEnable = true;
	movingEnabled = true;
	colorDisabled[] = { 0, 0, 1, 0.7 };
	controlsBackground[] = { fza_ah64_skinmenu_back };
	objects[] = { };
	controls[] = { fza_ah64_skin_list,fza_ah64_skin_act,fza_ah64_skininfo,fza_ah64_skin_close,fza_ah64_skin_ok,fza_ah64_custskinpath,fza_ah64_testskin };
	class fza_ah64_skinmenu_back : fza_ah64_RscText
	{
		idc = 200;
		style = CT_STATIC;
		x = safezoneX + (0.25 * safezoneW);
		y = safezoneY + (0.72 * safezoneH);
		w = safezoneW * 0.5;
		h = safezoneH * 0.26;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = { 0.1, 0.1, 0.1, 0.8 };
		colorBorder[] = { 0, 0, 0, 0 };
		borderSize = 1;
		text = "";
	};
	class fza_ah64_skin_list : fza_ah64_RscListbox
	{
		idc = 201;
		x = safezoneX + (0.25 * safezoneW);
     	y = safezoneY + (0.72 * safezoneH);
    	w = safezoneW * 0.5;
     	h = safezoneH * 0.075;
		style = LB_MULTI;
		colorText[] = {0.92, 0.73, 0, 1};
		colorBackground[] = {0, 0, 0, 0};
		SizeEX = 0.02;
		colorSelect[] = {0.7, 0, 0, 0.8};
		colorSelectBackGround[] = {0, 0, 0.5, 0.8};
		RowHeight = 0.06;
		wholeHeight = 0.125;
		text="";
	};
	class fza_ah64_skin_act : fza_ah64_wepbtn
	{
		idc = 202;
		x = 0.33;
		y = 0.46;
		w = 0.2;
		h = 0.135;
		text = "";
		action = "";
	};
	class fza_ah64_skininfo : fza_ah64_RscText
	{
		idc = 203;
		style = ST_PICTURE;
		linespacing = 1;
		colorBackground[] = {0, 0, 0, 0};
		colorText[] = {1, 1, 1, 1};
     	x = safezoneX + (0.47 * safezoneW);
     	y = safezoneY + (0.8 * safezoneH);
    	w = safezoneW * 0.06;
     	h = safezoneH * 0.1;
		sizeEx = 0.03;
		text = "";
	};
	class fza_ah64_custskinpath : fza_ah64_TEMPL_EDIT
	{
		idc = 204;
		colorText[] = {0.92, 0.73, 0, 1};
		colorSelect[] = {0.7, 0, 0, 0.8};
		colorSelectBackGround[] = {0, 0, 0.5, 0.8};
     	x = safezoneX + (0.25 * safezoneW);
     	y = safezoneY + (0.9 * safezoneH);
    	w = safezoneW * 0.5;
     	h = safezoneH * 0.025;
		sizeEx = 0.03;
		text = "N/A";
		action = "";
	};
	class fza_ah64_skin_close : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0.3, 0.2, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0.2, 0.3, 0.5 };
		colorText[] = {0.9, 0.7, 0, 1};
		colorBorder[] = { 0.9, 0.7, 0, 1 };
		sizeEx = 0.02;
		borderSize = 0.01;
     	x = safezoneX + (0.25 * safezoneW);
     	y = safezoneY + (0.95 * safezoneH);
    	w = safezoneW * 0.05;
     	h = safezoneH * 0.025;
		text = "CLOSE";
		action = "closedialog 0; fza_ah64_skindialog = false;";
	};
	class fza_ah64_skin_ok : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0.3, 0.2, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0.2, 0.3, 0.5 };
		colorText[] = {0.9, 0.7, 0, 1};
		colorBorder[] = { 0.9, 0.7, 0, 1 };
		sizeEx = 0.02;
		borderSize = 0.01;
     	x = safezoneX + (0.7 * safezoneW);
     	y = safezoneY + (0.95 * safezoneH);
    	w = safezoneW * 0.05;
     	h = safezoneH * 0.025;
		text = "OK";
		action = "[(vehicle player)] execvm ""\fza_ah64_controls\arming\setskin.sqf"";";
	};
	class fza_ah64_testskin : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0.3, 0.2, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0.2, 0.3, 0.5 };
		colorText[] = {0.9, 0.7, 0, 1};
		colorBorder[] = { 0.9, 0.7, 0, 1 };
		sizeEx = 0.02;
		borderSize = 0.01;
     	x = safezoneX + (0.4875 * safezoneW);
     	y = safezoneY + (0.95 * safezoneH);
    	w = safezoneW * 0.05;
     	h = safezoneH * 0.025;
		text = "Test Skin";
		action = "ctrlsettext [203,(ctrlText 204)];";
	};
};
/////////////////////////////////////////////////////////////
////////////////////////////IHADSS///////////////////////////
/////////////////////////////////////////////////////////////
#define CT_OBJECT 80
#define CT_MAP              100
class RscObject;
class fza_ah64_mapControl
{
	idc = -1;
	type = 100;
	style = 48;
	x = 0;
	y = 0;
	w = 1;
	h = 1;
	colorBackground[] = {1,1,1,0};
	colorText[] = {0,0,0,0};
	colorSea[] = {0.56,0.8,0.98,0};
	colorForest[] = {0.6,0.8,0.2,0};
	colorRocks[] = {0.5,0.5,0.5,0};
	colorCountlines[] = {0.65,0.45,0.27,0};
	colorMainCountlines[] = {0.65,0.45,0.27,0};
	colorCountlinesWater[] = {0,0.53,1,0};
	colorMainCountlinesWater[] = {0,0.53,1,0};
	colorForestBorder[] = {0.4,0.8,0,0};
	colorRocksBorder[] = {0.5,0.5,0.5,0};
	colorPowerLines[] = {0,0,0,0};
	colorNames[] = {0,0,0,0};
	colorInactive[] = {1,1,1,0};
	colorLevels[] = {0,0,0,0};
	colorRailWay[] = {0,0,0,0};
	colorOutside[] = {0.56,0.8,0.98,0};
	//a3compat//
	colorTracks[] = {0,0,0,0};
	colorRoads[] = {0,0,0,0};
	colorMainRoads[] = {0,0,0,0};
	colorTracksFill[] = {0,0,0,0};
	colorRoadsFill[] = {0,0,0,0};
	colorMainRoadsFill[] = {0,0,0,0};
	colorGrid[] = {0,0,0,0};
	colorGridMap[] = {0,0,0,0};
	////////////
	font = "TahomaB";
	sizeEx = 0;
	stickX[] = {0,{"Gamma",1,1.5 }};
	stickY[] = {0,{"Gamma",1,1.5 }};
	ptsPerSquareSea = 0;
	ptsPerSquareTxt = 0;
	ptsPerSquareCLn = 0;
	ptsPerSquareExp = 0;
	ptsPerSquareCost = 0;
	ptsPerSquareFor = "0f";
	ptsPerSquareForEdge = "0f";
	ptsPerSquareRoad = 0;
	ptsPerSquareObj = 0;
	fontLabel = "PuristaMedium";
	sizeExLabel = 0;
	fontGrid = "PuristaMedium";
	sizeExGrid = 0;
	fontUnits = "PuristaMedium";
	sizeExUnits = 0;
	fontNames = "PuristaMedium";
	sizeExNames = 0;
	fontInfo = "PuristaMedium";
	sizeExInfo = 0;
	fontLevel = "PuristaMedium";
	sizeExLevel = 0;
	scaleMax = 1;
	scaleMin = 0.125;
	text = "";
	maxSatelliteAlpha = 0;
	alphaFadeStartScale = 1;
	alphaFadeEndScale = 1.1;
	showCountourInterval = 1;
	scaleDefault = 2;
	class Task
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {1,0.537,0,0};
		size = 27;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
		iconCreated = "";
		iconCanceled = "";
		iconDone = "";
		iconFailed = "";
		colorCreated[] = {1,1,1,0};
		colorCanceled[] = {1,1,1,0};
		colorDone[] = {1,1,1,0};
		colorFailed[] = {1,1,1,0};
	};
	class CustomMark
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.6471,0.6706,0.6235,0};
		size = 18;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
	};
	class Legend
	{
		x = "SafeZoneX";
		y = "SafeZoneY";
		w = 0.34;
		h = 0.152;
		font = "PuristaMedium";
		sizeEx = 0.03921;
		colorBackground[] = {0.906,0.901,0.88,0};
		color[] = {0,0,0,0};
	};
	class Bunker
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.55,0.64,0.43,0};
		size = 14;
		importance = "1.5 * 14 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Bush
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.45,0.64,0.33,0};
		size = 14;
		importance = "0.2 * 14 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class BusStop
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.15,0.26,0.87,0};
		size = 12;
		importance = "1 * 10 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Command
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0,0.9,0,0};
		size = 18;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
	};
	class Cross
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		size = 16;
		color[] = {0,0.9,0,0};
		importance = "0.7 * 16 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Fortress
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		size = 16;
		color[] = {0,0.9,0,0};
		importance = "2 * 16 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Fuelstation
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		size = 16;
		color[] = {0,0.9,0,0};
		importance = "2 * 16 * 0.05";
		coefMin = 0.75;
		coefMax = 4;
	};
	class Fountain
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.2,0.45,0.7,0};
		size = 11;
		importance = "1 * 12 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Hospital
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.78,0,0.05,0};
		size = 16;
		importance = "2 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class Chapel
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.55,0.64,0.43,0};
		size = 16;
		importance = "1 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Church
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		size = 16;
		color[] = {0,0.9,0,0};
		importance = "2 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Lighthouse
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		size = 14;
		color[] = {0,0.9,0,0};
		importance = "3 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Quay
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		size = 16;
		color[] = {0,0.9,0,0};
		importance = "2 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class Rock
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.1,0.1,0.1,0};
		size = 12;
		importance = "0.5 * 12 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Ruin
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		size = 16;
		color[] = {0,0.9,0,0};
		importance = "1.2 * 16 * 0.05";
		coefMin = 1;
		coefMax = 4;
	};
	class SmallTree
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.45,0.64,0.33,0};
		size = 12;
		importance = "0.6 * 12 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Stack
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		size = 20;
		color[] = {0,0.9,0,0};
		importance = "2 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Tree
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.45,0.64,0.33,0};
		size = 12;
		importance = "0.9 * 16 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Tourism
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.78,0,0.05,0};
		size = 16;
		importance = "1 * 16 * 0.05";
		coefMin = 0.7;
		coefMax = 4;
	};
	class Transmitter
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0,0.9,0,0};
		size = 20;
		importance = "2 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class ViewTower
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0,0.9,0,0};
		size = 16;
		importance = "2.5 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class Watertower
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0.2,0.45,0.7,0};
		size = 20;
		importance = "1.2 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Waypoint
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0,0.35,0.7,0};
		size = 16;
		importance = "2.5 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class WaypointCompleted
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0,0.35,0.7,0};
		size = 16;
		importance = "2.5 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class PowerSolar
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0,0.35,0.7,0};
		size = 16;
		importance = "2.5 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class PowerWave
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0,0.35,0.7,0};
		size = 16;
		importance = "2.5 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class PowerWind
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0,0.35,0.7,0};
		size = 16;
		importance = "2.5 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class Shipwreck
	{
		icon = "\fza_ah64_us\tex\ICONS\f16_rsc_fcr_gen.paa";
		color[] = {0,0.35,0.7,0};
		size = 16;
		importance = "2.5 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class ActiveMarker
	{
		color[] = {0.3,0.1,0.9,0};
		size = 50;
	};
};
class RscTitles 
{
	class fza_ah64_mapfake
	{
		idd = 300;
		movingEnable = 1;
		enableSimulation = 1;
		enableDisplay = 1;
		duration     =  99999;
		fadein       =  0;
		fadeout      =  0;
		name = "fza_ah64_mapfake";
		//uiNameSpace setvariable ['fza_ah64_mapfake',_this select 0];
		onLoad = "_this call fza_ah64_perframe;";
		onunLoad = "((_this) displayCtrl 3001) ctrlSetEventHandler [""Draw"", '']; fza_ah64_pfsstate = false;";
		class controlsBackground
		{
			class fza_ah64_cMap: fza_ah64_mapControl
			{
				idc = 3001;
				moveOnEdges = 0;
				x = -100;
				y = -100;
				w = 0.01;
				h = 0.01;
			};
		};
		class controls {};
		class objects{};
	};
	class fza_ah64_click_helper
	{
		idd = 600;
		movingEnable =  1;
		duration     =  99999;
		fadein       =  0;
		fadeout      =  0;
		name = "fza_ah64_click_helper";
		onLoad = "with uiNameSpace do { fza_ah64_click_helper = _this select 0 }";
		class controls 
		{
			class fza_ah64_click_helper_center
			{
				idc = 601;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\hdu\hmd_curs_ca.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.495;
				y = 0.491;
				w = 0.01;
				h = 0.015;
			};		
			class fza_ah64_click_helper_txt
			{
				type = 13;
				idc = 602;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.25;
				y = 0.55;
				w = 0.5;
				h = 0.12;
				size = 0.02;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,0.5};
				text = "";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "center";
					shadow = false;
				};
			};
		};
	};
	class fza_ah64_raddisp
	{
		idd = 100;
		movingEnable =  1;
		duration     =  99999;
		fadein       =  0;
		fadeout      =  0;
		name = "fza_ah64_raddisp";
		//oldwith uiNameSpace do { fza_ah64_raddisp = _this select 0 }
		onLoad = "uiNameSpace setvariable ['fza_ah64_raddisp',_this select 0];";
		class objects
		{
			class fza_ah64_ihadss_hor_c
			{
				idc = 250;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_c.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_p1
			{
				idc = 251;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_p1.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_p2
			{
				idc = 252;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_p2.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_p3
			{
				idc = 253;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_p3.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_p4
			{
				idc = 254;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_p4.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_p5
			{
				idc = 255;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_p5.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_p6
			{
				idc = 256;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_p6.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_p7
			{
				idc = 257;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_p7.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_p8
			{
				idc = 258;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_p8.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_p9
			{
				idc = 259;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_p9.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			//negs
			class fza_ah64_ihadss_hor_n1
			{
				idc = 260;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_n1.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_n2
			{
				idc = 261;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_n2.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_n3
			{
				idc = 262;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_n3.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_n4
			{
				idc = 263;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_n4.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_n5
			{
				idc = 264;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_n5.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_n6
			{
				idc = 265;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_n6.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_n7
			{
				idc = 266;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_n7.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_n8
			{
				idc = 267;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_n8.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			class fza_ah64_ihadss_hor_n9
			{
				idc = 268;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_n9.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
			//trans
			class fza_ah64_ihadss_hor_d
			{
				idc = 269;
				type = 82;
				model = "\fza_ah64_us\prx\ihadss\fza_ah64_ihadss_hor_d.p3d";
				scale = 1;
				direction[] = {0, -0.35, -0.65};
				up[] = {0, 0.65, -0.35};
				position[] = {0.5,10,0.5};
				x = 0.5; y = 0.5; z = 0.2;
				xBack = 0.5;
				yBack = 0.5;
				zBack = 1.2;
				inBack = 1;
				enableZoom = 0;
				zoomDuration = 0.001;
			};
		};
		class controls 
		{
			//hdu//
			class fza_ah64_raddisp_hdu_bg
			{
				idc = 119;
				type = 0;
				colorText[] = {-1, 1, 0, 0.5};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "";
				style = 48;
				sizeEx = 512;
				x = 0.25;
				y = 0.28;
				w = 0.5;
				h = 0.44;
			};
			class fza_ah64_raddisp_hdu_bg2
			{
				idc = 120;
				type = 0;
				colorText[] = {-1, 1, 0, 0.5};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "";
				style = 48;
				sizeEx = 512;
				x = 0.25;
				y = 0.28;
				w = 0.5;
				h = 0.44;
			};
			///base///
			class fza_ah64_raddisp_radrange
			{
				type = 13;
				idc = 121;
				style = 2 + 16;
				lineSpacing = 1;
				x = -0.055;
				y = 0.72;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "right";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_targrange
			{
				type = 13;
				idc = 122;
				style = 2 + 16;
				lineSpacing = 1;
				x = -0.049;
				y = 0.74;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "right";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_collective
			{
				type = 13;
				idc = 123;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.31;
				y = 0.356;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "left";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_speed
			{
				type = 13;
				idc = 124;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.31;
				y = 0.5;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "left";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_radaralt
			{
				type = 13;
				idc = 125;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.18;
				y = 0.5;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "right";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_weptype
			{
				type = 13;
				idc = 126;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.56;
				y = 0.72;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "left";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_wepstate
			{
				type = 13;
				idc = 127;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.56;
				y = 0.74;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "left";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_safemessage
			{

				type = 13;
				idc = 128;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.25;
				y = 0.65;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "center";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_waypoint
			{
				type = 13;
				idc = 129;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.29;
				y = 0.6;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
				font = "EtelkaMonospaceProBold";
						//color = "1EFF00";
					align = "left";
					shadow = false;
				};
			};
			//JHCMS
			class fza_ah64_raddisp_jhmcs
			{
				idc = 130;
				type = 0;
				colorText[] = {0.1, 1, 0, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\ihadss.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.2485;
				y = 0.16;
				w = 0.5;
				h = 0.68;
			};
			class fza_ah64_raddisp_jhmcs_trk
			{
				idc = 131;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\f16_rsc_jhmcs_targ.paa";
				style = 48;
				sizeEx = 64;
				x = 0;
				y = -50;
				w = 0.0734;
				h = 0.1;
			};
			class fza_ah64_raddisp_target
			{
				idc = 132;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\ah64_target.paa";
				style = 48;
				sizeEx = 64;
				x = 0;
				y = -50;
				w = 0.0734;
				h = 0.1;
			};
			class fza_ah64_raddisp_tadspos
			{
				idc = 133;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\tadspos.paa";
				style = 48;
				sizeEx = 256;
				x = 0.5;
				y = 0.7;
				w = 0.03845;
				h = 0.05;
			};
			class fza_ah64_raddisp_chevron
			{
				idc = 134;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_chev.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.3;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_vsi
			{
				idc = 135;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\alt_vsi.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.678;
				y = 0.49;
				w = 0.01;
				h = 0.02;
			};
			class fza_ah64_raddisp_radaltbar
			{
				idc = 136;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.708;
				y = 0.6325;
				w = 0.01;
				h = 0.0025;
			};
			class fza_ah64_raddisp_fcrdir
			{
				idc = 137;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_fcr.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.678;
				y = 0.3;
				w = 0.032;
				h = 0.04;
			};
			/*class fza_ah64_raddisp_hor_1
			{
				idc = 138;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.41;
				y = 0.6;
				w = 0.015;
				h = 0.0025;
			};
			class fza_ah64_raddisp_hor_2
			{
				idc = 139;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.43;
				y = 0.6;
				w = 0.015;
				h = 0.0025;
			};
			class fza_ah64_raddisp_hor_3
			{
				idc = 140;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.45;
				y = 0.6;
				w = 0.015;
				h = 0.0025;
			};
			class fza_ah64_raddisp_hor_4
			{
				idc = 141;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.47;
				y = 0.6;
				w = 0.015;
				h = 0.0025;
			};
			class fza_ah64_raddisp_hor_5
			{
				idc = 142;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.51;
				y = 0.6;
				w = 0.015;
				h = 0.0025;
			};
			class fza_ah64_raddisp_hor_6
			{
				idc = 143;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.53;
				y = 0.6;
				w = 0.015;
				h = 0.0025;
			};
			class fza_ah64_raddisp_hor_7
			{
				idc = 144;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.55;
				y = 0.6;
				w = 0.015;
				h = 0.0025;
			};
			class fza_ah64_raddisp_hor_8
			{
				idc = 145;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.57;
				y = 0.6;
				w = 0.015;
				h = 0.0025;
			};*/
			class fza_ah64_raddisp_lase 
			{ 
				idc = 138; 
				type = 0; 
				colorText[] = {0.1, 1, 0, 1}; 
				font = "EtelkaMonospaceProBold"; 
				colorBackground[] = {1, 1, 1, 1}; 
				text = ""; 
				style = 48; 
				sizeEx = 1024; 
				x = 0.2485; 
				y = 0.16; 
				w = 0.5; 
				h = 0.68; 
			};
			class fza_ah64_raddisp_hdg0_tickmark
			{
				idc = 146;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_360.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg30_tickmark
			{
				idc = 147;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_30.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg60_tickmark
			{
				idc = 148;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_60.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg90_tickmark
			{
				idc = 149;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_90.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg120_tickmark
			{
				idc = 150;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_120.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg150_tickmark
			{
				idc = 151;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_150.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg180_tickmark
			{
				idc = 152;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_180.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg210_tickmark
			{
				idc = 153;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_210.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg240_tickmark
			{
				idc = 154;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_240.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg270_tickmark
			{
				idc = 155;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_270.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg300_tickmark
			{
				idc = 156;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_300.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg330_tickmark
			{
				idc = 157;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\mark_330.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.05;
				h = 0.04;
			};
			class fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 158;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.003;
				h = 0.01;
			};
			class fza_ah64_raddisp_hdg20_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 159;
			};
			class fza_ah64_raddisp_hdg40_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 160;
			};
			class fza_ah64_raddisp_hdg50_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 161;
			};
			class fza_ah64_raddisp_hdg70_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 162;
			};
			class fza_ah64_raddisp_hdg80_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 163;
			};
			class fza_ah64_raddisp_hdg100_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 164;
			};
			class fza_ah64_raddisp_hdg110_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 165;
			};
			class fza_ah64_raddisp_hdg130_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 166;
			};
			class fza_ah64_raddisp_hdg140_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 167;
			};
			class fza_ah64_raddisp_hdg160_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 168;
			};
			class fza_ah64_raddisp_hdg170_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 169;
			};
			class fza_ah64_raddisp_hdg190_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 170;
			};
			class fza_ah64_raddisp_hdg200_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 171;
			};
			class fza_ah64_raddisp_hdg220_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 172;
			};
			class fza_ah64_raddisp_hdg230_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 173;
			};
			class fza_ah64_raddisp_hdg250_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 174;
			};
			class fza_ah64_raddisp_hdg260_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 175;
			};
			class fza_ah64_raddisp_hdg280_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 176;
			};
			class fza_ah64_raddisp_hdg290_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 177;
			};
			class fza_ah64_raddisp_hdg310_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 178;
			};
			class fza_ah64_raddisp_hdg320_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 179;
			};
			class fza_ah64_raddisp_hdg340_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 180;
			};
			class fza_ah64_raddisp_hdg350_tickmark: fza_ah64_raddisp_hdg10_tickmark
			{
				idc = 181;
			};
			class fza_ah64_raddisp_pnvspos
			{
				idc = 182;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\headpos.paa";
				style = 48;
				sizeEx = 256;
				x = 0.49;
				y = 0.5;
				w = 0.03845;
				h = 0.05;
			};
			class fza_ah64_raddisp_fcr_for
			{
				idc = 183;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\horizon_bar.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.27;
				w = 0.002;
				h = 0.054;
			};
			class fza_ah64_raddisp_waypoint_gspd
			{
				
				type = 13;
				idc = 184;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.29;
				y = 0.62;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "left";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_velvect
			{
				idc = 185;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\MPD\cue_ca.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.5;
				w = 0.03;
				h = 0.04;
			};
			class fza_ah64_raddisp_slipball
			{
				idc = 186;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\hmd_slip.paa";
				style = 48;
				sizeEx = 1024;
				x = 0.5;
				y = 0.7;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_bobup
			{
				
				idc = 187;
				type = 0;
				colorText[] = {0.1, 1, 0, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\bobup.paa";
				style = 48;
				sizeEx = 256;
				x = 0.49;
				y = 0.5;
				w = 0.03845;
				h = 0.05;
			};
			class fza_ah64_raddisp_baroalt
			{
				
				type = 13;
				idc = 188;
				style = 2 + 16;
				lineSpacing = 1;
				x = 0.18;
				y = 0.35;
				w = 0.5;
				h = 0.12;
				size = 0.024;
				colorBackground[] = {0,0,0,0};
				colorText[] = {0.1,1,0,1};
				text = "0";
				font = "EtelkaMonospaceProBold";
				class Attributes 
				{
					font = "EtelkaMonospaceProBold";
					//color = "1EFF00";
					align = "right";
					shadow = false;
				};
			};
			class fza_ah64_raddisp_cscope1
			{
				idc = 190;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope2
			{
				idc = 191;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope3
			{
				idc = 192;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope4
			{
				idc = 193;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope5
			{
				idc = 194;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope6
			{
				idc = 195;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope7
			{
				idc = 196;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope8
			{
				idc = 197;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope9
			{
				idc = 198;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope10
			{
				idc = 199;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope11
			{
				idc = 200;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope12
			{
				idc = 201;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope13
			{
				idc = 202;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope14
			{
				idc = 203;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope15
			{
				idc = 204;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_cscope16
			{
				idc = 205;
				type = 0;
				colorText[] = {1, 1, 1, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\ICONS\f16_rsc_fcr_ac.paa";
				style = 48;
				sizeEx = 1024;
				x = -100;
				y = -100;
				w = 0.018;
				h = 0.024;
			};
			class fza_ah64_raddisp_fov
			{
				idc = 206;
				type = 0;
				colorText[] = {0.1, 1, 0, 1};
				font = "EtelkaMonospaceProBold";
				colorBackground[] = {1, 1, 1, 1};
				text = "\fza_ah64_US\tex\HDU\FOV-W.paa";
				style = 48;
				sizeEx = 1024;
				x = (safezoneX + safezoneW * 0.4);
				y = (safezoneY + safezoneH * 0.4);
				w = (safezoneW * 0.2);
				h = (safezoneH * 0.2);
			};
		};
	};
};
//kept here in case needed//
/*class CfgNonAIVehicles
{
	class ProxyWeapon;
	class Proxyfza_agm114l: ProxyWeapon
	{
		model = "\fza_ah64_US\fza_agm114l";
		simulation = "maverickweapon";
	};
	class Proxyfza_agm114k: ProxyWeapon
	{
		model = "\fza_ah64_US\fza_agm114k";
		simulation = "maverickweapon";
	};
	class Proxyfza_agm114: ProxyWeapon
	{
		model = "\fza_ah64_US\fza_agm114c";
		simulation = "maverickweapon";
	};
};*/