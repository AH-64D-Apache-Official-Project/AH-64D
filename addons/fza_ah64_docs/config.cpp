class CfgPatches
{
    class fza_ah64_docs
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "fza_ah64_mpd", "cba_main", "ace_interaction", "ace_interact_menu"};
        #include "version.hpp"
    };
};

#include "CfgFunctions.hpp"
#include "CfgFzaDocs.hpp"
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
                // fza_docs_fnc_addActions adds the Manual here at mission start
                class fza_misc {
                    displayName     = "AH-64 Misc";
                    condition       = "alive _target";
                    statement       = "";
                    distance        = 15;
                    showDisabled    = 0;
                    icon            = "";
                };
            };
        };
        class ACE_SelfActions: ACE_SelfActions {
            class fza_misc {
                displayName     = "AH-64 Misc";
                condition       = "_player in crew _target";
                statement       = "";
                showDisabled    = 0;
                icon            = "";
            };
        };
    };
};
