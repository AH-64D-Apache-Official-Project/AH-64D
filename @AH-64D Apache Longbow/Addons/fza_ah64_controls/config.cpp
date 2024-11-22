#include "BIS_AddonInfo.hpp"
class CfgPatches
{
    class fza_ah64_controls
    {
        units[] = {"fza_ah64base","fza_ah64d_b2e","fza_ah64d_b2e_heliSim","fza_ah64_pilot"};
        author="Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Snow(Dryden) & Community";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"A3_Air_F_Beta","A3_Sounds_F","A3_Data_F", "cba_main", "cba_xeh", "fza_ah64_sfmplus", "fza_ah64_aiCrew", "fza_ah64_audio", "fza_ah64_ihadss", "fza_ah64_fcr"};
        version = 2.2.1;
        versionStr = "2.2.1";
        versionAr[] = {2, 2, 1};
    };
};
class CfgAddons
{
    class PreloadBanks{};
    class PreloadAddons
    {
        class fza_ah64_controls
        {
            list[] = {"fza_ah64_controls", "fza_ah64_sfmplus", "fza_ah64_AICrew", "fza_ah64_dms", "fza_ah64_ku", "fza_ah64_mpd", "fza_ah64_ufd", "fza_ah64_audio","fza_ah64_ihadss", "fza_ah64_customise", "fza_ah64_fcr"};
        };
    };
};

/*extern*/ class SensorTemplateActiveRadar;
/*extern*/ class SensorTemplatePassiveRadar;
/*extern*/ class SensorTemplateLaser;
#include "config\defines.hpp"
#include "config\misc.hpp"

#include "config\CfgAnimationSourceSounds.hpp"
#include "config\CfgMoves.hpp"
#include "config\CfgNonAIVehicles.hpp"
#include "config\CfgVehicles.hpp"
#include "config\CfgCloudlets.hpp"

#include "config\CfgFunctions.hpp"
#include "config\extendedEventHandlers.hpp"

#include "config\CfgUserActions.hpp"
#include "config\UserActionGroups.hpp"
#include "config\UserActionsConflictGroups.hpp"
#include "config\CfgDefaultKeysPresets.hpp"

#include "config\CfgVideoOptions.hpp"
#include "config\CfgUi.hpp"

#include "config\CfgSettings.hpp"