#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_mpdIndex", "_control"];

switch(_control) do {
	case "t2": {
		[_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
	};
	case "b1": {
		[_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
	};
};