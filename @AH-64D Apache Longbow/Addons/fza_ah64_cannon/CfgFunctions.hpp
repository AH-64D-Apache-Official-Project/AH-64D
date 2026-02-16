#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions {
    class fza_ah64_cannon {
        tag = "fza_cannon";
        class functions {
            file = "\fza_ah64_cannon\functions";
            class fired {R;};
            class init {R;};
            class update {R;};
        };
    };
};