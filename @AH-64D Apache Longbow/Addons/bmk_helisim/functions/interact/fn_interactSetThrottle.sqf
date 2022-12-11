/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_interactStartSwitch

Description:
	Sets start switch state for the engine sim.

Parameters:
	_heli   - The helicopter to get information from [Unit].
	_engNum - The desired engine.

Returns:
	Whether to register a click (boolean).

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_throttlePos", "_throttleSetPoint"];

private _engState = _heli getVariable "bmk_helisim_engState" select _engNum;
private _engPwrLeverAnimName = format["fza_ah64_powerLever%1", _engNum + 1];

switch (_throttlePos) do {
	case "OFF" : {
		[_heli, _engPwrLeverAnimName, 0] call fza_fnc_animSetValue;
		[_heli, "bmk_helisim_engThrottlePos", _engNum, _throttlePos, true] call fza_sfmplus_fnc_setArrayVariable;
		[_heli, "bmk_helisim_engThrottleSetPoint", _engNum, _throttleSetPoint] call fza_sfmplus_fnc_setArrayVariable;
	};
	case "IDLE" : {
		[_heli, _engPwrLeverAnimName, 0.25] call fza_fnc_animSetValue;
		[_heli, "bmk_helisim_engThrottlePos", _engNum, _throttlePos, true] call fza_sfmplus_fnc_setArrayVariable;
		[_heli, "bmk_helisim_engThrottleSetPoint", _engNum, _throttleSetPoint] call fza_sfmplus_fnc_setArrayVariable;
	};
	case "FLY" : {
		[_heli, _engPwrLeverAnimName, 1.0, 0.25] call fza_fnc_animSetValue;
		[_heli, "bmk_helisim_engThrottlePos", _engNum, _throttlePos, true] call fza_sfmplus_fnc_setArrayVariable;
		[_heli, "bmk_helisim_engThrottleSetPoint", _engNum, _throttleSetPoint] call fza_sfmplus_fnc_setArrayVariable;
	};
};