class CfgPatches
{
    class fza_compat_pracs_sla
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "PRACS_Core"};
        skipWhenMissingDependencies = 1;
    };
};

#include "CfgVehicles.hpp"
