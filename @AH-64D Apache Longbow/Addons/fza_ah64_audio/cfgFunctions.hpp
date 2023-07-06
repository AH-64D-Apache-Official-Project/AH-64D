#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_project_audio
    {
        tag = "FZA_audio";
        class functions {
            file = "\fza_ah64_audio\functions";
            class addASEMessage {R;};
            class addCaution {R;};
            class addWarning {R;};
            class audiohandler {R;};
            class audioinit {R;};
            class delCaution {R;};
            class delWarning {R;};
            class getin {R;};
            class playaudio {R;};
            class playAdvisory {R;};
        };
    };
};