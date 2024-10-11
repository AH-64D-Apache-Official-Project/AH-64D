class CfgPatches
{
    class fza_ah64_sfx
    {
        units[] = {};
        author = "Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Snow(Dryden) & Community";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {};
    };
};
//#include "CfgFunctions.hpp"

#include "CfgDistanceFilters.hpp"
#include "CfgSound3DProcessors.hpp"
#include "CfgSoundCurves.hpp"
#include "cfgSounds.hpp"
#include "CfgSoundSets.hpp"
#include "CfgSoundShaders.hpp"
#include "CfgSoundShapes.hpp"

class CfgVehicles
{
    class Helicopter_Base_F;
    class fza_ah64base : Helicopter_Base_F {
        soundEngineOffExt[] = {"a3\sounds_f\dummysound",1,1,1};
        soundEngineOffInt[] = {"a3\sounds_f\dummysound", 1,1};
        soundEngineOnExt[] = {"a3\sounds_f\dummysound",1,1,1};
        soundEngineOnInt[] = {"a3\sounds_f\dummysound",1,1};
        class Sounds {
            soundSets[] = {""};
            soundSetsInt[] = {
                "fza_batteryInt_soundset",
                "fza_apuIntPlt_soundset",
                "fza_apuIntCpg_soundset"
            };
            soundSetsExt[] = {
                "fza_batteryExtPlt_soundset",
                "fza_batteryExtCpg_soundset",
                "fza_apuExt_soundset"
            };
        };
    };
};