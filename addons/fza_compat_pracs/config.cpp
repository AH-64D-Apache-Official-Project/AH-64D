class CfgPatches
{
    class fza_compat_pracs
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"fza_ah64_controls", "PRACS_SLA_Core"};
        skipWhenMissingDependencies = 1;
    };
};

#include "CfgVehicles.hpp"
