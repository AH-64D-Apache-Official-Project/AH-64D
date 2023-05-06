#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_utilities {
        tag="fza_util";
        class functions {
            file = "\fza_ah64_utilities\functions";
            class addKeybind {R;};
            class clampedMove {R;};
            class cycle {R;};
            class displayTime {R;};
            class drawLine {R;};
            class getArea {R;};
            class linearInterp {R;};
            class padString {R;};
            class setArrayVariable {R;};
        };
    };
};