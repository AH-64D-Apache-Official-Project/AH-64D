#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_mpdIndex", "_control"];

switch(_control) do {
	case "t1": {
		[_heli, _mpdIndex, "dms"] call fza_mpd_fnc_setCurrentPage;
	};
    case "b1": {
		[_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
	};
	case "l1": {
		[missionNamespace, _heli] call fza_dms_fnc_copy;
	};
}; 