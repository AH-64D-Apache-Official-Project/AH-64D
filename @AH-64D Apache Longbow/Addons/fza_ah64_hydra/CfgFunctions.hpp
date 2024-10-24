#ifdef __A3_DEBUG__
#define RECOMPILE_FLAG recompile = 1
#else
#define RECOMPILE_FLAG recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_hydra {
        tag="fza_hydra";
        class functions {
            file = "\fza_ah64_hydra\functions";
            class fired {RECOMPILE_FLAG;};
        };
    };
};