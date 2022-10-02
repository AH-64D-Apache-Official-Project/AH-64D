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
			class drivetrainController {R;};
			class drivetrainNoseGearbox1 {R;};
			class drivetrainNoseGearbox2 {R;};
			class drivetrainTailRotorGearboxes {R;};
			class drivetrainTransmission {R;};
		};
		class electrical {
			file = "\fza_ah64_systems\functions\electrical";
			class electricalACBus {R;};
			class electricalBattery {R;};
			class electricalController {R;};
			class electricalDCBus {R;};
			class electricalGenerator1 {R;};
			class electricalGenerator2 {R;};
			class electricalRectifier1 {R;};
			class electricalRectifier2 {R;};
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
		class interact {
			file = "\fza_ah64_systems\functions\interact";
			class interactAPUButton {R;};
			class interactBattSwitch {R;};
		};
		class repair {
			file = "\fza_ah64_systems\functions\repair";
			class repair {R;};
		};
    };
};