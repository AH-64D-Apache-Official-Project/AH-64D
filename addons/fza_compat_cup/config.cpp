class CfgPatches
{
    class fza_compat_cup
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"fza_ah64_controls", "CUP_TrackedVehicles_NewM113", "CUP_WheeledVehicles_NewM1097", "CUP_TrackedVehicles_Bradley"};
        skipWhenMissingDependencies = 1;
        #include "version.hpp"
    };
};

#include "CfgVehicles.hpp"
