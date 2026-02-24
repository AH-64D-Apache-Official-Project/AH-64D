/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_dmsShot

Description:
    Add the shot to the DMS shot list

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli, _targetType, _missileType, _triggerTime, _shotPos] call fza_hellfire_fnc_dmsShot;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_ident", "_targetType", "_missileType", "_triggerTime", ["_shotPos", [0,0,0]]];

private _shotAtArray = _heli getVariable "fza_dms_shotAt";
private _shotAtArray = _shotAtArray select [0,16];
private _shotAtIndex = _shotAtArray findIf {_x isEqualTo -1};

if (_shotAtIndex != -1) then {
    _shotAtArray set [_shotAtIndex, [(_shotAtIndex + 1), _ident, _targetType, _missileType, _triggerTime, _shotPos, "OWN", 1, 0]];
    _heli setVariable ["fza_dms_shotAt", _shotAtArray];
} else { 
    private _shotAtCompairArray = ([_shotAtArray, [], {_x # 0}, "ASCEND"] call BIS_fnc_sortBy)#0;
    private _ShotAtLargestIndex = ([_shotAtArray, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy)#0#0;
    private _shotAtIndexNext = (_shotAtArray find _shotAtCompairArray) mod 16;
    systemchat str _ShotAtLargestIndex;
    systemchat str _shotAtIndexNext;
    _shotAtArray set [_shotAtIndexNext, [(_ShotAtLargestIndex + 1), _ident, _targetType, _missileType, _triggerTime, _shotPos, "OWN", 1]];
    _heli setVariable ["fza_dms_shotAt", _shotAtArray];
};