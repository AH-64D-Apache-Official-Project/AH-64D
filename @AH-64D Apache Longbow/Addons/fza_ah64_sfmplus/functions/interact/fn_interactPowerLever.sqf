/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_interactPowerLever

Description:
	Handles power lever animation and invokes engineReset when a power lever is
	taken to off.	

Parameters:
	_heli   - The helicopter to get information from [Unit].
	_engNum - The desired engine.
	_state  - The state of the power lever (OFF, IDLE, FLY).

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_state"];

if(_heli animationphase "plt_rtrbrake" != 0) exitWith {};

private _engState = _heli getVariable "fza_sfmplus_engState" select _engNum;

if (_state == "OFF") then {
	[_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state] call fza_sfmplus_fnc_setArrayVariable;

	if (_engState == "ON") then {
		[_heli, _engNum] call fza_sfmplus_fnc_engineReset;
	};
};

if (_state == "IDLE") then {
	[_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state] call fza_sfmplus_fnc_setArrayVariable;
};

if (_state == "FLY") then {
	[_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state] call fza_sfmplus_fnc_setArrayVariable;
};
