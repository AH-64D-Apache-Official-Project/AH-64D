#include "BIS_AddonInfo.hpp"
class CfgPatches {
    class fza_ah64_controls {
        units[] = {"fza_ah64base","fza_ah64d_b1","fza_ah64d_b2e","fza_ah64_pilot"};
        author = "AH-64D Development Team";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"A3_Air_F_Beta","A3_Sounds_F","A3_Data_F", "cba_main", "cba_xeh"/*, "fza_ah64_ase", "fza_ah64_audio", "fza_ah64_auxtank", "fza_ah64_cannon", "fza_ah64_common", "fza_ah64_crew", "fza_ah64_customise", "fza_ah64_dms", "fza_ah64_fcr", "fza_ah64_fire", "fza_ah64_hatchet", "fza_ah64_hellfire", "fza_ah64_hydra", "fza_ah64_ihadss", "fza_ah64_ku", "fza_ah64_light", "fza_ah64_mpd", "fza_ah64_sfmplus", "fza_ah64_systems", "fza_ah64_ufd", "fza_ah64_us", "fza_ah64_wca", "fza_ah64_weapons"*/};
        version = 2.2.5;
        versionStr = "2.2.5";
        versionAr[] = {2, 2, 5};
    };
};

class SensorTemplateActiveRadar;
class SensorTemplatePassiveRadar;
class SensorTemplateLaser;
#include "config\defines.hpp"
#include "config\misc.hpp"

#include "config\CfgAnimationSourceSounds.hpp"
#include "config\CfgSounds.hpp"
#include "config\CfgMoves.hpp"
#include "config\CfgNonAIVehicles.hpp"
#include "config\CfgVehicles.hpp"
#include "config\CfgCloudlets.hpp"

#include "config\CfgFunctions.hpp"
#include "config\extendedEventHandlers.hpp"

#include "config\CfgSound3DProcessors.hpp"
#include "config\CfgSoundCurves.hpp"
#include "config\cfgDistanceFilters.hpp"
#include "config\CfgSoundShaders.hpp"
#include "config\CfgSoundSets.hpp"

#include "config\CfgUserActions.hpp"
#include "config\UserActionGroups.hpp"
#include "config\UserActionsConflictGroups.hpp"
#include "config\CfgDefaultKeysPresets.hpp"

#include "config\CfgVideoOptions.hpp"
#include "config\CfgUi.hpp"

#include "config\CfgSettings.hpp"