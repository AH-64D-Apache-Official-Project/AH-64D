/* ----------------------------------------------------------------------------
Function: fza_fnc_engineGetTarget

Description:
	Sets up the engine control system for the helicopter. Should only be called on init

Parameters:
	_heli - The apache helicopter [Unit].

Returns:
	Nothing

Examples:
    --- Code
	[_heli] call fza_fnc_engineInit;
    ---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params["_heli"];

if (!local _heli) exitWith {};

_heli setVariable["fza_ah64_engineStates", [
    ["OFF", 0],
    ["OFF", 0]
], true];