/* ----------------------------------------------------------------------------
Function: fza_fnc_animSetValue

Description:
	For variables that are linked to an animation, updates the variable value
	and animates the animation to the value.
    
Parameters:
	_heli - The apache helicopter to check. (Object)
	_varName - Name of the variable to assign. (String)
	_value - Value to be assigned to variable (Number or Bool)

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "fza_ah64_battery", true] call fza_fnc_animSetValue
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params [["_heli", nil, objNull], ["_varName", nil, ""], ["_value", nil, [0,false]]];

private _animNames = createHashMapFromArray
	[["fza_ah64_battery", "plt_batt"]
	,["fza_ah64_apu", "plt_apu"]
	,["fza_ah64_rtrbrake", "plt_rtrbrake"]
	,["fza_ah64_anticollision", "plt_anticollision"]
	];

private _animName = _animNames get _varName;

if (isNil "_animName") exitWith {["Variable name not valid: '%1'", _varName] call BIS_fnc_error};

_heli setVariable [_varName, _value, true];

if (typeName _value == "BOOL") then {
	_heli animate [_animName, parseNumber _value];
};

if (typeName _value == "SCALAR") then {
	_heli animate [_animName, value];
};