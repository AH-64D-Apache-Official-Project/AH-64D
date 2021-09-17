#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
	class fza_ah64_project_AICrew
	{
        tag = "FZA_AICrew";
		class functions {
			file = "\fza_ah64_AICrew\functions"; 
			class coreUpdate {R;};
			class engineStart {R;};
			class fireControl {R;};
			class init {R;};
			class getIn {R;};
			class GetOut {R;};
			class asecontrol {R;};
			class floodlight {R;};
		};
    };
};
