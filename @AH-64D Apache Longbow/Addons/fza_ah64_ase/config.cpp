class CfgPatches
{
    class fza_ah64_ase
    {
        units[] = {};
        author = "AH-64D Development Team";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"A3_Data_F_Jets_Loadorder", "A3_Data_F_Tank_Loadorder","A3_Data_F_Sams_Loadorder", "A3_Data_F_Loadorder"};
    };
};

#include "\fza_ah64_controls\config\defines.hpp"

#include "CfgAmmo.hpp"
#include "CfgCloudlets.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFunctions.hpp"
#include "CfgMagazines.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"