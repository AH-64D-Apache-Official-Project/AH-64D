/* ----------------------------------------------------------------------------
Function: fza_fnc_engineGetTarget

Description:
	Handles rotorlib, governs the engine RPM. Should be called regularly, at least once a second

Parameters:
	_heli - The apache helicopter [Unit].

Returns:
	Nothing

Examples:
    (begin example)
	[_heli] call fza_fnc_engineGovernor;
    (end)

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

if(!local _heli) exitWith {};

([_heli, 0] call fza_fnc_engineGetTarget) params ["_e1rpm", "_e1time"];
([_heli, 1] call fza_fnc_engineGetTarget) params ["_e2rpm", "_e2time"];

if(_e1rpm == _e2rpm) then {
	_heli setWantedRPMRTD [_e1rpm, _e1time min _e2time, -1];
} else {
	if(_e1rpm > _e2rpm) then {
		_heli setWantedRPMRTD [_e1rpm, _e1time, -1];
	} else {
		_heli setWantedRPMRTD [_e2rpm, _e2time, -1];
	}
}