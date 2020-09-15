/* ----------------------------------------------------------------------------
Function: fza_fnc_targetIsADA

Description:
    Returns whether the object should be counted as air defence artillery.

Parameters:
    _unit - The unit to check.

Returns:
	Bool - whether the aircraft is Air Defence Artillery or not.

Examples:
    --- Code
	_ret = [_unit] call fza_fnc_targetIsADA
	//_ret => true
    ---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_unit"];

{
	if(_unit isKindOf _x) exitWith {true};
	false;
} forEach fza_ah64_ada_units