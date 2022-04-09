/* ----------------------------------------------------------------------------
Function: fza_fnc_animSetValue

Description:
	For variables that are linked to an animation, updates the variable value
	and animates the animation to the value.
    
Parameters:
	_heli - The apache helicopter to check. (Object)
	_varName - Name of the variable to assign. (String)
	_value - Value to be assigned to variable (Number or Bool)
	_timing - (Optional) timing value to be passed into animate.

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "fza_ah64_battery", true] call fza_fnc_animSetValue
	[_heli, "fza_ah64_battery", true, 10] call fza_fnc_animSetValue
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params [["_heli", nil, [objNull]], ["_varName", nil, [""]], ["_value", nil, [0,false]], "_timing"];

private _animNames = createHashMapFromArray
	[["fza_ah64_battery", "plt_batt"]
	,["fza_ah64_apu", "plt_apu"]
	,["fza_ah64_rtrbrake", "plt_rtrbrake"]
	,["fza_ah64_anticollision", "plt_anticollision"]
	,["fza_ah64_tadsStow", "tads_stow"]
	,["fza_ah64_powerLever1", "plt_eng1_throttle"]
	,["fza_ah64_powerLever2", "plt_eng2_throttle"]
	];
systemChat str _this;
private _animName = _animNames get _varName;

if (isNil "_animName") exitWith {["Variable name not valid: '%1'", _varName] call BIS_fnc_error};

_heli setVariable [_varName, _value, true];

private _animValue = if (typeName _value != "SCALAR") then {parseNumber _value} else {_value};

if (isNil "_timing") then {
	_heli animate [_animName, _animValue];
} else {
	_heli animate [_animName, _animValue, _timing];
};