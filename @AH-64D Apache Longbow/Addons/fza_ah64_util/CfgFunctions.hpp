#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_util {
        tag="fza_util";
        class functions {
            file = "\fza_ah64_util\functions";
            class addKeybind {R;};
            class cycle {R;};
            class drawLine {R;};
            class getArea {R;};
            class linearInterp {R;};
            class padString {R;};
            class setArrayVariable {R;};
        };
        class pid {
            file = "\fza_ah64_util\functions\pid";
            class pidCreate {R;};
            class pidReset {R;};
            class pidRun {R;};
        };
    };
};