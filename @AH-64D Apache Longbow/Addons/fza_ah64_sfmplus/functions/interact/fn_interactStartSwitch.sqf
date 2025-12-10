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
params ["_heli", "_engNum"];

if (_heli getVariable "fza_ah64_rtrbrake") exitWith {};

private _engState    = _heli getVariable "fza_sfmplus_engState" select _engNum;

{
	_x params ["_Snd_Ctrl_BaseID","_toStatus"];

	private _Snd_Ctrl = format ["CustomSoundController%1", _Snd_Ctrl_BaseID + (_engNum * 2)];
	
	private _toValue = parseNumber _toStatus;
	private _cur_Snd_Ctrl = getCustomSoundController [_heli, _Snd_Ctrl];
		
	if (_cur_Snd_Ctrl == _toValue) then {continue};
	setCustomSoundController [_heli, _Snd_Ctrl, _toValue];
} forEach [
	[10, _engState == "OFF"],// Startup (ID : 10, 12)
	[11, _engState != "OFF"] // Shutdown (ID : 11, 13)
];

switch (_engState) do {
	case "STARTING": {
		_engState = "OFF";
		[_heli, "fza_sfmplus_engState", _engNum, _engState, true] call fza_fnc_setArrayVariable;

		systemChat str ["Engine Set POS (OFF)",time];
		
		false;
	};
	case "OFF": {
		_engState = "STARTING";
		[_heli, "fza_sfmplus_engState", _engNum, _engState, true] call fza_fnc_setArrayVariable;

		systemChat str ["Engine Set POS (START)",time];
		
		true;
	};
	default {
		true;
	}
};
