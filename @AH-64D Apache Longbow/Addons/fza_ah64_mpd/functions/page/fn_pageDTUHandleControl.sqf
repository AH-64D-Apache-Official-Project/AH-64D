#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_mpdIndex", "_control", "_state"];

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

switch (_state get "subPageVarPage" select 0) do {
    case 0: { // Root
        switch (_control) do {
            case "l1": {
                _state set ["subPageVarPage", DTU_LOAD_STATUS]; //Load status subpage
            };
        };
    };
};