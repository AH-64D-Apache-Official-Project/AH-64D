#ifdef __A3_DEBUG__
#define RECOMPILE_FLAG recompile = 1
#else
#define RECOMPILE_FLAG recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_fcr {
        tag="fza_fcr";
        class functions {
            file = "\fza_ah64_fcr\functions";
            class controller {RECOMPILE_FLAG;};
            class cycleNts {RECOMPILE_FLAG;};
            class init {RECOMPILE_FLAG;};
            class postProccess {RECOMPILE_FLAG;};
            class stateControl {RECOMPILE_FLAG;};
            class update {RECOMPILE_FLAG;}; 
        };
    };
};