// recompile = 1 UNCONDITIONALLY - required for -filePatching to work.
// This was gated behind `#ifdef __A3_DEBUG__`, which is DEAD CODE under HEMTT: that macro
// is hardcoded to 0 in a table the #ifdef existence check never consults, and cannot be
// defined (no project.toml key, no CLI flag). The #else branch always won, so every
// function was built compile-once-and-cache and patched .sqf files were never re-read.
// Costs nothing without -filePatching: no loose file exists, so it compiles the PBO copy
// once at mission start as before. See addons/bmkhs_helisim/cfgFunctions.hpp for the
// full write-up, and .hemtt/project.toml for the matching .sqfc exclude (both are needed).
#define R recompile = 1
class CfgFunctions
{
    class fza_ah64_common {
        tag="fza";
        class functions {
            file = "\fza_ah64_common\functions";
            class addKeybind {R;};
            class cycle {R;};
            class debugDrawCircle {R;};
            class debugDrawLine {R;};
            class getArea {R;};
            class getSeat {R;};
            class getSeatVariable {R;};
            class linearInterp {R;};
            class padString {R;};
            class rotateVector {R;};
            class setArrayVariable {R;};
            class setMultiArrayVariable {R;};
            class setSeatVariable {R;};
            class sign {R;};
            class currentTurret {R;};
            class updateNetworkGlobal {R;};
        };
        class pid {
            file = "\fza_ah64_common\functions\pid";
            class pidCreate {R;};
            class pidReset {R;};
            class pidRun {R;};
        };
    };
};
