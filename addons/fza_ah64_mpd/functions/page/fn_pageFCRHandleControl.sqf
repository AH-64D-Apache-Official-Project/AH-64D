#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_control"];

if ([_heli, _mpdIndex, _control] call fza_mpd_fnc_acqHandleControl) exitWith {};

switch(_control) do {
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t1": {
        _heli setVariable ["fza_ah64_fcrcscope", !(_heli getVariable "fza_ah64_fcrcscope")];
    };
    case "l1": {
        if (FCR_OWNER(_heli) != ([_heli] call fza_fnc_getSeat)) exitWith {};
        [_heli] call fza_fcr_fnc_cycleNTS;
    };
    case "l2": {
        [_heli, -1] call fza_fcr_fnc_slewCenterline;
    };
    case "r2": {
        [_heli, 1] call fza_fcr_fnc_slewCenterline;
    };
    case "l4": {
        // TGT: the NTS stored as a target, with FCR as this crew station's sight
        if (([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_FCR) exitWith {};
        private _ntsPos = [_heli, "FCR"] call fza_fnc_targetingAcqPoint;
        if (_ntsPos isEqualTo []) exitWith {};
        [_heli, _ntsPos] call fza_fnc_targetingStore;
    };
};
