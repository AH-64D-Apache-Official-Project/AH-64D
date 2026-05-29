class CfgPatches
{
    class fza_ah64_missionplanner
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "cba_main"};
        #include "version.hpp"
    };
};

#include "CfgFunctions.hpp"
#include "RscDisplay.hpp"

class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class ACE_Actions;
    };
    class fza_ah64base : Helicopter_Base_F {
        class ACE_Actions : ACE_Actions {
            class fza_MissionPlanner {
                displayName     = "Mission Planner";
                condition       = "alive _target";
                statement       = "[_target] call fza_mplanner_fnc_open;";
                distance        = 15;
                showDisabled    = 0;
                icon            = "";
            };
        };
    };
};

class Extended_PreInit_EventHandlers {
    class fza_ah64_mplanner_PreInits {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_missionplanner\XEH_preInit.sqf';";
    };
};
