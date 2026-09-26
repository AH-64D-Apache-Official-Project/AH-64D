class CfgPatches
{
    class fza_ah64_minigames
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_mpd", "fza_ah64_controls", "cba_main"};
        #include "version.hpp"
    };
};

#include "CfgFunctions.hpp"
#include "RscFzaMinigame.hpp"
#include "cfgSounds.hpp"

class Extended_PreInit_EventHandlers {
    class fza_ah64_minigames_PreInits {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_minigames\XEH_preInit.sqf';";
    };
};
