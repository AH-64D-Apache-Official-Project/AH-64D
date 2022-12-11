params ["_heli", "_deltaTime"];

private _collectiveVal      = _heli getVariable "bmk_helisim_collectiveVal";
private _cyclicPitchVal     = 0.0;//_heli getVariable "bmk_helisim_cyclicPitchVal";
private _cyclicPitchTrimVal = _heli getVariable ["bmk_helisim_cyclicPitchTrimVal", 0.0];

private _cyclicRollVal      = 0.0;//_heli getVariable "bmk_helisim_cyclicRollVal";
private _cyclicRollTrimVal  = _heli getVariable ["bmk_helisim_cyclicRollTrimVal", 0.0];

//Keyboard collective
private _keyCollectiveUp = inputAction "HeliCollectiveRaise";
private _keyCollectiveDn = inputAction "HeliCollectiveLower";

if (bmk_helisim_keyboardOnly) then {
    if (_keyCollectiveUp > 0.1) then { _collectiveVal = _collectiveVal + ((1.0 / 3.0) * _deltaTime); };
    if (_keyCollectiveDn > 0.1) then { _collectiveVal = _collectiveVal - ((1.0 / 3.0) * _deltaTime); };
    _collectiveVal = [_collectiveVal, 0.0, 1.0] call bis_fnc_clamp;
};

//HOTAS collective
private _joyCollectiveUp = inputAction "HeliCollectiveRaiseCont";
private _joyCollectiveDn = inputAction "HeliCollectiveLowerCont";

if (!bmk_helisim_keyboardOnly) then {
    _collectiveVal = _joyCollectiveUp - _joyCollectiveDn;
    _collectiveVal = [_collectiveVal, -1.0, 1.0] call BIS_fnc_clamp;
    _collectiveVal = linearConversion[ -1.0, 1.0, _collectiveVal, 0.0, 1.0];
};
_heli setVariable ["bmk_helisim_collectiveVal", _collectiveVal];

//Cyclic
private _joyCyclicForward  = inputAction "HeliCyclicForward";
private _joyCyclicBackward = inputAction "HeliCyclicBack";

if (inputAction "fza_ah64_forceTrimSwitchUp" == 0) then {   
    _cyclicPitchVal = (_joyCyclicForward - _joyCyclicBackward) + _cyclicPitchTrimVal;
    _cyclicPitchVal = [_cyclicPitchVal, -1.0, 1.0] call BIS_fnc_clamp;
} else {
    _cyclicPitchVal = (_joyCyclicForward - _joyCyclicBackward);
    _cyclicPitchVal = [_cyclicPitchVal, -1.0, 1.0] call BIS_fnc_clamp;
    _heli setVariable ["bmk_helisim_cyclicPitchTrimVal", _cyclicPitchVal];
};

_cyclicPitchTrimVal = [_cyclicPitchTrimVal, -1.0, 1.0] call BIS_fnc_clamp;

private _joyCyclicLeft     = inputAction "HeliCyclicLeft";
private _joyCyclicRight    = inputAction "HeliCyclicRight";

if (inputAction "fza_ah64_forceTrimSwitchUp" == 0) then {    
    _cyclicRollVal = (_joyCyclicRight - _joyCyclicLeft) + _cyclicRollTrimVal;
    _cyclicRollVal = [_cyclicRollVal, -1.0, 1.0] call BIS_fnc_clamp;
} else {
    _cyclicRollVal = (_joyCyclicRight - _joyCyclicLeft);
    _cyclicRollVal = [_cyclicRollVal, -1.0, 1.0] call BIS_fnc_clamp;
    _heli setVariable ["bmk_helisim_cyclicRollTrimVal",  _cyclicRollVal];
};

//Pedals
private _pedalLeft  = inputAction "HeliRudderLeft";
private _pedalRight = inputAction "HeliRudderRight";

private _pedalVal   = _pedalRight - _pedalLeft;

//Throttle
private _engineThrottleVal = [ _heli getVariable "bmk_helisim_engThrottleSetPoint" select 0, 
                               _heli getVariable "bmk_helisim_engThrottleSetPoint" select 1];

//systemChat format ["Pitch: %1 Trim: %2 -- Roll: %3 Trim %4", _cyclicPitchVal, _cyclicPitchTrimVal, _cyclicRollVal, _cyclicRollTrimVal];
//systemChat format ["Pitch: %1 -- Roll: %2 -- Yaw: %3 -- Throttle: %4", _cyclicPitchVal, _cyclicRollVal, _pedalVal,_engineThrottleVal];

[_collectiveVal, _cyclicPitchVal, _cyclicRollVal, _pedalVal, _engineThrottleVal];