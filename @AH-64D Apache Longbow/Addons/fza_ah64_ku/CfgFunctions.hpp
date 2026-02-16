#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_ku {
        tag="fza_ku";
        class checkers {
            file = "\fza_ah64_ku\functions\checkers";
            class checkerCode{R;};
            class checkerFree{R;};
            class checkerGrid{R;};
            class checkerInteger{R;};
        };
        class functions {
            file = "\fza_ah64_ku\functions";
            class activateInput{R;};
            class addPrompt{R;};
            class clear{R;};
            class deactivateInput{R;};
            class enter{R;};
            class handleInput{R;};
            class init{R;};
            class stopInput{R;};
            class updateScreen{R;};
        };
    };
};