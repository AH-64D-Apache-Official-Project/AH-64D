class CfgPatches
{
    class fza_ah64_docs
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        // fza_ah64_setup defines the AH-64 Misc ACE category the Manual goes in
        requiredAddons[] = {"fza_ah64_controls", "fza_ah64_mpd", "fza_ah64_setup", "cba_main", "ace_interact_menu"};
        #include "version.hpp"
    };
};

#include "CfgFunctions.hpp"
#include "CfgFzaDocs.hpp"
#include "RscDisplay.hpp"
