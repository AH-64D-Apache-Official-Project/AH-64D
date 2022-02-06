/* ----------------------------------------------------------------------------
Function: fza_fnc_animReset

Description:
	Resets an animation to the value on the given variable. Called by
	onPhaseChanged which is called by bis_fnc_initVehicle.

	It is used to override BIS_fnc_initVehicles overrides of core animations.
    
Parameters:
	_heli - The apache helicopter to check. (Object)
	_varName - Name of the variable linked to animation. (String)
	_animName - Animation to be overridden

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "fza_ah64_battery", "plt_batt"] call fza_fnc_animReset
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params [["_heli", nil, [objNull]], "_varName", "_animName"];

private _val = _heli getVariable _varName;

if (typeName _val == "BOOL") then {
	_heli animate [_animName, parseNumber _val];
};

if (typeName _val == "SCALAR") then {
	_heli animate [_animName, _val];
};