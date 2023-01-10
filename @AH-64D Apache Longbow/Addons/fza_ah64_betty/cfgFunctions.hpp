
#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
	class fza_ah64_project_betty
	{
		tag = "FZA_betty";
		class Functions {
			file = "\fza_ah64_betty\functions";
			class addASEMessage {R;};
			class addCaution {R;};
			class addWarning {R;};
			class getin {R;};
			class playsystemAudio {R;};
        };
    };
};