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

private _config          = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";
private _configVehicles  = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel     = getText (_configVehicles >> "fza_flightModel");

if (_heli getVariable "fza_ah64_rtrbrake") exitWith {};

if (_flightModel == "SFMPlus") then {
    private _engState    = _heli getVariable "fza_sfmplus_engState" select _engNum;

    switch (_engState) do {
        case "STARTING": {
            _engState = "OFF";
            [_heli, "fza_sfmplus_engState", _engNum, _engState, true] call fza_fnc_setArrayVariable;       
            false;
        };
        case "OFF": {
            _engState = "STARTING";
            [_heli, "fza_sfmplus_engState", _engNum, _engState, true] call fza_fnc_setArrayVariable;
            true;
        };
        default {
            true;
        }
    };
} else {
    private _isStarting = _heli getVariable "fza_sfmplus_simpleEng_isStarting" select _engNum;

    if (_isStarting == false) then {
        _isStarting = true;
        [_heli, "fza_sfmplus_simpleEng_isStarting", _engNum, _isStarting, true] call fza_fnc_setArrayVariable;
    } else {
        _isStarting = false;
        [_heli, "fza_sfmplus_simpleEng_isStarting", _engNum, _isStarting, true] call fza_fnc_setArrayVariable;
    };
};

