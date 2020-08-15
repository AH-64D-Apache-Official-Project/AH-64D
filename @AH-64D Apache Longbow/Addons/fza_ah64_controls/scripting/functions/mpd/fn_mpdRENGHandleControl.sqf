#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "b5": {
		[_heli, 1, "wca"] call fza_fnc_mpdSetDisplay;
	};
	case "fcr" : {
		[_heli, 1, "fcr"] call fza_fnc_mpdSetDisplay;
	};
	case "tsd": {
		[_heli, 1, "tsd"] call fza_fnc_mpdSetDisplay;
	};
	case "m": {
		[_heli, 1, "dms"] call fza_fnc_mpdSetDisplay;
	};
};