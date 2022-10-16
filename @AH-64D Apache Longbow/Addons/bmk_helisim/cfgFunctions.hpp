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
			class core_Config {R;};
			class core_Update {R;};
		};
		class mainRotor {					
			file = "\bmk_helisim\functions\mainRotor";
			class mainRotor_CalculateThrust {R;};
			class mainRotor_HubToControlAxes {R;};
			class mainRotor_UpdateControlAngles {R;};
			class mainRotor_Variables {R;};
			class mainRotor {R;};
		};
		class utility {
			file = "\bmk_helisim\functions\utility";
			class utility_ArmaToModel {R;};
			class utility_GetInput {R;};
		};
    };
};