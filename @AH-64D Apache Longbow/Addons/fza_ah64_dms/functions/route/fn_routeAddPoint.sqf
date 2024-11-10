/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_routeAddPoint

Description:
    Adds a point into the currently selected route given the route info and point info
    preserved the current Selected route point

Parameters:
    _heli - The apache

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _routePoint, _index] call fza_dms_fnc_routeData
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_routePoint","_index"];

private _rteIndex     = _heli getVariable "fza_ah64_routeCurPoint";
private _dmsNext      = (_heli getVariable "fza_dms_routeNext")#0;
private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
private _routeInfo    = _routeData # _routeCurrent;

_routeInfo insert [_index, [_routePoint]];
_routeData set [_routeCurrent, _routeInfo];
if (_dmsNext isEqualTo []) then {
    [_heli, _routePoint] call fza_dms_fnc_routeSetDir;
    _heli setVariable ["fza_ah64_routeCurPoint", _index, true];
};
if (_index <= _rteIndex && _rteIndex != -1) then {
    _heli setVariable ["fza_ah64_routeCurPoint", (_rteIndex + 1), true];
};
_heli setVariable ["fza_ah64_routeData", _routeData, true];