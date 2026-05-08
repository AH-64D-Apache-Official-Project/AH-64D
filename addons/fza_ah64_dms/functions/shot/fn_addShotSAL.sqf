/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_addShotSAL

Description:
    Add the shot to the DMS shot list

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli, _triggerTime, _shotPos, , _remoteEngagement] call fza_dms_fnc_addShotSAL;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_triggerTime", ["_shotPos", [0,0,0]], "_remoteEngagement"];

private _shotAtArray = _heli getVariable "fza_dms_shotAt";
private _shotAtArray = _shotAtArray select [0,16];
private _shotAtIndex = _shotAtArray findIf {_x isEqualTo -1};
private _ident = "FCR_UNK_LOAL";

if _remoteEngagement then {
    private _shotAtArray = _heli getVariable "fza_dms_shotAt";
    private _shotAtCompairArray = _shotAtArray select {_x isNotEqualTo -1};
    if (_shotAtCompairArray isEqualTo []) exitWith {_shotPos = [0,0,0]};
    private _lastShotATFile = ([_shotAtCompairArray, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy)#0;
    _shotPos = _lastShotATFile # 4;
};

if (_shotPos isNotEqualTo [0,0,0]) then {
    private _closestTarget = [_heli, _shotPos, 200] call fza_dms_fnc_getNearestFcrTargetData;
    if (_closestTarget isNotEqualTo []) then {
        _ident = [_closestTarget] call fza_dms_fnc_shotIdentFromFcrData;
    };
};

if (_shotAtIndex != -1) then {
    _shotAtArray set [_shotAtIndex, [(_shotAtIndex + 1), _ident, "SAL", _triggerTime, _shotPos, "OWN", 1]];
} else { 
    private _shotAtCompairArray = ([_shotAtArray, [], {_x # 0}, "ASCEND"] call BIS_fnc_sortBy)#0;
    private _ShotAtLargestIndex = ([_shotAtArray, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy)#0#0;
    private _shotAtIndexNext = (_shotAtArray find _shotAtCompairArray) mod 16;
    _shotAtArray set [_shotAtIndexNext, [(_ShotAtLargestIndex + 1), _ident, "SAL", _triggerTime, _shotPos, "OWN", 1]];
};

[_heli, "fza_dms_shotAt", _shotAtArray] call fza_fnc_updateNetworkGlobal;
