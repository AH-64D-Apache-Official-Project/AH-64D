params ["_heli"];

private _collectiveVal  = _heli animationSourcePhase "collective";
_collectiveVal  = [_collectiveVal, -1.0, 1.0] call BIS_fnc_clamp;
_collectiveVal  = linearConversion[ -1.0, 1.0, _collectiveVal, 0.0, 1.0];

private _cyclicPitchVal = _heli animationSourcePhase "cyclicForward";
_cyclicPitchVal = [_cyclicPitchVal, -0.5, 0.5] call BIS_fnc_clamp;
_cyclicPitchVal = linearConversion[-0.5, 0.5, _cyclicPitchVal, -1.0, 1.0];

private _cyclicRollVal  = _heli animationSourcePhase "cyclicAside";
_cyclicRollVal  = [_cyclicRollVal, -0.5, 0.5] call BIS_fnc_clamp;
_cyclicRollVal  = linearConversion[-0.5, 0.5, _cyclicRollVal, -1.0, 1.0];

[_collectiveVal, _cyclicPitchVal, _cyclicRollVal];