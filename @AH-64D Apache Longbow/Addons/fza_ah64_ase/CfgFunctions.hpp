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
            class aseManager {RECOMPILE_FLAG;};
            class audioController {RECOMPILE_FLAG;};
            class classification {RECOMPILE_FLAG;};
            class init {RECOMPILE_FLAG;};
            class swapFlares {RECOMPILE_FLAG;};
        };
        class countermeasures {
            file = "\fza_ah64_ase\functions\countermeasures";
            class chaff {RECOMPILE_FLAG;};
            class flare {RECOMPILE_FLAG;};
            class irJam {RECOMPILE_FLAG;};
        };
        class event {
            file = "\fza_ah64_ase\functions\event";
            class missileWarning {RECOMPILE_FLAG;};
        };
        class sensors {
            file = "\fza_ah64_ase\functions\sensors";
            class rwr {RECOMPILE_FLAG;};
        };
    };
};