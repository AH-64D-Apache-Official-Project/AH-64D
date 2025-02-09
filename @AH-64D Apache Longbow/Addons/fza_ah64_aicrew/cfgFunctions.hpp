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
            class fireControl {R;};
            class getIn {R;};
            class getOut {R;};
            class floodlight {R;};
        };
    };
};
