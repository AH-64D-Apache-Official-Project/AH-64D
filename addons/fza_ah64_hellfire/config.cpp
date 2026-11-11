class CfgPatches
{
    class fza_ah64_hellfire
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "ace_hellfire", "ace_missileguidance"};
        #include "version.hpp"
    };
};

#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\fza_ah64_controls\config\defines.hpp"

#include "ACE_GuidanceConfig.hpp"
#include "CfgAmmo.hpp"
#include "CfgFunctions.hpp"
#include "CfgNonAIVehicles.hpp"
#include "CfgSoundSets.hpp"
#include "CfgSoundShaders.hpp"
#include "CfgMagazines.hpp"
#include "CfgWeapons.hpp"

class Extended_PreInit_EventHandlers {
    class fza_hellfire_PreInits {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_hellfire\XEH_preInit.sqf';";
    };
};

class Extended_FiredBIS_EventHandlers {
    class fza_ah64base {
        class fza_hellfire_fired_eh {
            firedBIS = "_this call fza_hellfire_fnc_blastFired;";
        };
    };
};
