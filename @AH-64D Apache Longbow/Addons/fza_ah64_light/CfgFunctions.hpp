#ifdef __A3_DEBUG__
#define RECOMPILE_FLAG recompile = 1
#else
#define RECOMPILE_FLAG recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_light {
        tag="fza_light";
        class functions {
            file = "\fza_ah64_light\functions";
            class controller {RECOMPILE_FLAG;};
            class handleControl {RECOMPILE_FLAG;};
            class init {RECOMPILE_FLAG;};
            class setFloodLight {RECOMPILE_FLAG;};
        };
    };
};