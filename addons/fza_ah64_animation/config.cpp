class CfgPatches
{
    class fza_ah64_animation
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_common", "bmkhs_helisim"};
        #include "version.hpp"
    };
};

#include "cfgFunctions.hpp"

class Extended_PreInit_EventHandlers {
    class fza_ah64_animation {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_animation\XEH_preInit.sqf';";
    };
};
