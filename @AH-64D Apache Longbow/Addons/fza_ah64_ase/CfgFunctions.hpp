#ifdef __A3_DEBUG__
#define RECOMPILE_FLAG recompile = 1
#else
#define RECOMPILE_FLAG recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_ase {
        tag="fza_ase";
        class functions {
            file = "\fza_ah64_ase\functions";
            class adaClassification {RECOMPILE_FLAG;};
            class audioController {RECOMPILE_FLAG;};
            class bearingClock {RECOMPILE_FLAG;};
            class chaff {RECOMPILE_FLAG;};
            class controller {RECOMPILE_FLAG;};
            class flare {RECOMPILE_FLAG;};
            class init {RECOMPILE_FLAG;};
            class irJam {RECOMPILE_FLAG;};
            class missileWarning {RECOMPILE_FLAG;};
            class rlwr {RECOMPILE_FLAG;};
            class rlwrGetIdent {RECOMPILE_FLAG;};
            class swapFlares {RECOMPILE_FLAG;};
            class targetIsADA {RECOMPILE_FLAG;};
        };
    };
};