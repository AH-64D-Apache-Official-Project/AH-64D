#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
	class fza_ah64_project_aifunction
	{
        tag = "FZA_aifunction";
		class functions {
			file = "\fza_ah64_aifunction\functions"; 
			class coreUpdate {R;};
			class engineStart {R;};
			class fireControl {R;};
			class engineStartSequence {R;};
		};
    };
};
