class CfgPatches
{
    class fza_compat_pook
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "pook_SAM_Base"};
        skipWhenMissingDependencies = 1;
        #include "version.hpp"
    };
};

#include "CfgVehicles.hpp"
