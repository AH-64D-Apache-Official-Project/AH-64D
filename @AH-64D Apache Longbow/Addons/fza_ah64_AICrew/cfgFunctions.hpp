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
			class getin {R;};
			class GetOut {R;};
			class ase {R;};
			class turretaim {R;};
		};
    };
};
