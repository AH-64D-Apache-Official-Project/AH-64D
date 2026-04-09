class CfgPatches
{
    class fza_ah64_Hatchet
    {
        units[] = {};
        author="Apache Dev Team";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "HCT_core"};
        #include "version.hpp"
    };
};

#define PREFIX FZA //For Language localization macro, Matches the stringtable prefix in the language files
#define COMPONENT AH64 //For Language localization macro, Matches the stringtable prefix in the language files
#include "\x\cba\addons\main\script_macros_common.hpp"

#include "cfgHatchet.hpp"