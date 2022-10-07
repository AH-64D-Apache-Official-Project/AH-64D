
#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
	class fza_ah64_Misc	{
		tag = "fza_misc";
		class Customise {
			file = "\fza_ah64_misc\functions";
			class CustomiseCanAdd {R;};
			class CustomiseCanRemove {R;};
			class CustomiseAdd {R;};
			class CustomiseRemove {R;};
		};
	};
};