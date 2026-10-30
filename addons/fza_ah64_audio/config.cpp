#include "script_component.hpp"

class CfgPatches
{
    class fza_ah64_audio
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls"};
        #include "version.hpp"
    };
};

#include "cfgFunctions.hpp"
#include "cfgSounds.hpp"
#include "extendedEventHandlers.hpp"

//- Heli Sounds (Engine + Surrounding)
#include "CfgSoundShapes.hpp"
#include "CfgDistanceFilters.hpp"
#include "CfgSound3DProcessors.hpp"
#include "CfgSoundCurves.hpp"

#define fza_Vol_Multi_Int(NUM) __EVAL(0.75*NUM) //- Multiplier for Internal sounds

#include "CfgSoundSets.hpp"
#include "CfgSoundShaders.hpp"
