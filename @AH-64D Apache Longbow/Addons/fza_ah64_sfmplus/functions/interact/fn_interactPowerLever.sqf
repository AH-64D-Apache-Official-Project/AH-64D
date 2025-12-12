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

if (_heli getVariable "fza_ah64_rtrbrake") exitWith {};

private _engState = _heli getVariable "fza_sfmplus_engState" select _engNum;
private _engPwrLeverAnimName = format["fza_ah64_powerLever%1", _engNum + 1]; 

switch (_state) do {
    case "OFF": {
        [_heli, _engPwrLeverAnimName, 0] call fza_fnc_animSetValue;
        [_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state, true] call fza_fnc_setArrayVariable;

        if (_engState == "ON") then {
            [_heli, _engNum] call fza_sfmplus_fnc_engineReset;
        };

        //HeliSim
        //[_heli, _engNum, 0.0] call bmk_fnc_engineSetThrottle;
    };
    case "IDLE": {
        [_heli, _engPwrLeverAnimName, 0.25] call fza_fnc_animSetValue;
        [_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state, true] call fza_fnc_setArrayVariable;

        //HeliSim
        //[_heli, _engNum, 0.25] call bmk_fnc_engineSetThrottle;
    };
    case "FLY": {
        //0.063 sets the power levers to fly in 16 seconds
        [_heli, _engPwrLeverAnimName, 1, 0.25] call fza_fnc_animSetValue;
        [_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state, true] call fza_fnc_setArrayVariable;

        //HeliSim
        //[_heli, _engNum, 1.0] call bmk_fnc_engineSetThrottle;
    };
};

//- Catch lever when the engine isn't started yet
if (_engState == "OFF" && _state != "OFF") exitWith {};

{
	_x params ["_Snd_Ctrl_BaseID","_toStatus"];

	private _Snd_Ctrl = format ["CustomSoundController%1", _Snd_Ctrl_BaseID + (_engNum * 2)];
	
	private _toValue = parseNumber _toStatus;
	private _cur_Snd_Ctrl = getCustomSoundController [_heli, _Snd_Ctrl];
		
	if (_cur_Snd_Ctrl == _toValue) then {continue};
	setCustomSoundController [_heli, _Snd_Ctrl, _toValue];
} forEach [
	[10, _state != "OFF"],// Startup (ID : 10, 12)
	[11, _state == "OFF"] // Shutdown (ID : 11, 13)
];

//- Update power sound
[_heli, "powerLever"] call fza_fnc_fxLoops;