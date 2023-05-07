class CfgPatches
{
    class fza_ah64_customise
    {
        units[] = {"fza_ah64_FireControlRadar", "fza_ah64_IAFS", "fza_ah64_1200Magazine"};
        author ="Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Rosd6(Dryden) & Community";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"fza_ah64_controls"};
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

#include "Config\cfgVehicles.hpp"
#include "Config\cfgFunctions.hpp"