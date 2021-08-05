/* ----------------------------------------------------------------------------
Function: fza_fnc_bearingClock

Description:
    Converts a relative bearing to a clock position

Parameters:
    _degrees - relative bearing

Returns:
    Clock position for relative bearing

Examples:
    --- Code
    _clock = [0] call fza_fnc_bearingClock;
    //_result => 12
    
    _clock = [90] call fza_fnc_bearingClock;
    //_result => 3
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params["_degrees"];

private _clock = round (_degrees / (360 / 12) % 12);

if (_clock == 0) exitWith {12};

_clock;