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
params ["_heli", "_inputAxis", "_input", "_lagVal"];

private _output = 0.0;
switch (_inputAxis) do {
    case "pitch" : {
        private _prevLagInput  = _heli getVariable "fza_sfmplus_prevLagInputPitch";
        private _prevLagOutput = _heli getVariable "fza_sfmplus_prevLagOutputPitch";

        private _ca = [_lagVal] call fza_sfmplus_fnc_actuatorGetLagCoefA;
        private _cb = [_lagVal] call fza_sfmplus_fnc_actuatorGetLagCoefB;

        _output     = _ca * (_input + _prevLagInput) + _prevLagOutput * _cb;

        _heli setVariable ["fza_sfmplus_prevLagInputPitch",  _input];
        _heli setVariable ["fza_sfmplus_prevLagOutputPitch", _output];
    };
    case "roll" : {
        private _prevLagInput  = _heli getVariable "fza_sfmplus_prevLagInputRoll";
        private _prevLagOutput = _heli getVariable "fza_sfmplus_prevLagInputRoll";

        private _ca = [_lagVal] call fza_sfmplus_fnc_actuatorGetLagCoefA;
        private _cb = [_lagVal] call fza_sfmplus_fnc_actuatorGetLagCoefB;

        _output     = _ca * (_input + _prevLagInput) + _prevLagOutput * _cb;

        _heli setVariable ["fza_sfmplus_prevLagInputRoll", _input];
        _heli setVariable ["fza_sfmplus_prevLagInputRoll", _output];
    };
    case "yaw" : {
        private _prevLagInput  = _heli getVariable "fza_sfmplus_prevLagInputYaw";
        private _prevLagOutput = _heli getVariable "fza_sfmplus_prevLagInputYaw";

        private _ca = [_lagVal] call fza_sfmplus_fnc_actuatorGetLagCoefA;
        private _cb = [_lagVal] call fza_sfmplus_fnc_actuatorGetLagCoefB;

        _output     = _ca * (_input + _prevLagInput) + _prevLagOutput * _cb;

        _heli setVariable ["fza_sfmplus_prevLagInputYaw", _input];
        _heli setVariable ["fza_sfmplus_prevLagInputYaw", _output];
    };
};

_output;