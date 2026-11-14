#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_control", "_state"];

if ([_heli, _mpdIndex, _control] call fza_mpd_fnc_acqHandleControl) exitWith {};
if ([_heli, _mpdIndex, _control, _state] call fza_mpd_fnc_fcrTgtHandleControl) exitWith {};

switch _control do {
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t1": {
        _heli setVariable ["fza_ah64_fcrcscope", !(_heli getVariable "fza_ah64_fcrcscope")];
    };
    // t6 UTIL — FCR utility page not implemented
    case "l1": {
        // NTS: with FCR as this crew station's sight
        if (FCR_OWNER(_heli) != ([_heli] call fza_fnc_getSeat) || {([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_FCR}) exitWith {};
        [_heli] call fza_fcr_fnc_cycleNTS;
    };
    case "l2": {
        [_heli, -1] call fza_fcr_fnc_slewCenterline;
    };
    case "r1": {
        // ZOOM: choose the area with the cursor (fza_mpd_fnc_cursorEnter), or back to the full display
        _state set ["zoom", [1, 0] select (_state getOrDefault ["zoom", 0] > 0)];
    };
    case "r2": {
        [_heli, 1] call fza_fcr_fnc_slewCenterline;
    };
    case "r4": {
        // RFHO — RF handover (fire to LOBL transition)
        // Placeholder — implement RFHO logic when available
    };
};
