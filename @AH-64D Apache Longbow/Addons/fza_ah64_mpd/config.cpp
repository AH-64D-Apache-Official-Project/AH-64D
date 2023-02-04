class CfgPatches
{
	class fza_ah64_mpd
	{
        units[] = {};
		author ="Franze, Nodunit, Voodooflies, Keplager, mattysmith22, BradMick, Rosd6(Dryden) & Community";
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"fza_ah64_controls","ace_laser"};
    };
};

#include "ui\baseControls.hpp"
#include "ui\ctrls.hpp"
#include "ui\RscFzaAH64MPD.hpp"


#include "headers\tsd.hpp"
#include "headers\mpd_defines.hpp"
#include "headers\mfdConstants.h"

#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"

#include "CfgFunctions.hpp"
#include "CfgMagazines.hpp"
#include "CfgVehicles.hpp"
#include "CfgFontFamilies.hpp"

#include "FzaIconTypes.hpp"

class Extended_PreInit_EventHandlers {
	class fza_ah64_mpd_PreInits {
		init = "call compile preprocessFileLineNumbers 'fza_ah64_mpd\XEH_preInit.sqf';";
	};
};