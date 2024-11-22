#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
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
            class linearMotionCompensator {R;}
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