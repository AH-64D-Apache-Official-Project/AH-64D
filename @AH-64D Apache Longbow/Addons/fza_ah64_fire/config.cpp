class CfgPatches
{
    class fza_ah64_fire
    {
        units[] = {};
        author = "AH-64D Development Team";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"fza_ah64_controls"};
    };
};

#include "CfgFunctions.hpp"

class Extended_PreInit_EventHandlers {
    class fza_fire_ah64_PreInits {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_fire\XEH_preInit.sqf';";
    };
};