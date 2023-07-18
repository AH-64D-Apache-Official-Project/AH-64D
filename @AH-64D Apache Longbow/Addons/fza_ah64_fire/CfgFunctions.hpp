#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_fire {
        tag="fza_fire";
        class functions {
            file = "\fza_ah64_fire\functions";
            class damageSystem {R;};
            class damageEnginefire {R;};
            class init {R;};
            class handleControl {R;};
            class handleRearm {R;};
            class handlepanel {R;};
            class update {R;};
        };
    };
};