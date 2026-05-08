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
            class controller             {RECOMPILE_FLAG;};
            class syncAceMissileParams    {RECOMPILE_FLAG;};
            class tadsRfHandoffUpdate    {RECOMPILE_FLAG;};
            class arhOnFired              {RECOMPILE_FLAG;};
            class arhSeekerUpdate         {RECOMPILE_FLAG;};
            class arhTargetConstraint     {RECOMPILE_FLAG;};
            class isTargetInSeekerCone    {RECOMPILE_FLAG;};
            class trajectoryToAceProfile  {RECOMPILE_FLAG;};
            class init                    {RECOMPILE_FLAG;};
            class salOnFired              {RECOMPILE_FLAG;};
            class salFindLaserDesignation {RECOMPILE_FLAG;};
            class salCanLockBeforeLaunch  {RECOMPILE_FLAG;};
        };
    };
};
