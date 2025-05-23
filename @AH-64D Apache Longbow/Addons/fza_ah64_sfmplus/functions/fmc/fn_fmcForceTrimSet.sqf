params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

if (!(currentPilot _heli == player) || !(local _heli)) exitWith {};

//Cyclic pitch trim
private _curCyclicFwdAft  = (_heli getVariable "fza_sfmplus_cyclicFwdAft");
private _prevCyclicFwdAft = _heli getVariable "fza_ah64_forceTrimPosPitch";
private _pitchTrimVal     = _curCyclicFwdAft + _prevCyclicFwdAft;
_pitchTrimVal             = [_pitchTrimVal, -1.0, 1.0] call BIS_fnc_clamp;
if (fza_ah64_sfmPlusSpringlessCyclic || fza_ah64_sfmPlusKeyboardStickyPitch) then {
    _heli setVariable ["fza_ah64_forceTrimPosPitch", 0.0];
} else {
    _heli setVariable ["fza_ah64_forceTrimPosPitch", _pitchTrimVal, true];
};
//Cyclic roll trim
private _curCyclicLeftRight  = (_heli getVariable "fza_sfmplus_cyclicLeftRight");
private _prevCyclicLeftRight = _heli getVariable "fza_ah64_forceTrimPosRoll";
private _rollTrimVal         = _curCyclicLeftRight + _prevCyclicLeftRight;
_rollTrimVal                 = [_rollTrimVal, -1.0, 1.0] call BIS_fnc_clamp;
if (fza_ah64_sfmPlusSpringlessCyclic || fza_ah64_sfmPlusKeyboardStickyRoll) then {
    _heli setVariable ["fza_ah64_forceTrimPosRoll",  0.0];
} else {
    _heli setVariable ["fza_ah64_forceTrimPosRoll", _rollTrimVal, true];
};
//Pedal trim
private _curPedalLeftRight  = (_heli getVariable "fza_sfmplus_pedalLeftRight");
private _prevPedalLeftRight = _heli getVariable "fza_ah64_forceTrimPosPedal";
private _pedalTrimVal       = _curPedalLeftRight + _prevPedalLeftRight;
_pedalTrimVal               = [_pedalTrimVal, -1.0, 1.0] call BIS_fnc_clamp;
if (fza_ah64_sfmplusSpringlessPedals || fza_ah64_sfmPlusKeyboardStickyYaw) then {
    _heli setVariable ["fza_ah64_forceTrimPosPedal", 0.0];
} else {
    _heli setVariable ["fza_ah64_forceTrimPosPedal", _pedalTrimVal, true];
};