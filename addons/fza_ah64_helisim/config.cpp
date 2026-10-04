class CfgPatches
{
    class fza_ah64_helisim
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"bmkhs_helisim", "fza_ah64_controls", "fza_ah64_audio"};
        //The airframe this pack drives. Its preInit reads this to know what to schedule,
        //so a pack for another aircraft changes one line and touches no SQF.
        bmkhsBaseClass   = "fza_ah64base";
        #include "version.hpp"
    };
};

#include "CfgFunctions.hpp"
#include "config\CfgEventHandlers.hpp"
#include "config\CfgUserActions.hpp"
#include "config\cfgVehicles.hpp"
