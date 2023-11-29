/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_routeCycle

Description:
    Cycle to the next route under the correct conditioning

Parameters:
    _heli - The apache

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_routeCycle
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];

private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
private _routeInfo    = _routeData # _routeCurrent;
private _rteIndex     = _heli getVariable "fza_ah64_routeCurPnt";
private _Course1      = -1;
private _Course2      = -1;

if (_rteIndex == -1) exitwith {};

private _previousPnt = if (count _routeInfo > 1 && _rteIndex > 0) then {_routeInfo#(_rteIndex - 1);} else {-1;};
private _currentPnt  = if (count _routeInfo > 0 && _rteIndex > -1) then {_routeInfo#_rteIndex;} else {-1;};
private _nextPnt     = if (count _routeInfo > (_rteIndex + 1)) then {_routeInfo#(_rteIndex + 1);} else {-1;};

private _previousPntPos = [_heli, _previousPnt, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
private _currentPntPos  = [_heli, _currentPnt, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
private _nextPntPos     = [_heli, _nextPnt, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;

if (_previousPnt isNotEqualTo -1 && _currentPnt isNotEqualTo -1 && _previousPntPos != _currentPntPos) then {
    _Course1 = _previousPntPos getDir _currentPntPos;
};
if (_currentPnt isNotEqualTo -1 && _nextPnt isNotEqualTo -1 && _currentPntPos != _nextPntPos) then {
    _Course2 = _currentPntPos getDir _nextPntPos;
};

private _angle1 = abs((_Course1 - _Course2) mod 360)/2;
private _angle1 = if (_Course1 == -1 || _Course2 == -1) then {90;} else {_angle1;};
private _angle2 = (_Course1 + _Course2 + _angle1 + 360) mod 360;
private _angle3 = (_angle2 + 180 + 360) mod 360;
if (_Course1 isEqualTo -1) then {
    _angle2 = (_Course2 + _angle1 + 360) mod 360;
    _angle3 = (_Course2 - _angle1 + 360) mod 360;
};
if (_Course2 isEqualTo -1) then {
    _angle2 = (_Course1 + _angle1 + 360) mod 360;
    _angle3 = (_Course1 - _angle1 + 360) mod 360;
};
systemchat str [_angle1, _angle2, _angle3];