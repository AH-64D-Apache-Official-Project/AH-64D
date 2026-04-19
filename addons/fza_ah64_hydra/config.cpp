class CfgPatches
{
    class fza_ah64_hydra
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls"};
        #include "version.hpp"
    };
};
#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\fza_ah64_controls\config\defines.hpp"

#include "CfgAmmo.hpp"
#include "CfgFunctions.hpp"
#include "CfgMagazines.hpp"
#include "CfgNonAIVehicles.hpp"
#include "CfgSoundSets.hpp"
#include "CfgSoundShaders.hpp"
#include "CfgWeapons.hpp"
