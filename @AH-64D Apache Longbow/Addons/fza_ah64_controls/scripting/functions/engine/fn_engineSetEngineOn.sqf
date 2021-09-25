/* ----------------------------------------------------------------------------
Function: fza_fnc_engineSetEngineOn

Description:
    Engine event handler, stops the engines from being turned on using the action menu if they shouldn't be on according to the simulated startup sequence.

Parameters:
    _heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli, true] call fza_fnc_engineSetEngineOn
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params ["_heli"];

if (!fza_ah64_heliSimEnabled) then {
	private _eng1state = _heli getVariable "fza_sfmplus_engState" select 0;
	private _eng2state = _heli getVariable "fza_sfmplus_engState" select 1;
	
	if (_eng1State == "STARTING" || _eng2State == "STARTING") then {
		_heli setVariable ["fza_ah64_estarted", true, true];
		_heli engineOn true;
	};
} else {
	private _eng1state = _heli getVariable "bmk_engState" select 0;
	private _eng2state = _heli getVariable "bmk_engState" select 1;
	
	if (_eng1State == "STARTING" || _eng2State == "STARTING") then {
		_heli setVariable ["fza_ah64_estarted", true, true];
		_heli engineOn true;
	};
};