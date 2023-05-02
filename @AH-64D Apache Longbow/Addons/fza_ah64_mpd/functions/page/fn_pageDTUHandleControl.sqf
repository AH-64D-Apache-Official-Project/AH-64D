params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

switch(_control) do {
	case "t1": {
		[_heli, _mpdIndex, "dms"] call fza_mpd_fnc_setCurrentPage;
	};
    case "b1": {
		[_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
	};
};

switch (_state get "subPage") do {
    case DTU_ROOT: { // Root
        switch (_control) do {
            case "l1": {
                _state set ["subPage", DTU_LOAD_STATUS];
                _state set ["loadState", MFD_DTU_LOADING];
                [_heli, _state] spawn {
                    params ["_heli", "_state"];
                    sleep 4;
                    _state set ["loadState", MFD_DTU_LOAD_COMPLETE];
                    [missionNamespace, _heli] call fza_dms_fnc_copy;
                };
                _state set ["subPage", DTU_LOAD_STATUS]; //Load status subpage
            };
        };
    };
	case DTU_LOAD_STATUS: {
		switch (_control) do {
            case "l1": {
                _state set ["subPage", DTU_ROOT];
            };
        };
	};
};