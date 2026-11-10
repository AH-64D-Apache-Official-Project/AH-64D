class CfgPatches
{
    class fza_ah64_setup
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "fza_ah64_helisim", "fza_ah64_mpd", "cba_settings", "ace_interaction"};
        #include "version.hpp"
    };
};

#include "CfgFunctions.hpp"
#include "RscDisplay.hpp"

class CfgVehicles {
    class Air;
    class Helicopter: Air {
        class ACE_Actions;
        class ACE_SelfActions;
    };
    class Helicopter_Base_F: Helicopter {
        class ACE_Actions: ACE_Actions {
            class ACE_MainActions;
        };
    };
    class fza_ah64base : Helicopter_Base_F {
        class ACE_Actions : ACE_Actions {
            class ACE_MainActions : ACE_MainActions {
                class fza_ControlSetup {
                    displayName     = "Controls Setup";
                    condition       = "alive _target";
                    statement       = "[] call fza_setup_fnc_open;";
                    distance        = 15;
                    showDisabled    = 0;
                    icon            = "";
                };
            };
        };
        class ACE_SelfActions: ACE_SelfActions {
            class fza_ControlSetupCrew {
                displayName     = "Controls Setup";
                condition       = "_player in crew _target";
                statement       = "[] call fza_setup_fnc_open;";
                showDisabled    = 0;
                icon            = "";
            };
        };
    };
};
