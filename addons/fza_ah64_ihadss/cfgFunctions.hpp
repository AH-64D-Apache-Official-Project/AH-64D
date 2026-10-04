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
            class angleToScreen {R;};
            class constraintBoxDraw {R;};
            class cscopeDraw {R;};
            class fovControl {R;};
            class getVisionMode {R;};
            class controller {R;};
            class draw {R;};
            class handleControl {R;};
            class init {R;};
            class linearMotionCompensator {R;};
            class monocletoggle {R;};
            class pnvsControl {R;};
            class steeringCursorDraw {R;};
        };
        class canvas {
            file = "\fza_ah64_ihadss\functions\canvas";
            class canvasAdjust {R;};
            class canvasDrawLine {R;};
            class canvasDraw {R;};
        };
        class flight {
            file = "\fza_ah64_ihadss\functions\flight";
            class flightVelocityVector {R;};
        };
    };
};
