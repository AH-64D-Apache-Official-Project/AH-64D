/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_routeDelPoint

Description:
    Deletes a point from the currently selected route using an index
    preserved the current Selected route point
    handles the reset of wpt aproach if equal to deleted point

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
private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
private _routeInfo    = _routeData # _routeCurrent;

_routeInfo deleteAt _index;
_routeData set [_routeCurrent, _routeInfo];
if (_rteIndex == _index) then {
    _heli setVariable ["fza_ah64_routeCurPoint", -1, true];
};
if (_index < _rteIndex && _rteIndex != -1) then {
    _heli setVariable ["fza_ah64_routeCurPoint", (_rteIndex - 1), true];
};
private _wptAprch = _heli getvariable "fza_ah64_wptAprch";
if (_routePoint isEqualTo _wptAprch#0) then {
    [_heli, "fza_ah64_wptAprch", [-1, false]] call fza_fnc_updateNetworkGlobal;
};
_heli setVariable ["fza_ah64_routeData", _routeData, true];