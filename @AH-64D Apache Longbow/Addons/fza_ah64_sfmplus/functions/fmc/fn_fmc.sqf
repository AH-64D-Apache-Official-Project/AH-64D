params ["_heli", "_deltaTime"];

private _attHoldCycPitchOut = 0.0;
private _attHoldCycRollOut  = 0.0;

private _hdgHoldPedalYawOut = 0.0;

private _altHoldCollOut = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcAltitudeHold;

[_attHoldCycPitchOut, _attHoldCycRollOut, _hdgHoldPedalYawOut, _altHoldCollOut];