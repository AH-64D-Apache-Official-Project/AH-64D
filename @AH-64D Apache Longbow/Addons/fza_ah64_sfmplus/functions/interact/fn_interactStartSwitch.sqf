/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusStartSwitch

Description:

Parameters:

Returns:


Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_state"];

if(_heli animationphase "plt_rtrbrake" != 0) exitWith {};

private _engStartSwitch = format["plt_eng%1_start", _engNum + 1];

//If the start switch is in the off position, move it to the start position
if (_state == "START") then {
	_heli animateSource[_engStartSwitch, 1];
	[_heli, "fza_ah64_engStartSwitchState", _engNum, _state] call fza_sfmplus_fnc_setArrayVariable;

	//HeliSim
	//[_heli, _engNum, true] call bmk_fnc_engineStartSwitch;
};

if (_state == "OFF") then {
	_heli animateSource[_engStartSwitch, 0];
	[_heli, "fza_ah64_engStartSwitchState", _engNum, _state] call fza_sfmplus_fnc_setArrayVariable;

	//HeliSim
	//[_heli, _engNum, false] call BMK_fnc_engineStartSwitch;
}

