#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_mpdIndex", "_control"];

switch(_control) do {
    case "t1": {
		[_heli, _mpdIndex, "dtu"] call fza_mpd_fnc_setCurrentPage;
	};
    case "menu": {
		[_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
	};
    case "b5": {
		[_heli, _mpdIndex, "wca"] call fza_mpd_fnc_setCurrentPage;
	};
};