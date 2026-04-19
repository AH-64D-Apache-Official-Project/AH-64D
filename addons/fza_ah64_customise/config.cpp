class CfgPatches
{
    class fza_ah64_customise
    {
        units[] = {"fza_ah64_FireControlRadar", "fza_ah64_IAFS", "fza_ah64_1200Magazine"};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "ace_interact_menu"};
        #include "version.hpp"
    };
};

class CfgEditorCategories
{
    class EdCat_fza_ah64_Parts
    {
        displayName = "AH-64 Parts";
    };
};
class CfgEditorSubcategories
{
    class EdSubcat_fza_ah64_Magazines
    {
        displayName = "AH-64 Magazines";
    };
    class EdSubcat_fza_ah64_Components
    {
        displayName = "AH-64 Components";
    };
};

#include "cfgVehicles.hpp"
#include "cfgFunctions.hpp"
