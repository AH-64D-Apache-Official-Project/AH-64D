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
    class fza_ah64_dms {
        tag="fza_dms";
        class functions {
            file = "\fza_ah64_dms\functions";
            class copy{R;};
            class gridToPos{R;};
            class init{R;};
            class latLongToString{R;};
            class posToGrid{R;};
            class posToLatLong{R;};
        };
        class eden {
            file = "\fza_ah64_dms\functions\eden";
            class edenPointModify{R;};
            class edenPointNext{R;};
        };
        class point {
            file = "\fza_ah64_dms\functions\point";
            class pointCreate{R;};
            class pointDelete{R;};
            class pointEditValue{R;};
            class pointFillIconText{R;};
            class pointGetArrayIndex{R;};
            class pointGetIdentDetails{R;};
            class pointGetValue{R;};
            class pointIsValidIdent{R;};
            class pointNextFree{R;};
            class pointParse{R;};
            class pointToString{R;};
            class pointValidIndex{R;};
        };
        class route {
            file = "\fza_ah64_dms\functions\route";
            class routeAddPoint {R;};
            class routeData {R;};
            class routeDelPoint {R;};
            class routeSetDir {R;};
        };
        class shot {
            file = "\fza_ah64_dms\functions\shot";
            class addShotRF {R;};
            class addShotSAL {R;};
            class ageShot {R;};
            class getNearestFcrTargetData {R;};
            class shotIdentFromFcrData {R;};
        };
    };
};
