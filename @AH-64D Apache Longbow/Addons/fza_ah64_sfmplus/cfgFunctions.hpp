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
		class fuselage {
			file = "\fza_ah64_sfmplus\functions\fuselage";
			class fuselageDrag {R;};
		};
		class interact {
			file = "\fza_ah64_sfmplus\functions\interact";
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
		class simpleRotor {
			file = "\fza_ah64_sfmplus\functions\simpleRotor";
			class simpleRotor {R;};
			class simpleRotorNewtRaphSolver {R;};
			class simpleRotorVariables {R;};
		};
		class utility {
			file = "\fza_ah64_sfmplus\functions";
			class clampedMove {R;};
			class drawLine {R;};
			class getArea {R;};
			class getInput {R;};
			class getRtrRPM {R;};
			class setArrayVariable {R;};
		};
    };
};