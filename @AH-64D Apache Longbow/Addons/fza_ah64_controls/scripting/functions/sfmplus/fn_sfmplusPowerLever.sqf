/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusPowerLever

Description:

Parameters:

Returns:

Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_state"];

if(_heli animationphase "plt_rtrbrake" != 0) exitWith {};

//private _otherEngineNum = if (_engNum == 0) then { 1 } else { 0 };

private _engPwrLeverAnimName = format["plt_eng%1_throttle", _engNum + 1]; 

//If the start switch is in the off position, move it to the start position
if (_state == "OFF") then {
	_heli animateSource[_engPwrLeverAnimName, 0];
	[_heli, "fza_ah64_engPowerLeverState", _engNum, _state] call fza_fnc_sfmplusSetArrayVariable;
};

if (_state == "IDLE") then {
	_heli animateSource[_engPwrLeverAnimName, 0.25];
	[_heli, "fza_ah64_engPowerLeverState", _engNum, _state] call fza_fnc_sfmplusSetArrayVariable;
};

if (_state == "FLY") then {
	//0.063 sets the power levers to fly in 16 seconds
	_heli animateSource[_engPwrLeverAnimName, 1, 0.25];
	[_heli, "fza_ah64_engPowerLeverState", _engNum, _state] call fza_fnc_sfmplusSetArrayVariable;
};
