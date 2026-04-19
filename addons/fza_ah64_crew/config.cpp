class CfgPatches {
    class fza_ah64_crew {
        units[] = {"fza_ah64_pilot"};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls"};
        #include "version.hpp"
    };
};

#include "CfgWeapons.hpp"
#include "CfgVehicles.hpp"
