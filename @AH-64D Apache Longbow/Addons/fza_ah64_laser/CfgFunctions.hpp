#ifdef __A3_DEBUG__
#define RECOMPILE_FLAG recompile = 1
#else
#define RECOMPILE_FLAG recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_laser {
        tag="fza_laser";
        class functions {
            file = "\fza_ah64_laser\functions";
            class init {RECOMPILE_FLAG;};
            class update {RECOMPILE_FLAG;};
            class arm {RECOMPILE_FLAG;};
            class disarm {RECOMPILE_FLAG;};
        };
    };
};