class CfgPatches
{
	class fza_ah64_dms
	{
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
		weapons[] = {};
		requiredVersion = 2.10;
		requiredAddons[] = {"fza_ah64_controls"};
        #include "version.hpp"
    };
};

#include "\fza_ah64_controls\config\defines.hpp"
#include "headers\constants.h"
#include "extendedEventHandlers.hpp"

#include "Cfg3DEN.hpp"
#include "CfgFunctions.hpp"
#include "CfgVehicleClasses.hpp"
#include "CfgVehicles.hpp"
