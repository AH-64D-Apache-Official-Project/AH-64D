
#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_sights
    {
        tag = "fza_sights";
        class targeting {
            file = "\fza_ah64_sights\functions\targeting";
            class targetingAcqVec {R;};
            class targetingCurAcq {R;};
        };
    };
};
