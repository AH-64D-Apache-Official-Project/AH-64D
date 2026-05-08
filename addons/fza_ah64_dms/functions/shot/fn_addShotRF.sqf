/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_addShotRF

Description:
    Add the shot to the DMS shot list

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli, _ident, _triggerTime, _shotPos, _fcrData] call fza_dms_fnc_addShotRF;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", ["_ident", ""], "_triggerTime", ["_shotPos", [0,0,0]], ["_fcrData", []]];

if (_ident isEqualTo "") then {
    _ident = "FCR_UNK_LOAL";

    if (_fcrData isNotEqualTo []) then {
        _ident = [_fcrData] call fza_dms_fnc_shotIdentFromFcrData;
    } else {
        if (_shotPos isNotEqualTo [0, 0, 0]) then {
            private _closestTarget = [_heli, _shotPos, 200] call fza_dms_fnc_getNearestFcrTargetData;
            if (_closestTarget isNotEqualTo []) then {
                _ident = [_closestTarget] call fza_dms_fnc_shotIdentFromFcrData;
            };
        };
    };
};

private _shotAtArray = _heli getVariable "fza_dms_shotAt";
private _shotAtArray = _shotAtArray select [0,16];
private _shotAtIndex = _shotAtArray findIf {_x isEqualTo -1};

if (_shotAtIndex != -1) then {
    _shotAtArray set [_shotAtIndex, [(_shotAtIndex + 1), _ident, "RF", _triggerTime, _shotPos, "OWN", 1]];
} else { 
    private _shotAtCompairArray = ([_shotAtArray, [], {_x # 0}, "ASCEND"] call BIS_fnc_sortBy)#0;
    private _ShotAtLargestIndex = ([_shotAtArray, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy)#0#0;
    private _shotAtIndexNext = (_shotAtArray find _shotAtCompairArray) mod 16;
    _shotAtArray set [_shotAtIndexNext, [(_ShotAtLargestIndex + 1), _ident, "RF", _triggerTime, _shotPos, "OWN", 1]];
};

[_heli, "fza_dms_shotAt", _shotAtArray] call fza_fnc_updateNetworkGlobal;
