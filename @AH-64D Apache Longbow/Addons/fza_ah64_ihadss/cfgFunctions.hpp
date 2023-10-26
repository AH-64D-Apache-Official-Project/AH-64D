#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_project_ihadss
    {
        tag = "FZA_ihadss";
        class functions {
            file = "\fza_ah64_ihadss\functions";
            class angleToScreen {R;};
            class constraintBoxDraw {R;};
            class cscopeDraw {R;};
            class ihadssController {R;};
            class ihadssDraw {R;};
            class ihadssHandleControl {R;};
            class monocletoggle {R;};
            class steeringCursorDraw {R;};
        };
    };
};