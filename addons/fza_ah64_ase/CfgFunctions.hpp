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
            class cmCounts {RECOMPILE_FLAG;};
            class cmds {RECOMPILE_FLAG;};
            class cmdsConsent {RECOMPILE_FLAG;};
            class cmdsDispense {RECOMPILE_FLAG;};
            class cmdsFire {RECOMPILE_FLAG;};
            class cmFired {RECOMPILE_FLAG;};
            class flare {RECOMPILE_FLAG;};
            class irJam {RECOMPILE_FLAG;};
            class restock {RECOMPILE_FLAG;};
        };
        class radarJammer {
            file = "\fza_ah64_ase\functions\radarJammer";
            class rJam {RECOMPILE_FLAG;};
            class rJamAcreSignal {RECOMPILE_FLAG;};
            class rJamChat {RECOMPILE_FLAG;};
            class rJamComms {RECOMPILE_FLAG;};
            class rJamCommsInit {RECOMPILE_FLAG;};
            class rJamEffect {RECOMPILE_FLAG;};
            class rJamOverlay {RECOMPILE_FLAG;};
            class rJamSetMode {RECOMPILE_FLAG;};
            class rJamStatic {RECOMPILE_FLAG;};
            class rJamStaticMakeUp {RECOMPILE_FLAG;};
            class rJamWatch {RECOMPILE_FLAG;};
        };
        class radarDecoy {
            file = "\fza_ah64_ase\functions\radarDecoy";
            class aceDoppler {RECOMPILE_FLAG;};
            class aceRadarChaff {RECOMPILE_FLAG;};
            class aceRadarFilter {RECOMPILE_FLAG;};
            class decoyFired {RECOMPILE_FLAG;};
        };
        class event {
            file = "\fza_ah64_ase\functions\event";
            class missileWarning {RECOMPILE_FLAG;};
        };
        class sensors {
            file = "\fza_ah64_ase\functions\sensors";
            class incoming {RECOMPILE_FLAG;};
            class mws {RECOMPILE_FLAG;};
            class lwr {RECOMPILE_FLAG;};
            class rwr {RECOMPILE_FLAG;};
        };
    };
};
