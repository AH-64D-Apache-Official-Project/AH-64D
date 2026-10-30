class CfgPatches
{
    class fza_compat_pracs
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "PRACS_Car", "PRACS_Static_2", "PRACS_Tracked"};
        skipWhenMissingDependencies = 1;
    };
};

#include "CfgVehicles.hpp"
