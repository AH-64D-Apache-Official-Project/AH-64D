params ["_heli", "_deltaTime", "_engNum", "_engInput", "_altitude", "_temperature", "_controlInputs"];

private _engState        = _heli getVariable "bmk_helisim_engState" select _engNum;
private _maxTorqueScalar = 1.31;

switch (_engState) do {
    case "OFF": {
        [_heli, _engNum, _deltaTime, _engInput, _maxTorqueScalar, _controlInputs] call bmk_helisim_fnc_simpleEngineStateOff;
    };
    case "STARTING": {
        [_heli, _engNum, _deltaTime, _engInput, _maxTorqueScalar, _controlInputs] call bmk_helisim_fnc_simpleEngineStateStart;
    };
    case "ON" : {
        [_heli, _engNum, _deltaTime, _engInput, _maxTorqueScalar, _controlInputs] call bmk_helisim_fnc_simpleEngineStateOn;
    };
};