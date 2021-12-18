#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_mpdIndex", "_control"];

switch(_control) do {
	case "b1": {
		[_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
	};
};