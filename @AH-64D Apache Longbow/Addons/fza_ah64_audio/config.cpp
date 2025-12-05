class CfgPatches
{
    class fza_ah64_audio
    {
        units[] = {};
        author = "AH-64D Development Team";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {};
    };
};

#include "cfgFunctions.hpp"
#include "cfgSounds.hpp"
#include "extendedEventHandlers.hpp"

//- Heli Sounds (Engine + Surrounding)
#include "Sound_configs\CfgSoundShapes.hpp"
#include "Sound_configs\cfgDistanceFilters.hpp"
#include "Sound_configs\CfgSound3DProcessors.hpp"
#include "Sound_configs\CfgSoundCurves.hpp"

#define fza_Vol_Multi_Int(NUM) __EVAL(0.75*NUM) //- Multiplier for Internal sounds

#include "Sound_configs\CfgSoundSets.hpp"
#include "Sound_configs\CfgSoundShaders.hpp"
