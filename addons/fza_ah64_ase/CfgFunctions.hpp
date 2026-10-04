// recompile = 1 UNCONDITIONALLY - required for -filePatching to work.
// This was gated behind `#ifdef __A3_DEBUG__`, which is DEAD CODE under HEMTT: that macro
// is hardcoded to 0 in a table the #ifdef existence check never consults, and cannot be
// defined (no project.toml key, no CLI flag). The #else branch always won, so every
// function was built compile-once-and-cache and patched .sqf files were never re-read.
// Costs nothing without -filePatching: no loose file exists, so it compiles the PBO copy
// once at mission start as before. See addons/bmkhs_helisim/cfgFunctions.hpp for the
// full write-up, and .hemtt/project.toml for the matching .sqfc exclude (both are needed).
#define RECOMPILE_FLAG recompile = 1
class CfgFunctions
{
    class fza_ah64_ase {
        tag="fza_ase";
        class functions {
            file = "\fza_ah64_ase\functions";
            class aseManager {RECOMPILE_FLAG;};
            class audioController {RECOMPILE_FLAG;};
            class bearingClock {RECOMPILE_FLAG;};
            class classification {RECOMPILE_FLAG;};
            class init {RECOMPILE_FLAG;};
            class swapFlares {RECOMPILE_FLAG;};
            class targetIsADA {RECOMPILE_FLAG;};
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
            class mws {RECOMPILE_FLAG;};
            class lwr {RECOMPILE_FLAG;};
            class rwr {RECOMPILE_FLAG;};
        };
    };
};
