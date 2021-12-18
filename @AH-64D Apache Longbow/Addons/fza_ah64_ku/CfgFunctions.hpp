#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_ku {
        tag="fza_ku";
        class functions {
            file = "\fza_ah64_ku\functions";
            class addPrompt{R;};
            class enter{R;};
            class handleInput{R;};
            class init{R;};
            class toggleInput{R;};
            class update{R;};
        };
    };
};