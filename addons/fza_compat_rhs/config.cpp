class CfgPatches
{
    class fza_compat_rhs
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "rhs_c_a2port_armor"};
        skipWhenMissingDependencies = 1;
        #include "version.hpp"
        
    };
};

#include "CfgVehicles.hpp"
