#ifdef __A3_DEBUG__
#define RECOMPILE_FLAG recompile = 1
#else
#define RECOMPILE_FLAG recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_hellfire {
        tag="fza_hellfire";
        class functions {
            file = "\fza_ah64_hellfire\functions";
            class aceController {RECOMPILE_FLAG;};
            class arhFired {RECOMPILE_FLAG;};
            class arhSeeker {RECOMPILE_FLAG;};
            class checkSeekerAngle {RECOMPILE_FLAG;};
            class dmsShot {RECOMPILE_FLAG;};
            class getAttackProfile {RECOMPILE_FLAG;};
            class init {RECOMPILE_FLAG;};
            class limaLoblCheck {RECOMPILE_FLAG;};
            class salFired {RECOMPILE_FLAG;};
            class salLasePos {RECOMPILE_FLAG;};
            class salShouldStartLobl {RECOMPILE_FLAG;};
        };
    };
};