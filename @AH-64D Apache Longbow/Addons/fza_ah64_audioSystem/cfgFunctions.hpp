#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
	class fza_ah64_project_audioSystem
	{
		tag = "FZA_audioSystem";
		class functions {
			file = "\fza_ah64_audioSystem\functions";
			class addAdvisoryMessage {R;};
			class addASEMessage {R;};
			class addCaution {R;};
			class addWarning {R;};
			class audioSysteminit {R;};
			class getin {R;};
			class playaudio {R;};
			class audioSystemhandler {R;};
        };
    };
};