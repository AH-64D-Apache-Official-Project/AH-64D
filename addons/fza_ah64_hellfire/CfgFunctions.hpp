// recompile = 1 UNCONDITIONALLY - required for -filePatching to work.
// This was gated behind `#ifdef __A3_DEBUG__`, which is DEAD CODE under HEMTT: that macro
// is hardcoded to 0 in a table the #ifdef existence check never consults, and cannot be
// defined (no project.toml key, no CLI flag). The #else branch always won, so every
// function was built compile-once-and-cache and patched .sqf files were never re-read.
// Costs nothing without -filePatching: no loose file exists, so it compiles the PBO copy
// once at mission start as before. See addons/bmkhs_helisim/cfgFunctions.hpp for the
// full write-up, and .hemtt/project.toml for the matching .sqfc exclude (both are needed).
#define RECOMPILE_FLAG recompile = 1
class CfgFunctions
{
    class fza_ah64_hellfire {
        tag="fza_hellfire";
        class functions {
            file = "\fza_ah64_hellfire\functions";
            class controller             {RECOMPILE_FLAG;};
            class syncAceMissileParams    {RECOMPILE_FLAG;};
            class tadsRfHandoffUpdate    {RECOMPILE_FLAG;};
            class tadsRfHandoffReset     {RECOMPILE_FLAG;};
            class arhOnFired              {RECOMPILE_FLAG;};
            class arhSeekerUpdate         {RECOMPILE_FLAG;};
            class arhTargetConstraint     {RECOMPILE_FLAG;};
            class isTargetInSeekerCone    {RECOMPILE_FLAG;};
            class checkLos                {RECOMPILE_FLAG;};
            class trajectoryToAceProfile  {RECOMPILE_FLAG;};
            class init                    {RECOMPILE_FLAG;};
            class salOnFired              {RECOMPILE_FLAG;};
            class salFindLaserDesignation {RECOMPILE_FLAG;};
            class salCanLockBeforeLaunch  {RECOMPILE_FLAG;};
            class checkChaffDefeat        {RECOMPILE_FLAG;};
        };
    };
};
