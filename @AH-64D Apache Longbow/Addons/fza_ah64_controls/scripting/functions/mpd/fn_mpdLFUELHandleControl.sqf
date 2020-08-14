#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "t1": {
		[_heli, 0, "eng"] call fza_ah64_mpdSetDisplay;
	};
	case "t2": {
		[_heli, 0, "flt"] call fza_ah64_mpdSetDisplay;
	};
	case "wpn": {
		[_heli, 0, "wpn"] call fza_ah64_mpdSetDisplay;
	};
	case "m": {
		[_heli, 0, "dms"] call fza_ah64_mpdSetDisplay;
	};
};