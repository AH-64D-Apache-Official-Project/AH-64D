/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingRangeSet

Description:
    Selects a crew station's range source. Each crew station keeps its own.

Parameters:
    _heli   - The helicopter
    _seat   - The crew station, "plt"/"cpg" or a crew unit
    _source - RANGE_SRC_*
    _value  - Laser: last range (m). Manual: range (m). Navigation: point
              position (ASL). Unused for the others.

Returns:
    Nothing

Examples:
    --- Code
    [_heli, player, RANGE_SRC_RADAR] call fza_fnc_targetingRangeSet
    [_heli, "cpg", RANGE_SRC_NAV, _pointPosASL] call fza_fnc_targetingRangeSet
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_seat", "_source", ["_value", 0]];

_seat = [_heli, _seat] call fza_fnc_getSeat;
if (isNil "_seat") exitWith {};

_heli setVariable ["fza_ah64_rangeSrc_" + _seat, [_source, _value], true];
if (_source == RANGE_SRC_MANUAL) then {
    _heli setVariable ["fza_ah64_rangeManual_" + _seat, _value, true];
};
