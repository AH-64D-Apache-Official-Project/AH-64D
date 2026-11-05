/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatTargetPos

Description:
    Where the image auto tracker has its target, on any machine: the target
    itself while tracking, and while reacquiring where it was last seen moved
    on at the speed it had then.

Parameters:
    _heli - The helicopter

Returns:
    ASL position, [] without a track

Examples:
    --- Code
    private _pos = [_heli] call fza_ihadss_fnc_iatTargetPos;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

(_heli getVariable ["fza_ah64_iat", IAT_IDLE]) params ["_state", "", "_obj", "_trackPoint", "_coastPos", "_vel", "_seenAt"];

switch (_state) do {
    case IAT_TRACK: {
        if (_trackPoint isNotEqualTo []) then {_trackPoint} else {
            if (isNull _obj) then {[]} else {(getPosASLVisual _obj) vectorAdd ((aimPos _obj) vectorDiff (getPosASL _obj))};
        };
    };
    case IAT_COAST: {
        if (_coastPos isEqualTo []) then {[]} else {_coastPos vectorAdd (_vel vectorMultiply ((CBA_missionTime - _seenAt) max 0))};
    };
    default {[]};
};
