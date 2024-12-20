class CfgPatches
{
    class fza_compat_cup
    {
        units[] = {};
        author = "AH-64D Development Team";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"CUP_TrackedVehicles_NewM113", "CUP_WheeledVehicles_NewM1097", "CUP_TrackedVehicles_Bradley"};
        skipWhenMissingDependencies = 1;
    };
};

#include "CfgVehicles.hpp"