#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_project_hydra
    {
        tag = "FZA_hydra";
        class functions {
            file = "\fza_ah64_hydra\functions";
            class eventFired {R;};
        };
    };
};