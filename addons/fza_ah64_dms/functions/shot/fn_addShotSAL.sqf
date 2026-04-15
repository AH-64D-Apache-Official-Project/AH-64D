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

if (_shotPos isnotequalto [0,0,0]) then {
    private _fcrTargets = _heli getvariable "fza_ah64_fcrTargets";
    if (_fcrTargets isequalto []) exitwith {};
    if (isNull laserTarget _heli) exitwith {};
    _closestTarget = ([_fcrTargets, [], {_x#0 distance laserTarget _heli}, "ASCEND"] call BIS_fnc_sortBy)#0;
    _closestTarget params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];
    if ((_pos distance laserTarget _heli) > 200) exitwith {};
    private _unitType   = "UNK";
    private _unitStatus = "LOAL"; 

    switch (_type) do {
        case FCR_TYPE_UNKNOWN:    {_unitType = "UNK";};
        case FCR_TYPE_WHEELED:    {_unitType = "WHEEL";};
        case FCR_TYPE_HELICOPTER: {_unitType = "HELI";};
        case FCR_TYPE_FLYER:      {_unitType = "FLYER";};
        case FCR_TYPE_TRACKED:    {_unitType = "TRACK";};
        case FCR_TYPE_ADU:        {_unitType = "ADU";};
    };

    if ((_moving && (_range >= FCR_LIMIT_MIN_RANGE && _range <= FCR_LIMIT_MOVING_RANGE)) || _unitType == "FLYER") then {_unitStatus = "MOVE";}
     else {
        if (_range >= FCR_LIMIT_MIN_RANGE && _range <= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) then                          {_unitStatus = "LOBL";};
        if (_range > FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE && _range <= FCR_LIMIT_STATIONARY_RANGE) then                    {_unitStatus = "LOAL";};
    };
    _ident = ["FCR",_unitType,_unitStatus] joinString "_";
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
