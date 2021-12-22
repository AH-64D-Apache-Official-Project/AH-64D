class CfgPatches
{
	class fza_ah64_mpd
	{
        units[] = {};
		author = "Franze, Nodunit, Sacha 'Voodooflies' Oropeza, Keplager & Community";
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"fza_ah64_controls"};
    };
};

#include "headers\mpd_defines.hpp"
#include "headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"

#include "CfgFunctions.hpp"
#include "CfgMagazines.hpp"
#include "CfgVehicles.hpp"

#include "FzaIconTypes.hpp"

class Extended_PreInit_EventHandlers {
	class fza_ah64_mpd_PreInits {
		init = "call compile preprocessFileLineNumbers 'fza_ah64_mpd\XEH_preInit.sqf';";
	};
};