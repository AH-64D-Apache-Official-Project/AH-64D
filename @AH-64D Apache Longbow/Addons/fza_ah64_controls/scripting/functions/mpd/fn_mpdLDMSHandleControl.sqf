params ["_heli", "_system", "_control"];

switch(_control) do {
	case "b2": {
		[_heli, 0, "flt"] call fza_fnc_mpdSetDisplay;
	};
	case "b3": {
		[_heli, 0, "fuel"] call fza_fnc_mpdSetDisplay;
	};
	case "l5": {
		[_heli, 0, "wpn"] call fza_fnc_mpdSetDisplay;
	};
	case "wpn": {
		[_heli, 0, "wpn"] call fza_fnc_mpdSetDisplay;
	};
	case "m": {
		[_heli, 0, "wca"] call fza_fnc_mpdSetDisplay;
	};
};