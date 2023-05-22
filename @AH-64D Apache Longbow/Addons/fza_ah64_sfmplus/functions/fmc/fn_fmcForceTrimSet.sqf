params ["_heli"];

//Cyclic pitch trim
private _curCyclicFwdAft  = fza_sfmplus_cyclicFwdAft;
private _prevCyclicFwdAft = _heli getVariable "fza_ah64_forceTrimPosPitch";
_heli setVariable ["fza_ah64_forceTrimPosPitch", _curCyclicFwdAft + _prevCyclicFwdAft, true];
//Cyclic roll trim
private _curCyclicLeftRight  = fza_sfmplus_cyclicLeftRight;
private _prevCyclicLeftRight = _heli getVariable "fza_ah64_forceTrimPosRoll";
_heli setVariable ["fza_ah64_forceTrimPosRoll",  _curCyclicLeftRight + _prevCyclicLeftRight, true];
//Pedal trim
private _curPedalLeftRight  = fza_sfmplus_pedalLeftRight;
private _prevPedalLeftRight = _heli getVariable "fza_ah64_forceTrimPosPedal";
_heli setVariable ["fza_ah64_forceTrimPosPedal", _curPedalLeftRight + _prevPedalLeftRight, true];