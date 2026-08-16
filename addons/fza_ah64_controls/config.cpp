#include "BIS_AddonInfo.hpp"
class CfgPatches {
    class fza_ah64_controls {
        units[] = {"fza_ah64base","fza_ah64d_b1"};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"A3_Air_F_Beta","A3_Sounds_F","A3_Data_F", "cba_main", "cba_xeh"};
        #include "version.hpp"
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

// Control Input Visualiser UI
#include "uiConfig\RscCtrlVis.hpp"
#include "config\CfgUi.hpp"

#include "config\CfgSettings.hpp"
