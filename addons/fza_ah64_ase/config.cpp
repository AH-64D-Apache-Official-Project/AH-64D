class CfgPatches
{
    class fza_ah64_ase
    {
        units[] = {"fza_ah64_rJamStatic"};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_controls", "A3_Data_F_Jets_Loadorder", "A3_Data_F_Tank_Loadorder","A3_Data_F_Sams_Loadorder", "A3_Data_F_Loadorder", "A3_Sounds_F_Enoch"};
        #include "version.hpp"
    };
};

#include "\fza_ah64_controls\config\defines.hpp"

#include "CfgAmmo.hpp"
#include "CfgCloudlets.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFunctions.hpp"
#include "CfgMagazines.hpp"
#include "CfgSoundSets.hpp"
#include "CfgSoundShaders.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
