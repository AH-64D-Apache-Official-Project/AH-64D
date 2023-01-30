#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_mpdIndex", "_control"];

switch(_control) do {
	case "t2": {
		[_heli, _mpdIndex, "flt"] call fza_mpd_fnc_setCurrentPage;
	};
    case "t3": {
		[_heli, _mpdIndex, "fuel"] call fza_mpd_fnc_setCurrentPage;
	};
	case "t4": {
		[_heli, _mpdIndex, "eng"] call fza_mpd_fnc_setCurrentPage;
	};
	case "menu": {
		[_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
	};
};