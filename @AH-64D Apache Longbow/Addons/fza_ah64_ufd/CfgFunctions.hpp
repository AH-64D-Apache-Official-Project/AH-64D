#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_ufd {
        tag="fza_ufd";
        class functions {
            file = "\fza_ah64_ufd\functions";
            class update{R;};
        };
    };
};