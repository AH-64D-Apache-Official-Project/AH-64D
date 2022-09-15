/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsAPU

Description:
	Defines key values for the simulation.

Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];

private _apuBtnState   = _heli getVariable "fza_sfmplus_apuBtnState";
private _battBusState  = _heli getVariable "fza_sfmplus_battBusState";
private _apuState      = _heli getVariable "fza_sfmplus_apuState";
private _apuStartDelay = _heli getVariable "fza_sfmplus_apuStartDelay";
private _apuRPM_pct    = _heli getVariable "fza_sfmplus_apuRPM_pct";

if (_apuBtnState == "ON" && _battBusState == "ON") then {
    _apuRPM_pct = [_apuRPM_pct, 1.0, (1.0 / _apuStartDelay) * _deltaTime] call BIS_fnc_lerp;
} else {
    _apuRPM_pct = [_apuRPM_pct, 0.0, _deltaTime] call BIS_fnc_lerp;
};
_heli setVariable ["fza_sfmplus_apuRPM_pct", _apuRPM_pct];

//Set the APU state
if (_apuRPM_pct <= 0.85) then {
    _apuState = "OFF";
};
if (_apuRPM_pct > 0.85) then {
    _apuState = "ON";
};
_heli setVariable ["fza_sfmplus_apuState", _apuState];