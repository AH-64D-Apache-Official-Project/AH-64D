#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
	class bmk_helisim
	{
        tag = "bmk_helisim";
		class core {					
			file = "\bmk_helisim\functions\core";
			class core_config {R;};
			class core_update {R;};
		};
		class mainRotor {					
			file = "\bmk_helisim\functions\mainRotor";
			class mainRotor_calculateThrust {R;};
			class mainRotor_hubToControlAxes {R;};
			class mainRotor_update {R;};
			class mainRotor_updateControlAngles {R;};
			class mainRotor_variables {R;};
			class mainRotor {R;};
		};
		class utility {
			file = "\bmk_helisim\functions\utility";
			class utility_armaToModel {R;};
			class utility_getInput {R;};
		};
    };
};