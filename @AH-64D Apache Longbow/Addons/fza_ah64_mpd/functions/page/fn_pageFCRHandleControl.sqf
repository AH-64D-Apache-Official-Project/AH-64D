#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

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
        _state set ["arrowL", time];
    };
    case "r2": {
        _state set ["arrowR", time];
    };
};
 