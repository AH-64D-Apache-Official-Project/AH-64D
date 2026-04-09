class CfgPatches
{
    class fza_ah64_fire
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"fza_ah64_controls"};
        #include "version.hpp"
    };
};

#include "CfgFunctions.hpp"

class Extended_PreInit_EventHandlers {
    class fza_fire_ah64_PreInits {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_fire\XEH_preInit.sqf';";
    };
};