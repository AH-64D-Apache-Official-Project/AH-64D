#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
	class fza_ah64_project_systems
	{
        tag = "FZA_systems";
		class apu {
			file = "\fza_ah64_systems\functions\apu";	
			class apu {R;};
		};
		class core {					
			file = "\fza_ah64_systems\functions\core";
			class coreUpdate {R;};
			class coreVariables {R;};
		};
		class drivetrain {
			file = "\fza_ah64_systems\functions\drivetrain";
			
		};
		class electrical {
			file = "\fza_ah64_systems\functions\electrical";
			class electricalBattery {R;};
			class electricalGenController {R;};
		};
		class hydraulics {
			file = "\fza_ah64_systems\functions\hydraulics";
			class hydraulicsAccumulator {R;};
			class hydraulicsController {R;};
			class hydraulicsPriPump {R;};
			class hydraulicsPriReservoir {R;};
			class hydraulicsUtilPump {R;};
			class hydraulicsUtilReservoir {R;};
		};
		class repair {
			file = "\fza_ah64_systems\functions\repair";
			class repair {R;};
		};
    };
};