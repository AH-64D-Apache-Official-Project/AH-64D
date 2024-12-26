class CfgPatches
{
	class fza_ah64_dms
	{
        units[] = {};
        author = "AH-64D Development Team";
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"fza_ah64_controls"};
    };
};

#include "\fza_ah64_controls\config\defines.hpp"
#include "headers\constants.h"
#include "extendedEventHandlers.hpp"

#include "Cfg3DEN.hpp"
#include "CfgFunctions.hpp"
#include "CfgVehicleClasses.hpp"
#include "CfgVehicles.hpp"