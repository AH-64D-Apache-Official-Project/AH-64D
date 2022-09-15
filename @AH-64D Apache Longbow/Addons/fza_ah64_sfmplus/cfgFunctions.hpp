#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
	class fza_ah64_project_sfmplus
	{
        tag = "FZA_sfmplus";
		class aero {
			file = "\fza_ah64_sfmplus\functions\aero";
			class aeroStabilator {R;};
		};
		class core {
			file = "\fza_ah64_sfmplus\functions\core";
			class coreConfig {R;};
			class coreUpdate  {R;};
		};
		class damage {
			file = "\fza_ah64_sfmplus\functions\damage";
			class damageApply {R;};
		};
		class engine {
			file = "\fza_ah64_sfmplus\functions\engine";
			class engine  {R;};
			class engineController {R;};
            class engineReset {R;};
			class engineVariables {R;};
		};
		class fuel {
			file = "\fza_ah64_sfmplus\functions\fuel";
			class fuelSet {R;};
		};
		class interact {
			file = "\fza_ah64_sfmplus\functions\interact";
			class interactAPUButton {R;};
			class interactBattSwitch {R;};
			class interactPowerLever {R;};
			class interactStartSwitch {R;};
		};
		class mass {
			file = "\fza_ah64_sfmplus\functions\mass";
			class massSet {R;};
		};
		class performance {
			file = "\fza_ah64_sfmplus\functions\performance";
			class perfData {R;};
			class perfVariables {R;};
		};
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Move to own .pbo /////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////
		class systems {
			file = "\fza_ah64_sfmplus\functions\systems";	
			class systemsAPU {R;};
			class systemsVariables {R;};
		};
		class systemsCore {					
			file = "\fza_ah64_sfmplus\functions\systems\core";
			class systemsCoreUpdate {R;};
		};
		class systemsElectrical {
			file = "\fza_ah64_sfmplus\functions\systems\electrical";
			class systemsElectricalBattery {R;};
			class systemsElectricalGenController {R;};
		};
		class systemsHydraulics {
			file = "\fza_ah64_sfmplus\functions\systems\hydraulics";
			class systemsHydraulicsPump {R;};
			class systemsHydraulicsReservoir {R;};
		};
		/////////////////////////////////////////////////////////////////////////////////////////////
		// End of move to own .pbo //////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////
		class utility {
			file = "\fza_ah64_sfmplus\functions";
			class clampedMove {R;};
			class getArea {R;};
			class getInput   {R;};
			class setArrayVariable {R;};
		};
    };
};