class CfgPatches {
    class fza_ah64_cannon{
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"fza_ah64_controls"};
        #include "version.hpp"
    };
};

#include "\fza_ah64_controls\config\defines.hpp"

#include "CfgAmmo.hpp"
#include "CfgFunctions.hpp"
#include "CfgMagazines.hpp"
#include "CfgSoundSets.hpp"
#include "CfgSoundShaders.hpp"
#include "CfgWeapons.hpp"
