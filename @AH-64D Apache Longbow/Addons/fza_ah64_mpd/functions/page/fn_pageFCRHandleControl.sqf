#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex", "_control"];

Private _fcrMode = _heli Getvariable "fza_ah64_fcrMode";

switch(_control) do {
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t1": {
        _heli setVariable ["fza_ah64_fcrcscope", !(_heli getVariable "fza_ah64_fcrcscope")];
    };
    case "l1": {
        [_heli] call fza_fcr_fnc_cycleNTS;
    };
    case "l2": {
        private _arrowL = _state get "arrowL";
        if (_arrowL == 1) then {
            _state set ["arrowL", 2];
            _state spawn {
                sleep 0.5;
                _this#0 set ["arrowL", 1];
            };
        };
    };
    case "r2": {
        private _arrowR = _state get "arrowR";
        if (_arrowR == 1) then {
            _state set ["arrowR", 2];
            _state spawn {
                sleep 0.5;
                _this#0 set ["arrowR", 1];
            };
        };
    };
};
 