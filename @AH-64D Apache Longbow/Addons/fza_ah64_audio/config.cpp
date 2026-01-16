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
#include "CfgSoundShapes.hpp"
#include "cfgDistanceFilters.hpp"
#include "CfgSound3DProcessors.hpp"
#include "CfgSoundCurves.hpp"

#define fza_Vol_Multi_Int(NUM) __EVAL(0.75*NUM) //- Multiplier for Internal sounds

#include "CfgSoundSets.hpp"
#include "CfgSoundShaders.hpp"
