class CfgPatches
{
    class fza_compat_doom
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_mpd", "fza_ah64_doom"};
        skipWhenMissingDependencies = 1;
        #include "version.hpp"
    };
};

#include "CfgVehicles.hpp"
