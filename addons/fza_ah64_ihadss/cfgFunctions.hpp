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
    class fza_ah64_project_ihadss
    {
        tag = "fza_ihadss";
        class functions {
            file = "\fza_ah64_ihadss\functions";
            class cscopeProfileDraw {R;};
            class fovControl {R;};
            class getVisionMode {R;};
            class controller {R;};
            class draw {R;};
            class handleControl {R;};
            class hduCleanContainer {R;};
            class hduInit {R;};
            class hduUpdate {R;};
            class init {R;};
            class linearMotionCompensator {R;};
            class monocletoggle {R;};
            class nvsBias {R;};
            class nvsFixedToScreen {R;};
            class nvsFixedView {R;};
            class nvsState {R;};
            class pnvsControl {R;};
            class tadsNvs {R;};
            class tadsNvsControl {R;};
            class tadsSlew {R;};
        };
        class html {
            file = "\fza_ah64_ihadss\functions\html";
            class formatRect {R;};
            class hduMonocle {R;};
            class hduPnvsMask {R;};
            class htmlConstraints {R;};
            class htmlDraw {R;};
            class htmlExecJs {R;};
            class htmlIcons {R;};
            class htmlModel {R;};
            class viewScale {R;};
        };
    };
};
