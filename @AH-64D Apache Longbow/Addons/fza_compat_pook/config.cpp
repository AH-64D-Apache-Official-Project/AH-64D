class CfgPatches
{
    class fza_compat_pook
    {
        units[] = {};
        author = "AH-64D Development Team";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"fza_ah64_controls", "pook_SAM_Base"};
        skipWhenMissingDependencies = 1;
    };
};

#include "CfgVehicles.hpp"