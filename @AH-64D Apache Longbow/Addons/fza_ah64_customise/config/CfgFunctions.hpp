
#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
	class fza_ah64_customise
	{
		tag = "fza_customise";
		class Customise {
			file = "\fza_ah64_customise\functions";
			class canAdd {R;};
			class canRemove {R;};
			class add {R;};
			class remove {R;};
		};
	};
};