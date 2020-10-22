#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "l3": {
		[_heli, 1, "ase"] call fza_fnc_mpdSetDisplay;
	};
	case "l4": {
		[_heli, 1, "tsd"] call fza_fnc_mpdSetDisplay;
	};
	case "l6": {
		[_heli, 1, "fcr"] call fza_fnc_mpdSetDisplay;
	};
	case "b1": {
		[_heli, 1, "eng"] call fza_fnc_mpdSetDisplay;
	};
	case "tsd": {
		[_heli, 1, "tsd"] call fza_fnc_mpdSetDisplay;
	};
	case "fcr" : {
		[_heli, 1, "fcr"] call fza_fnc_mpdSetDisplay;
	};
	case "m": {
		[_heli, 1, "wca"] call fza_fnc_mpdSetDisplay;
	};
};