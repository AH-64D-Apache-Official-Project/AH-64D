#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_auxtank {
        tag="fza_auxtank";
        class functions {
            file = "\fza_ah64_auxtank\functions";
            class damage {R;};
        };
    };
};