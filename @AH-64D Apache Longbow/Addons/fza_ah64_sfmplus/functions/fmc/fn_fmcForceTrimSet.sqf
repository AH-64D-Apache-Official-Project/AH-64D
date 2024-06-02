params ["_heli"];

//Cyclic pitch trim
private _curCyclicFwdAft  = fza_sfmplus_cyclicFwdAft;
private _prevCyclicFwdAft = _heli getVariable "fza_sfmplus_forceTrimPosPitch";
private _pitchTrimVal     = _curCyclicFwdAft + _prevCyclicFwdAft;
_pitchTrimVal             = [_pitchTrimVal, -1.0, 1.0] call BIS_fnc_clamp;
_heli setVariable ["fza_sfmplus_forceTrimPosPitch", _pitchTrimVal, true];
//Cyclic roll trim
private _curCyclicLeftRight  = fza_sfmplus_cyclicLeftRight;
private _prevCyclicLeftRight = _heli getVariable "fza_sfmplus_forceTrimPosRoll";
private _rollTrimVal         = _curCyclicLeftRight + _prevCyclicLeftRight;
_rollTrimVal                 = [_rollTrimVal, -1.0, 1.0] call BIS_fnc_clamp;
_heli setVariable ["fza_sfmplus_forceTrimPosRoll", _rollTrimVal, true];
//Pedal trim
private _curPedalLeftRight  = fza_sfmplus_pedalLeftRight;
private _prevPedalLeftRight = _heli getVariable "fza_sfmplus_forceTrimPosPedal";
private _pedalTrimVal       = _curPedalLeftRight + _prevPedalLeftRight;
_pedalTrimVal               = [_pedalTrimVal, -1.0, 1.0] call BIS_fnc_clamp;
_heli setVariable ["fza_sfmplus_forceTrimPosPedal", _pedalTrimVal, true];