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

//create Route without A/B/B/C side/side duplicates
private _rteCycleList = [];
private _rteCycleIndex = _rteIndex;
{
    private _previousIndex = (_foreachindex - 1);
    private _previousPoint = (_routeInfo#_previousIndex);
    if (_previousPoint isEqualTo _x && _previousIndex > -1) then { 
        if (_previousIndex < _rteIndex) then {
            _rteCycleIndex = _rteCycleIndex - 1;
        };
        continue;
    };
    _rteCycleList pushBack _X;
} foreach _routeInfo;

private _previousPnt = if (count _rteCycleList > 1 && _rteCycleIndex > 0) then {_rteCycleList#(_rteCycleIndex - 1);} else {-1;};
private _currentPnt  = if (count _rteCycleList > 0 && _rteCycleIndex > -1) then {_rteCycleList#_rteCycleIndex;} else {-1;};
private _nextPnt     = if (count _rteCycleList > (_rteCycleIndex + 1)) then {_rteCycleList#(_rteCycleIndex + 1);} else {-1;};
_previousPnt;
private _previousPntPos = [_heli, _previousPnt, 1] call fza_dms_fnc_pointGetValue;
private _currentPntPos  = [_heli, _currentPnt, 1] call fza_dms_fnc_pointGetValue;
private _nextPntPos     = [_heli, _nextPnt, 1] call fza_dms_fnc_pointGetValue;

if (_previousPnt isNotEqualTo -1 && _currentPnt isNotEqualTo -1 && _previousPntPos isNotEqualTo _currentPntPos) then {
    _Course1 = _previousPntPos getDir _currentPntPos;
};
if (_currentPnt isNotEqualTo -1 && _nextPnt isNotEqualTo -1 && _currentPntPos isNotEqualTo _nextPntPos) then {
    _Course2 = _currentPntPos getDir _nextPntPos;
};

private _angle = ((_Course1 + _Course2 + 180) mod 360) / 2;
private _angle = if (_Course1 == -1 || _Course2 == -1) then {90;} else {_angle;};

if (_Course2 isEqualTo -1) then {//end point
    _angle = (_Course1 + _angle + 360) mod 360;
};
if (_Course1 isEqualTo -1) then {//start point
    _angle = (_Course2 + _angle + 360) mod 360;
};

//Calculate Line Direction and Normalize
_lineDirection = [sin _angle, cos _angle, 0];
_lineDirection = vectorNormalized _lineDirection;

//Calculate Closest Point
_diffVector = (position _heli) vectorDiff _currentPntPos;
_dotProduct = _diffVector vectorDotProduct _lineDirection;
_closestPoint = _currentPntPos vectorAdd [(_dotProduct * _lineDirection#0), (_dotProduct * _lineDirection#1), 0];

private _speed = round(vectorMagnitude (velocity _heli));
private _approachETA = if (_speed > 0) then {round((_heli distance2d _currentPntPos) / _speed);} else {99;};
private _leftMpd = [_heli, 0] call fza_mpd_fnc_currentPage;
private _rightMpd = [_heli, 1] call fza_mpd_fnc_currentPage;
private _wptAprch = _heli getvariable "fza_ah64_wptAprch";
private _count = count _rteCycleList;
//wpt approach 
if (_leftMpd != "TSD" && _rightMpd != "TSD" && _approachETA <= 60 && _wptAprch#0 isNotEqualTo _currentPnt) then {
    [_heli, "fza_ah64_wptAprch", [_currentPnt, true]] call fza_fnc_updateNetworkGlobal;
};
//waypoint passed
{
    if (_count == 0) exitwith {};
    if (_nextPnt isEqualTo -1) exitwith {};
    if (_closestPoint distance2D _heli > 20) exitwith {};
    if (_x isNotEqualTo _currentPnt && _rteIndex <= _foreachindex) exitWith {
        if (_leftMpd != "TSD" && _rightMpd != "TSD" && (_closestPoint distance2D _heli > 20)) then {
            [_heli, "fza_ah64_wptpassed", true] call fza_fnc_updateNetworkGlobal;
        };
        if (_count > 1 && (_count > (_rteCycleIndex + 1))) then {
            [_heli, _x] call fza_dms_fnc_routeSetDir;
            _heli setVariable ["fza_ah64_routeCurPnt", _foreachindex, true];
        };
    };
} foreach _routeInfo;

systemchat str ["Angle :" + str _angle,"Closest Intersect :" + str _closestPoint,"Distance:" + str (_heli distance2d _closestPoint), "Point Pos ETA :" + str _approachETA];