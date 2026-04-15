class CfgPatches
{
    class fza_ah64_ufd
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls"};
        #include "version.hpp"
    };
};

#include "\fza_ah64_mpd\headers\mpd_defines.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

#include "CfgFunctions.hpp"
#include "CfgVehicles.hpp"
