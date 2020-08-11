/* ----------------------------------------------------------------------------
Function: fza_fnc_displayTime

Description:
	Converts a numeric time to a pretty string.

Parameters:
	_time - The time difference in seconds.

Returns:
	Converted string

Examples:
    (begin example)
	_result = [1] call fza_fnc_displayTIme;
	//_result => "1 second"
    (end)

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"

params [["_time", 0, [0]]];

_time = round _time;

ASSERT_OP(_time, >=, 0, "Time cannot be negative");
ASSERT_OP(_time, <, 60*60, "Time must be less than an hour");

if(_time < 60) then {
	if (_time == 1) then {
		"1 second";
	} else {
		format ["%1 seconds", _time];
	};
} else {
	_time = floor (_time / 60);
	if (_time == 1) then {
		"1 minute";
	} else {
		format ["%1 minutes", _time];
	};
};