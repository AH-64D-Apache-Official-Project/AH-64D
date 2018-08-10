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
