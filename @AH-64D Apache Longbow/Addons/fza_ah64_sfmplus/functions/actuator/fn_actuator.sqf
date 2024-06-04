/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engine

Description:
    Sourced from JSBSim.

Parameters:
    ...

Returns:
    Lag coeffient required for actuator simulation.

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime", "_inputAxis", "_input", "_lagVal"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _priHydPumpDamage  = _heli getHitPointDamage "hit_hyd_pripump";
private _output            = 0.0;

//If the FMC or Primary Hydraulics are working, then there is no input lag, however, if the
//FMC or Primary hydraulics are NOT working, then there is input lag.
switch (_inputAxis) do {
    case "pitch" : {
        if (_priHydPumpDamage < SYS_HYD_DMG_THRESH && _heli getVariable "fza_sfmplus_fmcPitchOn") then {
            _output = _input;
        } else {
            _output = [_heli, _deltaTime, _inputAxis, _input, _lagVal] call fza_sfmplus_fnc_actuatorLag;
        };
    };
    case "roll" : {
        if (_priHydPumpDamage < SYS_HYD_DMG_THRESH && _heli getVariable "fza_sfmplus_fmcPitchOn") then {
            _output = _input;
        } else {
            _output = [_heli, _deltaTime, _inputAxis, _input, _lagVal] call fza_sfmplus_fnc_actuatorLag;
        };
    };
    case "yaw" : {
        if (_priHydPumpDamage < SYS_HYD_DMG_THRESH && _heli getVariable "fza_sfmplus_fmcYawOn") then {
            _output = _input;
        } else {
            _output = [_heli, _deltaTime, _inputAxis, _input, _lagVal] call fza_sfmplus_fnc_actuatorLag;
        };
    };
};

_output;