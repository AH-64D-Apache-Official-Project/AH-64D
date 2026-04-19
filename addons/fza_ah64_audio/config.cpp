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
