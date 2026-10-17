/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingRangeUpdate

Description:
    Range source events for the local crew station: actioning rockets
    selects the last manual range or the default, a new NTS with FCR as the
    sight selects radar, and lasing selects the laser, keeping the last laser
    range for when the laser stops.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_targetingRangeUpdate
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _seat = [_heli] call fza_fnc_getSeat;
if (isNil "_seat") exitWith {};

// Actioning rockets drops the range source for the last manual range, or the default without one
private _was = _heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE];
if (_was != (_heli getVariable ["fza_ah64_rangeLastWas", WAS_WEAPON_NONE])) then {
    _heli setVariable ["fza_ah64_rangeLastWas", _was];
    if (_was == WAS_WEAPON_RKT) then {
        private _manual = _heli getVariable ["fza_ah64_rangeManual_" + _seat, 0];
        if (_manual > 0) then {
            [_heli, _seat, RANGE_SRC_MANUAL, _manual] call fza_fnc_targetingRangeSet;
        } else {
            [_heli, _seat, RANGE_SRC_DEFAULT] call fza_fnc_targetingRangeSet;
        };
    };
};

// A new NTS with FCR as the sight selects radar range
private _nts = (_heli getVariable ["fza_ah64_fcrNts", [objNull]]) param [0, objNull];
if (_nts isNotEqualTo (_heli getVariable ["fza_ah64_rangeLastNts", objNull])) then {
    _heli setVariable ["fza_ah64_rangeLastNts", _nts];
    if (!isNull _nts && {([_heli, "fza_ah64_sight", _seat] call fza_fnc_getSeatVariable) == SIGHT_FCR}) then {
        [_heli, _seat, RANGE_SRC_RADAR] call fza_fnc_targetingRangeSet;
    };
};

if (isNull laserTarget _heli || {(_heli getVariable ["fza_ah64_laserSeat", "cpg"]) != _seat}) exitWith {};

private _range = round ((_heli distance laserTarget _heli) min RANGE_LASER_MAX);
(_heli getVariable ["fza_ah64_rangeSrc_" + _seat, [RANGE_SRC_DEFAULT, 0]]) params ["_source", "_value"];

// The live range is read from the laser while it fires; the kept value is sent at most twice a second
if (_source != RANGE_SRC_LASER || {CBA_missionTime - (_heli getVariable ["fza_ah64_rangeLaserSent", -10]) > 0.5 && {_range != _value}}) then {
    _heli setVariable ["fza_ah64_rangeLaserSent", CBA_missionTime];
    [_heli, _seat, RANGE_SRC_LASER, _range] call fza_fnc_targetingRangeSet;
};
