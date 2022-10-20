params ["_heli", "_deltaTime"];

private _collectiveVal = _heli getVariable "bmk_helisim_collectiveVal";

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

private _cyclicPitchVal = _heli animationSourcePhase "cyclicForward";
_cyclicPitchVal = [_cyclicPitchVal, -0.5, 0.5] call BIS_fnc_clamp;
_cyclicPitchVal = linearConversion[-0.5, 0.5, _cyclicPitchVal, -1.0, 1.0];

private _cyclicRollVal  = _heli animationSourcePhase "cyclicAside";
_cyclicRollVal  = [_cyclicRollVal, -0.5, 0.5] call BIS_fnc_clamp;
_cyclicRollVal  = linearConversion[-0.5, 0.5, _cyclicRollVal, -1.0, 1.0];

[_collectiveVal, _cyclicPitchVal, _cyclicRollVal];