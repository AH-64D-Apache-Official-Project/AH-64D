#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_wca {
        tag="fza_wca";
        class functions {
            file = "\fza_ah64_wca\functions";
            class update {R;};
        };
    };
};