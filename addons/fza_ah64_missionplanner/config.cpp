class CfgPatches
{
    class fza_ah64_missionplanner
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls"};
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

class CBA_Settings {
    class fza_mplanner_ammoLimitEnable {
        typeName = "BOOL";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_LIMIT_ENABLE";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_LIMIT_ENABLE_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = 0;
    };
    class fza_mplanner_ammo_AGM114K {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_AGM114K";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_AGM114L {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_AGM114L";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_AGM114K2A {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_AGM114K2A";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_AGM114FA {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_AGM114FA";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_AGM114N {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_AGM114N";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_M151 {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_M151";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_M261 {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_M261";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_M255A1 {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_M255A1";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_M257 {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_M257";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_M278 {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_M278";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
    class fza_mplanner_ammo_M230 {
        typeName = "SCALAR";
        isClientSettable = 1;
        displayName = "$STR_FZA_AH64_MPLANNER_AMMO_M230";
        description = "$STR_FZA_AH64_MPLANNER_AMMO_DESC";
        category = "$STR_FZA_AH64_MPLANNER_SETTINGS";
        value = -1;
    };
};
