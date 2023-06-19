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

private _config          = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";
private _configVehicles  = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel     = getText (_configVehicles >> "fza_flightModel");

if (_heli getVariable "fza_ah64_rtrbrake") exitWith {};

private _engState            = _heli getVariable "fza_sfmplus_engState" select _engNum;
private _engPwrLeverAnimName = format["fza_ah64_powerLever%1", _engNum + 1];

if (_state == "OFF") then {
    [_heli, _engPwrLeverAnimName, 0] call fza_fnc_animSetValue;
    [_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state, true] call fza_fnc_setArrayVariable;

    if (_flightModel == "SFMPlus") then {
        if (_engState == "ON") then {
            [_heli, _engNum] call fza_sfmplus_fnc_engineReset;
        };
    } else {
        [_heli, "fza_sfmplus_simpleEng_isCutoff",   _engNum,  true, true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_throttlePct", _engNum, 0.0,  true] call fza_fnc_setArrayVariable;
    };
};

if (_state == "IDLE") then {
    [_heli, _engPwrLeverAnimName, 0.25] call fza_fnc_animSetValue;
    [_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state, true] call fza_fnc_setArrayVariable;
    
    if (_flightModel == "HeliSim") then {
        [_heli, "fza_sfmplus_simpleEng_isCutoff", _engNum,    false, true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_throttlePct", _engNum, 0.0,   true]  call fza_fnc_setArrayVariable;
    };
};

if (_state == "FLY") then {
    //0.063 sets the power levers to fly in 16 seconds
    [_heli, _engPwrLeverAnimName, 1, 0.25] call fza_fnc_animSetValue;
    [_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state, true] call fza_fnc_setArrayVariable;
    
    if (_flightModel == "HeliSim") then {
        [_heli, "fza_sfmplus_simpleEng_isCutoff", _engNum,    false, true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_throttlePct", _engNum, 1.0,   true] call fza_fnc_setArrayVariable;
    };
};
