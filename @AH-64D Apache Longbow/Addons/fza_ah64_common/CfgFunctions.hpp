#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_common {
        tag="fza";
        class functions {
            file = "\fza_ah64_common\functions";
            class addKeybind {R;};
            class calculateSideslip {R;};
            class cycle {R;};
            class debugDrawCircle {R;};
            class debugDrawLine {R;};
            class getArea {R;};
            class linearInterp {R;};
            class padString {R;};
            class setArrayVariable {R;};
            class sign {R;};
        };
        class pid {
            file = "\fza_ah64_common\functions\pid";
            class pidCreate {R;};
            class pidReset {R;};
            class pidRun {R;};
        };
    };
};